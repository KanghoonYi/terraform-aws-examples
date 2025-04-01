data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  esbuild_src   = "./.esbuild"
  function_name = "${var.lambda_handler_name}-${var.stage}"
  default_env = {
    STAGE = var.stage
  }
  combined_env = merge(local.default_env, var.environment_variables)
}


resource "terraform_data" "build_app" {
  triggers_replace = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "rm -rf ${local.esbuild_src} && export PATH=$PATH:${path.cwd}/node_modules/.bin && npm run build:prod"
  }
}

resource "null_resource" "sam_metadata_aws_lambda_function" {
  count = 1

  provisioner "local-exec" {
    command = "rm -rf ${local.esbuild_src} && export PATH=$PATH:${path.cwd}/node_modules/.bin && npm run build:prod"
  }

  triggers = {
    # This is a way to let SAM CLI correlates between the Lambda function resource, and this metadata
    # resource
    resource_name = "module.APIGatewayLambdaHandler.aws_lambda_function.this[0]"
    resource_type = "ZIP_LAMBDA_FUNCTION"

    # The Lambda function source code.
    # original_source_code = jsonencode(var.source_path)
    original_source_code = local.esbuild_src

    # a property to let SAM CLI knows where to find the Lambda function source code if the provided
    # value for original_source_code attribute is map.
    # source_code_property = "path"

    # A property to let SAM CLI knows where to find the Lambda function built output
    built_output_path = "${local.esbuild_src}/${module.APIGatewayLambdaHandler.local_filename == null ? "" : module.APIGatewayLambdaHandler.local_filename == null}"
  }

  # SAM CLI can run terraform apply -target metadata resource, and this will apply the building
  # resources as well
  depends_on = [terraform_data.build_app, module.APIGatewayLambdaHandler]
}

module "APIGatewayLambdaHandler" {
  source        = "terraform-aws-modules/lambda/aws"
  architectures = ["arm64"]
  timeout       = 15

  function_name       = local.function_name
  description         = var.lambda_description
  handler             = var.handler_src
  runtime             = "nodejs22.x"
  memory_size         = 256
  publish             = true
  create_function     = true
  create_package      = true
  create_role         = false
  create_sam_metadata = false

  source_path = [
    {
      path = local.esbuild_src
      commands = [
        "npm install --production",
        ":zip"
      ],
      patterns : [
        "node_modules/.+",
        "!node_modules/@aws-sdk/.*",
      ]
    }
  ]

  store_on_s3 = true
  s3_bucket   = var.source_code_bucket_name

  environment_variables = local.combined_env == null ? {} : local.combined_env

  lambda_role = var.lambda_role_arn

  event_source_mapping = {
  }

  tracing_mode          = "Active"
  attach_network_policy = true
  attach_tracing_policy = true

  logging_log_group                 = "/aws/lambda/${local.function_name}"
  cloudwatch_logs_retention_in_days = var.log_ttl_days

  depends_on = [
    terraform_data.build_app,
  ]
}


# Proxy Resource (/{proxy+})
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = var.agw_rest_api_id
  parent_id   = var.agw_parent_resource_id
  path_part   = var.agw_http_path
}

# Method (ANY)
resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = var.agw_rest_api_id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = var.agw_http_method
  authorization = "NONE"
}

# Integration with Lambda
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = var.agw_rest_api_id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.APIGatewayLambdaHandler.lambda_function_invoke_arn
}

# Lambda Permission for API Gateway
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.APIGatewayLambdaHandler.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.agw_execution_arn}/*/*"
}

terraform {
  backend "s3" {
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_role" "lambda_role" {
  name = "APIGatewayLambdaRole-${var.stage}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lambda_basic_exec_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# Policy for Trace
resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "APIGatewayLambdaBasePolicy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:Get*",
        ],
        "Resource" : "*"
      },
      {
        Effect : "Allow",
        Action : [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
          "xray:GetSamplingStatisticSummaries",
        ],
        Resource : ["*"],
      },
    ]
  })
}

# API Gateway
resource "aws_api_gateway_rest_api" "apigateway_rest_api" {
  name        = "APIGateway-${var.stage}"
  description = "REST API connected to Lambda"
}

# Deployment & Stage
resource "aws_api_gateway_deployment" "deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigateway_rest_api.id
  stage_name = var.stage
  depends_on = [
    module.get_hello,
  ]
}


# Endpoints
module "get_hello" {
  source = "./tfModules/APIGatewayHandler"
  stage = var.stage

  agw_rest_api_id = aws_api_gateway_rest_api.apigateway_rest_api.id
  agw_execution_arn = aws_api_gateway_rest_api.apigateway_rest_api.execution_arn
  agw_parent_resource_id = aws_api_gateway_rest_api.apigateway_rest_api.root_resource_id
  agw_http_method = "GET"
  agw_http_path = "hello"


  lambda_role_arn        = aws_iam_role.lambda_role.arn
  lambda_handler_name    = "APIGatewayGetHello"
  handler_src            = "src/functions/getHello/handler.main"
  environment_variables = var.lambda_environment_variables
  source_code_bucket_name = var.source_code_bucket_name

  depends_on = [
    aws_iam_role.lambda_role
  ]
}
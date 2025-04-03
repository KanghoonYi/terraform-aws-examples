output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = try(module.APIGatewayLambdaHandler.lambda_function_arn, "")
}

variable "stage" {
  type = string
  default = "dev"
  validation {
    condition     = can(regex("^(dev|staging|prod)$", var.stage))
    error_message = "Invalid 'stage' variable"
  }
}

variable "lambda_environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {
    STAGE = "dev"
  }
}

variable "source_code_bucket_name" {
  type    = string
  default = "tf-lambda-source-dev"
}
variable "instance_type" {
  type        = string                     # The type of the variable, in this case a string
  default     = "t2.micro"                 # Default value for the variable
  description = "The type of EC2 instance" # Description of what this variable represents
}

variable "stage" {
  type = string
  validation {
    condition     = can(regex("^(dev|staging|prod)$", var.stage))
    error_message = "Invalid 'stage' variable"
  }
}

variable "agw_rest_api_id" {
  type = string
}

variable "agw_parent_resource_id" {
  type = string
}

variable "agw_execution_arn" {
  type = string
}

variable "agw_http_path" {
  type = string
}

variable "agw_http_method" {
  type = string
  validation {
    condition     = can(regex("^(GET|POST|PATCH|DELETE)$", var.agw_http_method))
    error_message = "Invalid 'agw_http_method' variable"
  }
}

variable "lambda_handler_name" {
  type = string
}

variable "lambda_description" {
  type    = string
  default = ""
}

variable "handler_src" {
  type = string
}

variable "lambda_role_arn" {
  type = string
}

variable "log_ttl_days" {
  type    = number
  default = 30
}

variable "source_code_bucket_name" {
  type    = string
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  nullable = true
}
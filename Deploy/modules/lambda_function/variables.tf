variable "function_name" {
  type        = string
  description = "Name of the Lambda function."
}

variable "rendered_source" {
  type        = string
  description = "The contents of the rendered file."
}

variable "role_arn" {
  type        = string
  description = "The ARN of the role the lambda function will assume."
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key for the CloudWatch logs."
}

variable "project" {
  type        = string
  description = "The name of the project."
}

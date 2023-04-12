variable "source_path" {
  type        = string
  description = "The path that includes the source file."
}

variable "source_file" {
  type        = string
  description = "The source file for the lambda function."
}

variable "instance_id" {
  type        = string
  description = "Instance ID of the server instance."
}

variable "region" {
  type        = string
  description = "Region of the instance server."
}

variable "role_arn" {
  type        = string
  description = "The ARN of the role the lambda function will assume."
}

variable "api_execution_arn" {
  type        = string
  description = "Exectuion ARN of the API."
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key for the CloudWatch logs."
}

variable "project" {
  type        = string
  description = "The name of the project."
}

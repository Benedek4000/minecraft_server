variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket."
}

variable "cloudfront_origin_access_identity_arn" {
  type        = string
  description = "ARN of the cloudfront origin access identity to have access to the S3 bucket."
}

variable "file_source" {
  type        = string
  description = "Source path of the files to upload to the S3 bucket."
}

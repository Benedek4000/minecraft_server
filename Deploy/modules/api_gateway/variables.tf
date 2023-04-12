variable "api_name" {
  type        = string
  description = "Name of the API."
}

variable "api_description" {
  type        = string
  description = "Description of the API."
}

variable "domain_name" {
  type        = string
  description = "Domain name of the API."
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the domain name certificate."
}

variable "start_function" {
  type        = string
  description = "Invoke ARN of the start function."
}

variable "stop_function" {
  type        = string
  description = "Invoke ARN of the stop function."
}

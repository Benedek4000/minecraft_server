variable "role_name" {
  type        = string
  description = "Name of the role to be created."
}

variable "principal_type" {
  type        = string
  description = "AssumeRole principal type."
}

variable "principal_identifiers" {
  type        = list(string)
  description = "AssumeRole principal identifiers."
}

variable "predefined_policies" {
  type        = set(string)
  description = "Set of the predefined AWS policies to be included in the role."
}


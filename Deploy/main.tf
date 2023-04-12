variable "project" {}
variable "region" {}
variable "az" {}
variable "server_file_source" {}
variable "lambda_file_source" {}
variable "api_domain_tag" {}
variable "minecraft_domain_tag" {}
variable "zone_name" {}
variable "cidr_vpc" {}
variable "cidr_anyone" {}
variable "port_ssh" {}
variable "port_http" {}
variable "port_https" {}
variable "port_server" {}
variable "port_server_status" {}
variable "lambda_role_predefined_policies" {}
variable "ec2_role_predefined_policies" {}
variable "instance_type" {}
variable "stop_hour" {}

locals {
  defaultTags = {
    project = var.project
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = local.defaultTags
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "northVirginia"

  default_tags {
    tags = local.defaultTags
  }
}

data "local_sensitive_file" "public_key" {
  filename = "${path.cwd}/../minecraft_server.pub"
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.project
  public_key = data.local_sensitive_file.public_key.content
}

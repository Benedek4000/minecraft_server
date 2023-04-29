variable "project" {}
variable "region" {}
variable "az" {}
variable "website_file_source" {}
variable "server_file_source" {}
variable "lambda_file_source" {}
variable "control_website_domain_tag" {}
variable "api_domain_tag" {}
variable "minecraft_domain_tag" {}
variable "zone_name" {}
variable "enable_waf" {}
variable "cidr_vpc" {}
variable "cidr_anyone" {}
variable "port_ssh" {}
variable "port_http" {}
variable "port_https" {}
variable "port_server" {}
variable "port_rcon" {}
variable "lambda_role_predefined_policies" {}
variable "ec2_role_predefined_policies" {}
variable "instance_type" {}

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

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
variable "apiFile" {}
variable "logFormatFile" {}
variable "server_file_path" {}
variable "apiGatewayStageName" {}
variable "instance_type" {}
variable "sgData" {
  type = object({
    portSsh    = number
    portHttp   = number
    portHttps  = number
    portServer = number
    portRcon   = number
    cidrVpc    = list(string)
    cidrAnyone = list(string)
  })
}
variable "securityGroups" {}


locals {
  defaultTags = {
    project = var.project
  }

  portMapping = {
    portSsh    = var.sgData.portSsh
    portHttp   = var.sgData.portHttp
    portHttps  = var.sgData.portHttps
    portServer = var.sgData.portServer
    portRcon   = var.sgData.portRcon
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

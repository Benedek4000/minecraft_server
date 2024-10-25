variable "project" {}
variable "region" {}
variable "az" {}
variable "website_file_source" {}
variable "server_file_source" {}
variable "lambda_file_source" {}
variable "misc_file_source" {}
variable "build_file_source" {}
variable "versions" {}
variable "zone_name" {}
variable "mc_version" {}
variable "subnet_number" {}
variable "vpc" {}
variable "ig" {}
variable "server_name" {}
variable "instance_type" {}
variable "server_properties" {}
variable "files_bucket_id" {}
variable "modding" {}

locals {
  control_domain_tag   = "control."
  api_domain_tag       = "api."
  minecraft_domain_tag = "${var.server_name}.minecraft."

  portMapping = {
    portSsh    = 22
    portHttp   = 80
    portHttps  = 443
    portServer = 25565
    portRcon   = 25575
  }

  cidrBlocks = {
    cidrAnyone = ["0.0.0.0/0"],
    sshIps     = [for k, v in data.aws_ec2_managed_prefix_list.sshIps.entries : v.cidr]
  }

  default_server_properties = {
    seed        = ""
    gamemode    = "survival"
    motd        = "'A Minecraft Server'"
    difficulty  = "normal"
    online_mode = "true"
    hardcore    = "false"
    level_type  = "minecraft\\:normal"
  }
}

data "aws_ec2_managed_prefix_list" "sshIps" {
  name = "com.amazonaws.${var.region}.ec2-instance-connect"
}

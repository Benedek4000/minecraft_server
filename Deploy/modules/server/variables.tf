variable "project" {}
variable "region" {}
variable "az" {}
variable "website_file_source" {}
variable "server_file_source" {}
variable "lambda_file_source" {}
variable "misc_file_source" {}
variable "build_file_source" {}
variable "versions" {}
variable "key_name" {}
variable "zone_name" {}
variable "mc_version" {}
variable "vpc_number" {}
variable "server_name" {}
variable "instance_type" {}
variable "server_properties" {}

locals {
  control_domain_tag   = "control."
  api_domain_tag       = "api."
  minecraft_domain_tag = "${var.server_name}."

  portMapping = {
    portSsh    = 22
    portHttp   = 80
    portHttps  = 443
    portServer = 25565
    portRcon   = 25575
  }

  cidrBlocks = {
    cidrAnyone = ["0.0.0.0/0"]
  }

  default_server_properties = {
    seed        = ""
    gamemode    = "survival"
    motd        = "A Minecraft Server"
    difficulty  = "normal"
    online_mode = "true"
    hardcore    = "false"
    level_type  = "minecraft\\:normal"
  }

  versions = merge(var.versions, { "latest" = var.versions[element(sort(keys(var.versions)), length(keys(var.versions)) - 1)] })
}

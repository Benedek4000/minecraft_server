variable "project" {}
variable "region" {}
variable "default_az" {}
variable "zone_name" {}
variable "default_server_file_path" {}
variable "default_instance_type" {}
variable "servers" {}
variable "versions" {}


locals {
  defaultTags = {
    project = var.project
  }

  website_file_source = "${path.root}/../Projects/website"
  server_file_source  = "${path.root}/../Projects/server_files"
  lambda_file_source  = "${path.root}/../Projects/lambda_functions"
  misc_file_source    = "${path.root}/../Projects/misc_files"
  build_file_source   = "${path.root}/../Projects/build_files"
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

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.project}"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
}

module "minecraft-servers" {
  providers = {
    aws               = aws
    aws.northVirginia = aws.northVirginia
  }

  source   = "./modules/server"
  for_each = { for k, v in var.servers : k => v }

  project             = var.project
  region              = var.region
  az                  = try(each.value.az, var.default_az)
  website_file_source = local.website_file_source
  server_file_source  = local.server_file_source
  lambda_file_source  = local.lambda_file_source
  misc_file_source    = local.misc_file_source
  build_file_source   = local.build_file_source
  mc_version          = try(each.value.version, "latest")
  versions            = var.versions
  key_name            = aws_key_pair.key_pair.key_name
  server_name         = each.key
  vpc                 = aws_vpc.vpc
  ig                  = aws_internet_gateway.ig
  subnet_number       = each.value.subnet_number
  zone_name           = var.zone_name
  instance_type       = try(each.value.instance_type, var.default_instance_type)
  server_properties   = try(each.value.server_properties, null)
}

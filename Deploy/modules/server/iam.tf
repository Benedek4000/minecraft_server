locals {
  lambdaRolePolicies = [
    "AmazonEC2FullAccess",
    "AmazonSSMFullAccess",
    "AmazonRoute53FullAccess",
  ]
  ec2RolePolicies = [
    "AmazonSSMFullAccess",
    "AmazonS3FullAccess",
    "CloudWatchAgentServerPolicy",
  ]
}

module "lambda-role" {
  source = "git::https://github.com/Benedek4000/terraform-aws-role.git//module?ref=1.0.1"

  roleName             = "${var.project}-${var.server_name}-lambda-role"
  principalType        = "Service"
  principalIdentifiers = ["lambda.amazonaws.com"]
  policies             = local.lambdaRolePolicies
}

module "ec2-role" {
  source = "git::https://github.com/Benedek4000/terraform-aws-role.git//module?ref=1.0.1"

  roleName             = "${var.project}-${var.server_name}-ec2-role"
  principalType        = "Service"
  principalIdentifiers = ["ec2.amazonaws.com"]
  policies             = local.ec2RolePolicies
}

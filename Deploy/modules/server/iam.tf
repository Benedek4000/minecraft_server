locals {
  lambdaRolePredefinedPolicies = [
    "AmazonEC2FullAccess",
    "AmazonSSMFullAccess"
  ]
  ec2RolePredefinedPolicies = [
    "AmazonSSMFullAccess",
    "AmazonS3FullAccess"
  ]
}

module "lambda-role" {
  source = "../role"

  roleName             = "${var.project}-${var.server_name}-lambda-role"
  principalType        = "Service"
  principalIdentifiers = ["lambda.amazonaws.com"]
  predefinedPolicies   = local.lambdaRolePredefinedPolicies
}

module "ec2-role" {
  source = "../role"

  roleName             = "${var.project}-${var.server_name}-ec2-role"
  principalType        = "Service"
  principalIdentifiers = ["ec2.amazonaws.com"]
  predefinedPolicies   = local.ec2RolePredefinedPolicies
}

locals {
  apigatewayRolePredefinedPolicies = [
    "AmazonAPIGatewayPushToCloudWatchLogs",
  ]
  lambdaRolePredefinedPolicies = [
    "AmazonEC2FullAccess",
    "AmazonSSMFullAccess"
  ]
  ec2RolePredefinedPolicies = [
    "AmazonSSMFullAccess",
    "AmazonS3FullAccess"
  ]
}

module "apigatewayRole" {
  source = "./modules/role"

  roleName             = "${var.project}-apigateway-role"
  principalType        = "Service"
  principalIdentifiers = ["apigateway.amazonaws.com"]
  predefinedPolicies   = local.apigatewayRolePredefinedPolicies
}

module "lambda-role" {
  source = "./modules/role"

  roleName             = "${var.project}-lambda-role"
  principalType        = "Service"
  principalIdentifiers = ["lambda.amazonaws.com"]
  predefinedPolicies   = local.lambdaRolePredefinedPolicies
}

module "ec2-role" {
  source = "./modules/role"

  roleName             = "${var.project}-ec2-role"
  principalType        = "Service"
  principalIdentifiers = ["ec2.amazonaws.com"]
  predefinedPolicies   = local.ec2RolePredefinedPolicies
}

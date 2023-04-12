module "lambda-role" {
  source = "./modules/role"

  role_name             = "${var.project}-lambda-role"
  principal_type        = "Service"
  principal_identifiers = ["lambda.amazonaws.com"]
  predefined_policies   = var.lambda_role_predefined_policies
}

module "ec2-role" {
  source = "./modules/role"

  role_name             = "${var.project}-ec2-role"
  principal_type        = "Service"
  principal_identifiers = ["ec2.amazonaws.com"]
  predefined_policies   = var.ec2_role_predefined_policies
}

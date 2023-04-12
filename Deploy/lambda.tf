module "lambda_functions" {
  source = "./modules/lambda_function"

  for_each = toset(fileset("${path.root}/${var.lambda_file_source}", "**.*"))

  source_path       = "${path.root}/${var.lambda_file_source}"
  source_file       = each.value
  instance_id       = aws_instance.server.id
  region            = var.region
  role_arn          = module.lambda-role.role_arn
  kms_key_arn       = aws_kms_key.lambda-logs.arn
  api_execution_arn = module.api_gateway.execution_arn
  project           = var.project
}

resource "aws_kms_key" "lambda-logs" {
  description             = "${var.project}-lambda-log-key"
  deletion_window_in_days = 10
}

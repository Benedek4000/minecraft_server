module "lambda_functions" {
  source = "./modules/lambda_function"

  for_each = toset(fileset("${path.root}/${var.lambda_file_source}", "**.*"))

  source_path       = "${path.root}/${var.lambda_file_source}"
  source_file       = each.value
  role_arn          = module.lambda-role.role_arn
  kms_key_arn       = aws_kms_key.lambda-logs.arn
  api_execution_arn = aws_api_gateway_rest_api.api.execution_arn
  project           = var.project

  instance_id = aws_instance.server.id
  region      = var.region

  stop_schedule_arn = aws_cloudwatch_event_rule.trigger_lambda_stop.arn
}

resource "aws_kms_key" "lambda-logs" {
  description             = "${var.project}-lambda-log-key"
  deletion_window_in_days = 10
}

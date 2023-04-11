data "template_file" "start_function" {
  template = file("./lambda_functions/lambda_startServer.py")
  vars = {
    INSTANCE_ID = aws_instance.server.id
    REGION_NAME = var.region
  }
}

/* data "template_file" "stop_function" {
  template = file("./lambda_functions/lambda_stopServer.py")
  vars = {
    INSTANCE_ID = aws_instance.server.id
    REGION_NAME = var.region
  }
} */

module "start_function" {
  source = "./modules/lambda_function"

  function_name   = "start_function"
  rendered_source = data.template_file.start_function.rendered
  role_arn        = module.lambda-role.role_arn
  kms_key_arn     = aws_kms_key.lambda-logs.arn
  project         = var.project
}

output "start_url" {
  value = module.start_function.invoke_arn
}

/* module "stop_function" {
  source = "./modules/lambda_function"

  function_name   = "stop_function"
  rendered_source = data.template_file.stop_function.rendered
  role_arn        = module.lambda-role.role_arn
  kms_key_arn     = aws_kms_key.lambda-logs.arn
  project         = var.project
} */

resource "aws_kms_key" "lambda-logs" {
  description             = "${var.project}-lambda-log-key"
  deletion_window_in_days = 10
}

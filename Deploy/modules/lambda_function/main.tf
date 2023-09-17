terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

data "template_file" "data" {
  template = file("${var.source_path}/${var.source_file}")
  vars = {
    INSTANCE_ID = var.instance_id
    REGION_NAME = var.region
    ZONE_ID     = var.zone_id
    NAME_TAG    = var.name_tag
  }
}

data "archive_file" "lambda_archive" {
  type                    = "zip"
  source_content_filename = var.source_file
  source_content          = data.template_file.data.rendered
  output_path             = "${var.build_files}/${var.server_name}_${var.source_file}.zip"
}

resource "aws_lambda_function" "function" {
  filename      = data.archive_file.lambda_archive.output_path
  function_name = "${split(".", var.source_file)[0]}-${var.server_name}"
  role          = var.role_arn
  handler       = "${split(".", var.source_file)[0]}.handler"
  timeout       = 10

  source_code_hash = data.archive_file.lambda_archive.output_base64sha256

  runtime = "python3.9"
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_execution_arn}/*"
}

resource "aws_lambda_permission" "cloudwatch_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "events.amazonaws.com"

  source_arn = var.stop_schedule_arn
}

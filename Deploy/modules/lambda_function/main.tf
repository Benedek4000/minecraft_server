terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

resource "local_file" "rendered_template" {
  content  = var.rendered_source
  filename = "${path.module}/${var.function_name}.py"
}

data "archive_file" "lambda_archive" {
  type                    = "zip"
  source_content_filename = local_file.rendered_template.filename
  source_content          = local_file.rendered_template.content
  output_path             = "_${var.function_name}.zip"
}

resource "aws_lambda_function" "function" {
  filename      = data.archive_file.lambda_archive.output_path
  function_name = var.function_name
  role          = var.role_arn
  handler       = "${var.function_name}.handler"

  source_code_hash = data.archive_file.lambda_archive.output_base64sha256

  runtime = "python3.9"
}

/* resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_execution_arn}/*"
}
 */

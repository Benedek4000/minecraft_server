resource "aws_cloudwatch_log_group" "api" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}/${local.stageName}"
  retention_in_days = 7
}

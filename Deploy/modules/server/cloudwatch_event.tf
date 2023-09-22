resource "aws_cloudwatch_event_rule" "trigger_lambda_stop" {
  name                = "${var.project}-${var.server_name}-stop-server-trigger"
  description         = "Stop the ${var.server_name} Minecraft Server every day at 6am UTC"
  schedule_expression = "cron(55 5,17 * * ? *)"
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule  = aws_cloudwatch_event_rule.trigger_lambda_stop.name
  arn   = module.lambdaFunctions["stopServer"].function.arn
  input = jsonencode({ "message" : "Triggered by CloudWatch Event Rule" })
}

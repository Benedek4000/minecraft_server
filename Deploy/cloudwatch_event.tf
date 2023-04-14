resource "aws_cloudwatch_event_rule" "trigger_lambda_stop" {
  name                = "stop-server-trigger"
  description         = "Stop the Minecraft Server every day at 6am UTC"
  schedule_expression = "cron(55 ${var.stop_hour - 1} * * ? *)"
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule  = aws_cloudwatch_event_rule.trigger_lambda_stop.name
  arn   = module.lambda_functions["lambda_stopServer.py"].arn
  input = jsonencode({ "message" : "Triggered by CloudWatch Event Rule" })
}

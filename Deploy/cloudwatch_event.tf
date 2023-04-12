resource "aws_cloudwatch_event_rule" "trigger_lambda_stop" {
  name        = "stop-server-trigger"
  description = "Stop the Minecraft Server every day at 6am UTC"
  #schedule_expression = "cron(0 ${var.stop_hour} * * ? *)" # This expression triggers the event every day at 6am UTC
  schedule_expression = "cron(0 ${var.stop_hour} * * ? *)"
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule  = aws_cloudwatch_event_rule.trigger_lambda_stop.name
  arn   = module.lambda_functions["lambda_stopServer.py"].arn              # Replace this with the ARN of your Lambda function
  input = jsonencode({ "message" : "Triggered by CloudWatch Event Rule" }) # This is an example input to the Lambda function
}

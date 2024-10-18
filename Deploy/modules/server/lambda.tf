locals {
  lambdaConfig = {
    minecraftServerControl = {
      cloudwatchInvokeArns = [aws_cloudwatch_event_rule.trigger_lambda_stop.arn],
      environmentVariables = {
        INSTANCE_ID      = aws_instance.server.id,
        REGION           = var.region,
        ZONE_ID          = data.aws_route53_zone.zone.zone_id,
        NAME_TAG         = aws_route53_record.server.name,
        S3_BACKUP_TARGET = "s3://${module.s3_backup.bucket.id}",
      }
    }
  }
}

module "lambdaFunctions" {
  source = "git::https://github.com/Benedek4000/terraform-aws-lambda.git//module?ref=1.0.2"

  for_each               = { for k, v in local.lambdaConfig : k => v }
  functionName           = "${each.key}-${var.server_name}"
  sourcePath             = var.lambda_file_source
  buildFiles             = var.build_file_source
  runtime                = "python3.11"
  roleArn                = module.lambda-role.role.arn
  apiGatewayInvokeArns   = [aws_api_gateway_rest_api.api.execution_arn]
  cloudwatchInvokeArns   = each.value.cloudwatchInvokeArns
  environmentVariables   = each.value.environmentVariables
  overrideFunctionSource = each.key
}

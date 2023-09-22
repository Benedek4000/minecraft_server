locals {
  lambdaConfig = {
    startServer = {
      cloudwatchInvokeArns = [],
      environmentVariables = {
        INSTANCE_ID = aws_instance.server.id,
        REGION      = var.region,
        ZONE_ID     = data.aws_route53_zone.zone.zone_id,
        NAME_TAG    = aws_route53_record.server.name,
      }
    }
    stopServer = {
      cloudwatchInvokeArns = [aws_cloudwatch_event_rule.trigger_lambda_stop.arn],
      environmentVariables = {
        INSTANCE_ID = aws_instance.server.id,
        REGION      = var.region,
      }
    }
    getStatus = {
      cloudwatchInvokeArns = [],
      environmentVariables = {
        INSTANCE_ID = aws_instance.server.id,
        REGION      = var.region,
      }
    }
  }
}

module "lambdaFunctions" {
  source = "git::https://github.com/Benedek4000/terraform-aws-lambda.git?ref=1.0.0"

  for_each               = { for k, v in local.lambdaConfig : k => v }
  function_name          = "${each.key}-${var.server_name}"
  source_path            = var.lambda_file_source
  build_files            = var.build_file_source
  runtime                = "python3.11"
  role_arn               = module.lambda-role.role.arn
  apiGatewayInvokeArns   = [aws_api_gateway_rest_api.api.execution_arn]
  cloudwatchInvokeArns   = each.value.cloudwatchInvokeArns
  environmentVariables   = each.value.environmentVariables
  overrideFunctionSource = each.key
}

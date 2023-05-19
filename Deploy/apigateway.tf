locals {
  stageName = "prod"
}

data "template_file" "api" {
  template = file(var.apiFile)
  vars = {
    START_SERVER_LAMBDA = module.lambda_functions["lambda_startServer.py"].invoke_arn
    STOP_SERVER_LAMBDA  = module.lambda_functions["lambda_stopServer.py"].invoke_arn
    GET_STATUS_LAMBDA   = module.lambda_functions["lambda_getStatus.py"].invoke_arn
    WEBSITE_DOMAIN      = "https://${module.website_acm_certificate.certificate_domain_name}"
  }
}

data "template_file" "log_format" {
  template = file(var.logFormatFile)
}

resource "aws_api_gateway_rest_api" "api" {
  name = "${var.project}-control"
  body = data.template_file.api.rendered
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_domain_name" "api" {
  domain_name     = module.api_acm_certificate.certificate_domain_name
  certificate_arn = module.api_acm_certificate.certificate_arn
  security_policy = "TLS_1_2"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = local.stageName

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api.arn
    format          = replace(data.template_file.log_format.rendered, "/\\s+/", "")
  }

  variables = {
    apiSpecHash = sha1(data.template_file.api.rendered)
  }
}

resource "aws_api_gateway_method_settings" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled                            = true
    logging_level                              = "INFO"
    throttling_burst_limit                     = 100
    throttling_rate_limit                      = 50
    caching_enabled                            = false
    cache_ttl_in_seconds                       = 300
    cache_data_encrypted                       = true
    data_trace_enabled                         = false
    require_authorization_for_cache_control    = true
    unauthorized_cache_control_header_strategy = "SUCCEED_WITH_RESPONSE_HEADER"
  }
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(data.template_file.api.rendered)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api.stage_name
  domain_name = aws_api_gateway_domain_name.api.domain_name
}

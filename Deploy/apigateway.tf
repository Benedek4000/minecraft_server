data "template_file" "api" {
  template = file("api.json")
  vars = {
    START_SERVER_LAMBDA = module.lambda_functions["lambda_startServer.py"].invoke_arn
    STOP_SERVER_LAMBDA  = module.lambda_functions["lambda_stopServer.py"].invoke_arn
    GET_STATUS_LAMBDA   = module.lambda_functions["lambda_getStatus.py"].invoke_arn
    WEBSITE_DOMAIN      = "https://${module.website_acm_certificate.certificate_domain_name}"
  }
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
  stage_name    = "prod"
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api.stage_name
  domain_name = aws_api_gateway_domain_name.api.domain_name
}

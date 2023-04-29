module "api_gateway" {
  source = "./modules/api_gateway"

  api_name        = "${var.project}-control"
  api_description = "Minecraft Server Control API"
  domain_name     = module.api_acm_certificate.certificate_domain_name
  certificate_arn = module.api_acm_certificate.certificate_arn
  start_function  = module.lambda_functions["lambda_startServer.py"].invoke_arn
  stop_function   = module.lambda_functions["lambda_stopServer.py"].invoke_arn
  status_function = module.lambda_functions["lambda_getStatus.py"].invoke_arn
}

resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = module.api_gateway.api_id
  stage_name    = "prod"
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = module.api_gateway.api_id

  depends_on = [
    module.api_gateway
  ]
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = module.api_gateway.api_id
  stage_name  = aws_api_gateway_stage.api.stage_name
  domain_name = module.api_gateway.apigateway_domain_name
}

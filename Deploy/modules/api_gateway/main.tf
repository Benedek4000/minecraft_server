resource "aws_api_gateway_rest_api" "api" {
  name                         = var.api_name
  description                  = var.api_description
  disable_execute_api_endpoint = true
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_domain_name" "api" {
  domain_name              = var.domain_name
  regional_certificate_arn = var.certificate_arn
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "start" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "start"
}

resource "aws_api_gateway_method" "start" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.start.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "start" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.start.id
  http_method             = aws_api_gateway_method.start.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.start_function
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_method_response" "start" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.start.id
  http_method = aws_api_gateway_method.start.http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_method.start
  ]
}

resource "aws_api_gateway_integration_response" "start" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.start.id
  http_method = aws_api_gateway_method.start.http_method
  status_code = aws_api_gateway_method_response.start.status_code

  depends_on = [
    aws_api_gateway_integration.start
  ]
}

resource "aws_api_gateway_resource" "stop" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "stop"
}

resource "aws_api_gateway_method" "stop" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.stop.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "stop" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.stop.id
  http_method             = aws_api_gateway_method.stop.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.stop_function
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_method_response" "stop" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.stop.id
  http_method = aws_api_gateway_method.stop.http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_method.stop
  ]
}

resource "aws_api_gateway_integration_response" "stop" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.stop.id
  http_method = aws_api_gateway_method.stop.http_method
  status_code = aws_api_gateway_method_response.stop.status_code

  depends_on = [
    aws_api_gateway_integration.stop
  ]
}

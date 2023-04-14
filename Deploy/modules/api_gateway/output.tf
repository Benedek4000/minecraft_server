output "api_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.api.execution_arn
}

output "route53_zone_id" {
  value = aws_api_gateway_domain_name.api.cloudfront_zone_id
}

output "route53_domain_name" {
  value = aws_api_gateway_domain_name.api.cloudfront_domain_name
}

output "apigateway_domain_name" {
  value = aws_api_gateway_domain_name.api.domain_name
}

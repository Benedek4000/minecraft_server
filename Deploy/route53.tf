data "aws_route53_zone" "zone" {
  name = var.zone_name
}

resource "aws_route53_record" "website" {
  name    = module.website_acm_certificate.certificate_domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "server" {
  name    = "${var.minecraft_domain_tag}${var.zone_name}"
  type    = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl     = 300
  records = [aws_eip.server.public_ip]
}

resource "aws_route53_record" "control-server" {
  name    = module.api_acm_certificate.certificate_domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  alias {
    zone_id                = aws_api_gateway_domain_name.api.cloudfront_zone_id
    name                   = aws_api_gateway_domain_name.api.cloudfront_domain_name
    evaluate_target_health = false
  }
}

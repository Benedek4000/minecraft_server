data "aws_route53_zone" "zone" {
  name = var.zone_name
}

resource "aws_route53_record" "server" {
  name    = "${var.minecraft_domain_tag}${var.zone_name}"
  type    = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl     = 300
  records = [aws_eip.server.public_ip]
}

resource "aws_route53_record" "control-server" {
  name    = "${var.api_domain_tag}${var.minecraft_domain_tag}${var.zone_name}"
  type    = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  alias {
    zone_id                = module.api_gateway.route53_zone_id
    name                   = module.api_gateway.route53_domain_name
    evaluate_target_health = false
  }
}

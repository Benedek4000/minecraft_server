data "aws_route53_zone" "zone" {
  name = var.zone_name
}

resource "aws_route53_record" "server" {
  name    = "${var.domain_tag}${var.zone_name}"
  type    = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl     = 300
  records = [aws_eip.server.public_ip]
}

/* resource "aws_route53_record" "start-server" {
  name    = "start.${var.domain_tag}${var.zone_name}"
  type    = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl     = 300
  records = [module.start_function.invoke_arn]
} */

/* resource "aws_route53_record" "staop-server" {
  name    = "stop.${var.domain_tag}${var.zone_name}"
  type    = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl     = 300
  records = [module.stop_function.invoke_arn]
}
 */

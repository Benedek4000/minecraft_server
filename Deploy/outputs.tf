output "website_domain_name" {
  value = module.website_acm_certificate.certificate_domain_name
}

output "server_domain_name" {
  value = "${aws_route53_record.server.name}:${local.portMapping.portServer}"
}

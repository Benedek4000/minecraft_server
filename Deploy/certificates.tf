module "api_acm_certificate" {
  source = "./modules/acm_certificate"

  zone_name  = var.zone_name
  domain_tag = "${var.api_domain_tag}${var.minecraft_domain_tag}"
}

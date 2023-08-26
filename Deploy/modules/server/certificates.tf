module "website_acm_certificate" {
  source = "./modules/acm_certificate"

  providers = {
    aws = aws.northVirginia
  }
  zone_name  = var.zone_name
  domain_tag = "${local.control_domain_tag}${local.minecraft_domain_tag}"
}


module "api_acm_certificate" {
  source = "./modules/acm_certificate"

  providers = {
    aws = aws.northVirginia
  }

  zone_name  = var.zone_name
  domain_tag = "${local.api_domain_tag}${local.minecraft_domain_tag}"
}

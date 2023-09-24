module "website_acm_certificate" {
  source = "git::https://github.com/Benedek4000/terraform-aws-certificate.git//module?ref=1.0.2"

  providers = {
    aws = aws.northVirginia
  }
  zoneName  = var.zone_name
  domainTag = "${local.control_domain_tag}${local.minecraft_domain_tag}"
}


module "api_acm_certificate" {
  source = "git::https://github.com/Benedek4000/terraform-aws-certificate.git//module?ref=1.0.2"

  providers = {
    aws = aws.northVirginia
  }

  zoneName  = var.zone_name
  domainTag = "${local.api_domain_tag}${local.minecraft_domain_tag}"
}

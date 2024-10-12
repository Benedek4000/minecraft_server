output "server_info" {
  value = {
    server_name         = var.server_name
    website_domain_name = module.website_acm_certificate.certificate.domain_name
    server_domain_name  = "${aws_route53_record.server.name}:${local.portMapping.portServer}"
    gamemode            = try(var.server_properties.gamemode, local.default_server_properties.gamemode)
    hardcore            = try(var.server_properties.hardcore, local.default_server_properties.hardcore)
    online_mode         = try(var.server_properties.online_mode, local.default_server_properties.online_mode)
    version             = var.mc_version
    modding             = var.modding.mods
  }
}

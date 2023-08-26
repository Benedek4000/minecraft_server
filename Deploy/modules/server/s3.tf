module "s3_website" {
  source = "./modules/s3_static_website_bucket"

  bucket_name                           = "${var.project}-${var.server_name}-control"
  cloudfront_origin_access_identity_arn = aws_cloudfront_origin_access_identity.oai.iam_arn
  file_source                           = var.website_file_source
  build_files                           = var.build_file_source
  misc_file_source                      = var.misc_file_source
  server_name                           = var.server_name
  api_domain_tag                        = local.api_domain_tag
  zone_name                             = var.zone_name
}

module "s3_backup" {
  source = "./modules/s3_bucket"

  bucket_name           = "${var.project}-${var.server_name}-backup"
  principal_type        = "Service"
  principal_identifiers = ["ec2.amazonaws.com"]
}

module "s3_website" {
  source = "./modules/s3_static_website_bucket"

  bucket_name                           = "${var.project}-control"
  cloudfront_origin_access_identity_arn = aws_cloudfront_origin_access_identity.oai.iam_arn
  file_source                           = "${path.root}/${var.website_file_source}"
}

module "s3_backup" {
  source = "./modules/s3_bucket"

  bucket_name           = "${var.project}-backup"
  principal_type        = "Service"
  principal_identifiers = ["ec2.amazonaws.com"]
}

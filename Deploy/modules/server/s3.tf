locals {
  no_modification_files = toset(["favicon.ico", "index.html", "styles.css"])
}

data "local_file" "no_modification" {
  for_each = local.no_modification_files

  filename = "${var.website_file_source}/${each.value}"
}

resource "local_file" "no_modification" {
  for_each = local.no_modification_files

  filename = "${var.build_file_source}/${var.server_name}/${each.value}"
  content  = data.local_file.no_modification[each.value].content
}

data "template_file" "source_js" {
  template = file("${var.website_file_source}/source.js")
  vars = {
    SERVER_NAME    = var.server_name
    API_DOMAIN_TAG = local.api_domain_tag
    ZONE_NAME      = var.zone_name
  }
}

resource "local_file" "source_js" {
  filename = "${var.build_file_source}/${var.server_name}/source.js"
  content  = data.template_file.source_js.rendered
}

data "archive_file" "website_files" {
  type        = "zip"
  output_path = "${var.build_file_source}/${var.server_name}_website.zip"
  source_dir  = "${var.build_file_source}/${var.server_name}"

  depends_on = [
    local_file.no_modification,
    local_file.source_js,
  ]
}

resource "aws_s3_bucket_website_configuration" "web-conf" {
  bucket = module.s3_website.bucket_id
  index_document {
    suffix = "index.html"
  }
}

resource "null_resource" "website-upload" {
  provisioner "local-exec" {
    environment = {
      S3_SOURCE = "${var.build_file_source}/${var.server_name}"
      S3_TARGET = "s3://${module.s3_website.bucket_id}"
    }

    command = "bash ${var.misc_file_source}/upload_files.sh"
  }

  triggers = {
    value = data.archive_file.website_files.output_base64sha256
  }
}

module "s3_website" {
  source = "../s3_bucket"

  bucket_name           = "${var.project}-${var.server_name}-control"
  principal_type        = "AWS"
  principal_identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
  force_destroy         = true
}

module "s3_backup" {
  source = "../s3_bucket"

  bucket_name           = "${var.project}-${var.server_name}-backup"
  principal_type        = "Service"
  principal_identifiers = ["ec2.amazonaws.com"]
}

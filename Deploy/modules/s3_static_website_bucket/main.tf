terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

data "archive_file" "website_files" {
  type        = "zip"
  output_path = "../Projects/website_archive.zip"
  source_dir  = var.file_source
}

data "aws_iam_policy_document" "s3-read-only" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.cloudfront_origin_access_identity_arn]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    effect  = "Deny"
    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
  }
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3-read-only.json
}

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.bucket]
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "web-conf" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket-encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "null_resource" "website-upload" {
  provisioner "local-exec" {
    environment = {
      S3_SOURCE = var.file_source
      S3_TARGET = "s3://${aws_s3_bucket.bucket.id}"
    }

    command = "bash ./modules/s3_static_website_bucket/upload_files.sh"
  }

  triggers = {
    value = data.archive_file.website_files.output_base64sha256
  }
}

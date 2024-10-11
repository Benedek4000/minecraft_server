module "s3_server_files" {
  source = "git::https://github.com/Benedek4000/terraform-aws-bucket.git//module?ref=1.0.0"

  bucketName           = "${var.project}-files"
  principalType        = "Service"
  principalIdentifiers = ["ec2.amazonaws.com"]
  forceDestroy         = true
}

data "archive_file" "server_files" {
  type        = "zip"
  output_path = "${local.build_file_source}/server_files.zip"
  source_dir  = "${local.server_file_source}/"
}

resource "null_resource" "server-files-upload" {
  provisioner "local-exec" {
    environment = {
      S3_SOURCE = "${local.server_file_source}"
      S3_TARGET = "s3://${module.s3_server_files.bucket.id}"
    }

    command = "bash ${local.misc_file_source}/upload_files.sh"
  }

  triggers = {
    value = data.archive_file.server_files.output_base64sha256
  }
}

locals {
  envVars = {
    SEED                   = try(var.server_properties.seed, local.default_server_properties.seed)
    GAMEMODE               = try(var.server_properties.gamemode, local.default_server_properties.gamemode)
    MOTD                   = try(var.server_properties.motd, local.default_server_properties.motd)
    DIFFICULTY             = try(var.server_properties.difficulty, local.default_server_properties.difficulty)
    ONLINE_MODE            = try(var.server_properties.online_mode, local.default_server_properties.online_mode)
    HARDCORE               = try(var.server_properties.hardcore, local.default_server_properties.hardcore)
    LEVEL_TYPE             = try(var.server_properties.level_type, local.default_server_properties.level_type)
    VERSION                = var.mc_version
    SERVER_FILE_PATH       = var.versions[var.modding.client][var.mc_version]
    S3_SERVER_FILES_TARGET = "s3://${var.files_bucket_id}"
    MODS                   = "${join(" ", [for mod in var.modding.mods : "${var.modding.client}-${mod}"])}"
  }
}

data "template_file" "user_data" {
  template = file("${var.misc_file_source}/user_data_${var.modding.client}.sh")
  vars     = local.envVars
}

data "aws_ec2_instance_type" "server" {
  instance_type = var.instance_type
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-${data.aws_ec2_instance_type.server.supported_architectures[0]}-server-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = data.aws_ec2_instance_type.server.supported_architectures
  }
}

resource "aws_iam_instance_profile" "server-profile" {
  name = "${var.project}-${var.server_name}-profile"
  role = module.ec2-role.role.name
}

resource "aws_instance" "server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  availability_zone           = "${var.region}${var.az}"
  vpc_security_group_ids      = [aws_security_group.sg["server"].id]
  user_data                   = data.template_file.user_data.rendered
  iam_instance_profile        = aws_iam_instance_profile.server-profile.name

  lifecycle {
    ignore_changes = all
  }

  tags = {
    Name = "${var.project}-${var.server_name}"
  }
}

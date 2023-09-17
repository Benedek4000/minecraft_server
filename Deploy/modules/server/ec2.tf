data "template_file" "server_properties" {
  template = file("${var.server_file_source}/server.properties")
  vars = {
    RCON_PASSWORD = file("${var.server_file_source}/rcon_password.txt")
    SEED          = try(var.server_properties.seed, local.default_server_properties.seed)
    GAMEMODE      = try(var.server_properties.gamemode, local.default_server_properties.gamemode)
    MOTD          = try(var.server_properties.motd, local.default_server_properties.motd)
    DIFFICULTY    = try(var.server_properties.difficulty, local.default_server_properties.difficulty)
    ONLINE_MODE   = try(var.server_properties.online_mode, local.default_server_properties.online_mode)
    HARDCORE      = try(var.server_properties.hardcore, local.default_server_properties.hardcore)
    LEVEL_TYPE    = try(var.server_properties.level_type, local.default_server_properties.level_type)
  }
}

data "template_file" "start_minecraft_server" {
  template = file("${var.server_file_source}/start_minecraft_server.sh")
  vars = {
    RCON_PASSWORD = file("${var.server_file_source}/rcon_password.txt")
  }
}

data "template_file" "stop_service" {
  template = file("${var.server_file_source}/stop_service.sh")
  vars = {
    S3_TARGET = "s3://${module.s3_backup.bucket_id}"
  }
}

data "template_file" "user_data" {
  template = file("${var.misc_file_source}/user_data.sh")
  vars = {
    START             = file("${var.server_file_source}/start.sh")
    SERVER_COMMAND    = file("${var.server_file_source}/server_command.sh")
    EULA              = file("${var.server_file_source}/eula.txt")
    SERVER_PROPERTIES = data.template_file.server_properties.rendered
    MINECRAFT_SERVICE = file("${var.server_file_source}/minecraft.service")
    START_SERVICE     = data.template_file.start_minecraft_server.rendered
    STOP_SERVICE      = data.template_file.stop_service.rendered
    SERVER_FILE_PATH  = local.versions[var.mc_version]
  }
}

data "aws_ec2_instance_type" "server" {
  instance_type = var.instance_type
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-${data.aws_ec2_instance_type.server.supported_architectures[0]}-server-*"]
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
  role = module.ec2-role.roleName
}

resource "aws_instance" "server" {
  key_name                    = var.key_name
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  availability_zone           = "${var.region}${var.az}"
  vpc_security_group_ids      = [aws_security_group.sg["server"].id]
  user_data                   = data.template_file.user_data.rendered
  iam_instance_profile        = aws_iam_instance_profile.server-profile.name

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "${var.project}-${var.server_name}"
  }
}

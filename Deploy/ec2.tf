data "template_file" "server_properties" {
  template = file("./server_files/server.properties")
  vars = {
    RCON_PASSWORD = file("./server_files/rcon_password.txt")
  }
}

data "template_file" "start_minecraft_server" {
  template = file("./server_files/start_minecraft_server.sh")
  vars = {
    RCON_PASSWORD = file("./server_files/rcon_password.txt")
  }
}

data "template_file" "user_data" {
  template = file("./user_data.sh")
  vars = {
    #STOP              = file("./server_files/stop.sh")
    START             = file("./server_files/start.sh")
    SERVER_COMMAND    = file("./server_files/server_command.sh")
    EULA              = file("./server_files/eula.txt")
    SERVER_PROPERTIES = data.template_file.server_properties.rendered
    MINECRAFT_SERVICE = file("./server_files/minecraft.service")
    START_SERVICE     = data.template_file.start_minecraft_server.rendered
    STOP_SERVICE      = file("./server_files/stop_service.sh")
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
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
    values = ["arm64"]
  }
}

resource "aws_eip" "server" {
  instance = aws_instance.server.id
  vpc      = true
}

resource "aws_iam_instance_profile" "server-profile" {
  name = "${var.project}-profile"
  role = module.ec2-role.role_name
}

resource "aws_instance" "server" {
  key_name                    = aws_key_pair.key_pair.key_name
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  availability_zone           = "${var.region}${var.az}"
  vpc_security_group_ids      = [aws_security_group.server.id]
  user_data                   = data.template_file.user_data.rendered
  iam_instance_profile        = aws_iam_instance_profile.server-profile.name

  tags = {
    Name = var.project
  }
}

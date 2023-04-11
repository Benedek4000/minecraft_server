data "template_file" "user_data" {
  template = file("./user_data.sh")
  vars = {
    EULA              = file("./server_files/eula.txt")
    SERVER_PROPERTIES = file("./server_files/server.properties")
    MINECRAFT_SERVICE = file("./server_files/minecraft.service")
    START_SERVICE     = file("./server_files/start_minecraft_server.sh")
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

resource "aws_instance" "server" {
  key_name                    = aws_key_pair.key_pair.key_name
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  availability_zone           = "${var.region}${var.az}"
  vpc_security_group_ids      = [aws_security_group.server.id]
  user_data                   = data.template_file.user_data.rendered

  tags = {
    Name = var.project
  }
}

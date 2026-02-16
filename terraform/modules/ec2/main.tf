data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Generate a new SSH key pair if none provided
resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.generated.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.generated.private_key_pem
  filename = "${path.root}/${var.project_name}-key.pem"
  file_permission = "0400"
}

resource "aws_security_group" "strapi_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "strapi_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated.key_name

  iam_instance_profile = "ec2-ecr-role"
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  user_data = templatefile("${path.module}/user_data.sh", {
    docker_compose_content = var.docker_compose_content
    nginx_conf_content     = var.nginx_conf_content
    docker_username        = var.docker_username
    docker_password        = var.docker_password
    region                 = var.region
  })

  tags = {
    Name = "${var.project_name}-strapi"
  }
}

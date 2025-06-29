terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc

data "aws_vpc" "main" {
  id = var.vpc_id
}

# https://registry.terraform.io/providers/hashicorp/aws/2.54.0/docs/resources/security_group

resource "aws_security_group" "sg_my_server" {
  name        = "allow_tls"
  vpc_id = data.aws_vpc.main.id

  ingress = [{
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
	prefix_list_ids  = []
	security_groups = []
	self = false
  },
  {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip]
    ipv6_cidr_blocks = ["::/0"]
	prefix_list_ids  = []
	security_groups = []
	self = false
  }]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outgoing traffic"
    ipv6_cidr_blocks = ["::/0"]
	prefix_list_ids  = []
	security_groups = []
	self = false
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair

resource "aws_key_pair" "key" {
  key_name   = "aws-key"
  public_key = file("./terraform.pub")
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami

data "aws_ami" "amazon-linux-2" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# https://developer.hashicorp.com/terraform/tutorials/provision/cloud-init

resource "aws_instance" "my_server" {
  ami                         = "${data.aws_ami.amazon-linux-2.id}"
  instance_type               = var.instance_type
 # subnet_id                   = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_my_server.id]
  # user_data                   = file("./user_data.yaml")
  user_data = file("${path.module}/user_data.yaml")  # https://developer.hashicorp.com/terraform/language/functions/file
  key_name = aws_key_pair.key.key_name

  tags = {
    Name = "Build Module"
  }
}
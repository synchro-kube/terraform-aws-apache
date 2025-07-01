Build Terraform Module named 'terraform-aws-apache-example'

/*
resource "aws_instance" "my_server" {
  ami                         = "${data.aws_ami.amazon-linux-2.id}"
  instance_type               = var.instance_type
 # subnet_id                   = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_my_server.id]
  # user_data                   = file("./user_data.yaml")
  user_data = file("${path.module}/user_data.yaml")  # https://developer.hashicorp.com/terraform/language/functions/file
  key_name = aws_key_pair.key.key_name
  */
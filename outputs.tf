output "public-ipv4" {
  value = aws_instance.my_server.public_ip
}
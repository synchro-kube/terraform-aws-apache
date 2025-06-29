variable "vpc_id" {
  type = string
  default = "vpc-032434d06f5012bbd"
}

variable "my_public_ip" {
  type = string
  description = "whatismyip 174.115.207.135/32"
  default = "174.115.207.135/32"
}
/*
variable "public_key" {
  type = string
}
*/
variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "server_name" {
  type = string
  default = "AWS Apache Example Server"
}
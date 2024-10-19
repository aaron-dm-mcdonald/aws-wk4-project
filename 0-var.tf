variable "region" {
  default = "us-east-1"
}

variable "vpc1_cidr" {
  default = "10.10.0.0/16"
}

variable "vpc2_cidr" {
  default = "10.15.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.10.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.15.11.0/24"
}

variable "tgw_name" {
  default = "my-tgw"
}

variable "us-east-1-linux" {
  default = "ami-06b21ccaeff8cd686"
}


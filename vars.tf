variable "access_key"{
        default = ""
}

variable "secret_key" {
        default = ""
}

variable "region" {
         default = "eu-central-1"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "ami" {
  type    = string
  default = "ami-0e8286b71b81c3cc1"
}


variable "public_subnet_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["eu-central-1b", "eu-central-1a"]
}

variable "public_key_path" {
        default = ""
}

resource "aws_key_pair" "ec2key" {
         key_name = ""
        public_key = file(var.public_key_path)
}


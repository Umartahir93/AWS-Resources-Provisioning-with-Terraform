variable region {
  default     = "us-east-1"
  description = "AWS Region"
}

variable vpc_cidr {
  default     = "10.0.0.0/16"
  description = "VPC cidr Block"
}

variable "public_subnet_1_cidr" {
  description = "Public subnet 1 CIDR"
}

variable "public_subnet_2_cidr" {
  description = "Public subnet 2 CIDR"

}

variable "public_subnet_3_cidr" {
  description = "Public subnet 3 CIDR"
}

variable "private_subnet_1_cidr" {
  description = "Private Subnet 1 CIDR"
}

variable "private_subnet_2_cidr" {
  description = "Private Subnet 2 CIDR"
}

variable "private_subnet_3_cidr" {
  description = "Private Subnet 3 CIDR"
}







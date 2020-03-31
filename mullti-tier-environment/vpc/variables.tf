variable "region" {
  type = string
  default = "us-east-1"
}

variable "environment" {
  type =string
  default="test"
}

variable "availability_zones" {
  type =list
}

variable "bastion_instance_type" {
  type =string
}

variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"  
}


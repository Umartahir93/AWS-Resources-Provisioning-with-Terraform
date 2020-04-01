provider "aws" {
  region = var.region
  version = "2.55"
  
}

terraform {
  backend "s3"{
  key     = "PROD/infrastructure.tfstate"
  bucket  = "umartahir-terraform-buckettestus-east-1"
  region  = "us-east-1"
  }
}

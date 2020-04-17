provider "aws" {
  region  = var.aws_region
  version = "2.55"

}

terraform {
  backend "s3" {
    key    = "pipeline/ecr-pipeline.tfstate"
    bucket = "umartahir-terraform-buckettestus-east-1"
    region = "us-east-1"
  }

}

provider "aws" {
  region  = var.aws_region
  version = "2.55"

}

provider "github" {
  token      = var.github_token
  individual = true
}


terraform {
  backend "s3" {
    key    = "ecs_fargate/infrastructure.tfstate"
    bucket = "umartahir-terraform-buckettestus-east-1"
    region = "us-east-1"
  }

}

provider "aws" {
  region = var.s3_region
}


terraform{
    required_version = "> 0.11.7"

    backend "s3"{
        bucket = "umartahir-terraform-buckettestus-east-1"

        key ="test/terraform/backup"

        region ="us-east-1"

        encrypt ="true"  
    }
}
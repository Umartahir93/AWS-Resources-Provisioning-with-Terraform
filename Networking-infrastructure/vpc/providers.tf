provider "aws" {
    region =var.region 
    version = "2.55"
}

terraform{
    required_version =">= 0.11.7"


    backend "s3"{
        bucket = "umartahir-terraform-buckettestus-east-1"

        key = "terraform/vpc/backup"

        region = "us-east-1"

        encrypt = "true"

    }


}

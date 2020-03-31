variable environment {
  type    = string
  default = "test"
}

variable s3_bucket_prefix {
  type        = string
  default     = "umartahir-terraform-bucket"
  description = "Prefix of the s3 bucket"

}

variable s3_region {
  type = string
}

locals {
  s3_tags = {
    created_by  = "terraform"
    environment = "${var.environment}"
  }
}



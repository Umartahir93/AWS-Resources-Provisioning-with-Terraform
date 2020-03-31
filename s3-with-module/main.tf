module "my-s3" {
  source = "../s3workspace"
  s3_bucket_prefix = var.s3_bucket_prefix
  s3_region =var.s3_region  
}

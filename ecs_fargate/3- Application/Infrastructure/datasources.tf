data "terraform_remote_state" "infrastructure" {
    backend = "s3"

    config = {
    key    = "env:/dev-env/ecs_fargate/platform.tfstate"
    bucket = "umartahir-terraform-buckettestus-east-1"
    region = "us-east-1"
    } 
}
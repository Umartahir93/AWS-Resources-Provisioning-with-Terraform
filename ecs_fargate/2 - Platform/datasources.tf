data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    workspaces = {
      name = "dev-env"
    }
  }
}
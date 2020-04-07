module "child" {
  source = "../Networking-infrastructure/vpc"
  availability_zones =["us-east-1a","us-east-1b","us-east-1c"]
  bastion_instance_type="t2.micro"
}

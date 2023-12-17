terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v5.1.2"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  name = "github-vpc"

  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a"]

  private_subnets = ["10.0.2.0/24"]
  public_subnets  = ["10.0.1.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}
terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v5.1.2"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  testing_common_vars = yamldecode(file(find_in_parent_folders("testing_common_vars.yml")))
}

inputs = {
  name = "testing-vpc"

  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]

  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.testing_common_vars.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                                              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.testing_common_vars.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                                     = 1
  }
}
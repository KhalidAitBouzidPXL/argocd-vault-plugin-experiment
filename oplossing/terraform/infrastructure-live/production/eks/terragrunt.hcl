terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v19.1.0"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "data" {
  config_path = "../data"
}

locals {
  production_common_vars = yamldecode(file(find_in_parent_folders("production_common_vars.yml")))
}

inputs = {
  create_iam_role = false
  iam_role_arn    = dependency.data.outputs.lab_role_arn

  enable_irsa = false

  cluster_name    = local.production_common_vars.eks_cluster_name
  cluster_version = "1.28"

  vpc_id                         = dependency.vpc.outputs.vpc_id
  subnet_ids                     = dependency.vpc.outputs.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type        = "AL2_x86_64"
    create_iam_role = false
    iam_role_arn    = dependency.data.outputs.lab_role_arn
  }

  eks_managed_node_groups = {
    one = {
      name           = "node-group-2"
      instance_types = ["t3.large"]

      min_size     = 3
      max_size     = 5
      desired_size = 3
    }
  }

  node_security_group_additional_rules = {
    allow_http_traffic = {
      description                = "Allow HTTP traffic"
      protocol                   = "tcp"
      from_port                  = 80
      to_port                    = 80
      type                       = "ingress"
      cidr_blocks                = ["0.0.0.0/0"]
    }
  }
}
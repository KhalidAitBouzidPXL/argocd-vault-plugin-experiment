terraform {
  source = "../../../infrastructure-modules/nginx"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "../eks"
}

inputs = {
  cluster_name           = dependency.eks.outputs.cluster_name
  cluster_endpoint       = dependency.eks.outputs.cluster_endpoint
  cluster_ca_certificate = dependency.eks.outputs.cluster_certificate_authority_data
  ssm_parameter_name     = "kubernetes-pe2-production-eks-cluster-1-nginx-ingress-lb"
  gh_username            = get_env("GH_USERNAME")
  gh_token               = get_env("GH_TOKEN")
  namespace              = "prodsbamtut"
}
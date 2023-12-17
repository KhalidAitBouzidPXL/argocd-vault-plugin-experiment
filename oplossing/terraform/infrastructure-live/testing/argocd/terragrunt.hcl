terraform {
  source = "../../../infrastructure-modules/argocd"
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
  repository_url         = "git@github.com:PXL-Systems-Expert/kubernetes-pe2-KhalidAitBouzidPXL.git"
  repository_path        = "oplossing/kubernetes/overlays/test"
  ssh_private_key        = get_env("SSH_PRIVATE_KEY", "")
  admin_password         = get_env("ADMIN_PASSWORD", "")
  hashed_admin_password  = get_env("HASHED_ADMIN_PASSWORD", "")
  namespace              = "testsbamtut"
}
terraform {
  source = "../../../infrastructure-modules/github-ec2-runner"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id              = dependency.vpc.outputs.vpc_id
  subnet_id           = dependency.vpc.outputs.public_subnets[0]
  iam_instance_role   = "LabInstanceProfile"
  security_group_name = "github-ec2-runner-sg"
  instance_type       = "t3.medium"
  ami_id              = "ami-0fa1ca9559f1892ec" # Amazon Linux 2 AMI
  instance_name       = "github-ec2-runner"
  runner_name         = "private-github-ec2-runner"
  runner_token        = get_env("RUNNER_TOKEN", "")
}
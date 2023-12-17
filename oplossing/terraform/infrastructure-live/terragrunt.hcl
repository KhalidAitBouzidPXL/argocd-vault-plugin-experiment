locals {
  common_vars = yamldecode(file("common_vars.yml"))
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket         = "${local.common_vars.backend_bucket_name}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.common_vars.aws_region}"
    encrypt        = true
    dynamodb_table = "${local.common_vars.backend_dynamodb_table_name}"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region              = "${local.common_vars.aws_region}"
}
EOF
}
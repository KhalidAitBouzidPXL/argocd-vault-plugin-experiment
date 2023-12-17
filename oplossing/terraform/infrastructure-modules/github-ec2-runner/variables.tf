variable "vpc_id" {
  type        = string
  description = "The ID of the VPC in which to create the EC2 instance"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet in which to create the EC2 instance"
}

variable "security_group_name" {
  type        = string
  description = "The name of the security group to create for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "The type of EC2 instance to launch"
}

variable "ami_id" {
  type        = string
  description = "The ID of the AMI to use for the EC2 instance"
}

variable "instance_name" {
  type        = string
  description = "The name of the EC2 instance"
}

variable "runner_token" {
  type        = string
  description = "The token to use for the GitHub Runner"
  sensitive   = true
}

variable "runner_name" {
  type        = string
  description = "The name to use for the GitHub Runner"
}

variable "iam_instance_role" {
  type        = string
  description = "The IAM instance role to use for the EC2 instance"
}
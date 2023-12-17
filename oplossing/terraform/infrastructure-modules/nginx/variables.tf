variable "cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "The base64 encoded Kubernetes cluster CA certificate"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "ssm_parameter_name" {
  description = "The name of the SSM parameter to create"
  type        = string
}

variable "gh_username" {
  description = "The username to use for the GitHub registry"
  type        = string
  sensitive   = true
}

variable "gh_token" {
  description = "The token to use for the GitHub registry"
  type        = string
  sensitive   = true
}

variable "namespace" {
  description = "The namespace to deploy the application to"
  type        = string
}
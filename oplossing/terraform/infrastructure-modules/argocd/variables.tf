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

variable "repository_url" {
  description = "The URL of the Git repository"
  type        = string
}

variable "repository_path" {
  description = "The path of the Git repository that will be monitored by ArgoCD"
  type        = string
}

variable "ssh_private_key" {
  description = "The SSH private key that will be used to authenticate with the Git repository"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "The password for the ArgoCD admin user"
  type        = string
  sensitive   = true
}

variable "hashed_admin_password" {
  description = "The hashed password for the ArgoCD admin user"
  type        = string
  sensitive   = true
}

variable "namespace" {
  description = "The namespace to deploy the application to"
  type        = string
}
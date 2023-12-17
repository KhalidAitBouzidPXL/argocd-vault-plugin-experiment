resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "5.51.3"

  set {
    name  = "dex.enabled"
    value = "false"
  }

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.hashed_admin_password
  }

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}

resource "argocd_repository" "repository" {
  repo            = var.repository_url
  ssh_private_key = var.ssh_private_key
}

resource "argocd_application" "argo_configuration" {
  metadata {
    name      = "argo-application"
    namespace = "argocd"
  }

  spec {
    project = "default"

    source {
      repo_url        = argocd_repository.repository.repo
      target_revision = "HEAD"
      path            = var.repository_path
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.namespace
    }

    sync_policy {
      automated {
        self_heal = true
        prune     = true
      }
      sync_options = ["CreateNamespace=true"]
    }
  }
}
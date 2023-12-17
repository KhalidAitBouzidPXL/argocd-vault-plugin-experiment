resource "helm_release" "nginx" {
  name             = "nginx-ingress"
  repository       = "https://helm.nginx.com/stable"
  chart            = "nginx-ingress"
  namespace        = var.namespace
  create_namespace = true

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}

data "kubernetes_service" "nginx_server" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = var.namespace
  }

  depends_on = [helm_release.nginx]
}

resource "kubernetes_ingress_v1" "nginx_ingress_rules" {
  metadata {
    name      = "nginx-ingress-rules"
    namespace = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = data.kubernetes_service.nginx_server.status.0.load_balancer.0.ingress.0.hostname
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "angular-client-service"
              port {
                number = 80
              }
            }
          }
        }
        path {
          path      = "/api"
          path_type = "Prefix"
          backend {
            service {
              name = "spring-boot-server-service"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}

resource "aws_ssm_parameter" "this" {
  name  = var.ssm_parameter_name
  type  = "String"
  value = data.kubernetes_service.nginx_server.status.0.load_balancer.0.ingress.0.hostname
}

resource "kubernetes_secret" "ghcr" {
  metadata {
    name      = "ghcr"
    namespace = var.namespace
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      "auths" = {
        "ghcr.io" = {
          "username" = var.gh_username
          "password" = var.gh_token
          "auth"     = base64encode("${var.gh_username}:${var.gh_token}")
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"

  depends_on = [helm_release.nginx]
}
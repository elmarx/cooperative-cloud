resource "kubernetes_namespace" "this" {
  metadata {
    name = "ingress"
  }
}

resource "helm_release" "this" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_version
  namespace  = kubernetes_namespace.this.metadata[0].name
  atomic     = true

  set {
    name  = "controller.watchIngressWithoutClass"
    value = true
  }

  set {
    name  = "controller.replicaCount"
    value = 2
  }
}

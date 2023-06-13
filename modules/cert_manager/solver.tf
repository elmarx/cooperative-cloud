resource "kubernetes_manifest" "cert_manager_issuer_prod" {
  manifest   = yamldecode(file("${path.module}/crd/cert_manager_issuer.yaml"))
  depends_on = [helm_release.cert_manager]
}

resource "kubernetes_manifest" "cert_manager_issuer_staging" {
  manifest   = yamldecode(file("${path.module}/crd/cert_manager_issuer_staging.yaml"))
  depends_on = [helm_release.cert_manager]
}
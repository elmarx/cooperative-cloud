module "ingress" {
  source = "../modules/ingress_nginx"
}

module "cert_manager" {
  source = "../modules/cert_manager"
}

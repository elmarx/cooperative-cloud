provider "kubernetes" {
  config_path    = "${path.module}/../k3s.yaml"
  config_context = "default"
}

provider "helm" {
  kubernetes {
    config_path    = "${path.module}/../k3s.yaml"
    config_context = "default"
  }
}

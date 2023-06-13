terraform {
  backend "remote" {
    organization = "cooperative"

    workspaces {
      name = "kubernetes"
    }
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
  }
}

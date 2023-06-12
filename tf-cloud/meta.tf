terraform {
  backend "remote" {
    organization = "cooperative"

    workspaces {
      name = "tf-cloud"
    }
  }

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.45.0"
    }
  }
}

terraform {
  backend "remote" {
    organization = "cooperative"

    workspaces {
      name = "server"
    }
  }

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.38.0"
    }
    pass = {
      source  = "mecodia/pass"
      version = "3.1.0"
    }
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.5.0"
    }
  }
}

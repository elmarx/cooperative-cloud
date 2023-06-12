terraform {
  backend "remote" {
    organization = "cooperative"

    workspaces {
      name = "dns"
    }
  }

  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.5.0"
    }
    pass = {
      source  = "mecodia/pass"
      version = "3.1.0"
    }
  }
}

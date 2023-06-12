locals {
  datacenter = {
    nbg1 = "nbg1-dc3"
    hel1 = "hel1-dc2"
    fsn1 = "fsn1-dc14"
  }

  nixos_infect = <<-EOT
    #!/bin/sh

    curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | \
      PROVIDER=hetznercloud NIX_CHANNEL=nixos-23.05 bash 2>&1 | \
      tee /tmp/infect.log
  EOT
}

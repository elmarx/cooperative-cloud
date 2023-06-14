{
  description = "colmena";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.nixos.url = "nixpkgs/nixos-23.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, nixos, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          devShells.default = pkgs.mkShell {
            packages = [ pkgs.colmena pkgs.nixpkgs-fmt ];
          };
        }) // {

      colmena = {
        meta = {
          nixpkgs = import nixos {
            system = "x86_64-linux";
            overlays = [ ];
          };
        };

        "node0.kooperative.cloud" = { name, nodes, pkgs, ... }: {
          imports = [
            ./hardware-configuration.nix
            ./networking.nix # generated at runtime by nixos-infect
          ];

          boot.tmp.cleanOnBoot = true;
          zramSwap.enable = true;
          networking.hostName = "node0";
          networking.domain = "kooperative.cloud";
          services.openssh.enable = true;
          users.users.root.openssh.authorizedKeys.keys = [
            # add your public key here if you want to have access :)
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJOPHVWvqquGbL86yoRU0GPXpTgvCiucTB7O4eVykvM9 elmar@crabtree.athmer.org"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIECS0/KZ01SSfCmXOLmFtsmiEOhGZ7L2pn1oejfjQDOT elmar@athmer.org"

          ];

          # networking.firewall.enable = false;
          networking.firewall.allowedUDPPorts = [
            51820
            8472 # flannel
          ];
          networking.firewall.allowedTCPPorts = [
            6443 # control plane connection
            10250 # metrics endpoint
            80 # http
            443 # https
          ];

          boot.kernel.sysctl = {
            "net.ipv4.conf.all.forwarding" = true;
            "net.ipv4.conf.default.forwarding" = true;
          };

          # add wireguard interface
          networking.wireguard.interfaces.wg0 = {
            privateKey = "wBcKpA2imRtwLBIvqvcOiON9rD5CJyajNOuDZqh1fFA=";
            # publicKey = "60dVYunQRvc55FxMoOdnu9vqSl8Rb4FXAnpUNiyR7i4=";
            listenPort = 51820;
            # 10.0.0.1 — 10.0.0.254 node address range
            ips = [ "10.0.0.1/32" ];
            peers = [
              # { publicKey = ""; allowedIPs = [ "" ]; }
              { publicKey = "lJeF+PANDxvDozzZy+cO9yOAogv+8zZXz31eqRMLdi0="; allowedIPs = [ "10.0.0.2/32" ]; persistentKeepalive = 25; } # jim
              { publicKey = "WnyDFDqTOlnrbS5qH02mFHeCH81EemXp/yQKKOqzCko="; allowedIPs = [ "10.0.0.15/32" ]; persistentKeepalive = 24; } # andreas
              { publicKey = "jIFYCFSZBjoJTjX1HTm/JAYYEsFYKGKU4IQ535MccWI="; allowedIPs = [ "10.0.0.4/32" ]; persistentKeepalive = 25; } # ram
              { publicKey = "qw5tOwhHyHdKqWNv6ReVl7U4SIAY2Zt8vAJd5H8q/XY="; allowedIPs = [ "10.0.0.23/32" ]; persistentKeepalive = 25; } # david
              { publicKey = "tpJITm3/XO0Beb08iKJeflDgkLZ6jyEYJO+3EE0pO3U="; allowedIPs = [ "10.0.0.24/32" ]; persistentKeepalive = 25; } # elmar home
              { publicKey = "j84euLoKeGDGPwdY8fwnp5F4GkjbuPDniIFBKMU76gY="; allowedIPs = [ "10.0.0.16/32" ]; persistentKeepalive = 25; } # lennard
              { publicKey = "wzkpKdzH2BYAj9ls6MTFMPIT49wo8R89EKuOnEDVl24="; allowedIPs = [ "10.0.0.74/32" ]; persistentKeepalive = 25; } # marek
              { publicKey = "2p2Nnmf61ITes2GPN/XKN+3j0YIDAjiWJrnZnXRW6is="; allowedIPs = [ "10.0.0.7/32" ]; persistentKeepalive = 25; }  # marcel
              { publicKey = "wTul+BVeyH9cRfDh/IqnHWCQA/u2MxX9WxvtlrDgQSc="; allowedIPs = [ "10.0.0.83/32" ]; persistentKeepalive = 25; }  # stephan
              { publicKey = "iG2hSl/aQxuthfUfsFBR3hW9iyT4xHHRcVl/hfUgmTY="; allowedIPs = [ "10.0.0.112/32" ]; persistentKeepalive = 25; }  # sebastian
              { publicKey = "r3B51/P+rPMLwJDKmNQ03cZGbCt7jFBxm2EvmRvfcxU="; allowedIPs = [ "10.0.0.50/32" ]; persistentKeepalive = 25; }  # michael
              { publicKey = "vXO5YWp72dnP8LPK7PwFy1N+VYULjA3v/lbFffSxeRY="; allowedIPs = [ "10.0.0.6/32" ]; persistentKeepalive = 25; }  # kasimir
              { publicKey = "4ZRDsWXEEaoeLRNlDKXEVa9kHPYuVXNkWkNRiFN6M0c="; allowedIPs = [ "10.0.0.7/32" ]; persistentKeepalive = 25; }  # kasimir
              { publicKey = "gOuxTMwTaQuO8YevI5gdlcYSEGuyyoR2qO4BUl8WQC4="; allowedIPs = [ "10.0.0.8/32" ]; persistentKeepalive = 25; }  # kasimir
              { publicKey = "FCF0u+A1qNBcZtxj2050lrMvOf6sGW218B4Vs8Y4qlk="; allowedIPs = [ "10.0.0.9/32" ]; persistentKeepalive = 25; }  # kasimir
              { publicKey = "okOdDt+FNOqyj523F50p8/pEvvlVif52Pw+Y+qyo0zU="; allowedIPs = [ "10.0.0.100/32" ]; persistentKeepalive = 25; }  # michel
              { publicKey = "phiLd5HSz+N7rxylX9kAlyzk8rr3dawbKnpEuyIaeWE="; allowedIPs = [ "10.0.0.3/32" ]; persistentKeepalive = 25; }  # elmar NUC
              { publicKey = "gplGFXxZ4jmuNcFdsMzIVDcUysviTS/p3dOKozXrBEs="; allowedIPs = [ "10.0.0.201/32" ]; persistentKeepalive = 25; }  # elmar deskpi node 1
              { publicKey = "jWtcASRVF/EvIaoJnb+9ewZqtcdNjkzcEpjjsswPRV0="; allowedIPs = [ "10.0.0.202/32" ]; persistentKeepalive = 25; }  # elmar deskpi node 2
              { publicKey = "z726yKnrOWq4Pzh9tnAgDj0z3Wbet8LXIk5qM5oEzic="; allowedIPs = [ "10.0.0.203/32" ]; persistentKeepalive = 25; }  # elmar deskpi node 3
              { publicKey = "vNFeA9IYjujvCZcG4Z1sil3/4d5RSIsZGCB+Lwf7ACI="; allowedIPs = [ "10.0.0.204/32" ]; persistentKeepalive = 25; }  # elmar deskpi node 4
              { publicKey = "eriDmgZNhJX8gnb3KlknIyMWFPDuh5VU3wZY3mFmri8="; allowedIPs = [ "10.0.0.205/32" ]; persistentKeepalive = 25; }  # elmar deskpi node 5
              { publicKey = "jdNWPolz/N5PWigTndSbi0OiXr0rXEKCcGjcQmfvG2s="; allowedIPs = [ "10.0.0.206/32" ]; persistentKeepalive = 25; }  # elmar deskpi node 6
              { publicKey = "kennyQi0MqqHbyYxXnc+TQsqbtdDp77sb5bzDX9I4Ts="; allowedIPs = [ "10.0.0.7/32" ]; persistentKeepalive = 25; }  # elmar thinkpad
            ];
          };

          services.k3s = {
            enable = true;
            role = "server";
            extraFlags = ''
              --node-ip 10.0.0.1 \
              --node-external-ip 167.235.131.220 \
              --node-label='svccontroller.k3s.cattle.io/enablelb=true' \
              --cluster-cidr 10.42.0.0/16 \
              --service-cidr 10.43.0.0/16 \
              --disable traefik \
              --flannel-iface wg0
            '';
          };
        };
      };
    };
}

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
            ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJOPHVWvqquGbL86yoRU0GPXpTgvCiucTB7O4eVykvM9 elmar@crabtree.athmer.org''
          ];

          networking.firewall.allowedUDPPorts = [ 51820 ];

          boot.kernel.sysctl = {
            "net.ipv4.conf.all.forwarding" = true;
            "net.ipv4.conf.default.forwarding" = true;
          };

          # add wireguard interface
          networking.wireguard.interfaces.wg0 = {
            privateKey = "wBcKpA2imRtwLBIvqvcOiON9rD5CJyajNOuDZqh1fFA=";
            listenPort = 51820;
            ips = [ "10.0.0.1/32" ];
            peers = [
              # { publicKey = ""; allowedIPs = [ "" ]; }
            ];
          };
        };
      };
    };
}

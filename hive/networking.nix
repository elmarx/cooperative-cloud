{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "2a01:4ff:ff00::add:2"
 "2a01:4ff:ff00::add:1"
 "185.12.64.1"
 ];
    defaultGateway = "172.31.1.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="167.235.131.220"; prefixLength=32; }
        ];
        ipv6.addresses = [
          { address="2a01:4f8:c2c:cb65::1"; prefixLength=64; }
{ address="fe80::9400:2ff:fe45:f47d"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "172.31.1.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = "fe80::1"; prefixLength = 128; } ];
      };

    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="96:00:02:45:f4:7d", NAME="eth0"

  '';
}
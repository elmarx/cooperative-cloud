resource "hcloud_server" "node" {
  count       = local.node_count
  name        = "node${count.index}"
  image       = "debian-11"
  server_type = "cx11"
  location    = "nbg1"
  public_net {
    ipv4 = var.enable_ipv4 ? hcloud_primary_ip.node_v4[count.index].id : null
    ipv6 = hcloud_primary_ip.node_v6[count.index].id
  }
  ssh_keys  = [hcloud_ssh_key.default.id]
  user_data = local.nixos_infect
}

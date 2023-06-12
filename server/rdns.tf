resource "hcloud_rdns" "node_aaaa" {
  count      = local.node_count
  server_id  = hcloud_server.node[count.index].id
  ip_address = hcloud_server.node[count.index].ipv6_address
  dns_ptr    = "node${count.index}.kooperative.cloud"
}

resource "hcloud_rdns" "node_a" {
  count      = var.enable_ipv4 ? local.node_count : 0
  server_id  = hcloud_server.node[count.index].id
  ip_address = hcloud_server.node[count.index].ipv4_address
  dns_ptr    = "node${count.index}.kooperative.cloud"
}

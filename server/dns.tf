resource "powerdns_record" "node_aaaa" {
  count   = local.node_count
  name    = "node${count.index}.${local.zone}"
  ttl     = 60
  type    = "AAAA"
  zone    = local.zone
  records = [hcloud_server.node[count.index].ipv6_address]
}

resource "powerdns_record" "node_a" {
  count   = var.enable_ipv4 ? local.node_count : 0
  name    = "node${count.index}.${local.zone}"
  ttl     = 60
  type    = "A"
  zone    = local.zone
  records = [hcloud_server.node[count.index].ipv4_address]
}

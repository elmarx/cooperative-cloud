resource "hcloud_primary_ip" "node_v4" {
  count             = var.enable_ipv4 ? var.max_node_count : 0
  name              = "node${count.index}_v4"
  type              = "ipv4"
  assignee_type     = "server"
  auto_delete       = false
  delete_protection = false
  datacenter        = local.datacenter.nbg1
}

resource "hcloud_primary_ip" "node_v6" {
  count             = var.max_node_count
  name              = "node${count.index}_v6"
  type              = "ipv6"
  assignee_type     = "server"
  auto_delete       = false
  delete_protection = false
  datacenter        = local.datacenter.nbg1
}

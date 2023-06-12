variable "max_node_count" {
  type    = number
  default = 3
}

variable "node_count" {
  type    = number
  default = 1
}

locals {
  node_count = var.node_count == null ? var.max_node_count : var.node_count
}

variable "enable_ipv4" {
  type    = bool
  default = true
}

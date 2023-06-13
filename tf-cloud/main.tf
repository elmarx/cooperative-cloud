locals {
  modules = ["tf-cloud", "server", "dns", "kubernetes"]
}

resource "tfe_workspace" "this" {
  for_each       = toset(local.modules)
  name           = each.value
  organization   = tfe_organization.this.name
  execution_mode = "local"
  tag_names      = ["managed-by-tf"]
}

data "pass_password" "hcloud" {
  path = "server/hetzner.de/token/cooperative-cloud"
}

provider "hcloud" {
  token = data.pass_password.hcloud.password
}

data "pass_password" "pdns_api_key" {
  path = "server/powerdns/api-key"
}

provider "powerdns" {
  api_key    = data.pass_password.pdns_api_key.password
  server_url = "https://ns.eathmer.de"
}

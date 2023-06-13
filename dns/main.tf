resource "powerdns_zone" "this" {
  name         = "kooperative.cloud."
  kind         = "Master"
  nameservers  = ["ns1.eathmer.de.", "ns2.eathmer.de.", "ns3.eathmer.de."]
  soa_edit_api = "DEFAULT"
}

resource "powerdns_record" "www" {
  name = "www.${powerdns_zone.this.name}"
  type = "CNAME"
  ttl  = 300
  zone = powerdns_zone.this.name

  records = [
    "node0.${powerdns_zone.this.name}",
  ]
}

resource "powerdns_zone" "this" {
  name         = "kooperative.cloud."
  kind         = "Master"
  nameservers  = [ "ns1.eathmer.de.", "ns2.eathmer.de.", "ns3.eathmer.de." ]
  soa_edit_api = "DEFAULT"
}

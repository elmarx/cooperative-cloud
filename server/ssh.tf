resource "hcloud_ssh_key" "default" {
  name       = "terraform"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "digitalocean_vpc" "this" {
  name     = "tenminutevpn-${data.digitalocean_region.this.slug}"
  region   = data.digitalocean_region.this.slug
  ip_range = "10.100.0.0/24"
}

resource "digitalocean_custom_image" "this" {
  name         = "tenminutevpn"
  url          = one([for item in data.github_release.this.assets : item if item.name == "debian-12.raw.gz"]).browser_download_url
  distribution = "Debian"
  regions      = [data.digitalocean_region.this.slug]

  timeouts {
    create = "15m"
  }
}

resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "digitalocean_ssh_key" "this" {
  name       = "tenminutevpn"
  public_key = tls_private_key.this.public_key_openssh
}

resource "digitalocean_droplet" "this" {
  name  = "tenminutevpn"
  image = digitalocean_custom_image.this.id
  size  = "s-1vcpu-512mb-10gb"

  region   = data.digitalocean_region.this.slug
  vpc_uuid = digitalocean_vpc.this.id
  ipv6     = false

  droplet_agent = false
  backups       = false
  monitoring    = false
  resize_disk   = false

  ssh_keys = [
    digitalocean_ssh_key.this.fingerprint,
  ]

  timeouts {
    create = "15m"
    delete = "15m"
  }
}

resource "digitalocean_firewall" "this" {
  name = "tenminutevpn"

  droplet_ids = [digitalocean_droplet.this.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "ssh_resource" "this" {
  when = "create"

  host        = digitalocean_droplet.this.ipv4_address
  user        = "root"
  private_key = tls_private_key.this.private_key_pem

  timeout     = "15m"
  retry_delay = "5s"

  commands = [
    "echo 'Hello, World!'",
  ]
}

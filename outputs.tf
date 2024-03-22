output "ipv4_address" {
  value = digitalocean_droplet.this.ipv4_address
}

output "ssh_private_key" {
  value     = tls_private_key.this.private_key_openssh
  sensitive = true
}

output "ssh_public_key" {
  value = tls_private_key.this.public_key_openssh
}

output "wireguard" {
  value     = ssh_resource.this.result
  sensitive = true
}

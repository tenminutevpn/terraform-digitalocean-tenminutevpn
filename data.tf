data "digitalocean_region" "this" {
  slug = var.tenminutevpn_region
}

data "github_release" "this" {
  owner      = "tenminutevpn"
  repository = "tenminutevpn"

  retrieve_by = "tag"
  release_tag = var.tenminutevpn_version
}

data "cloudinit_config" "this" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/templates/cloud-config.yaml", {})
  }
}

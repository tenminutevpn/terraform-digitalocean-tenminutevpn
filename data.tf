data "digitalocean_region" "this" {
  slug = var.tenminutevpn_region
}

data "github_release" "this" {
  owner      = "tenminutevpn"
  repository = "tenminutevpn"

  retrieve_by = "tag"
  release_tag = var.tenminutevpn_version
}

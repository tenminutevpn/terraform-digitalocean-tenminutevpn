data "digitalocean_region" "this" {
  slug = var.region
}

data "github_release" "this" {
  owner      = "tenminutevpn"
  repository = "tenminutevpn"

  retrieve_by = "tag"
  release_tag = "v0.1.0rc0"
}

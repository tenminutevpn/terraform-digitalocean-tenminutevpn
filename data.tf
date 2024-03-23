data "digitalocean_region" "this" {
  slug = var.tenminutevpn_region
}

data "github_release" "this" {
  owner      = "tenminutevpn"
  repository = "tenminutevpn"

  retrieve_by = "tag"
  release_tag = var.tenminutevpn_version
}

locals {

  wireguard = {
    kind = "wireguard/v1"
    metadata = {
      name = "wireguard"
      annotations = {
        "tenminutevpn.com/config-dir"      = "/etc/wireguard/"
        "tenminutevpn.com/peer-config-dir" = "/etc/wireguard/peers/"
      }
    }
    spec = {
      device  = "wg0"
      address = "100.96.0.1/24"
      port    = var.wireguard_port
      dns     = "100.96.0.1"
      peers = [
        {
          allowedips = ["100.96.0.5/32"]
        }
      ]
    }
  }

  dnsmasq = {
    kind = "dnsmasq/v1"
    metadata = {
      name = "dnsmasq"
    }
    spec = {
      interface = "wg0"
      server    = var.dns
    }
  }

  squid = {
    kind = "squid/v1"
    metadata = {
      name = "squid"
      annotations = {
        "tenminutevpn.com/config-dir" = "/etc/squid/"
      }
    }
    spec = {
      port = var.squid_port
    }
  }
}

data "cloudinit_config" "this" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "01-wireguard.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/templates/tenminutevpn-resource.yaml", {
      path    = "/etc/tenminutevpn/01-wireguard.yaml",
      content = yamlencode(local.wireguard),
    })
  }

  part {
    filename     = "02-dnsmasq.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/templates/tenminutevpn-resource.yaml", {
      path    = "/etc/tenminutevpn/02-dnsmasq.yaml",
      content = yamlencode(local.dnsmasq),
    })
  }

  part {
    filename     = "03-squid.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/templates/tenminutevpn-resource.yaml", {
      path    = "/etc/tenminutevpn/03-squid.yaml",
      content = yamlencode(local.squid),
    })
  }

  part {
    filename     = "tenminutevpn-config.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/templates/tenminutevpn-config.yaml")
  }
}

terraform {
  required_version = "~> 1.6.0"

  required_providers {
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "~> 2.0"
    }
  }
}

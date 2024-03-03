terraform {
  required_version = "1.5.6"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
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

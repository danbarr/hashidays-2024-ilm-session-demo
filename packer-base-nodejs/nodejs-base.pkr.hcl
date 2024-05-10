packer {
  required_version = ">= 1.10.1"
  required_plugins {
    docker = {
      version = "~> 1.0.9"
      source  = "github.com/hashicorp/docker"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "docker" "node-20" {
  image    = "node:20"
  commit   = true
  platform = "linux/amd64"
  changes = [
    "USER node"
  ]
}

build {
  hcp_packer_registry {
    bucket_name = "node-20-hashicafe-base"
    description = "Approved container image for HashiCafe apps using Node.js 20."
    bucket_labels = {
      "owner"        = var.owner
      "dept"         = var.department
      "node-version" = "20"
    }
    build_labels = {
      "build-time" = local.timestamp
    }
  }

  sources = [
    "source.docker.node-20"
  ]

  provisioner "shell" {
    script = "${path.root}/harden-container.sh"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "${var.registry_host}/node-20-hashicafe-base"
      tags       = ["20", "latest"]
    }
    post-processor "docker-push" {
      login          = true
      login_server   = var.registry_host
      login_username = var.registry_username
      login_password = var.registry_password
    }
  }
}

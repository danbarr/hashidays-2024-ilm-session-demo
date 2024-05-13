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
  timestamp         = timestamp()
  timestamp_cleaned = regex_replace(timestamp(), "[- TZ:]", "")
}

source "docker" "node-20" {
  image    = "node:20-alpine"
  commit   = true
  platform = "linux/amd64"
  changes = [
    "LABEL build-date=${local.timestamp}",
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
      "platform"     = "alpine"
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
      tags       = concat(var.extra_tags, [local.timestamp_cleaned, "latest"])
    }

    post-processor "docker-push" {
      ecr_login    = var.registry_is_ecr
      login_server = var.registry_host
    }
  }
}

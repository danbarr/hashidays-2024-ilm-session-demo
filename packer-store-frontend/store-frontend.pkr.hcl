packer {
  required_plugins {
    docker = {
      version = "~> 1.0.0"
      source  = "github.com/hashicorp/docker"
    }
  }
}

locals {
  timestamp         = timestamp()
  timestamp_cleaned = regex_replace(timestamp(), "[- TZ:]", "")
}

data "hcp-packer-artifact" "nodejs-20-base" {
  bucket_name  = var.base_image_bucket
  channel_name = var.base_image_channel
  platform     = "docker"
  region       = "docker"
}

source "docker" "store-frontend" {
  image    = data.hcp-packer-artifact.nodejs-20-base.labels["ImageDigest"]
  commit   = true
  platform = "linux/amd64"
  exec_user = "root:root"

  changes = [
    "LABEL build-date=${local.timestamp}",
    "WORKDIR /app",
    "ENTRYPOINT [\"/app/entrypoint.sh\"]",
    "CMD [\"node_modules/.bin/next\", \"start\"]",
    "USER nextjs",
    "EXPOSE 3000",
    "ENV PORT 3000",
    "ENV NODE_ENV production",
  ]
}

build {
  hcp_packer_registry {
    bucket_name = "hashicafe-store-frontend"
    description = "Docker child image."
    bucket_labels = {
      "owner" = var.owner
      "dept"  = var.department
      "node-version" = "20"
    }
    build_labels = {
      "build-time" = local.timestamp
    }
  }

  sources = [
    "source.docker.store-frontend"
  ]

  provisioner "file" {
    source = "${path.root}/../apps/store-frontend/"
    destination = "/app"
  }

  provisioner "shell" {
    inline = [
      "apk add --no-cache libc6-compat",
      "cd /app",
      "yarn install --frozen-lockfile",
      "NEXT_PUBLIC_PUBLIC_API_URL=APP_NEXT_PUBLIC_API_URL NEXT_PUBLIC_FOOTER_FLAG=APP_PUBLIC_FOOTER_FLAG yarn build",
      "yarn cache clean",
      "addgroup --system --gid 1001 nodejs",
      "adduser --system --uid 1001 nextjs",
      "chown -R root:root /app",
      "chown -R nextjs:nodejs /app/.next",
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "${var.registry_host}/hashicafe-store-frontend"
      tags       = concat(var.extra_tags, [local.timestamp_cleaned, "latest"])
    }

    post-processor "docker-push" {
      ecr_login    = var.registry_is_ecr
      login_server = var.registry_host
    }
  }
}

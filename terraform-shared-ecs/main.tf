terraform {
  required_version = ">= 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Service = "ecs"
      App     = var.cluster_name
    }
  }
}

module "ecs-fargate-cluster" {
  source             = "app.terraform.io/HashiCafe-inc/ecs-fargate-cluster/aws"
  version            = "1.0.1"
  cluster_name       = var.cluster_name
  container_insights = true
}

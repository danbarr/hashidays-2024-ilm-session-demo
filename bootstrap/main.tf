terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.55.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.90.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11.1"
    }
  }

  cloud {
    # Set TF_CLOUD_ORGANIZATION and optionally TF_CLOUD_PROJECT in your environment
    workspaces {
      tags = ["demo", "hcp", "terraform", "waypoint"]
    }
  }
}

provider "tfe" {
  organization = var.hcp_terraform_organization
}

provider "hcp" {}

data "tfe_organization" "current" {}

data "tfe_github_app_installation" "selected" {
  name = var.github_username
}

resource "tfe_project" "waypoint_shared" {
  name        = "Waypoint-Shared-Infra"
  description = "Shared services for HCP Waypoint applications"
}

resource "tfe_project" "waypoint_apps" {
  name        = "Waypoint-Apps"
  description = "HCP Waypoint applications are provisioned here"
}

resource "tfe_team" "waypoint_shared" {
  name = "waypoint-shared-readers"
}

resource "tfe_team_project_access" "waypoint_shared_reader" {
  team_id    = tfe_team.waypoint_shared.id
  project_id = tfe_project.waypoint_shared.id
  access     = "custom"

  workspace_access {
    runs           = "read"
    state_versions = "read-outputs"
  }
}

resource "tfe_team_token" "waypoint_shared_reader" {
  team_id = tfe_team.waypoint_shared.id
}

resource "tfe_workspace" "shared_ecs" {
  name        = "hashidays2024-waypoint-shared-ecs"
  description = "Shared ECS cluster and ALB for HCP Waypoint developer apps"
  project_id  = tfe_project.waypoint_shared.id

  vcs_repo {
    github_app_installation_id = data.tfe_github_app_installation.selected.id
    identifier                 = "${var.github_username}/hashidays-2024-ilm-session-demo"
  }

  working_directory = "terraform-shared-ecs/"
  trigger_patterns  = ["/terraform-shared-ecs"]
  terraform_version = "~>1.8.0"
  queue_all_runs    = false
}

resource "tfe_variable" "shared_ecs_cluster_name" {
  key          = "cluster_name"
  value        = var.ecs_cluster_name
  category     = "terraform"
  workspace_id = tfe_workspace.shared_ecs.id
}

resource "tfe_variable" "shared_ecs_region" {
  key          = "region"
  value        = var.aws_region
  category     = "terraform"
  workspace_id = tfe_workspace.shared_ecs.id
}

resource "tfe_variable" "shared_ecs_route53_zone" {
  key          = "route53_zone_name"
  value        = var.route53_zone
  category     = "terraform"
  workspace_id = tfe_workspace.shared_ecs.id
}

resource "tfe_variable_set" "waypoint_shared" {
  name     = "HCP Waypoint Shared Infrastructure"
  global   = false
  priority = false
}

resource "tfe_project_variable_set" "waypoint_shared" {
  variable_set_id = tfe_variable_set.waypoint_shared.id
  project_id      = tfe_project.waypoint_apps.id
}

resource "tfe_variable" "shared_ecs_workspace_name" {
  key             = "TF_VAR_shared_ecs_workspace_name"
  value           = tfe_workspace.shared_ecs.name
  category        = "env"
  variable_set_id = tfe_variable_set.waypoint_shared.id
}

resource "tfe_variable" "tf_organization_name" {
  key             = "TFE_ORGANIZATION"
  value           = data.tfe_organization.current.name
  category        = "env"
  variable_set_id = tfe_variable_set.waypoint_shared.id
}

resource "tfe_variable" "tf_token" {
  key             = "TFE_TOKEN"
  value           = tfe_team_token.waypoint_shared_reader.token
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.waypoint_shared.id
}

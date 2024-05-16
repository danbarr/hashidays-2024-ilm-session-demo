locals {
  waypoint_ecs_service_variables = [
    {
      name          = "hcp_packer_bucket_name"
      options       = ["hashicafe-store-frontend"]
      variable_type = "string"
      user_editable = false
    },
    {
      name          = "hcp_packer_channel"
      options       = ["development", "latest", "staging", "production"]
      variable_type = "string"
      user_editable = true
    },
    {
      name          = "shared_ecs_workspace_name"
      options       = [tfe_workspace.shared_ecs.name]
      variable_type = "string"
      user_editable = false
    },
  ]
}

resource "tfe_registry_module" "waypoint_ecs_service" {
  vcs_repo {
    display_identifier         = "${var.github_username}/terraform-aws-waypoint-ecs-frontend-service"
    identifier                 = "${var.github_username}/terraform-aws-waypoint-ecs-frontend-service"
    github_app_installation_id = data.tfe_github_app_installation.selected.id
    branch                     = "main"
  }

  test_config {
    tests_enabled = var.enable_module_tests
  }
}

# The tfe_registry_module resource does not wait for the first version to ingress, 
# so we need to wait before moving on to the no-code settings.
resource "time_sleep" "module_ingress_delay" {
  create_duration = "10s"

  depends_on = [tfe_registry_module.waypoint_ecs_service]
}

resource "tfe_no_code_module" "waypoint_ecs_service" {
  enabled         = true
  registry_module = tfe_registry_module.waypoint_ecs_service.id

  dynamic "variable_options" {
    for_each = toset(local.waypoint_ecs_service_variables)

    content {
      name    = variable_options.value["name"]
      type    = variable_options.value["variable_type"]
      options = variable_options.value["options"]
    }
  }

  depends_on = [time_sleep.module_ingress_delay]
}

locals {
  template_markdown = <<-EOT
    # HashiCafe Store Frontend
    
    Your development instance of the HashiCafe store frontend service is now active in ECS!

    The deployed website application is available at the `service_url` output below.

    To update and re-deploy the container:
    
    1. Update your application code in the app repo. Upon merge to main, the container will automatically re-build and publish to ECR and HCP Packer.
    1. Run the `Promote-Frontend-to-Dev` action to promote the new container version into the development channel.
    1. Re-apply the `{{.ApplicationName}}` workspace in HCP Terraform.

    You can also trigger a manual rebuild of the container using the `Rebuild-Frontend-Container` action.
    EOT
}

resource "hcp_waypoint_application_template" "ecs_service" {
  name                     = "Store-Frontend-ECS"
  summary                  = "Deploys an ECS task with the HashiCafe store frontend service"
  description              = "This template deploys the hashicafe-store-frontend app as a service on the shared development ECS environment, registered to an ALB for ingress access."
  readme_markdown_template = base64encode(local.template_markdown)

  labels = ["ecs", "frontend", "dev"]

  terraform_cloud_workspace_details = {
    name                 = tfe_project.waypoint_apps.name
    terraform_project_id = tfe_project.waypoint_apps.id
  }

  terraform_no_code_module = {
    source  = "${tfe_registry_module.waypoint_ecs_service.registry_name}/${tfe_registry_module.waypoint_ecs_service.namespace}/${tfe_registry_module.waypoint_ecs_service.name}/${tfe_registry_module.waypoint_ecs_service.module_provider}"
    version = tfe_no_code_module.waypoint_ecs_service.version_pin
  }

  variable_options = local.waypoint_ecs_service_variables
}

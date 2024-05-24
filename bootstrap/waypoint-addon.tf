locals {
  # waypoint_ecs_s3_addon_variables = [
  #   {
  #     name          = "expired_version_retention_days"
  #     options       = [14, 30, 60, 90]
  #     variable_type = "number"
  #     user_editable = true
  #   },
  #   {
  #     name          = "region"
  #     options       = ["us-east-2", "eu-central-1", "ap-southeast-2"]
  #     variable_type = "string"
  #     user_editable = true
  #   }
  # ]

  # Workaroud since user-editable values are not fully implemented for add-ons
  waypoint_ecs_s3_addon_variables = [
    {
      name          = "expired_version_retention_days"
      options       = [30]
      variable_type = "number"
      user_editable = false
    },
    {
      name          = "region"
      options       = ["eu-central-1"]
      variable_type = "string"
      user_editable = false
    }
  ]
}

resource "tfe_registry_module" "waypoint_ecs_s3_addon" {
  vcs_repo {
    display_identifier         = "${var.github_username}/terraform-aws-waypoint-addon-s3-for-ecs"
    identifier                 = "${var.github_username}/terraform-aws-waypoint-addon-s3-for-ecs"
    github_app_installation_id = data.tfe_github_app_installation.selected.id
    branch                     = "main"
  }

  test_config {
    tests_enabled = var.enable_module_tests
  }
}

# The tfe_registry_module resource does not wait for the first version to ingress, 
# so we need to wait before moving on to the no-code settings.
resource "time_sleep" "addon_ingress_delay" {
  create_duration = "10s"

  depends_on = [tfe_registry_module.waypoint_ecs_s3_addon]
}

resource "tfe_no_code_module" "waypoint_ecs_s3_addon" {
  enabled         = true
  registry_module = tfe_registry_module.waypoint_ecs_s3_addon.id

  dynamic "variable_options" {
    for_each = toset(local.waypoint_ecs_s3_addon_variables)

    content {
      name    = variable_options.value["name"]
      type    = variable_options.value["variable_type"]
      options = variable_options.value["options"]
    }
  }

  depends_on = [time_sleep.addon_ingress_delay]
}

resource "hcp_waypoint_add_on_definition" "ecs_s3" {
  name                     = "s3-bucket-for-ecs"
  summary                  = "S3 bucket for an ECS service"
  description              = "This add-on creates an S3 bucket and attaches an access policy to your ECS task role for workload access."
  readme_markdown_template = base64encode("Your S3 bucket `{{.AddOnName}}` is ready and accessible from your ECS task container.")

  labels = ["s3", "ecs"]

  terraform_cloud_workspace_details = {
    # Blank values default to the project containing the application
    name                 = ""
    terraform_project_id = ""
  }

  terraform_no_code_module = {
    source  = "${tfe_registry_module.waypoint_ecs_s3_addon.registry_name}/${tfe_registry_module.waypoint_ecs_s3_addon.namespace}/${tfe_registry_module.waypoint_ecs_s3_addon.name}/${tfe_registry_module.waypoint_ecs_s3_addon.module_provider}"
    version = tfe_no_code_module.waypoint_ecs_s3_addon.version_pin
  }

  variable_options = local.waypoint_ecs_s3_addon_variables
}

output "shared_infra_project_id" {
  description = "ID of the shared infrastructure project in HCP Terraform."
  value       = tfe_project.waypoint_shared.id
}

output "apps_project_id" {
  description = "ID of the Waypoint applications project in HCP Terraform."
  value       = tfe_project.waypoint_apps.id
}

output "shared_ecs_workspace_id" {
  description = "ID of the shared ECS cluster workspace in HCP Terraform."
  value       = tfe_workspace.shared_ecs.id
}

output "no_code_module_version" {
  description = "Version of the module that no-code provisioning is currently pinned to."
  value       = tfe_no_code_module.waypoint_ecs_service.version_pin
}

output "hcp_waypoint_template_id" {
  description = "ID of the HCP Waypoint template."
  value       = hcp_waypoint_application_template.ecs_service.id
}

output "hcp_waypoint_addon_id" {
  description = "ID of the HCP Waypoint addon."
  value       = hcp_waypoint_add_on_definition.ecs_s3.id
}

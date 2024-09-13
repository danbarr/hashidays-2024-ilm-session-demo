<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | ~> 0.90.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.55.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.11.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | ~> 0.90.0 |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | ~> 0.55.0 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.11.1 |

## Resources

| Name | Type |
|------|------|
| [hcp_waypoint_add_on_definition.ecs_s3](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/waypoint_add_on_definition) | resource |
| [hcp_waypoint_application_template.ecs_service](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/waypoint_application_template) | resource |
| [tfe_no_code_module.waypoint_ecs_s3_addon](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/no_code_module) | resource |
| [tfe_no_code_module.waypoint_ecs_service](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/no_code_module) | resource |
| [tfe_project.waypoint_apps](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project) | resource |
| [tfe_project.waypoint_shared](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project) | resource |
| [tfe_project_variable_set.waypoint_shared](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project_variable_set) | resource |
| [tfe_registry_module.waypoint_ecs_s3_addon](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/registry_module) | resource |
| [tfe_registry_module.waypoint_ecs_service](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/registry_module) | resource |
| [tfe_team.waypoint_shared](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team) | resource |
| [tfe_team_project_access.waypoint_shared_reader](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team_project_access) | resource |
| [tfe_team_token.waypoint_shared_reader](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team_token) | resource |
| [tfe_variable.shared_ecs_cluster_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.shared_ecs_region](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.shared_ecs_route53_zone](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.shared_ecs_workspace_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tf_organization_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tf_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable_set.waypoint_shared](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) | resource |
| [tfe_workspace.shared_ecs](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |
| [time_sleep.addon_ingress_delay](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.module_ingress_delay](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [tfe_github_app_installation.selected](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/github_app_installation) | data source |
| [tfe_organization.current](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_username"></a> [github\_username](#input\_github\_username) | Your GitHub username. Used to find your GitHub App installation in HCP Terraform. | `string` | n/a | yes |
| <a name="input_hcp_terraform_organization"></a> [hcp\_terraform\_organization](#input\_hcp\_terraform\_organization) | The name of your HCP Terraform organization. | `string` | n/a | yes |
| <a name="input_route53_zone"></a> [route53\_zone](#input\_route53\_zone) | Your Amazon Route 53 hosted DNS zone name. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which to deploy the shared Amazon ECS infrastructure. | `string` | `"us-east-2"` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | Name for the shared Amazon ECS cluster. | `string` | `"hashidays2024"` | no |
| <a name="input_enable_module_tests"></a> [enable\_module\_tests](#input\_enable\_module\_tests) | Whether to enable tests on the private registry module. If you enable this, you must manually add your AWS credentials as environment variables on the module. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apps_project_id"></a> [apps\_project\_id](#output\_apps\_project\_id) | ID of the Waypoint applications project in HCP Terraform. |
| <a name="output_hcp_waypoint_addon_id"></a> [hcp\_waypoint\_addon\_id](#output\_hcp\_waypoint\_addon\_id) | ID of the HCP Waypoint addon. |
| <a name="output_hcp_waypoint_template_id"></a> [hcp\_waypoint\_template\_id](#output\_hcp\_waypoint\_template\_id) | ID of the HCP Waypoint template. |
| <a name="output_no_code_module_version"></a> [no\_code\_module\_version](#output\_no\_code\_module\_version) | Version of the module that no-code provisioning is currently pinned to. |
| <a name="output_shared_ecs_workspace_id"></a> [shared\_ecs\_workspace\_id](#output\_shared\_ecs\_workspace\_id) | ID of the shared ECS cluster workspace in HCP Terraform. |
| <a name="output_shared_infra_project_id"></a> [shared\_infra\_project\_id](#output\_shared\_infra\_project\_id) | ID of the shared infrastructure project in HCP Terraform. |
<!-- END_TF_DOCS -->
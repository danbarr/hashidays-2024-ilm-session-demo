variable "hcp_terraform_organization" {
  type        = string
  description = "The name of your HCP Terraform organization."
}

variable "github_username" {
  type        = string
  description = "Your GitHub username. Used to find your GitHub App installation in HCP Terraform."
}

variable "enable_module_tests" {
  type        = bool
  description = "Whether to enable tests on the private registry module. If you enable this, you must manually add your AWS credentials as environment variables on the module."
  default     = false
}

variable "aws_region" {
  type        = string
  description = "The AWS region in which to deploy the shared Amazon ECS infrastructure."
  default     = "us-east-2"
}

variable "route53_zone" {
  type        = string
  description = "Your Amazon Route 53 hosted DNS zone name."
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name for the shared Amazon ECS cluster."
  default     = "hashidays2024"
}

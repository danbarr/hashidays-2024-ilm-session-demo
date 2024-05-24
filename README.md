# Demo repo for HashiDays 2024 session "Unlocking Infrastructure Lifeycle Management"

This demo was built for the HashiDays 2024 session "Unlocking Infrastructure Lifeycle Management". It is designed to be used with these Terraform no-code modules:

- Module for Waypoint template: [terraform-aws-waypoint-ecs-frontend-service](https://github.com/danbarr/terraform-aws-waypoint-ecs-frontend-service)
- Module for Waypoint add-on: [terraform-aws-waypoint-addon-s3-for-ecs](https://github.com/danbarr/terraform-aws-waypoint-addon-s3-for-ecs)

## Prerequisites

- A [HashiCorp Cloud Platform (HCP) account](https://developer.hashicorp.com/hcp/docs/hcp/create-account) with HCP Packer and HCP Waypoint activated and [connected](https://developer.hashicorp.com/hcp/docs/waypoint/configure-hcp-terraform-integration) to your HCP Terraform organization

- An [HCP Terraform organization](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-sign-up) with Plus tier licensing (required for the no-code provisioning feature)

- An AWS account with a Route 53 public hosted zone
  - AWS credentials must be available in your HCP Terraform organization, usually a global variable set or connected to the projects this demo will create. I recommend using [dynamic provider credentials](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration).

Note this demo creates resources which are not part of the AWS Free Tier. You are responsible for any incurred costs.

To use the bootstrap configuration to set up this demo in your organization, you must also:

- Authorize HCP Terraform to your GitHub account via [GitHub App integration](https://developer.hashicorp.com/terraform/cloud-docs/vcs/github-app)

- Ensure appropriate credentials are attached to the HCP Terraform projects created for the demo via global or project-scoped variable set(s):
  - AWS credentials with access to manage VPCs, ECS, ECR, ELBs, CloudWatch, and Route 53
  - HCP token with contributor role on your HCP project

## Components

### Packer templates

The Packer templates illustrate a simple ancestry relationship with a golden base image and an app-specific child image. This repository includes GitHub Actions workflows to automate the build/publishing process, and also to demonstrate on-demand invocation via HCP Waypoint actions. A self-managed runner is used to facilitate access to Amazon ECR.

- `packer-base-nodejs` - Builds a base "hardened" Node.js 20 parent container.
- `packer-store-frontend` - Builds an application child container using the HashiCups demo app frontend component.

### Application code

- `apps/store-frontend` - A version of the [HashiCups frontend](https://github.com/hashicorp-demoapp/frontend) demo app with updated dependencies for Node.js 20.

### Shared infrastructure

- `terraform-shared-ecs` - Provisions an AWS ECS cluster and ALB in a dedicated VPC, to be used as a shared environment for HCP Waypoint application instances to live. Must be deployed as an HCP Terraform workspace because the output values are read by the module used for the HCP Waypoint template.

### Demo bootstrap

- `bootstrap` - Creates the necessary resources in HCP Terraform and HCP Waypoint for this demo.

### Related

- Terraform module `terraform-aws-waypoint-ecs-frontend-service` - A Terraform no-code module built for use as an HCP Waypoint template. Consumes the outputs from the HCP Terraform workspace where you host the `terraform-shared-ecs` infrastructure. Managed in its own repo due to private registry publishing requirements - <https://github.com/danbarr/terraform-aws-waypoint-ecs-frontend-services>

- Terraform module `terraform-aws-waypoint-addon-s3-for-ecs` - A Terraform no-code module built for use as an HCP Waypoint add-on. Adds an S3 bucket and attaches an IAM policy to the ECS task role from the associated Waypoint application. Managed in its own repo due to private registry publishing requirements - <https://github.com/danbarr/terraform-aws-waypoint-addon-s3-for-ecs>

## Credits

HashiCups demo app - <https://github.com/hashicorp-demoapp>

Packer GitHub Action - <https://github.com/hashicorp/setup-packer>

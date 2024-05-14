# Demo repo for HashiDays 2024 session "Unlocking Infrastructure Lifeycle Management"

Watch this space!

## Prerequisites

- A [HashiCorp Cloud Platform (HCP) account](https://developer.hashicorp.com/hcp/docs/hcp/create-account) with HCP Packer and HCP Waypoint activated
- An [HCP Terraform organization](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-sign-up) with Plus tier licensing
- An AWS account with a Route 53 public hosted zone

Note this demo creates resources which are not part of the AWS Free Tier. You are responsible for any incurred costs.

## Components

### Packer templates

The Packer templates illustrate a simple ancestry relationship with a golden base image and an app-specific child image. This repository includes GitHub Actions workflows to automate the build/publishing process, and also to demonstrate on-demand invocation via HCP Waypoint actions. A self-managed runner is used to facilitate access to Amazon ECR.

- `packer-base-nodejs` - Builds a base "hardened" Node.js 20 parent container.
- `packer-store-frontend` - Builds an application child container using the HashiCups demo app frontend component.

### Application code

- `apps/store-frontend` - A version of the [HashiCups frontend](https://github.com/hashicorp-demoapp/frontend) demo app with updated dependencies for Node.js 20.

### Shared infrastructure

- `terraform-shared-ecs` - Provisions an AWS ECS cluster and ALB in a dedicated VPC, to be used as a shared environment for HCP Waypoint application instances to live. Must be deployed as an HCP Terraform workspace because the output values are read by the module used for the HCP Waypoint template.

### Related

- Terraform module `terraform-aws-waypoint-ecs-frontend-service` - A Terraform no-code module built for HCP Waypoint. Consumes the outputs from the HCP Terraform workspace where you host the `terraform-shared-ecs` infrastructure. Managed in its own repo to conform with private registry publishing requirements - <https://github.com/danbarr/terraform-aws-waypoint-ecs-frontend-services>

## Credits

HashiCups demo app - <https://github.com/hashicorp-demoapp>

Packer GitHub Action - <https://github.com/hashicorp/setup-packer>

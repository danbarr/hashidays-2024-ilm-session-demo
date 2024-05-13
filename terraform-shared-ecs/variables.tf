variable "region" {
  type        = string
  description = "AWS region where resources are created."
}

variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster. This is also used as the DNS hostname and the base for other resource names."
}

variable "route53_zone_name" {
  type        = string
  description = "Name of the Route53 zone where the DNS record will be created."
}

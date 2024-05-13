output "region" {
  description = "The AWS region used."
  value       = var.region
}

output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "vpc_private_subnets" {
  description = "ID of private subnets."
  value       = [for id in module.vpc.private_subnets : id]
}

output "vpc_public_subnets" {
  description = "ID and CIDR of public subnets."
  value       = [for id in module.vpc.public_subnets : id]
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster."
  value       = module.ecs-fargate-cluster.cluster_arn
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.ecs_frontend.arn
}

output "alb_domain" {
  description = "DNS domain name of the frontend Application Load Balancer."
  value       = local.dns_subdomain
}

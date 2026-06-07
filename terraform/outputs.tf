output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "alb_dns_name" {
  description = "Public DNS of the backend load balancer"
  value       = module.compute.alb_dns_name
}

output "frontend_bucket_name" {
  description = "S3 bucket hosting the frontend"
  value       = module.storage.frontend_bucket_name
}

output "cloudfront_domain_name" {
  description = "CloudFront URL for the frontend"
  value       = module.storage.cloudfront_domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (for cache invalidation)"
  value       = module.storage.cloudfront_distribution_id
}

output "redis_endpoint" {
  description = "ElastiCache Redis primary endpoint"
  value       = module.compute.redis_endpoint
}

output "app_log_group" {
  description = "CloudWatch log group for application logs"
  value       = module.monitoring.app_log_group_name
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

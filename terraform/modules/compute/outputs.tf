output "alb_dns_name" { value = aws_lb.this.dns_name }
output "alb_arn" { value = aws_lb.this.arn }
output "asg_name" { value = aws_autoscaling_group.backend.name }
output "redis_endpoint" { value = aws_elasticache_cluster.redis.cache_nodes[0].address }
output "target_group_arn" { value = aws_lb_target_group.backend.arn }

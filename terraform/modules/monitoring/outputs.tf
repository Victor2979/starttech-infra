output "app_log_group_name" { value = aws_cloudwatch_log_group.app.name }
output "instance_profile_name" { value = aws_iam_instance_profile.ec2.name }
output "ec2_role_arn" { value = aws_iam_role.ec2.arn }

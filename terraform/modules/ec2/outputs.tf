output "asg_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.main.name
}

output "asg_arn" {
  description = "Auto Scaling Group ARN"
  value       = aws_autoscaling_group.main.arn
}

output "launch_template_id" {
  description = "Launch template ID"
  value       = aws_launch_template.main.id
}

output "log_group_arn" {
  description = "CloudWatch log group ARN"
  value       = aws_cloudwatch_log_group.app.arn
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.app.name
}

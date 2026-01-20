output "alb_dns_name" {
  description = "ALB DNS name - Use this to access your application"
  value       = module.alb.alb_dns_name
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.ec2.asg_name
}

output "codedeploy_app_name" {
  description = "CodeDeploy application name"
  value       = module.codedeploy.codedeploy_app_name
}

output "deployment_group_name" {
  description = "CodeDeploy deployment group name"
  value       = module.codedeploy.deployment_group_name
}

output "deployment_bucket_name" {
  description = "S3 deployment bucket name"
  value       = module.codedeploy.deployment_bucket_name
}

output "github_actions_role_arn" {
  description = "GitHub Actions IAM role ARN - Use this in CI/CD pipeline"
  value       = module.iam.github_actions_role_arn
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = module.ec2.log_group_name
}

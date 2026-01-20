output "deployment_bucket_name" {
  description = "S3 deployment bucket name"
  value       = aws_s3_bucket.deployment.id
}

output "deployment_bucket_arn" {
  description = "S3 deployment bucket ARN"
  value       = aws_s3_bucket.deployment.arn
}

output "codedeploy_app_name" {
  description = "CodeDeploy application name"
  value       = aws_codedeploy_app.main.name
}

output "codedeploy_app_arn" {
  description = "CodeDeploy application ARN"
  value       = aws_codedeploy_app.main.arn
}

output "deployment_group_name" {
  description = "CodeDeploy deployment group name"
  value       = aws_codedeploy_deployment_group.main.deployment_group_name
}

output "deployment_group_arn" {
  value = aws_codedeploy_deployment_group.main.arn
}


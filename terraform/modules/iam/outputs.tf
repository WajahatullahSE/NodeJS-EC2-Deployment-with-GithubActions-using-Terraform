output "ec2_instance_profile_name" {
  description = "EC2 instance profile name"
  value       = aws_iam_instance_profile.ec2.name
}

output "ec2_instance_role_arn" {
  description = "EC2 instance role ARN"
  value       = aws_iam_role.ec2_instance.arn
}

output "codedeploy_service_role_arn" {
  description = "CodeDeploy service role ARN"
  value       = aws_iam_role.codedeploy.arn
}

output "github_actions_role_arn" {
  description = "GitHub Actions role ARN"
  value       = aws_iam_role.github_actions.arn
}

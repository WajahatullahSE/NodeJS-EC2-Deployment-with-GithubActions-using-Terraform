variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "deployment_bucket_arn" {
  description = "S3 deployment bucket ARN"
  type        = string
}

variable "log_group_arn" {
  description = "CloudWatch log group ARN"
  type        = string
}

variable "github_oidc_provider_arn" {
  description = "GitHub OIDC provider ARN"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository in org/repo format"
  type        = string
}

variable "codedeploy_app_arn" {
  description = "CodeDeploy application ARN"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "codedeploy_deployment_group_arn" {
  type = string
}

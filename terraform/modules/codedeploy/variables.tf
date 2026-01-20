variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "codedeploy_service_role_arn" {
  description = "CodeDeploy service role ARN"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group name"
  type        = string
}

variable "target_group_name" {
  description = "ALB target group name"
  type        = string
}

variable "deployment_config_name" {
  description = "CodeDeploy deployment configuration"
  type        = string
  default     = "CodeDeployDefault.OneAtATime"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

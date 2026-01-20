variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}

variable "ec2_security_group_id" {
  description = "EC2 security group ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "user_data_script_path" {
  description = "Path to user data script"
  type        = string
}

variable "github_repo_url" {
  description = "GitHub repository URL"
  type        = string
}

variable "app_port" {
  description = "Application port"
  type        = number
}

variable "asg_min_size" {
  description = "ASG minimum size"
  type        = number
}

variable "asg_max_size" {
  description = "ASG maximum size"
  type        = number
}

variable "asg_desired_size" {
  description = "ASG desired size"
  type        = number
}

variable "cpu_target_value" {
  description = "Target CPU utilization for scaling"
  type        = number
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

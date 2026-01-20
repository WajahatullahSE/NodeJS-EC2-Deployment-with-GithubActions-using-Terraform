variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "app_port" {
  description = "Application port"
  type        = number
}

variable "health_check_path" {
  description = "Health check path"
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

variable "github_repo" {
  description = "GitHub repository in org/repo format"
  type        = string
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
  description = "Target CPU utilization percentage for scaling"
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

variable "deployment_config_name" {
  description = "CodeDeploy deployment configuration"
  type        = string
}

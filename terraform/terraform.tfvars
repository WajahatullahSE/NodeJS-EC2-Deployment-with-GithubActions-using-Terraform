project_name = "wu-node-app"
environment  = "dev"
region       = "us-west-2"

# VPC Configuration
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-west-2a", "us-west-2b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

# EC2 Configuration
ami_id        = "ami-0a864d7e31fe76819"  
instance_type = "t3.small"

# Application Configuration
app_port          = 8081
health_check_path = "/"

# GitHub Configuration
github_repo_url = "https://github.com/WajahatullahSE/NodeJS-EC2-Deployment-with-GithubActions-using-Terraform.git"
github_repo     = "WajahatullahSE/NodeJS-EC2-Deployment-with-GithubActions-using-Terraform"

# User Data Script (place this file in your repo at: scripts/setup.sh)
user_data_script_path = "./scripts/setup.sh"

# Auto Scaling Configuration
asg_min_size     = 2
asg_max_size     = 4
asg_desired_size = 2
cpu_target_value = 85.0

# Logging Configuration
log_group_name     = "/aws/ec2/wu-node-app"
log_retention_days = 7

# CodeDeploy Configuration
deployment_config_name = "CodeDeployDefault.HalfAtATime"  # Options: OneAtATime, HalfAtATime, AllAtOnce

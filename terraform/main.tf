# Root Module - Main Infrastructure

# Wires all modules together to create complete infrastructure

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}
provider "aws" {
  region = var.region 
}

# Common tags for all resources
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# OIDC for Github
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = local.common_tags
}

# Security Module
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  app_port     = var.app_port
  tags         = local.common_tags
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  project_name           = var.project_name
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids
  alb_security_group_id  = module.security.alb_security_group_id
  app_port               = var.app_port
  health_check_path      = var.health_check_path
  tags                   = local.common_tags
}

# EC2 Module (includes ASG and Launch Template)
module "ec2" {
  source = "./modules/ec2"

  project_name           = var.project_name
  region                 = var.region
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  instance_profile_name  = module.iam.ec2_instance_profile_name
  ec2_security_group_id  = module.security.ec2_security_group_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  target_group_arn       = module.alb.target_group_arn
  user_data_script_path  = var.user_data_script_path
  github_repo_url        = var.github_repo_url
  app_port               = var.app_port
  asg_min_size           = var.asg_min_size
  asg_max_size           = var.asg_max_size
  asg_desired_size       = var.asg_desired_size
  cpu_target_value       = var.cpu_target_value
  log_group_name         = var.log_group_name
  log_retention_days     = var.log_retention_days
  tags                   = local.common_tags
}

# CodeDeploy Module (includes S3 bucket)
module "codedeploy" {
  source = "./modules/codedeploy"

  project_name               = var.project_name
  codedeploy_service_role_arn = module.iam.codedeploy_service_role_arn
  asg_name                   = module.ec2.asg_name
  target_group_name          = module.alb.target_group_name
  deployment_config_name     = var.deployment_config_name
  tags                       = local.common_tags
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  project_name              = var.project_name
  deployment_bucket_arn     = module.codedeploy.deployment_bucket_arn
  codedeploy_deployment_group_arn   = module.codedeploy.deployment_group_arn
  log_group_arn             = module.ec2.log_group_arn
  github_oidc_provider_arn  = data.aws_iam_openid_connect_provider.github.arn
  github_repo               = var.github_repo
  codedeploy_app_arn        = module.codedeploy.codedeploy_app_arn
  tags                      = local.common_tags
}

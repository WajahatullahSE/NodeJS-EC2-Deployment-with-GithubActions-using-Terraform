# CodeDeploy Module
# Creates S3 bucket, CodeDeploy application and deployment group

# S3 Bucket for deployment artifacts
resource "aws_s3_bucket" "deployment" {
  bucket = "${var.project_name}-deployment-bucket"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-deployment-bucket"
    }
  )
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "deployment" {
  bucket = aws_s3_bucket.deployment.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "deployment" {
  bucket = aws_s3_bucket.deployment.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "deployment" {
  bucket = aws_s3_bucket.deployment.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CodeDeploy Application
resource "aws_codedeploy_app" "main" {
  name             = "${var.project_name}-app"
  compute_platform = "Server"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-codedeploy-app"
    }
  )
}

# CodeDeploy Deployment Group
resource "aws_codedeploy_deployment_group" "main" {
  app_name              = aws_codedeploy_app.main.name
  deployment_group_name = "${var.project_name}-deployment-group"
  service_role_arn      = var.codedeploy_service_role_arn

  deployment_config_name = var.deployment_config_name

  # Auto Scaling Groups
  autoscaling_groups = [var.asg_name]

  # Load Balancer Info
  load_balancer_info {
    target_group_info {
      name = var.target_group_name
    }
  }

  # Auto Rollback Configuration
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-deployment-group"
    }
  )
}

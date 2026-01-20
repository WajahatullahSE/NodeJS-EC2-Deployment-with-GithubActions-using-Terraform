# IAM Module - Roles and Policies

# Creates IAM roles for EC2 instances and CodeDeploy

# EC2 Instance Role - Used by EC2 instances
resource "aws_iam_role" "ec2_instance" {
  name = "${var.project_name}-ec2-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ec2-instance-role"
    }
  )
}

# EC2 Instance Policy - S3, CloudWatch, SSM permissions
resource "aws_iam_role_policy" "ec2_instance_policy" {
  name = "${var.project_name}-ec2-instance-policy"
  role = aws_iam_role.ec2_instance.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 access for CodeDeploy artifacts
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.deployment_bucket_arn,
          "${var.deployment_bucket_arn}/*"
        ]
      },
      # CloudWatch Logs
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "${var.log_group_arn}:*"
      },
      # CloudWatch Agent
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach AWS managed policy for SSM (for debugging and management)
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-ec2-instance-profile"
  role = aws_iam_role.ec2_instance.name

  tags = var.tags
}

# CodeDeploy Service Role
resource "aws_iam_role" "codedeploy" {
  name = "${var.project_name}-codedeploy-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codedeploy.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-codedeploy-service-role"
    }
  )
}

# Attach AWS managed policy for CodeDeploy
resource "aws_iam_role_policy_attachment" "codedeploy_service" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# Additional Auto Scaling permissions for CodeDeploy
resource "aws_iam_role_policy" "codedeploy_autoscaling" {
  name = "${var.project_name}-codedeploy-autoscaling-policy"
  role = aws_iam_role.codedeploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:CompleteLifecycleAction",
          "autoscaling:DeleteLifecycleHook",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeLifecycleHooks",
          "autoscaling:PutLifecycleHook",
          "autoscaling:RecordLifecycleActionHeartbeat"
        ]
        Resource = "*"
      }
    ]
  })
}

# GitHub Actions Role for OIDC authentication
resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.github_oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
        }
      }
    }]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-github-actions-role"
    }
  )
}

# GitHub Actions Policy - S3 upload and CodeDeploy trigger
resource "aws_iam_role_policy" "github_actions_policy" {
  name = "${var.project_name}-github-actions-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 upload for deployment artifacts
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.deployment_bucket_arn,
          "${var.deployment_bucket_arn}/*"
        ]
      },
      # CodeDeploy operations
      {
        Effect = "Allow"
        Action = [
          "codedeploy:CreateDeployment",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:GetApplicationRevision",
          "codedeploy:RegisterApplicationRevision"
        ]
        #Resource = var.codedeploy_deployment_group_arn
        Resource = "*"
      }
    ]
  })
}

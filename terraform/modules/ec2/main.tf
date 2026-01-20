# EC2 Module - Auto Scaling Group
# Creates Launch Template and Auto Scaling Group with target tracking

# CloudWatch Log Group for application logs
resource "aws_cloudwatch_log_group" "app" {
  name              = var.log_group_name
  retention_in_days = var.log_retention_days

  tags = merge(
    var.tags,
    {
      Name = var.log_group_name
    }
  )
}

# Launch Template
resource "aws_launch_template" "main" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [var.ec2_security_group_id]

  # User data script from repository
  user_data = base64encode(templatefile(var.user_data_script_path, {
    project_name    = var.project_name
    github_repo_url = var.github_repo_url
    region          = var.region
    log_group_name  = var.log_group_name
    app_port        = var.app_port
  }))

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.project_name}-instance"
      }
    )
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-launch-template"
    }
  )
}

# Auto Scaling Group
resource "aws_autoscaling_group" "main" {
  name                = "${var.project_name}-asg"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [var.target_group_arn]
  #health_check_type   = "ELB"
  health_check_type   = "EC2"
  health_check_grace_period = 300

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_size

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# Target Tracking Scaling Policy - CPU based
resource "aws_autoscaling_policy" "target_tracking" {
  name                   = "${var.project_name}-cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.main.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_target_value
  }
}

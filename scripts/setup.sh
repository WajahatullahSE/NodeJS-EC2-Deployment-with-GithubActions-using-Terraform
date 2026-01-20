#!/bin/bash
# Install software
yum update -y
yum install -y git ruby wget nodejs npm amazon-cloudwatch-agent

npm install -g pm2

# Install CodeDeploy agent
cd /home/ec2-user
wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
chmod +x install
./install auto

systemctl enable codedeploy-agent
systemctl start codedeploy-agent

# Prepare directories
mkdir -p /opt/nodeapp /var/log/nodeapp
chown -R ec2-user:ec2-user /opt/nodeapp /var/log/nodeapp

# CloudWatch agent setup
# Create CloudWatch agent configuration
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/nodeapp/app.log",
            "log_group_name": "${log_group_name}",
            "log_stream_name": "{instance_id}/app.log",
            "timezone": "UTC"
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "${project_name}",
    "metrics_collected": {
      "mem": {
        "measurement": [
          {"name": "mem_used_percent"}
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": [
          {"name": "used_percent"}
        ],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      }
    }
  }
}
EOF

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json


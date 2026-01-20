#!/bin/bash
# Start PM2 application after deployment

set -e

echo "Starting PM2 application..."

cd /opt/nodeapp

# Delete previous PM2 process if exists
pm2 delete nodeapp || true

# Start application with PM2
PORT=8081 pm2 start index.js --name nodeapp --log /var/log/nodeapp/app.log

# Save PM2 process list
pm2 save

echo "Application started successfully"

#!/bin/bash
# Validate that the application is running correctly

set -e

echo "Validating application..."

# Wait for app to start
sleep 10

# Check if PM2 process is running
if pm2 list | grep -q "nodeapp"; then
    echo "PM2 process is running"
else
    echo "ERROR: PM2 process is not running"
    exit 1
fi

# Check if application is responding on port 8081
if curl -f http://localhost:8081/ > /dev/null 2>&1; then
    echo "Application is responding correctly"
else
    echo "ERROR: Application is not responding"
    exit 1
fi

echo "Validation successful"

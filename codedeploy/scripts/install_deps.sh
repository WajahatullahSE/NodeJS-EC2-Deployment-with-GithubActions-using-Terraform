#!/bin/bash
# Install application dependencies

set -e

echo "Installing application dependencies..."

sudo chown -R ec2-user:ec2-user /opt/nodeapp
cd /opt/nodeapp
npm ci --omit=dev

# Install npm dependencies
npm install --production

echo "Dependencies installed successfully"

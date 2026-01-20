#!/bin/bash
# Install application dependencies

set -e

echo "Installing application dependencies..."

cd /opt/nodeapp

# Install npm dependencies
npm install --production

echo "Dependencies installed successfully"

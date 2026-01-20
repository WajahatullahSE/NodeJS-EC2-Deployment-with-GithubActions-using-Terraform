#!/bin/bash
# Clean up before installation

set -e

echo "Cleaning up old application files..."

# Stop PM2 if running
pm2 stop all || true
pm2 delete all || true

# Clean up old files (but keep directory)
cd /opt/nodeapp
rm -rf * .[^.]*

echo "Cleanup complete"
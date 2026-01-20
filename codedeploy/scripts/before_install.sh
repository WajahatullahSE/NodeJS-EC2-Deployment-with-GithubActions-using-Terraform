#!/bin/bash
set -e

echo "Stopping old app (if exists)"
pm2 delete all || true

echo "Cleaning app directory"
rm -rf /opt/nodeapp/*
mkdir -p /opt/nodeapp
chown -R ec2-user:ec2-user /opt/nodeapp

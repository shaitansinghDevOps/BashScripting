#!/bin/bash

echo "Configuration management for frontend in progress"

echo "disbling the nagnix"
dnf module disable nginx -y

echo "enbling nagix"
dnf module enable nginx:1.24 -y

echo "Installing the nagix "
dnf install nginx -y
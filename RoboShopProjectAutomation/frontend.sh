#!/bin/bash

echo "Configuration management for frontend in progress"
ID=$(id-u)
if[$id -ne 0]
do
 echo "script has to excute as root user"
 echo -e "Example usegae \n\t \e[32 sudo bash $0 OR #bash $0 \e[0m"
fi
echo "disbling the nagnix"
dnf module disable nginx -y

echo "enbling nagix"
dnf module enable nginx:1.24 -y

echo "Installing the nagix "
dnf install nginx -y
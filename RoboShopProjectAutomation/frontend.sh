#!/bin/bash

echo "Configuration management for frontend in progress"
ID=$(id -u)
Component="frontend"
if [ $ID -ne 0 ]
then
 echo "script has to excute as root user"
 echo -e "Example usage:\n\t \e[32msudo bash $0 OR bash $0\e[0m"
 exit 1
fi
echo "disbling the nagnix"
dnf module disable nginx -y

echo "enbling nagix"
dnf module enable nginx:1.24 -y

echo "Installing the nagix "
dnf install nginx -y
echo "Dowanloading the UI of $Component "
curl -L -o /tmp/$Component.zip https://stan-robotshop.s3.amazonaws.com/$Component-v3.zip

echo "CleanUp Job"
cd /usr/share/nginx/html
rm -rf *

echo "Unziping the folder"
unzip /tmp/$Component.zip
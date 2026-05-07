#!/bin/bash

echo "Configuration management for frontend in progress"
ID=$(id -u)
Component="frontend"
Log=$("/tmp/${Component}.log")
if [ $ID -ne 0 ]
then
 echo "script has to excute as root user"
 echo -e "Example usage:\n\t \e[32msudo bash $0 OR bash $0\e[0m"
 exit 1
fi
stat()
{
    if [$1 -eq 0]; then
     echo -e "\e[32m sucuess \e[0m"
    else 
      echo -e "\e[33m sucuess \e[0m"
      exit 2
    fi
}
echo "disbling the nagnix"
dnf module disable nginx -y &>> $Log
stat $?

echo "enbling nagix"
dnf module enable nginx:1.24 -y &>> $Log
stat $?

echo "Installing the nagix "
dnf install nginx -y &>> $Log
stat $?

echo "Dowanloading the UI of $Component " &>> $Log
curl -L -o /tmp/$Component.zip https://stan-robotshop.s3.amazonaws.com/$Component-v3.zip &>> $Log
stat $?

echo "CleanUp Job"
cd /usr/share/nginx/html &>> $Log
rm -rf * &>> $Log
stat $?

echo "Unziping the folder"
unzip /tmp/$Component.zip &>> $Log
stat $?
echo "Enbling the $Component servive" 
systemctl enable nginx &>> $Log
stat $?

echo "Starting  the $Component servive" 
systemctl restart nginx &>> $Log
stat $?
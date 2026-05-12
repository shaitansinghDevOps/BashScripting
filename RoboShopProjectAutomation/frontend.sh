#!/bin/bash

echo "Configuration management for monodb in progress"

ID=$(id -u)
COMPONENT="frontend"
LOG="/tmp/${COMPONENT}.log"

if [ $ID -ne 0 ]
then
   echo "Script has to execute as root user"
   echo -e "Example usage:\n\t \e[32msudo bash $0 OR bash $0\e[0m"
   exit 1
fi

stat() {
   if [ $1 -eq 0 ]
   then
      echo -e "\e[32m Success \e[0m"
   else
      echo -e "\e[31m Failure \e[0m"
      exit 2
   fi
}

echo -n "Disabling nginx"
dnf module disable nginx -y &>> $LOG
stat $?

echo -n "Enabling nginx"
dnf module enable nginx:1.24 -y &>> $LOG
stat $?

echo -n "Installing nginx"
dnf install nginx -y &>> $LOG
stat $?

echo -n "Downloading the UI of $COMPONENT"
curl -L -o /tmp/$COMPONENT.zip https://stan-robotshop.s3.amazonaws.com/$COMPONENT-v3.zip &>> $LOG
stat $?

echo -n "Cleanup Job"
cd /usr/share/nginx/html &>> $LOG
rm -rf * &>> $LOG
stat $?

echo -n "Unzipping the folder"
unzip /tmp/$COMPONENT.zip &>> $LOG
stat $?


echo -n "Configuring $COMPONENT proxy file"
cp /home/ec2-user/Roboshop/BashScripting/RoboShopProjectAutomation/nginx.conf /etc/nginx/nginx.conf
stat $?

echo -n "Enabling the $COMPONENT service"
systemctl enable nginx &>> $LOG
stat $?

echo -n "Starting the $COMPONENT service"
systemctl restart nginx &>> $LOG
stat $?
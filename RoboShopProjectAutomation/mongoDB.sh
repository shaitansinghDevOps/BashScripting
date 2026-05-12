#!/bin/bash

echo "Configuration management for frontend in progress"

ID=$(id -u)
COMPONENT="mongodb"
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

echo -n "Configuring the repo:"
cp /home/ec2-user/Roboshop/BashScripting/RoboShopProjectAutomation/mongo.repo /etc/yum.repos.d/mongo.repo
stat $?

echo -n "Installing $COMPONENT:"
dnf install mongodb-org -y  &>> $LOG 
stat $?

echo -n "Updating the $COMPONENT visibility:"
sed -ie 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n "Starting $COMPONENT service:"
systemctl enable mongod
systemctl restart mongod
stat $?

echo -e "\n \t ___ Configuration Management for $COMPONENT in completed! ___"
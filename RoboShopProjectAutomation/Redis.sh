#!/bin/bash

echo "Configuration management for catalogue  in progress"

ID=$(id -u)
COMPONENT="redis"
APPUSER="roboshop"
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



echo -n "Disabling $COMPONENT"
dnf module disable redis -y &>> $LOG
stat $?

echo -n "Enabling $COMPONENT"
dnf module enable redis:7 -y &>> $LOG
stat $?

echo -n "Installing $COMPONENT"
dnf install redis -y &>> $LOG
stat $?


echo -n "Updating the $COMPONENT visiblity"
sed -ie 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $?


echo -n "Enabling the $COMPONENT service"
systemctl enable redis &>> $LOG
stat $?

echo -n "Starting the $COMPONENT service"
systemctl start redis &>> $LOG
systemctl status redis -l &>> $LOG
stat $?


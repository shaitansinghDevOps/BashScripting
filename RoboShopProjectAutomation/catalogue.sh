#!/bin/bash

echo "Configuration management for monodb in progress"

ID=$(id -u)
COMPONENT="catalogue"
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

create_user() {
    id $APPUSER  &>> $LOG
    if [ $? -ne 0 ]; then
        echo -n "Creating roboshop user account :"
        useradd $APPUSER 
        stat $?
    else
        echo -n "SKIPPING"
    fi 
    stat $? 
}

echo -n "Disabling nodejs"
dnf module disable nodejs -y &>> $LOG
# dnf install nodejs -y
stat $?

echo -n "Enabling nodejs"
dnf module enable nodejs:20 -y &>> $LOG
stat $?

echo -n "Installing nodejs"
dnf install nodejs -y &>> $LOG
stat $?

echo -n "Creating the user account"
create_user &>> $LOG
stat $?

echo -n "set up an /app directory to hold app data"
mkdir /app 

echo -n "Performing cleanup of $COMPONENT :"
rm -rf /app/ || true 
stat $?


echo -n "Downloading the UI of $COMPONENT"
curl -L -o /tmp/$COMPONENT.zip https://stan-robotshop.s3.amazonaws.com/$COMPONENT-v3.zip &>> $LOG
stat $?

echo -n "Configuring $COMPONENT proxy file"
cp /home/ec2-user/Roboshop/BashScripting/RoboShopProjectAutomation/${COMPONENT}.service /etc/systemd/system/catalogue.service
stat $?

echo -n "Extracting the $COMPONENT app"
unzip -o /tmp/${COMPONENT}.zip -d /app/  &>> $LOG
stat $?

echo -n "genrating the $COMPONENT Artificats"
cd /app/
npm install &>> LOG
statc $?

echo -n "installing mongodb schema :"
dnf install mongodb-mongosh -y &>> LOG

echo -n "injecting the schemea  :"
mongosh --host mongodb.shoptherobo.shop </app/db/master-data.js



echo -n "Enabling the $COMPONENT service"
systemctl enable $COMPONENT &>> $LOG
stat $?

echo -n "Starting the $COMPONENT service"
systemctl restart $COMPONENT &>> $LOG
stat $?
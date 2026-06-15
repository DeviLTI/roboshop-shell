#!/bin/bash

userid=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Logfolder=/var/logs/roboshop-logs
script_name=$(echo $0 | cut -d '.' -f1)
logfile="$Logfolder/$script_name.log"
Script_dir=$PWD

if [ $userid -ne 0 ]
then 
echo "Run this script with Sudo"
exit 1
else
echo "You are running with sudo"
fi


mkdir -p $Logfolder
echo "script started executing at : $(date)"

validate(){
    if [ $1 -eq 0 ]
    then 
    echo -e "$2 is... $G Success $N"
    else
    echo -e "$2 is ...$R Failed $N"
    exit 1
    fi
}

dnf module disable nodejs -y &>>$logfile
validate $? "Disbaling default nodejs"

dnf module enable nodejs:20 -y &>>$logfile 
validate $? "Enabling nodejs-20"

dnf install nodejs -y &>>$logfile
validate $? "Installing node js"

id roboshop
if [ $? -ne 0 ]
then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$logfile
validate $? "creating system user"
else
echo -e "$Y system user already created. $N"
fi

mkdir -p /app &>>$logfile
validate $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$logfile
validate $? "Downlodaing code"


rm -rf /app/*
cd /app 
unzip /tmp/catalogue.zip &>>$logfile
validate $? " unzipping the code"

cd /app
npm install &>>$logfile
validate $? "dependencies installation"

cp $Script_dir/catalogue.service /etc/systemd/system/catalogue.service &>>$logfile
validate $? "copiying service "

systemctl daemon-reload &>>$logfile
validate $? "reloading the service"

systemctl enable catalogue &>>$logfile 
validate $? "Enabling service"

systemctl start catalogue &>>$logfile
validate $? "strarting Catalogue"


cp $Script_dir/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$logfile
validate $? "copiying mongodb repo"

dnf install mongodb-mongosh -y &>>$logfile
validate $? "installing mongodb client"

STATUS=$(mongosh --host mongodb.daws84s.site --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
mongosh --host MONGODB-SERVER-IPADDRESS </app/db/master-data.js &>>$logfile
validate $? "downloading master data"
else
echo -e " $Y Data already loaded. $N "
fi
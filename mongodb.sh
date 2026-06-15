#!/bin/bash

userid=$(id -u)
R="\e[31m"
Y="\e[32m"
G="\e[33m"
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

cp mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$logfile
validate $? "copiying mongodb repo"

dnf install mongodb-org -y &>>$logfile
validate $? "Installing MongoDB "

systemctl enable mongod -y &>>$logfile
validate $? "Enabling MONGODB"

systemctl start mongod &>>$logfile
validate $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0g' /etc/mongod.conf &>>$logfile
validate $? "changing port number"

systemctl restart mongod -y &>>$logfile
validate $? " Restarting mongoDB"

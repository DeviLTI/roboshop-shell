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

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$logfile
validate $? "copiying repo"

dnf install rabbitmq-server -y &>>$logfile
validate $? "Installing rabbitmq "

systemctl enable rabbitmq-server  &>>$logfile
validate $? "Enabling Rabbitmq"

systemctl start rabbitmq-server &>>$logfile
validate $? "Starting rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>$logfile
validate $? "Creating system user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$logfile
validate $? "setting permissions"


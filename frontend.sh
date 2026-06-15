#!/bin/bash

userid=$(id -u)
R="\e[31m"
Y="\e[32m"
G="\e[33m"
N="\e[0m"

Logfolder="/var/logs/roboshop-logs"
script_name=$(echo $0 | cut -d '.' -f1)
logfile="$Logfolder/$script_name.log"
Script_dir=$PWD
mkdir -p $Logfolder
echo "Script started executing at : $(date)" | tee -a $logfile


if [ $userid -ne 0 ]
then 
echo "Run this script with sudo access" | tee -a $logfile
exit
else
echo "you are running with sudo " | tee -a $logfile


validate(){
    if [ $1 -eq 0 ]
    then 
    echo " $2 is...$G Success $N" | tee -a $logfile
    else
    echo "$2 is ..$R failed $N" | tee -a $logfile
    exit 1
    fi
}

dnf module disable nginx -y &>>$logfile
validate $? "Disabling default nginx " 

dnf module enable nginx:1.24 &>>$logfile
validate $? "Enabling nginx "

dnf install nginx -y &>>$logfile
validate $? "Installing nginx "

systemctl enable nginx  &>>$logfile
validate $? "Enabling service"

systemctlstart nginx &>>$logfile
validate $? "starting nginx serever"

rm -rf /usr/share/nginx/html &>>$logfile
validate $? "Removing default content"

curl -o /temp/frontend.zip  https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$logfile
validate $? "Downloading our frontend code"

cd /usr/share/nginx/html &>>$logfile
unzip /temp/frontend.zip
validate $? "unzipping the new code"
 
rm -rf /etc/nginx/nginx.conf &>>$logfile
validate $? "removing default configuration"

cp $Script_dir/nginx.conf /etc/nginx/nginx.conf &>>$logfile
validate $? "copiying configurations"

systemctlrestart nginx &>>$logfile
validate $? "Restarting nginx "


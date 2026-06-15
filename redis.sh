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

dnf module disable redis -y 
validate $? "disabling default redis"

dnf module enable redis:7 -y 
validate $? "Enabling redis"

dnf install redis -y 
validate $? "Installation of redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
validate $? "changing port and protected mode"

systemctl enable redis 
validate $? "enabling redis"


systemctl start redis 
validate $? "Starting redis"






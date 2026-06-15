#!/bin/bash

userid=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
Logfolder="/var/logs/roboshop-shell"
Script-name= "$(echo ${0} | cut -d '.' -f1)
logfile = "Logfolder/Script-name".log
Script_dir = $PWD

if [ $userid -ne 0 ]
then 
echo "Run this script with root access."
exit 1
else
echo "you are running with root access."
fi


validate(){
    if [ $1 -eq 0 ]
    then
      echo -e "$2 installation ${G} success ${N} " &>>logfile
    else
      echo -e "$2 installation ${R} failed ${N}  " &>>logfile
      exit 1
    fi
}



dnf list installed mysql &>>logfile
if [ $? -ne 0 ]
then
echo "$2 is not installed...going to install  "&>>logfile
    exit 1

    dnf install mysql -y  &>>logfile
    validate $? mysql
else
    echo -e "$2 was already installed.. ${Y} Nothing to do.. ${N} "&>>logfile
fi


#!/bin/bash

userid=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
Logfolder="/var/logs/roboshop-shell"
Scriptname=$(echo ${0} | cut -d '.' -f1)
logfile=Logfolder/Scriptname.log
Scriptdir=$PWD
package=mysql

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
      echo -e "$2 installation ${G} success ${N}" | tee -a logfile
    else
      echo -e "$2 installation ${R} failed ${N}" | tee -a logfile
      exit 1
    fi
}



dnf list installed mysql &>>logfile
if [ $? -ne 0 ]
then
echo "$package is not installed...going to install" | tee -a logfile
dnf install mysql -y  &>>logfile
validate $? mysql
else
    echo -e "$package was already installed.. ${Y} Nothing to do.. ${N}" |tee -a logfile
fi
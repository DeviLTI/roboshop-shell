#!/bin/bash

userid=$(id -u)
R=\e[31m
G=\e[32m
Y=\e[33m
N=\e[0m


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
      echo -e "$2 installation $G success $N"
    else
      echo -e "$2 installation $R failed $N"
      exit 1
    fi
}



dnf list installed mysql
if [ $? -ne 0 ]
then
echo "$2 is not installed...going to install"
    dnf install mysql
    validate( '$?' 'mysql' )
else
    echo -e "$2 was already installed.. $Y Nothing to do $N"
fi


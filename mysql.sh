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

dnf install mysql-server -y &>>$logfile
validate $? "Installing MYSQl"

systemctl enable mysqld -y &>>$logfile
validate $? "Enabling mysql"

systemctl start mysqld -y &>>$logfile
validate $? "Starting mysql "
 
mysql_secure_installation --set-root-pass RoboShop@1
validate $? "Setting mysql root password"

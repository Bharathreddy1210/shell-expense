#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "please enter the DB password::"
read mysql_root_password

VALIDATE() {
        if [ $1 -ne 0 ]
        then 
             echo -e "$2...$R FAILURE $N"
             exit 1
        else 
             echo -e "$2...$G SUCCESS $N"
        fi
}



if [ $USERID -ne 0 ]
then 
   echo -e $R "please login with root user" $N
   exit 1
else
   echo -e $Y "Super User" $N
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing Mysql server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enable mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting mysql server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

mysql -h db.bharathdevops.site -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "mysql root password setup"
else
    echo -e  "password already setup....$G SKIP $N"
fi


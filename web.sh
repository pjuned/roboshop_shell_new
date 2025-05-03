#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGDB_HOST=mongodb.aws76s.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

dnf install nginx -y &>> LOGFILE

validate $? "installing nginx"

systemctl enable nginx &>> LOGFILE

validate $? "enabling nginx"

systemctl start nginx

validate $? "startinging nginx"

rm -rf /usr/share/nginx/html/* &>> LOGFILE

validate $? "removed nginx default content"


curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>LOGFILE

validate $? "downloading nginx code"


cd /usr/share/nginx/html &>> LOGFILE


validate $? "changing path to html dir"


unzip -o /tmp/web.zip &>> LOGFILE

validate $? "unzipping web.zip code"


cp /home/centos/roboshop_shell_new/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>> LOGFILE

validate $? "confiruging roboshop.conf"


systemctl restart nginx 

validate $? "restarting nginx"

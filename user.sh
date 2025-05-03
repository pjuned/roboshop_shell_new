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

validate(){
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

dnf module disable nodejs -y &>> $LOGFILE

validate $? "Disabling current NodeJS"

dnf module enable nodejs:18 -y  &>> $LOGFILE

validate $? "Enabling NodeJS:18"

dnf install nodejs -y  &>> $LOGFILE

validate $? "Installing NodeJS:18"

id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    validate $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app

validate $? "creating app directory"

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip  &>> $LOGFILE

validate $? "Downloading user application"

cd /app 

unzip -o /tmp/user.zip  &>> $LOGFILE

validate $? "unzipping user"

npm install  &>> $LOGFILE

validate $? "Installing dependencies"



# use absolute, because catalogue.service exists there
cp /home/centos/roboshop_shell_new/user.service /etc/systemd/system/user.service &>> $LOGFILE

validate $? "Copying user service file"


systemctl daemon-reload &>> $LOGFILE

validate $? "daemon reload"

systemctl enable user &>> $LOGFILE

validate $? "enabling user"

systemctl start user &>> $LOGFILE

validate  $? "starting user"

npm audit fix


dnf install mongodb-org-shell -y &>> LOGFILE

validate $? "installing mongodb client"

mongo --host mongodb.aws76s.online </app/schema/user.js

validate $? "loading user data"
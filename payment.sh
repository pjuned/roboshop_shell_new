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

dnf install python36 gcc python3-devel -y


id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi


mkdir -p /app

VALIDATE $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>> $LOGFILE

VALIDATE $? "Downloading catalogue application"

cd /app 

unzip -o /tmp/catalogue.zip  &>> $LOGFILE

VALIDATE $? "unzipping catalogue"

pip3.6 install -r requirements.txt &>> $LOGFILE

VALIDATE $? "installing dependency pip3"

cp /home/user/centos/roboshop_shell_new /etc/systemd/system/payment.service &>> $LOGFILE

systemctl daemon-reload &>> $LOGFILE

validate $? "daemon relaoding"

systemctl enable payment &>> $LOGFILE

validate $? "enabling payment"

systemctl start payment &>> $LOGFILE

validate $? "starting payment"




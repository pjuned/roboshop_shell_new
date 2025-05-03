#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

dnf install maven -y &>> LOGFILE

validate $? "installing maven"

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

curl -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip  &>> $LOGFILE

validate $? "Downloading shipping application"

cd /app 

unzip -o /tmp/shipping.zip  &>> $LOGFILE

validate $? "unzipping shipping"

cd /app

mvn clean package &>> LOGFILE

validate $? "installing dependencies"

mv target/shipping-1.0.jar shipping.jar

systemctl daemon-reload &>> LOGFILE

validate $? "loading daemon"

systemctl enable shipping &>> LOGFILE

validate $? "enable shipping"

systemctl start shipping &>> LOGFILE

validate $? "starting shipping"

dnf install mysql -y &>> LOGFILE

validate $? "installing mysql client"


mysql -h mysql.aws76s.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> LOGFILE

validate $? "loading schema"

systemctl restart shipping 

validate $? "restarting shipping"






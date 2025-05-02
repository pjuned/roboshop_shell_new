#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


validate(){
     if [ $1 -ne 0 ]
then
    echo -e " $2  is $R failed $N"
    exit 1
else
    echo -e "$2 is $G success $N"
fi

}
if [ $ID -ne 0 ]
then
    echo -e "$R please run this with root user $N"
    exit 1 # you can give other than 0
else
    echo -e "$G you are root user $N"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

validate $? "copying mongodb repo"  

dnf install mongodb-org -y &>> $LOGFILE

validate $? "installing mongodb"

systemctl enable mongod &>> $LOGFILE

validate $? "enabling mongod"

systemctl start mongod &>> $LOGFILE

validate $? "starting mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

validate $? "editing mongod with 0.0.0.0"

systemctl restart mongod &>> $LOGFILE

validate $? "restarting mongod"
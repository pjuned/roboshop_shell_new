ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

MONGODB_HOST=mongodb.aws76s.online


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

dnf module disable nodejs -y &>> $LOGFILE

validate $? "disabling current nodejs version"

dnf module enable nodejs:18 -y &>> $LOGFILE

validate $? "enabling nodejs 18"

dnf install nodejs -y &>> $LOGFILE

validate $? "nodejs installation"

useradd roboshop &>> $LOGFILE

validate $? "user roboshop creating"

mkdir /app

validate $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

validate $? "downloading app code"

cd /app

unzip /tmp/catalogue.zip &>> $LOGFILE

validate $? "unzipping catalogue"

npm install &>> $LOGFILE

validate $? "installing dependencies"

cp /home/centos/roboshop_shell_new/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

validate $? "copying catalogue.service"

systemctl daemon-reload &>> $LOGFILE

validate $? "loading catalogue daemon service"

systemctl enable catalogue &>>$LOGFILE

validate $? "enabling catalogue"

systemctl start catalogue &>> $LOGFILE

validate $? "starting catalogue service"

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

validate $? "copying mongodb client"

dnf install mongodb-org-shell -y &>> $LOGFILE

validate $? "installing mongodb client"

mongo --host $MONGODB_HOST </app/schema/catalogue.js

validate $? "loading catalogue data into mongodb"




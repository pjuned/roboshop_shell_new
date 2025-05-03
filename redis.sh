#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGDB_HOST=mongodb.aws76s.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

#exec &>LOGFILE


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

#dnf install --nobest https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

 #dnf install -y --nobest https://rpms.remirepo.net/enterprise/8/remi-release-8.4-1.el8.remi.noarch.rpm



validate $? "installing redis repo package"

dnf module enable redis -y 


validate $? "enabling redis 6.2" 

dnf install redis -y 

validate $? "installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf


validate $? "allowing remote connections"

systemctl enable redis 

validate $? "enabling resis"

systemctl start redis 

validate $? "starting redis"


# #!/bin/bash

# # Enable EPEL and Remi repos
# dnf install -y epel-release
# dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm

# # Enable Redis module from Remi repo
# dnf module enable -y redis:remi-6.2

# # Install Redis
# dnf install -y redis

# sec -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf


# validate $? "allowing remote connections"


# # Start and enable Redis
# systemctl enable redis
# systemctl start redis

# # Check Redis status
# systemctl status redis


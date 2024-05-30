date=$(date +%F-%H-%M-%S)
script_name=$0
location=/tmp
logfile=$location/$script_name-$date.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
id=$(id -u)
if [ $id -ne 0 ]
then
echo -e "$R user is not root $N. $G kindly proceed with root access$N"
exit 1
fi
validate() {
    if [ $1 -ne 0 ]
    then
    echo -e "$2.. $R failure $N"
    else
    echo  -e "$2..$G success $N"
    fi
}
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $logfile
validate $? "installing redis repo file"
yum module enable redis:remi-6.2 -y &>> $logfile
validate $? "enable redis"
yum install redis -y  &>> $logfile
validate $? "installing redis"
sed -i "s/127.0.0.1/0.0.0.0/g" /etc/redis.conf  /etc/redis/redis.conf $logfile
validate $? "changing ip address"
 systemctl enable redis $logfile
 validate $? "enable redis"
 systemctl start redis $logfile
validate $? "start redis"
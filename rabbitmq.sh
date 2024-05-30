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
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $logfile
validate $? "configure yum repos by vendor"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $logfile
validate $? "configure yum by rabbitmq"
yum install rabbitmq-server -y &>> $logfile
validate $? "installing rabbitmq"
systemctl enable rabbitmq-server &>> $logfile
validate $? "enabling rabbitmq"
systemctl start rabbitmq-server &>> $logfile
validate $? "start rabbitmq"
rabbitmqctl add_user roboshop roboshop123 &>> $logfile
validate $? "creating user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $logfile
validate $? "setting permissions"


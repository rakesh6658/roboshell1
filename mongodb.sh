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
    echo "$2.. failure"
    else
    echo "$2.. success"
    fi
}
cp "/home/centos/roboshell1/mongo.repo" "/etc/yum.repos.d/mongo.repo" &>> $logfile
validate $? "copying mongo.repo"
yum install mongodb-org -y &>> $logfile
validate $? "installing mongodb" 
systemctl enable mongod &>> $logfile
validate $? "enabling mongodb" 
systemctl start mongod &>> $logfile
validate $? "start mongodb"
sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>> $logfile
validate $? "changing ip address mongodb"
systemctl restart mongod &>> $logfile
validate $? "restarted mongod"



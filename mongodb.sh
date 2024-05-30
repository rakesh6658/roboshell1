date=$(date +%F-%H-%M-%S)
script_name=$0
location=/tmp
logfile=$location/$script_name-$date.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
validate () 
    if [ $1 -ne 0 ]
    then
    echo "$2.. failure"
    else
    echo "$2.. success
    fi
    
id=$(id -u)
if [ $id -ne 0 ]
then
echo -e "$R user is not root $N. $G kindly proceed with root access$N"
exit 1
fi
yum install mongodb-org -y
validate $? "installing mongodb"
systemctl enable mongod
validate $? "enabling mongodb"
systemctl start mongod
validate $? "start mongodb"
sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf
validate $? "changing ip address mongodb"
systemctl restart mongod
validate $? "restarted mongod"



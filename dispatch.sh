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
yum install golang -y &>> $logfile
validate $? "golang install"
useradd roboshop &>> $logfile
validate $? "adding user roboshop"
mkdir /app &>> $logfile
validate $? "creating app directory"
curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip &>> $logfile
validate $? "downloading code to directory"
cd /app &>> $logfile
validate $? "change to app directory"
unzip /tmp/dispatch.zip &>> $logfile
validate $? "unzip dispatch.zip"
cd /app &>> $logfile
validate $? "change to app directory"
go mod init dispatch &>> $logfile
go get  &>> $logfile
go build &>> $logfile
cp /home/centos/roboshell1/dispatch.service /etc/systemd/system/dispatch.service &>> $logfile
validate $? "copying dispatch.service"
systemctl daemon-reload &>> $logfile
validate $? "daemon-reload"
systemctl enable dispatch  &>> $logfile
validate $? "enable dispatch"
systemctl start dispatch &>> $logfile
validate $? "start dispatch"

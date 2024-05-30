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
yum install python36 gcc python3-devel -y &>> $logfile
validate $? "installing phython"
useradd roboshop &>> $logfile
validate $? "adding user roboshop"
mkdir /app &>> $logfile
validate $? "creating app directory"
curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $logfile
validate $? "downloading code to directory"
cd /app &>> $logfile
validate $? "change to app directory"
unzip /tmp/payment.zip &>> $logfile
validate $? "unzip payment.zip"
cd /app &>> $logfile
validate $? "change to app directory"
pip3.6 install -r requirements.txt &>> $logfile
validate $? "download the dependencies"
cp /home/centos/roboshell1/payment.service /etc/systemd/system/payment.service &>> $logfile
validate $? "copying payment.service"
systemctl daemon-reload &>> $logfile
validate $? "daemon-reload"
systemctl enable payment  &>> $logfile
validate $? "enable payment"
systemctl start payment &>> $logfile
validate $? "start payment"


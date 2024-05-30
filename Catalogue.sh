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
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $logfile
validate $? "npm setup"
yum install nodejs -y &>> $logfile
validate $? "installing nodejs"
useradd roboshop &>> $logfile
validate $? "adding user roboshop"
mkdir /app &>> $logfile
validate $? "creating app directory"
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $logfile
validate $? "Download the application code to created app directory."
cd /app &>> $logfile
validate $? "change to app directory"
unzip /tmp/catalogue.zip &>> $logfile
validate $? "unzip catalouge"
cd /app &>> $logfile
validate $? "change to app directory"
npm install &>> $logfile
validate $? "installing npm dependencies"
cp /home/centos/roboshell1/catalogue.service /etc/systemd/system/catalogue.service &>> $logfile
validate $? "copying catalogue.service"
systemctl daemon-reload &>> $logfile
validate $? "daemon-reload"
systemctl enable catalogue  &>> $logfile
validate $? "enable catalogue"
systemctl start catalogue &>> $logfile
validate $? "start catalogue"
cp "/home/centos/roboshell1/mongo.repo" "/etc/yum.repos.d/mongo.repo" &>> $logfile
validate $? "copying mongo.repo"
yum install mongodb-org-shell -y &>> $logfile
validate $? "installing mongodb-org-shell"
mongo --host mongodb.rakeshreddy.online </app/schema/catalogue.js &>> $logfile
validate $? "loading schema"




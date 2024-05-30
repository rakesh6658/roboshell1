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
yum install maven -y &>> $logfile
validate $? "installing maven"
useradd roboshop &>> $logfile
validate $? "adding user roboshop"
mkdir /app &>> $logfile
validate $? "creating app directory"
curl -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $logfile
validate $? "Download the application code to created app directory."
cd /app &>> $logfile
validate $? "change to app directory"
unzip /tmp/shipping.zip &>> $logfile
validate $? "unzip shipping"
cd /app &>> $logfile
validate $? "change to app"
mvn clean package &>> $logfile
validate $? "clean maven package"
mv target/shipping-1.0.jar shipping.jar &>> $logfile
validate $? "changing name shipping.jar"
cp /home/centos/roboshell1/shipping.service /etc/systemd/system/shipping.service &>> $logfile
validate $? "copying shipping service"
systemctl daemon-reload &>> $logfile
validate $? "daemon-reload"
systemctl enable shipping &>> $logfile
validate $? "enable shipping"
systemctl start shipping &>> $logfile
validate $? "start shipping"
yum install mysql -y  &>> $logfile
validate $? "installing mysql client"
mysql -h mysql.rakeshreddy.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $logfile
validate $? "loading schema"
systemctl restart shipping &>> $logfile
validate $? "retart shipping"

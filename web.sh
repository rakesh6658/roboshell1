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
yum install nginx -y &>> $logfile
validate $? "installing nginx"
systemctl enable nginx &>> $logfile
validate $? "enable nginx"
systemctl start nginx &>> $logfile
validate $? "start nginx"
rm -rf /usr/share/nginx/html/* &>> $logfile
validate $? "removing default content"
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $logfile
validate $? "downloading the frontend"
cd /usr/share/nginx/html &>> $logfile
validate $? "pointing to html"
unzip /tmp/web.zip &>> $logfile
validate $? "unzip web.zip"
cp /home/centos/roboshell1/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $logfile
validate $? "copying roboshop.conf"
systemctl restart nginx  &>> $logfile
validate $? "restart nginx"
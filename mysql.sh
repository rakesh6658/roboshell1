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
yum module disable mysql -y &>> $logfile
validate $? "disabling mysql module"
cp /home/centos/roboshell1/mysql.repo /etc/yum.repos.d/mysql.repo &>> $logfile
validate $? "copying mysql.repo"
yum install mysql-community-server -y &>> $logfile
validate $? "installing mysql server"
systemctl enable mysqld &>> $logfile
validate $? "enable mysql"
systemctl start mysqld &>> $logfile
validate $? "start mysql"
mysql_secure_installation --set-root-pass RoboShop@1 &>> $logfile
validate $? "secure installation"
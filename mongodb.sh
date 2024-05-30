date=$date(date +%F-%H-%M-%S)
script_name=$0
location=/tmp
logfile=$location/$script_name-$date.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
validate(){
    if [ $1 ]
}
id=$(id -u)
if [ $id -ne 0 ]
then
echo "$R user is not root $N. $G kindly proceed with root access$N"
exit 1
fi
echo " $Y welcome to shell script $N"

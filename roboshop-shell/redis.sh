source common.sh

print_head "install redis"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log
dnf module enable redis:remi-6.2 -y &>>$log
yum install redis -y &>>$log
status

print_head "update the redis conf file to lisen from anywhere"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>$log
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>>$log
status

print_head "restart service"
systemctl enable redis &>>$log
systemctl start redis &>>$log
status
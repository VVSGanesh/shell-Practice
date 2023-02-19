source common.sh

print_head "install Mangodb"
cp $script_path/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log
yum install mongodb-org -y &>>$log
status

print_head "making mangodb to lisiten from anywhere"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$log
status

print_head "enable and restart mangoDB service"
systemctl enable mongod &>>$log
systemctl restart mongod &>>$log
status
source common.sh

print_head "install nginx"
yum install nginx -y &>>$log
status

print_head "removing the old content"
rm -rf /usr/share/nginx/html/* &>>$log
status

print_head "Getting the source code"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log
status

print_head "unzipping the code to the default path"
cd /usr/share/nginx/html &>>$log
unzip /tmp/frontend.zip &>>$log
status

print_head "robshop conf file"
cp $script_path/files/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log
status

print_head "enabling and restarting the service"
systemctl enable nginx
systemctl restart nginx
status
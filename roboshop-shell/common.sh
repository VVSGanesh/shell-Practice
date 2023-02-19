script_path=$(pwd)
log=/tmp/roboshop.log

print_head(){
  echo -e "\e[35m$1\e[0m"
}

status(){
  if [ $? -ne 0 ];then
    echo "Please refer /tmp/roboshop.log for the logs"
    exit
    else
        echo "Success"
    fi
}

nodejs(){
  rm -rf /app/* &>>$log

  print_head "Install NodeJS"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log
  yum install nodejs -y &>>$log
  status

  print_head "Adding new user"
  id roboshop &>>$log
  if [ $? -ne 0 ]; then
    useradd roboshop
  fi

  mkdir -p /app

  print_head "source code and unzip to the app folder"
  curl -L -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>$log
  cd /app &>>$log
  unzip /tmp/$component.zip &>>$log
  status

  print_head "install dependies"
  npm install
  status

  print_head "configure systemd"
  cp $script_path/files/$component.service /etc/systemd/system/$component.service &>>$log
  status

  print_head "restart services"
  systemctl daemon-reload &>>$log
  systemctl enable $component &>>$log
  systemctl restart $component &>>$log
  status

  print_head "install mangodb client"
  cp $script_path/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log
  yum install mongodb-org-shell -y &>>$log
  status

  print_head "load schema"
  mongo --host MONGODB-SERVER-IPADDRESS </app/schema/$component.js &>>$log
  status
}
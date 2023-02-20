source common.sh

print_head "disable mysql"
dnf module disable mysql -y &>>$log
status

print_head "install mysql"
cp $script_path/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log
yum install mysql-community-server -y &>>$log
status

if [ -z "$root_password" ]; then
    echo "root_password variable is missing"
    exit
fi

print_head "reset default password"
mysql_secure_installation --set-root-pass $root_password
status

print_head "restart service"
systemctl enable mysqld
systemctl start mysqld
status
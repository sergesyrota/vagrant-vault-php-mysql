#!/bin/bash
apt-get update
debconf-set-selections <<< 'mysql-server mysql-server/root_password password your_password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password your_password'
apt-get install mysql-server -y
cp /vagrant/provision/.my.cnf ~/
echo "GRANT ALL PRIVILEGES on *.* TO 'vault'@'%' IDENTIFIED BY 'vault' WITH GRANT OPTION;" | mysql
echo "CREATE DATABASE vault;" | mysql
sed -i 's/bind-address\s\+=\s\+127.0.0.1/bind-address = 0.0.0.0/g' /etc/mysql/my.cnf

#varibles block
DB="zabbix"
DBuser="zabbix"
DBpass="zabbix"
Region="Europe"
City="Minsk"
sudo yum clean all
sudo yum update
#installing mariadb
sudo yum install mariadb mariadb-server -y
#Mysql Initial configuration
sudo /usr/bin/mysql_install_db --user=mysql --force

sudo systemctl start mariadb

#Creating initial database
sudo echo "create database $DB character set utf8 collate utf8_bin;" | mysql -uroot
sudo echo "grant all privileges on $DB.* to $DBuser@localhost identified by '$DBpass';" | mysql -uroot

#Installing zabbix
sudo yum install -y http://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-release-4.2-1.el7.noarch.rpm
sudo yum install zabbix-server-mysql zabbix-web-mysql -y

#Import initial schema and data
sudo bash -c "zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -u$DB -p$DBpass $DB"

#Database configuration for Zabbix server
sudo echo "DBHost=localhost
DBPassword=$DBpass" | sudo tee -a /etc/zabbix/zabbix_server.conf > /dev/null

#Configuring PHP settings
sudo sed -i "s|# php_value date.timezone Europe/Riga|php_value date.timezone $Region/$City|" /etc/httpd/conf.d/zabbix.conf

#Changing apache root to access http://zabbix-server/zabbix -> http://zabbix-server
sudo sed -i 's|DocumentRoot "/var/www/html"|DocumentRoot "/usr/share/zabbix"|g' /etc/httpd/conf/httpd.conf

sudo yum install zabbix-agent -y
sudo systemctl start zabbix-server
sudo systemctl start zabbix-agent 
sudo systemctl restart httpd
sudo systemctl enable zabbix-server
sudo systemctl enable zabbix-agent
sudo systemctl enable httpd

sudo yum install zabbix-get -y





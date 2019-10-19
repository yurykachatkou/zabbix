#variables block
Server="192.168.56.155"

sudo yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
sudo yum install zabbix-agent -y

sudo bash -c 'cat << EOF > /etc/zabbix/zabbix_agentd.conf
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server='$Server'
ServerActive='$Server'
Hostname=zabbixclient
Include=/etc/zabbix/zabbix_agentd.d/*.conf
HostMetadata=system.uname
StartAgents=3
EOF
'
sudo systemctl start zabbix-agent 
sudo systemctl enable zabbix-agent 

sudo yum install tomcat tomcat-webapps tomcat-admin-webapps -y
sudo systemctl start tomcat
sudo systemctl enable tomcat
sudo cp /vagrant/clusterjsp.war /usr/share/tomcat/webapps


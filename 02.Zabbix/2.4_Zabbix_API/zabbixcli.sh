#!/bin/bash
source /vagrant/variables.conf

sudo yum clean all
sudo yum update
sudo yum install -y http://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-release-4.2-1.el7.noarch.rpm
sudo yum install zabbix-agent -y

#setting up zabbix_agentd.conf
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

#Setting up JAVA_OPTS variable for JMX
sudo echo "JAVA_OPTS=-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=192.168.56.156" | sudo tee -a /usr/share/tomcat/conf/tomcat.conf> /dev/null


wget http://repo2.maven.org/maven2/org/apache/tomcat/tomcat-catalina-jmx-remote/7.0.76/tomcat-catalina-jmx-remote-7.0.76.jar
sudo cp tomcat-catalina-jmx-remote-7.0.76.jar /usr/share/tomcat/lib/

#deploying clusterjsp 
sudo cp /vagrant/clusterjsp.war /usr/share/tomcat/webapps
sudo systemctl start tomcat


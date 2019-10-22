#!/bin/bash

#installing tomcat
sudo yum install tomcat tomcat-webapps tomcat-admin-webapps -y
#installing logstash
sudo wget https://artifacts.elastic.co/downloads/logstash/logstash-7.4.0.rpm
sudo yum localinstall logstash-7.4.0.rpm -y 

#configuring logstash
cat << EOF > /etc/logstash/conf.d/logstash.conf
input {
	file {
		path => "/var/log/tomcat/*.log"
		start_position => "beginning"
	}

}

output {
	elasticsearch {
	hosts => ["192.168.56.155:9200"]
	}
	stdout { codec => rubydebug }
}
EOF
#deploying clusterjsp.war
sudo cp /vagrant/clusterjsp.war /usr/share/tomcat/webapps
#permission for tomcat logs
sudo chmod -R 755 /var/log/tomcat

sudo systemctl start tomcat
sudo systemctl start logstash
sudo systemctl enable tomcat
sudo systemctl enable logstash


#!/bin/bash

#installing elasticsearch
sudo wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.4.0-x86_64.rpm
sudo yum localinstall elasticsearch-7.4.0-x86_64.rpm -y

#configuring elasticsearch
echo "transport.host: localhost
network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml

sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
sudo wget https://artifacts.elastic.co/downloads/kibana/kibana-7.2.1-x86_64.rpm
sudo yum localinstall kibana-7.2.1-x86_64.rpm -y

#configuring kibana
echo "server.host: 0.0.0.0" >> /etc/kibana/kibana.yml
sudo systemctl start kibana
sudo systemctl enable kibana




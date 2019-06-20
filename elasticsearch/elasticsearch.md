# install
https://linuxize.com/post/how-to-install-elasticsearch-on-centos-7/

sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
sudo vi /etc/yum.repos.d/elasticsearch.repo
---------------------------
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
---------------------------------------

sudo yum install elasticsearch
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

curl -X GET "localhost:9200/"


sudo journalctl -u elasticsearch

# Configuring Elasticsearch
Elasticsearch data is stored in the /var/lib/elasticsearch directory, configuration files are located in /etc/elasticsearch

# uninstall elasticsearch from ubuntu
-------------------
-- To remove the elasticsearch package and any other dependant package which are no longer needed from Ubuntu Xenial.
sudo apt-get remove --auto-remove elasticsearch
sudo apt-get purge elasticsearch
sudo apt-get purge --auto-remove elasticsearch


1) start_zookeeper
2) start_kafka
3) start_logstash
$LOGSTASH_HOME/bin/logstash -f /data01/logstash/logstash-kafka.conf

4) start_elasticsearch


curl -X GET 'http://localhost:9200/_cat/indices?v

curl 'localhost:9200/_mapping?pretty=true'

curl 'localhost:9200/sell_out_log/sell_out_log/620fcc3c-e1cc-4ba0-a7a7-808386eb3b39?pretty=true'

curl 'localhost:9200/sell_out_log?pretty=true'

curl http://localhost:9200/_cat/indices

curl -XDELETE http://localhost:9200/sell_out_log

http://localhost:9200/sell_out_log/doc/GMZ3-GoBaHpSWzYSy3Ko

http://localhost:9200/sell_out_log/doc/_search  

http://localhost:9200/_cluster/health
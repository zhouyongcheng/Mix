# springboot es api
[HighRichClientApi](https://blog.csdn.net/u010011737/article/details/79041125)

https://blog.csdn.net/yjclsx/article/details/86576946

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

# elastichsearch api
> GET /_cluster/health/indexName
> get /_cluster/health?level=indices

## 获取集群的状态
> get /_cluster/status?pretty
> get /_cluster/stats
>get /_cluster/settings

## 节点统计信息
> get /_nodes/stats


## cat api
> /_cat/health?v
>/_cat/indices?v
>/_cat/master?v
>/_cat/nodes?v
>/_cat/allocation?v
>/_cat/shards?v
>/_cat/plugins?v
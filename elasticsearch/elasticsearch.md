# pass parameter
https://discuss.elastic.co/t/solved-painless-parameters-passing-from-java-code/117079

# springboot es api
[HighRichClientApi](https://blog.csdn.net/u010011737/article/details/79041125)

https://blog.csdn.net/yjclsx/article/details/86576946

[ElasticSearch踩过的坑](https://www.jianshu.com/p/fa31f38d241e)

## install header plugin
```
git clone git://github.com/mobz/elasticsearch-head.git
cd elasticsearch-head
npm install
npm run start
http://localhost:9100
```


## 停止es
kill -9  pid_es

## 创建起点服务
sudo /sbin/chkconfig  --add elasticsearch
sudo service elasticsearch status

[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md

sudo yum install elasticsearch
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

## 安装ES和配置
* 安装jdk
* 直接下载解压，安装完毕。
* 设置JAVA_OPTS,内存配置
* 配置主要是config/elasticsearch.yml文件
```
    cluster.name: xxxxx
    node.name: yyyy
    path.data: /path/to/data    索引存储文件的地址
    path.logs: /path/to/log
    bootstrap.mlockall: true
    network.host: 192.168.0.1
    http.port: 9200
    discovery.zen.ping.unicast.hosts: ["node1", "node2"]
    discovery.zen.minimum_master_nodes:3
    gateway.recovery_after_nodes:3
    node.max_local_storage_nodes: 1
    action.destructive_requires_name:true   -- 禁止通过通配符的方式进行删除索引
    max.poll.records：

```
* 启动，停止es
```
elasticsearch.sh -d --cluster.name myclusterName --node.name mynode1
kill -9 pidxxx
```
* xx

>>>>>>> 8a129a7f1dbfd15741aaa638833f42c7b9df2d25

## install elasticsearch head plugin
```
git clone https://github.com/mobz/elasticsearch-head.git
npm install
npm run start
http://localhost:9100
```


ES6字段类型概述
一级分类	二级分类	具体类型
-----------------------------------------------------
核心类型	字符串类型	text,keyword
整数类型	integer,long,short,byte
浮点类型	double,float,half_float,scaled_float
逻辑类型	boolean
日期类型	date
范围类型	range
二进制类型	binary
复合类型	数组类型	array
对象类型	object
嵌套类型	nested
地理类型	地理坐标类型	geo_point
地理地图	geo_shape
特殊类型	IP类型	ip
范围类型	completion
令牌计数类型	token_count
附件类型	attachment
抽取类型	percolator
--------------------- 
作者：大树168 
来源：CSDN 
原文：https://blog.csdn.net/limingcai168/article/details/85780964 
版权声明：本文为博主原创文章，转载请附上博文链接！


curl -X GET "localhost:9200/"


# elasticsearch.yml
```
-- 禁止自动创建index
action.auto_create_index: false
```

## es的脚本功能配置，修改配置后，需要重新启动es
```
script.inline:on
script.indexed:on
script.file:on
```


sudo journalctl -u elasticsearch

# Configuring Elasticsearch
Elasticsearch data is stored in the /var/lib/elasticsearch directory, configuration files are located in /etc/elasticsearch

# elastichsearch api
> get /_cluster/health/indexName
> get /_cluster/health?level=indices
> get /_mapping/mapping_name               -- 获取索引的mapping信息
> 

## 获取索引的统计信息
* get http://localhost:9200/_stats
* get http://localhost:9200/index_name/_stats

## 关闭和打开索引
post http://localhost:9200/index_nae/_close
post http://localhost:9200/index_nae/_open


## 获取集群的状态
> get /_cluster/status?pretty
> get /_cluster/stats
> get /_cluster/settings
> get /_nodes/stats


## cat api
```
>/_cat/health?v
>/_cat/indices?v
>/_cat/master?v
>/_cat/nodes?v
>/_cat/allocation?v
>/_cat/shards?v
>/_cat/plugins?v
 /_cat/templates?v
 /_cat/aliases?v
 /_cat/recovery?v

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

-- 查询所有的索引信息
curl -XGET 'http://localhost:9200/_cat/indices?v

curl 'localhost:9200/_mapping?pretty=true'

curl 'localhost:9200/sell_out_log/sell_out_log/620fcc3c-e1cc-4ba0-a7a7-808386eb3b39?pretty=true'

curl 'localhost:9200/sell_out_log?pretty=true'

curl http://localhost:9200/_cat/indices

-- 获取索引
GET http://localhost:9200/idx_name
GET http://localhost:9200/idx_name/_settings,_mappings

--打开索引
post http://localhost:9200/idx_name/_open

-- 关闭索引
post http://localhost:9200/idx_name/_close

-- 删除索引
-XDELETE http://localhost:9200/idx_name

-- 删除多个索引
-XDELETE http://localhost:9200/idx_name1,idx_name2


curl -XDELETE http://localhost:9200/sell_out_log

http://localhost:9200/sell_out_log/doc/GMZ3-GoBaHpSWzYSy3Ko

http://localhost:9200/sell_out_log/doc/_search  

http://localhost:9200/_cluster/health

## 查询文档的查询参数
通过参数控制，可以在查询的时候指定在主节点上进行查询，还系在副本节点上查询。
* _primary: 在主节点上查询
* _local: 尽可能在本地节点上查询？
* refresh: 可以设置为true，查询前先刷新相关分片，保障获取信息（耗费资源）


## 查询所有文档
http://localhost:9200/sell_out_report_idx/_search
http://localhost:9200/index_name/_doc/1?_source_include=field1,field2&pretty
http://localhost:9200/index_name/_doc/1?fields=field1,field2&pretty

## 只获取文档的内容（source）
http://localhost:9200/index_name/_doc/1/_source?pretty

-- 按照某个字段匹配查询
http://localhost:9200/sell_out_report_idx/_search?q=status:1

-- 分页查询
http://localhost:9200/sell_out_report_idx/_search?from=0&size=10

-- 修改setting内容
PUT /my_temp_index/_settings
{
"number_of_replicas": 1
}

-- 创建索引
put http://localhost:9200/idx_name -H 'Content-Type:application/json' -d '
{
	"settings" :{
		"number_of_shards" : 3,
		"number_of_replicas" 2
	},
	"mappings" : {
	   "type_name" : {
			"properties" : {
				"name" : "text"
			}
	   }
	}
}	
'

-- 索引映射管理
put http://localhost:9200/idx_name -H 'Content-Type:application/json' -d '
{
	"mappings" : {
		"type_name" : {
			"properties" : {
				"message" : {
					"type" : "text"
				}
			}
		}
	}
}
'

-- 获取mapping信息
get http://localhost:9200/idx_name/_mapping/map_name

-- 别名管理
-- 添加别名
post http://localhost:9200/_aliases -H 'Content-Type:application/json' -d '
{
	"actions" : [
	{
		"remove" : {
			"index" : "index_name",
			"alias" : "alias_name"
		}
	},
	{
		"add" : {
			"index" : "index_name",
			"alias" : "alias_name"
		}
	}
	]
}
'

-- 删除别名
delete http://localhost:9200/idx_name/_alias/alias_name

-- 查询别名
get http://localhost:9200/idx_name/_alias/*


-- 创建完索引后可以添加分词器，但先要关闭索引，修改后在打开。
post http://localhost:9200/idx_name/_close
put http://localhost:9200/idx_name/_settings -H 'Content-Type:application/json' -d '
{
	"analysis" : {
		"analyzer" : {
			"content" : {
				"type" : "customer",
				"tokenizer" : "whitespace"
			}
		}
	}
}	
'

curl -XPOST localhost:9200/_aliases -H 'Content-Type: application/json' -d '
{
    "actions": [
        { 
        	"remove": {
            	"alias": "sell_out_report_idx",
            	"index": "sell_out_report_idx_v2"
        	}
    	},
        { 
        	"add": {
            	"alias": "sell_out_report_idx",
            	"index": "sell_out_report_idx_v3"
        	}
    	}
    ]
}
'
## 一个别名关联多个索引
curl -XPOST localhost:9200/_aliases -H 'Content-Type: application/json' -d '
{
    "actions": [
        {"add": {"alias":"sell_idx","index":"idx_name_1"}},
        {"add": {"alias":"sell_idx","index":"idx_name_2"}},
        {"add": {"alias":"sell_idx","index":"idx_name_3"}},
    ]
}
'

curl -XPOST localhost:9200/_aliases -H 'Content-Type: application/json' -d '
{
    "actions": [
        {"add": {"alias":"sell_idx","indices": ["idx_name_1", "idx_name_2"]}}
    ]
}
'

## 创建过滤别名
curl -XPOST localhost:9200/_aliases -H 'Content-Type: application/json' -d '
{
    "actions": [
        {
            "add": {"alias":"sell_idx","indices": "idx_name_1", filter: {
                "term" : { "user" : "xyz"}
            }}
        }
    ]
}
'

## 创建索引的时候指定别名(创建了两个别名，一个是current_day, 一个是2019，只包含year=2019的数据)
{
    aliases: {
        "current_day" :{},
        "2019" : {
                "term" : {"year": "2019"}
        }
    }
}



## delete document based on query condition
curl -XPOST "http://localhost:9200/sell_out_report_idx/_delete_by_query?conflicts=proceed" -H 'Content-Type: application/json' -d '{
    "query": {
        "range" : {
            "updateTime" : {
                "lte" : "2019-09-03 17:30:52.000"
            }
        }
    }
}'

## 索引的配置
put http://localhost:9200/indix_name/_settings 
{
    "index" : {
        "number_of_replicas":3
    }
}

## 获取索引的配置
get http://localhost:9200/index_name/_settings
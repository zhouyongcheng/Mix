$(Kafka monitor)[https://github.com/quantifind/KafkaOffsetMonitor]

https://thepracticaldeveloper.com/2018/11/24/spring-boot-kafka-config/

(spring-boot|kafka)[https://blog.csdn.net/cowbin2012/article/details/85407495]

# install kafka
# start kafka
before starting kafka, zookeeper is already configured in the config/server.properties
* bin/kafka-server-start.sh  -daemon /home/cmwin/software/kafka/config/server.properties
* bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
* bin/kafka-topics.sh --list --zookeeper localhost:2181
* bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
* bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning
*  bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic my-replicated-topic
 * bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic my-replicated-topic


bin/kafka-topics.sh --zookeeper localhost:2181 --alter --topic tp_product_sell_out_notification --partitions 9



## server.properties configuration metadata

## 必须配置的项目
```
broker.id=0
port=9092           端口小于1024，则必须以root的身份运行，kafka不推荐用root运行。
num.network.threads=2  
num.io.threads=8  
socket.send.buffer.bytes=1048576  
socket.receive.buffer.bytes=1048576  
socket.request.max.bytes=104857600  
log.dirs=/tmp/kafka-logs  
num.partitions=2  
log.retention.hours=168  
  
log.segment.bytes=536870912  
log.retention.check.interval.ms=60000  
log.cleaner.enable=false  
  
zookeeper.connect=localhost:2181  
zookeeper.connection.timeout.ms=1000000
```

# 客户端连接
```
zkCli.sh -server localhost:2181

```

# zookeeper集群安装
```
* 在集群中的每个机器都解压zookeeper，然后配置，每个机器上的zoo.cfg文件都一样，配置好一个，复制就行。

```


WXI065  4   4   4   4  4
WXI011  8   3   3   3  3   3
ALN001  2   2   2   2  2   2


http://localhost:9200/sell_out_report_idx/_doc/_search
http://localhost:9200/sell_out_report_idx/_doc/_search


es.connect.timeout = 1000;    // 连接超时时间
es.socket.timeout = 30000;    // 连接超时时间
es.connection.request.timeout = 500; // 获取连接的超时时间
es.max.connect.num = 100; // 最大连接数
es.max.connect.per.route = 100; // 最大路由连接数


sudo ufw allow from 10.67.31.186









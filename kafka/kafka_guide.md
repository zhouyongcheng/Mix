$(Kafka monitor)[https://github.com/quantifind/KafkaOffsetMonitor]

https://thepracticaldeveloper.com/2018/11/24/spring-boot-kafka-config/

(spring-boot|kafka)[https://blog.csdn.net/cowbin2012/article/details/85407495]

# 为什么要选择kafka？
* 高性能的消息发送及消息消费。
* 高吞吐率（超大量级的数据实时传输），每秒能处理的消息数（数据量）
* 实时性（低延时），客户端发送消息到客户端消费消息的时间。 高吞吐低延时。
* 消息的可靠性策略（消息丢失及重复消费的避免）
* 消息的持久化功能
* 扩展性（横向扩展能力，可操作性），负载均衡和故障转移。
* 实时流式处理
* 异步消息处理，系统间解耦。
* 消息设计（消息类型）
* 消息的传递协议

## kafka的消息设计
kafka消息采用二进制来保存，但仍然是结构化的数据。便于消息引擎进行处理。
消息传递协议： AMQP, 采用发布订阅的模式，也能满足队列模式（一个消费者组）。

## 如何保障高吞吐低延时
```
生产端：kafka采用顺序写入磁盘的方式，写入速度和内存的随机读写差不多快。每秒能轻松写入几万条。
消费端：零拷贝技术保障。
```

## kafka消息的持久化
```
生产者和消费者不必同时在线，系统解耦。
满足从指定offset进行重复消费的需求。
```

## kafka的负载均衡和故障转移,横向扩展
```
因为kafka的状态维护在zookeeper中，所以只需启动新的服务器就可以实现
```

## 查看kafka的版本
> 直接查看kafka/lib/kafka*.jar,后面的序号就是kafka的版本。前面的版本号是scala的版本号

## 安装kafka
> 直接解压下载的二进制文件到指定的目录，设置环境变量就完成安装工作。
> 

## 启动kafka
```
   在启动kafka之前，先要启动zookeeper， 压缩包中已经内置了zookeeper.可直接启动。
   在KAFKA_HOME目录下执行下面命令：
   bin/zookeeper-server-start.sh config/zookeeper.prperties
   bin/kafka-server-start.sh  -daemon /home/cmwin/software/kafka/config/server.properties
```

## 创建topic
```
bin/kafka-topics.sh --create --zookeeper localhost:2181 --topic test --replication-factor 1 --partitions 1 
查看创建的topic的详细信息
bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic test
列出创建的topic列表信息
bin/kafka-topics.sh --list --zookeeper localhost:2181
创建topic的时候，需要考虑下面的参数信息：
1）replication-factor: 副本数（一条消息保留的份数）
2) partitions:         分区数（不同的消息保存到不同的分区上，横向扩展）
```

## 多副本，多partition的topic创建
```
 bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic my-replicated-topic
 bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic my-replicated-topic
```

## 通过kafka的控制台发生消息和消费消息
```
bin/kafka-console-producer.sh --broker-list 10.67.31.48:9092 --topic mytopic
bin/kafka-console-consumer.sh --bootstrap-server 10.67.31.48:9092 --topic mytopic --from-beginning
```

## 修改topic的分区数
```sh
bin/kafka-topics.sh --zookeeper localhost:2181 --alter --topic tp_product_sell_out_notification --partitions 9
```
 
## 删除topic及相关数据
```
bin/kafka-topics.sh  --delete --zookeeper 172.25.216.29：2182,172.25.216.30：2182 --topic tp_product_sell_out_notification
bin/kafka-topics.sh  --delete --zookeeper 172.25.216.29：2182,172.25.216.30：2182 --topic tp_product_sell_out_notification_trace
bin/kafka-topics.sh --zookeeper 172.25.216.29：2182,172.25.216.30：2182 --list 
```

## kafka多节点安装部署
操作系统： linux
磁盘规划： 因为kafka写入磁盘是顺序写入，所以机械硬盘（hdd）就能够满足需求。容量大便宜。
磁盘容量规划：
   每天消息的条数：x
   每条消息两个副本
   保留周期为2天
   平均消息大小：2K
   每天的消息容量=1亿*2副本*2KB/1000/1000 = 200GB
   额外的文件存储=200*10%=20G
   总容量=220*7天=1.5T左右。
   是否取用压缩功能。

内存规划：
    尽量分配更多的内存给系统的page cache
    不要为broker设置过大的堆内存，不要超过6GB
    page cache的大小至少要超过一个日志段的大小。
 cup规划：
    多核比较重要，频率高低不是关键因素。启动多个线程，所以核数比较重要，kafka不是计算密集，cpu的频率不那么重要。

典型线上环境配置：
    cpu：24核
    内存：32G
    磁盘： 1TB 7200转 sas盘两块。
    带宽： 1Gb/s
    ulimit -n 1000000

## kafka参数配置
* broker参数配置
```
配置路径： $KAFKA_HOME/config/server.properties
#集群中的broker.id不能重复。
broker.id=0 
# kafka持久化消息的存储目录，可指定多个目录，提高效率。 每个目录挂载一个硬盘，并行读取。
log.dirs=/tmp/kafka-logs
# 如果同一套zookeeper管理多个kafka集群，则后面的kafka_cluster名称必须添加。
zookeeper.connect=localhost:2181,localhost:2182,localhost:2183/kafka_cluster_1 
#
zookeeper.connection.timeout.ms=1000000
# 监听的配置，不需要在配置port和host.name了
listeners=PLAINTEXT://10.67.31.48:9092
# 设置用于绑定公网IP提供使用，可以不设置该参数。
advertised.listeners=PLAINTEXT://10.67.31.48:9092
# 是否允许删除kafka的topic，如果配置了ACL权限管理的话，推荐设置为true
delete.topic.enable=true
# 数据保留时间,默认保留7天的数据
log.retention.hours=168
# 根据日志文件的大小来确认保留的内容
log.retention.bytes=-1
# 和producer的acks参数配合使用，只要在acks=-1时才有用。 
min.insync.replicas=2    #表示两个replica收到消息，才显示成功。
# 确定后台用于网络请求的线程数，默认是3，其他broker和client的请求处理线程。
num.network.threads=3
# 实际处理网络请求的线程数
num.io.threads=8  
# 最大消息尺寸，超过后就报错，消息丢失。
message.max.bytes=2M
```

* topic参数配置
```
覆盖broker的全局配置
delete.retention.hour=xxxxx
max.message.bytes=xxxxx
```

* GC配置参数
```
推荐使用java8的G1回收
-Xmx300m                   　　　　　　最大堆大小
-Xms300m                　　　　　　　　初始堆大小
-Xmn100m                　  　　　　　　年轻代大小
-XX:SurvivorRatio=8        　　　　　　Eden区与Survivor区的大小比值，设置为8,则两个
Survivor区与一个Eden区的比值为2:8,一个Survivor区占整个年轻代的1/10
-XX:+UseG1GC                　　　　　　使用 G1 (Garbage First) 垃圾收集器 
-XX:MaxTenuringThreshold=14        　　提升年老代的最大临界值(tenuring threshold). 默认值为 15[每次GC，增加1岁，到15岁如果还要存活，放入Old区]
-XX:ParallelGCThreads=8            　　设置垃圾收集器在并行阶段使用的线程数[一般设置为本机CPU线程数相等，即本机同时可以处理的个数，设置过大也没有用]
-XX:ConcGCThreads=8            　　　　并发垃圾收集器使用的线程数量
-XX:+DisableExplicitGC　　　　　　　　　　禁止在启动期间显式调用System.gc()
-XX:+HeapDumpOnOutOfMemoryError        OOM时导出堆到文件
-XX:HeapDumpPath=d:/a.dump        　　  导出OOM的路径
-XX:+PrintGCDetails           　　　　   打印GC详细信息
-XX:+PrintGCTimeStamps            　　　 打印CG发生的时间戳
-XX:+PrintHeapAtGC            　　　　　  每一次GC前和GC后，都打印堆信息
-XX:+TraceClassLoading            　　　  监控类的加载
-XX:+PrintClassHistogram        　　　　　 按下Ctrl+Break后，打印类的信息
```

* jvm配置参数
```
kafka主要使用堆外内存。大量使用操作系统的页缓存。通常，kafka的堆内存不超过6G

```

* OS参数配置
```
文件描述符限制： ulimit -n 100000
socket缓存区大小限制: 如何设置os级别的socket缓存区大小。
文件系统： ext4或者XFS，生产环境最好使用XFS
关闭swap： sysctl vm.swappiness= 比较小的值
设置更长的flush时间： 如何设置os的这个值，可以设置稍微大点，比如2分钟。
```


```
broker.id=0
port=9092           端口小于1024，则必须以root的身份运行，kafka不推荐用root运行。
socket.send.buffer.bytes=1048576  
socket.receive.buffer.bytes=1048576  
socket.request.max.bytes=104857600  
log.dirs=/tmp/kafka-logs  
num.partitions=2  
# 比位移保留时间
offsets.retention.minutes=1440
log.segment.bytes=536870912  
log.retention.check.interval.ms=60000  
log.cleaner.enable=false  
```

# 客户端连接
```
zkCli.sh -server localhost:2181

```

# zookeeper集群安装
```
* 在集群中的每个机器都解压zookeeper，然后配置，每个机器上的zoo.cfg文件都一样，配置好一个，复制就行。

```


es.connect.timeout = 1000;    // 连接超时时间
es.socket.timeout = 30000;    // 连接超时时间
es.connection.request.timeout = 500; // 获取连接的超时时间
es.max.connect.num = 100; // 最大连接数
es.max.connect.per.route = 100; // 最大路由连接数

sudo ufw allow from 10.67.31.186

# producer的开发（生产者的开发）
```
配置信息
# 如果集群中机器很多，只需配置几个，会自动搜索其他的broker。 配置多个，避免单点问题。 如果配置listeners没有明确配置ip地址，则用hostname，而不是ip地址。
bootstrap.servers=k1:9092,k2:9092,k3:9092
# 系列化的类
key.serializer=xxx
value.serializer=xxx
```s









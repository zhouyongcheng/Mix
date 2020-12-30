## QA
* kafkas生产者是批量发送消息给broker的，如果这批数据中有一个发生错误，最终是如何处理的。全体失效还是个别失效？
A：单独针对各个消息进行返回callback调用。因为sender线程负责接收broker返回的消息，并按照消息发送的顺序调用batch中的回调方法。
* 102393223



$(Kafka monitor)[https://github.com/quantifind/KafkaOffsetMonitor]

https://thepracticaldeveloper.com/2018/11/24/spring-boot-kafka-config/

(spring-boot|kafka)[https://blog.csdn.net/cowbin2012/article/details/85407495]

## kafka的监控软件

1. (kafka eagle)[http://download.smartloli.org/]

2. kafka manager

   ## topic的创建

1. 设定topic的partition数， partition是分散到各个broker上。
2. 设定partition的副本数，各个副本也存储在各个broker上，数据冗余。可靠性。
3. 每个partition都会一个leader的broker，其他副本的broker叫做flower. 写操作只会针对leader partition。
4. 如果要保障整个topic的顺序性，则一个topic创建一个partition来保障。丢失并发能力。
5. 生产环境中，topic的partition数<=broker的个数。

# 为什么要选择kafka？
* 高性能的消息发送及消息消费。
* 高吞吐率（超大量级的数据实时传输），每秒能处理的消息数（数据量）
* 实时性（低延时），客户端发送消息到客户端消费消息的时间。 高吞吐低延时。
* 消息容错性，可靠性策略（消息丢失及重复消费的避免）。
* 消息的持久化功能, 顺序的写入，零拷贝（内核完成），分布式并发读写，性能高。（消息保存到硬盘，默认7天）
* 热扩展性（分布式的，横向扩展能力，可操作性），负载均衡和故障转移。
* 秒杀的流量消峰处理。
* 异步消息处理，系统间解耦。提高整个系统的可靠性。
* 动态的上下线。集群自动维护数据的可用性（rebalance）

## kafka的消息交付保障
* producer
  消息提交到log日志文件后，只要有一个可用的包含该消息的副本，这个消息就不会丢失。
  新版本的kafka提供了幂等性的producer和事务的支持，避免重复提交消息。
  幂等性：enable.idempotence=true
  在broker会存储一个map, key=（producer_id,partition_id), value = 最新的系列号，如果后续发的消息的系列号小于等于当前缓存的系列号，就不会存储。

* consumer
  consumer的位移提交策略。
  1） 先获取若干消息，然后提交位移信息，然后消费消息，（最多一次，可能发生丢消息）;
  2)  获取若干消息，处理完成后，提交位移。 （至少一次，可能重复消费）

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
   本地单例起到zookeeper和kafka
   bin/zookeeper-server-start.sh config/zookeeper.prperties
   bin/kafka-server-start.sh  -daemon /data/soft/kafka/config/server.properties
```

# kafka常用命令

## 查看kafka版本

```
手枪
```



## 创建topic
```
bin/kafka-topics.sh --create --zookeeper localhost:2181 --topic cdn-log --replication-factor 1 --partitions 1 
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
 bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic my-replicated-topic
 bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic my-replicated-topic
```

## 通过kafka的控制台发生消息和消费消息
```
bin/kafka-console-producer.sh --broker-list 10.67.31.48:9092 --topic mytopic
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic cdn-log

bin/kafka-console-consumer.sh --bootstrap-server 10.67.31.48:9092 --topic mytopic --from-beginning

bin/kafka-console-producer.sh --broker-list 192.168.101.3:9092 --topic flink1
bin/kafka-console-consumer.sh --bootstrap-server 192.168.101.3:9092 --topic flink1 --from-beginning
```

## 增加topic的分区数
```sh
bin/kafka-topics.sh --zookeeper localhost:2181 --alter --topic tp_product_sell_out_notification --partitions 9
```

## 删除topic及相关数据
```shell
# 只会删除zookeeper中的元数据，消息文件须手动删除
bin/kafka-topics.sh  --delete --zookeeper localhost:2181 --topic tp_product_sell_out_notification 
# 方法二：待验证
bin/kafka-run-class.sh kafka.admin.DeleteTopicCommand --zookeeper localhost:2181 --topic test
```

## 消费者相关命令

```shell
# 首先我们需要知道当前有哪些消费者group，如果已知，此步骤可忽略
bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list
# 显示消费者组的相信信息
bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group GROUP_NAME --describe
kafka-consumer-groups.sh --zookeeper localhost:2181 --group g_product_sell_out_dmb --describe
# 查看消费者组的成员信息(id,host,client_id, partitions)
bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group group1 --members
```

## 查看topic某分区偏移量最大（小）值

```shell
bin/kafka-run-class.sh kafka.tools.GetOffsetShell --topic student --time -1 --broker-list localhost:9092 --partitions 0
```

## 查看topic消费进度

```
bin/kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --group groupName
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
# 把请求加入到broker的请求队列的线程数量。
num.network.threads=3
# 实际处理网络请求的线程数,处理消息的线程数（从消息队列中获取消息进行业务处理）
num.io.threads=8  
# 最大消息尺寸，超过后就报错，消息丢失。
message.max.bytes=2M
# broker维护的唯一请求队列的大小。超过后，新请求就会被阻塞。
queued.max.requests=500
# 如果一个follow副本持续的落后leader副本超过10秒，则follow副本被踢出isr.
replic.lag.time.max.ms=10000ms
log.segment.bytes=1G   # 控制kafka日志文件单个文件的大小。




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
* 使用同一组zookeeper的kafka构成同一组kafka集群。

```

## 管理kafka的集群
启动broker，启动完成后，记得查看logs/server.log确认状态。
  首先要启动zookeeper. 使用-daemon， 不要使用在后面加&符号的方式，用户退出后，进程也就退出了。
  以下是两种可选方案。
  1）bin/kafka-server-start.sh -daemon config/server.properties
  2) nohub bin/kafka-server-start.sh config/server.properties &

关闭broker
1) 下面的方式会关闭当前机器上的所有kafka实例。
  bin/kafka-server-stop.sh  
2） ps ax | grep -i 'kafka\.Kafka' | grep java | grep -v grep | awk '{print $1}'
   kill -s TERM pid

## 设置JMX端口
JMX_PORT=9997 bin/kafka-server-start.sh config/server.properties
export JMX_PORT=9997 bin/kafka-server-start.sh -daemon config/server.properties


## 增加broker
kafka的集群通过zookeeper来处理，只要在新加入的broker中取个唯一的broker.id就可以了。
kafka机器能发现新的broker并同步所有的元数据。
但是新增的broker不会分配任何已经存在的topic分区。用户必须进行手动执行分区分配。对新建的topic没有影响。

## 生产者

##    生产者消息的重复发送

1. 当写入kafka的topic的leader节点和flower节点后，给生产者客户端发送ACK消息失败后，生产者收不到ack消息，就会重新发送消息，导致消息的重复发送。
2. kafka事务的概念是针对生产者的，当生产者批量发送消息的时候，可能分发到各个partition， 分发过程中，生产者挂掉后，就可能出现数据的不一致性（30条数据，有20条写入partition成功，有10条失败的情况），事务的ID是客户端的生产者提供的。
3. 生产者在发送消息的时候，主线程是一个一个的发，但是客户端的后台发送线程是先组织好一批消息后一次发送，减少网络通信的评率，提高生产者的效率。（通过时间阀值和数量阀值来控制什么时候发送。



```
配置信息
# 如果集群中机器很多，只需配置几个，会自动搜索其他的broker。 配置多个，避免单点问题。 如果配置listeners没有明确配置ip地址，则用hostname，而不是ip地址。
bootstrap.servers=k1:9092,k2:9092,k3:9092
# 系列化的类
key.serializer=xxx
value.serializer=xxx
acks=0   : 不关心消息发送的结果，允许消息丢失，吞吐量大。
acks=1   ： 消息写入到Leader就会返回成功的通知消息，适中。
acks=all  ： 消息写入所有的partitions才通知成功。 吞吐量小，安全。
# producer端用于缓存消息的缓冲区大小，单位是字节。默认是32M
buffer.memory=33554432
compression.type=none  #默认没有压缩
compression.type=GZIP|Snappy|LZ4  # 需要配合服务端的设置进行设置。 减小网络IO。
# 重试次数的配置，可能造成消息的重复发送，比如网络抖动，消息已经写入kafka,但响应通知未发给producer，会导致重复发送。（精确一次的设计，新版本的kafka解决这个问题？）
retries=3    #重试次数设置
retry.backoff.ms=100  #默认为100Ms
# producer封装多条发往同一个partition的消息到一个batch中，减少网络请求次数。
batch.size=16384   #默认16K
batch.size=1048576   #1M
linger.ms=100   # 批量发送消息的时间间隔
# 发送请求的大小（指的是一条消息加上消息头的大小？）
max.request.size=1048576  (默认值)
# producer发送消息给broker，需要在指定的时间范围内返回处理结果个producer，超过时间，producer就认为请求超时，报timeout异常。
request.timeout.ms=30000 (30秒)
```

## producer如何避免数据丢失及乱序的问题。
无消息丢失的配置策略
```
#当缓存区满后，producer处于阻塞状态并停止消息，而不是抛出异常
block.on.buffer.full=true 
# 新版本的kafka通过下面的参数进行控制。
max.block.ms=1000
acks=all
# producer只会重试那些可以恢复的异常，错误，不可恢复的是不会重试的。
retries=Integer.MAX_VALUE
# 单个broker的连接，能够发送未响应的请求的数量。 producer未收到上个请求的响应，无法发送新的请求。
max.in.flight.requests.per.connection=1

## broker端的配置
不允许非ISR的副本被选举为Leader，避免数据丢失。
unclean.leader.election.enable=false
replication.factor=3
min.insync.replicas=2   （只有producer的acks=all或者-1的时候，才有意义）
推荐配置replication.factor=min.insync.replicas+1
enable.auto.commit=false
-- 调用方式
KafkaProducer.send(record, Callback() {}), 在callback中发送异常时显示关闭producer.
```

### 生产者API

1. 生产者发送消息是异步的方式，客户端程序中写的代码部分是同步方式，但在通过api的send方法发送后，会产生一个后台线程进行发送消息，就构成了异步发送的过程。（有客户端API来实现）。
2. 生产者对ack信息的处理， 如果接收到ack，则更加ack判断正常，异常进行处理。如果未收到，怎么处理？重试？（可能出现重复发送的问题，解决这个问题，是否需要在消费者端协调处理，避免重复数据的重复消费？）
3. 主线程(main)和send线程共同完成消息发送。中间通过RecordAccumulator来协调。
4. 拦截器，系列化和分区都是在生产者端指定的。



## 消费者

1. 各种消费者组的消费一致性（高水位机制）
2. 不能保障消息的丢失。
3. 消费者组中的消费者个数发生变化时，会对消费的partition信息进程重新分配。
4. 消费的偏移量是以[组，topic, partition] 为单位记录的。当一个partition重新分配给组内的另外一个消费       者后，不会产生消息的重复消费的问题。
5. 高水位的概念：针对的是同一个partition中的leader和follower节点的内容，消费者只能消费在高水位以前的数据，避免leader重选后，获取不到数据。水位线取在isr中的各个broker中LEO(log end offset)最小的为水位线。 消费者消费数据的一致性。可能会出现数据丢失和数据重复的问题。 就是flower没完全同步过来，但leader挂掉，新选举的leader的数据就会少了。新写入到leader，以前leader没有同步过来的消息就丢失了。新选举出来的leader会发出各个flower截取到新的水位线的数据（丢弃高于水位线的消息丢失）【储存一致性，消费一致性】。
6. 消费者的位移信息是保存在zk或者kafka中，有启动kafka消费者的参数决定。--zookeeper 或者 --bootstrap-server区分。

数据重复： 当leader挂掉后，各个flower会同步部分数据，产生新的水位线。 生产者未收到leader的ack信息，重新发送消息，就会导致在前一个水位线和当前水位线的数据产生重复。

消费者消费partition的分区策略

1）roundRobin

2）Range： 可能出现消费的消息partion不对等的情况，一个消费者消费比较多的partition的，另一个消费少的partition。常出现在一个消费者组消费多个topic的情况。



### 消费者自动提交(offset)

消费者提交offset成功后，如果消费者挂掉，则同一组的不同消费者来进行消费，如果是earlier模式，则会从提交点后的offset开始消费，避免消息的丢失。如果是last模式，则会丢掉保存的offset后及当前到来消息前的消息。offset偏移量的保存[group:topic:partition=offset]

消费者自动提交会出现数据丢失的问题， 比如自动提交的时间是100毫秒，那么当消费者获取一笔数据进行处理，在100毫秒内不能正常的处理完，这时，自动就提交offset到zookeeper或者_consumer_offset里， 后面消费者处理失败了，则会发生处理失败记录的丢失。

先提交后处理，会出现数据丢失的情况。

先处理消息后提交offset，则会出现重复消费的情况。 比如消费一批消息写入mysql， 但在提交的时候失败。则下次消费的时候就出现相同消息重复写入mysql的情况。

### 消费者手动提交

1. 配置enable.auto.commit = false   

2. 同步手动提交

3. 异步手动提交

   消费者命令行提交偏移量

   ```
   ./kafka-consumer-groups.sh --bootstrap-server 172.18.67.59:9092,172.18.67.60:9092,172.18.67.61:9092 --group g_product_sell_out_trace --topic tp_product_sell_out_notification_trace --reset-offsets --to-latest --execute
   ```

   

### 消费者自定义存储offset的方式

默认情况下，offset可以存着zookeeper中或者kafka本身的_consumer_offset主题中。

自定义的话，可以考虑把业务处理的逻辑和提交offset的逻辑放在一个支持事务处理的逻辑中。这样就能保障其事务一致性。比如mysql等。

幂等性：

生产者的幂等性： enable.idompotence=true



```
auto.offset.reset值含义解释
earliest 
当各分区下有已提交的offset时，从提交的offset开始消费；无提交的offset时，从头开始消费 
latest 
当各分区下有已提交的offset时，从提交的offset开始消费；无提交的offset时，消费新产生的该分区下的数据 
none 
topic各分区都存在已提交的offset时，从offset后开始消费；只要有一个分区不存在已提交的offset，则抛出异常

# 1）consumerGroup检查组内成员发送崩溃的时间设置。
session.timeout.ms=10000ms (10秒)   #新版本用于确定consumer崩溃的时间
#2）消息处理逻辑的最大时间。也就是消费者poll出数据后的处理时间大于这个设置的时间，认为这个消费者已经落后其他消费者了，就会被踢出组。该消费者负责的分区被重新分配给其他消费者。理想情况下，会导致rebalance.如果业务处理慢，设置大一点，能完成业务的处理时间。
max.poll.interval.ms=120000
# 单次poll获取的消息记录数，如果在单位时间内处理不完，可以设小该参数。
max.poll.records=50
# auto.offset.reset=earlist|latest|none
enable.auto.commit=true|false
# 如果实际业务的消息很大，设置这个值满足需求。
fetch.max.bytes=xxxx
# rebalance的时候，其他成员感知新一轮的rebalce的时间。   
heartbeat.interval.ms < session.timeout.ms
heartbeat.interval.ms
# 用户环境不在乎Socket资源开销，推荐设置为-1，不要关闭空闲连接。
connections.max.idle.ms=-1
```

## offset对应消费者的意义
>最多一次： 消息可能丢失，但不会被重复处理。
 消息读取后，在处理之前就提交消息，保障只会被处理一次。 但提交后消息可能处理失败[丢失] 

>最少一次： 消息不会丢失，但可能被处理多次。
消息消费后提交offset，则保障至少一次。 消息被处理后，提交过程失败，则可能重复消费。

>精确一次： 消息一定会被处理，而且只被处理一次。


## rebalance的触发条件
* 组成员发送变更
  1）consumer的进程挂掉
  2）consumer无法在指定的时间内完成消息的处理，则认为consumer挂掉了。
  调整下面3个参数的配置。避免处理不完导致rebalance的情况。
  request.timeout.ms
  max.poll.records
  max.poll.interval.ms

* 组订阅的topic发送变更
* 组订阅的topic的分区发送变更

## kafka日志文件的保留策略
* 基于时间的留存策略 默认会删除7天前的数据，删除log文件，index文件，timeindex文件。
 log.retention.ms|minutes|hours
* 基于大小的留存策略
 log.retention.bytes=-1

 ## 消费者组的管理
 bin/kafka-consumer-groups.sh --bootstrap-server 10.67.31.48:9092
 --list
 --describe
 --group
 --zookeeper
 --reset-offset

> 列出集群中所有的消费者组
bin/kafka-consumer-groups.sh --bootstrap-server 10.67.31.48:9092 --list







# 注意事项
```
1. flink内部封装了状态数据，而且状态数据并不会被清理，因此一定要避免在一个无限数据流上使用aggregation。
```

## 1. flink指令集合

### 1.1 集群命令

````shell
bin/start_cluster.sh
bin/stop-cluster.sh
````

### 1.2 JobManager命令

````shell
bin/jobmanager.sh stop | start
````



## 2. flink的集群安装

### 2.1 服务器配置列表

| 节点名称              |    flink    |      |      |      |      |
| --------------------- | :---------: | ---- | ---- | ---- | ---- |
| node03:192.168.101.3  | JobManager  |      |      |      |      |
| node14:192.168.101.14 |             |      |      |      |      |
| node21:192.168.101.21 | TaskManager |      |      |      |      |
| node22:192.168.101.22 | TaskManager |      |      |      |      |
| node23:192.168.101.23 | TaskManager |      |      |      |      |

### 2.2 配置文件及修改

| flink-conf.yml |                                                              |      |
| -------------- | ------------------------------------------------------------ | ---- |
| masters        | node03:8081                                                  |      |
| slaves         | node21<br />node22<br />node23                               |      |
| zoo.cfg        | server.1=node21:2888:3888<br/>server.2=node22:2888:3888 <br/>server.3=node23:2888:3888 |      |
|                |                                                              |      |
|                |                                                              |      |

### 2.3 集群模式

#### 2.3.1 standaloneHA模式

````properties
#  在Node03上配置完成后，把配置信息同步到node14, node21,node22,node23
1> 需要配置zookeeper集群

# conf/masters文件配置
node03:8081
node14:8081
 
# conf/slaves文件配置
node21
node22
node23
 
# conf/flink-conf.ymal文件配置
jobmanager.rpc.address: node03
jobmanager.rpc.port: 6123
high-availability: zookeeper
high-availability.storageDir: hdfs:///flink/ha/
high-availability.zookeeper.quorum: node21:2181,node22:2181,node23:2181
high-availability.zookeeper.client.acl: open
high-availability.zookeeper.path.root: /flink
high-availability.cluster-id: /cluster-mc
````



#### 2.3.2 yarn管理模式

```properties
1）启动zookeeper集群
2）启动hadoop集群。

yarn-session.sh -n 2 -s 2 -jm 1024 -tm 1024 -nm test -d
-n : TaskManager的数量
-s ： slot的数量
-jm ：JobManager的内存mb
-tm : TaskManager的内存mb
-nm ：yarn上的appName名
-d： 后台运行
```

#### 



## 访问地址

| Flink管理节点访问 | http:node03:8081 |      |
| ----------------- | ---------------- | ---- |
|                   |                  |      |
|                   |                  |      |
|                   |                  |      |
|                   |                  |      |

## 流处理中要解决的问题

### 时间系列问题

### 数据状态问题

1. 状态保存
2. 状态恢复

## flink的优点
1. 快
2. 批流统一，同时支持批处理和流处理。
3. exactlyonce，精确一致性。
4. 分布式，横向扩展容易，能处理大数据。
5. checkpoint支持，就是断点续传的特定，能从savepoint进行有状态恢复。
6. 低延迟，吞吐量高，exactly-once， 编程api丰富。api变化快，也是也个缺点。

## flink的组件

1. JobManager
2. ResourceManager
3. TaskManager
4. Dispatcher

JobManager从ResourceManager申请资源（taskmanager slots）来运行一个job中的各个task，通常情况下，一个flink集群环境下会运行着多个TaskManager， 每个taskManager能提供一定数量的slots. TaskManager会把自己有的资源信息注册到ResoureManager

下载解压完成安装 [下载](http://flink.apache.org/downloads.html)

## 创建flink的maven项目


```shell
curl https://flink.apache.org/q/quickstart.sh | bash -s 1.10.0
```

## 提交任务job给flink框架进行处理
```shell
1. flink run -m node21:8081 ./examples/batch/WordCount.jar --input /opt/wcinput/wc.txt --output /opt/wcoutput/
2. flink run -m node21:8081 ./examples/batch/WordCount.jar --input hdfs:///user/admin/input/wc.txt --output hdfs:///user/admin/output2
3. /data/soft/flink-1.9.0/bin/flink run -m node03:8081 ../quickstart/target/quickstart-0.1.jar --input /data/tmp/word.txt  --output /data/tmp/count.txt
4. bin/flink run -c com.cmwin.wordcount.WordCountKafkaInStdOut /data/Projects/FlinkDemo/target/flink-demo-0.1.jar
```
## 输入到print中的信息查看
>程序的输出会打到Flink主目录下面的log目录下的.out文件中


## flink的开发流传

## flink从kafka中获取数据
## 启动本地flink集群,非root用户启动

```
./bin/start-cluster.sh
./bin/stop-cluster.sh
./bin/flink run -c com.cmwin.demo.MyJob /data/jobs/myjob.jar
```

## flink的集群模式

* standalone： 不依赖其他的资源调度框架，不依赖yarn，kerberters等资源管理器。

* cluster安装方式

* flink高可用配置

  ```properties
  #  在Node03上配置完成后，把配置信息同步到node14, node21,node22,node23上
   # masters
   node03:8081
   node14:8081
   
   # slaves
   node21
   node22
   node23
   
   # flink-conf.ymal
   jobmanager.rpc.address: node03
   jobmanager.rpc.port: 6123
   high-availability: zookeeper
   high-availability.storageDir: hdfs:///flink/ha/
   high-availability.zookeeper.quorum: node21:2181,node22:2181,node23:2181
   high-availability.zookeeper.client.acl: open
   high-availability.zookeeper.path.root: /flink
   high-availability.cluster-id: /cluster-mc
  ```

  

## 3. flink访问hive

### 3.0 flink依赖的hive包

```shell
# /data/soft/flink1.10.0/lib/
# 下面这些依赖包,从/data/soft/hive3.1.2/lib目录下拷贝.
datanucleus-api-jdo-4.2.4.jar
datanucleus-core-4.1.17.jar
datanucleus-rdbms-4.1.19.jar
flink-connector-hive_2.12-1.10.0.jar
flink-dist_2.12-1.10.0.jar
flink-shaded-hadoop-2-uber-2.8.3-8.0.jar
flink-table_2.12-1.10.0.jar
flink-table-api-java-bridge_2.11-1.10.0.jar
flink-table-blink_2.12-1.10.0.jar
HikariCP-2.6.1.jar
hive-beeline-3.1.2.jar
hive-common-3.1.2.jar
hive-exec-3.1.2.jar
hive-metastore-3.1.2.jar
hive-shims-common-3.1.2.jar
jackson-core-2.9.5.jar
javax.jdo-3.2.0-m3.jar
libfb303-0.9.3.jar
log4j-1.2.17.jar
metrics-core-3.1.0.jar
mysql-connector-java-5.1.43.jar
slf4j-log4j12-1.7.15.jar
```



### 3.1 配置hive的catelog信息

```yaml
catalogs: [mchive]
  - name: mchive
    type: hive
    hive-conf-dir: /data/soft/hive-3.1.2/conf
    default-database: mc
    
execution:
  planner: blink
  type: batch
  current-catalog: mchive
  current-database: mc
```

### 3.2 启动hive的metastore并连接hive

```shell
hive --service metastore
# 在/data/soft/flink-1.10.0/conf目录下放/hive-site.xml文件.
bin/sql-client.sh embedded -d conf/sql-client-hive.yaml
```




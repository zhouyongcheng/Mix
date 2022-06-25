## 学习资料



[flink学习Aliyun]: https://developer.aliyun.com/article/753



```
https://developer.aliyun.com/article/753999

```



## 注意事项

```
1. flink内部封装了状态数据，而且状态数据并不会被清理，因此一定要避免在一个无限数据流上使用aggregation。
```

## 1. flink指令集合

### 1.1 集群命令

````shell
bin/flink --version
bin/start_cluster.sh
bin/stop-cluster.sh
http://localhost:8081
nc -l 9999   -- 开启socket连接
````

### 1.2 JobManager命令

````shell
bin/jobmanager.sh stop | start
````

1.3 提交程序到flink执行

```shell
mvn clean package -Dmaven.test.skip=true
flink run -c demo.SocketTextStreamWordCount /home/demo/word-count-1.0-SNAPSHOT.jar 127.0.0.1 9000
nc -lk 9999
```

www.itellyou.cn

## flink cdc相关

### flink启动sql控制台

```shell
./bin/sql-client.sh embedded
> set execution.result-mode=tableau;
>set sql-client.execution.result-mode=table;

```

### 创建flink的关联表

```sql
CREATE TABLE test_flink_cdc ( 
  id INT, 
  name STRING,
  primary key(id)  NOT ENFORCED
) WITH ( 
  'connector' = 'mysql-cdc', 
  'hostname' = 'localhost', 
  'port' = '3306', 
  'username' = 'root', 
  'password' = '123456', 
  'database-name' = 'mcsell', 
  'table-name' = 'demo' 
);
```



## 2. flink的集群安装

### 2.1 服务器配置列表

| 节点名称              |    flink    | PC      |      |      |      |
| --------------------- | :---------: | ------- | ---- | ---- | ---- |
| node03:192.168.101.3  | JobManager  | thinkpd |      |      |      |
| node14:192.168.101.14 |             | server  |      |      |      |
| node21:192.168.101.21 | TaskManager | server  |      |      |      |
| node22:192.168.101.22 | TaskManager | server  |      |      |      |
| node23:192.168.101.23 | TaskManager | server  |      |      |      |

### 2.2 配置文件

#### 2.2.1 基础信息配置[JobManager, TaskManager]

```yaml
# 在一台服务器上配置完成后，复制到其他服务器就可以。
# jobManager 的IP地址
jobmanager.rpc.address: node03

# JobManager 的端口号
jobmanager.rpc.port: 6123

# JobManager JVM heap 内存大小
jobmanager.heap.size: 1024m

# TaskManager JVM heap 内存大小
taskmanager.heap.size: 1024m

# 每个 TaskManager 提供的任务 slots 数量大小

taskmanager.numberOfTaskSlots: 1

# 程序默认并行计算的个数
parallelism.default: 1

# 文件系统来源
# fs.default-scheme

# #web ui端口
rest.port: 8081
```



#### 2.2.2 修改Flink配置文件masters

```
vim flink-1.11.2/conf/masters
node03
```



#### 2.2.3 修改Flink配置文件workers

```
node21
node22
node23
```



#### 2.2.4 将node03节点上修改好的flink复制到其他两个Slave节点

#### 2.2.2  高可用配置

```yaml
# 可以选择 'NONE' 或者 'zookeeper'.
# high-availability: zookeeper

# 文件系统路径，让 Flink 在高可用性设置中持久保存元数据
# high-availability.storageDir: hdfs:///flink/ha/

# zookeeper 集群中仲裁者的机器 ip 和 port 端口号
# high-availability.zookeeper.quorum: localhost:2181

# 默认是 open，如果 zookeeper security 启用了该值会更改成 creator
# high-availability.zookeeper.client.acl: open

```

#### 2.2.3 容错和检查点 配置

```yaml
# 用于存储和检查点状态
# state.backend: filesystem

# 存储检查点的数据文件和元数据的默认目录
# state.checkpoints.dir: hdfs://namenode-host:port/flink-checkpoints

# savepoints 的默认目标目录(可选)
# state.savepoints.dir: hdfs://namenode-host:port/flink-checkpoints

# 用于启用/禁用增量 checkpoints 的标志
# state.backend.incremental: false
```



### 2.2 配置文件及修改

| flink-conf.yml |                                                              |      |
| -------------- | ------------------------------------------------------------ | ---- |
| masters        | node03:8081                                                  |      |
| slaves         | node21<br />node22<br />node23                               |      |
| zoo.cfg        | server.1=node21:2888:3888<br/>server.2=node22:2888:3888 <br/>server.3=node23:2888:3888 |      |
|                |                                                              |      |
|                |                                                              |      |



### 2.3 集群模式

#### 2.3.0 本地开发模式

```properties
1: 直接下载并解压到~/soft目录下。
2: bin/start-cluster.sh
3: http://localhost:8081
4: bin/flink run examples/streaming/WordCount.jar
5: bin/stop-cluster.sh
```



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

http://localhost:8081/#/overview

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

## flink的数据源

```properties
# 基于集合
1、fromCollection(Collection) - 从 Java 的 Java.util.Collection 创建数据流。集合中的所有元素类型必须相同。
2、fromCollection(Iterator, Class) - 从一个迭代器中创建数据流。Class 指定了该迭代器返回元素的类型。
3、fromElements(T …) - 从给定的对象序列中创建数据流。所有对象类型必须相同。

# 基于集合
final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
DataStream<String> text = env.readTextFile("file:///path/to/file");

# 基于socket

# 第三方或自己定义source
StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
DataStream<KafkaEvent> input = env
		.addSource(
			new FlinkKafkaConsumer011<>(
				parameterTool.getRequired("input-topic"), //从参数中获取传进来的 topic 
				new KafkaEventSchema(),
				parameterTool.getProperties())
			.assignTimestampsAndWatermarks(new CustomWatermarkExtractor()));
			
# 			
```



## flink的sink

```properties
# 目的： 把处理的结果存入到指定的sink中
```

## flink的转化操作

### Map操作  

```java
# 输入1个内容，转化为另外一个内容。
    SingleOutputStreamOperator<Student> map = student.map(new MapFunction<Student, Student>() {
        @Override
        public Student map(Student value) throws Exception {
            Student s1 = new Student();
            s1.id = value.id;
            s1.name = value.name;
            s1.password = value.password;
            s1.age = value.age + 5;
            return s1;
        }
});
map.print();

```

###  FlatMap:

```java
# 输入1个内容，转化为0个或在多个内容。
SingleOutputStreamOperator<Student> flatMap = student.flatMap(new FlatMapFunction<Student, Student>() {
    @Override
    public void flatMap(Student value, Collector<Student> out) throws Exception {
        if (value.id % 2 == 0) {
            out.collect(value);
        }
    }
});
flatMap.print();


```

### Filter

```java
// 条件为true的数据返回到，false的丢弃。
SingleOutputStreamOperator<Student> filter = student.filter(new FilterFunction<Student>() {
    @Override
    public boolean filter(Student value) throws Exception {
        if (value.id > 95) {
            return true;
        }
        return false;
    }
});
filter.print();
```

### KeyBy

```java
// 逻辑上是基于 key 对流进行分区。在内部，它使用 hash 函数对流进行分区。它返回 KeyedDataStream 数据流
KeyedStream<Student, Integer> keyBy = student.keyBy(new KeySelector<Student, Integer>() {
    @Override
    public Integer getKey(Student value) throws Exception {
        return value.age;
    }
});
keyBy.print();
```

### Reduce

```java
//Reduce 返回单个的结果值，并且 reduce 操作每处理一个元素总是创建一个新值。常用的方法有 average, sum, min, max, count，使用 reduce 方法都可实现。
SingleOutputStreamOperator<Student> reduce = student.keyBy(new KeySelector<Student, Integer>() {
    @Override
    public Integer getKey(Student value) throws Exception {
        return value.age;
    }
}).reduce(new ReduceFunction<Student>() {
    @Override
    public Student reduce(Student value1, Student value2) throws Exception {
        Student student1 = new Student();
        student1.name = value1.name + value2.name;
        student1.id = (value1.id + value2.id) / 2;
        student1.password = value1.password + value2.password;
        student1.age = (value1.age + value2.age) / 2;
        return student1;
    }
});
reduce.print();
```

### Aggregation

```java
// 例如 min，max，sum 等。 这些函数可以应用于 KeyedStream 以获得 Aggregations 聚合。
// max 和 maxBy 之间的区别在于 max 返回流中的最大值，但 maxBy 返回具有最大值的键， min 和 minBy 同理。
KeyedStream.sum(0) 
KeyedStream.sum("key") 
KeyedStream.min(0) 
KeyedStream.min("key") 
KeyedStream.max(0) 
KeyedStream.max("key") 
KeyedStream.minBy(0) 
KeyedStream.minBy("key") 
KeyedStream.maxBy(0) 
KeyedStream.maxBy("key")
```



### union

```java
// Union 函数将两个或多个数据流结合在一起。 这样就可以并行地组合数据流。 如果我们将一个流与自身组合，那么它会输出每个记录两次。
inputStream.union(inputStream1, inputStream2, ...);
```



### connect

```java
//获取Flink运行环境
StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

//绑定数据源
DataStreamSource<Long> text1 = env.addSource(new MyParalleSource()).setParallelism(1);
DataStreamSource<Long> text2 = env.addSource(new MyParalleSource()).setParallelism(1);

//为了演示connect的不同，将第二个source的值转换为string
SingleOutputStreamOperator<String> text2_str = text2.map(new MapFunction<Long, String>() {
    @Override
    public String map(Long value) throws Exception {
        return "str" + value;
    }
});

ConnectedStreams<Long, String> connectStream = text1.connect(text2_str);

SingleOutputStreamOperator<Object> result = connectStream.map(new CoMapFunction<Long, String, Object>() {
    @Override
    public Object map1(Long value) throws Exception {
        return value;
    }

    @Override
    public Object map2(String value) throws Exception {
        return value;
    }
});

//打印到控制台,并行度为1
result.print().setParallelism(1);
env.execute( "StreamingDemoWithMyNoParalleSource");
```



### Split

```java
/获取Flink运行环境
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        
        //绑定数据源
        DataStreamSource<Long> text = env.addSource(new MyParalleSource()).setParallelism(1);
        //对流进行切分 奇数偶数进行区分
        SplitStream<Long> splitString = text.split(new OutputSelector<Long>() {
            @Override
            public Iterable<String> select(Long value) {
                ArrayList<String> output = new ArrayList<>();
                if (value % 2 == 0) {
                    output.add("even");//偶数
                } else {
                    output.add("odd");//奇数
                }
 
                return output;
            }
        });
 
        //选择一个或者多个切分后的流
        DataStream<Long> evenStream = splitString.select("even");//选择偶数
        DataStream<Long> oddStream = splitString.select("odd");//选择奇数
 
        DataStream<Long> moreStream = splitString.select("odd","even");//选择多个流
        //打印到控制台,并行度为1
        evenStream.print().setParallelism(1);
        env.execute( "StreamingDemoWithMyNoParalleSource");
```

### Select

```java
// 功能允许您从拆分流中选择特定流。
SplitStream<Integer> split;
DataStream<Integer> even = split.select("even"); 
DataStream<Integer> odd = split.select("odd"); 
DataStream<Integer> all = split.select("even","odd");

```

### 窗口函数

```java
// umbling time windows(翻滚时间窗口)
data.keyBy(1)
	.timeWindow(Time.minutes(1)) //tumbling time window 每分钟统计一次数量和
	.sum(1);
//sliding time windows(滑动时间窗口)
data.keyBy(1)
	.timeWindow(Time.minutes(1), Time.seconds(30)) //sliding time window 每隔 30s 统计过去一分钟的数量和
	.sum(1);
```

### count window

```java
data.keyBy(1)
	.countWindow(100) //统计每 100 个元素的数量之和
	.sum(1);
	
	//每 10 个元素统计过去 100 个元素的数量之和
	data.keyBy(1) 
	.countWindow(100, 10) 
	.sum(1);
```









## flink的组件

1. JobManager
2. ResourceManager
3. TaskManager
4. Dispatcher

JobManager从ResourceManager申请资源（taskmanager slots）来运行一个job中的各个task，通常情况下，一个flink集群环境下会运行着多个TaskManager， 每个taskManager能提供一定数量的slots. TaskManager会把自己有的资源信息注册到ResoureManager

下载解压完成安装 [下载](http://flink.apache.org/downloads.html)

## 创建flink的maven项目

```shell
mvn archetype:generate \
    -DarchetypeGroupId=org.apache.flink \
    -DarchetypeArtifactId=flink-walkthrough-datastream-java \
    -DarchetypeVersion=1.14.0 \
    -DgroupId=com.amy.flink \
    -DartifactId=flink14demo \
    -Dversion=0.1 \
    -Dpackage=spendreport \
    -DinteractiveMode=false

```


```shell
1. curl https://flink.apache.org/q/quickstart.sh | bash -s 1.14.0
2. 在idea中打开项目
3. 注释调maven依赖中的provided,这样就能直接在idea中运行项目。
4. 把demo代码中的env.execute("Flink Batch Java API Skeleton");给注释掉，否则会报错。
5. ctrl + shif + f10运行代码。
```

示例代码

```java
public class BatchJob {

	public static void main(String[] args) throws Exception {
		// set up the batch execution environment
		final ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
		DataSource<String> dataSource = env.fromElements("a", "b", "c");
		long count = dataSource.count();
		System.out.println("element count = "+ count);
//		env.execute("Flink Batch Java API Skeleton");
	}
}
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


## flink的开发流程

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



## flink table

### flink sql client

```shell
1）bin/start-cluster.sh
2) bin/sql-client.sh embedded

SET execution.result-mode=table;
SET execution.result-mode=changelog;

# 执行查询语句。
SELECT name, 
  COUNT(*) AS cnt 
  FROM (VALUES ('Bob'), ('Alice'), ('Greg'), ('Bob')) 
  AS NameTable(name) 
  GROUP BY name;
```

### flink connector使用

1. 开启checkpoint, 每3秒执行一次

```shell
Flink SQL> SET execution.checkpointing.interval = 3s;
```

2. 创建数据库表

   ```sql
   CREATE TABLE demo (    
       id INT,
       name STRING,
       PRIMARY KEY (id) NOT ENFORCED  
   ) WITH (
       'connector' = 'mysql-cdc',
       'hostname' = 'localhost',
       'port' = '3306',
       'username' = 'root',
       'password' = '123456',
       'database-name' = 'mcsell',
       'table-name' = 'demo'  
   );
   
   将来
   
   CREATE TABLE products (    
       id INT,
       name STRING,
       description STRING,
       PRIMARY KEY (id) NOT ENFORCED  
   ) WITH (
       'connector' = 'mysql-cdc',
       'hostname' = 'localhost',
       'port' = '3306',
       'username' = 'root',
       'password' = '123456',
       'database-name' = 'mydb',
       'table-name' = 'products'  
   );
   CREATE TABLE orders (   
       order_id INT,   
       order_date TIMESTAMP(0),
       customer_name STRING,
       price DECIMAL(10, 5),
       product_id INT,
       order_status BOOLEAN,
       PRIMARY KEY (order_id) NOT ENFORCED 
   ) WITH (   
       'connector' = 'mysql-cdc',
       'hostname' = 'localhost',
       'port' = '3306',
       'username' = 'root',
       'password' = '123456',
       'database-name' = 'mydb',
       'table-name' = 'orders' );
      
   CREATE TABLE shipments (   shipment_id INT,   order_id INT,   origin STRING,   destination STRING,   is_arrived BOOLEAN,   PRIMARY KEY (shipment_id) NOT ENFORCED ) WITH (   'connector' = 'postgres-cdc',   'hostname' = 'localhost',   'port' = '5432',   'username' = 'postgres',   'password' = 'postgres',   'database-name' = 'postgres',   'schema-name' = 'public',   'table-name' = 'shipments' );
   ```

   

3. xx
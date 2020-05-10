# 注意事项
```
1. flink内部封装了状态数据，而且状态数据并不会被清理，因此一定要避免在一个无限数据流上使用aggregation。
```

## 本地安装

## 服务器配置列表

| 节点名称              |    flink    |      |      |      |      |
| --------------------- | :---------: | ---- | ---- | ---- | ---- |
| node03:192.168.101.3  | JobManager  |      |      |      |      |
| node14:192.168.101.14 |             |      |      |      |      |
| node21:192.168.101.21 | TaskManager |      |      |      |      |
| node22:192.168.101.22 | TaskManager |      |      |      |      |
| node23:192.168.101.23 | TaskManager |      |      |      |      |

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

JobManager从ResourceManager申请资源（taskmanager slots）来运行一个job中的各个task，通常情况下，一个flink集群环境下会运行着多个TaskManager， 每个taskManager能提供一定数量的slots. TaskManager会把自己有的资源信息注册到ResoureManager去。



下载解压完成安装 [下载](http://flink.apache.org/downloads.html)

## 启动本地实例
```
bin/start_cluster.sh
```


## 启动本地flink集群,非root用户启动
/bin/start-cluster.sh

## 创建flink的maven项目


```shell
curl https://flink.apache.org/q/quickstart.sh | bash -s 1.10.0
```

## 提交任务job给flink框架进行处理
```
1. flink run -m node21:8081 ./examples/batch/WordCount.jar --input /opt/wcinput/wc.txt --output /opt/wcoutput/
2. flink run -m node21:8081 ./examples/batch/WordCount.jar --input hdfs:///user/admin/input/wc.txt --output hdfs:///user/admin/output2
3. /data/soft/flink-1.9.0/bin/flink run -m node03:8081 ../quickstart/target/quickstart-0.1.jar --input /data/tmp/word.txt  --output /data/tmp/count.txt
4. bin/flink run --class com.cmwin.wordcount.WordCountKafkaInStdOut /data/Projects/FlinkDemo/target/flink-demo-0.1.jar
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
* 


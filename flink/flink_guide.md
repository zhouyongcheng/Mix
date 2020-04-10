# 注意事项
```
1. flink内部封装了状态数据，而且状态数据并不会被清理，因此一定要避免在一个无限数据流上使用aggregation。
```

## 本地安装
下载解压完成安装 [下载](http://flink.apache.org/downloads.html)

## 启动本地实例
```
bin/start_cluster.sh
```


## 启动本地flink集群,非root用户启动
/bin/start-cluster.sh

## 创建flink的maven项目
curl https://flink.apache.org/q/quickstart.sh | bash -s 1.10.0

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


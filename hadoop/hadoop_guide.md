[hadoop](https://www.yiibai.com/hadoop)
## 启动Hadoop集群
* 单机模式
* 伪分布式模式
* 完全分布式模式

## ssh localhost免密登录
```
ssh-keygen -t rsa
cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys 
```

## install hadoop
下载hadoop的压缩包，解压到/usr/local/hadoop.
chown -R hadoop:hadoop /usr/local/hadoop


# Hadoop HDFS操作
* 格式化配置HDFS文件系统
> hadoop namenode -format
* 启动分布式文件系统
> start-dfs.sh
> stop-dfs.sh
* HDFS的文件列表
> $HADOOP_HOME/bin/hadoop fs -ls <args>
* 将数据插入到HDFS
```
    $HADOOP_HOME/bin/hadoop fs -mkdir /user/input 
    $HADOOP_HOME/bin/hadoop fs -put /home/file.txt /user/input
    $HADOOP_HOME/bin/hadoop fs -ls /user/input
    $HADOOP_HOME/bin/hadoop fs -cat /user/output/outfile 
    从HDFS得到文件使用get命令在本地文件系统。
    $HADOOP_HOME/bin/hadoop fs -get /user/output/ /home/hadoop_tp/ 
```

* xx
* xx

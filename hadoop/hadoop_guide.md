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

## zookeeper的集群安装
```
node21:/data/soft/zookeeper
node22:/data/soft/zookeeper
node23:/data/soft/zookeeper
1. 编辑zookeeper/conf/zoo.cfg
   tickTime=2000
    dataDir=/data/zookeeper
    clientPort=2181
    initLimit=5
    syncLimit=2
    server.1=192.168.101.21:2888:3888
    server.2=192.168.101.22:2888:3888
    server.3=192.168.101.23:2888:3888

2. 创建/data/zookeeper文件夹
3. 在/data/zookeeper目录下创建myid文件,内容分别为1,2,3
4. 分别在3个节点起点zookeeper
    编辑/etc/profile,添加ZK_HOME及PATH信息.
 5. 以下命令来连接一个zk集群
   > bin/zkCli.sh -server 192.168.101.21:2181,192.168.101.22:2181,192.168.101.23:2181
6. 注意防火墙可能导致节点间不通导致访问失败.
   > WatchedEvent state:SyncConnected type:None path:null 表示连接成功.   
```

## hadoop的安装
> 注意：每个节点的安装和配置是相同的，通常在master中配置完成后，把安装目录复制到其他节点。特别注意的是，使用普通用户，非root用户。
> 如果是生产环境，考虑单独创建个用户和用户组来负责hadoop的相关安装和配置。

* hadoop版本的选择，实验环境选择hadoop-3.2.1
* 解压安装到/data/soft/hadoop-3.2.1  
* 配置环境变量HADOOP_HOME
* 配置$HADOOP_HOME/etc/hadoop/hadoop-env.sh, 修改JAVA_HOME的地址
* 配置yarn环境信息$HADOOP_HOME/etc/hadoop/yarn_env.sh,修改JAVA_HOME的地址.

## 配置核心文件
* core-site.xml
```
<property>
    <name>fs.defaultFS</name>
    <value>hdfs://master:9000</value>
</property>
<property>
    <name>hadoop.tmp.dir</name>
    <value>/data/hadoop/tmp</value>
</property>
```
* hdfs-site.xml
```
# HDFS的最大副本数就是3,超过3也是没有意义的。
<property>
    <name>dfs.replication</name>
    <value>l</value >
</property>
```
* yarn-site.xml
```

```

* x
* 

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


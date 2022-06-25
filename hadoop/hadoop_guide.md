[hadoop](https://www.yiibai.com/hadoop)

## 集群安装

### 基础环境设置

```shell
# 设置主机名称
sudo hostnamectl set-hostname node41
sudo hostnamectl set-hostname node42
sudo hostnamectl set-hostname node43

#编辑/etc/hosts
192.168.101.41 node41
192.168.101.42 node42
192.168.101.43 node43

# 下载hadoop3.1.4并解压到node41：/usr/local/hadoop,设置环境变量
export HADOOP_HOME=/usr/local/hadoop
export PATH=$PAGH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
# 生效
source /etc/profile

# 修改配置文件
mkdir -p /usr/local/hadoop/data
mkdir -p /usr/local/hadoop/hdfs/name
mkdir -p /usr/local/haddop/hdfs/data
```

### core-sizte.xml修改

```xml
<configuration>
  <!--定义namenode地址 默认9000-->
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://node41:9003</value>
  </property>
  <!--修改用于hadoop存储数据的默认位置-->
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/usr/local/hadoop/data</value>
  </property>
</configuration>
```

### hdfs-site.xml 配置

```xml
<configuration>
<property>
  <name>dfs.namenode.name.dir</name>
  <value>/usr/local/hadoop/hdfs/name</value>
</property>
<property>
    <name>dfs.datanode.data.dir</name>
    <value>/usr/local/hadoop/hdfs/data</value>
</property>
<property>
    <name>dfs.replication</name>
    <value>1</value>
</property>
</configuration>
```

### mapred-site.xml 配置

```xml
<configuration>
   <property>
       <name>mapreduce.framework.name</name>
       <value>yarn</value>
   </property>
</configuration>
```

### yarn-site.xml配置

```xml
<configuration>
<!-- Site specific YARN configuration properties -->
<!-- 设置ResourceManager 域名 -->
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>node41</value>
    </property>
  <!-- 开启yarn.webapp.ui2 -->
  <property>
    <description>To enable RM web ui2 application.</description>
    <name>yarn.webapp.ui2.enable</name>
    <value>true</value>
  </property>
    <!-- 默认为true, 当虚拟机内存不够多时，容易超出虚拟机内存 -->
    <property>
      <name>yarn.nodemanager.vmem-check-enabled</name>
      <value>false</value>
      <description>Whether virtual memory limits will be enforced for containers.</description>
    </property>
</configuration>
```

### hadoop-env.sh

```shell
JAVA_HOME=/usr/local/jdk
export HADOOP_SHELL_EXECNAME=root
export HADOOP_SECURE_DN_USER=yarn
export HDFS_DATANODE_USER=root
export HDFS_DATANODE_SECURE_USER=hdfs
export HDFS_NAMENODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root
```

### workers配置

```txt
node41
node42
node43
```

### 修改bin/hdfs

```
把HADOOP_SHELL_EXECNAME="hdfs"修改为HADOOP_SHELL_EXECNAME="root"即可
```

### 配置免密登录

```shell
# 在每台机器上执行下面命令(node41,node42,node43)
ssh-keygen -t rsa

# copy每台机器的id到node41上面
# node41, node42， node43上分别执行
ssh-copy-id node41

# 把node41上的~/.ssh/authorized_keys文件copy到node42,node43
scp ~/.ssh/authorized_keys node42:`pwd`
scp ~/.ssh/authorized_keys node43:`pwd`
```

### 启动Hadoop集群

```shell
# 格式化namenode
hadoop namenode -format

#启动hdfs集群：
start-dfs.sh   #启动hdfs集群
stop-dfs.sh   #停止hdfs集群

#启动yarn集群：
start-yarn.sh    #启动yarn集群
stop-yarn.sh     #停止yarn集群

#一次性启动hdfs、yarn集群：
start-all.sh
stop-all.sh
```

### 访问集群

```
yarn：http://node41:8088
hdfs：http://node41:9870
```



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

# 访问地址
hdfs webui 界面: http://192.168.101.3:9870
yarn webui 界面: http://192.168.101.3:8088


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
```shell
$HADOOP_HOME/bin/hadoop fs -mkdir /user/input 
$HADOOP_HOME/bin/hadoop fs -put /home/file.txt /user/input
$HADOOP_HOME/bin/hadoop fs -ls /user/input
$HADOOP_HOME/bin/hadoop fs -cat /user/output/outfile 
从HDFS得到文件使用get命令在本地文件系统。
$HADOOP_HOME/bin/hadoop fs -get /user/output/ /home/hadoop_tp/ 
$HADOOP_HOME/bin/hdfs dfs -chmod  +w /flink/output
$HADOOP_HOME/bin/hdfs dfs -cat /flink/output/*
```



<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
<property>
<name>yarn.nodemanager.env-whitelist</name>
<value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CL
ASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
</property>
<property>
<name>yarn.resourcemanager.hostname</name>
<value>hadoop100</value>
</property>
<configuration>


HDFS_DATANODE_USER=cmwin
HDFS_DATANODE_SECURE_USER=hdfs
HDFS_SECONDARYNAMENODE_USER=cmwin
YARN_RESOURCEMANAGER_USER=cmwin
HADOOP_SECURE_DN_USER=yarn
YARN_NODEMANAGER_USER=cmwin

## 删除指定目录
./hdfs dfs -rm -f -R /mysql

hdfs dfs -head -n 1 /mc/db/T_D_KEY_PRICE_INFO

hadoop job -kill application_1587789850023_0043

hadoop命令行 与job相关的：
命令行工具 • 
1.查看 Job 信息：
hadoop job -list 
2.杀掉 Job： 
hadoop  job -kill  job_id
3.指定路径下查看历史日志汇总：
hadoop job -history output-dir 
4.作业的更多细节： 
hadoop job -history all output-dir 
5.打印map和reduce完成百分比和所有计数器：
hadoop job –status job_id 
6.杀死任务。被杀死的任务不会不利于失败尝试：
hadoop jab -kill-task <task-id> 
7.使任务失败。被失败的任务会对失败尝试不利：
hadoop job  -fail-task <task-id>

随机返回指定行数的样本数据 
hadoop fs -cat /mc/db/T_D_KEY_PRICE_INFO/* | shuf -n 5

返回前几行的样本数据 
hadoop fs -cat /test/gonganbu/scene_analysis_suggestion/* | head -100

返回最后几行的样本数据 
hadoop fs -cat /test/gonganbu/scene_analysis_suggestion/* | tail -5

查看文本行数 
hadoop fs -cat hdfs://172.16.0.226:8020/test/sys_dict/sysdict_case_type.csv |wc -l

查看文件大小(单位byte) 
hadoop fs -du hdfs://172.16.0.226:8020/test/sys_dict/*

hadoop fs -count hdfs://172.16.0.226:8020/test/sys_dict/*
————————————————
版权声明：本文为CSDN博主「Ronney-Hua」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/github_38358734/java/article/details/79272521

[hadoop](https://www.yiibai.com/hadoop)
## 启动Hadoop集群
* 单机模式
* 伪分布式模式
* 完全分布式模式

## ssh免密登陆

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

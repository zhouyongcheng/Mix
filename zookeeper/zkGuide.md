## use root account do all the following things.

# 安装zookeeper
[Zookeeper下载](http://zookeeper.apache.org/releases.html)
* 用户[安装/运行][root/root]
* 建议使用3台机器进行集群部署，过半存活，集群对外才可用。
* 安装jdk8以上，设置环境变量。并设置heap大小(Xmx=3G)。
* zookeeper是一个tar.gz包，解压完成安装。/usr/local/zookeeper
* 剩下的工作就是配置。[zoo.cfg]
> 编辑: /usr/local/zookeeper/conf/zoo.cfg
>每个broker都对应一个myid文件，里面记载broker的编号。
````
tickTime=2000
dataDir=/var/lib/zookeeper/
dataLogDir=/var/logs/zookeeper  [单独硬盘：推荐]
clientPort=2181
initLimit=5
syncLimit=2 
preAllocSize=64M
snapCount=100000
traceFile=/tmp/zookeeper/log
autopurge.snapRetainCount=5
autopurge.purgeInterval=0           [bin/zkCleanup.sh]
syncEnabled=true
server.1=192.168.122.1:2888:3888
server.2=zoo2:2888:3888
server.3=zoo3:2888:3888
````
* 启动zookeeper  
```
bin/zkServer.sh start
bin/zkServer.sh stop
```  

* 启动客户端
```
bin/zkCli.sh
zkCli.sh -server ip:port
```


## 应维
## create zookeeper node
create [-s] [-e] path data acl    s->sequential node | e->temp node
----------------------------------------
example:
create /zk-book 123               path=/zk-book    data=123

ls path 
example:
ls /zk-book

get path
get /zk-book

set path data
set /zk-book 456

delete path [version]







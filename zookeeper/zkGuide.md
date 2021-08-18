## use root account do all the following things.
![zookeeper简介](http://static.open-open.com/lib/uploadImg/20141108/20141108213345_5.png)

# 安装zookeeper
zookeeper图像界面
```
git clone https://github.com/zzhang5/zooinspector.git
cd zooinspector
mvn clean package
chmod +x target/zooinspector-pkg/bin/zooinspector.sh
target/zooinspector-pkg/bin/zooinspector.sh
```





## 安装zookeeper

>>>>>>> 4d7877170c8d9c4aeeda7db9c87d968de873bb29
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
dataLogDir=/var/logs/zookeeper
clientPort=2181
initLimit=5
syncLimit=2 
preAllocSize=64M
snapCount=100000
traceFile=/tmp/zookeeper/log
autopurge.snapRetainCount=5
autopurge.purgeInterval=0
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

## 

## 常用客户端命令

```shell
# 创建临时有序节点
create [-s] [-e] path data acl

参数解释：
s->sequential （有序）
e-> 临时节点

# 查看zookeeper的版本信息
echo stat | nc localhost 2181
```

## 安装hbase的注意事项
* 配置/etc/hosts, 各个节点间可相互访问.
* 各个节点的配置都是一样的, 所以在master节点配置完后, 复制到各个节点.
* 各个节点的防火墙注意关闭(或在配置成各个节点可以相互访问) [有节点未关闭,坑]
* 主节点到各个节点免密登陆(ssh-copy-id)
* 首先要起动zookeeper
* 启动hadoop
* 最后启动hbase
* 创建hbase/tmp目录  /data/hbase/tmp

## 客户端命令
```
bin/hbase shell
```

## hbase管理访问地址
> http://192.168.101.14:60010/master-status

## /etc/hosts配置
```
192.168.101.3  node03 node03.cmwin.com
192.168.101.14  node14 node14.cmwin.com
192.168.101.21  node21 node21.cmwin.com
192.168.101.22  node22 node22.cmwin.com
192.168.101.23  node23 node23.cmwin.com
```

## ssh免密登陆
```sh
1. ssh-keygen -t rsa
2. ssh-copy-id -i ~/.ssh/id_rsa.pub username@nodename
例: ssh-copy-id -i ~/.ssh/id_rsa.pub cmwin@node03
```

## 主要的配置文件
* conf/hbase-env.sh
```sh
export JAVA_HOME=/data/soft/jdk1.8.0_131
export HBASE_MANAGES_ZK=false
```
* hbase-site.xml
```xml
<configuration>
  <property>
    <name>hbase.master.info.port</name>
    <value>60010</value>
  </property>
  <property>
    <name>hbase.tmp.dir</name>
    <value>/data/hbase/tmp</value>
  </property>
  <property>
    <name>hbase.rootdir</name>
    <value>hdfs://node03.cmwin.com:9000/hbase</value>
  </property>
  <property>
    <name>hbase.cluster.distributed</name>
    <value>true</value>
  </property>
  <property>
    <name>hbase.zookeeper.quorum</name>
    <value>node21.cmwin.com,node22.cmwin.com,node23.cmwin.com</value>
  </property>
</configuration>
```
* regionServers
```
node21.cmwin.com
node22.cmwin.com
node23.cmwin.com
```

## 是否必须配置,避免雪崩效应(hbase-site.xml)
```xml
<property>
    <name>hbase.coprocessor.abortonerror</name>
    <value>false</value>
</property>
```

停止regionserver
/bin/hbase-daemon.sh stop regionserver RegionServer
 
启动regionserver
/bin/hbase-daemon.sh start regionserver RegionServer
 
重启regionserver
bin/graceful_stop.sh --restart --reload --debug nodename
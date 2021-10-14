[Codis官网](https://github.com/CodisLabs/codis/blob/release3.2/doc/tutorial_zh.md)

[安装参考](https://www.cnblogs.com/toutou/p/install_codis.html)

## CODIS安装

### 系统环境安装

```bash
yum install -y gcc make gcc-c++ automake autoconf zlib-*
```

### 安装go

```properties
# 确定操作系统的发行版本
cat /etc/centos-release
wget -c https://golang.google.cn/dl/go1.17.2.linux-amd64.tar.gz
tar zxvf go1.17.2.linux-amd64.tar.gz -C /usr/local

# 编辑环境变量
vim /etc/profile
-------------------------------
GOROOT=/usr/local/go
GOPATH=/opt
JAVA_HOME=/usr/local/jdk
KE_HOME=/usr/local/kafka-eagle
NG_HOME=/usr/local/nginx
PATH=$PATH:$KE_HOME/bin:$JAVA_HOME/bin:$NG_HOME/sbin:$GOROOT/bin
export JAVA_HOME KE_HOME GOROOT PATH

#> go env -w GO111MODULE=off

cd /opt/src/github.com/wandoulabs/codis
make 

./admin/codis-dashboard-admin.sh start
./admin/codis-proxy-admin.sh start
./admin/codis-server-admin.sh start
./admin/codis-fe-admin.sh start

```



### 安装java

### 安装zookeeper

### 安装codis

```bash
mkdir -p $GOPATH/src/github.com/CodisLabs
```



# codis介绍
> Codis 支持按照 Namespace 区分不同的产品, 拥有不同的 product name 的产品, 各项配置都不会冲突。 

生成配置文件，即将现有的配置文件输出到指定目录位置
./codis-proxy --default-config | tee conf/proxy.toml

关闭codis proxy   
/opt/codis/bin/codis-admin --proxy=192.168.0.57:11080  --shutdown
关闭codis dashboard 
/opt/codis/bin/codis-admin --dashboard=192.168.0.202:18080 --shutdown
启动codis-server
nohup /opt/codis/bin/codis-server /opt/codis/config/redis6329.conf 1>> yum_start_1.log &
启动codis-fe
nohup /opt/codis/bin/codis-fe --log=/tmp/cods_fe.log --dashboard-list=/home/mcuser/workjob/resource/codis.json --listen=0.0.0.0:18090 &
启动codis-dashboard   
nohup /opt/codis/bin/codis-dashboard --config=/opt/codis/config/dashboard.toml --log=/tmp/codis_dashboard.log &




## Codis由四部分组成
* Codis Proxy (codis-proxy)
* Codis Manager (codis-config)
* Codis Redis (codis-server)
* ZooKeeper

## Codis-proxy
```
sudo su -
/opt/codis/bin/codis-admin --proxy=172.25.216.18:19000  --shutdown
nohup /opt/codis/bin/codis-proxy --config=/opt/codis/config/proxy.toml --log=/tmp/proxy.log &
coddis-proxy 是客户端连接的 Redis 代理服务,可以部署多个 codis-proxy, 本身是无状态的。
```

## Codis-config
> Codis 的管理工具, 支持包括, 添加/删除 Redis 节点, 添加/删除 Proxy 节点, 发起数据迁移等操作

## codis-server
> 相当于redis-server实例(instance) 



### Codis的启动

```bash
nohup /opt/codis/bin/codis-server /opt/codis/config/redis6319.conf > /tmp/redis_6319.log &
```


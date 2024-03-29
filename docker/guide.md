[TOC]

# spring cloud guide

## EurekaCenter: 8001
## EurekaGateway: 8002
## EurekaConfig: 8003
## EurekaService: 9001
## EurekaConsumer: 9002


## 移除旧的版本：
```
[install docker](http://www.runoob.com/docker/centos-docker-install.html)
sudo yum remove docker \`
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-selinux \
                docker-engine-selinux \
                docker-engine
```

## 安装一些必要的系统工具：

```
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
添加软件源信息：
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
更新 yum 缓存：
sudo yum makecache fast
sudo yum -y install docker-ce
sudo systemctl start docker
```


## docker的安装(centos)
````
确保 yum 包更新到最新。
yum -y update
wget -qO- https://get.docker.com/ | sh
yum -y install docker docker-registry
systemctl enable docker.service
systemctl start docker.service
systemctl status docker.service
````

## get mirror



https://www.cnblogs.com/wushuaishuai/p/9984210.html



## docker idea集成

```properties
# 编辑docker服务参数
vim /lib/systemc/system/docker.service

# 添加-H tcp://0.0.0.0:2375
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock

```



## 配置 Docker 镜像加速

```properties
https://registry.docker-cn.com

http://hub-mirror.c.163.com

https://3laho3y3.mirror.aliyuncs.com

http://f1361db2.m.daocloud.io

https://mirror.ccs.tencentyun.com

# 配置方式
mkdir -p /etc/docker
touch /etc/docker/daemon.json
{
  "registry-mirrors": ["https://3laho3y3.mirror.aliyuncs.com"]
}
# 重启一下 Docker
sudo systemctl daemon-reload
sudo systemctl restart docker
```



## docker compose安装

```
# 获取脚本
$ curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
# 赋予执行权限
$chmod +x /usr/local/bin/docker-compose
```



### docker安装mysql

```properties
docker pull mysql:5.7
# 映射出docker中的配置文件到本地
docker run --name my-mysql -p 3306:3306 -d --privileged -v /etc/mysql/:/etc/mysql/conf.d/ -v /data/mysql_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 mysql:5.7.23
# 只映射数据存储地址和端口。
docker run --name my-mysql -p 3306:3306 -d -v /etc/mysql/:/etc/mysql/conf.d/ -v /data/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456  mysql:5.7.23

# 参数说明：
	#映射容器服务的 3306 端口到宿主机的 3306 端口，外部主机可以直接通过 宿主机ip:3306
	-p 3306:3306
	# 设置MySQL服务root用户的密码。
	MYSQL_ROOT_PASSWORD=123456
# 进入docker容器环境。	
docker exec -it my-mysql /bin/bash

# copy本地文件到docker容器中
```

### docker安装redis

```properties
docker pull redis:latest
# 启动容器
docker run --name my-redis -p 6379:6379 -d --privileged -v /data/redis_data:/data redis redis-server --appendonly yes
# 参数：
    # 容器内执行redis-server命令，并打开持久化
	redis-server --appendonly yes 
# 进入容器调用客户端进行验证。
docker exec -it my-redis /bin/bash
```

安装mongodb

```properties
docker run --name mc-mongo -p 27017:27017 -v /data/db:/data/db -d mongo:latest
docker exec -it 容器id /bin/bash

mongo
use admin
db.createUser({user:"root",pwd:"root",roles:[{role:'root',db:'admin'}]})   //创建用户,此用户创建成功,则后续操作都需要用户认证
exit
```



### docker安装redis-cluster

#### IP和端口规划

| ip            | port |
| ------------- | ---- |
| 172.16.10.243 | 7001 |
| 172.16.10.243 | 7002 |
| 172.16.10.243 | 7003 |
| 172.16.10.243 | 7004 |
| 172.16.10.243 | 7005 |
| 172.16.10.243 | 7006 |

#### 模板配置文件

```properties
# 文件名： ./redis-cluster.tmpl
#------------------------------------------------

# redis端口
port ${PORT}
# 关闭保护模式
protected-mode no
# 开启集群
cluster-enabled yes
# 集群节点配置
cluster-config-file nodes.conf
# 超时
cluster-node-timeout 5000
# 集群节点IP host模式为宿主机IP
cluster-announce-ip 172.26.10.243
# 集群节点端口 7001 - 7006
cluster-announce-port ${PORT}
cluster-announce-bus-port 1${PORT}
# 开启 appendonly 备份模式
appendonly yes
# 每秒钟备份
appendfsync everysec
# 对aof文件进行压缩时，是否执行同步操作
no-appendfsync-on-rewrite no
# 当目前aof文件大小超过上一次重写时的aof文件大小的100%时会再次进行重写
auto-aof-rewrite-percentage 100
# 重写前AOF文件的大小最小值 默认 64mb
auto-aof-rewrite-min-size 64mb
```

#### docker-compose配置

```yaml
version: '3.7'

services:
  redis7001:
    image: 'redis'
    container_name: redis7001
    command:
      ["redis-server", "/usr/local/etc/redis/redis.conf"]
    volumes:
      - ./redis-cluster/7001/conf/redis.conf:/usr/local/etc/redis/redis.conf
      - ./redis-cluster/7001/data:/data
    ports:
      - "7001:7001"
      - "17001:17001"
    environment:
      # 设置时区为上海，否则时间会有问题
      - TZ=Asia/Shanghai


  redis7002:
    image: 'redis'
    container_name: redis7002
    command:
      ["redis-server", "/usr/local/etc/redis/redis.conf"]
    volumes:
      - ./redis-cluster/7002/conf/redis.conf:/usr/local/etc/redis/redis.conf
      - ./redis-cluster/7002/data:/data
    ports:
      - "7002:7002"
      - "17002:17002"
    environment:
      # 设置时区为上海，否则时间会有问题
      - TZ=Asia/Shanghai


  redis7003:
    image: 'redis'
    container_name: redis7003
    command:
      ["redis-server", "/usr/local/etc/redis/redis.conf"]
    volumes:
      - ./redis-cluster/7003/conf/redis.conf:/usr/local/etc/redis/redis.conf
      - ./redis-cluster/7003/data:/data
    ports:
      - "7003:7003"
      - "17003:17003"
    environment:
      # 设置时区为上海，否则时间会有问题
      - TZ=Asia/Shanghai


  redis7004:
    image: 'redis'
    container_name: redis7004
    command:
      ["redis-server", "/usr/local/etc/redis/redis.conf"]
    volumes:
      - ./redis-cluster/7004/conf/redis.conf:/usr/local/etc/redis/redis.conf
      - ./redis-cluster/7004/data:/data
    ports:
      - "7004:7004"
      - "17004:17004"
    environment:
      # 设置时区为上海，否则时间会有问题
      - TZ=Asia/Shanghai


  redis7005:
    image: 'redis'
    container_name: redis7005
    command:
      ["redis-server", "/usr/local/etc/redis/redis.conf"]
    volumes:
      - ./redis-cluster/7005/conf/redis.conf:/usr/local/etc/redis/redis.conf
      - ./redis-cluster/7005/data:/data
    ports:
      - "7005:7005"
      - "17005:17005"
    environment:
      # 设置时区为上海，否则时间会有问题
      - TZ=Asia/Shanghai


  redis7006:
    image: 'redis'
    container_name: redis7006
    command:
      ["redis-server", "/usr/local/etc/redis/redis.conf"]
    volumes:
      - ./redis-cluster/7006/conf/redis.conf:/usr/local/etc/redis/redis.conf
      - ./redis-cluster/7006/data:/data
    ports:
      - "7006:7006"
      - "17006:17006"
    environment:
      # 设置时区为上海，否则时间会有问题
      - TZ=Asia/Shanghai
```

#### 批量生成配置文件

```shell
# 文件名 ./redis-cluster-config.sh
#------------------------------------------------

#!/bin/bash
for port in `seq 7001 7006`; do \
  mkdir -p ./redis-cluster/${port}/conf \
  && PORT=${port} envsubst < ./redis-cluster.tmpl > ./redis-cluster/${port}/conf/redis.conf \
  && mkdir -p ./redis-cluster/${port}/data; \
done
```

#### 集群配置

```shell
# 测试环境，没有密码限制
docker exec -it redis7001 redis-cli -p 7001 --cluster create 172.16.10.243:7001 172.16.10.243:7002 172.16.10.243:7003 172.16.10.243:7004 172.16.10.243:7005 172.16.10.243:7006 --cluster-replicas 1
```

#### 集群测试

```shell
# 主节点和备份节点的ping通性
docker exec -it redis7001 redis-cli -h 172.16.10.243 -p 7005 ping

# 必须带上-c参数，否则会报错 (error) MOVED 5798 172.16.10.243:7002
docker exec -it redis7001 redis-cli -h 172.16.10.243 -p 7003 -c

#  查看集群状态
cluster nodes

# 查看slots分片
cluster slots

# 查看集群信息
cluster info
```

#### Springboot配置Redis集群

1. maven依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-pool2</artifactId>
</dependency>
```

2. application.yml配置

```yaml
spring:
  redis:
    timeout: 6000
    password: 123456
    cluster:
      max-redirects: 3 # 获取失败 最大重定向次数 
      nodes:
        - 172.16.10.243:7001
        - 172.16.10.243:7002
        - 172.16.10.243:7003
        - 172.16.10.243:7004
        - 172.16.10.243:7005
        - 172.16.10.243:7006
    lettuce:
      pool:
        max-active: 1000 #连接池最大连接数（使用负值表示没有限制）
        max-idle: 10 # 连接池中的最大空闲连接
        min-idle: 5 # 连接池中的最小空闲连接
        max-wait: -1 # 连接池最大阻塞等待时间（使用负值表示没有限制）
  cache:
    jcache:
      config: classpath:ehcache.xml
```

3. java配置

```java
@Configuration
@AutoConfigureAfter(RedisAutoConfiguration.class)
public class RedisConfig {
    @Bean
    public RedisTemplate<String, Object> redisCacheTemplate(LettuceConnectionFactory redisConnectionFactory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new GenericJackson2JsonRedisSerializer());
        template.setConnectionFactory(redisConnectionFactory);
        return template;
    }
}
```



### docker安装mongodb

```properties
docker pull mongo:latest
docker run -itd --name mongo-mc -p 27017:27017 mongo  --auth
# 参数说明：
--auth：需要密码才能访问容器服务。
docker exec -it mongo-mc mongo admin
# 创建一个名为 admin，密码为 123456 的用户。
db.createUser({ user:'admin',pwd:'123456',roles:[ { role:'userAdminAnyDatabase', db: 'admin'},"readWriteAnyDatabase"]});
# 尝试使用上面创建的用户信息进行连接。
db.auth('admin', '123456')
```

### 安装nginx

```
docker pull nginx:latest
docker run --name nginx-mc -p 8080:80 -d nginx
# 参数说明：
-p 8080:80： 端口进行映射，将本地 8080 端口映射到容器内部的 80 端口。
-d nginx： 设置容器在在后台一直运行。

```

````
docker pull registry.hub.docker.com/ubuntu:latest
docker pull dl.dockerpool.com:5000/ubuntu
docker pull ubuntu
docker pull ubuntu:latest
docker pull ubuntu:14.04
````



### 安装zookeeper

```shell
docker run -d --name zookeeper -p 2181:2181 -v /etc/localtime:/etc/localtime -t zookeeper

docker pull wurstmeister/zookeeper
docker run -d --name zookeeper -p 2181:2181 -v /etc/localtime:/etc/localtime -t wurstmeister/zookeeper

docker run -d --name my-zookeeper -p 2181:2181 -v /etc/localtime:/etc/localtime -t zookeeper

```

### docker本地集群安装zookeeper

```shell
# 获取官方版本的zookeeper
docker pull zookeeper:latest

# 创建自己的bridge网络，创建容器的时候指定ip
docker network create --driver bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1 zoonet

# 创建容器node1
docker run -d -p 2181:2181 --name zookeeper_node1 --privileged --restart always --network zoonet --ip 172.18.0.2 \
-v /usr/local/zookeeper-cluster/node1/volumes/data:/data \
-v /usr/local/zookeeper-cluster/node1/volumes/datalog:/datalog \
-v /usr/local/zookeeper-cluster/node1/volumes/logs:/logs \
-e ZOO_MY_ID=1 \
-e "ZOO_SERVERS=server.1=172.18.0.2:2888:3888;2181 server.2=172.18.0.3:2888:3888;2181 server.3=172.18.0.4:2888:3888;2181" zookeeper

# 创建容器node2
docker run -d -p 2182:2181 --name zookeeper_node2 --privileged --restart always --network zoonet --ip 172.18.0.3 \
-v /usr/local/zookeeper-cluster/node2/volumes/data:/data \
-v /usr/local/zookeeper-cluster/node2/volumes/datalog:/datalog \
-v /usr/local/zookeeper-cluster/node2/volumes/logs:/logs \
-e ZOO_MY_ID=2 \
-e "ZOO_SERVERS=server.1=172.18.0.2:2888:3888;2181 server.2=172.18.0.3:2888:3888;2181 server.3=172.18.0.4:2888:3888;2181" zookeeper

# 创建容器node2
docker run -d -p 2183:2181 --name zookeeper_node3 --privileged --restart always --network zoonet --ip 172.18.0.4 \
-v /usr/local/zookeeper-cluster/node3/volumes/data:/data \
-v /usr/local/zookeeper-cluster/node3/volumes/datalog:/datalog \
-v /usr/local/zookeeper-cluster/node3/volumes/logs:/logs \
-e ZOO_MY_ID=3 \
-e "ZOO_SERVERS=server.1=172.18.0.2:2888:3888;2181 server.2=172.18.0.3:2888:3888;2181 server.3=172.18.0.4:2888:3888;2181" zookeeper

# 进入容器验证下
docker exec -it zookeeper_node01 bash
bin/zkServer.sh status

# 开启防火墙
firewall-cmd --zone=public --add-port=2181/tcp --permanent
firewall-cmd --zone=public --add-port=2182/tcp --permanent
firewall-cmd --zone=public --add-port=2183/tcp --permanent
systemctl restart firewalld
firewall-cmd --list-all
```

### 安装kafka

```
docker pull wurstmeister/kafka
docker run -d --name my-kafka -p 9092:9092 --link my-zookeeper --env KAFKA_ZOOKEEPER_CONNECT=my-zookeeper:2181 --env KAFKA_ADVERTISED_HOST_NAME=127.0.0.1 --env KAFKA_ADVERTISED_PORT=9092 --volume /etc/localtime:/etc/localtime wurstmeister/kafka:latest

# 进入kafka容器查看状态
docker exec -it ${CONTAINER ID} /bin/bash

172.16.10.181 改为宿主机器的IP地址，如果不这么设置，可能会导致在别的机器上访问不到kafka。
```


### 安装consul

```
docker pull consul
docker run --name mc-consul -d -p 8500:8500 consul


## install prometheus

```
docker run -d \
    -p 9090:9090 \
    -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
    -name mc-prometheus \
    prom/prometheus
```

### springboot应用安装到docker运行

```

```



## use image to create container

​```shell
docker create -it ubuntu             // create the container but at stop status
-t :  pseudo-tty   terminal
-i : container standard input open status.

docker start ubuntu
docker attach container_names
docker exec -it container_name  /bin/bash

docker run -t -i ubuntu /bin/bash    // create and start the container

# 交互方式，退出删除容器
docker run -it --rm ubuntu
```

## docker的镜像管理(must use root to do management)
````
docker tag dl.dockerpool.org:5000/ubuntu:latest ubuntu:latest
docker images            // 查看本的的镜像列表
docker inspect image_id  // 查看镜像的详细内容
docker search mysql      // 查询mysql镜像
docker search -s 20 ubuntu  // s: star
docker search redis      // 查询redis镜像
docker pull redis        // 从远程库下载镜像到本地
docker rmi mysql        // 删除本地的mysql镜像
docker rmi image_id      // 删除指定ID的镜像
docker rmi -f image_id   // 强制删除指定的镜像
docker rm container_id   // delete specified container

docker run -it ubuntu /bin/bash  //启动镜像，建立容器
docker ps                 // list current running container 
docker ps -a              // list all docker container
docker port container_id  // confirm docker running port information
````
## 创建镜像
````
1. 基于容器创建
   docker commit -m "创建新镜像，基于xx容器" based_container new_image_id:[tag]
   docker commit [options] container  repository[:tag]
   options: 
   	-a --author=""
   	-m --message=""
   	-p --pause=true 

   example: docker commit -m "add a file" -a "docker-root" a92abcxx8799 new_repository_nm

   
2. 基于本地模版导入
   
3. 基于Dockerfile创建
docker build -t spring-boot .
docker build -t apache/dolphinscheduler:mysql-driver .
````

## 存出或导入镜像，上传镜像到仓库
````
把当前本地的镜像输出成一个tar文件，可以传输给别人使用
docker save -o hello-world.tar hello-world

从提供的镜像tar文件导入到本地的镜像库中
docker load --input hello-world.tar
docker load < hello-world.tar

上传镜像到仓库(默认远程仓库)
docker push image_name:[tag]


````



## docker命令
````properties
docker version
docker info
# 搜镜像信息
docker search
docker pull tomcat:latest
docker rmi id
# 删除所有的images
docker rmi -f $(docker images -aq)

# copy本的文件到docker容器
docker cp  c:/temp/file.txt container_name:/etc/

# 容器命令
# 创建容器并处于停止状态，启动容器
docker create -it image_id
docker start container_id

创建并同时启动容器,执行指定指令，centos代表的是image名
docker run centos /bin/echo 'hello world'
docker run -it centos /bin/bash

如果一个容器已经停止，则必须用run方法进行启动
docker run image
--name ： 给容器起个名字
-d     ： 后台进程
-it    ：交换，启动后台
-p     :  8080:8080 (主机端口：容器端口)

以守护进程的方式运行容器
docker run -d -p 4001:4001 --name spring-boot spring-boot-image
# 查看守护进程的输出内容
docker logs container_id
docker logs -f container_id
docker logs --tail 10 container_id




# 停止容器
docker stop container_id
# 查看处于终止状态的容器，并重新启动
docker ps -a -q
docker start container_id
docker restart container_id
# 停止运行的容器
docker stop container_id
docker kill container_id
# 停止运行的容器
docker stop container_id

# 查看运行着的容器
docker ps   
# 查看本地所有的容器，包括不运行的 
docker ps -a
# 删除指定的容器，才能删除指定的镜像
docker rm container_id
# 删除所有的容器
docker rm -f $(docker ps -aq)

# 把docker的后台进程提到当前控制台显示
docker attach container_name
# 进入后台的进程
docker exec -it container_id /bin/bash

# copy容器中的内容到主机的home目录。
docker copy container_id:/home/document.txt  /home


# 停止容器
exit
# 退出但不停止
Ctrl + p + q 
# 导出容器
docker export  container_id > test_container_id.tar
# 导入容器
cat test_container_id.tar | docker import - test/container_nm:tag_nm
````

## 容器的数据管理方法
````
-v /webapp 在容器内创建了数据卷
-P 外部访问容器时，容器提供的端口号
docker run -d -P --name web -v /webapp demo/webapp python app.py

挂载主机的/src/webapp到容器的/opt/webapp目录下面
docker run -d -P --name myubuntu -v /data01:/data01 ubuntu


````

### 容器数据卷功能

```shell
# 容器间共享数据的方式(相当于共享磁片)
# 创建一个专用的容器，数据卷容器
docker run -it -v /dbdata --name dbdata ubuntu
docker run -it volume-from dbdata --name ubuntu2 ubuntu

# 匿名挂载 （容器内的/etc/niginx 挂在到容器外的/etc/nginx)
docker run -d -P --name nginx_01 -v /etc/nginx nginx
# 具名挂载
docker run -d -P --name nginx_01 -v mynginx:/etc/nginx:ro nginx
docker run -d -P --name nginx_01 -v mynginx:/etc/nginx:rw nginx

# 查看挂载的路径
docker volume inspect mynginx

# 查看容器的详细信息
docker  container_id inspect

# 在其他容器中挂载该数据卷
docker run -it --volumes-from dbdata --name myapp ubuntu

# 删除数据卷（只有所有的挂载容器都被删除后才能执行成功,无容器使用)
docker rm -v dbdata

# 查看数据卷的详细列表
docker volume ls
```

## DockerFile管理

```

```





## Docker的网络功能

````
绑定宿主机器的4001端口和容器的4001端口
docker run -d -p 4001:4001 --name spring-boot-rest spring-boot-image
查看容器绑定的端口
docker port container_nm
docker port container_nm 5000
容器间相互通信(web容器和db容器通信)
docker run -d --name db mydb-image
docker run -td --link db:db --name myweb spring-boot-img 
````

docker run --name db --env MYSQL_ROOT_PASSWORD=example -d mariadb
docker run --name MyWordPress --link db:mysql -p 8080:80 -d wordpress

## use docker to install rabbitmq
```
docker pull rabbitmq:management
docker run -d --hostname myhostname -p 5671:5671 -p 5672:5672 -p 4369:4369 -p 25672:25672 -p 15671:15671 -p 15672:15672 --name okong-rabbit rabbitmq:management
docker ps
docker logs xxxx  (xxxx = ps find id)
http://localhost:15672  guest/guest
```

## docker run options
```
-a stdin: 指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项；
-d: 后台运行容器，并返回容器ID；
-i: 以交互模式运行容器，通常与 -t 同时使用；
-p: 端口映射，格式为：主机(宿主)端口:容器端口
-t: 为容器重新分配一个伪输入终端，通常与 -i 同时使用；
--name="nginx-lb": 为容器指定一个名称；
--dns 8.8.8.8: 指定容器使用的DNS服务器，默认和宿主一致；
--dns-search example.com: 指定容器DNS搜索域名，默认和宿主一致；
-h "mars": 指定容器的hostname；
-e username="ritchie": 设置环境变量；
--env-file=[]: 从指定文件读入环境变量；
--cpuset="0-2" or --cpuset="0,1,2": 绑定容器到指定CPU运行；
-m :设置容器使用内存最大值；
--net="bridge": 指定容器的网络连接类型，支持 bridge/host/none/container: 四种类型；
--link=[]: 添加链接到另一个容器；
--expose=[]: 开放一个端口或一组端口；
```

## docker exec -it 容器ID 参数
```
 docker exec -it 3ba5b7475423 redis-cli  
 参数说明：
-d：分离模式: 在后台运行	
-i：即使没有附加也保持STDIN 打开
-t：分配一个伪终端
```

# docker网络

### docker加速器

```

# 创建自己的bridge网络，创建容器的时候指定ip
docker network create --driver bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1 zoonet

```

### docker常用网络命令

``` bash
docker network ls
docker network connect

# 查看容器的配置信息
docker inspect container_id


# 查看网络下面都有那些容器
docker network inspect network_name


# 解除当前容器的网络绑定操作
docker network disconnect network_name container_id
docker network connect  network_name container_id
docker restart container_id
```




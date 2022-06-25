

## compose的安装

```shell
# 官网查看版本
https://github.com/docker/compose/releases
# 下载指定版本
curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose

# 国内下载源
curl -L https://get.daocloud.io/docker/compose/releases/download/1.27.4/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose

# 给执行权限
sudo chmod +x /usr/local/bin/docker-compose
# 创建软链
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
# 测试是否安装成功
docker-compose --version
# 版本对应关系
https://docs.docker.com/compose/compose-file/
```



## zookeeper集群安装

### compose文件

```yaml
version: '3.7'

networks:
  docker_net:
    external: true

services:
  zoo1:
    image: zookeeper
    restart: unless-stopped
    hostname: zoo1
    container_name: zoo1
    ports:
      - 2182:2181
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181
    volumes:
      - ./zookeeper/zoo1/data:/data
      - ./zookeeper/zoo1/datalog:/datalog
    networks:
      - docker_net

  zoo2:
    image: zookeeper
    restart: unless-stopped
    hostname: zoo2
    container_name: zoo2
    ports:
      - 2183:2181
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=0.0.0.0:2888:3888;2181 server.3=zoo3:2888:3888;2181
    volumes:
      - ./zookeeper/zoo2/data:/data
      - ./zookeeper/zoo2/datalog:/datalog
    networks:
      - docker_net

  zoo3:
    image: zookeeper
    restart: unless-stopped
    hostname: zoo3
    container_name: zoo3
    ports:
      - 2184:2181
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=0.0.0.0:2888:3888;2181
    volumes:
      - ./zookeeper/zoo3/data:/data
      - ./zookeeper/zoo3/datalog:/datalog
    networks:
      - docker_net
```

### 结果检测

```shell
# 启动容器
docker-compose -f docker-compose-zookeeper-cluster.yml up -d
docker-compose -f docker-compose-zookeeper-cluster.yml stop
docker rm zoo1 zoo2 zoo3

docker-compose -f docker-compose-kafka-cluster.yml up -d
docker-compose -f docker-compose-kafka-cluster.yml stop
docker rm kafka1 kafka2 kafka3 kafka-manager

privileged: true

```


### dolphinscheduler启动关闭
```bash
#下载datax的编译好的文件，也可以自己本地编译
docker cp datax.tgz docker-swarm_dolphinscheduler-worker_1:/opt/soft
docker cp /data/soft/

docker exec -it docker-swarm_dolphinscheduler-worker_1 bash
  
cd /opt/soft
tar zxf datax.tgz
rm -f datax.tgz
mv datax.tgz datax

cd /data/soft/dolphinscheduler/docker/docker-swarm
docker-compose up -d
docker-compose -f docker-compose.yml stop

# 停止所有容器并移除所有容器、网络和存储卷
docker-compose down -v

```
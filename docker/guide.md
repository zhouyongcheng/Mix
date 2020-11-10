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





### 获取mysql的image

```
docker pull mysql:5.7
```



````
docker pull registry.hub.docker.com/ubuntu:latest
docker pull dl.dockerpool.com:5000/ubuntu
docker pull ubuntu
docker pull ubuntu:latest
docker pull ubuntu:14.04
````

## use image to create container
```shell
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

docker加速器

```

```



```
docker
```


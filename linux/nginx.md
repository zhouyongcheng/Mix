## nginx参考

```
https://www.cnblogs.com/wushuaishuai/tag/nginx/
```



## nginx安装

```shell
# 下载
wget -c http://nginx.org/download/nginx-1.21.0.tar.gz
# 解压
tar -xzvf /tmp/nginx-1.21.0.tar.gz 
# 配置
./configure --prefix=/usr/local/nginx
# 安装
make && make install
# 配置环境变量
vim /etc/profile
export NG_HOME=/usr/local/nginx
export PATH=$PATH:$NG_HOME/sbin
# 启动
>nginx
```

## nginx配置

### 反向代理

```json
server {
    # 监听的服务器和端口号
	listen       9001;
	server_name  192.168.17.129;

    # 请求路径转发
	location ~ /edu/ {
		proxy_pass  http://127.0.0.1:8080
	}

	# 请求路径转发
	location ~ /vod/ {
		proxy_pass  http://127.0.0.1:8081
	}
}
```




## nginx 常用命令
```
运行nginx
nginx 
查看nginx的版本
nginx -v
快速停止或关闭
nginx -s stop
正常停止或关闭
nginx -s quit
配置文件修改重装载
nginx -s reload

```


## nginx 起点后报403错误
```
修改nginx的配在文件/etc/nginx/nginx.conf
user nginx 修改为 user root;

查看nginx的启动用户，发现是nobody，而为是用root启动的
ps aux | grep "nginx: worker process" | awk'{print $1}'
```

## windows下查看nginx进程
tasklist /fi "imagename eq nginx.exe"


## 查看新修改的nginx是否有错误，避免上线导致服务器出错
```
sudo nginx -t -c /opt/nginx/conf/nginx.conf.kafka
-c <path_to_config>：使用指定的配置文件而不是 conf 目录下的 nginx.conf 。
-t：测试配置文件是否正确，在运行时需要重新加载配置的时候，此命令非常重要，用来检测所修改的配置文件是否有语法错误。
```
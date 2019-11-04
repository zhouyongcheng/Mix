# nginx配置
/etc/nginx/..

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

如何起点nginx

nginx的关闭

## windows下查看nginx进程
tasklist /fi "imagename eq nginx.exe"


## 查看新修改的nginx是否有错误，避免上线导致服务器出错
```
sudo nginx -t -c /opt/nginx/conf/nginx.conf.kafka
-c <path_to_config>：使用指定的配置文件而不是 conf 目录下的 nginx.conf 。
-t：测试配置文件是否正确，在运行时需要重新加载配置的时候，此命令非常重要，用来检测所修改的配置文件是否有语法错误。
```
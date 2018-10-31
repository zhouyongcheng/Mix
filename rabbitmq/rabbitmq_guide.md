# 安装
安装完成后管理控制台url，默认
http://localhost:15672   guest/


## 创建vhost
```
rabbitmqctl add_vhost host_name
rabbitmqctl delete_vhost host_name
rabbitmqctl list_vhosts
```

## rabbitmq消息的持久化
* Exchange设置为持久化 durable=true
* Queue设置为持久化 durable = true
* 发送消息的时候指定delivery_mode = 2, 持久化消息

 
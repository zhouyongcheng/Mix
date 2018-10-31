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

## startup server
```
 /sbin/rabbitmq-server -detached  -- start up erlang node and rabbitmq application
 ./rabbitmqctl stop   -- close whole node include erlang node and application running on it
 rabbitmqctl stop_app  -- just stop rabbitmq application not include erlang node
 rabbitmqctl start_app

```

## rabbitmq configuration
```
  /etc/rabbitmq/rabbitmq.config

```

## rabbitmq privilege management
```
rabbitmqctl add_user username password
rabbitmqctl delete_user  username
rabbitmqctl list_users
rabbitmqctl change_password username newpassword
rabbitmqctl list_permissions -p hostname
rabbitmqctl clear_permissions -p hostname username
rabbitmqctl list_user_permissions username 

privilegs: read, write, config

rabbitmqctl set_permissions -p vhostname  username  ".*" ".*" ".*"    [stand for config, wirte, read]

```

 
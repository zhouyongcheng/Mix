## 分片的建立
分片中的各个角色
* mongos
> 路由进程，路由所有请求，然后将结果聚合。本身不存储数据和配置信息。
> 
* 配置服务器
> 存储集群的配置信息。数据和片的对应关系，mongos会从配置服务器获取同步数据。

## 分片的建立过程
* 启动配置服务器和mongos， 配置服务器先要启动，mongos需要使用配置服务器上的内容。
```
mkdir -p /data/dbs/config
./mongod --dbpath /data/dbs/config --port 20000
./mongos --port 30000 --configdb localhost:20000
```
* 添加片
```
mkdir -p /data/dbs/shard1
./mongod --dbpath /data/dbs/shard1 --port 10000
```
* 连接到mongos服务器上，添加分片配置
```
./mongo localhost:30000/admin
db.runCommand({addshard: "localhost:10000", allowLocal: true})
当在localhost上运行分片时，需设定allowLocal:true, 
生产环境，mongos和分片实例应在不同服务器上。
```

* 在数据库和集合的级别将分片功能打开
  > 对数据库foo的分片功能，数据库的集合会存入到不同的分片。
  db.runCommand({"enablesharding": "foo"})
  > 数据库级别分片后，就可以集合分片
  db.runCommand({"shardcollection": "foo.bar", "key": {"_id": 1}})


## 生产环境的分片配置
* 多个配置服务器
```
mkdir -p /data/dbs/config1 /data/dbs/config2 /data/dbs/config3
./mongod --dbpath /data/dbs/config1 --port 20001
./mongod --dbpath /data/dbs/config2 --port 20002
./mongod --dbpath /data/dbs/config3 --port 20003
```

* 多个mongos服务器, mongos启动是连接到config服务器
```
mongos的数量不受限制，建议一个应用服务器只运行一个mongos，应用服务器和mongos直接本地通信。如果服务器本身不工作了，也不会有别的应用试图和本服务器的mongos通信。
./mongos --configdb localhost:20001,localhost:20002,localhost:20003
```

* 每个片都是副本集
```
生产环境中，每个片都应该是副本集。单个服务器失败了，不会导致整个片失效。添加分片时，指定副本集的名称及种子服务器就好。
db.runCommand({"addshard": "foo/prod.demo.com:27017"})

```

* 配置集合
```
在mongos服务器上运行下面的命令
db.shards.find()
db.databases.find()
db.chunks.find()
```

* 分片命令
```
db.printShardingStatus()
db.runCommand({"removeshard": "localhost:10000"})

```

* xxx
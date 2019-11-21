## 为什么采用mongdb
* 横向扩展方便，这样可以增加存储空间及提升性能。
* 采用文档数据模型，自动在多台服务器间分割数据。
* 提供通用索引功能，多种快速查询方式。
* 支持mapreduce及其他的聚合功能，适用数据分析的统计。
* 支持文件的存储（可按大文件，小文件采用不同的存储方式，图片，视频，文本等）
* 管理方便，管理理念，尽可能让服务器自动配置，用户在必要的时候调整设置。
* 多数据库并存，数据库间完全独立（权限，存储位置等）
* mongodb在插入数据的时候不会执行代码，所以不会有注入式攻击的风险。
☐

## 注意事项
* mongodb不仅区分类型，而且还区分大小写（键及值）
* 同一个文档中，不能有重复的键。
* 使用子集合的方式来组织数据是一种很好的方式（sellout.report, sellout.realtime)
* admin数据库，把用户加到这个数据库，则该用户自动继承所有数据库的权限。
* mongod.lock：这个文件的目的是防止其他mongod的进程使用当前进程的数据。
* 使用64位的稳定版本的mongodb
* 


# 安装mongodb

* download and extract (linux | windows)
* su root
* mkdir -p /data/db
* chown cmwin:cmwin /data/db
* export PATH=/home/cmwin/software/mongodb/bin:$PATH

- 启动|关闭方式
```
 mongod --dbpath /data/db
 mongod -f /etc/mongodb.cnf
 mongod --shutdown
 mongod --config /etc/mongod/mongod.conf 
 use admin | db.shutdownServer()

 启动参数：
  --auth： 是否开启安全检查（用户/密码，权限）
  --dbpath: 数据文件的存储地址
  --port:   进程使用的端口
  --fork:   后台运行进程
  --logpath：日志文件地址（可读写权限）
  --logappend:  追加的方式，如果没有该参数，覆盖方式。 
  --config: 指定配置文件的路径启动进程
  -f:       指定配置文件的路径启动进程
 
 关闭mongodb：
 kill -2 pid
 kill -15 pid
 但不要用kill -9 pid,会导致数据库数据损坏。
 使用mongodb的命令
 > use admin
 > db.shutdownServer();
 http://localhost:28017
```


## 常用命令
```
mongo
>version()
> show dbs
> use dbname
> show collections
> show users
> db.audit.validate()   -- 检测一个集合状态。
>db.createCollection("audit", {capped:true, size: 20480})    -创建固定大小集合
>db.createCollection("mycollec", {capped:true, size:100000, max:1000}); -- 限制记录条数
>db.runCommand({convertToCapped: "test", size: 10000})  -- 把普通集合转换未固定集合
>db.audit.find().sort({$natural: -1}).limit(10)   --获取固定集合中的最后10条记录。
```

## mongo.conf example
```
dbpath = /home/cmwin/data/db
logpath = /home/cmwin/data/log
journal = true
port = 5000
auth = true
```

## mongo client using
```
mongo --port 5000 --host 192.168.0.1 --username cmwin --password admin123 --authenticationDatabase admin

```

## backup mongodb server(all database will be backuped)
 * mkdir ~/mongobak
 * cd ~/mongobak
 * ./mongodump
 ````
 execute above command, will create a directory and some backup file in ~/mongobak/dump
 ````

## backup single database
`./mongodump -d db_name`

## backup specified collection
`./mongodump -d db_name -c collection_name`


## restore backup database to server, move to directory which contain dump directory.
   * cd ~/mongobak   
   * mongorestore --drop

## restore single database or collection
* mongorestore -d db_name --drop
* mongorestore -d db_name -c collection_name --drop


## export data from mongodb
export -d test -c todo -q {} -f _id,name,address --csv > test.todo.csv

## import data into mongodb(csv, tsv, json etc)

# 数据库的安全管理
````
认证和授权是针对指定数据库的。针对每个数据库进行设定)
首先在数据库启动时不启用--auth, 创建完admin用户后在启用--auth选项。
通过admin用户创建其他用户。
````

## 创建管理员用户(create admin user) 
```
用户的信息维护在admin数据库的system.users.
use admin
db.createUser({
    user : "admin",
    pwd: "admin",
    roles: [
        {role: "readWrite", db: "admin"},
        {role: "userAdminAnyDatabase", db: "admin"}
    ]
})
或者
db.addUser({
    user: "admin",
    pwd: "admin",
    roles: ["readWrite", "dbAdmin"]
})
```

## 启用认证机制(--auth)
````
启动服务器的时候添加 [--auth] 启动选项。
也可以在启动配置文件(mongodb.cnf)中添加auth=true的配置信息
````

## 给特定的数据库创建用户及授权
````
1.先用登陆到admin数据库，通过认证。
2.使用目标数据库。 use cmwin
3.db.createUser({
    user: "cmwin",
    pwd: "cmwin",
    roles: [
        "readWrite", "dbAdmin"
    ]
})
4. db.auth("cmwin", "cmwin");
5. show users;
6. 正常使用数据库。
````

## auth in the mongo console
- use admin
- db.auth("admin", "admin");
- db.system.users.find()
- db.system.version.find();

## roles in mongodb
- read
- readWrite
- dbAdmin
- userAdmin
- clusterAdmin
- readAnyDatabase
- readWriteAnyDatabase
- userAdminAnyDatabase
- dbAdminAnyDatabase

## 绑定到特定的IP地址和端口
- mongod --bind_ip 127.0.0.1 --port 27017  --rest
- 通过防火墙来限定访问数据库服务器的客户端。增加服务器的安全性。

# 服务器的管理，配置
## 通过配置文件来定制服务器的行为。（/etc/mongodb.conf）
```
dbpath=/data/db
logpath=/var/log/mongodb/mongodb.log
logappend=true
auth=false
rest=true
```
## 通过命令行的选项定制服务器的行为。
`mongod --auth --rest &`

## 通过调用db的命令来设定数据库行为。
`[db.adminCommand({setParameter:1, logLevel:0})]`


## 关闭数据库的方式。
```
1. use admin, db.shutdownServer()
2. mongod --shutdown
```

## gridfs管理
* mongofiles list
* mongofiles put targetfile
* mongofiles delete filename
* mongofiles get filename
* db.fs.files.find()

## 索引功能(index)
- db.posts.ensureIndex({Tags: 1})
- db.posts.ensureIndex({Tags: -1})
- db.posts.ensureIndex({"name":1, "age": -1})
- db.posts.ensureIndex({"comments.count", 1})
- db.posts.dropIndexes();
- db.posts.dropIndex({"name": 1})
- db.posts.ensureIndex({"name": 1}, {"unique": true})
- db.posts.ensureIndex({"name": 1}, {"unique": true, "dropDups": true})
- db.posts.ensureIndex({"name":1, "age": 1}, {"unique": true})
- db.posts.reIndex();
* db.blog.ensureIndex({body: 'text'})
* db.blog.getIndexex();

* db.blog.runCommand("text": {search: 'fish'});



# 数据的导入导出: mongoimport
````
mongoimport -d blog -c student -u cmwin -p cmwin --type csv --file ~/tmp/student.csv --headerline
mongoexport -d blog -c student -u cmwin -p cmwin -q {} -f _id,Title,Message,Author --csv > blogposts.csv
````



## spring-boot mongodb integration

# replication （复制集）
-- 在服务器上执行下面的命令，查看复制集的操作日志信息。
 db.printReplicationInfo()
 
- replication set (复制集)

## 复制集中的基本概念
- master的priority必须为1
- secondary的种类：
  1. {priority: 0} 不可能成为master，同步master数据，参与投票。
  2. {priority: 0, hidden: true}, 同步master数据，参与投票，客户端看不到。
  3. {priority: 0, hidden: true, delay: time}
  4. Arbiters: 仲裁服务器，不同步master的数据，只参与投票选举的过程。 
  5. {votes: 0} Non-voting: 仅仅不参与投票，其他功能都有。
  
  ```
  cfg_1 = rs.conf();
  cfg_1.members[3].votes = 0
  cfg_1.members[4].votes = 0
  cfg_1.members[5].votes = 0
  rs.reconfig(cfg_1)
  ```
  
## 复制集的创建(start all instance, and initial config)
```
1. 给复制集命名：cmwinset, 创建mongodb实例的时候指定该名称。(--replSet cmwinset)
2. 启动所有复制集中的数据库实例，--replSet指向同一个名字。(cmwinset/hostname:27021)
3. 连接到某台服务器(hostname:27021)。通过admin数据库来配置复制集的信息。
4. 以配置参数调用rs.initiate(cfg),创建复制集。
5. db.isMaster(),判断是否是主节点。

如果不希望每个实例都占用一个shell，下面启动mongod是，可以添加参数 --fork 和 --logfile <file>, 这样在后台运行并输出日志到指定文件。
mongod --dbpath /home/cmwin/db/active1/data  --port 27021  --fork  --logfile /home/cmwin/db/logs/log_27017.log  --replSet cmwinset


复制集中的节点的限制，实际是指能够进行投票的节点的个数为基准进行计算的。 必须存活的节点数=总节点数/2+1

创建复制集的操作步骤:

## 启动复制集中的各个mongod instance.
mkdir -p /home/cmwin/db/active1/data
mongod --dbpath /home/cmwin/db/active1/data  --port 27021 --replSet cmwinset

mkdir -p /home/cmwin/db/active2/data
mongod --dbpath /home/cmwin/db/active2/data  --port 27022 --replSet cmwinset

mkdir -p /home/cmwin/db/passive1/data
mongod --dbphth /home/cmwin/db/passive1/data --port 27023 --replSet cmwinset

mkdir -p /home/cmwin/db/arbiter1/data
mongod --dbpath /home/cmwin/db/ariter1/data  --port 27024 --replSet cmwinset  -rest

## 任意一mongod instance上执行下面操作（计划的主服务器上进行操作）。
*  初始化复制集
*  添加成员到复制集中
mongo localhost.localdomain:27021
>rs.initiate()     -- 使用默认参数初始化复制集
-- 检查初始化后的状态。
>rs.status()  
>rs.add("localhost.localdomain:27022")
>rs.add("localhost.localdomain:27023")

## 复制配置文件，并且修改为设计的复制集信息
>conf = rs.conf()
>conf.members[2].hidden = true    -- 复制集的客户端看不到该节点，一般作为备份节点或者报表节点。即使客户端设置了读取偏好，也不能读取数据。
>conf.members[2].priority = 0      -- 不会被选为master
>conf.members[2].votes = 0            -- 不参与投票

>conf.members[2].slaveDelay = xxxs   -- 该节点落后于主服务器的时间，由于容错设置，比如操作失败后，切换到及分钟前的状态（是否有实际意义？）
>rs.reconfig(conf)

-- 添加仲裁节点。
>rs.addArb("localhost.localdomain:27024")

# 辅助server上登陆查看信息。
1）登陆辅助server。
2）执行db.getMongo().setSlaveOk();
3) 通过1，2，就可以直接在副本服务器上查看数据库文档信息。


从复制集中移出服务器
1. 关闭需要移出的服务器实例。
    connect to specified instance and use admin, db.shutdownServer();
2. 登陆主服务器地址，调用remove命令。
    connect to master instance and use admin, rs.remove('hostname:27022')

添加服务器到复制集中。
1. 启动要加入的服务器instance.
   mongod --dbpath /home/cmwin/db/active4/data --port 27025 --replSet  cmwinset
2. 连接到主服务器instance
   use admin, rs.add("hostname:27025")

添加arbiter实例
1. 启动服务器instance.
2. 连接主服务器的admin数据库，执行下面命令添加arbiter到集群中。
   use admin, rs.addArb("localhost.localdomain:27026");
```

## 复制集的数据复制
```
通常情况下，辅助节点都是从主节点进行数据的复制，可以通过执行下面的命令，改变节点复制的数据来源。
rs.syncFrom("hostaname:port")
```


## 复制集中master的选举
```
1. 连接到主服务master, 执行rs.stepDown()
使用场景：
  1. 模拟master当机。
  2. master服务器维护，如升级等。
  
```

## mongodb的日志功能
- 开启慢日志，可以对执行比较慢的查询进行分析。
- 当进行主从复制集的时候，需要开启oplog，操作日志。

## 复制集常用命令
 ```
 rs.stepDown()    -- 强制进行新的选举
 db.isMaster()   -- 判断是不是主节点。

 ```



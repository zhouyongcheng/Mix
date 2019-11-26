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
 
  --oplogSize=100M, 复制集的时候用来设定固定大小的oplog, 用作各个节点的数据复制的缓存集合(collection)


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

## 数据库的备份操作(全库备份)
 > 执行完mongodump命令后,会在当前目录下创建dump目录,备份文件都存储在dump目录下.
 * mkdir ~/mongobak
 * cd ~/mongobak
 * ./mongodump

##  备份单个数据库
`./mongodump -d db_name`

## 备份指定数据库下的指定集合
`./mongodump -d db_name -c collection_name`


## 恢复全部数据库的备份,
> 注意切换到包含dump目录的路径下执行mongorestore命令
   * cd ~/mongobak   
   * mongorestore --drop    --drop参数指的是先删除,在导入,避免数据的重复.

## 恢复单个数据库
* mongorestore -d db_name --drop

## 恢复指定数据库下的指定集合
* mongorestore -d db_name -c collection_name --drop


## export data from mongodb
export -d test -c todo -q {} -f _id,name,address --csv > test.todo.csv

## import data into mongodb(csv, tsv, json etc)

# 数据库的安全管理
````
默认情况下,mongodb是不启用安全认证的.
可以在任何数据库中创建用户.
支持对每个数据库进行单独访问控制设置. 存储在system.users集合中. (admin数据库的system.users)
任何被添加到admin数据库的[用户],在所有数据库中都有相同的数据库访问权限.
认证和授权是针对指定数据库的。针对每个数据库进行设定)
首先在数据库启动时不启用--auth, 创建完admin用户后在启用--auth选项。
通过admin用户创建其他用户。
````

## 使用认证保护服务器


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
- read                                 :用户可读取指定的数据库
- readWrite                        :用户对指定的数据库有读写权限
- dbAdmin                            :在指定的数据库中个执行管理操作
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


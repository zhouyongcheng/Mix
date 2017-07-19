
# reference document
[redis-guide](https://redis.io/topics/quickstart)

# install redis
```
wget -C http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
copy executed command to /usr/local/bin
make install 

src/redis-server
src/redis-cli
src/redis-cli shutdown NOSAVEc
```

# admin command
>start redis server

`src/redis-server`

```
src/redis-server /path/to/redis.conf --loglevel warning
src/redis-server --sentinel sentinel.conf
src/redis-sentinel sentinel.conf

redis-cli -h localhost -p 6379 -P password
redis-cli>ping
redis-cli>shutdown
redis-cli>select 1
redis-cli>config set loglevel warning
redis-cli>config get loglevel
redis-cli>flushall
redis-cli>flushdb
redis-cli>set key value
redis-cli>append key value
redis-cli>strlen key
redis-cli>mget k1 k2
redis-cli>mset k1 v1 k2 v2
redis-cli>hset key field fieldv
redis-cli>hget key field
redis-cli>hmset key f1 v1 f2 v2
redis-cli>hmget key f1 f2
redis-cli>hgetall key
redis-cli>hexists key field
redis-cli>hsetnx key field value
redis-cli>hincrby key field incrementvalue
redis-cli>hdel key field
redis-cli>hkeys key
redis-cli>hvals key
redis-cli>hlen key
redis-cli>lpush key v1 v2 ...
redis-cli>rpush key v3 v4 ...
redis-cli>lpop key
redis-cli>rpop key
redis-cli>brpop key 0
redis-cli>blpop key 0
redis-cli>llen key
redis-cli>lrange key 0 -1 
redis-cli>lrange key start end   (include start and end)
redis-cli>lrem key count value
redis-cli>lindex key index
redis-cli>lset key index value
redis-cli>ltrim key start end
redis-cli>linsert key before|after pivot value
redis-cli>rpoplpush source destination
redis-cli>
redis-cli>sadd key m1 m2 ...
redis-cli>srem key m2 m2 ...
redis-cli>smembers key
redis-cli>sismember key m1
redis-cli>sdiff k1 k2
redis-cli>sinter k1 k2
redis-cli>sunion k1 k2
redis-cli>scard key
redis-cli>smembers key
redis-cli>sdiffstore destination key1 key2
redis-cli>sinterstore destination key1 key2
redis-cli>sunionstore destination key2 key2
redis-cli>srandmember key [count]
redis-cli>spop key

redis-cli>zadd key score1  member1 score2 member2
redis-cli>zscore key member
redis-cli>zrange key start end [withscores]
redis-cli>zrevrange key start end 
redis-cli>zrangebyscore key min max [withscores]
redis-cli>zrevrangebyscore key 100 0 limit 0 3
redis-cli>zincrby key value item
redis-cli>zcard key
redis-cli>zcount key min max
redis-cli>zcount key (89 +inf
redis-cli>zrem key item
redis-cli>zremrangebyrank key start stop
redis-cli>zremrangebyscore key (4 5
redis-cli>zrank key member
redis-cli>zrevrank key member
redis-cli>
redis-cli>expire key seconds
redis-cli>ttl key
redis-cli>persist key
redis-cli>pexpire key milseond
redis-cli>
redis-cli>sort mylist alpha desc
redis-cli>sort mylist desc limit 1 2
redis-cli>sort mylist BY post:*->time desc
redis-cli>sort mylist BY post:*->time desc GET post:*->title

redis-cli>publish channel.1 mymessage
redis-cli>
redis-cli>
redis-cli>
redis-cli>


redis-cli>del key
redis-cli>exists key
redis-cli keys "user:*" | xargs redis-cli DEL
redis-cli DEL `redis-cli keys "user:*"`
redis-cli>type mykey
redis-cli>decr key
redis-cli>decrby key value
redis-cli>incr key
redis-cli>incrby key value
redis-cli>
redis-cli>
redis-cli>
redis-cli>
redis-cli>


```

# redis-server configuration
```
maxmemory=xxxxxx
maxmemory-policy=[volatile-lru | allkeys-lru | volatile-ttl ]
```


# sentinel configuration
```
sentinel monitor mymaster 127.0.0.1 6379 2
sentinel down-after-milliseconds mymaster 60000
sentinel failover-timeout mymaster 180000
sentinel parallel-syncs mymaster 1

sentinel monitor resque 192.168.1.3 6380 4
sentinel down-after-milliseconds resque 10000
sentinel failover-timeout resque 180000
sentinel parallel-syncs resque 5
```


# Tomcat + Redis 实现Session共享
## Tomcat配置,引入jar包
```
tomcat-redis-session-manager1.2.jar
jedis-2.8.0.jar
commons-pool2-2.2.jar
```

## 配置context.xml
```
<Valve className="com.orangefunction.tomcat.redissessions.RedisSessionHandlerValve" />
    <Manager className="com.orangefunction.tomcat.redissessions.RedisSessionManager"
             host="172.16.100.200"
             port="9736" 
             database="15"    />
```


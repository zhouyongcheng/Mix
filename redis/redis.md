

# reference document

[redis-guide](https://redis.io/topics/quickstart)

[redis常用命令] (https://www.cnblogs.com/jtfr/p/10503803.html)

<<<<<<< HEAD
## 安装redis
=======
## 安装Redis

### 环境准备

```shell
# root用户操作
yum -y install centos-release-scl
yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils
echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile
>>>>>>> aa68d12f6819143dd878da4d7fee9904aa1391c5
```

### 安装

```shell
# 用root用户进行安装？
wget -C http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
copy executed command to /usr/local/bin
make install 

------------------------------------------
make distclean
# 编译安装到指定目录下
make PREFIX=/usr/local/redis install 
# 卸载
make uninstall

src/redis-server
src/redis-cli
src/redis-cli shutdown NOSAVE
```

## 管理命令
```shell
# 启动redis-server,并以守护进程的方式运行，在redis.conf文件中 daemonize=yes
src/redis-server /etc/redis.conf
# redis启动设置为服务形式启动
#将安装目录…/redis-3.0.3/utils下的启动脚本文件redis_init_script拷贝到/etc/init.d下，并重命名为redisd
#修改/etc/init.d/redisd文件：
#添加# chkconfig: 2345 90 10
>90表示服务启动执行的优先级，10表示服务被关闭的优先级
>添加服务: chkconfig --add redisd
>根据启动脚本中配置文件路径，新建配置文件目录，拷贝文件到该目录下
>cp /usr/local/redis/redis-3.0.3/redis.conf   /etc/redis/6379.conf
```

## redis常用命令


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

## redis服务器配置
```properties
maxmemory=xxxxxx
maxmemory-policy=[volatile-lru | allkeys-lru | volatile-ttl ]
```


## sentinel 配置
```shell
sentinel monitor mymaster 127.0.0.1 6379 2
sentinel down-after-milliseconds mymaster 60000
sentinel failover-timeout mymaster 180000
sentinel parallel-syncs mymaster 1

sentinel monitor resque 192.168.1.3 6380 4
sentinel down-after-milliseconds resque 10000
sentinel failover-timeout resque 180000
sentinel parallel-syncs resque 5
```


## Tomcat + Redis 实现Session共享
```shell
# Tomcat配置,引入jar包
tomcat-redis-session-manager1.2.jar
jedis-2.8.0.jar
commons-pool2-2.2.jar
# 配置context.xml
<Valve className="com.orangefunction.tomcat.redissessions.RedisSessionHandlerValve" />
    <Manager className="com.orangefunction.tomcat.redissessions.RedisSessionManager"
             host="172.16.100.200"
             port="9736" 
             database="15"    />
```

## springboot2集成Redis

### Redis 连接池简介

```
客户端连接 Redis 使用的是 TCP协议，直连的方式每次需要建立 TCP连接，而连接池的方式是可以预先初始化好客户端连接，所以每次只需要从 连接池借用即可，而借用和归还操作是在本地进行的，只有少量的并发同步开销，远远小于新建TCP连接的开销。另外，直连的方式无法限制 redis客户端对象的个数，在极端情况下可能会造成连接泄漏，而连接池的形式可以有效的保护和控制资源的使用。
```

### Jedis和lettuce对比

```
1、Jedis在实现上是直接连接的redis server，如果在多线程环境下是非线程安全的，这个时候只有使用连接池，为每个Jedis实例增加物理连接
2、Lettuce的连接是基于Netty的，连接实例（StatefulRedisConnection）可以在多个线程间并发访问，应为StatefulRedisConnection是线程安全的，所以一个连接实例（StatefulRedisConnection）就可以满足多线程环境下的并发访问，当然这个也是可伸缩的设计，一个连接实例不够的情况也可以按需增加连接实例。
```



## RedisConfig

```java
@Configuration
@ConditionalOnClass(RedisOperations.class)
@EnableConfigurationProperties(RedisProperties.class)
public class RedisCacheConfig {

    private Environment env;

    public RedisCacheConfig(Environment env) {
        this.env = env;
    }

    /**
     * @description 配置访问mc的codis的RedisTemplate
     * @author zhouyc
     * @param
     * @return
     * @date 2020/7/30 18:54
     */
    @Bean("redisTemplate")
    public <String, Object> RedisTemplate<String, Object> redisTemplate(JedisConnectionFactory factory) {
        RedisTemplate<String, Object> redisTemplate = new RedisTemplate<>();
        redisTemplate.setConnectionFactory(factory);
        //key序列化方式;（不然会出现乱码;）,但是如果方法上有Long等非String类型的话，会报类型转换错误；
        //所以在没有自己定义key生成策略的时候，以下这个代码建议不要这么写，可以不配置或者自己实现ObjectRedisSerializer
        //或者JdkSerializationRedisSerializer序列化方式;
        StringRedisSerializer keySerializer = new StringRedisSerializer();
        JdkSerializationRedisSerializer valueSerializer = new JdkSerializationRedisSerializer();
        redisTemplate.setKeySerializer(keySerializer);
        redisTemplate.setHashKeySerializer(keySerializer);
        redisTemplate.setValueSerializer(valueSerializer);
        redisTemplate.setHashValueSerializer(valueSerializer);
        return redisTemplate;
    }

    /**
     * 配置第一个数据源的RedisTemplate
     * 注意：这里指定使用名称=factory2 的 RedisConnectionFactory
     *
     * @param factory
     * @return
     */
    @Bean("redisTemplate2")
    public RedisTemplate<String, Object> redisTemplate2(JedisConnectionFactory factory) {
        RedisTemplate<String, Object> redisTemplate = new RedisTemplate<>();
        redisTemplate.setConnectionFactory(factory);
        // 使用Jackson2JsonRedisSerialize 替换默认序列化（备注，此处我用Object为例，各位看官请换成自己的类型哦~）
        StringRedisSerializer stringRedisSerializer = new StringRedisSerializer();
        Jackson2JsonRedisSerializer jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer(Object.class);
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        objectMapper.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
        jackson2JsonRedisSerializer.setObjectMapper(objectMapper);
        redisTemplate.setKeySerializer(stringRedisSerializer);
        redisTemplate.setValueSerializer(stringRedisSerializer);
        redisTemplate.setHashKeySerializer(stringRedisSerializer);
        redisTemplate.setHashValueSerializer(jackson2JsonRedisSerializer);
        redisTemplate.afterPropertiesSet();
        return redisTemplate;
    }

    @Bean("factory")
    public JedisConnectionFactory factory(JedisPoolConfig jedisPoolConfig) {
        RedisStandaloneConfiguration redisStandaloneConfiguration = new RedisStandaloneConfiguration();
        //设置redis服务器的host或者ip地址
        redisStandaloneConfiguration.setHostName(env.getProperty("spring.redis.host"));
        //设置默认使用的数据库
        redisStandaloneConfiguration.setDatabase(Integer.parseInt(env.getProperty("spring.redis.database")));
        //设置redis的服务的端口号
        redisStandaloneConfiguration.setPort(Integer.parseInt(env.getProperty("spring.redis.port")));
        // 获得默认的连接池构造器(怎么设计的，为什么不抽象出单独类，供用户使用呢)
        JedisClientConfiguration.JedisPoolingClientConfigurationBuilder jedisBuilder = (JedisClientConfiguration.JedisPoolingClientConfigurationBuilder) JedisClientConfiguration.builder();
        jedisBuilder.poolConfig(jedisPoolConfig);
        JedisClientConfiguration jedisClientConfiguration = jedisBuilder.build();
        return new JedisConnectionFactory(redisStandaloneConfiguration, jedisClientConfiguration);
    }

    /**
     * 连接池配置信息
     * @return
     */
    @Bean
    public JedisPoolConfig jedisPoolConfig() {
        JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
        //最大连接数
        jedisPoolConfig.setMaxTotal(60);
        // 最大空闲连接
        jedisPoolConfig.setMaxIdle(50);
        //最小空闲连接数
        jedisPoolConfig.setMinIdle(50);
        // 当资源池连接用尽后，调用者的最大等待时间（单位为毫秒，30秒后还未获取的时候，失败处理）。
        jedisPoolConfig.setMaxWaitMillis(30000);
        // 是否开启空闲资源检测。
        jedisPoolConfig.setTestWhileIdle(true);
        jedisPoolConfig.setTestOnBorrow(true);
        jedisPoolConfig.setTestOnReturn(true);
        // 空闲资源的检测周期（单位为毫秒, 10秒检查下）
        jedisPoolConfig.setTimeBetweenEvictionRunsMillis(10*1000);
        //资源池中资源的最小空闲时间（单位为毫秒，30秒后释放），达到此值后空闲资源将被移除。
        jedisPoolConfig.setMinEvictableIdleTimeMillis(30*1000);
        // 做空闲资源检测时，每次检测资源的个数。
        jedisPoolConfig.setNumTestsPerEvictionRun(-1);
        return jedisPoolConfig;
    }
}
```


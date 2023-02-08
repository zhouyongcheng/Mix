## spring redisTemplate的构建

### maven依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
    <exclusions>
        <exclusion>
            <groupId>io.lettuce</groupId>
            <artifactId>lettuce-core</artifactId>
        </exclusion>
    </exclusions>
</dependency>
<dependency>            
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
</dependency>
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-pool2</artifactId>
</dependency>
```

### 单redis数据源的配置

#### application.yml配置信息

```yaml
spring:
    redis:
        host: localhost
        port: 6379
        database: 0
        timeout: 60000
        jedis:
            pool:
                max-active: 100
                min-idle: 20
                max-idle: 20
                max-wait: 10s
                time-between-eviction-runs: 30000
                min-evictable-idle-time: 60000
                num-tests-per-eviction-run: -1
```

#### java配在类

```java
@Configuration
@ConditionalOnClass(RedisOperations.class)
@ConfigurationProperties(prefix = "spring")
@Getter
@Setter
public class RedisConfig {

    private static final Logger logger = LoggerFactory.getLogger(RedisConfig.class);

    private RedisProperties redis;

    @Bean
    public RedisTemplate<String, Object> redisTemplate(JedisConnectionFactory factory) {
        return buildRedisTemplate(factory);
    }

    @Bean
    public JedisConnectionFactory factory(JedisPoolConfig jedisPoolConfig) {
        return buildJedisConnectionFactory(jedisPoolConfig, redis);
    }

    /**
     * 连接池配置信息
     * @return
     */
    @Bean
    public JedisPoolConfig jedisPoolConfig() {
        JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
        //最大连接数
        jedisPoolConfig.setMaxTotal(redis.getJedis().getPool().getMaxActive());
        // 最大空闲连接
        jedisPoolConfig.setMaxIdle(redis.getJedis().getPool().getMaxIdle());
        //最小空闲连接数
        jedisPoolConfig.setMinIdle(redis.getJedis().getPool().getMinIdle());
        // 当资源池连接用尽后，调用者的最大等待时间（单位为毫秒，30秒后还未获取的时候，失败处理）。
        jedisPoolConfig.setMaxWaitMillis(redis.getJedis().getPool().getMaxWait().toMillis());
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

    /**
     * 从提供的RedisConnectionFactory中创建redisTemplate
     * @param factory RedisConnectionFactory
     * @return
     */
    private RedisTemplate buildRedisTemplate(JedisConnectionFactory factory) {
        RedisTemplate<String, Object> redisTemplate = new RedisTemplate<>();
        redisTemplate.setConnectionFactory(factory);
        Jackson2JsonRedisSerializer jackson2JsonRedisSerializer = 
            new Jackson2JsonRedisSerializer(Object.class);
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        objectMapper.activateDefaultTyping(LaissezFaireSubTypeValidator.instance ,
                ObjectMapper.DefaultTyping.NON_FINAL, JsonTypeInfo.As.PROPERTY);
        jackson2JsonRedisSerializer.setObjectMapper(objectMapper);
        // 配置屏蔽中心redisTemplate的系列化方式。
        RedisSerializer stringSerializer = new StringRedisSerializer();
        redisTemplate.setKeySerializer(stringSerializer);
        redisTemplate.setValueSerializer(jackson2JsonRedisSerializer);
        redisTemplate.setHashKeySerializer(stringSerializer);
        redisTemplate.setHashValueSerializer(jackson2JsonRedisSerializer);
        redisTemplate.afterPropertiesSet();
        return redisTemplate;
    }

    /**
     * @param
     * @return
     * @Description: 根据不同的配置信息，获取JedisConnectionFactory
     * @Exception
     * @author: zhouyc
     * @date: 2020-08-30 17:02
     */
    private JedisConnectionFactory buildJedisConnectionFactory(
        JedisPoolConfig jedisPoolConfig, 
        RedisProperties redisProperties) {
        RedisStandaloneConfiguration redisStandaloneConfiguration =
                new RedisStandaloneConfiguration();
        logger.info("================connection information begin=================");
        logger.info("host = [{}]", redisProperties.getHost());
        logger.info("port = [{}]", redisProperties.getPort());
        logger.info("db = [{}]", redisProperties.getDatabase());
        logger.info("===============connection information end=====================");
        
        //设置redis服务器的host或者ip地址
        redisStandaloneConfiguration.setHostName(redisProperties.getHost());
        //设置默认使用的数据库
        redisStandaloneConfiguration.setDatabase(redisProperties.getDatabase());
        //设置redis的服务的端口号
        redisStandaloneConfiguration.setPort(redisProperties.getPort());
        JedisClientConfiguration.JedisPoolingClientConfigurationBuilder jedisBuilder = 	    (JedisClientConfiguration.JedisPoolingClientConfigurationBuilder) JedisClientConfiguration.builder();
        jedisBuilder.poolConfig(jedisPoolConfig);
        JedisClientConfiguration jedisClientConfiguration = jedisBuilder.build();
        return new JedisConnectionFactory(
            redisStandaloneConfiguration,
            jedisClientConfiguration);
    }
}
```

### 多数据源配置

#### application配置文件

```yaml
spring:
    redis1:
        host: localhost
        port: 6379
        database: 0
        timeout: 60000
        jedis:
            pool:
                max-active: 100
                min-idle: 20
                max-idle: 20
                max-wait: 10s
                time-between-eviction-runs: 30000
                min-evictable-idle-time: 60000
                num-tests-per-eviction-run: -1
    redis2:
        host: localhost
        port: 6379
        database: 1
        timeout: 60000
        jedis:
            pool:
                max-active: 100
                min-idle: 20
                max-idle: 20
                max-wait: 10s
                time-between-eviction-runs: 30000
                min-evictable-idle-time: 60000
                num-tests-per-eviction-run: -1
```

#### java配置

```java
/**
 * redis 缓存配置
 * @author zhouyc
 */
@Configuration
@ConditionalOnClass(RedisOperations.class)
@ConfigurationProperties(prefix = "spring")
@Getter
@Setter
public class MultiRedisConfig {

    private Logger logger = LoggerFactory.getLogger(MultiRedisConfig.class);

    /**
     * redis source 1
     */
    private RedisProperties redis1;

    /**
     * redis source 2
     */
    private RedisProperties redis2;

    /**
     * @param
     * @return
     * @description 配置访问redis1的RedisTemplate
     * @author zhouyc
     * @date 2020/7/30 18:54
     */
    @Bean("redisTemplate1")
    public RedisTemplate<String, Object> redisTemplate1(@Qualifier("factory1") JedisConnectionFactory factory1) {
        return buildRedisTemplate(factory1);
    }

    @Bean("redisTemplate2")
    public RedisTemplate<String, Object> redisTemplate2(@Qualifier("factory2") JedisConnectionFactory factory2) {
        return buildRedisTemplate(factory2);
    }

    @Bean("factory1")
    @Primary
    public JedisConnectionFactory factory1(@Qualifier("jedisPoolConfig1") JedisPoolConfig jedisPoolConfig1) {
        return buildJedisConnectionFactory(jedisPoolConfig1, redis1);
    }

    @Bean("factory2")
    public JedisConnectionFactory factory2(@Qualifier("jedisPoolConfig2") JedisPoolConfig jedisPoolConfig2) {
        return buildJedisConnectionFactory(jedisPoolConfig2, redis2);
    }


    /**
     * @param
     * @return
     * @Description: 根据不同的配置信息，获取JedisConnectionFactory
     * @Exception
     * @author: zhouyc
     * @date: 2020-08-30 17:02
     */
    private JedisConnectionFactory buildJedisConnectionFactory(JedisPoolConfig jedisPoolConfig, RedisProperties redisProperties) {
        RedisStandaloneConfiguration redisStandaloneConfiguration =
                new RedisStandaloneConfiguration();

        logger.info("=================connection information begin=====================");
        logger.info("host = [{}]", redisProperties.getHost());
        logger.info("port = [{}]", redisProperties.getPort());
        logger.info("db = [{}]", redisProperties.getDatabase());
        logger.info("=================connection information end=====================");

        //设置redis服务器的host或者ip地址
        redisStandaloneConfiguration.setHostName(redisProperties.getHost());
        //设置默认使用的数据库
        redisStandaloneConfiguration.setDatabase(redisProperties.getDatabase());
        //设置redis的服务的端口号
        redisStandaloneConfiguration.setPort(redisProperties.getPort());
        JedisClientConfiguration.JedisPoolingClientConfigurationBuilder jedisBuilder = (JedisClientConfiguration.JedisPoolingClientConfigurationBuilder) JedisClientConfiguration.builder();
        jedisBuilder.poolConfig(jedisPoolConfig);
        JedisClientConfiguration jedisClientConfiguration = jedisBuilder.build();
        return new JedisConnectionFactory(redisStandaloneConfiguration, jedisClientConfiguration);
    }
    /**
     * 连接池配置信息
     * @return
     */
    @Bean("jedisPoolConfig1")
    public JedisPoolConfig jedisPoolConfig1() {
        JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
        //最大连接数
        jedisPoolConfig.setMaxTotal(redis1.getJedis().getPool().getMaxActive());
        // 最大空闲连接
        jedisPoolConfig.setMaxIdle(redis1.getJedis().getPool().getMaxIdle());
        //最小空闲连接数
        jedisPoolConfig.setMinIdle(redis1.getJedis().getPool().getMinIdle());
        // 当资源池连接用尽后，调用者的最大等待时间（单位为毫秒，30秒后还未获取的时候，失败处理）。
        jedisPoolConfig.setMaxWaitMillis(redis1.getJedis().getPool().getMaxWait().toMillis());
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

    /**
     * 连接池配置信息
     * @return
     */
    @Bean("jedisPoolConfig2")
    public JedisPoolConfig jedisPoolConfig2() {
        JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
        //最大连接数
        jedisPoolConfig.setMaxTotal(redis2.getJedis().getPool().getMaxActive());
        // 最大空闲连接
        jedisPoolConfig.setMaxIdle(redis2.getJedis().getPool().getMaxIdle());
        //最小空闲连接数
        jedisPoolConfig.setMinIdle(redis2.getJedis().getPool().getMinIdle());
        // 当资源池连接用尽后，调用者的最大等待时间（单位为毫秒，30秒后还未获取的时候，失败处理）。
        jedisPoolConfig.setMaxWaitMillis(redis2.getJedis().getPool().getMaxWait().toMillis());
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

    /**
     * 从提供的RedisConnectionFactory中创建redisTemplate
     * @param factory RedisConnectionFactory
     * @return
     */
    private RedisTemplate buildRedisTemplate(JedisConnectionFactory factory) {
        RedisTemplate<String, Object> redisTemplate = new RedisTemplate<>();
        redisTemplate.setConnectionFactory(factory);
        Jackson2JsonRedisSerializer jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer(Object.class);
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        objectMapper.activateDefaultTyping(LaissezFaireSubTypeValidator.instance ,
                ObjectMapper.DefaultTyping.NON_FINAL, JsonTypeInfo.As.PROPERTY);
        jackson2JsonRedisSerializer.setObjectMapper(objectMapper);
        // 配置屏蔽中心redisTemplate的系列化方式。
        RedisSerializer stringSerializer = new StringRedisSerializer();
        redisTemplate.setKeySerializer(stringSerializer);
        redisTemplate.setValueSerializer(jackson2JsonRedisSerializer);
        redisTemplate.setHashKeySerializer(stringSerializer);
        redisTemplate.setHashValueSerializer(jackson2JsonRedisSerializer);
        redisTemplate.afterPropertiesSet();
        return redisTemplate;
    }
}
```

### sentinel配置

```java
@Bean
public RedisTemplate<String, Object> redisTemplate(JedisConnectionFactory factory) {
    return buildRedisTemplate(factory);
}

/**
     * @Description: 屏蔽中心的redisTemplate基本配置信息。
     * @param
     * @return
     * @Exception
     *
     * @author: zhouyc
     * @date:  2020-08-22 14:07
     */
    @Bean("factory")
    public JedisConnectionFactory jedisConnectionFactory(JedisPoolConfig jedisPoolConfig, RedisSentinelConfiguration sentinelConfiguration) {
        JedisConnectionFactory jedisConnectionFactory = new JedisConnectionFactory(sentinelConfiguration, jedisPoolConfig);
        return jedisConnectionFactory;
    }

/**
     * 连接池配置信息
     * @return
     */
    @Bean
    public JedisPoolConfig jedisPoolConfig() {
        JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
        //最大连接数
        jedisPoolConfig.setMaxTotal(redis.getJedis().getPool().getMaxActive());
        // 最大空闲连接
        jedisPoolConfig.setMaxIdle(redis.getJedis().getPool().getMaxIdle());
        //最小空闲连接数
        jedisPoolConfig.setMinIdle(redis.getJedis().getPool().getMinIdle());
        // 当资源池连接用尽后，调用者的最大等待时间（单位为毫秒，30秒后还未获取的时候，失败处理）。
        jedisPoolConfig.setMaxWaitMillis(redis.getJedis().getPool().getMaxWait().toMillis());
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

    /**
     * @Description: sentinel配置
     * @param
     * @return
     * @Exception
     *
     * @author: zhouyc
     * @date:  2020-09-08 11:52
     */
    @Bean
    public RedisSentinelConfiguration sentinelConfiguration() {
        RedisSentinelConfiguration redisSentinelConfiguration = new RedisSentinelConfiguration();
        //配置matser的名称
        redisSentinelConfiguration.master(redis.getSentinel().getMaster());
        //配置redis的哨兵sentinel
        Set<RedisNode> redisNodeSet = new HashSet<>();
        List<String> nodes = redis.getSentinel().getNodes();
        nodes.forEach(x->{
            redisNodeSet.add(new RedisNode(x.split(":")[0],Integer.parseInt(x.split(":")[1])));
        });
        redisSentinelConfiguration.setSentinels(redisNodeSet);
        return redisSentinelConfiguration;
    }
```


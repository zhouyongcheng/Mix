# springboot-kafka实现顺序
* 创建消费者和生产者的Map配置
* 根据Map配置创建对应的消费者工厂(consumerFactory)和生产者工厂(producerFactory)
* 根据consumerFactory创建监听器的监听器工厂
* 根据producerFactory创建KafkaTemplate(Kafka操作类)
* 创建监听容器

## kafka生产者配置

```java
package com.cmwin.amy.message.config;

import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;
import org.springframework.kafka.support.serializer.JsonSerializer;

import java.util.HashMap;
import java.util.Map;

/**
 * kafka生产配置
 * @author zhouyc
 *
 */
@Configuration
@EnableKafka
public class KafkaProducerConfig {

    @Value("${kafka.producer.servers}")
    private String servers;

    @Value("${kafka.producer.retries}")
    private int retries;

    @Value("${kafka.producer.batch.size}")
    private int batchSize;

    @Value("${kafka.producer.linger}")
    private int linger;

    @Value("${kafka.producer.buffer.memory}")
    private int bufferMemory;

    @Bean
    public ProducerFactory<String, Object> producerFactory() {
        return new DefaultKafkaProducerFactory<>(producerConfigs());
    }

    @Bean
    public KafkaTemplate<String, Object> kafkaTemplate() {
        return new KafkaTemplate<>(producerFactory());
    }

    private Map<String, Object> producerConfigs() {
        Map<String, Object> props = new HashMap<>();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, servers);
        props.put(ProducerConfig.RETRIES_CONFIG, retries);
        props.put(ProducerConfig.BATCH_SIZE_CONFIG, batchSize);
        props.put(ProducerConfig.LINGER_MS_CONFIG, linger);
        props.put(ProducerConfig.BUFFER_MEMORY_CONFIG, bufferMemory);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
        return props;
    }
}
```



## kafka消费者的配置

```java
package com.cmwin.amy.message.config;


import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.config.KafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.listener.ConcurrentMessageListenerContainer;
import org.springframework.kafka.listener.ContainerProperties;
import org.springframework.kafka.support.serializer.JsonDeserializer;

import java.util.HashMap;
import java.util.Map;

/**
 * kafka消费者配置
 * @author zhouyc
 *
 */
@Configuration
@EnableKafka
public class KafkaConsumerConfig {

    @Value("${kafka.consumer.servers}")
    private String servers;

    @Value("${kafka.consumer.enable.auto.commit}")
    private boolean enableAutoCommit;

    @Value("${kafka.consumer.session.timeout}")
    private String sessionTimeout;

    @Value("${kafka.consumer.auto.commit.interval}")
    private String autoCommitInterval;

    @Value("${kafka.consumer.group.id}")
    private String groupId;

    @Value("${kafka.consumer.auto.offset.reset}")
    private String autoOffsetReset;

    @Value("${kafka.consumer.concurrency}")
    private int concurrency;

    /**
     * 消费者工厂，负责创建相应的消费者
     * @return 消费者工厂类
     */
    @Bean
    public ConsumerFactory<String, Object> consumerFactory() {
        JsonDeserializer<Object> deserializer = new JsonDeserializer<>(Object.class);
        deserializer.addTrustedPackages("com.cmwin.amy.message.domains");
        return new DefaultKafkaConsumerFactory<>(
                commonConsumerConfigs(),
                new StringDeserializer(),
                deserializer);
    }

    /**
     * 消费者监听器创建工厂
     * @return
     */
    @Bean
    public KafkaListenerContainerFactory<ConcurrentMessageListenerContainer<String, Object>> kafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, Object> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(consumerFactory());
        // 如果分区数大于消费者数量的时候，启动多个消费线程同时消费。
        factory.setConcurrency(concurrency);
        //  批量获取消息进行消费必须设置
        factory.setBatchListener(true);
        factory.getContainerProperties().setPollTimeout(1500);
        factory.getContainerProperties().setAckMode(ContainerProperties.AckMode.MANUAL);
        return factory;
    }

    /**
     * kafka 消费者的基本配置
     * @return
     */
    private Map<String, Object> commonConsumerConfigs() {
        Map<String, Object> propsMap = new HashMap<>();
        propsMap.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, servers);
        propsMap.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, enableAutoCommit);
        propsMap.put(ConsumerConfig.AUTO_COMMIT_INTERVAL_MS_CONFIG, autoCommitInterval);
        propsMap.put(ConsumerConfig.SESSION_TIMEOUT_MS_CONFIG, sessionTimeout);
            propsMap.put(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, 20);
        propsMap.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, autoOffsetReset);
        return propsMap;
    }

}
```

## listener结果转发

```java
@SendTo("topic_a")
@KafkaListener(topics = "topic_b")
public String sendToTest() {
    return "message to topica";
}
```



## 取消和启动kafkaListener

```java
public interface KafkaConsumerListener {
    void startListener(String listenerId);
    void stopListener(String listenerId);
}

@Service
public class KafkaConsumerListenerImpl implements KafkaConsumerListener {

    private Logger logger = LoggerFactory.getLogger(KafkaConsumerListenerImpl.class);

    private KafkaListenerEndpointRegistry registry;

    public KafkaConsumerListenerImpl(KafkaListenerEndpointRegistry registry) {
        this.registry = registry;
    }

    /**
     * 开启监听.
     *
     * @param listenerId 监听ID
     */
    @Override
    public void startListener(String listenerId) {
        //判断监听容器是否启动，未启动则将其启动
        if (!registry.getListenerContainer(listenerId).isRunning()) {
            registry.getListenerContainer(listenerId).start();
        }
        //项目启动的时候监听容器是未启动状态，而resume是恢复的意思不是启动的意思
        if (registry.getListenerContainer(listenerId).isRunning()){
            logger.info(listenerId + "开启监听成功。");
        }else {
            logger.error(listenerId + "开启监听失败。");
        }
    }

    /**
     * 停止监听.
     *
     * @param listenerId 监听ID
     */
    @Override
    public void stopListener(String listenerId) {
        registry.getListenerContainer(listenerId).stop();
        logger.info(listenerId + "停止监听成功。");
    }
}
```


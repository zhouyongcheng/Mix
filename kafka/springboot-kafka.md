# springboot-kafka实现顺序
* 创建消费者和生产者的Map配置
* 根据Map配置创建对应的消费者工厂(consumerFactory)和生产者工厂(producerFactory)
* 根据consumerFactory创建监听器的监听器工厂
* 根据producerFactory创建KafkaTemplate(Kafka操作类)
* 创建监听容器



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


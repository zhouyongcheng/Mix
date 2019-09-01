# springboot-kafka实现顺序
* 创建消费者和生产者的Map配置
* 根据Map配置创建对应的消费者工厂(consumerFactory)和生产者工厂(producerFactory)
* 根据consumerFactory创建监听器的监听器工厂
* 根据producerFactory创建KafkaTemplate(Kafka操作类)
* 创建监听容器

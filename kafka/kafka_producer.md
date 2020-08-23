## 异常信息

```
ABX001:37:2710 BYTE
nested exception is org.apache.kafka.common.errors.RecordTooLargeException: The message is 2710 bytes when serialized which is larger than the maximum request size you have configured with the max.request.size configuration.
```



## 修改topic的最大消息尺寸

```
bin/kafka-configs.sh --zookeeper localhost:2181  --alter --topic tp_store_sell_out_dashboard --config max.message.bytes=2097152 

kafka-configs.bat --zookeeper localhost:2181  --alter --topic tp_store_sell_out_dashboard --config max.message.bytes=2097152 


bin/kafka-topics.sh --zookeeper localhost:2181 --alter --topic tp_store_sell_out_dashboard --config max.message.bytes=128000

```



# 生产者的配置

* acks:
   写如数数据分片的几个复制集才认为写入操作成功。
    acks = 0  
        生产者发送完消息就认为成功，有可能发生消息丢失的情况，但发送消息的吞吐量最大化。

    acks = 1
    	leader replica收到消息就返回成功，但仍然有可能丢消息（写入失败）。但概论小了。
    	吞吐量和同步，异步的方式有观，异步的快。

    acks = all
         要所有包含要写入分区的broker都收到消息后才返回成功。（可能丢消息，机率小，数据中心挂了的场景）。


 * buffer.memory
  ```
      生产者在发送消息的时候，为提高效率，会把发送到同一个topic，partition的消息缓存成一批，进行一次发送。
      如果应用产生的消息速度快于producer发送消息的速度，后产生的消息就会block，（缓存空间不足）如果block的时间超过max.block.ms,
      则producer就会报异常。
  ```

  * batch.size
  * linger.ms
 ```
    一个batch最多存储的字节大小。如果batch满了，则producer会立即把消息发送到brokers。
    每次发送batch内的消息到broker的最大等待时间 。
    任何一个阀值满足，都会执行向broker发送消息。
 ```

max.in.flight.requests.per.connection
timeout.ms
request.timeout.ms
metadata.fetch.timeout.ms
max.block.ms
max.request.size
receive.buffer.bytes
send.buffer.bytes

```
	
```



  * compression.type
  ```
  	3种选择 【gzip，snappy，lz4】
  	推荐使用： snappy
  ```

  * retries
  * retry.backoff.ms
  ```
     两个参数共同确定给应用抛异常的时间。（重试次数及每次重试之间的间隔时间）
  ```



## broker中配置

```properties
# broker能接收消息的最大字节数,值应该比消费端的fetch.message.max.bytes更小才对
message.max.bytes=1000000
message.max.bytes=1001
replica.fetch.max.bytes=1002
# consumer
fetch.message.max.bytes=1002




```



## consumer配置

```properties
 # 消费者能读取的最大消息,这个值应该大于或等于message.max.bytes(broker配置参数)
 fetch.message.max.bytes
```


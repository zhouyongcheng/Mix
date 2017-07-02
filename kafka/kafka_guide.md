$(Kafka monitor)[https://github.com/quantifind/KafkaOffsetMonitor]

# install kafka
# start kafka
before starting kafka, zookeeper is already configured in the config/server.properties
* bin/kafka-server-start.sh config/server.properties
* bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
* bin/kafka-topics.sh --list --zookeeper localhost:2181
* bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
* bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning

 bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic my-replicated-topic
 bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic my-replicated-topic

## server.properties configuration metadata

```
broker.id=0  
num.network.threads=2  
num.io.threads=8  
socket.send.buffer.bytes=1048576  
socket.receive.buffer.bytes=1048576  
socket.request.max.bytes=104857600  
log.dirs=/tmp/kafka-logs  
num.partitions=2  
log.retention.hours=168  
  
log.segment.bytes=536870912  
log.retention.check.interval.ms=60000  
log.cleaner.enable=false  
  
zookeeper.connect=localhost:2181  
zookeeper.connection.timeout.ms=1000000
```
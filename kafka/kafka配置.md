## kafka 消费者默认配置
```
auto.commit.interval.ms = 1000
auto.offset.reset = latest
bootstrap.servers = [bigserver1:9092, bigserver2:9092, testing:9092]
check.crcs = true
client.dns.lookup = default
client.id =
connections.max.idle.ms = 540000
default.api.timeout.ms = 60000
enable.auto.commit = true
exclude.internal.topics = true
fetch.max.bytes = 52428800
fetch.max.wait.ms = 500
fetch.min.bytes = 1
group.id = track_pc
heartbeat.interval.ms = 3000
interceptor.classes = []
internal.leave.group.on.close = true
isolation.level = read_uncommitted
key.deserializer = class org.apache.kafka.common.serialization.StringDeserializer
max.partition.fetch.bytes = 1048576
max.poll.interval.ms = 300000
max.poll.records = 500
metadata.max.age.ms = 300000
metric.reporters = []
metrics.num.samples = 2
metrics.recording.level = INFO
metrics.sample.window.ms = 30000
partition.assignment.strategy = [class org.apache.kafka.clients.consumer.RangeAssignor]
receive.buffer.bytes = 65536
reconnect.backoff.max.ms = 1000
reconnect.backoff.ms = 50
request.timeout.ms = 10000
retry.backoff.ms = 100
sasl.client.callback.handler.class = null
sasl.jaas.config = null
sasl.kerberos.kinit.cmd = /usr/bin/kinit
sasl.kerberos.min.time.before.relogin = 60000
sasl.kerberos.service.name = null
sasl.kerberos.ticket.renew.jitter = 0.05
sasl.kerberos.ticket.renew.window.factor = 0.8
sasl.login.callback.handler.class = null
sasl.login.class = null
sasl.login.refresh.buffer.seconds = 300
sasl.login.refresh.min.period.seconds = 60
sasl.login.refresh.window.factor = 0.8
sasl.login.refresh.window.jitter = 0.05
sasl.mechanism = GSSAPI
security.protocol = PLAINTEXT
send.buffer.bytes = 131072
session.timeout.ms = 10000
ssl.cipher.suites = null
ssl.enabled.protocols = [TLSv1.2, TLSv1.1, TLSv1]
ssl.endpoint.identification.algorithm = https
ssl.key.password = null
ssl.keymanager.algorithm = SunX509
ssl.keystore.location = null
ssl.keystore.password = null
ssl.keystore.type = JKS
ssl.protocol = TLS
ssl.provider = null
ssl.secure.random.implementation = null
ssl.trustmanager.algorithm = PKIX
ssl.truststore.location = null
ssl.truststore.password = null
ssl.truststore.type = JKS
value.deserializer = class org.apache.kafka.common.serialization.StringDeserializer
```

* session.timeout.ms
>在设定的时间内，没有收到消费者的心跳通知，则认为消费者死亡，发生rebalance。

* heartbeat.interval.ms
> 消费者多长时间向broker报告自己的健康状况。 建议设置小于session.timeout.ms/3 

* request.timeout.ms
> 向kafka获取消息后，在指定的时间内没有向kafka发送响应信息，认为失败（重试机会有设置）
> 这个值需要比session.timeout.ms大（就是在session时间内，给kafka发响应都可以？）

* earliest
>分区下有已提交的offset时，从提交的offset开始消费；无提交的offset时，从头开始消费 
* latest 
>分区下有已提交的offset时，从提交的offset开始消费；无提交的offset时，消费新产生的该分区下的数据

* max.poll.interval.ms
> 两次poll之间的最大时间，如果超过这个时间，则poll出来的数据回滚到kafka。结果：
> 1）数据回滚，导致重复消费的可能。
> 2）会发生rebalance（消费者在poll的时候发送心跳？）
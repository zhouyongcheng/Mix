bin/kafka-topics.sh --create --zookeeper 172.25.216.29:2182,172.25.216.30:2182,172.25.216.31:2182 --replication-factor 3 --partitions 6 --topic tp_product_sell_out_notification
bin/kafka-topics.sh --create --zookeeper 172.25.216.29:2182,172.25.216.30:2182,172.25.216.31:2182 --replication-factor 3 --partitions 6 --topic tp_product_sell_out_notification_trace
bin/kafka-topics.sh --list --zookeeper 172.25.216.29:2182,172.25.216.30:2182,172.25.216.31:2182

-- 创建topic，并指定该topic的数据保留时间。
bin/kafka-topics.sh --create --zookeeper zk1:2182,zk2:2182,zk3:2182 --replication-factor 3 --partitions 6 --topic demo --config delete.retention.ms=259200000


## 手动分配分区信息。
如果指定了--replica-assignment,则不用指定--replication-factor和partitions了。
前提条件： 
brokerid = 0,1,2
分区数： 4
副本因子： 2
---------------------
分区1：0,1   （broker0：broker1）
分区2：1,2
分区3：0,2
分区4：1,2
bin/kafka-topics.sh --create --zookeeper zk1:2182,zk2:2182,zk3:2182 --replica-assignment 0:1,1:2,0:2,1:2 --topic demo

# 删除topic
* 确保参数配置
 delete.topic.enable=true
 bin/kafka-topics.sh --delete --zookeeper localhost:2181 --topic test
 若要确定topic是否删除成功，需要用list命令查看topic的信息
 bin/kafka-topics.sh --zookeeper localhost:2181 --list

 ## 查询topic的详情
bin/kafka-topics.sh --zookeeper localhost:2181 --describe --topic test


## 修改分区
可以为topic增加分区，但不允许减少topic的分区数。
当发送到topic的消息有key时，增加分区可能会影响用户的业务逻辑，所有增加分区前要进行分析确认。
bin/kafka-topics.sh  --alter --zookeeper localhost:2181 --partitions 5 test-topic


## kafka-config.sh
bin/kafka-config.sh --zookeeper localhost:2181 --alter -entity-type topics --entity-name test-topic --add-config cleanup.policy=compact

bin/kafka-config.sh --zookeeper localhost:2181 --describe -entity-type topics --entity-name test-topic

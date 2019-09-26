bin/kafka-topics.sh --create --zookeeper 172.25.216.29:2182,172.25.216.30:2182,172.25.216.31:2182 --replication-factor 3 --partitions 6 --topic tp_product_sell_out_notification
bin/kafka-topics.sh --create --zookeeper 172.25.216.29:2182,172.25.216.30:2182,172.25.216.31:2182 --replication-factor 3 --partitions 6 --topic tp_product_sell_out_notification_trace
bin/kafka-topics.sh --list --zookeeper 172.25.216.29:2182,172.25.216.30:2182,172.25.216.31:2182

-- es mapping create

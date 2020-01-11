## kafka针对某个topic消费，如果中途有条消息消费失败，会不会影响后续的消息消费？

## kafka的消费者消费消息速度慢，导致消息积压的解决
* enable.auto.commit=false; (关闭自动提交)
* session.timeout.ms=100000(增大session超时时间)
    消费者在指定的时间内没有给消费协调者发送心跳，则认为消费者无效，重新平衡各个消费者。
    消费者何时发送心跳信息？
* request.timeout.ms=110000(socket握手超时时间,默认是3000 但是kafka配置要求大于session.timeout.ms时间)


## rebalance的问题解决 
>两次pull之间的时间超过阀值，GroupCoordination会认为ConsumerCoordination已经消失，然后进行rebalance. 所以要尽量避免两次pull相邻时间过程导致rebalance。
* 消费者是在poll的时候发送心跳的，所以超过interval的时间，则认为消费者失效，rebalance
* max-poll-records: 
    数量过多，导致一次poll操作返回的消息在指定的时间内不能完成，就会导致提交失败，数据回滚到kafka中，会发生重复消费的情况。 （会不会发生rebalance？）
    
* max.poll.interval.ms: 设置一次poll出来的记录，在这个时间范围内能够处理完成。但不要设置太长，可以减少poll的记录数。

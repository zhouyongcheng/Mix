以下内容参考[es性能调优](https://knownsec-fed.com/2019-01-09-elasticsearch-xing-neng-tiao-you/)

# elasticsearch的生命周期管理
* Elasticsearch从设置、创建、打开、关闭、删除的全生命周期过程的管理。
* 

## 系统层面的调优
```
1. 系统层面的调优主要是内存的设定与避免交换内存,确保堆内存最小值（Xms）与最大值（Xmx）的大小是相同的，防止程序在运行时改变堆内存大小，这是一个很耗系统资源的过程. 不要超过32G，超过了也没有什么作用。在配置文件中对内存进行锁定，以避免交换内存
bootstrap.mlockall: true

```

## 分片与副本
```
创建索引的时候，应该创建多少个分片与副本数
副本数: 根据物理硬件的情况，2~3个副本，但至少保障一个副本，保障容灾。（副本数可以动态调整）
分片数
是比较难确定的。因为一个索引分片数一旦确定，就不能更改，保证每一个分片的大小没有超过 50G（大概在 40G 左右），但是相比之前的分片数查询起来，效果并不明显。之后又尝试了增加分片数，发现分片数增多之后，查询速度有了明显的提升，每一个分片的数据量控制在 10G 左右。

如果现在你的场景是分片数不合适了，但是又不知道如何调整，那么有一个好的解决方法就是按照时间创建索引，然后进行通配查询。如果每天的数据量很大，则可以按天创建索引，如果是一个月积累起来导致数据量很大，则可以一个月创建一个索引。如果要对现有索引进行重新分片，则需要重建索引，我会在文章的最后总结重建索引的过程。
```

## 参数调优
```
index.refresh_interval：
这个参数的意思是数据写入后几秒可以被搜索到，默认是 1s。每次索引的 refresh 会产生一个新的 lucene 段, 这会导致频繁的合并行为，如果业务需求对实时性要求没那么高，可以将此参数调大，实际调优告诉我，该参数确实很给力，cpu 使用率直线下降。

indices.memory.index_buffer_size：
如果我们要进行非常重的高并发写入操作，那么最好将 indices.memory.index_buffer_size 调大一些，index buffer 的大小是所有的 shard 公用的，一般建议（看的大牛博客），对于每个 shard 来说，最多给 512mb，因为再大性能就没什么提升了。ES 会将这个设置作为每个 shard 共享的 index buffer，那些特别活跃的 shard 会更多的使用这个 buffer。默认这个参数的值是 10%，也就是 jvm heap 的 10%。

index.merge.scheduler.max_thread_count:1 # 索引 merge 最大线程数
indices.memory.index_buffer_size:30%     # 内存
index.translog.durability:async # 这个可以异步写硬盘，增大写的速度
index.translog.sync_interval:120s #translog 间隔时间
discovery.zen.ping_timeout:120s # 心跳超时时间
discovery.zen.fd.ping_interval:120s     # 节点检测时间
discovery.zen.fd.ping_timeout:120s     #ping 超时时间
discovery.zen.fd.ping_retries:6     # 心跳重试次数
thread_pool.bulk.size:20 # 写入线程个数 由于我们查询线程都是在代码里设定好的，我这里只调节了写入的线程数
thread_pool.bulk.queue_size:1000 # 写入线程队列大小
index.refresh_interval:300s #index 刷新间隔
```

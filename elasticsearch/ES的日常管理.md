## 启动关闭ES
```
/opt/elasticsearch/bin/elasticsearch -d
ps -ef | grep elasticsearch
kill -9 pidxxx
```

## 删除索引和删除文档的区别
* 删除索引是会立即释放空间的，不存在所谓的“标记”逻辑。
* 删除文档的时候，是将新文档写入，同时将旧文档标记为已删除。 磁盘空间是否释放取决于新旧文档是否在同一个segment file里面，因此ES后台的segment merge在合并segment file的过程中有可能触发旧文档的物理删除。但因为一个shard可能会有上百个segment file，还是有很大几率新旧文档存在于不同的segment里而无法物理删除。想要手动释放空间，只能是定期做一下force merge，并且将max_num_segments设置为1。


## ES官网工具——curator工具。


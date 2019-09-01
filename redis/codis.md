# codis介绍
> Codis 支持按照 Namespace 区分不同的产品, 拥有不同的 product name 的产品, 各项配置都不会冲突。 

## Codis由四部分组成
* Codis Proxy (codis-proxy)
* Codis Manager (codis-config)
* Codis Redis (codis-server)
* ZooKeeper

## Codis-proxy
  > codis-proxy 是客户端连接的 Redis 代理服务,可以部署多个 codis-proxy, 本身是无状态的。

## Codis-config
> Codis 的管理工具, 支持包括, 添加/删除 Redis 节点, 添加/删除 Proxy 节点, 发起数据迁移等操作

## codis-server
> 相当于redis-server实例(instance) 

> 
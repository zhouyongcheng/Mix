[Elasticsearch 基于时间的索引](http://russellluo.com/2017/05/elasticsearch-time-based-indices.html

## 目标
* 数据分段存储在不同的索引中
* 数据存储在不同的索引中，提供横向扩展功能。

## 选择建立索引的时间范围
* 按天进行索引 2019-01-01
* 按周进行索引 
* 按月进行索引 2010-05

## 设计索引模板
目的是管理好日益增加的索引的setting,mapping等内容。利用ES 的index template实现。
Index Templates 的基本原理是：首先预定义一个或多个 “索引模板”（index template，其中包括 settings 和 mappings 配置）；然后在创建索引时，一旦索引名称匹配了某个 “索引模板”，ES 就会自动将该 “索引模板” 包含的配置（settings 和 mappings）应用到这个新创建的索引上面。


## 售罄跟踪日志索引
    按照天进行索引，最多保留一周的数据就可以了（也许3天的数据就足以），无需保留长时间的数据。
1. 按天索引（索引名称形如 trace-2019-05-16）
2. 每天的日志数据，只会进入当天的索引
3. 搜索的时候，希望搜索范围是所有的索引（借助 alias）
4. 创建索引时，如果索引名称的格式形如 “log-*”，ES 会自动将上述 settings 和 mappings 应用到该索引
5. aliases 的配置，告诉 ES 在每次创建索引时，自动为该索引添加一个名为 “search-logs” 的 alias（别名）

### 创建索引模板
```
$ curl -XPUT http://localhost:9200/_template/log_template -d '{
  "template": "log-*",
  "settings": {
    "number_of_shards": 1
  },
  "mappings": {
    "log": {
      "dynamic": false,
      "properties": {
        "content": {
          "type": "string"
        },
        "created_at": {
          "type": "date",
          "format": "dateOptionalTime"
        }
      }
    }
  },
  "aliases": {
    "search-logs": {}
  }
}'
```

## 创建索引的过程
## 搜索的过程
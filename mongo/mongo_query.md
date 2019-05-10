# 数据库的操作
## 数据的插入
```
db.test.save({})
> for (var i = 0; i < 10; i++) db.test.save({})
```

## 查询操作

- 查询并输出内容  
db.todo.find().forEach(printjson);


- 查询中，如果和key进行匹配的是一个对象，则必须和该对象完全匹配才能获取数据。
-- 可以使用limit和skip实现分页功能。
- 查询中使用点号[.] 	子对象或者数组对象中使用。（对象型），查找文档中的内嵌信息（数组及对象型）

## 聚集【命令】
```
db.media.count()
db.media.find({type: 'CD'}).count()   -- 默认情况会忽略limit和skip语句进行统计。
db.media.find({type: 'CD'}).count(true)   --不忽略limit和skip语句进行统计。
db.media.distinct("title");                 -- 返回文档的title数组结果。
db.media.distinct("product.color")
db.media.group({
	key ： {Title: true},
	initial: {Total: 0},
	reduce: function(items, prev) {
			prev.Total += 13;
	}
})
```


db.media.find({released: {$all: ['2001', '2009']}})

db.media.find({released: {$in: ['2001', '2017']}})

-- 获取单个文档
db.media.findOne().pretty();

## 使用条件操作符
- 大于，大于等于，小于，小于等于  
db.media.find({released: {$gt: '2017'}})
db.media.find({released: {$gte: '2017'}})
db.media.find({released: {$lt: '2017'}})
db.media.find({released: {$lte: '2017'}})

- null处理 
查找的记录不仅包括值为null的记录，还包括不包含查询key的记录。

- 数组内容的查询  
```
tag代表数组，tag: ['java','db', 'javascript']
1. 数组中包含某个值
db.todo.find({tag: 'java'})

2. 同时包含几个值, tag数组中必须同时有java. db两个值。
db.todo.find({tag: {$all: ['java','db']}})
db.todo.find({name: 'xxxx'}, {"job": {$slice: [1,2]}} )

db.media.find({release: {$mod: [2,1]}})  -- 获取发现年份为奇数的文档。
db.media.find({TrackList: {$size: 2}})  --获取traclist长度为2的文档。
```

- 内嵌文档的查询
```
用点操作符进行查询。 db.todo.find({"location.address": 'shenzheng'})
```

db.media.find({$or: [{released: {$in: ['2001', '2002']}}, {type: 'DVD'}]})
db.media.find({type: 'java'}, {author: {$slice: 3}})
db.media.find({auth:'zhouyc'}, {language: {$slice: [4,-3]}});
db.media.find({released: {$mod: [2, 0]}})
db.media.find({released: {$mod : [2, 1]}})
db.media.find({tracklist: {$size: 2}})
db.media.find({operation: {$exists: true}})
db.media.find({operation: {$exists: false}})
db.media.find({tracklist: {$elemMatch: {type:'DVD', released: {$gt: 2017}}}})   --匹配完整数组
db.media.find({tracklist: {$not: {$elemMatch: {type:'DVD', released: '2012'}}})
db.media.find({title: /Java*/i})
db.media.find({"name": /(zhou|li)*/i})

- group操作  
```
db.media.group({
    key : {address: true},
    cond: {country: 'cn'},
    reduce: function(obj, prev) {prev.psum += obj.pcount},
    initial: {psum: 0}
}) 
obj:  代表当前的记录
prev: 当前记录之前记录的统计结果
initial: 统计的初始值
```
db.media.findOne({title : /xleaning/})

db.media.findOne({author: 'zhouyc'})

db.todo.aggregate({$group: {_id: "$category", count: {$sum: 1}}});

## 更新操作
```
db.todo.update({label: 'game'}, {$set: {title: 'basketball'}})
db.todo.update({label: 'game'}, {$unset: {address: 1}})
{$set: {"company", "dha"}}   -- 在集合中添加一个字段
{$unset: {"company": ""}}
{$inc: {age: 5}}
{$unset: {address : 1}}
{$push: {'book': 'java in action'}}
{$pushAll: {'book': ['javascript', 'angular']}}
{$addToSet: {'book': 'angularjs'}}
{$pop: {'book', -1}}
{$pop: {'book', 1}}
{$pull: {'book', 'angular'}}
{$pullAll: {'book', ['java', 'angularjs']}}
{$rename : {'book': 'bookes'}}

```

## 删除记录
```
db.todo.remove({label: 'game'})
db.todo.drop()  -删除一个集合
```


## capped collection
- db.createCollection("syslog", {capped:true,size: 1000000, max:200})
- db.isCapped() 

# 数据库的操作
## 数据的插入
```
db.test.save({})
> for (var i = 0; i < 10; i++) db.test.save({})
```

## 查询操作

```properties
# 查询键位的值为null的语句
db.c.find({"z": {"$in": [null], "$exsits": true}})
# 查询并输出内容
db.todo.find().forEach(printjson);
```

## 聚集
```
db.media.count()
db.media.count({"type": "cd"})           -- 统计满足条件的记录数
db.media.find({type: 'CD'}).count()      -- 默认情况会忽略limit和skip语句进行统计。
db.media.find({type: 'CD'}).count(true)   --不忽略limit和skip语句进行统计。
db.media.distinct("title");               -- 返回文档的title数组结果。
db.media.distinct("product.color")
db.media.group({
	key ： {Title: true},
	initial: {Total: 0},
	reduce: function(items, prev) {
			prev.Total += 13;
	}
})
```


## aggregation操作
```

```


db.media.find({released: {$all: ['2001', '2009']}})

db.media.find({released: {$in: ['2001', '2017']}})

-- 获取单个文档
db.media.findOne().pretty();

## 使用条件操作符

```properties
# 大于，大于等于，小于，小于等于  
db.media.find({released: {$gt: '2017'}})
db.media.find({released: {$gte: '2017'}})
db.media.find({released: {$lt: '2017'}})
db.media.find({released: {$lte: '2017'}})

- null处理 
  查找的记录不仅包括值为null的记录，还包括不包含查询key的记录。
```

### 数组内容的查询  

```properties
# 数组对象
tag代表数组，tag: ['java','db', 'javascript']

# 数组中包含某个值
db.todo.find({tag: 'java'})

# 同时包含几个值, tag数组中必须同时有java. db两个值。
db.todo.find({tag: { $all: ['java','db']}})

# 精确匹配，当tag的内容和条件中的内容完全一致的情况下才有记录（包括顺序）
db.todo.find({"tag": ['java', 'db', 'javascript']})

# 查询指定位置的值（数组中的第几个记录的值满足条件
db.todo.find({"tag.2", "javascript"})

# 根据数组包含的元素的个数来查询
db.todo.find({"tag" : {"$size" : 3}})

# 子文档的多个属性匹配
db.todo.find({"address": {$elemMatch : {name : "home", state: 'NY'}}});

# 获取traclist长度为2的文档。
db.media.find({TrackList: {$size: 2}})  

# 获取发现年份为奇数的文档。
db.media.find({release: {$mod: [2,1]}})  

```

### 内嵌文档的查询

```properties
# 用点操作符进行查询。 
db.todo.find({"location.address": 'shenzheng'})
# and查询
db.media.find({$or: [{released: {$in: ['2001', '2002']}}, {type: 'DVD'}]})
db.media.find({released: {$mod: [2, 0]}})
db.media.find({released: {$mod : [2, 1]}})
db.media.find({tracklist: {$size: 2}})
db.media.find({operation: {$exists: true}})
db.media.find({operation: {$exists: false}})
# 匹配数组中的子文档的属性，同一个子文档的两个属性
db.media.find({tracklist: {$elemMatch: {type:'DVD', released: {$gt: 2017}}}}) 
db.media.find({tracklist: {$not: {$elemMatch: {type:'DVD', released: '2012'}}})
db.media.find({title: /Java*/i})
db.media.find({"name": /(zhou|li)*/i})
```

### 投影操作

```properties
# 查询的结果中，只获取前3个用户的信息。
db.media.find({type: 'java'}, {author: {$slice: 3}})
# 结果中，返回3开始的元素，一共返回4个。  
db.media.find({type: 'java'}, {author: {$slice: [3,4]}})
#
db.media.find({auth:'zhouyc'}, {language: {$slice: [4,-3]}});

```





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

- 正则表达式
db.media.findOne({"title" : /xleaning/i})  不区分大小写

db.media.findOne({author: 'zhouyc'})

db.todo.aggregate({$group: {_id: "$category", count: {$sum: 1}}});

## 更新操作

* 至少包含2个参数，1个指明要更新的文档（查询语句），2：如何更新

```shell
# 添加新的属性或者更新属性的值。
db.todo.update({label: 'game'},  {$set: {title: 'basketball'}})
# 删除指定的属性
db.todo.update({label: 'game'}, {$unset: {address: 1}})

# 以下是操作部分的内容；
# 在集合中添加或者更新指定的属性。
{$set: {"company", "dha"}}
# 删除指定属性。
{$unset: {"company": 1}}
{$unset: {address : 1}}
# 数子类型的值+5
{$inc: {age: 5}}
# 添加数组类型的属性，并把值放到数组中
{$push: {'book': 'java in action'}}
{$pushAll: {'book': ['javascript', 'angular']}}
# 
{$addToSet: {'book': 'angularjs'}}
{$pop: {'book', -1}}
{$pop: {'book', 1}}
# 参数是要移除数组中具体的值
{$pull: {'book', 'angular'}}
{$pullAll: {'book', ['java', 'angularjs']}}
# 给属性重命名
{$rename : {'book': 'bookes'}}

```

## 删除记录
```properties
# 清除集合中指定条件的记录
db.todo.remove({label: 'game'})

# 删除一个集合，包括该集合中创建的索引
db.todo.drop()  

```


## 固定大小的集合
- db.createCollection("syslog", {capped:true,size: 1000000, max:200})
- db.isCapped() 

## mapReduce整理
map = function() {
    for (var key in this) {
        emit(key, {"count" : 1})
    }
}

reduce = function(key, emits) {
    int total = 0;
    for (var item of emits) {
        total += emits.count
    }
    return {"count": total};
}

## 创建索引的语法
db.sellout.ensureIndex({"username": 1});
db.sellout.ensureIndex({"user.firstname": 1}); 
> 内嵌文档的索引
db.sellout.ensureIndex({"user.firstname": 1}, {"name": "firtname_index"});
> 唯一索引
db.sellout.ensureIndex({"product.key_id": 1}, {"unique":true});    
> 创建唯一索引，如果有重复记录，则保留一条，其他删除
db.sellout.ensureIndex({"product.key_id": 1}, {"unique":true, "dropDups":true});  
> 创建索引，并在后台执行
db.sellout.ensureIndex({"productId": 1}, {"background":true});   

## 删除索引
>删除指定的索引dropIndex()
db.COLLECTION_NAME.dropIndex("INDEX-NAME")

>删除所有索引
db.COLLECTION_NAME.dropIndexes()

## 创建索引的缺点
* 每次进行创建，删除，更新的时候都会产生额外的开销。
* 每个集合（collection),最多能创建64个索引，应尽量避免创建索引的个数。
* 查询返回的结果是占数据的大半部分的话，不要使用索引。
* 

## 创建索引的规则
* 查询字段上构建索引，也要考虑在排序字段上建立索引。
* 一定要创建查询中使用到的所有键的索引。
* 一个索引由多个键位组成，需要考虑多个键位的方向和顺序问题。
* 索引由多个键位组成，则查询其中的单个键位，也能提高其查询速度。
* 只有使用索引的前几个字段的查询才会有所帮助，如果检索条件不包含前面的键，则不会优化。
* mongodb查询优化器会重新排列查询项的顺序，会按照索引的顺序重排查询条件。
* 会做什么样的查询，哪些键需要建立索引。
* 每个键的索引方向。
* 索引的方向，使常用的数据放置在内存中（比如日期型的数据按降系，最新的数据驻留在内存

## 索引的分析和使用
* explain和hint的使用
db.sellout.find().explain();

## 查询索引的基本信息
>查看数据库中所有索引
db.system.indexes.find()
db.system.indexes.find({"ns":"test.c", "name": "age_1"});
db.system.namespaces.find();
db.COLLECTION_NAME.getIndexes()
db.COLLECTION_NAME.totalIndexSize()





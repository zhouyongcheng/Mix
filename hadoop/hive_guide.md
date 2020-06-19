# 1. hive构建

操作用户: 非root用户进行hive的安装,配置,起动.

## 1.1 hive3.1.2安装

[安装参考]: https://blog.csdn.net/weixin_43824520/article/details/100580557	"安装参考"

### 问题点
1. 启动hive报which : no hbase in
    在hive/lib目录中添加mysql的java驱动.
2. com.google.common.base.Preconditions.checkArgument
    hadoop和hive的lib目录中,比较那个guava版本高,就用谁的覆盖.

## 1.2 HiveCatalog配置

metastore的配置

```
source /data/soft/hive-3.1.2/scripts/metastore/upgrade/mysql/hive-schema-3.1.0.mysql.sql
CREATE USER 'hive'@'%' IDENTIFIED BY 'manager';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'hive'@'%';
mysql> GRANT ALL ON metastore.* TO 'hive'@'%' IDENTIFIED BY 'hive';
mysql> GRANT ALL ON metastore.* TO 'hive'@'%' IDENTIFIED BY 'hive';
mysql> FLUSH PRIVILEGES;
mysql> ALTER DATABASE metastore CHARACTER SET latin1;

```

### metastore server开启

```shell
hive --service metastore
sudo stop hive-hcatalog-server
```

### hdfs的访问路径

```xml
<!-- /data/soft/hadoop-3.2.1/etc/hadoop/core-site.xml中的fs.defaultFS确定 -->
<configuration>
   <property>
      <name>fs.defaultFS</name>
      <value>hdfs://node03:9000</value>
    </property>
    <property>
      <name>hadoop.tmp.dir</name>
      <value>/data/hadoop/tmp</value>
    </property>
 </configuration>
```



## 2. 创建表

### 注意点

```properties
1.建表的过程中没有指定location，那么就会在hive.metastore.warehouse.dir指定的路径下，以表名创建一个文件夹，之后所有有关该表的数据都会存储到此文件夹中。
hive-site.xml的内容hive.metastore.warehouse.dir

```



### 2.1 创建内部表

```mysql
CREATE TABLE mc.dept (
	id int,
 	name string,
 	location string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

-- 从本地导入
LOAD DATA LOCAL INPATH '/mysql/cmwin' OVERWRITE INTO TABLE dept; 

-- 从hdfs路径导入数据到hive(奇怪现象,导入后,/mc/db/dept/*下的内容消失了??
LOAD DATA INPATH 'hdfs://node03:9000/mc/db/dept/*' OVERWRITE INTO TABLE dept; 

-- 删除内部表的时候，不仅删除了表中的数据，还删除了数据文件。
```

### 2.2 创建外部表

```mssql
hive> create external table T_D_KEY_CHANNEL(guid string,brand_code int, channel_name string)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE;
    
    LOAD DATA INPATH 'hdfs://node03:9000/mc/db/T_D_KEY_CHANNEL/*' OVERWRITE INTO TABLE T_D_KEY_CHANNEL; 
    
--  创建外部表后,通过load的方式把数据装载到hive后,hdfs下,该文件变成了不可见状态. 实际上时文件的路径被迁移到  了hive的数据库目录下面了./mc/db/mytest;
--  删除外部表，只能删除表数据，并不能删除数据文件。
```







hive常用命令

```shell
/data/bin/hive-3.2.1/bin/hive
show databases;

```


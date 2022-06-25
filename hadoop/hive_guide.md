访问地址

```
http://node41:9870
```



# 1. hive构建

操作用户: 非root用户进行hive的安装,配置,起动.

## 1.1 hive3.1.2安装

```shell
# 解压hive到/usr/local/hive
# 删除guava包
rm /usr/local/hive/lib/guava-xxx.jar
# copy guava包
cp /usr/local/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar /usr/local/hive/lib
# 添加mysql的driver到hive的lib下
# 编剧hive-site.sh环境变量
export HADOOP_HOME=/usr/local/hadoop
export HIVE_CONF_DIR=/usr/local/hive/conf
export HIVE_AUX_JARS_PATH=/usr/local/hive/lib

# 修改hive-site.xml文件

# 初始化hive的metadata
bin/schematool -initSchema -dbType mysql --verbose

# 启动metastore服务
nohup bin/hive --service metastore &

nohup bin/hive --service hiveserver2 &

# 访问hive
bin/hive

```

## 配置hive-site.xml

```xml
<configuration>
  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>root</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>cmwin110!</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:mysql://192.168.101.44:3306/hive?createDatabaseIfNotExist=true&amp;useSSL=false</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>com.mysql.jdbc.Driver</value>
  </property>
  <property>
    <name>hive.metastore.schema.verification</name>
    <value>false</value>
  </property>
  <property>
    <name>datanucleus.schema.autoCreateAll</name>
    <value>true</value>
  </property>
  <property>
     <name>hive.server2.thrift.bind.host</name>
     <value>node44</value>
  </property>
</configuration>
```

编剧hadoop的core-site.xml,添加下面两项目。

```xml
<property>
    <name>hadoop.proxyuser.root.hosts</name>
    <value>*</value>
  </property>
  <property>
    <name>hadoop.proxyuser.root.groups</name>
    <value>*</value>
  </property>d
```



## 1.2 HiveCatalog配置

metastore的配置

```shell
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

### 创建分区表

```properties
# 创建动态分区表时，设置系统参数
set hive.exec.dynamic.partition=true
set hive.exec.dynamic.partition.mode=nonstrict;
```



舞蹈





hive常用命令

```shell
/data/bin/hive-3.2.1/bin/hive
show databases;

```


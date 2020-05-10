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

```
hive --service metastore
```




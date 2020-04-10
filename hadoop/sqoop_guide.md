## sqoop学习

1. ## 安装sqoop

   **[sqoop下载](http://sqoop.apache.org)**

   

2. ##  配置sqoop

   ```
   拷贝common-lang:common-lang.jar到/data/soft/sqoop-1.4.7/lib目录下.
   拷贝mysql-connector-java-5.1.43.jar到/data/soft/sqoop-1.4.7/lib目录下
   ```

   

3. ## sqoop的使用

   ```sql
   -- 列出服务器中的所有数据库
   sqoop list-databases --connect jdbc:mysql://127.0.0.1:3306 --username root --password manager
   
   -- 列出库中的所有表
   sqoop list-tables --connect jdbc:mysql://127.0.0.1:3306/cmwin --username root --password manager
   ```

   把mysql的数据导入到hdfs

   ```sql
   sqoop import --connect jdbc:mysql://127.0.0.1:3306/cmwin --username root --password manager --table dept --split-by deptno -m 1 --delete-target-dir --target-dir '/mysql/cmwin'
   ```

   

4. ## 待续

```xml
<property>
    <name>mapreduce.application.classpath</name>
    <value>
        /data/soft/hadoop-3.2.1/etc/hadoop,
        /data/soft/hadoop-3.2.1/share/hadoop/common/*,
        /data/soft/hadoop-3.2.1/share/hadoop/common/lib/*,
        /data/soft/hadoop-3.2.1/share/hadoop/hdfs/*,
        /data/soft/hadoop-3.2.1/share/hadoop/hdfs/lib/*,
        /data/soft/hadoop-3.2.1/share/hadoop/mapreduce/*,
        /data/soft/hadoop-3.2.1/share/hadoop/mapreduce/lib/*,
        /data/soft/hadoop-3.2.1/share/hadoop/yarn/*,
        /data/soft/hadoop-3.2.1/share/hadoop/yarn/lib/*
    </value>
</property>/

```


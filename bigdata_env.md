## 大数据实验环境的启动顺序

1. 关闭防火墙

2. 启动zookeeper[node03]

   ```bash
   /data/bin/zookeeper_cluster_start.sh
   /data/bin/zookeeper_cluster_stop.sh
   ```

3. 启动hadoop[node03]

   ```bash
   /data/bin/hadoop_cluster_start.sh
   /data/bin/hadoop_cluster_stop.sh
   ```

4. 启动mysql

5. 启动hive

6. 启动flink

7. 启动redis

8. 启动azkaban

## 服务的控制面板

| 服务名称   | url地址                           |      |
| ---------- | --------------------------------- | ---- |
| hadoop应用 | http://192.168.101.3:9870         |      |
| hadoop集群 | http://192.168.101.3:8088/cluster |      |
|            |                                   |      |



## CDH

1. 版本管理

2. 部署

3. 兼容性

4. 安全性

软件安装路径：/data/soft



大数据实验环境服务器配置

| 服务器地址     | ZK   | kafka | hadoop    | flink | hbase | mysql | redis | mongo | hive | sqoop | azkaban   |
| -------------- | ---- | ----- | --------- | ----- | ----- | ----- | ----- | ----- | ---- | ----- | --------- |
| 192.168.101.3  |      |       | 9870 8088 | 8081  |       | 3306  |       |       |      | Y     | 8082 8083 |
| 192.168.101.14 |      |       |           |       |       |       |       |       |      |       |           |
| 192.168.101.21 | 2181 | 9092  | datanode  |       |       |       |       |       |      |       |           |
| 192.168.101.22 | 2181 | 9092  | datanode  |       |       |       |       |       |      |       |           |
| 192.168.101.23 | 2181 | 9092  | datanode  |       |       |       |       |       |      |       |           |
|                |      |       |           |       |       |       |       |       |      |       |           |
|                |      |       |           |       |       |       |       |       |      |       |           |
|                |      |       |           |       |       |       |       |       |      |       |           |
|                |      |       |           |       |       |       |       |       |      |       |           |


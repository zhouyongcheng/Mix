# 用二进制包安装mysql
> download mysql  mysql-8.0.12-linux-glibc2.12-x86_64.tar.xz

## 错误解决
```
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/lib/mysql/mysql.sock' (2)

在/etc/my.cnf文件的[client]和[mysqld]节点下配置socket=/var/lib/mysql/mysql.sock
```

## copy my.cnf  /etc/my.cnf
--------------------------------
* linux的默认查找优先级
1)--default-files=/path/to/my.cnf
2)/etc/my.cnf
3)/etc/mysql/my.cnf
4)$MYSQL_HOME/my.cnf
--------------------------------

配置文件信息
----------------------------------------
````properties
# /etc/my.cnf

[client]
no-beep
port=3306
 
[mysql]
default-character-set=utf8
 
[mysqld]
port=3306
user=mysql
basedir="/data01/mysql"
datadir="/data01/mysql/data"
tmpdir="/data01/mysql/temp"
character-set-server=utf8
 
default-storage-engine=INNODB
sql-mode="STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
 
# General and Slow logging.
log-output=FILE
general-log=0
general_log_file="/data01/mysql/log/mysql-general.log"
slow-query-log=1
slow_query_log_file="/data01/mysql/log/mysql-slow.log"
long_query_time=10
log-error="/data01/mysql/log/mysql.err"
server-id=0
secure-file-priv="/data01/mysql/uploads"
 
#下面都是可选参数
max_connections=151
query_cache_size=0
table_open_cache=2000
tmp_table_size=40M
thread_cache_size=10
 
#*** MyISAM Specific options
myisam_max_sort_file_size=100G
myisam_sort_buffer_size=71M
key_buffer_size=8M
read_buffer_size=64K
read_rnd_buffer_size=256K
 
#*** INNODB Specific options ***
innodb_flush_log_at_trx_commit=1
innodb_log_buffer_size=1M
innodb_buffer_pool_size=8M
innodb_log_file_size=48M
innodb_thread_concurrency=9
innodb_autoextend_increment=64
innodb_buffer_pool_instances=8
innodb_concurrency_tickets=5000
innodb_old_blocks_time=1000
innodb_open_files=300
innodb_stats_on_metadata=0
innodb_file_per_table=1
innodb_checksum_algorithm=0
 
back_log=80
flush_time=0
join_buffer_size=256K
max_allowed_packet=4M
max_connect_errors=100
open_files_limit=4161
query_cache_type=0
sort_buffer_size=256K
table_definition_cache=1400
binlog_row_event_max_size=8K
sync_master_info=10000
sync_relay_log=10000
sync_relay_log_info=10000
````



## 安装mysql5.8


```properties

# 用root账号安装mysql
-------------------------------------
mkdir /data01/
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
cd /data01/
tar xvf mysql-version.tar.gz
mv mysql-version mysql
cd mysql
mkdir data log temp uploads
chown -R mysql .
chgrp -R mysql .
bin/mysqld --initialize --user=mysql
bin/mysql_ssl_rsa_setup
chown -R root .
chown -R  mysql data log temp uploads
bin/mysqld_safe --user=mysql &
cd /usr/local
ln -s /data01/mysql mysql
cp support-files/mysql.server /etc/init.d/
```

## 安装完成后的处理

```shell
bin/mysql -uroot -pxxxxx   (/data01/mysql/log/mysql.err temp password)
alter user ‘root’@’localhost’ identified by '123456';
alter user 'root'@'localhost' PASSWORD EXPIRE NEVER;
flush privileges;
cmwin@110!
```
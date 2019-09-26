1)下载mysql的zip版本,并解压到d:\mysql-5.7.17

2)编辑my.ini文件
#-----------------------------------begin--
[client]
no-beep
port=3306
 
[mysql]
default-character-set=utf8
 
[mysqld]
port=3306
basedir="D:/mysql-5.7.17"
datadir="D:/mysql-5.7.17/data"
tmpdir="D:/mysql-5.7.17/temp"
character-set-server=utf8
 
default-storage-engine=INNODB
sql-mode="STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
 
# General and Slow logging.
log-output=FILE
general-log=0
general_log_file="D:/mysql-5.7.17/log/mysql-general.log"
slow-query-log=1
slow_query_log_file="D:/mysql-5.7.17/log/mysql-slow.log"
long_query_time=10
 
log-error="D:/mysql-5.7.17/log/mysql.err"
 
server-id=0
secure-file-priv="D:/mysql-5.7.17/uploads"
 
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
#-----------------------------------my.ini end--


3）创建相应的目录
D:\mysql-5.7.17\data
D:\mysql-5.7.17\temp
D:\mysql-5.7.17\uploads

4)创建初始数据库
mysqld --defaults-file=d:\mysql-5.7.17\my.ini --initialize-insecure --console


* 默认配置文件的路径 (echo %WINDIR%)
1)%WINDIR%\my.ini
2)c:\my.ini
3)install_dir\my.ini

* linux的默认查找优先级
/etc/my.cnf
/etc/mysql/my.cnf
$MYSQL_HOME/my.cnf



5）添加或删除既存的windows服务
mysqld --install mysql --defaults-file=d:\mysql\my.ini
mysqld --remove mysql

6）修改root密码（初始密码为空）
mysql -uroot 
mysql>show databases;
mysql>use mysql;
mysql>update user set authentication_string=PASSWORD('123456') where User='root';
-------------------------------------------------------------------------
#版本小于5.7.6,执行下面的命令
mysql> UPDATE user SET password=PASSWORD('123456') WHERE user='root';
-------------------------------------------------------------------------
mysql> FLUSH PRIVILEGES;
mysql> quit

7）外网访问设定
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'mypassword' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.0.1' IDENTIFIED BY 'mypassword' WITH GRANT OPTION;


GRANT ALL PRIVILEGES ON *.* TO 'cmwin'@'10.67.31.174' IDENTIFIED BY 'manager' WITH GRANT OPTION;
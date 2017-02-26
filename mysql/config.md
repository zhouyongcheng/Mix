# mysql配置文件详解
#### 导语：
> [mysql](http://dev.mysql.com)是一个开源的数据库服务软件。为了方便用户的使用，
 mysql提供了通过配置文件[my.cnf]来为各种相关的进程提供配置。如mysql, mysqld等

## my.cnf的查找位置
* linux
> --default-files=/path/to/my.cnf
  /etc/my.cnf
  /etc/mysql/my.cnf
  $MYSQL_HOME/my.cnf
  ~/my.cnf

* windows
> %WINDIR%\my.ini  [**c:\windows**]
  c:\my.ini
  %MYSQL_HOME%\my.ini

## my.cnf的组织结构
```
[client]
	port = 3306
	socket = /data/mysql/3306/mysql.sock
[mysqld]
	port = 3306
	socket = /data/mysql/3306/mysql.sock
	key_buffer_size = 384M
	max_allowed_packet = 1M
	table_open_cache = 512
	sort_buffer_size = 2M
	read_buffer_size = 2M
	read_rnd_buffer_size = 8M
	myisam_sort_buffer_size = 64M
	thread_cache_size = 8
	query_cache_size = 32M
	thread_concurrency = 8

	log-bin = mysql.bin
	server-id = 1

[mysqldump]
	quick
	max_allowed_packet = 16M

[mysql]
	no-auto-rehash

[myisamchk]
	key_buffer_size = 256M
	sort_buffer_size = 256M
	read_buffer = 2M
	write_buffer = 2M

[mysqlhotcopy]
	interactive-timeout
```

## 日志文件管理
> 对mysql的错误日志，sql查询日志，慢执行sql日志，二进制日志等的配置管理。
log-output=table|file|none  控制日志的输出目的地

### 错误日志文件管理
> mysql的启动，关闭的信息也会被记录
log-error = /data/mysql/3306/logs/3306.err
log-warnings = false;

### 查询日志文件管理
* 慢查询日志 
>slow_query_log = 1
slow_query_log_file = /data/mysql/3306/logs/slow_query.log
long_query_time = 10S 
min_examined_row_limit = 0
log_short_format = 1
log_slow_admin_statements = 0;

* 普通查询日志
>general_log = 0
 general_log_file=/data/mysql/3306/logs/general.log

### 二进制日志文件
> 记录数据库中修改事件
 
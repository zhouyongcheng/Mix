## 常用命令

```mysql
# 登录命令
mysql -h 127.0.0.1 -P3306 -uroot -p

```

mysqls数据库服务的启动，停止，维护等都使用mysql用户进行。
#groupadd -g 33201 mysql
#useradd mysql -u 43201 -g mysql

创建数据库用的目录结构
mkdir -p /data/mysql/3306/data
mkdir -p /data/mysql/3306/tmp
mkdir -p /data/mysql/3306/binlog
mkdir -p /data/mysql/backup
mkdir -p /data/mysql/scripts

chown -R mysql:mysql /data/mysql

2)创建数据库的配置文件
-------------------------------
vi /data/mysql/3306/my.cnf
--------------------------------
[client]
port = 3306
socket = /data/mysql/3306/mysql.sock

[mysqld]
port = 3306
user = mysql
socket = /data/mysql/3306/mysql.sock
pid-file=/data/mysql/3306/mysql.pid
basedir=/usr/local/mysql
datadir=/data/mysql/3306/data
tmpdir=/data/mysql/33006/tmp
open_file_limit=10240
explicity_defaults_for_timestamp

default-storage-engine=INNODB
sql_mode="STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"

# Buffer
max_allowed_packet=256M
max_heap_table_size=256M
net_buffer_length=8K
sort_buffer_size=2M
join_buffer_size=4M
read_buffer_size=2M
read_rnd_buffer_size=16M

# Log
log-bin=/data/mysql/3306/binlog/mysql-bin
binlog_cache_size=32M
max_binlog_cache_size=512M
max_binlog_size=512M
binlog_format=mixed
log_output=FILE
log-error=../mysql-error.log
slow_query_log = 1
slow_query_log_file = ../slow_query.log
general_log = 0
general_log_file = ../general_query.log
expire-log-days = 14

# character
character_set_server=utf8
collation_server=utf8_general_ci

# *** INNODB Specific options ***
innodb_data_file_path=ibdata1:2048M:autoextend
innodb_log_file_size=256M
innodb_log_files_in_group=3
innodb_buffer_pool_size=1024M
innodb_flush_log_at_trx_commit=1
innodb_log_buffer_size=1M
innodb_thread_concurrency=9
innodb_autoextend_increment=64
innodb_buffer_pool_instances=8
innodb_concurrency_tickets=5000
innodb_old_blocks_time=1000
innodb_open_files=300
innodb_stats_on_metadata=0
innodb_file_per_table=1
innodb_checksum_algorithm=0

========================================
3)初始化数据库 (根据实际的mysql版本，安装数据库的方式可能不同)
$/usr/local/mysql/scripts/mysql_install_db --datadir=/data/mysql/3036/data --basedir=/usr/local/mysql

4）启动数据库服务
$mysql_safe --defaults-file=/data/mysql/3306/my.cnf &
查看进程是否正常启动,1.查看端口是否被分配 2.查看进程
$netstat -lnt | grep 3306
ps -ef | grep bin/mysql | grep -v grep

5)通过操作用户的数据字典表，修改用户的权限
select user, host from mysql.user;
删除不必要的账号，安全考虑
delete from mysql.user where (user, host) not in (select 'root', 'localhost');
update mysql.user set user='system', password=password('123456') where user='root';

6) vi /data/mysql/scripts/mysql_env.ini
chmod 600 /data/mysql/scripts/mysql_env.ini

7) vi /data/mysql/scripts/mysql_db_startup.sh
===============================================
#!/bin/sh
source /data/mysql/scripts/mysql_env.ini
echo "Startup MySql service: localhost_"${HOST_PORT}
/usr/local/bin/mysql -u${MYSQL_USER} -p${MYSQL_PASS} -S /data/mysql/${HOST_port}/mysql.sock $2

chmod +x /data/mysql/scripts/*.sh

echo "export PATH=/data/mysql/scripts:\$PATH" >> ~/.bash_profile
source ~/.bash_profile

# 删除数据库
drop database if exists db_name;

# 创建数据库
create database if not exists db_name default character set = utf8  collate = xxxx;

#查看mysql中创建的数据库
1) show databases;
2) select * from information_schema.schemata;

#创建用户(可以从任何一台机器链接访问，只能从指定的服务进行进行链接。)
create user cmwin identified by '123456';    
create user cmwin@'192.168.3.23' identified by 'cmwin@110!';

#创建用户并授权
grant select on myschema.* to cmwin identified by '123456';
grant select on myschema.* to cmwin@192.168.0.2 identified by '123456';
grant select on mysql.user to cmwin@192.168.0.2;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'cmwin110!' WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON cmwin.* to 'root'@'%' IDENTIFIED BY 'cmwin@110!' WITH GRANT OPTION;



#查看用户的授权
show grants for 'cmwin'@'192.168.0.2';
show grants;

#收回指定用户的权限
revoke select on mysql.user from 'cmwin'@'192.168.0.1';
revoke all privileges, grant options from user;

## 修改用户命名

```properties
 # 修改加密规则
ALTER USER 'cmwin'@'%' IDENTIFIED BY 'manager' PASSWORD EXPIRE NEVER;  
#更新一下用户的密码 
ALTER USER 'cmwin'@'%' IDENTIFIED WITH mysql_native_password BY 'manager'; 
# 刷新权限 
FLUSH PRIVILEGES;  
```


# 显示支持的字符集
show character set;
show collation like 'latin%';

# 查看mysql的系统变量
show variables like '%character%';

#设置mysql的系统变量
set global character_set_server=utf8;
set session character_set_server=utf8;

# 设置客户端连接使用的字符集。
set character_set_client=utf8;
set character_set_results=utf8;
#一次修改所有的客户端字符集相关内容。
set names utf8 collation utf8_general_ci;
set character set utf8;


#创建数据库是指定字符集
create database demodb character set utf8;
数据库级别的字符集设定，是放在了每个数据库目录下的db.opt下面。


#查看mysql支持的engine
show engines;

# 查看表的状态
show table status like 't_mytable'\G;

#forget password for mysql root user
* use system root accout do the following directive.
--------------------------------------------------------
* /etc/init.d/mysql.server stop
* cd /data01/mysql/bin
* ./mysqld_safe --skip-grant-tables &
* ./mysql -p
* mysql> update mysql.user set authentication_string=password('manager') where user='root' and host = 'localhost'
* mysql> flush privileges;
* mysql> quit;
* /etc/init.d/mysql.server stop
* /etc/init.d/mysql.server start
----------------------------------------------------


mysql> show warnings;













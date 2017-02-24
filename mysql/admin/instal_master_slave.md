# 最简单的复制集配置
- 关闭数据库服务
- 复制数据文件到slave的数据文件目录
  
  ```
  把datadir目录下面的所有内容复制到slave的datadir目录下。D:\mysql-5.7.17\data 复制一份到D:\mysql-5.7.17\3307下面。  
  确保master的配置文件：  
  [mysqld]
  log-bin=d:/mysql-5.7.17/log/mysql-bin
  server_id=112134
  在master上面创建slave能够连接到服务器的账号，并且有replication slave权限。
  grant replication slave on *.* to 'repl'@'slavehost' identified by 'password';
  ```

# 配置slave服务器
	vi /data/mysql/3307/my.cnf
	[mysqld]
	server_id=112135
	log-bin=/data/mysql/3307/log/mysql-bin


	-- 替换3306为3307
	sed -i 's/3306/3307/g' /data/mysql/3307/my.cnf
	rm /data/mysql/3307/auto.cnf

# 启动slave服务器
	service mysql start

# 配置slave连接到master
	mysql>change master to 
		master_home='192.168.0.1',
		master_port='3306',
		master_user='master',
		master_password='password',
		master_log_file='mysql-bin.000003',   // show master status中获取的值
		master_log_pos=120                    // show master status中获取的值

# 启动slave的服务
	mysql>start slave;
	mysql>show slave status;


# install mysql master最
# install mysql slave
# install java

# 用二进制包安装mysql
> 下面的操作用root账号进行操作。

* linux的默认查找优先级
1)--default-files=/path/to/my.cnf
2)/etc/my.cnf
3)/etc/mysql/my.cnf
4)$MYSQL_HOME/my.cnf


```
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
cd /data01/
tar zxvf mysql-version.tar.gz
mv mysql-version mysql
cd mysql
mkdir mysql-files
chown -R mysql .
chgrp -R mysql .
bin/mysqld --initialize --user=mysql
bin/mysql_ssl_rsa_setup
chown -R root .
chwon -R  mysql data mysql-files
bin/mysqld_safe --user=mysql &
```
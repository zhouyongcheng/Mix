-- 创建数据库的名称使用小写字母， 表名也使用小写字母。


drop [database | schema] if exists db_name;


create database cmwin character set utf8;


create table todo (
	todo varchar(40),
	done tinyint default 0,
	create_date date,
	create_user varchar(30)
) engine=innodb;	
create database cmwin character set utf8;

CREATE DATABASE cmwin DEFAULT CHARSET utf8 COLLATE utf8_general_ci;


create table todo (
	todo varchar(40),
	done tinyint default 0,
	create_date date,
	create_user varchar(30)
) engine=innodb;	


# EXECUTE SQL FILE
> ./mysql -uroot -p /home/cmwin/sql/create_tables.sql

mysql> show variables like 'low_case_table_names'
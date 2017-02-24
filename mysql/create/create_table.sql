create table my_table (name varchar(10)) engine=memory;
create table my_table (name varchar(10)) engine=innodb;
create table my_table (name varchar(10)) engine=myisam;
create table t_csv (id int not null default 0, v1 varchar(10) not null default '') engine=csv;
create table t_name engine=myisam as select * from other_table;
create table t_name engine=archive as select * from other_table;
create table t_name (age int, c char(10)) engine=blackhole;

create table t_name (age int, address char(10)) engine=myisam;
show table status like 't_name'\G;




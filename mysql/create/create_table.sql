## 表的创建
-- 可以在表中设置约束
-- 约束的设置：
--   1. 可以直接在列上面设置约束 not null等
--   2. 在表的定义末尾添加约束，primary key， foreign key等  


-- 不同的engine。
create table my_table (name varchar(10)) engine=memory;
create table my_table (name varchar(10)) engine=innodb;
create table my_table (name varchar(10)) engine=myisam;
create table t_csv (id int not null default 0, v1 varchar(10) not null default '') engine=csv;

-- 通过选择数据创建新表	
create table t_name engine=myisam as select * from other_table;
create table t_name engine=archive as select * from other_table;
create table t_name (age int, c char(10)) engine=blackhole;

create table t_name (age int, address char(10)) engine=myisam;
show table status like 't_name'\G;

create table shop (
	id char(2),
	name varchar(30),
	create_time date,
	duration int,
	primary key (id, name)   -- 复合主键
) engine=innodb;



-- 表的删除和更新
drop table  tb_name;    -- 删除的表是无法恢复的

-- 更新表结构的定义
alter table tb_name add column  address varchar(40);
alter table tb_name drop column duration;

-- 向表中插入数据
begin transaction;    --sqlserver
start transaction;    --mysql
insert into tb_name (id, name) values ('01', 'name01');
commit;



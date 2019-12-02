-- count中的参数如果是列名，如果该列有Null值，则null值这行不会统计。
-- 只有select, having, order by子句中才可以使用聚合函数。
-- having : 常数，聚合函数，group by 中的列名。
select count(*) from tb_name;
select count(col_nam) from tb_name;
select count(distinct col_name) from tb_name;
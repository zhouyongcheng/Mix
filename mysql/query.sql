--sqlserver get 【2019-12-26 23:59:59.003】时间格式。
select top 1 CONVERT(DATETIME,CONVERT (VARCHAR, GETDATE(), 112),112) + 1 - 1.0 / 3600 / 24 from table_name


-- count中的参数如果是列名，如果该列有Null值，则null值这行不会统计。
-- 只有select, having, order by子句中才可以使用聚合函数。
-- having : 常数，聚合函数，group by 中的列名。
select count(*) from tb_name;
select count(col_nam) from tb_name;
select count(distinct col_name) from tb_name;


select 
   name,
   sum(price)
from product
group by rollup(name)   


-- 获取在指定时间周期内的合法日期，小于当前日期的最大日期，或者大于当前日期的最小日期的记录。
-- 1： 通过在基础表中增加按小于或者大于当前日期的数据分割成对应0，1的记录， 如果有0的，选择0这部分的记录。
-- 2： 计算和当前日期差值的绝对值，取绝对值最小的记录。
-- 3: 优点：逻辑清晰，查询简单， 缺点：使用函数后，会导致索引失效。

select *
FROM (
         select ROW_NUMBER() OVER (PARTITION BY STORE_CODE ORDER BY priorityOrder,DIFF) AS RN, o.*
         FROM (select *,
                      case
                          when isnull(EFFECT_DAY_WITH_START, '1900-01-01') <= :nowDate then 0
                          else 1 end as priorityOrder,
                      ABS(datediff(DAY, ISNULL(EFFECT_DAY_WITH_START, '1900-01-01'), :nowDate)) DIFF
               from T_D_STORE_MENU_INFO
               where (del_flag is null or del_flag = 'N')
                   AND PRICE_TYPE_CODE is not null
                   and ISNULL(EFFECT_DAY_WITH_END, '2099-12-31') >= :nowDate
              ) o
     ) SP
WHERE SP.RN = 1

-- 方式2： 可以比较两种查询的效率。主要是先理解解题的思路。
-- 1： 按当前日期把记录分成2部分，获取靠近当前日期的最大值和最小值， max（value），min（value）
-- 2： 对同一组按日期由小到大进行编号，然后获取编号最小的记录。找到目标记录。
-- 3： 然后用目标记录关联到原始记录。
SELECT T.STORE_CODE,
       T.STORE_EXT_ATTR_ID,
       T.MAXVDAY
FROM (
         SELECT T.STORE_CODE,
                T.STORE_EXT_ATTR_ID,
                T.MAXVDAY,
                ROW_NUMBER() OVER (PARTITION BY STORE_CODE, STORE_EXT_ATTR_ID ORDER BY MAXVDAY) RN
         FROM (
                  SELECT STORE_CODE,
                         STORE_EXT_ATTR_ID,
                         MAX(VALIDATE_DAY) AS MAXVDAY
                  FROM T_D_STORE_EXT_ATTRIBUTE_VALUE
                  WHERE STORE_CODE = 'ABX001'
                    AND VALIDATE_DAY < (
                          CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 112), 112) + 1 - 1.0 / 3600 / 24)
                  GROUP BY STORE_CODE, STORE_EXT_ATTR_ID
                  UNION ALL
                  SELECT STORE_CODE,
                         STORE_EXT_ATTR_ID,
                         MIN(VALIDATE_DAY) AS MAXVDAY
                  FROM T_D_STORE_EXT_ATTRIBUTE_VALUE
                  WHERE STORE_CODE = 'ABX001'
                    AND VALIDATE_DAY > (CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 112), 112) + 1 - 1.0 / 3600 / 24)
                  GROUP BY STORE_CODE, STORE_EXT_ATTR_ID
              ) T
     ) T
WHERE T.RN = 1

# 修改数据库的配置，触发job的执行。
```
1. 备份qrtz_cron_triggers表的修改记录
2. 备份qrtz_triggers表对应的记录
3.更改表qrtz_cron_triggers的cronExpression
4.将表qrtz_triggers的NEXT_FIRE_TIME和PREV_FIRE_TIME的值改为0
5.还原备份记录
```

## 清除trigger，然后重新从配置文件存入数据库
```sql
select * from mnct.QRTZ_CRON_TRIGGERS 
select * from mnct.QRTZ_TRIGGERS
select * from mnct.QRTZ_JOB_DETAILS
```
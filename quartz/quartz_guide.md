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

1） 修改spring-jobs.xml的cron表达式，找到dailyTrigger17进行修改
2）执行下面两个更新语句
update MNCT.QRTZ_CRON_TRIGGERS SET CRON_EXPRESSION = '0/20 * * * * ?' WHERE TRIGGER_NAME = 'dailyTrigger17';
update MNCT.QRTZ_TRIGGERS SET PREV_FIRE_TIME = 0, NEXT_FIRE_TIME = 0 WHERE TRIGGER_NAME = 'dailyTrigger17';
3）重新启动服务
```

```mssql
1） 修改spring-jobs.xml的cron表达式
# 待售罄数据生成2点执行
dailyTrigger23:   0 0 2 * * ?
# 锁定循环断货或者自动恢复3:20执行
dailyTrigger68:   0 20 3 * * ?

2）执行下面两个更新语句
update MNCT.QRTZ_CRON_TRIGGERS SET CRON_EXPRESSION = '0 0 2 * * ?' WHERE TRIGGER_NAME = 'dailyTrigger23';
update MNCT.QRTZ_TRIGGERS SET PREV_FIRE_TIME = 0, NEXT_FIRE_TIME = 0 WHERE TRIGGER_NAME = 'dailyTrigger23';
update MNCT.QRTZ_CRON_TRIGGERS SET CRON_EXPRESSION = '0 20 3 * * ?' WHERE TRIGGER_NAME = 'dailyTrigger68';
update MNCT.QRTZ_TRIGGERS SET PREV_FIRE_TIME = 0, NEXT_FIRE_TIME = 0 WHERE TRIGGER_NAME = 'dailyTrigger68';

update MNCT.QRTZ_TRIGGERS SET PREV_FIRE_TIME = 1597867200000, NEXT_FIRE_TIME = 0 WHERE TRIGGER_NAME = 'dailyTrigger23';



3）重新启动服务
```


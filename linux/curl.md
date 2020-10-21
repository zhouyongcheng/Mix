# curl使用

## 基本使用
```
curl "http://localhost:8080/message"
```

curl "http://localhost:8070/jobhandler/genSellOutData" &

grep '生成当前餐厅的task列表数据' log/log-info_20201008.log | wc -l

grep 'task保持到数据库用时' log/log-info_20201008.log > db_2.txt


tail -f log/log-info_20201009.log | grep '数据库'


T_D_STORE_SELL_OUT_WHITELIST


curl "http://localhost:8070/datasync/view2" &


select * from mcsell.t_b_task_active_table tbtat ;
select count(*) from mcsell.t_d_product_sell_out_task;
select count(*) from mcsell.t_d_product_sell_out_task_1;
select count(*) from mcsell.t_d_product_sell_out_task_2;



grep 'kafka生成task信息发生异常' log/log-info_20201020.log


task1： 26852496

数据库监控检查及降级开关
http://localhost/jobhandler/databaseAvailability

数据库恢复正常后，恢复各个消费者。
http://localhost/jobhandler/recoveryConsumer
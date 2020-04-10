# hive构建

操作用户: 非root用户进行hive的安装,配置,起动.

[hive3.1.2安装](https://blog.csdn.net/weixin_43824520/article/details/100580557)

## 问题点
1. 启动hive报which : no hbase in
  在hive/lib目录中添加mysql的java驱动.
2. com.google.common.base.Preconditions.checkArgument
  hadoop和hive的lib目录中,比较那个guava版本高,就用谁的覆盖.



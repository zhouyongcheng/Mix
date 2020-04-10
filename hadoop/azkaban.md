## 安装准备

1. Azkaban官网: https://azkaban.github.io
2. 软件下载地址: https://github.com/azkaban/azkaban
3. 官方插件地址: https://github.com/azkaban/azkaban-plugins
4. 官方文档地址: http://azkaban.github.io/azkaban/docs/latest



```shell
# Build Azkaban
./gradlew build

# Clean the build
./gradlew clean

# Build and install distributions
./gradlew installDist

# Run tests
./gradlew test

# Build without running tests
./gradlew build -x test
```

## 创建mysql数据库

```mysql
1) 以 root 用户登录mysql
2) CREATE DATABASE azkaban;
3  CREATE USER 'azkaban'@'%' IDENTIFIED BY 'azkaban';
4) GRANT SELECT,INSERT,UPDATE,DELETE ON azkaban.* to 'azkaban'@'%' WITH GRANT OPTION;
5) flush privileges;
6) use azkaban;
7) source /home/azkaban/db/create-all-sql-3.0.0.sql
```



## 安装executor和Web

1. /data/soft/azkaban-web

   ```properties
   # Azkaban Personalization Settings
   azkaban.name=Test
   azkaban.label=My Local Azkaban
   azkaban.color=#FF3601
   azkaban.default.servlet.path=/index
   web.resource.dir=web/
   default.timezone.id=Asia/Shanghai
   # Azkaban UserManager class
   user.manager.class=azkaban.user.XmlUserManager
   user.manager.xml.file=conf/azkaban-users.xml
   # Loader for projects
   executor.global.properties=conf/global.properties
   azkaban.project.dir=projects
   # Velocity dev mode
   velocity.dev.mode=false
   # Azkaban Jetty server properties.
   jetty.use.ssl=false
   jetty.ssl.port=8443
   jetty.keystore=keystore
   jetty.password=123456
   jetty.keypassword=123456
   jetty.truststore=keystore
   jetty.trustpassword=123456
   jetty.maxThreads=25
   jetty.port=8082
   # Azkaban Executor settings
   # mail settings
   mail.sender=
   mail.host=
   # User facing web server configurations used to construct the user facing server URLs. They are useful when there is a reverse proxy between Azkaban web servers and users.
   # enduser -> myazkabanhost:443 -> proxy -> localhost:8081
   # when this parameters set then these parameters are used to generate email links.
   # if these parameters are not set then jetty.hostname, and jetty.port(if ssl configured jetty.ssl.port) are used.
   # azkaban.webserver.external_hostname=myazkabanhost.com
   # azkaban.webserver.external_ssl_port=443
   # azkaban.webserver.external_port=8081
   job.failure.email=
   job.success.email=
   lockdown.create.projects=false
   cache.directory=cache
   # JMX stats
   jetty.connector.stats=true
   executor.connector.stats=true
   # Azkaban mysql settings by default. Users should configure their own username and password.
   database.type=mysql
   mysql.port=3306
   mysql.host=192.168.101.3
   mysql.database=azkaban
   mysql.user=azkaban
   mysql.password=azkaban
   mysql.numconnections=100
   #Multiple Executor
   azkaban.use.multiple.executors=true
   #azkaban.executorselector.filters=StaticRemainingFlowSize,MinimumFreeMemory,CpuStatus
   azkaban.executorselector.filters=StaticRemainingFlowSize,CpuStatus
   azkaban.executorselector.comparator.NumberOfAssignedFlowComparator=1
   azkaban.executorselector.comparator.Memory=1
   azkaban.executorselector.comparator.LastDispatched=1
   azkaban.executorselector.comparator.CpuUsage=1
   ```

   

2. /data/soft/azkaban-exec

   ```properties
   # Azkaban Personalization Settings
   azkaban.name=Test
   azkaban.label=My Local Azkaban
   azkaban.color=#FF3601
   azkaban.default.servlet.path=/index
   web.resource.dir=web/
   default.timezone.id=Asia/Shanghai
   # Azkaban UserManager class
   user.manager.class=azkaban.user.XmlUserManager
   user.manager.xml.file=conf/azkaban-users.xml
   # Loader for projects
   executor.global.properties=conf/global.properties
   azkaban.project.dir=projects
   # Velocity dev mode
   velocity.dev.mode=false
   # Azkaban Jetty server properties.
   jetty.use.ssl=false
   jetty.maxThreads=25
   jetty.port=8082
   # Where the Azkaban web server is located
   azkaban.webserver.url=http://node03:8082
   # mail settings
   mail.sender=
   mail.host=
   # User facing web server configurations used to construct the user facing server URLs. They are useful when there is a reverse proxy between Azkaban web servers and users.
   # enduser -> myazkabanhost:443 -> proxy -> localhost:8081
   # when this parameters set then these parameters are used to generate email links.
   # if these parameters are not set then jetty.hostname, and jetty.port(if ssl configured jetty.ssl.port) are used.
   # azkaban.webserver.external_hostname=myazkabanhost.com
   # azkaban.webserver.external_ssl_port=443
   # azkaban.webserver.external_port=8081
   job.failure.email=
   job.success.email=
   lockdown.create.projects=false
   cache.directory=cache
   # JMX stats
   jetty.connector.stats=true
   executor.connector.stats=true
   # Azkaban plugin settings
   azkaban.jobtype.plugin.dir=/data/soft/azkaban-exec/plugins/jobtypes
   # Azkaban mysql settings by default. Users should configure their own username and password.
   database.type=mysql
   mysql.port=3306
   mysql.host=192.168.101.3
   mysql.database=azkaban
   mysql.user=azkaban
   mysql.password=azkaban
   mysql.numconnections=100
   # Azkaban Executor settings
   executor.port=12321
   executor.maxThreads=50
   executor.flow.threads=30
   ```

   

## 启动服务

1. 先启动azkaban-exec

2. 新版本默认不会激活executor的,需要先激活在开启azkaban-web.

   curl http://192.168.101.3:12321/executor?action=activate

3. 启动azkaban-web

4. 如果azkaban-exec的配置修改后,要重新启动web



## 更新executors表

```mysql
insert into executors (host, port, active) values ('node21', 12321, 1);
insert into executors (host, port, active) values ('node22', 12321, 1);
update azkaban.executors set active=1;
select * from executors;
curl http://192.168.101.3:12321/executor?action=activate
```






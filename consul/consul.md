## 启动consul

```kotlin
./consul agent -server  -bootstrap-expect 1 -ui -data-dir /tmp/consul -bind=172.16.10.243

./consul agent -server -ui -bootstrap-expect=1 -client=0.0.0.0 -bind=172.16.10.243 -data-dir=./consul_data -config-dir=./config  -node=consul_master --enable-script-checks=true
```





```
server.port=8092

spring.application.name=monitor

management.endpoints.web.exposure.include = prometheus,health
management.endpoints.web.base-path = /
management.endpoints.web.path-mapping.prometheus = actuator
management.endpoints.jmx.exposure.exclude = *
management.endpoint.health.show-details = never
management.endpoint.prometheus.enabled = true
management.metrics.export.prometheus.enabled = true
management.metrics.export.prometheus.step = 5s
management.metrics.export.prometheus.descriptions = false
prometheus.metric-expire = 30

consul.agents = localhost
consul.port = 8500
consul.heartbeat-interval = 30000
consul.service.prefer-ip-address = true
consul.service.health-check-interval = 30s
consul.service.health-check-timeout = 10s
consul.service.deregister-after-critical-for = 24h


spring.datasource.name=dsMcSellout
spring.datasource.type=com.alibaba.druid.pool.DruidDataSource
spring.datasource.driver-class-name=org.mariadb.jdbc.Driver
spring.datasource.url=jdbc:mariadb://172.25.216.34:3306/mcsell?serverTimezone=Asia/Shanghai&characterEncoding=utf8&useSSL=false
spring.datasource.username=root
spring.datasource.password=123456
spring.datasource.druid.filters=stat,wall
spring.datasource.druid.use-global-data-source-stat=true
spring.datasource.druid.initial-size=10
spring.datasource.druid.max-active=20
spring.datasource.druid.min-idle=10
spring.datasource.druid.max-wait=60000
spring.datasource.druid.time-between-eviction-runs-millis=60000
spring.datasource.druid.min-evictable-idle-time-millis=300000
spring.datasource.druid.max-evictable-idle-time-millis=900000
spring.datasource.druid.test-while-idle=true
spring.datasource.druid.test-on-borrow=false
spring.datasource.druid.test-on-return=false
spring.datasource.druid.validation-query=SELECT 1
spring.datasource.druid.validation-query-timeout=2000
spring.datasource.druid.pool-prepared-statements=true
spring.datasource.druid.maxPoolPreparedStatementPerConnectionSize=20
```

## docker 运行prometheus

```
docker run -d -p 9090:9090 \
    -v /data/config/prometheus.yml:/etc/prometheus/prometheus.yml \
    prom/prometheus
```



```
server.port=8092

spring.profiles.active=qa

spring.application.name=monitor

management.endpoints.web.exposure.include=health,info,metrics,prometheus
management.endpoints.web.base-path=/prometheus
management.endpoints.web.path-mapping.prometheus=actuator
management.endpoints.jmx.exposure.exclude=*
# endpoint
management.endpoint.health.show-details = never
management.endpoint.metrics.enabled=true
management.endpoint.prometheus.enabled=true
management.metrics.export.prometheus.enabled=true
management.metrics.export.prometheus.step=5s
management.metrics.export.prometheus.descriptions=false
prometheus.metric-expire=30

consul.agents = sellout-consul-pod.sellout
consul.port = 8500
consul.heartbeat-interval = 30000
consul.service.prefer-ip-address = true
consul.service.health-check-interval = 30s
consul.service.health-check-timeout = 10s
consul.service.deregister-after-critical-for = 24h

```



## 安装prometheus

```
https://kifarunix.com/install-and-setup-prometheus-on-ubuntu-20-04/
```



## 启动prometheus

```
prometheus --config.file=/etc/prometheus/prometheus.yml
```


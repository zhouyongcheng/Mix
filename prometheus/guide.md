```
https://www.cnblogs.com/xidianzxm/p/11542135.html
https://developer.ibm.com/languages/java/tutorials/monitor-spring-boot-microservices/
```



```java
Gauge.builder("humidity", humidity, humidity -> sensorReading.getHumidity()).strongReference(true).register(Metrics.globalRegistry);
```



## prometheus配置

```yaml
# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'
    metrics_path: '/metrics'
    static_configs:
    - targets: ['localhost:9090']

  - job_name: 'consul-prometheus'
    metrics_path: 'prometheus'
    params:
        format: ['prometheus']
    consul_sd_configs:
      - server:   '172.16.10.243:8500'
        services: []
    relabel_configs:
      - source_labels: ['__meta_consul_service']
        regex:  .*sellout.*
        action:  keep
~                        
```

## promethus配在方式2

```yaml
- job_name: 'application'
    scrape_interval: 5s
    metrics_path: '/actuator/prometheus'
    file_sd_configs:
      - files: ['/usr/local/prometheus/groups/applicationgroups/*.json']
      
# 配置文件的详细信息。   
$ vim groups/applicationgroups/application.json
[
    {
        "targets": [
            "192.168.1.124:8088"
        ],
        "labels": {
            "instance": "springboot2-prometheus",
            "service": "springboot2-prometheus-service"
        }
    }
]      
```



## grafana的启动

```
docker run -d -p 3000:3000 --name=grafana grafana/grafana
```


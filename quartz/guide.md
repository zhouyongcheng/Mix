## trigger公共属性
* startTime: trigger生效的开始时间
* endTime: trigger有效期的终止时间
* misfire: 如果scheduler关闭了，或者Quartz线程池中没有可用的线程来执行job,错过触发点
* calendar: 日历配置


## warning
 * 不要在单独的机器上运行Clustering
 * 不要针对任何其他实例运行的相同的一组表来启动非群集实例。您可能会收到严重的数据损坏，一定会遇到不正常的行为。
 * same datasource, running same cluster quartz, no shared for other cluster or standalone instance.


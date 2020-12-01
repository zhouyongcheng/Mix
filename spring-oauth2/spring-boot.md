https://github.com/heibaiying/spring-samples-for-all

https://www.jianshu.com/u/f1c47972d390

## SpringBoot2全局事务配置

```java
/**
 *  注意事项：在service的方法中，如果捕获并处理了异常，则事务会失效。（Exception导致回滚，被捕获后，回滚失效）
 */
@Aspect
@Configuration
@EnableTransactionManagement
public class TransactionAdviceConfig {

    private static final String AOP_POINTCUT_EXPRESSION = "execution (* com.cmwin.demo..*Service*.*(..))";

    private PlatformTransactionManager transactionManager;

    public TransactionAdviceConfig(PlatformTransactionManager transactionManager) {
        this.transactionManager = transactionManager;
    }

    @Bean
    public TransactionInterceptor txAdvice() {
        // 更新操作（insert, update, delete)
        DefaultTransactionAttribute txAttr_REQUIRED = new DefaultTransactionAttribute();
        txAttr_REQUIRED.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
        // 只读
        DefaultTransactionAttribute txAttr_REQUIRED_READONLY = new DefaultTransactionAttribute();
        txAttr_REQUIRED_READONLY.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
        txAttr_REQUIRED_READONLY.setReadOnly(true);
        // 根据方法名称的不同，选择不同的事务隔离级别。
        // 更新操作
        NameMatchTransactionAttributeSource source = new NameMatchTransactionAttributeSource();
        source.addTransactionalMethod("add*", txAttr_REQUIRED);
        source.addTransactionalMethod("save*", txAttr_REQUIRED);
        source.addTransactionalMethod("delete*", txAttr_REQUIRED);
        source.addTransactionalMethod("update*", txAttr_REQUIRED);
        source.addTransactionalMethod("exec*", txAttr_REQUIRED);
        source.addTransactionalMethod("set*", txAttr_REQUIRED);

        // 查询操作
        source.addTransactionalMethod("get*", txAttr_REQUIRED_READONLY);
        source.addTransactionalMethod("query*", txAttr_REQUIRED_READONLY);
        source.addTransactionalMethod("find*", txAttr_REQUIRED_READONLY);
        source.addTransactionalMethod("list*", txAttr_REQUIRED_READONLY);
        source.addTransactionalMethod("count*", txAttr_REQUIRED_READONLY);
        source.addTransactionalMethod("is*", txAttr_REQUIRED_READONLY);
        return new TransactionInterceptor(transactionManager, source);
    }

    @Bean
    public Advisor txAdviceAdvisor() {
        AspectJExpressionPointcut pointcut = new AspectJExpressionPointcut();
        pointcut.setExpression(AOP_POINTCUT_EXPRESSION);
        return new DefaultPointcutAdvisor(pointcut, txAdvice());
    }
}
```



### swagger配置

#### 依赖包 

```xml
<dependency>
	<groupId>io.springfox</groupId>
	<artifactId>springfox-boot-starter</artifactId>
	<version>3.0.0</version>
</dependency>
```

#### java配置

```java
@Configuration
@EnableOpenApi
public class SwaggerConfig {

    @Bean
    public Docket api() {
        return new Docket(DocumentationType.OAS_30)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.basePackage("cn.cmwin.amy.demo.controller"))
                .paths(PathSelectors.any())
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("基于Swagger3.0.0的接口文档")
                .description("api信息列表")
                .version("2.0")
                .contact(new Contact("cmwin", "http://www.baidu.com", "123456@qq.com"))
                .build();
    }
}
```





## springboot配置

### 	独立的配置文件方式

```java
@Component
@PropertySource("classpath:my.properties")
@ConfigurationProperties(prefix = "user")
public class MyConfig {
    private String username;
    private String password;
}

# my.properties
user.username=demo
user.password=123456    
```

### 在application配置文件中配置

```java
@Data
@Component
@ConfigurationProperties(prefix = "zookeeper")
public class ZookeeperConfigurer {
    /** 尝试次数 */
    private int retryCount;

    /** 重试间隔时间 */
    private int elapsedTimeMs;

    /** session超时时间 */
    private int sessionTimeoutMs;

    /** 连接超时时间 */
    private int connectionTimeoutMs;

    /** zookeeper集群地址 */
    private String servers;

    /** zookeeper分布式锁跟路径 */
    private String lockPath;
}

```




## 使用了 Eureka 就自动具有了注册中心、负载均衡、故障转移的功能

Hystrix 会在某个服务连续调用 N 次不响应的情况下，立即通知调用端调用失败，避免调用端持续等待而影响了整体服务。Hystrix 间隔时间会再次检查此服务，如果服务恢复将继续提供服务

熔断的监控现在有两款工具：Hystrix-dashboard 和 Turbine


## Spring Cloud Config
```
Spring Cloud Config 是一个解决分布式系统的配置管理方案。它包含了 Client 和 Server 两个部分，Server 提供配置文件的存储、以接口的形式将配置文件的内容提供出去，Client 通过接口获取数据、并依据此数据初始化自己的应用。

如果服务运行期间改变配置文件，服务是不会得到最新的配置信息，需要解决这个问题就需要引入 Refresh。可以在服务的运行期间重新加载配置文件，具体可以参考这篇文章：配置中心 svn 示例和 refresh

生产中建议对配置中心做集群，来支持配置中心高可用性
```


```
1)服务注册：在服务治理框架中，通常都会构建一个注册中心，每个服务单元向注册中心登记自己提供的服务，将主机与端口号、版本号、通信协议等一些附加信息告知注册中心，注册中心按照服务名分类组织服务清单，服务注册中心还需要以心跳的方式去监控清单中的服务是否可用，若不可用需要从服务清单中剔除，达到排除故障服务的效果。

2) 服务发现：由于在服务治理框架下运行，服务间的调用不再通过指定具体的实例地址来实现，而是通过向服务名发起请求调用实现。
```

```
基于 Service Consumer 获取到的服务实例信息，我们就可以进行服务调用了。而 Spring Cloud 也为 Service Consumer 提供了丰富的服务调用工具：

Ribbon，实现客户端的负载均衡。
Hystrix，断路器。
Feign，RESTful Web Service 客户端，整合了 Ribbon 和 Hystrix。
```

## 服务调用端负载均衡 ——Ribbon
* Ribbon 工作时会做四件事情：
1. 优先选择在同一个 Zone 且负载较少的 Eureka Server；
2. 定期从 Eureka 更新并过滤服务实例列表；
3. 根据用户指定的策略，在从 Server 取到的服务注册列表中选择一个实例的地址；
4. 通过 RestClient 进行服务调用。


## 服务调用端熔断 ——Hystrix
```
服务雪崩效应是一种因 “服务提供者” 的不可用导致 “服务消费者” 的不可用，并将不可用逐渐放大的过程。
Netflix 创建了一个名为 Hystrix 的库，实现了断路器的模式。“断路器” 本身是一种开关装置，
当某个服务单元发生故障之后，通过断路器的故障监控（类似熔断保险丝），向调用方返回一个符合预期的
、可处理的备选响应（FallBack），而不是长时间的等待或者抛出调用方无法处理的异常，这样就保证了服
务调用方的线程不会被长时间、不必要地占用，从而避免了故障在分布式系统中的蔓延，乃至雪崩。
```


## 服务调用端代码抽象和封装 ——Feign
```
Feign 具有如下特性：

可插拔的注解支持，包括 Feign 注解和 JAX-RS 注解
支持可插拔的 HTTP 编码器和解码器
支持 Hystrix 和它的 Fallback
支持 Ribbon 的负载均衡
支持 HTTP 请求和响应的压缩
```


## 注意事项
```
1. 在搭建 Eureka Server 双节点或集群的时候，要把 eureka.client.register-with-eureka 和
 eureka.client.fetch-registry 均改为 true（默认）。否则会出现实例列表为空，且 peer2 不在 available-replicas 而在 unavailable-replicas 的情况（这时其实只是启动了两个单点实例）。如
 果是像我这样图省事把之前的单节点配置和双节点的配置放在一个工程里，双节点的配置里要显示设置以上
 两个参数，直接删除是用不了默认配置的 ——Spring profile 会继承未在子配置里设置的父配置（application.yml）中的配置。

2. 在注册的时候，配置文件中的 spring.application.name
```

## Eureka 集群使用
```

```


## 针对造成服务雪崩的不同原因，可以使用不同的应对策略:
1. 流量控制
    * 网关限流 (Nginx+Lua 的网关进行流量控制)
    * 用户交互限流
    * 关闭重试
    * 采用加载动画，提高用户的忍耐等待时间
    * 提交按钮添加强制等待时间机制
2. 改进缓存模式
3. 服务自动扩容
4. 服务调用者降级服务
    * 资源隔离
    * 对依赖服务进行分类
      1. 强依赖:核心业务依赖
      2. 弱依赖: 不会导致业务终止的依赖
    * 不可用服务的调用快速失败
    * 服务降级(fallback)
    ```
    服务调用方: 对于查询操作，我们可以实现一个 fallback方法，当请求后端服务出现异常的时候，
    可以使用 fallback 方法返回的值。fallback 方法的返回值一般是设置的默认值或者来自缓存。
    熔断只是作用在服务调用这一端
    ```
https://www.
.com/u/f1c47972d390

## 导入xml定义的bean
```java
@ImportResource(value = "{classpath:spring_ftp.xml}")
public class AppConfig {

    @Value("${http.url:http://localhost:8080}")   // 参数值和默认值的配置方式
    private String url;
}
```


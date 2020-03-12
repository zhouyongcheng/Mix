## 使用oauth2保护你的应用，可以分为简易的分为三个步骤
* 配置资源服务器
* 配置认证服务器
* 配置spring security

##  注意事项
* 各个客户端应用都需要在服务提供商的认证服务器上进行注册，获取相应的client_id, client_secret, 客户端调用的时候，需要提供这些信息。

认证服务器进行用户的认证及令牌的发放。
资源服务器需要验证请求的令牌的有效性。
认证服务器和资源服务器的令牌发放和认证的协议必须一致，如何保障的？
授权码模式的同意授权是在服务提供商的认证服务器上进行的。
其他模式的同意授权是在第3方应用上进行的，比如密码模式（第3方应用有用户的密码，说明已经获取了授权信息）


## 业务流程
* 资源拥有者（ResourceOwner)访问第3方应用。
* 第3方应用请求资源拥有者进行授权
（调用授权服务器的授权端口，获取授权码，其中有用户认证的过程，授权服务器保存第3方应用的接受授权码的访问地址，然后重定向到第3方指定的地址）
* 第3方应用获取授权码后，拿授权码+客户端ID+客户端密码去获取请求的token。
  （在第3方的应用的服务器后台进行，用户是不可见的，保证令牌的安全性）
* 第3方应用使用获取的token去请求访问的资源。
  （资源服务器会对请求的token进行交易（有效性，访问范围等？）验证通过，提供资源。

## 代码重写的内容
1）AthenticationSuccessHandler
2）AuthenticationFailureHandler
3) WhitelabelApprovalEndpoint
4) FilterSecurityInterceptor
5) ExceptionTranslationFilter
6) AnonymousAuthenticationFilter




# oauth2根据使用场景不同，分成了4种模式
* 授权码模式（authorization code）
* 简化模式（implicit）
* 密码模式（resource owner password credentials）
* 客户端模式（client credentials）

## 安全需求
* 验证方法自定义
* 登录页面自定义
* 定义哪些方法需要安全验证，哪些方法不需要。
* 


# 详细
传统：在配置类中添加@EnableWebSecurity注解，就可以驱动SpringSecurity的功能。
springboot中： 引入下面的依赖包，就可以驱动SpringSecurity的功能。
```xml
<dependency>
<groupid>org.springframework.boot</groupid>
<artifactid>spring-boot-starter-security</artifactid>
</dependency>
```

创建的默认用户和密码:  user/xxx(控制台输出的密码)

## WebSecurityConfigurerAdapter方法，实现对SpringSecurity的配置。
```java
/**
* 用来配置用户签名服务，主要是user-details 机制，你还可以给予用户赋予角色
* @param auth 签名管理器构造器， 用于构建用户具体权限控制
*/
protected 飞roid configure (AuthenticationManagerBuilder auth );

/**
 * 用来配置Filter
 * param web Spring Web Secur 工ty 对象
 */
public 飞roid configure (WebSecurity web) ;

/**
 * 用来配置拦截保护的请求，比如什么请求放行，什么请求需要验证
 * ＠ param http http 安全请求对象
 */
protected void configure (HttpSecurity http) throws Exception ;

```

源码解读
* TokenEndpoint.java
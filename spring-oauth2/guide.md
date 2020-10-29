# spring oauth2学习笔记

http://localhost:7777/oauth/authorize?response_type=code&client_id=gateway&redirect_uri=http://localhost:8082/callback&scope=all


http://localhost:5555/uaa/oauth/authorize?response_type=code&client_id=menuCenter&redirect_uri=http://127.0.0.1:5555/login&scope=all


[Spring Security 小知识点](https://blog.csdn.net/xichenguan/article/details/78091567)

[spring-cloud-demo](https://github.com/piomin/sample-spring-microservices-new)

[spring-oauth资源] (https://www.baeldung.com/spring-security-oauth-jwt)

## 系统安全

* 用户： 一堆可以进行的[行为集合]。

```properties
可见的菜单
可用的功能（页面的功能按钮，查看、新增、修改、删除、审核等）
数据权限： 同一个页面上看到的数据不相同。解决方案一般是把数据和具体的组织架构关联起来
可写的数据。
```

* 权限： 可以访问的资源。
* 授权： 给用户授予访问某个资源的能力。
* 



## 安全问题

```
1. 对外提供的api访问的安全控制
2. 做为api的客户端的安全控制
```

## 问题点
```
scope是如何进行设定的，如何使用？有什么功能。  
refresh_token的使用场景
token持久化的作用什么？为什么要把token存入到数据库或者redis？
服务器启动的时候,先启动授权服务器,然后在启动资源服务器.
认证服务器挂了,但已经获取正常token的客户端还是能够通过token访问资源服务器的资源.因为资源服务器能够正常的解析出token,就说明token是经过认证服务器反送的,应该是合法的请求.
客户端详情信息在数据库中修改后,不用重新启动授权服务器.(修改了认证方式, paaword, authorization_code等,已验证)
1. 密码模式,必须配置AuthenticationManager,否则认证服务器不支持.
2. 通过zuul获取token等信息的时候,需要在zuul的配置中添加 zuul.sensitiveHeaders=Cookie,Set-Cookie, 否则报校验通不过的错误信息.
```

## zuul网关的注意点
```
1. 不要随便加@EnableOAuth2Sso, 可能导致正常的路由都失败. Could not get any response的错误.
2.  如果路由规则中指定的, 如果指定的是SERVICE_ID, 代表的只是服务器地址加上端口号, context-path是不包含的, 如果规则的path和服务的context-path一致,则添加strip-prefix: false
      mc-oauth-server:
            path: /uaa/**
            strip-prefix: false
            service-id: MC-AUTH-SERVER
```


## spring-oauth表说明 
[表说明](http://andaily.com/spring-oauth-server/db_table_description.html)


## oauth2的作用
* 用户只需要一个账户和密码，就能在各种客户端上访问有权使用的资源，无需在各个客户端进行注册。
  
  > 前提条件： 用户使用的资源系统有相应的授权服务器，并且各个客户端系统有访问客户资源的对接功能。

## 角色:
##  资源服务器
1. 资源服务器都需要配置哪些内容,都起到什么作用?
 ```
 因为客户端访问资源服务器的时候,都需要携带token进行调用, 如果用非对称加密算法签的token,则只需要获取对应的public-key进行验证,所以配置下面属性
security:
    oauth2:
        resource:
            id: mc-service-demo
            prefer-token-info: true
            jwt:
                key-uri: http://localhost:7777/uaa/oauth/token_key
                -- 获取公钥的地址.认证服务器的endpoint.

  也有通过获取用户信息的方式来进行验证的, 未经过测试.todo
  security:
    oauth2:
        resource:
             id:  mc-service-demo
             prefer-token-info: false
             user-info-uri: http://localhost:7777/uaa/user            
 ```

2. 资源服务器,授权服务器,第3方应用之间的关系是怎么样的?
2. 资源服务器是不是也要配置成认证服务器的一个客户端?
3. 资源服务器只间是通过什么样的方式相互访问的?
4. 第3方应用是如何访问资源服务器的?
5. 资源服务器上的api是通过授权服务器控制的,还是资源服务器自身控制的?
    目前的测试结果看, 资源服务器需要定义自己的访问控制策略. 
    如果资源服务未定义权限控制,只要知道地址,都能访问到,这就需要定义额外的访问策略了(防火墙,网关等)
6. 如果资源服务器本身不配置资源的权限控制,是可以随便进行访问的.
7. 资源服务器的访问权限是如何控制的?
8. 资源服务器如何验证请求中的token的合法性?
* 认证服务器会暴露url给资源服务器来验证其合法性
* 提供获取publickey的接口,资源服务器获取public key后用于验证token的合法性.


  当资源服务器继承ResourceServerConfigurerAdapter的时候, resourceId就不能在application.properties中进行配置了,需要重写config方法,设置resourceId.
  ```java
  @Override
    public void configure(ResourceServerSecurityConfigurer resources) throws Exception {
        resources.resourceId("demo").stateless(true);
    }
  ```

  9. 资源服务器获取token中配置的额外信息
  ```java
  public Map<String, Object> getExtraInfo(Authentication auth) {
    OAuth2AuthenticationDetails oauthDetails =
      (OAuth2AuthenticationDetails) auth.getDetails();
    return (Map<String, Object>) oauthDetails
      .getDecodedDetails();
}
  ```

## 资源服务器之间的相互调用




## 认证服务器
1. 认证服务器不需要在application.yml文件中配置和oauth相关的内容. (配置Datasource除外,client信息存储用)

2. 如果认证服务器扩展了AuthorizationServerConfigurerAdapter, 就不能在配在文件中配置相应的客户端信息,需要重写configure(ClientDetailsServiceConfigurer clients)方法来提供客户端的相应信息. 采用数据库的方式配置客户端信息.开发可用Memory.
  ```java
  @Override
    public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
        clients.jdbc(dataSource);
    }
  ```

3. 因为认证服务器需要认证用户及客户端的有效性, 所以需要配置能获取用户信息及客户端信息的内容
   * 资源服务器在获取令牌后, 需要进行验证, 从验证服务器上获取publicKey, 这样就能验证token是通过授权服务器颁发的(privatekey签名, publickye验证, 非对称加密), 所以要运行tokenKeyAccess的访问权限.
   * 资源服务器获取token后, 就可以通过获取的public key验证其有效性.
```java
@Override
public void configure(AuthorizationServerSecurityConfigurer security) throws Exception {
        // 允许客户表单认证
        security.allowFormAuthenticationForClients(); 
        // 对传入的客户端密码进行加密,然后和数据库中存入的客户端密码进行比较.
        security.passwordEncoder(passwordEncoder); 
        // 获取token进行签名的public key及验证token的有效性.
        security.tokenKeyAccess("permitAll()").checkTokenAccess("isAuthenticated()");
    }
```
4. 验证服务器需要配置token的生成及存储方式

*  提供token的生成及存储方式. 
*  对token的编码加强,在标准的token信息中添加额外的信息.
  ```java
  public class CustomTokenEnhancer implements TokenEnhancer {
    @Override
    public OAuth2AccessToken enhance(
      OAuth2AccessToken accessToken, 
      OAuth2Authentication authentication) {
        Map<String, Object> additionalInfo = new HashMap<>();
        additionalInfo.put(
          "organization", authentication.getName());
        ((DefaultOAuth2AccessToken) accessToken).setAdditionalInformation(
          additionalInfo);
        return accessToken;
    }
}
  ```

*  token的endpoint的基础信息设置
   1. 通过tokenEnhancer,在token中添加额外信息,比如用户角色权限信息等.不要放置敏感信息.
   2. 设在token存储的方式,本例使用的是jwt,这样无需在服务器端进行存储.
   3. 如果客户端需要支持密码模式的话,必须设置authenticationManager
   4. 如果需要token更新功能,需要设置userDetailsService.  
```java
/**
  * 授权和令牌端点和令牌服务
  * @param endpoints
  */
@Override
public void configure(AuthorizationServerEndpointsConfigurer endpoints) {
    TokenEnhancerChain tokenEnhancerChain = new TokenEnhancerChain();
    tokenEnhancerChain.setTokenEnhancers(Arrays.asList(tokenEnhancer, accessTokenConverter));
    endpoints.tokenStore(jwtTokenStore)
            .tokenEnhancer(tokenEnhancerChain)
            .allowedTokenEndpointRequestMethods(HttpMethod.GET, HttpMethod.POST)
            //refresh_token:UserDetailsService is required
            .userDetailsService(userDetailService)
            .authenticationManager(authenticationManager);
}

 @Bean
public TokenEnhancer tokenEnhancer() {
    return new CustomTokenEnhancer();
}   
```
5. 配置认证服务器的WebSecurity信息
认证服务器本身需要设定自己的安全访问策略. 
* 获取用户信息的userDetailsService, 能够返回用户的基本信息,密码,角色,权限等信息.
* PasswordEncoder, 对用户的输入密码进行加密和数据库中保存的密码进行对比.
* login登陆页面的定制  
* login成功后的处理
* login失败后的处理
* 允许哪些url不用认证就能访问
* 哪些url必须认证通过后才能访问等
```java
@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Bean
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Autowired
    private McUserDetailsService userDetailsService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

   /**
     * 获取用户信息的userDetailsService, 能够返回用户的基本信息,密码,角色,权限等信息.
     * PasswordEncoder, 对用户的输入密码进行加密和数据库中保存的密码进行对比.
     */
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder());
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .exceptionHandling()
            .authenticationEntryPoint((request, response, authException) -> response.sendError(HttpServletResponse.SC_UNAUTHORIZED))
            .and()
            .authorizeRequests()
            .antMatchers("/login", "/login.html","/oauth/token").permitAll()
            .anyRequest().authenticated()
            .and()
            .httpBasic();
    }

    @Override
    public void configure(WebSecurity web) throws Exception {
        web.ignoring().antMatchers("/**/*.css");
        web.ignoring().antMatchers("/**/*.js");
        web.ignoring().antMatchers("/favor.ioc");
        web.ignoring().antMatchers("/resources/**");
    }
}
```

## 非对称加密的方式签发token
```text
1. 生成keystore文件: mytest.jks
keytool -genkeypair -alias mytest 
                    -keyalg RSA 
                    -keypass mypass 
                    -keystore mytest.jks 
                    -storepass mypass

2. 导出public key
keytool -list -rfc --keystore mytest.jks | openssl x509 -inform pem -pubkey

-----BEGIN PUBLIC KEY-----
yyyyy
-----END PUBLIC KEY-----

-----BEGIN CERTIFICATE-----
xxxxx
-----END CERTIFICATE-----

 只获取public key的方式.
keytool -list -rfc --keystore mytest.jks | openssl x509 -inform pem -pubkey -noout  
3. 拷贝public部分的内容放到资源服务器的resource/public.txt, 以文件的方式存放.
```

## 在授权服务器上配置token使用的非对称key,z主要就是修改JwtAccessTokenConverter
```java
@Bean
public JwtAccessTokenConverter accessTokenConverter() {
    JwtAccessTokenConverter converter = new JwtAccessTokenConverter();
    KeyStoreKeyFactory keyStoreKeyFactory = 
      new KeyStoreKeyFactory(new ClassPathResource("mytest.jks"), "mypass".toCharArray());
    converter.setKeyPair(keyStoreKeyFactory.getKeyPair("mytest"));
    return converter;
}
```



6. 自定义认证服务器的登陆页面
   
7. 客户端使用用户名密码进行登陆



## 約束条件
* 同一个授权码，只能进行一次令牌的申请。
* 针对一个客户端申请的授权码，只能用该客户端的id和密码才能申请到令牌。


## OAuth2涉及角色
* resource owner：资源所有者（指用户）
* resource server：资源服务器存放受保护资源，要访问这些资源，需要获得访问令牌。
* client：客户端代表请求资源服务器资源的第三方程序
* authrization server：授权服务器用于发放访问令牌给客户端
```
1. ClientDetailsServiceConfigurer：用来配置客户端详情信息
2. AuthorizationServerSecurityConfigurer：用来配置令牌端点(Token Endpoint)的安全与权限访问。
* /oauth/authorize(授权端，授权码模式使用)
* /oauth/token(令牌端，获取 token)
* /oauth/check_token(资源服务器用来校验token)
* /oauth/confirm_access(用户发送确认授权)
* /oauth/error(认证失败)
* /oauth/token_key(如果使用JWT，可以获的公钥用于 token 的验签
3. AuthorizationServerEndpointsConfigurer：用来配置授权以及令牌（Token）的访问端点和令牌服务（比如：配置令牌的签名与存储方式）
```


**参考资料**
[OAuth工作流程](https://www.jianshu.com/p/68f22f9a00ee)
[授权码模式表定义](https://github.com/spring-projects/spring-security-oauth/blob/master/spring-security-oauth2/src/test/resources/schema.sql)

## oauth的工作流程
* 客户端需要把自己注册到授权服务器 （授权服务器提供注册客户端的界面或者数据库直接写入）
* 客户端访问自己的界面，上面有各种登陆选项（登陆到别的系统的按钮，如QQ，京东等）
* 登陆QQ时，打开QQ的登陆窗口，输入合法的qq账户和密码进行认证。
* 如果用户之前没有授权客户端程序（平安万里）使用他们的数据，则qq要求用户授权客户端使用权限。
   如果用户已经授权过，则跳过授权过程。
*  经过正确的身份验证后，qq将用户及一个验证码重定向到客户端（平安）指定的重定向URI。
*  客户端（平安）发送客户端ID，客户端令牌和身份验证码（授权码）到qq。
*  qq验证这些值都有效后，将最终的访问令牌发送给客户端系统（平安）系统。
*  客户端获得访问令牌后，就带着令牌访问资源服务器（qq）上面的资料（api接口）
*  资源服务器（qq）使用qq的授权服务器验证令牌的有效性。
*  成功验证令牌后，qq服务器（资源服务器）就向客户端（平安）提供他访问的资源。
* 

## 1.授权码模式程
（A）用户访问客户端，客户端将用户导向授权服务器进行认证并授权。   
（B）用户选择是否给予客户端授权。  
（C）假设用户给予授权，授权服务器将用户导向客户端事先指定的“重定向URI”，并附上一个授权码。  
（D）客户端收到授权码，和客户端设定的“重定向URI”向认证服务器申请令牌，申请令牌的过程是客户端的后台服务器上完成的，对用户不可见。  
（E）认证服务器核对授权码和重定向URI，确认无误后向客户端发送访问令牌和更新令牌。   

**测试流程**
```
(A) http://localhost:8000/oauth/token?code=83YUfj&scope=all&grant_type=authorization_code&redirect_uri=http://localhost:8082/showEmployees
(B) curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d 'grant_type=authorization_code&code=Li4NZo&redirect_uri=http://localhost:8082/userinfo' "http://client:secret@localhost:8081/oauth/token"
```



**申请验证码的api接口**
```
get http://localhost:8000/oauth/authorize?response_type=code&client_id=myclient&state=xyz&redirect_uri=http://localhost:8082/userinfo
参数说明：
respone_type：授权类型，必选，此处固定值“code”
client_id：客户端的ID，必选
client_secret：客户端的密码，可选
redirect_uri：重定向URI，可选
scope：申请的权限范围，可选
state：客户端当前的状态，可以指定任意值，认证服务器会原封不动的返回这个值
```

**申请token的API接口**
```
post http://localhost:8000/oauth/token
grant_type：表示使用的授权模式，必选，此处固定值为“authorization_code”
code：表示上一步获得的授权吗，必选
redirect_uri：重定向URI，必选，与步骤 A 中保持一致
client_id：表示客户端ID，必选
```


**授权服务器返回令牌的response内容**
```
access_token：表示令牌，必选
token_type：表示令牌类型，该值大小写不敏感，必选，可以是 bearer 类型或 mac 类型
expires_in：表示过期时间，单位为秒，若省略该参数，必须设置其它过期时间
refresh_token：表示更新令牌，用来获取下一次的访问令牌，可选
scope：表示权限范围
```


## 2.密码授权模式的流程
（A）用户向客户端提供用户名和密码。  
（B）客户端将用户名密码发送认证给服务器，向后者请求令牌。  
（C）认证服务器确认无误后，向客户端提供访问令牌。  

> 备注：密码模式，用户访问资源服务器的用户名和密码是提供给了客户端的服务，在客户端的应用上操作。授权码的授权过程，是在授权服务器应用上进行的，只是最后把授权码发给了客户端指定的uri。
> 密码模式必须配置AuthenticationManager。

### 密码模式申请令牌的请求参数
```
POST /oauth/token {
grant_type：授权类型，必选，此处固定值“password”
username：表示用户名，必选
password：表示用户密码，必选
scope：权限范围，可选
}
```


## 3.客户端模式流程
（A）:客户端向认证服务器进行身份认证，并要求一个访问令牌。  
（B）:认证服务器确认无误后，向客户端提供访问令牌。  
> 备注， 授权服务器针对客户端应用进行认证授权，和具体的用户无关系。（所有通过该客户端的用户权限都一样）

### 客户端模式的请求参数
```
granttype：表示授权类型，此处固定值为“clientcredentials”，必选  
scope：表示权限范围，可选
client_id: 客户端ID
client_critical: 客户端密码
```


## 4.更新模式
如果用户访问的时候，客户端“访问令牌”已经过期，则需要使用“更新令牌”申请一个新的令牌
> 备注： 客户端需要自己调用令牌的刷新接口来获取新的令牌，无需重新进行认证和授权。？？？  
```
客户端发出更新令牌请求，包含以下参数：
granttype：表示授权模式，此处固定值为“refreshtoken”，必选
refresh_token：表示早前收到的更新令牌，必选
scope：表示申请权限范围，不得超出上一次申请的范围，若省略该参数，则表示与上一次一样
```

## 隐式模式
该模式类似授权码模式，但不会生成授权码，直接返回访问令牌，同时，也不会生成刷新令牌。



## 令牌的存取方式
 * 内存模式
 * 数据库
 * JWT

## 令牌的验证方式
## 应用客户端的存取方式
 内存
 数据库


## 授权方式的选择

* 密码模式：资源的拥有者提供用户名和秘密给授权服务器获取访问token。密码暴露给客户端应用。
> 适用场景：用户端客户端高度信任，通常时授权服务器的其他模式好用才使用密码模式。
* 授权码模式：功能最完整、流程最严密的授权模式，它的特点是通过客户端的后台服务器与授权服务器进行互动完成令牌的发放。
     1. 授权码有时效性，通常时10分钟（可配？），如果获取授权码后，10分钟内未申请令牌，则授权码失效。
     2. 获取令牌的参数：授权码+客户端ID+重定向URI必须匹配，否则获取令牌失败。
* 简化模式： 简化模式不通过第三方应用程序的服务器，直接在浏览器中向认证服务器申请令牌，跳过了“授权码”这个步骤。
*  更新令牌： 用户访问的时候，客户端“访问令牌”已经过期，则需要使用“更新令牌”申请一个新的令牌
*  客户端模式： 



## 授权服务器配置
### 配置授权服务器需要考虑的内容
* 支持的授权类型， 不同的授权类型提供了不同的获取令牌的方式。  
* 客户端详细信息的存储方式。
* 令牌的存储方式（数据库，redis）
* 令牌存储方式JWT的加密算法（指的是签名的加密方式，对称加密，非对称加密选择）

1. 客户端详情的配置（ClientDetailsServiceConfigurer）
```
clientId：客户端标识ID  
secret：客户端安全码(在数据库中存储的是加密后的密码，否则获取token会失败)  
scope：客户端访问范围，默认为空则拥有全部范围.  
authorizedGrantTypes：客户端使用的授权类型，默认为空。  
authorities：客户端可使用的权限。  
```
2. 管理令牌
术语：
> 持久化令牌（存储到外围设备，数据库，redis等）

令牌的创建，获取，刷新，加载读取，令牌的撤销等令牌的管理，基本都有DefaultTokenServices。  
作为应用来说，主要考虑的是如何配置TokenStore。

JWT的处理  
```
(A) JwtAccessTokenConverter担当了token的编码及解码过程，相当于jdbcTokenStore存放uuid类别的token功能。
(B) 对jwt令牌进行签名的密钥，必须在授权服务器及资源服务器上都有，而且JwtAccessTokenConverter也要一样。
(C) 使用 JWT 令牌需要在授权服务中使用 JWTTokenStore，资源服务器也需要一个解码 Token令牌的类 JwtAccessTokenConverter。JwtTokenStore 依赖这个类进行编码以及解码，因此授权服务以及资源服务都需要配置这个转换类
(D)Token 令牌默认是有签名的，并且资源服务器中需要验证这个签名，因此需要一个对称的 Key 值，用来参与签名计算
这个 Key 值存在于授权服务和资源服务之中
(E) 使用非对称加密算法加密 Token 进行签名，Public Key 公布在 /oauth/token_key 这个 URL 中默认 /oauth/token_key 的访问安全规则是 "denyAll()" 即关闭的，可以注入一个标准的 SpingEL 表达式到 AuthorizationServerSecurityConfigurer 配置类中将它开启，例如 permitAll()
需要引入 spring-security-jwt 库
```

3. 配置授权类型

*  授权是使用 AuthorizationEndpoint 这个端点来进行控制的，使用 AuthorizationServerEndpointsConfigurer 
*  这个对象实例来进行配置，默认是支持除了密码授权外所有标准授权类型，它可配置以下属性：
*  authenticationManager：认证管理器，当你选择了资源所有者密码（password）授权类型的时候，请设置这个属性注入一个 AuthenticationManager对象
*  userDetailsService：可定义自己的 UserDetailsService 接口实现，获取用户的基本信息及权限设置
*  authorizationCodeServices：用来设置授权码服务的（即 AuthorizationCodeServices 的实例对象），主要用于 "authorization_code" 授权码类型模式
*  implicitGrantService：这个属性用于设置隐式授权模式，用来管理隐式授权模式的状态
*  tokenGranter：完全自定义授权服务实现（TokenGranter接口实现），只有当标准的四种授权模式已无法满足需求时

4. 配置授权端点（endpoint)
> 授权端点的 URL 应该被 Spring Security 保护起来只供授权用户访问
```
/oauth/authorize：授权端点
/oauth/token：令牌端点
/oauth/confirm_access：用户确认授权提交端点
/oauth/error：授权服务错误信息端点
/oauth/check_token：用于资源服务访问的令牌解析端点
/oauth/token_key：提供公有密匙的端点，如果你使用JWT令牌的话
```

5.  设置token服务类





  - 令牌存储方式
    - JWT的方式存储令牌（RSA非对称加密），spring框架提供JwtTokenStore.
    需要一个JwtAccessTokenConverter.通过public key和privatekey进行验证token.

    - 数据库方式存取令牌。
	spring框架本身提供的JdbcTokenStore,只需要配置数据源DataSource,然后调用JdbcTokenStore就好了。
    
   - 通过授权服务器解析令牌。授权服务器的check_token端点(endpoint)验证令牌的有效性。

## 授权服务器配置
  - TokenStore: Token的存储方式及解析方式。
  - AuthenticationManager: 用户的认证方式。
  - UserDetialsService: 获取用户的基本信息的方式。作用到底是什
  - JdbcClientDetailsService: 客户端的获取方式。
  - 令牌的一些基本信息（失效时间，令牌刷新是否支持等）
  - 配置客户端的一些基本信息：客户端ID，客户端密码，认证方式，允许授权服务器授权的范围，是否需要批准授权等信息。
  - 授权服务器本身的一些安全配置信息。  
  - 配置AuthorizationServerEndpointsConfigurer
     -- authenciationManager
     - userDetialService
     - tokenServices.


## 资源服务器配置
* 要访问资源服务器受保护的资源需要携带令牌（从授权服务器获得）
* 客户端往往同时也是一个资源服务器，各个服务之间的通信（访问需要权限的资源）时需携带访问令牌
* OAuth2 为资源服务器配置提供ResourceServerProperties类，该类会读取配置文件中对资源服务器得配置信息（如授权服务器公钥访问地址)

### 资源服务器的可配置项
* tokenServices：ResourceServerTokenServices 类的实例，用来实现令牌业务逻辑服务
* resourceId：这个资源服务的ID，这个属性是可选的，但是推荐设置并在授权服务中进行验证 
* tokenExtractor 令牌提取器用来提取请求中的令牌
* 请求匹配器，用来设置需要进行保护的资源路径，默认的情况下是受保护资源服务的全部路径
* 受保护资源的访问规则，默认的规则是简单的身份验证（plain authenticated）
* 其他的自定义权限保护规则通过 HttpSecurity 来进行配置

### 解析令牌方法
* 使用 DefaultTokenServices 在资源服务器本地配置令牌存储、解码、解析方式。 
* 使用 RemoteTokenServices 资源服务器通过 HTTP 请求来解码令牌，每次都请求授权服务器端点/oauth/check_token。
* 若授权服务器是 JWT 非对称加密，则需要请求授权服务器的 /oauth/token_key 来获取公钥 key 进行解码。
* 资源服务器的HttpSecurity配置。设置资源服务器资源本身的安全。
* 通常,资源服务器也作为授权服务器的客户端。 配置资源服务器的tokenService(remoteTokenServices)

> 令牌解析
资源服务器和授权服务器不在同一个应用，则需告诉资源服务器令牌如何存储与解析，并与授权服务器使用相同的密钥进行解密


## 客户端模块的开发
* 客户端也需要实现存储用户的授权代码和访问令牌的功能。
* 

 

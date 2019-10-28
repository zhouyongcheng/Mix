# spring oauth2学习笔记

## oauth2的作用
* 用户只需要一个账户和密码，就能在各种客户端上访问有权使用的资源，无需在各个客户端进行注册。
  > 前提条件： 用户使用的资源系统有相应的授权服务器，并且各个客户端系统有访问客户资源的对接功能。

## 約束条件
* 同一个授权码，只能进行一次令牌的申请。
* 针对一个客户端申请的授权码，只能用该客户端的id和密码才能申请到令牌。


## OAuth2涉及角色
* resource owner：资源所有者（指用户）
* resource server：资源服务器存放受保护资源，要访问这些资源，需要获得访问令牌。
* client：客户端代表请求资源服务器资源的第三方程序
* authrization server：授权服务器用于发放访问令牌给客户端

**参考资料**
[OAuth工作流程](https://www.jianshu.com/p/68f22f9a00ee)

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
 1）使用 JWT 令牌需要在授权服务中使用 JWTTokenStore，资源服务器也需要一个解码 Token令牌的类 JwtAccessTokenConverter。  
 JwtTokenStore 依赖这个类进行编码以及解码，因此授权服务以及资源服务都需要配置这个转换类
2）Token 令牌默认是有签名的，并且资源服务器中需要验证这个签名，因此需要一个对称的 Key 值，用来参与签名计算
这个 Key 值存在于授权服务和资源服务之中
3）者使用非对称加密算法加密 Token 进行签名，Public Key 公布在 /oauth/token_key 这个 URL 中默认 /oauth/token_key 的访问安全规则是 "denyAll()" 即关闭的，可以注入一个标准的 SpingEL 表达式到 AuthorizationServerSecurityConfigurer 配置类中将它开启，例如 permitAll()
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
  - RemoteTokenServices 远程校验token是否合法（在授权服务器上进行校验）
  - 资源服务器的HttpSecurity配置。
  - ResourceServerSecurityConfigurer: 通常,资源服务器也作为授权服务器的客户端。、  配置资源服务器的tokenService(remoteTokenServices)



  - 客户端获取方式（客户端应用）也就是说每个访问授权服务器的应用都是客户端，需要注册到授权服务器中。
  - 数据库方式加载客户端信息。(new JdbcClientDetailsService(dataSource)
   

## 资源服务器
- 令牌的解析方式
  -- 需要一个授权服务器匹配的令牌存储store, JwtTokenStore及对应的TokenConverter.     配置public key来解析token，确保是授权服务器生成的token，也就意味资源服务器必须信任授权服务器。
  - 获取public key的方式，1）通过在资源服务器本地配置publickey。 
   2）通过远程的方式，从授权服务器上获取public_key，然后进行验证。



## WebSecurity配置信息

 

# spring oauth2学习笔记
## 令牌的存取方式
 内存
 数据库
 JWT

## 令牌的验证方式
## 应用客户端的存取方式
 内存
 数据库

## 授权方式的选择
  秘密方式：资源的拥有者提供用户名和秘密给授权服务器获取相应的访问token。
  资源服务器提供登陆接口。


## 授权服务额器
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

 

** springboot oauth2 sso

在springboot2的应用起动类上enableAuthorizationServer, 则使该应用变为权限服务器。
* 需要user/password进行授权操作。
* clientId和client_secret： 可以在配置文件中配相关客户端的信息。也可以存在数据库中。
* redirect_uri: 获取认证码成功后重定向的网页。（在授权服务器上要为客户端注册这个地址，用于识别客户端的有效性）
```
security:
  oauth2:
    client:
      registered-redirect-uri: http://www.baidu.com
      client-id: oauth
      client-secret: oauth
      scope: all
      access-token-validity-seconds: 6000
      refresh-token-validity-seconds: 6000
      grant-type: authorization_code,password
      resource-ids: oauth2
```


如果有@EnableWebSecurity的配在项目，则会提示登陆。因为SpringSecurity会保护授权服务器。
如果要使用授权服务器，则必须配在EnableWebSecurity. 因为授权服务器必须要被保护。

通过下面的url获取授权码：
http://localhost:8080/oauth/authorize?response_type=code&client_id=oauth&redirect_uri=http://your.web.site&scope=all

2)  上面的获取授权码后，则用者个授权码去获取授权用的token。
```
http://localhost:8080/oauth/token
type: Basic Auth, authorization: username/password, 这里只的是客户端的id和秘密。（配置文件中配的内容）
header： Content-Type ： application/x-www-form-urlencoded
body {
	grant_type : authorization_code
	code: xxxxxx
	redirect_url: xxxxx.xxx.xx
	client_id: oauthxxx
	scope: all

}
```


密码模式
直接在客户端上使用用户的id和密码来获取token，进行后续的访问。
```
http://localhost:8080/oauth/token
type: Basic Auth，authorization: username/password, 这里只的是客户端的id和秘密。（配置文件中配的内容）
body {
	grant_type : password 
	username： xxx
	password：yyyy
	scope: all
}
注意： 用户名和密码都在客户端应用中，除非是内部系统或在绝对信任的应用。但可以避免获取授权码的过程。
```

通过springSecurity保护的用户，实际是授权服务器的用户。也就是登陆的用户，拥有资源的用户，用户不能在配置文件中进行配置。


启动资源服务器保护资源的时候，只能通过获取的token，然后在去访问需要的资源了。（如果不配置，登陆页面都需要token访问，否则提示无权访问。）
如果资源服务器配置的resourceId和授权服务器上配置的资源id不匹配，也是不能访问的。
```
security:
  oauth2:
    client:
      registered-redirect-uri: http://www.baidu.com
      client-id: oauth
      client-secret: oauth
      scope: all
      access-token-validity-seconds: 6000
      refresh-token-validity-seconds: 6000
      grant-type: authorization_code,password
  --------------------授权服务器的配置--------------------------    
      resource-ids: oauth2
  --------------------资源服务器的配置-------------------    
    resource:
      id: oauth1
```

* 授权服务器的详细作用
** 客户端的验证与授权
** 令牌的生成与发放
** 令牌的校验与更新
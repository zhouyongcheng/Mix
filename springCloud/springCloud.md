# oauth endpoint
```
/oauth/authorize  (授权端，授权码模式使用)
/oauth/token      (令牌端，获取 token)
/oauth/check_token(资源服务器用来校验token)
/oauth/confirm_access (用户发送确认授权)
/oauth/error  (认证失败)
/oauth/token_key (如果使用JWT，可以获的公钥用于 token 的验签)
```



curl -s cmwin:manager@192.168.3.5:4001/oauth/token  \
 -d grant_type=client_credentials \
 -d scope=app

 curl -s clientId:secretId@192.168.3.5:4001oauth/token  \
 -d grant_type=client_credentials \
 -d scope=app



```
com.github
thymeleaf-extras-shiro
```


UserDetailService

passwordEncode

# springSecurity

**核心功能** 

* 认证（你是谁)
* 授权（能作什么） 
* 攻击防止（防止伪造身份） 

##  密码的处理
* 注册的时候密码加密后存入数据库,避免密码泻露.
```java
private void encryptPassword(UserEntity userEntity){
        String password = userEntity.getPassword();
        password = new BCryptPasswordEncoder().encode(password);
        userEntity.setPassword(password);
    }
```


* 登陆验证的时候调用加密后和数据库中存储的进行比较.
1) 在WebSecurity中配置密码加密的算法, 由系统自己调用,只要配置就可以了
```java
@Bean
public PasswordEncoder passwordEncoder(){
    return new BCryptPasswordEncoder();
}
 // DaoAuthenticationProvider.additionalAuthenticationChecks  验证密码的有效行
```

## 登陆流程修改
> 需求: 未登录的情况下
>    用户访问html资源的时候跳转到登录页
>    其他类型请求: 返回JSON格式数据，状态码为401 (服务间调用)

### 实现方式 
```
    1)  修改loginPage的地址,.loginPage("/authentication/require")  // 登录跳转,表示需要身份认证时,调转的处理
    2) .antMatchers("/authentication/require", "/login.html").permitAll() // 登录跳转 URL 无需认证
    3) 定义一个RestController, 处理/authentication/require
```


## 自定义Filter
* 自定义的 Filter 建议继承 GenericFilterBean，本文示例：
* 配置自定义 Filter 在 Spring Security 过滤器链中的位置
* UsernamePasswordAuthenticationFilter
```java

// 在 UsernamePasswordAuthenticationFilter 前添加 BeforeLoginFilter
        http.addFilterBefore(new BeforeLoginFilter(), UsernamePasswordAuthenticationFilter.class);

        // 在 CsrfFilter 后添加 AfterCsrfFilter
        http.addFilterAfter(new AfterCsrfFilter(), CsrfFilter.class);
```

## 动态权限修改示例
```java
@GetMapping(value="/tovip")
public boolean updateToVIP() {
        // 得到当前的认证信息
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        //  生成当前的所有授权
        List<GrantedAuthority> updatedAuthorities = new ArrayList<>(auth.getAuthorities());
        // 添加 ROLE_VIP 授权
        updatedAuthorities.add(new SimpleGrantedAuthority("ROLE_VIP"));
        // 生成新的认证信息
        Authentication newAuth = new UsernamePasswordAuthenticationToken(auth.getPrincipal(), auth.getCredentials(), updatedAuthorities);
        // 重置认证信息
        SecurityContextHolder.getContext().setAuthentication(newAuth);
        return true;
    }
```

## rememberMe sql
```sql
CREATE TABLE persistent_logins (
    username VARCHAR (64) NOT NULL,
    series VARCHAR (64) PRIMARY KEY,
    token VARCHAR (64) NOT NULL,
    last_used TIMESTAMP NOT NULL
)
```

##认证过程
> 如果要在用户名密码验证前加入其他验证,如验证码,则需要在UsernamePasswordAuthenticationFilter前添加自己的Filter进行处理.

```
Spring Security使用UsernamePasswordAuthenticationFilter过滤器来拦截用户名密码认证请求
 ，将用户名和密码封装成一个UsernamePasswordToken对象交给AuthenticationManager处理。
  AuthenticationManager将挑出一个支持处理该类型Token的AuthenticationProvider
（为DaoAuthenticationProvider，AuthenticationProvider的其中一个实现类）来进行认证，
认证过程中DaoAuthenticationProvider将调用UserDetailService的loadUserByUsername方法
来处理认证，如果认证通过（即UsernamePasswordToken中的用户名和密码相符）则返回一个UserDeta
ils类型对象，并将认证信息保存到Session中，认证后我们便可以通过Authentication对象获取到认证
的信息了。
```


UsernamePasswordAuthenticationFilter-->BasicAuthenticationFilter-->ExceptionTranslateFilter-->FilterSecurityInterceptor--> Controller API

UsernamePasswordAuthenticationToken
ProviderManager
DaoAuthenticationProvider
UserDetailsService
InMemoryUserDetailsManager
最后在配置类中进行配置
HttpSecurity http配置UsernamePasswordAuthenticationFilter
AuthenticationManagerBuilder auth) 配置DaoAuthenticationProvider

## 验证码的验证过程;
1) 登陆页面现实的时候,在 img的src属性上发送验证码生成请求 src=/image/code
2) 在服务器端会生成验证码,返回之前存入到session中.
3) 登陆的时候,先进行验证码的验证操作,然后在进行uname/passwd的验证.
4) 验证通过后,清楚缓存中的验证码.(成功或失败都清除)


## 使用数据库定义用户认证服务
* 用户的数据存储在数据库中
* 只要定义UserDetailService获取用户的信息就可以了,这样UsernamePasswordAuthenticationFilter就会比较通过UserDetailService 获取的用户的密码及客户端输入的密码进行比较,如果相等,认证通过. 当然,因为注册了PasswordEncoder,所以请求过来的password默认会被加密,所以数据库中的密码也应该用同一个密码加密器进行加密后存入数据库.


## 配置页面路由(定义一个配置类,)
```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/sellout/index").setViewName("sellout/index");
        registry.addViewController("/hello").setViewName("hello");
    }
}
```

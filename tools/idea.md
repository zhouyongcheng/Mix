## ideavim

```shell
# 在home目录下创建 .ideavimrc
# jj代替Esc
imap jj <Esc>
set timeoutlen=1000
```



## 注释模版

```properties
#live template
#class comment
/**
 * class_name: $CLASS_NAME$
 * describe: TODO
 * creat_user: zhouyc
 * creat_date: $CREAT_DATE$
 * creat_time: $CREAT_TIME$
 **/
 
 #method comment
 /**
 * describe: TODO
 * @param: $METHOD_PARAM$
 *
 * creat_user: zhouyc
 * creat_date: $CREAT_DATE$
 * creat_time: $CREAT_TIME$
 **/
 
 # Template variables:
 METHOD_NAME -> methodName()
 METHOD_PARAM -> methodParameters()
 CREAT_DATE -> date()
 CREAT_TIME -> time()
```


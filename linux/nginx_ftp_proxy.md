# nginx反向代理FTP服务

## 查看ftp的版本信息。
vsftpd -v
vsftpd: version 2.2.2

## nginx的安装
1. 下载并解压Nginx压缩包
2. 配置
3. 


## 查看nginx现有的配置
sbin/nginx -V
2>&1 nginx -V | tr ' '  '\n' | grep stream

## 安装模块
1. 在未安装nginx的情况下安装nginx第三方模块(需要make install)
```
./configure --prefix=/usr/local/nginx \
--with-http_stub_status_module \
--with-http_ssl_module --with-http_realip_module \
--with-http_image_filter_module \
--add-module=../ngx_pagespeed-master --add-module=/第三方模块目录
 make
 make isntall
```

2. 在已安装nginx情况下安装nginx模块(不需要make install，只需要make)
```
 ./configure --prefix=/usr/local/nginx \
 --with-http_stub_status_module \
 --with-http_ssl_module --with-http_realip_module \
 --with-http_image_filter_module \
 --add-module=../ngx_pagespeed-master
 make
 /usr/local/nginx/sbin/nginx -s stop
 cp objs/nginx /usr/local/nginx/sbin/nginx
 /usr/local/nginx/sbin/nginx //启动nginx
```


TLS SNI support enabled
configure arguments: --prefix=/opt/nginx1.11.2.5/nginx --with-cc-opt=-O2 --add-module=../ngx_devel_kit-0.3.0 --add-module=../echo-nginx-module-0.61 --add-module=../xss-nginx-module-0.05 --add-module=../ngx_coolkit-0.2rc3 --add-module=../set-misc-nginx-module-0.31 --add-module=../form-input-nginx-module-0.12 --add-module=../encrypted-session-nginx-module-0.06 --add-module=../srcache-nginx-module-0.31 --add-module=../ngx_lua-0.10.10 --add-module=../ngx_lua_upstream-0.07 --add-module=../headers-more-nginx-module-0.32 --add-module=../array-var-nginx-module-0.05 --add-module=../memc-nginx-module-0.18 --add-module=../redis2-nginx-module-0.14 --add-module=../redis-nginx-module-0.3.7 --add-module=../rds-json-nginx-module-0.14 --add-module=../rds-csv-nginx-module-0.07 --with-ld-opt=-Wl,-rpath,/opt/nginx1.11.2.5/luajit/lib --with-stream --with-stream_ssl_module --sbin-path=/opt/nginx1.11.2.5/sbin/nginx --conf-path=/opt/nginx1.11.2.5/conf/nginx.conf --error-log-path=/opt/nginx1.11.2.5/log/error.log --pid-path=/opt/nginx1.11.2.5/nginx.pid --with-http_gzip_static_module --with-http_stub_status_module --with-http_realip_module --with-http_ssl_module
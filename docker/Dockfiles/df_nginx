# 注意：非注释第一行 必须以FROM 开头。
 # FROM 指定基础镜像，即以此镜像作为基础
 FROM nginx
 # 设置元数据，利用 docker inspect [镜像名称|镜像ID],即可查看。
 LABEL author="zhouyc"
 LABEL version="v1.0.0"
 LABEL desc="modify nginx welcome"
 # 操作执行，这里直接修改了nginx的html的首页内容，/usr/share/nginx/html
# 原本想输出中文，乱码了，设置了 ENV LANG C.UTF-8 或者 ENV LANG zh_CN.UTF-8 都不行 放弃了，有知道大神望告知！
 RUN echo 'hello world, you are welcome' > /usr/share/nginx/html/index.html
 # 启动命令 不写时 会直接使用基础镜像的启动命令
 CMD ["nginx", "-g", "daemon off;"]
# 基础镜像为java:8
FROM java:8
# 维护者信息
MAINTAINER zhouyc yongchengzhou@hotmail.com
VOLUME /tmp
ADD DockerDemo-1.0-SNAPSHOT.jar app.jar
# 镜像的操作指令通过run来执行
RUN bash -c 'touch /app.jar'
EXPOSE 4001
# 容器启动后执行的指令
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]

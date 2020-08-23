## 添加阿里的mvn仓库

````xml
<!-- 在mvn的setting文件中进行全局配置 -->
<mirror>
    <id>nexus-aliyun</id>
    <mirrorOf>central</mirrorOf>
    <name>Nexus aliyun</name>
    <url>http://maven.aliyun.com/nexus/content/groups/public</url>
</mirror>

<!-- 在单个项目的pom.xml文件中进行配置 -->
<repositories>
    <repository>
        <id>central</id>
        <name>aliyun maven</name>
        <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        <layout>default</layout>
        <!-- 是否开启发布版构件下载 -->
        <releases>
            <enabled>true</enabled>
        </releases>
        <!-- 是否开启快照版构件下载 -->
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
    </repository>
</repositories>
````

## 把jar加入本地repository

```
mvn install:install-file -Dfile=c:/ftp4j-1.6.jar -DgroupId=it.sauronsoftware -DartifactId=ftp4j -Dversion=1.6 -Dpackaging=jar
```



## flink的idea插件

## 在idea中使用maven

```
1） 编辑系统环境变量M2_HOME
2)  设置PATH变量包含M2_HOME/bin
3)  重新启动idea
```


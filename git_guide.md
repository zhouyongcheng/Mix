## 1. 添加阿里的manen镜像



```xml
<!-- 第一步:修改maven根目录下的conf文件夹中的setting.xml文件-->
<mirrors>
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>        
    </mirror>
  </mirrors>

<!-- 第二步: pom.xml文件里添加 -->
<repositories>  
        <repository>  
            <id>alimaven</id>  
            <name>aliyun maven</name>  
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>  
            <releases>  
                <enabled>true</enabled>  
            </releases>  
            <snapshots>  
                <enabled>false</enabled>  
            </snapshots>  
        </repository>  
</repositories>  
```





## svn 导出纯代码

1. 拷贝svn的项目,放在一个干净的目录下面.
2. 执行下面的清理脚步,完成svn信息的清除.
```bat
 @echo On
 @Rem 删除SVN版本控制目录
 @PROMPT [Com]

 @for /r . %%a in (.) do @if exist "%%a/.svn" rd /s /q "%%a/.svn"
 @Rem for /r . %%a in (.) do @if exist "%%a/.svn" @echo "%%a/.svn"
  
 @echo Mission Completed.
 @pause
```


## 把本地文件导入到maven仓库,避免从远程仓库导入
```



mvn install:install-file -Dfile=~/data/soft/flink-1.10.0/lib/flink-table_2.12-1.10.0.jar -DgroupId=org.apache.flink -DartifactId=flink-table_2.12 -Dversion=1.10.0 -Dpackaging=jar
```



<!-- https://mvnrepository.com/artifact/org.apache.flink/flink-table -->
<dependency>
    <groupId>org.apache.flink</groupId>
    <artifactId>flink-table_2.11</artifactId>
    <version>1.7.2</version>
    <scope>provided</scope>
</dependency>





# common command

当执行 "git reset HEAD" 命令时，暂存区的目录树会被重写，被 master 分支指向的目录树所替换，但是工作区不受影响。
当执行 "git rm --cached <file>" 命令时，会直接从暂存区删除文件，工作区则不做出改变。

当执行 "git checkout ." 或者 "git checkout -- <file>" 命令时，会用暂存区全部或指定的文件替换工作区的文件。这个操作很危险，会清除工作区中未添加到暂存区的改动。

当执行 "git checkout HEAD ." 或者 "git checkout HEAD <file>" 命令时，会用 HEAD 指向的 master 分支中的全部或者部分文件替换暂存区和以及工作区中的文件。这个命令也是极具危险性的，因为不但会清除工作区中未提交的改动，也会清除暂存区中未提交的改动。


要从 Git 中移除某个文件，就必须要从已跟踪文件清单中移除，然后提交。可以用以下命令完成此项工作
git rm <file>
git commit -m "rmove file"

如果删除之前修改过并且已经放到暂存区域的话，则必须要用强制删除选项 -f
git rm -f <file>


如果把文件从暂存区域移除，但仍然希望保留在当前工作目录中，换句话说，仅是从跟踪清单中删除，使用 --cached 选项即可
git rm --cached <file>

重命名一个文件、目录、软连接。
git mv README  README.md

# Git 服务器搭建
```
创建一个git用户组和用户
groupadd git
useradd git -g git
passwd  manager/manager
```

##创建证书登录

```
$ cd /home/git/
$ mkdir .ssh
$ chmod 755 .ssh
$ touch .ssh/authorized_keys
$ chmod 644 .ssh/authorized_keys
```

## 初始化Git仓库
```
$ cd /home/git
$ mkdir gitrepo
$ chown git:git gitrepo/
$ cd gitrepo
$ git init --bare cmwin.git
$ chown -R git:git cmwin.git
```

##克隆仓库
```
$ git clone git@192.168.3.5:/home/git/gitrepo/cmwin.git
```
-- 把本地的git仓库和远程的仓库进行关联。
git remote add origin git@github.com:michaelliao/learngit.git 
-- 把本地的分支推送到远程分支，并进行关联。(第一次关联的时候)
git push -u origin master
-- 只推送
git push origin master

-- 如果从零开始开发，先建立远程仓库，然后在本地进行clone。

## git的分支管理
```
可以在本地创建多个分支，代码完成后，合并到主分支，然后删除分支，把合并后的代码推送到远程版本库
```
* git branch     查看分支情况 
* git checkout -b newbranch   创建新的分支并切换到新分支进行作业。
* git branch dev   创建新分支，但不切换到该分支
* git checkout dev  切换到dev分支

## dev分支
在dev分支上进行开发，最后合并到master分支。
新功能在future分支上进行开发，最后合并到master分支
* master分支是主分支，因此要时刻与远程同步；
* dev分支是开发分支，团队所有成员都需要在上面工作，所以也需要与远程同步；
* bug分支只用于在本地修复bug没必要推到远程;
* feature分支是否推到远程，取决于你是否和你的小伙伴合作在上面开发。


```
分支修改内容合并到主分支
```
* 查看分支：git branch
* 创建分支：git branch <name>
* 切换分支：git checkout <name>
* 创建+切换分支：git checkout -b <name>
* 合并某分支到当前分支：git merge <name>
* 删除分支：git branch -d <name>
* 强行删除分支： git branch -D feature-vulcan  （丢弃一个没有被合并过的分支）
* 创建本地dev分支和远程dev分支绑定 git checkout -b dev origin/dev
* 建立本地分支和远程分支的关联 git branch --set-upstream-to=origin/dev dev   
* git log --graph --pretty=oneline --abbrev-commit

## 分支管理策略
* master分支应该是非常稳定的，也就是仅用来发布新版本，平时不能在上面干活
* 在dev分支上干活
* git stash  把当前工作现场“储藏”起来，等以后恢复现场后继续工作
* git stash list   查看缓存的工作内容列表
* git stash pop    取出暂存的工作内容进行工作
* git stash apply stash@{0}
* git stash drop  stash@{0}

## 标签管理 
> 注意，标签不是按时间顺序列出，而是按字母排序的
* git tag v1.0   在当前分支，当前提交上打tag
* git tag v1.1   在当前分支，指定的提交上打tag
* git show tagname  显示tag的基本信息
* git tag -a v0.1 -m "version 0.1 released" 1094adb   创建带有说明的标签，用-a指定标签名，-m指定说明文字
* git tag -d v0.1  删除标签
* git push origin <tagname>
* git push origin --tags   一次性推送全部尚未推送到远程的本地标签
>标签已经推送到远程，要删除远程标签就麻烦一点，先从本地删除
```
git tag -d v0.9
git push origin :refs/tags/v0.9
```

## git 导出纯代码
```
git archive --format zip --output "../master.zip" master -0
git archive --format zip --output "../output.zip" master -0
```


 git clone git@10.67.31.48:/home/git/mcrepo.git
  git clone git@10.67.31.48:/home/git/msgcenter.git


threadpool.bulk.type: fixed
threadpool.bulk.size: 8
threadpool.bulk.queue_size: 1000

git remote add origin git@192.168.101.14:/home/git/gitrepo/mcproj.git

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
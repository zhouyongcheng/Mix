# 问题解决
* 出现了npm ERR! cb() never called!错误 
    npm cache clean -f
    清除完缓存后，安装最新版本的Node helper： 
    npm install -g n 
    告诉助手（n）安装最新的稳定版Node： 
    sudo n stable 
    完成上一个命令后，您将获得最新信息。让我们再次运行安装： 
    npm install

* 删除nodejs
```
    二.卸载
1.自带工具删除
yum remove nodejs npm -y 

2.手动删除残留
进入 /usr/local/lib 删除所有 node 和 node_modules文件夹
进入 /usr/local/include 删除所有 node 和  node_modules 文件夹
进入 /usr/local/bin 删除 node 的可执行文件node和npm
检查 ~ 文件夹里面的"local"   "lib"  "include"  文件夹，然后删除里面的所有  "node" 和  "node_modules" 文件夹
```


##update node to latest version


## update and install angular/cli
> 用root账户进行安装，其他用户也能使用
npm uninstall -g @angular/cli
npm uninstall -g angular-cli
npm cache clean --force
cnpm install -g @angular/cli@latest
cnpm install --save-dev @angular/cli@latest


1）环境构建
  安装node
  安装typescript： npm install -g typescript

  ## 安装node的准备
  
  

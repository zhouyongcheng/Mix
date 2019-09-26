
## curl日常使用

## 下载文件
curl -L -O  http://www.xxx.xx/file.tar

curl --version
curl http://localhost:4001/greet
````

## 查看应用的端口
````
netstat -tunlp

````

## confirm linux versios
lsb_release -a

## add sudo user


curl -s clientId:secretId@localhost:4001/oauth/token  \
 -d grant_type=client_credentials \
 -d scope=app

## install git on linux 


# ubuntu network setting

## dhcp method
```
vi /etc/network/interfaces
auto eth0
iface eth0 inet dhcp
sudo /etc/init.d/networking restart
sudo dhclient eth0
```

## static method
auto enp2s0
iface enp2s0 inet static
address xx.xx.xx.48
netmask xx.xx.xx.0
gateway xx.xx.xx.1

broadcast xx.xx.xx.255
dns1 xx.xx.xx.110

## firewall management
```
sudo ufw status
sudo ufw disable
sudo ufw enable
sudo ufw allow/deny 8080
sudo ufw allow/deny servicename
sudo ufw delete allow/deny 20
```

NFS扩容配置

检查是否有nfs和rpc
rpm -qa nfs-utils rpcbind
没有的话就安装
yum install -y nfs-utils rpcbind


/etc/init.d/rpcbind status
/etc/init.d/nfs start
/etc/init.d/nfs status

开机自启
chkconfig nfs on
chkconfig rpcbind on
创建挂载目录
mkdir -p /data
chown -R nfsnobody.nfsnobody /data
挂载
mount -t nfs 172.20.193.33:/data /data
df -h
检查
showmount -e 172.20.193.33


mount -t nfs 172.25.216.21:/data /data

修改/etc/hosts,并立刻生效
=======
change ubuntu repository
=---------------------
sudo apt-get clean
sudo rm /var/lib/apt/lists/* -vf
将/etc/apt/sources.list文件替换为下面文件

deb http://cn.archive.ubuntu.com/ubuntu/ xenial main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse ##测试版源
deb http://cn.archive.ubuntu.com/ubuntu/ xenial-proposed main restricted universe multiverse # 源码
deb-src http://cn.archive.ubuntu.com/ubuntu/ xenial main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ xenial-updates main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse ##测试版源
deb-src http://cn.archive.ubuntu.com/ubuntu/ xenial-proposed main restricted universe multiverse

sudo apt-get update

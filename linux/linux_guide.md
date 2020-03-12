## centos修改hostname
```
1. centos6:编辑以下两个文件
/etc/hosts
/etc/sysconf/network

2. centos7:
hostnamectl --static set-hostname name
```

## ssh免密登陆
```
1. ssh-keygen -t rsa
2. ssh-copy-id -i ~/.ssh/id_rsa.pub username@nodename
```

## 软连接的创建
ln -s /data/MenuCenter file 
/data/MenuCenter  -- 已经在本地存在的目录
file : 要创建的link标识符


sed -ie 's/192.168.0.1/192.168.0.2/g' /opt/msgct/application-pro.properties

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

## 查看linux的版本信息
lsb_release -a

## centos添加sudo用户
```
1. root用户登陆
2. visudo 
3. 复制root用户的行,把root用户改为自己的用户就ok
```

# 查看防火墙状态
firewall-cmd --state

#停止firewall
systemctl stop firewalld.service

#禁止firewall开机启动
systemctl disable firewalld.service 

#关闭selinux 
vi /etc/selinux/config
将SELINUX=enforcing改为SELINUX=disabled

ntpdate asia.pool.ntp.org


## add sudo user


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


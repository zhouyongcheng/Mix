## curl日常使用

## 下载文件
curl -L -O  http://www.xxx.xx/file.tar

````
curl --version
curl http://localhost:4001/greet
````

## 查看应用的端口
````
netstat -tunlp

````

## confirm linux versios
lsb_release -a

<<<<<<< HEAD
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



=======
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
>>>>>>> a64aeaa7fd16d62e44fe5f78310504597f5f4161

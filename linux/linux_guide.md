## curl日常使用
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




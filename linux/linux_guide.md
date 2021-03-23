## windows杀进程

```powershell
netstat -ano | findstr 端口号
taskkill -PID 进程号 -F
```

安装FinalShell

```shell
rm -f finalshell_install_linux.sh;
wget www.hostbuf.com/downloads/finalshell_install_linux.sh;
chmod +x finalshell_install_linux.sh;
./finalshell_install_linux.sh;
/usr/lib/FinalShell/bin
```


ls ~/logs/rocketmqlogs/ | xargs -i rm ~/logs/rocketmqlogs/{}


创建网络连接

```shell
# 查看物理网卡的信息
nmcli device show  | grep -i device
# 删除当前的连接
nmcli connection show && nmcli connection delete enp5s0
#创建一个新的连接
nmcli connection add type ethernet autoconnect yes con-name eth0 ifname enp5s0 ip4 192.168.101.14 gw4 192.168.101.1
# 添加dns信息
nmcli connection modify eth0 ipv4.dns 10.1.1.26  +ipv4.dns 10.1.1.27
#启动
nmcli connection up eth0
#显示详细信息  
nmcli connection show
nmcli connection show eth0
systemctl restart network.service
```



## 1. 设备基础信息

```
1、查看CPU信息
# 总核数 = 物理CPU个数 X 每颗物理CPU的核数
# 总逻辑CPU数 = 物理CPU个数 X 每颗物理CPU的核数 X 超线程数

# 查看物理CPU个数
cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l

# 查看每个物理CPU中core的个数(即核数)
cat /proc/cpuinfo| grep "cpu cores"| uniq

# 查看逻辑CPU的个数
cat /proc/cpuinfo| grep "processor"| wc -l

# 查看CPU信息（型号）
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c
```
centos7 默认从KDE启动
```
# yum -y groupinstall "Graphical Administration Tools"
# yum -y groupinstall "Internet Browser"
# yum -y groupinstall "General Purpose Desktop"
# yum -y groupinstall "Office Suite and Productivity"
# yum -y groupinstall "Graphics Creation Tools"
```
echo "gnome-session" >> ~/.xinitrc
echo "exec startkde" >> ~/.xinitrc

## 2. centos修改hostname
```
1. centos6:编辑以下两个文件
/etc/hosts
192.168.101.21  node21
192.168.101.22  node22
192.168.101.23  node23

/etc/sysconf/network
NETWORKING=yes
HOSTNAME=node21

2. centos7:
hostnamectl --static set-hostname name
```

## 3. ssh免密登陆
```
1. ssh-keygen -t rsa
2. ssh-copy-id -i ~/.ssh/id_rsa.pub username@nodename

ssh-copy-id -i ~/.ssh/id_rsa.pub cmwin@node03
```

## 4. 软连接的创建
ln -s /data/MenuCenter file 
/data/MenuCenter  -- 已经在本地存在的目录
file : 要创建的link标识符


sed -ie 's/192.168.0.1/192.168.0.2/g' /opt/msgct/application-pro.properties

## 5. 防火墙

### 5.1 禁止开启防火墙

```shell
# centos6
chkconfig iptables off
chkconfig iptables on
# centos7

```

### 5.2 关闭防火墙

```shell
# centos6
service iptables stop
service iptables start
service iptables status
# centos7
systemctl enable firewalld.service
systemctl disable firewalld.service
systemctl status firewalld.service
```

## 配置环境变量的方式

```shell
# 编辑/etc/profile
# 编辑~/.bashrc
# 在/etc/profile.d/myenv.sh, 这样，每次服务器启动的时候都会加载环境变量。
```



## curl日常使用

## 下载文件
curl -L -O  http://www.xxx.xx/file.tar

curl --version
curl http://localhost:4001/greet

## 查看应用的端口

````shell
netstat -tunlp
````


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
```shell

# NFS扩容配置
# 检查是否有nfs和rpc
rpm -qa nfs-utils rpcbind
# 没有的话就安装
yum install -y nfs-utils rpcbind

/etc/init.d/rpcbind status
/etc/init.d/nfs start
/etc/init.d/nfs status

# 开机自启
chkconfig nfs on
chkconfig rpcbind on
#创建挂载目录
mkdir -p /data
chown -R nfsnobody.nfsnobody /data
#挂载
mount -t nfs 172.20.193.33:/data /data
df -h
#检查
showmount -e 172.20.193.33

mount -t nfs 172.25.216.21:/data /data
```



## ubuntu 网络管理

```shell
# ubuntu重启网络
sudo service network-manager restart
```


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

## 网络配置

```properties
# 网卡配置文件
/etc/sysconfig/network-scripts/ifcfg-eth0
# 主机名文件,修改完后需要重新启动服务器（但是可以通过hostname命令设置，临时生效，下次启动就自然好了）
/etc/sysconfig/network
#dns文件
/etc/resolv.conf
```

## 网络常用命令

```shell
# 查看本机的hostname或在临时设置hostname
hostname
# 查看dns服务器
nslookup  server
# 网络状态
netstat -tuln
# 网络耕种
traceroute
# 查看端口占用情况
lsof -i:8080
```

## sudo用户添加

```
visudo -f /ect/sudoers
myname  ALL=(ALL) NOPASSWD:ALL

```



## hostname设置

```shell
hostnamectl --static set-hostname redis-11
hostnamectl --static set-hostname redis-12
hostnamectl --static set-hostname redis-13
```

## 设备挂载

```
mount /dev/cdrom /mnt/cdrom
ls ~/logs/rocketmqlogs/ | xargs -i rm ~/logs/rocketmqlogs/{}

## 文本操作

### 批量修改路径下文件中的内容

```
sed -i "s/192.168.101.1/127.0.0.1/g" `grep 192.168.101.1 -rl ./path`

```



## 查看cup信息

```shell
# 查看物理CPU的个数
cat /proc/cpuinfo |grep "physical id"|sort |uniq|wc -l  
# 查看逻辑CPU的个数
cat /proc/cpuinfo |grep "processor"|wc -l 
# 查看CPU是几核
cat /proc/cpuinfo |grep "cores" | uniq
```

## 创建网络连接

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



## yum的使用

```shell
yum list
yum search httpd
# 更新指定的包名
yum -y update package_name
# 查询组名称。
yum grouplist
yum groupinstall group_name
yum groupremove group_name

# 不要执行全系统更新
yum -y update  # 一定不要执行
# 卸载
yum -y remove package_name

# 尽量不要装使用的软件。
# 尽量不要使用yum remove
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
mount -t nfs 192.168.101.4:/data /data
df -h
#检查
showmount -e 192.168.101.4

mount -t nfs 192.168.101.4:/data /data
```



## ubuntu 网络管理

```shell
# ubuntu重启网络
sudo service network-manager restart
```

## 虚拟机的配置

```
clone虚拟机后，需要修改网络配置项目
1）/etc/sysconfig/network-scripts/ifcfg-eth0
# 删除mac地址
2） rm -rf /etc/udev/rules.d/70-persistent-net.rules
3)reboot system
```

## putty安装

```
依赖安装：
yum -y install gcc
yum -y install gtk2-devel

# 下载源码
https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
# 解压/data/soft/putty-074
./configure --prefix=/opt/putty --exec-prefix=/opt/putty


设置前景色：224 226 228
default background ：41 49 52
default background ：39 40 34 
default background ：50 50 48 
```


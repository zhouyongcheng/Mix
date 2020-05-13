# 虚拟机的相关内容

## 注意事项

```
1、安装虚拟机后，后台运行服务，尽量移除不需要的设备，如cdrom，audio等，这样启动时不加载，避免不必要的错误。
2、虚拟机安装成后台运行模式，不要图形界面。
3、ip地址配置成固定ip地址。
4、启动的时候加 --type headless
```





## 虚机网络基本配置

````shell
1) 桥接模式
2）静态IP， 通过复制主机的/etc/sysconfig/netowrk-script/ifconfig-eth0到各个虚拟机上，修改名称和uuid,ip地址
3) 查看网卡信息
$ ip addr 
4) 生产网卡对应的uuid
$ uuidgen eth0

# /etc/sysconfig/netowrk-script/ifconfig-enp3s0配置信息
TYPE=Ethernet
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp3s0
UUID=da3f092b-d773-4cee-a128-0d92cc0e788a
DEVICE=enp3s0
ONBOOT=yes
IPADDR=192.168.101.14
NETMASK=255.255.255.0
PREFIX=24
GATEWAY=192.168.101.1
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
DNS1=192.168.101.1
DNS2=8.8.8.8
````

## 命令行启动虚拟机

```shell
# centos7设置开机启动的模式
systemctl get-default
systemctl set-default multi-user.target

# 要从远程打开和关闭虚拟机，需要虚拟机以命令行的方式启动
vim /etc/inittab
id:3:initdefault:
#------------------------------------
$ VBoxManage list vms
$ VBoxManage list runningvms # 列出运行中的虚拟机
$ VBoxManage startvm Centos6_1 --type headless  # 命令行方式启动虚拟机，无需显示器
$ VBoxManage controlvm Centos6_1 acpipowerbutton # 关闭虚拟机，等价于点击系统关闭按钮，正常关机
$ VBoxManage controlvm XP poweroff # 关闭虚拟机，等价于直接关闭电源，非正常关机
$ VBoxManage controlvm XP pause # 暂停虚拟机的运行
$ VBoxManage controlvm XP resume # 恢复暂停的虚拟机
$ VBoxManage controlvm XP savestate # 保存当前虚拟机的运行状态
```



## 命令行安装虚拟机


https://blog.csdn.net/ZYC88888/article/details/81226820


SNS_VIP=192.168.101.88
/etc/rc.d/init.d/functions
case "$1" in
start)
       ifconfig lo:0 $SNS_VIP netmask 255.255.255.255 broadcast $SNS_VIP
       /sbin/route add -host $SNS_VIP dev lo:0
       echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
       echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
       echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
       echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
       sysctl -p >/dev/null 2>&1
       echo "RealServer Start OK"
       ;;
stop)
       ifconfig lo:0 down
       route del $SNS_VIP >/dev/null 2>&1
       echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore
       echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce
       echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore
       echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce
       echo "RealServer Stoped"
       ;;
*)
       echo "Usage: $0 {start|stop}"
       exit 1
esac
exit 0

## p配置步骤
1. 配置两台lvs节点（主备关系）
2. 配置多个RS（real server）
3. keepalived是服务于LVS的。
4. keepalived是在lvs的主备服务器上启动的应用程序。
5. keepalived会检查lvs和后端服务器的健康状况。

## 安装keepalived
ipvsadm -lnc
ipvsadm -C  清除配置信息
ifconfig eth0:2 down  -- 清除虚拟ip地址，禁用

yum install keepalived
yum install ipvsadm

service keepalived start
/etc/keepalived/keepalived.conf

tail /var/log/message


配置两台lvs服务器
配置两台ftp服务器

keepalived.conf配置信息
```
-- 配置LVS 和 RS的信息
vrrp_instance VI_1 {
    state MASTER
    interface wlp4s0
    virtual_router_id 51
    priority 100           -- 权重值， master 要大于 backup
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.101.21/24 dev eth0 label eth0:3  --配置虚拟IP地址，lvs服务器一样。
    }
}

# 对virtualIP进行配置,ftp
virtual_server 192.168.101.21 21 {
    delay_loop 6
    lb_algo rr
    lb_kind DR
    nat_mask 255.255.255.0
    persistence_timeout 50
    protocol TCP

    real_server 192.168.101.3 80 {     -- ftp服务器的地址
        weight 1
        TCP_CHECK {
              connect_timeout 10
              nb_get_retry 3
               delay_before_retry 3
              connect_port 80
        }
    }
}

```

安装向导： 安装keepalived和ftp服务器
192.168.101.21
192.168.101.22

MC-1147： MC_一键停单安全性加固
MC-1198：【生产环境】售罄断货报表中原因为空
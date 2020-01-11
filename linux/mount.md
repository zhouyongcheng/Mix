## 查看当前服务器的mount信息
```
mount | grep data
mount -t nfs 192.168.0.33:/data /data
设备名称: 192.168.0.33:/data
挂载点  : /data
-t nfs 指定设备的文件系统类型(nfs:网络文件系统)
    
选项 –l 并不是马上umount，而是在该目录空闲后再umount    
umount -l /data
or
umount -l 192.168.0.33:/data
```

## 确认ftp服务的配置中，是否配置允许需要mount的服务器。 /etc/exports文件内容
```
/data 192.168.0.107(rw,sync)
/data 192.168.0.190(rw,sync)
/data 192.168.0.206(rw,sync)
/data 192.168.0.221(rw,sync)
/data 192.168.0.228(rw,sync)
/data 192.168.0.236(rw,sync)

添加完上面的内容后，需要重新reload一下使配置生效
/etc/init.d/nfs reload
```

## nfs和rpc的安装方式
yum install -y nfs-utils rpcbind

## 检查是否安装nfs和rpc
rpm -qa nfs-utils rpcbind

## 检查rpc和nfs的状态
/etc/init.d/rpcbind status
/etc/init.d/nfs status
/etc/init.d/nfs start

## 配置开机自启
chkconfig nfs on
chkconfig rpcbind on

## 创建挂载目录并挂载
mkdir -p /data
chown -R nfsnobody.nfsnobody /data
mount -t nfs 192.168.0.33:/data /data

# 检查
df -h
showmount -e 192.168.0.33

scp /opt/nginx/conf/nginx.conf.kafka mc@192.168.0.46:/opt/nginx/conf/


## unmount操作

echo "* soft nofile 204800" >> /etc/security/limits.conf
echo "* hard nofile 204800" >> /etc/security/limits.conf
echo "* soft nproc 204800" >> /etc/security/limits.conf
echo "* hard nproc 204800 " >> /etc/security/limits.conf

echo fs.file-max = 6553560 >> /etc/sysctl.conf


# doris启动命令
```shell
bin/start_fe.sh  --helper 192.168.101.4:9010 --daemon
```


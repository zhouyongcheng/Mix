[NTP address](http://www.pool.ntp.org)

vim /etc/ntpd.conf


logfile /var/log/ntpd.log
server ntp1.aliyun.com
server ntp2.aliyun.com
server ntp3.aliyun.com

server 127.0.0.1
fudge 127.0.0.1  stratum  10
ntpdate -u

## 启动时间同步进程
systemctl start ntpd
## 作为后台服务器运行
systemctl enable ntpd



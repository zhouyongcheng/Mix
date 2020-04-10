# vsftp的安装
sudo yum install vsftpd
vsftpd -v
systemctl start vsftpd
systemctl enable vsftpd

firewall-cmd --zone=public --add-port=21/tcp --permanent
firewall-cmd --zone=public --add-service=ftp --permanent
firewall-cmd --reload

firewall-cmd --zone=public --add-port=40001-40100/tcp --permanent
firewall-cmd --reload

## Configuring the FTP Server
cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig

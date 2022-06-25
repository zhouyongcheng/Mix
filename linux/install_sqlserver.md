[install_sqlserver](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-2017&preserve-view=true)

sudo yum install python2

sudo curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo

sudo yum install -y mssql-server

sudo /opt/mssql/bin/mssql-conf setup

systemctl status mssql-server

sudo firewall-cmd --zone=public --add-port=1433/tcp --permanent
sudo firewall-cmd --reload

--------------------------------------
-- install command client 
--------------------------------------

sudo curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/7/prod.repo

sqlcmd -S 192.168.101.28 -U SA -P 'Gameover_110!'


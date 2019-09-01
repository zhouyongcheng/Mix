

To remove mysql completely from your system Just type in terminal

sudo apt-get purge mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*
sudo rm -rf /etc/mysql /var/lib/mysql
sudo apt-get autoremove
sudo apt-get autoclean


cd /tmp/ && wget https://dev.mysql.com/get/mysql-apt-config_0.8.3-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.3-1_all.deb
sudo apt-get update
sudo apt-get install mysql-community-server
sudo systemctl stop mysql.service
sudo systemctl start mysql.service
sudo systemctl enable mysql.service
sudo mysql -u root -p

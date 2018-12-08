`# install rabbitmq on centos7
* sudo yum install epel-release
* sudo yum update
* sudo reboot

## Step 2: Install Erlang
````
cd ~
wget http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
sudo rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
sudo yum install erlang
erl
````

## Step 3: Install RabbitMQ
````
cd ~
wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.1/rabbitmq-server-3.6.1-1.noarch.rpm
sudo rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
sudo yum install rabbitmq-server-3.6.1-1.noarch.rpm
````

## Step 4: Modify firewall rules
````
sudo firewall-cmd --zone=public --permanent --add-port=4369/tcp --add-port=25672/tcp --add-port=5671-5672/tcp --add-port=15672/tcp  --add-port=61613-61614/tcp --add-port=1883/tcp --add-port=8883/tcp
sudo firewall-cmd --reload
````

## start the RabbitMQ server and enable it to start on system boot:
````
sudo systemctl start rabbitmq-server.service
sudo systemctl enable rabbitmq-server.service
sudo rabbitmqctl status
````

## Step 5: Enable and use the RabbitMQ management console
````
sudo rabbitmq-plugins enable rabbitmq_management
sudo chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
sudo rabbitmqctl add_user mqadmin mqadminpassword
sudo rabbitmqctl set_user_tags mqadmin administrator
sudo rabbitmqctl set_permissions -p / mqadmin ".*" ".*" ".*"
http://[your-vultr-server-IP]:15672/
````




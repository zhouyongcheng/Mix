## ubuntu添加用户
sudo adduser hadoop

## ssh localhost免密登录
```
ssh-keygen -t rsa
cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys 
```
相比 lowdb更加安全快速

借助内存进行快速访问 并且扩展性更加强大 只需要编写正确的数据库语句就可以实现

# mangodb的核心概念

```
  	数据库
  ｜---- 集合1
  ｜			｜-------文档1
  ｜			｜				 ｜--- 字段：值
  ｜			｜				
  ｜			｜-------文档2
  ｜			｜-------文档3
  ｜
  ｜---- 集合2
```

mangodb由此构成

# 安装mongodb数据库

这里按照一台ubuntu  20.04.4的VPS为例子

其他的可以查看网站

[ mongodb下载](https://www.mongodb.com/zh-cn/docs/manual/tutorial/install-mongodb-on-ubuntu/#std-label-install-mdb-community-ubuntu)

```
cat /etc/lsb-release
```

查看机器软件

```
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.4 LTS"
```

```
sudo apt-get install gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
   --dearmor
```

安装公钥

```
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```

```
sudo apt-get update
```

```
sudo apt-get install -y mongodb-org
```

## 启动服务

```
sudo systemctl start mongod
sudo systemctl status mongod
```

## 开始使用

```
mongod
```

```
mongodsh
```

```
mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.5.1
```

这里就出现了链接地址

# 开启远程访问

```
sudo vim /etc/mongod.conf
```

```
net:
  port: 27017
  bindIp: 0.0.0.0   
security:
  authorization: enabled

```

```
sudo systemctl restart mongod
sudo systemctl status  mongod
```

```
mongosh
> use admin
> db.createUser({
     user:  "remoteUser",
     pwd:   "Strong_Passw0rd!",
     roles: [{ role: "root", db: "admin" }]
   })

```

```
mongodb://账户:密码@服务器ip:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.5.1
```

如果启动失败

```
sudo rm -f /tmp/mongodb-27017.sock
```

# 基本命令

## 数据库

查看数据库

```
show dbs
```

切换数据库  如果不存在自动创建

```
ues 数据库名字
```

显示当前数据库

```
db
```

删除数据库

```
use 数据库
db.dropDatabase()
```

## 集合

创建集合

```
db.createCollection('集合名字')
```

显示当前集合

```
db.showCollections
```

删除集合

```
db.集合名字.drop()
```

重命名集合

```
db.集合名字.renameCollection('new name')
```

## 文档

插入文档

```
db.集合.insert(文档对象)
```

查询

```
db.集合.find(查询条件)
```

更新

```
db.集合名.updata({name:"张三"},{$set{age:18}})
db.集合名.updata({查询条件},{$set{更新的文档对象 }})
```

删除

```
db.集合名.remove(查询条件)
```


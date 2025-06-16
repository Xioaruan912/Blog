首先下载插件

[romote_ssh](https://marketplace.visualstudio.com/items/?itemName=ms-vscode-remote.remote-ssh)

在本地生成sshkey

```
ssh-keygen
```

将key送给远程服务器

```
ssh-copy-id -i ~/.ssh/id_rsa.pub  root@服务器IP
```

复制完毕后检验是否成功

```
ssh -i ～/.ssh/id_rsa 'root@服务器IP'
```

如果失败 则进入服务器ssh配置

```
/etc/ssh/sshd_config
```

添加如下

```
PasswordAuthentication yes
PubkeyAuthentication yes
```

同时可以修改ssh端口

```
Port 3823
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
```

然后进入vscode ssh界面

![image-20250427134210650](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250427134210650.png)

打开配置文件

```
Host VSCODE中展示的服务器名字
  HostName 服务器IP
  Port 服务器端口
  User root
  IdentityFile sshkey的路径

```

纯净如下

```
Host 
  HostName 
  Port 
  User 
  IdentityFile 

```


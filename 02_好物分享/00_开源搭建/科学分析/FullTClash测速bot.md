# 搭建



去 https://my.telegram.org/apps 申请API

去 [@BotFather](https://t.me/BotFather) 那里创建一个机器人，获得该机器人的bot_token，应形如：

bot_token = "123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"

```
apt install -y git && git clone https://github.com/AirportR/FullTclash.git && cd FullTclash
pip3 install -r requirements.txt
```

这里如果报错 就换个服务器 我在亚洲云的服务器上失败了 Claw上成功

在./resources/config.yaml（没有就创建）,在config.yaml中写入如下信息：

```
admin:
- 12345678 # 改成自己的telegram uid
- 8765431 # 这是第二行，表示第二个管理员，没有第二个管理员就把该行删除。
bot:
 api_id: 123456 #改成自己的api_id
 api_hash: 123456ABCDefg #改成自己的api_hash
 bot_token: 123456:ABCDefgh123455  # bot_token, 从 @BotFather 获取
 # 如果是在中国大陆地区使用，则程序需要代理才能连接上Telegram服务器。写入如下信息：
 proxy: 127.0.0.1:7890 #socks5 替换成自己的代理地址和端口
```

uid可以去@gagacesu_bot 查找

# 对接

如果是VLess协议就需要去后台打开short id

![image-20250831132446642](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250831132446642.png)

不然会报错

```
/new 链接 名字
```

```
/test 名字
```

这样就ok了
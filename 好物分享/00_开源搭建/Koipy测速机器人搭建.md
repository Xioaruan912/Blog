这是Fulltclash的升级 可以通过构建多后端实现测速

通过tg获取最新的 安装包

# tg机器人安装

```
mkdir koipy
cd koipy
touch config.yaml
unzip koipy-linux-amd64.zip
sudo chmod +x koipy && ./koipy 
```

填写config内容

```
license: xxxxxxxxxxx  # 激活码，必填。否则无法使用
# 如果bot需要代理：
bot:
  proxy: socks5://127.0.0.1:7890 # socks5代理
  bot-token: 123456:abcdefg # bot的token, 首次启动必填，替换你自己的
  #proxy: http://127.0.0.1:7890 # http代理也支持
  #api-id:  # telegram的 api_id 选填
  #api-hash:  # telegram的 api_hash 选填
```

koipy自带 api 所以不需要申请了

![image-20251107020621516](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251107020621516.png)

这样机器人构建成功了 现在构建后端

# 后端

https://github.com/AirportR/miaospeed/releases/tag/4.6.2

获取后端

```
./miaospeed-linux-amd64 server -bind 0.0.0.1:8765 -path miaospeed -token 123123N2e{Q?W -mtls
```

然后回去tg机器人

```
slaveConfig: # 后端配置
  slaves: # 后端列表，注意是数组类型
    - type: miaospeed # 固定值，目前只这个支持
      id: "localmiaospeed" # 后端id
      token: "123123N2e{Q?W" # 连接密码
      address: "127.0.0.1:8765" # 后端地址
      path: "/miaospeed" # websocket的连接路径，只有路径正确才能正确连接，请填写复杂的路径，防止路径被爆破。可以有效避免miaospeed服务被网络爬虫扫描到.
      skipCertVerify: true # 跳过证书验证，如果你不知道在做什么，请写此默认值
      tls: true # 启用加密连接，如果你不知道在做什么，请写此默认值
      invoker: "114514" # bot调用者，请删掉此行或者随便填一个字符串
      buildtoken: "MIAOKO4|580JxAo049R|GEnERAl|1X571R930|T0kEN" # 默认编译token  如果你不知道在做什么，请写此默认值
      comment: "本地miaospeed后端" # 后端备注，显示在bot页面的
      hidden: false # 是否隐藏此后端
      option: # 可选配置
        downloadDuration: 8 # 测试时长
        downloadThreading: 4 # 测速线程
        downloadURL: https://dl.google.com/dl/android/studio/install/3.4.1.0/android-studio-ide-183.5522156-windows.exe # 测速文件
        pingAddress: https://cp.cloudflare.com/generate_204 # 延迟测试地址
        pingAverageOver: 3 # ping多少次取平均
        stunURL: udp://stun.ideasip.com:3478 # STUN地址，测udp连通性的
        taskRetry: 3 # 后端任务重试
```


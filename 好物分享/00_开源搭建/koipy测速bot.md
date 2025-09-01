类似FullTClash的更新版本

```
https://koipy.gitbook.io/koipy/ji-huo
```

# 搭建

依旧获取bot 的token

```
apt install wget curl ca-certificates
bash <(curl -sL https://raw.githubusercontent.com/detesion/get-koipy/refs/heads/main/koipy-docker.sh)
```

本次为闭源

```
#config.yaml
network: # 网络
  httpProxy: "http://host:port" # http代理，如果设置的话，bot会用这个拉取订阅
  socks5Proxy: "socks5://host:port" # socks5代理， bot的代理在下面bot那一栏填
# 如果bot需要代理：
bot:
  proxy: socks5://127.0.0.1:11112 # socks5代理
  bot-token: 123456:abcdefg # bot的token, 首次启动必填，替换你自己的
  #proxy: http://127.0.0.1:11112 # http代理也支持
  #api-id:  # telegram的 api_id 选填
  #api-hash:  # telegram的 api_hash 选填


```


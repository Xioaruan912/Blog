尝试探索通过clash配合Burp抓包

```
mixed-port: 7890
allow-lan: true
bind-address: '*'
mode: global
log-level: info
external-controller: '127.0.0.1:9090'

proxies:
  - name: local-http
    type: http
    server: 127.0.0.1
    port: 8080

proxy-groups:
  - name: 🔄XBoard
    type: select
    proxies:
      - local-http

rules:
  - MATCH,🔄XBoard

```

这个是最简单的配置文件 后期可以单独添加rules

```
mixed-port: 7890
allow-lan: true
mode: rule
log-level: info
bind-address: "*"
external-controller: "127.0.0.1:9090"

proxies:
  - name: burp-proxy
    type: http
    server: 127.0.0.1
    port: 8080

proxy-groups:
  - name: "抓包代理"
    type: select
    proxies:
      - burp-proxy
      - DIRECT

rules:
  # 🎯 手动添加你要抓包的目标域名
  - DOMAIN-SUFFIX,example.com,抓包代理
  - DOMAIN-KEYWORD,wechat,抓包代理
  - DOMAIN-KEYWORD,google,抓包代理
  - DOMAIN-KEYWORD,bing,抓包代理
  - DOMAIN-KEYWORD,baidu,抓包代理

  # 🍪 如果要抓 APP 流量，也可以加 IP-CIDR 或 PROCESS-NAME（Clash Meta 支持）
  # - PROCESS-NAME,chrome.exe,抓包代理
  # - PROCESS-NAME,firefox.exe,抓包代理

  # 🌐 其余走直连
  - MATCH,DIRECT

```

例如我尝试抓取wegame 那么我可以通过

```
mixed-port: 7890
allow-lan: true
mode: rule
log-level: info

dns:
  enable: true
  listen: 0.0.0.0:53
  enhanced-mode: fake-ip
  nameserver:
    - 223.5.5.5
    - 8.8.8.8
  fake-ip-range: 198.18.0.1/16

tun:
  enable: true
  stack: system # 适合 Windows，macOS 也支持
  dns-hijack:
    - 198.18.0.2:53
  auto-route: true
  auto-detect-interface: true

proxies:
  - name: "Burp"
    type: http
    server: 127.0.0.1
    port: 8080

proxy-groups:
  - name: PROXY
    type: select
    proxies:
      - Burp
      - DIRECT

rules:
  # 按进程名精确匹配（需要 Clash.Meta）
  - PROCESS-NAME,WeGame.exe,PROXY
  - PROCESS-NAME,DeltaForceClient.exe,PROXY

  # 按域名匹配
  - DOMAIN-SUFFIX,wegame.qq.com,PROXY
  - DOMAIN-SUFFIX,gtimg.com,PROXY
  - DOMAIN-SUFFIX,myapp.com,PROXY
  - DOMAIN-SUFFIX,tencent.com,PROXY
  - DOMAIN-KEYWORD,wegame,PROXY

  # 常见腾讯云 IP 段匹配
  - IP-CIDR,203.205.128.0/17,PROXY
  - IP-CIDR,183.3.0.0/16,PROXY
  - IP-CIDR,119.147.0.0/16,PROXY
  - IP-CIDR,182.254.0.0/16,PROXY
  - IP-CIDR,157.255.0.0/16,PROXY
  - IP-CIDR,49.51.0.0/16,PROXY

  # 兜底
  - MATCH,DIRECT

```

进行


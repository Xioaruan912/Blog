# 声明

```
通过研究细节 从而分析反制手段
```

# Xboard安装

我是通过docker自动安装

## docker

```
curl -sSL https://get.docker.com | bash

# For CentOS systems, also run:
systemctl enable docker
systemctl start docker
git clone -b compose --depth 1 https://github.com/cedar2025/Xboard
cd Xboard
```

```
docker compose run -it --rm \
    -e ENABLE_SQLITE=true \
    -e ENABLE_REDIS=true \
    -e ADMIN_ACCOUNT=admin@demo.com \
    web php artisan xboard:install
```

```
docker compose run -it --rm web php artisan xboard:install
```

```
docker compose up -d
```

默认端口：7001

# 配合XrayR

```
#!/bin/bash
clear
echo "-------------安装--------------"
echo "请选择操作："
echo "【1】一键安装shadow"
echo "【2】一键安装x-ui(推荐)"
echo "【3】一键安装XrayR(推荐)"
echo "【4】一键安装Xboard 节点管理系统"
echo "【5】一键安装 Alist"
echo "【6】添加nginx"
echo "【7】一键安装MySQL"
echo
echo "-------------日志--------------"
echo "【8】检查shadowsocks-libev服务状态"
echo "【9】查看shadowsocks-libev服务日志"
echo "【10】查看x-ui服务日志"
read -p "请输入选项： " input

if [ "$input" == "1" ]; then
    # 安装shadowsocks-libev的步骤省略
    echo "shadowsocks-libev安装步骤"
elif [ "$input" == "2" ]; then
    echo "一键安装x-ui"
    apt update -y 
    apt install curl wget -y
    bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/master/install.sh) 
    clear
    echo "安装成功"
    echo "使用文档：https://v2rayssr.com/reality.html" 
    echo "选择 8  查看面板信息"
    x-ui
elif [ "$input" == "3" ]; then
    echo "一键安装XrayR"
    apt update -y 
    apt install curl wget -y
    bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)
    clear

    # 请求用户输入NodeID、节点类型、ApiHost和ApiKey
    read -p "请输入NodeID: " ID
    echo "节点类型  V2ray, Vmess, Vless, Shadowsocks, Trojan, Shadowsocks-Plugin"
    read -p "请输入节点类型: " NoteID
    read -p "请输入ApiHost(面板地址): " ApiHost
    read -p "请输入ApiKey(面板通信密钥): " ApiKey

    # 使用用户输入的信息替换配置文件
    sudo bash -c "cat <<EOF > /etc/XrayR/config.yml
Log:
  Level: warning # Log level: none, error, warning, info, debug
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/rouating.html for help
InboundConfigPath: # /etc/XrayR/custom_inbound.json # Path to custom inbound config, check https://xtls.github.io/config/inbound.html for help
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnectionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 30 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB
Nodes:
  - PanelType: \"NewV2board\" # Panel type: SSpanel, NewV2board, PMpanel, Proxypanel, V2RaySocks, GoV2Panel, BunPanel
    ApiConfig:
      ApiHost: \"${ApiHost}\"
      ApiKey: \"${ApiKey}\"
      NodeID: $ID
      NodeType: $NoteID # Node type: V2ray, Vmess, Vless, Shadowsocks, Trojan, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: true  # Enable Vless for V2ray Type
      VlessFlow: \"xtls-rprx-vision\" # Only support vless
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 0 # Local settings will replace remote settings, 0 means disable
      RuleListPath: # /etc/XrayR/rulelist Path to local rulelist file
      DisableCustomConfig: false # disable custom config for sspanel
    ControllerConfig:
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      AutoSpeedLimitConfig:
        Limit: 0 # Warned speed. Set to 0 to disable AutoSpeedLimit (mbps)
        WarnTimes: 0 # After (WarnTimes) consecutive warnings, the user will be limited. Set to 0 to punish overspeed user immediately.
        LimitSpeed: 0 # The speedlimit of a limited user (unit: mbps)
        LimitDuration: 0 # How many minutes will the limiting last (unit: minute)
      GlobalDeviceLimitConfig:
        Enable: false # Enable the global device limit of a user
        RedisNetwork: tcp # Redis protocol, tcp or unix
        RedisAddr: 127.0.0.1:6379 # Redis server address, or unix socket path
        RedisUsername: # Redis username
        RedisPassword: YOUR PASSWORD # Redis password
        RedisDB: 0 # Redis DB
        Timeout: 5 # Timeout for redis request
        Expiry: 60 # Expiry time (second)
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        - SNI: # TLS SNI(Server Name Indication), Empty for any
          Alpn: # Alpn, Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback, check https://xtls.github.io/config/features/fallback.html for details.
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for disable
      DisableLocalREALITYConfig: true # disable local reality config
      EnableREALITY: true # Enable REALITY
      REALITYConfigs:
        Show: true # Show REALITY debug
        Dest: www.amazon.com:443 # Required, Same as fallback
        ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for disable
        ServerNames: # Required, list of available serverNames for the client, * wildcard is not supported at the moment.
          - www.amazon.com
        PrivateKey: YOUR_PRIVATE_KEY # Required, execute './XrayR x25519' to generate.
        MinClientVer: # Optional, minimum version of Xray client, format is x.y.z.
        MaxClientVer: # Optional, maximum version of Xray client, format is x.y.z.
        MaxTimeDiff: 0 # Optional, maximum allowed time difference, unit is in milliseconds.
        ShortIds: # Required, list of available shortIds for the client, can be used to differentiate between different clients.
          - \"\"
          - 0123456789abcdef
      CertConfig:
        CertMode: dns # Option about how to get certificate: none, file, http, tls, dns. Choose \"none\" will forcedly disable the tls config.
        CertDomain: \"node1.test.com\" # Domain to cert
        CertFile: /etc/XrayR/cert/node1.test.com.cert # Provided if the CertMode is file
        KeyFile: /etc/XrayR/cert/node1.test.com.key
        Provider: alidns # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          ALICLOUD_ACCESS_KEY: aaa
          ALICLOUD_SECRET_KEY: bbb
EOF"
    sudo XrayR restart
    echo "XrayR配置完成，NodeID已设置为$ID"
    echo "ApiHost已设置为: $ApiHost"
    echo "ApiKey已设置为: $ApiKey"
elif [ "$input" == "4" ]; then
    # 检查 Docker 是否已安装
    if command -v docker >/dev/null 2>&1; then
        echo "Docker 已经安装，跳过安装"
    else
        echo "Docker 未安装，开始安装"
        curl -sSL https://get.docker.com | bash
        systemctl enable docker
        systemctl start docker
    fi

    # 确保 git 已安装
    apt install git -y

    # 克隆 Xboard 仓库并安装
    git clone -b docker-compose --depth 1 https://github.com/cedar2025/Xboard
    cd Xboard
    clear

    # 运行 Xboard 安装
    docker compose run -it --rm xboard php artisan xboard:install
    docker compose up -d

    # 获取外网 IP
    IP=$(curl -s ifconfig.me)
    echo "Xboard 节点管理系统安装成功"
    echo "访问 http://$IP:7001"

elif [ "$input" == "5" ]; then
    echo "一键安装 Alist"
    curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s install
    echo "Alist 安装完成"
    cd /opt/alist
    read -p "请输入设置的密码： " PASSWORD
    ./alist admin set $PASSWORD
elif [ "$input" == "6" ]; then
    echo "添加nginx"
    apt install nginx -y
    mkdir -p /etc/nginx/cert
    echo "请输入完整的公钥内容，然后输入Ctrl+D保存："
    cat > /etc/nginx/cert/cert.pem

    # 处理多行私钥输入
    echo "请输入完整的私钥内容，然后输入Ctrl+D保存："
    cat > /etc/nginx/cert/key.pem

    read -p "请输入服务 IP 和端口（例如：http://127.0.0.1:8080）：" IP
    read -p "请输入域名地址：" domain
   
    # 删除 nginx.conf 的旧配置，从第 6 行开始删除所有行
    sudo sed -i '6,$d' /etc/nginx/nginx.conf

    # 定义新的 nginx 配置
    nginx_config="events {
        worker_connections 1024;
    }

    http {
        client_max_body_size 1000m;

        server {
            listen 80;
            server_name $domain;
            return 301 https://\$host\$request_uri;
        }
 
        server {
           listen 443 ssl http2;
           server_name $domain;
           ssl_certificate /etc/nginx/cert/cert.pem;
           ssl_certificate_key /etc/nginx/cert/key.pem;

            location / {
                proxy_pass $IP;
                proxy_http_version 1.1;
                proxy_set_header Upgrade \$http_upgrade;
                proxy_set_header Connection \"Upgrade\";
                proxy_set_header Host \$host;
            }
        }
    }"

    # 使用 printf 保持格式输出到 nginx 配置文件
    printf "%s\n" "$nginx_config" | sudo tee -a /etc/nginx/nginx.conf


    nginx -t
    nginx -s reload
    echo "nginx 安装并配置完成"
elif [ "$input" == "7" ]; then
    echo "一键安装 MySQL"
    apt update -y
    apt install mysql-server -y
    read -p "输入数据库密码：" pwd
    sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$pwd'; FLUSH PRIVILEGES;"

    read -p "输入创建的数据库:" data
    mysql -u root -p$pwd -e "CREATE DATABASE $data;"
    sudo sed -i 's/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
    echo "运行如下开启远程访问： 
CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '$pwd';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"
    echo "MySQL 安装完成"
elif [ "$input" == "8" ]; then
    sudo systemctl status shadowsocks-libev
elif [ "$input" == "9" ]; then
    sudo journalctl -u shadowsocks-libev.service -f
elif [ "$input" == "10" ]; then
    x-ui status
else
    echo "无效的选项，程序退出。"
fi
```

使用脚本即可

## 备份

使用docker命令进入容器

```shell
docker exec -it  DOCKER_ID /bin/sh
tar czf /tmp/data.tar.gz -C /www/ .docker
docker cp 容器ID:/tmp/data.tar.gz /home/youruser/backup/data.tar.gz

```

## 恢复

```
docker cp /home/youruser/backup/data.tar.gz cf6fba019a02:/tmp/data.tar.gz
docker exec -it cf6fba019a02 /bin/sh
mkdir -p /www/.docker
tar xzf /tmp/data.tar.gz -C /www/.docker --strip-components=1
```



```
只需要备份database.sqlite就行
目录在.docker/.data/
可以直接把这个目录备份就行
```

```
cd .docker/.data/
ls
```

```
database.sqlite  redis
```

# Clash配置

新版本可以在后台进行配置文件修改

![image-20250427135922656](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250427135922656.png)

如果为旧版本

需要进入docker 容器中 使用vscode可以简易进行操作

```
/www/resources/ruls/
```

![image-20250427140059999](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250427140059999.png)

## GPT分流美国

首先正则化匹配美国节点 

```
proxy-groups:
  - { name: "$app_name", type: select, proxies: ["自动选择", "故障转移"] }
  - { name: "自动选择", type: url-test, proxies: [], url: "http://www.gstatic.com/generate_204", interval: 86400 }
  - { name: "故障转移", type: fallback, proxies: [], url: "http://www.gstatic.com/generate_204", interval: 7200 }
  - { name: "USA", type: select, proxies: [/USA/] } 
```

![image-20250427140156854](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250427140156854.png)

或者实现url_test 自动选择最好的节点

```
  - { name: "USA", type: url-test, proxies: [/USA/],url: "http://chatgpt.com", interval: 86400 } 
```

然后对GPT的网站指定代理组

```
  - DOMAIN,hackthebox.com,USA
  - DOMAIN,ip.sb,USA
  - DOMAIN,ipv4.ip.sb,USA
  - DOMAIN,ab.chatgpt.com,USA
  - DOMAIN,chatgpt.com,USA
  - DOMAIN,platform.openai.com,USA
  - DOMAIN,openai.com,USA
  - DOMAIN,cdn.openai.com,USA
  - DOMAIN,api.openai.com,USA
```

可以访问ip.sb看看是不是分流成功

这样 clash选择策略 ->自动选择 

访问GPT网站即可实现美国节点访问

可以在clash链接中查看是否生效

![image-20250427140347338](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250427140347338.png)

可以在美国代理组中选择节点

![image-20250427140434113](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250427140434113.png)

# 最终配置文件

```
mixed-port: 7890
allow-lan: true
bind-address: '*'
mode: rule
log-level: info
external-controller: '127.0.0.1:9090'
dns:
  enable: true
  ipv6: true
  enhanced-mode: fake-ip
  listen: 53
  fake-ip-range: 198.18.0.1/16
  fake-ip-filter:
  - '*.lan'
  - '*.localdomain'
  - '*.example'
  - '*.invalid'
  - '*.localhost'
  - '*.test'
  - '*.local'
  - '*.home.arpa'
  - time.*.com
  - time.*.gov
  - time.*.edu.cn
  - time.*.apple.com
  - time1.*.com
  - time2.*.com
  - time3.*.com
  - time4.*.com
  - time5.*.com
  - time6.*.com
  - time7.*.com
  - ntp.*.com
  - ntp1.*.com
  - ntp2.*.com
  - ntp3.*.com
  - ntp4.*.com
  - ntp5.*.com
  - ntp6.*.com
  - ntp7.*.com
  - '*.time.edu.cn'
  - '*.ntp.org.cn'
  - +.pool.ntp.org
  - time1.cloud.tencent.com
  - music.163.com
  - '*.music.163.com'
  - '*.126.net'
  - musicapi.taihe.com
  - music.taihe.com
  - songsearch.kugou.com
  - trackercdn.kugou.com
  - '*.kuwo.cn'
  - api-jooxtt.sanook.com
  - api.joox.com
  - joox.com
  - y.qq.com
  - '*.y.qq.com'
  - streamoc.music.tc.qq.com
  - mobileoc.music.tc.qq.com
  - isure.stream.qqmusic.qq.com
  - dl.stream.qqmusic.qq.com
  - aqqmusic.tc.qq.com
  - amobile.music.tc.qq.com
  - '*.xiami.com'
  - '*.music.migu.cn'
  - music.migu.cn
  - '*.msftconnecttest.com'
  - '*.msftncsi.com'
  - msftconnecttest.com
  - msftncsi.com
  - localhost.ptlogin2.qq.com
  - localhost.sec.qq.com
  - +.srv.nintendo.net
  - +.stun.playstation.net
  - xbox.*.microsoft.com
  - '*.*.xboxlive.com'
  - +.battlenet.com.cn
  - +.wotgame.cn
  - +.wggames.cn
  - +.wowsgame.cn
  - +.wargaming.net
  - proxy.golang.org
  - stun.*.*
  - stun.*.*.*
  - +.stun.*.*
  - +.stun.*.*.*
  - +.stun.*.*.*.*
  - heartbeat.belkin.com
  - '*.linksys.com'
  - '*.linksyssmartwifi.com'
  - '*.router.asus.com'
  - mesu.apple.com
  - swscan.apple.com
  - swquery.apple.com
  - swdownload.apple.com
  - swcdn.apple.com
  - swdist.apple.com
  - lens.l.google.com
  - stun.l.google.com
  - +.nflxvideo.net
  - '*.square-enix.com'
  - '*.finalfantasyxiv.com'
  - '*.ffxiv.com'
  - '*.mcdn.bilivideo.cn'
  - WORKGROUP
  default-nameserver:
  - 223.5.5.5
  - 119.29.29.29
  nameserver:
  - system
  - 223.5.5.5
  - 119.29.29.29
  - https://223.5.5.5/dns-query
  - https://223.6.6.6/dns-query
  - https://1.12.12.12/dns-query
  - https://120.53.53.53/dns-query
  nameserver-policy: null
  fallback: null
  fallback-filter: null
proxies:

proxy-groups:
  - { name: "🔄$app_name", type: select, proxies: ["自动选择", "故障转移", "负载均衡"] }
  - { name: "💬ChatGPT", type: url-test, proxies: [/USA/],
      url: "https://chat.openai.com",
      interval: 600, timeout: 3000, tolerance: 80 }
  - { name: "🎬Netflix", type: select, proxies: [/SG/, /JP/] }
  - { name: "自动选择", type: url-test, proxies: [],
      url: "https://www.gstatic.com/generate_204",
      interval: 300, timeout: 3000, tolerance: 80 }
  - { name: "故障转移", type: fallback, proxies: [],
      url: "https://www.gstatic.com/generate_204",
      interval: 600, timeout: 3000 }
  - { name: "负载均衡", type: load-balance, proxies: [/USA/,/HK/,/TW/, /SG/, /JP/],
      url: "https://www.gstatic.com/generate_204",
      interval: 300, strategy: round-robin }
rules:
  - DOMAIN-SUFFIX,dns.alidns.com,🔄$app_name
  - DOMAIN-SUFFIX,doh.pub,🔄$app_name
  - DOMAIN-SUFFIX,114dns.com,🔄$app_name
  - DOMAIN-SUFFIX,dns.tencent.com,🔄$app_name
  - DOMAIN-SUFFIX,dnspai.com,🔄$app_name
  - DOMAIN-SUFFIX,sdns.cn,🔄$app_name
  - DOMAIN-SUFFIX,linux.do,🔄$app_name
  - DOMAIN-SUFFIX,nodeseek.com,🔄$app_name
  - DOMAIN-SUFFIX,telegram.org,🔄$app_name
  - DOMAIN-SUFFIX,t.me,🔄$app_name
  - DOMAIN,core.telegram.org,🔄$app_name
  - DOMAIN,telegram.me,🔄$app_name
  - IP-CIDR,91.108.4.0/22,🔄$app_name,no-resolve
  - IP-CIDR,91.108.8.0/21,🔄$app_name,no-resolve
  - IP-CIDR,91.108.16.0/22,🔄$app_name,no-resolve
  - IP-CIDR,91.108.56.0/22,🔄$app_name,no-resolve
  - IP-CIDR,149.154.160.0/20,🔄$app_name,no-resolve
  - IP-CIDR6,2001:b28:f23d::/48,🔄$app_name,no-resolve
  - IP-CIDR6,2001:67c:4e8::/48,🔄$app_name,no-resolve
  - DOMAIN-SUFFIX,tiktok.com,🎬Netflix
  - DOMAIN-SUFFIX,tiktokv.com,🎬Netflix
  - DOMAIN-SUFFIX,tik-tokapi.com,🎬Netflix
  - DOMAIN-SUFFIX,muscdn.com,🎬Netflix
  - DOMAIN-SUFFIX,playstation.net,DIRECT
  - DOMAIN-SUFFIX,miHoYo.com,DIRECT
  - DOMAIN-SUFFIX,game.qq.com,DIRECT
  - DOMAIN-SUFFIX,game.weibo.cn,DIRECT
  - DOMAIN-SUFFIX,biligame.com,DIRECT
  - DOMAIN-SUFFIX,netease.com,DIRECT
  - DOMAIN-SUFFIX,youtube.com,🔄$app_name
  - DOMAIN-SUFFIX,ytimg.com,🔄$app_name
  - DOMAIN-SUFFIX,youtu.be,🔄$app_name
  - DOMAIN,i.ytimg.com,🔄$app_name
  - DOMAIN,r1---sn-*.googlevideo.com,🔄$app_name
  - DOMAIN-SUFFIX,googlevideo.com,🔄$app_name
  - DOMAIN-SUFFIX,ytimg.com,REJECT
  - DOMAIN-SUFFIX,youtube.com,REJECT
  - DOMAIN,video-stats.video.google.com,REJECT
  - DOMAIN,ad.doubleclick.net,REJECT
  - DOMAIN,advertising.googleapis.com,REJECT
  - DOMAIN,pubads.g.doubleclick.net,REJECT
  - DOMAIN-SUFFIX,video.google.com,REJECT
  - DOMAIN,partner.googleadservices.com,REJECT
  - DOMAIN,content.googleapis.com,REJECT

  - IP-CIDR,64.233.160.0/19,REJECT,no-resolve
  - IP-CIDR,64.233.172.0/24,REJECT,no-resolve
  # 🎬Netflix
  - DOMAIN-SUFFIX,acconunkit.com,🎬Netflix
  - DOMAIN-SUFFIX,atdmt.com,🎬Netflix
  - DOMAIN-SUFFIX,atlassolutions.com,🎬Netflix
  - DOMAIN-SUFFIX,facebook.com,🎬Netflix
  - DOMAIN-SUFFIX,facebook.net,🎬Netflix
  - DOMAIN-SUFFIX,facebookmail.com,🎬Netflix
  - DOMAIN-SUFFIX,fb.com,🎬Netflix
  - DOMAIN-SUFFIX,fb.gg,🎬Netflix
  - DOMAIN-SUFFIX,fbcdn.net,🎬Netflix
  - DOMAIN-SUFFIX,fb.watch,🎬Netflix
  - DOMAIN-SUFFIX,fbsbx.com,🎬Netflix
  - DOMAIN-SUFFIX,fbwat.ch,🎬Netflix
  - DOMAIN-SUFFIX,parse.com,🎬Netflix
  - DOMAIN-SUFFIX,ai.com,💬ChatGPT 
  - DOMAIN-SUFFIX,api.revenuecat.com,💬ChatGPT
  - DOMAIN-SUFFIX,browser-intake-datadoghq.com,💬ChatGPT
  - DOMAIN-SUFFIX,chatgpt.com,💬ChatGPT
  - DOMAIN-SUFFIX,chat.openai.com,💬ChatGPT
  - DOMAIN-SUFFIX,auth0.openai.com,💬ChatGPT
  - DOMAIN-SUFFIX,cdn.openai.com,💬ChatGPT
  - DOMAIN-SUFFIX,oaistatic.com,💬ChatGPT
  - DOMAIN-SUFFIX,oaiusercontent.com,💬ChatGPT
  - DOMAIN-SUFFIX,openai.com,💬ChatGPT
  - DOMAIN-SUFFIX,openaiapi-site.azureedge.net,💬ChatGPT
  - DOMAIN-SUFFIX,openaicom.imgix.net,💬ChatGPT
  - DOMAIN-SUFFIX,openaicomproductionae4b.blob.core.windows.net,💬ChatGPT
  - DOMAIN-SUFFIX,openaicom-api-bdcpf8c6d2e9atf6.z01.azurefd.net,💬ChatGPT
  - DOMAIN-SUFFIX,ingest.sentry.io,💬ChatGPT
  - DOMAIN-SUFFIX,ios.chat.openai.com.cdn.cloudflare.net,💬ChatGPT
  - DOMAIN-SUFFIX,client.crisp.chat,💬ChatGPT
  - DOMAIN-SUFFIX,o33249.ingest.sentry.io,💬ChatGPT
  # Instagram
  - DOMAIN-SUFFIX,instagram.com,🎬Netflix
  - DOMAIN-SUFFIX,cdninstagram.com,🎬Netflix
  - DOMAIN-SUFFIX,github.com,🎬Netflix
  - DOMAIN-SUFFIX,githubassets.com,🎬Netflix
  - DOMAIN-SUFFIX,githubusercontent.com,🎬Netflix
  - DOMAIN-SUFFIX,ghcr.io,🎬Netflix
  - DOMAIN-SUFFIX,github.io,🎬Netflix
  - DOMAIN-SUFFIX,githubapp.com,🎬Netflix
# 🎬Netflix
  - DOMAIN-SUFFIX,netflix.com,🎬Netflix
  - DOMAIN-SUFFIX,netflix.net,🎬Netflix
  - DOMAIN-SUFFIX,nflxext.com,🎬Netflix
  - DOMAIN-SUFFIX,nflximg.com,🎬Netflix
  - DOMAIN-SUFFIX,nflximg.net,🎬Netflix
  - DOMAIN-SUFFIX,nflxso.net,🎬Netflix
  - DOMAIN-SUFFIX,nflxvideo.net,🎬Netflix
  - DOMAIN-SUFFIX,netflixdnstest0.com,🎬Netflix
  - DOMAIN-SUFFIX,netflixdnstest1.com,🎬Netflix
  - DOMAIN-SUFFIX,netflixdnstest2.com,🎬Netflix
  - DOMAIN-SUFFIX,netflixdnstest3.com,🎬Netflix
  - DOMAIN-SUFFIX,netflixdnstest4.com,🎬Netflix
  - DOMAIN-SUFFIX,netflixdnstest5.com,🎬Netflix
  - DOMAIN-SUFFIX,netflixdnstest6.com,🎬Netflix
  - DOMAIN-SUFFIX,netflixdnstest7.com,🎬Netflix
  - DOMAIN-SUFFIX,netflixdnstest8.com,🎬Netflix
  - DOMAIN-SUFFIX,netflixdnstest9.com,🎬Netflix
  - DOMAIN-KEYWORD,apiproxy-http,🎬Netflix
  - DOMAIN-KEYWORD,ichnaea-web-,🎬Netflix
  - IP-CIDR,23.246.0.0/18,🎬Netflix,no-resolve
  - IP-CIDR,37.77.184.0/21,🎬Netflix,no-resolve
  - IP-CIDR,45.57.0.0/17,🎬Netflix,no-resolve
  - IP-CIDR,64.120.128.0/17,🎬Netflix,no-resolve
  - IP-CIDR,66.197.128.0/17,🎬Netflix,no-resolve
  - IP-CIDR,108.175.32.0/20,🎬Netflix,no-resolve
  - IP-CIDR,192.173.64.0/18,🎬Netflix,no-resolve
  - IP-CIDR,198.38.96.0/19,🎬Netflix,no-resolve
  - IP-CIDR,198.45.48.0/20,🎬Netflix,no-resolve
  - IP-CIDR,103.87.204.0/22,🎬Netflix,no-resolve
  - IP-CIDR,185.2.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,185.9.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,207.45.72.0/22,🎬Netflix,no-resolve
  - IP-CIDR,208.75.76.0/22,🎬Netflix,no-resolve
  - IP-CIDR,52.89.124.203/32,🎬Netflix,no-resolve
  - IP-CIDR,54.148.37.5/32,🎬Netflix,no-resolve
  - IP-CIDR,69.53.224.0/19,🎬Netflix,no-resolve
  - IP-CIDR,103.148.240.0/24,🎬Netflix,no-resolve
  - IP-CIDR,103.164.7.0/24,🎬Netflix,no-resolve
  - IP-CIDR,159.221.224.0/22,🎬Netflix,no-resolve
  - IP-CIDR,159.221.244.0/22,🎬Netflix,no-resolve
  - IP-CIDR,185.159.140.0/24,🎬Netflix,no-resolve
  - IP-CIDR,185.16.228.0/22,🎬Netflix,no-resolve
  - IP-CIDR,195.177.72.0/22,🎬Netflix,no-resolve
  - IP-CIDR,195.47.253.0/24,🎬Netflix,no-resolve
  - IP-CIDR,31.223.224.0/21,🎬Netflix,no-resolve
  - IP-CIDR,103.149.180.0/24,🎬Netflix,no-resolve
  - IP-CIDR,203.116.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,203.198.0.0/20,🎬Netflix,no-resolve
  - IP-CIDR,203.198.80.0/21,🎬Netflix,no-resolve
  - IP-CIDR,203.75.84.0/24,🎬Netflix,no-resolve
  - IP-CIDR,203.83.220.0/22,🎬Netflix,no-resolve
  - IP-CIDR,207.45.73.0/24,🎬Netflix,no-resolve
  - IP-CIDR,218.102.32.0/19,🎬Netflix,no-resolve
  - IP-CIDR,219.76.0.0/17,🎬Netflix,no-resolve
  - IP-CIDR,23.78.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,34.192.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,34.208.0.0/12,🎬Netflix,no-resolve
  - IP-CIDR,34.248.0.0/13,🎬Netflix,no-resolve
  - IP-CIDR,35.160.0.0/13,🎬Netflix,no-resolve
  - IP-CIDR,37.77.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,38.72.126.0/24,🎬Netflix,no-resolve
  - IP-CIDR,44.224.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,44.230.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,52.0.0.0/15,🎬Netflix,no-resolve
  - IP-CIDR,52.10.0.0/15,🎬Netflix,no-resolve
  - IP-CIDR,52.12.0.0/15,🎬Netflix,no-resolve
  - IP-CIDR,52.22.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,52.24.0.0/14,🎬Netflix,no-resolve
  - IP-CIDR,52.32.0.0/14,🎬Netflix,no-resolve
  - IP-CIDR,52.40.0.0/14,🎬Netflix,no-resolve
  - IP-CIDR,52.5.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,52.54.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,52.7.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,52.71.40.0/16,🎬Netflix,no-resolve
  - IP-CIDR,52.72.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,52.88.0.0/15,🎬Netflix,no-resolve
  - IP-CIDR,54.0.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,54.148.0.0/15,🎬Netflix,no-resolve
  - IP-CIDR,54.175.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,54.186.0.0/15,🎬Netflix,no-resolve
  - IP-CIDR,54.188.0.0/15,🎬Netflix,no-resolve
  - IP-CIDR,54.213.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,54.214.128.0/17,🎬Netflix,no-resolve
  - IP-CIDR,54.68.0.0/15,🎬Netflix,no-resolve
  - IP-CIDR,54.85.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,54.86.0.0/16,🎬Netflix,no-resolve
  - IP-CIDR,8.41.4.0/24,🎬Netflix,no-resolve
  # 自定义规则
# 不需要代理的规则 (中国网站/PRC Web)

  - IP-CIDR,185.188.32.0/24,DIRECT,no-resolve
  - IP-CIDR,185.188.33.0/24,DIRECT,no-resolve
  - IP-CIDR,185.188.34.0/24,DIRECT,no-resolve
  - IP-CIDR,185.188.35.0/24,DIRECT,no-resolve
  - IP-CIDR6,2a0b:b580::/48,DIRECT,no-resolve
  - IP-CIDR6,2a0b:b581::/48,DIRECT,no-resolve
  - IP-CIDR6,2a0b:b582::/48,DIRECT,no-resolve
  - IP-CIDR6,2a0b:b583::/48,DIRECT,no-resolve
  - IP-CIDR,182.254.116.0/24,DIRECT,no-resolve
  - DOMAIN-SUFFIX,12306.cn,DIRECT
  - DOMAIN-SUFFIX,12306.com,DIRECT
  - DOMAIN-SUFFIX,126.net,DIRECT
  - DOMAIN-SUFFIX,163.com,DIRECT
  - DOMAIN-SUFFIX,21cn.com,DIRECT
  - DOMAIN-SUFFIX,360.cn,DIRECT
  - DOMAIN-SUFFIX,360.com,DIRECT
  - DOMAIN-SUFFIX,360buy.com,DIRECT
  - DOMAIN-SUFFIX,360buyimg.com,DIRECT
  - DOMAIN-SUFFIX,36kr.com,DIRECT
  - DOMAIN-SUFFIX,51ym.me,DIRECT
  - DOMAIN-SUFFIX,58.com,DIRECT
  - DOMAIN-SUFFIX,71.am.com,DIRECT
  - DOMAIN-SUFFIX,8686c.com,DIRECT
  - DOMAIN-SUFFIX,abercrombie.com,DIRECT
  - DOMAIN-SUFFIX,acfun.tv,DIRECT
  - DOMAIN-SUFFIX,adobesc.com,DIRECT
  - DOMAIN-SUFFIX,air-matters.com,DIRECT
  - DOMAIN-SUFFIX,air-matters.io,DIRECT
  - DOMAIN-SUFFIX,aixifan.com,DIRECT
  - DOMAIN-SUFFIX,akadns.net,DIRECT
  - DOMAIN-SUFFIX,alibabacloud.com,DIRECT
  - DOMAIN-SUFFIX,alicdn.com,DIRECT
  - DOMAIN-SUFFIX,alipay.com,DIRECT
  - DOMAIN-SUFFIX,alipayobjects.com,DIRECT
  - DOMAIN-SUFFIX,aliyun.com,DIRECT
  - DOMAIN-SUFFIX,aliyuncs.com,DIRECT
  - DOMAIN-SUFFIX,amap.com,DIRECT
  - DOMAIN-SUFFIX,appshike.com,DIRECT
  - DOMAIN-SUFFIX,appstore.com,DIRECT
  - DOMAIN-SUFFIX,autonavi.com,DIRECT
  - DOMAIN-SUFFIX,aweme.snssdk.com,DIRECT
  - DOMAIN-SUFFIX,bababian.com,DIRECT
  - DOMAIN-SUFFIX,baidu.com,DIRECT
  - DOMAIN-SUFFIX,baidupcs.com,DIRECT
  - DOMAIN-SUFFIX,baiducotent.com,DIRECT
  - DOMAIN-SUFFIX,baidustatic.com,DIRECT
  - DOMAIN-SUFFIX,bcebos.com,DIRECT
  - DOMAIN-SUFFIX,gshifen.com,DIRECT
  - DOMAIN-SUFFIX,popin.cc,DIRECT
  - DOMAIN-SUFFIX,shifen.com,DIRECT
  - DOMAIN-SUFFIX,wshifen.com,DIRECT
  - DOMAIN-SUFFIX,bdimg.com,DIRECT
  - DOMAIN-SUFFIX,bdstatic.com,DIRECT
  - DOMAIN-SUFFIX,beatsbydre.com,DIRECT
  - DOMAIN-SUFFIX,bet365.com,DIRECT
  - DOMAIN-SUFFIX,broadcasthe.net,DIRECT
  - DOMAIN-SUFFIX,caiyunapp.com,DIRECT
  - DOMAIN-SUFFIX,ccgslb.com,DIRECT
  - DOMAIN-SUFFIX,ccgslb.net,DIRECT
  - DOMAIN-SUFFIX,chinacache.net,DIRECT
  - DOMAIN-SUFFIX,chunbo.com,DIRECT
  - DOMAIN-SUFFIX,chunboimg.com,DIRECT
  - DOMAIN-SUFFIX,clashroyaleapp.com,DIRECT
  - DOMAIN-SUFFIX,clouddn.com,DIRECT
  - DOMAIN-SUFFIX,cloudsigma.com,DIRECT
  - DOMAIN-SUFFIX,cloudxns.net,DIRECT
  - DOMAIN-SUFFIX,cmct.tv,DIRECT
  - DOMAIN-SUFFIX,cmfu.com,DIRECT
  - DOMAIN-SUFFIX,cnbeta.com,DIRECT
  - DOMAIN-SUFFIX,cnbetacdn.com,DIRECT
  - DOMAIN-SUFFIX,chdbits.co,DIRECT
  - DOMAIN-SUFFIX,cnlang.org,DIRECT
  - DOMAIN-SUFFIX,cz88.net,DIRECT
  - DOMAIN-SUFFIX,dct-cloud.com,DIRECT
  - DOMAIN-SUFFIX,didialift.com,DIRECT
  - DOMAIN-SUFFIX,digicert.com,DIRECT
  - DOMAIN-SUFFIX,douban.com,DIRECT
  - DOMAIN-SUFFIX,doubanio.com,DIRECT
  - DOMAIN-SUFFIX,douyin.com,DIRECT
  - DOMAIN-SUFFIX,douyu.com,DIRECT
  - DOMAIN-SUFFIX,douyu.tv,DIRECT
  - DOMAIN-SUFFIX,douyutv.com,DIRECT
  - DOMAIN-SUFFIX,duokan.com,DIRECT
  - DOMAIN-SUFFIX,duoshuo.com,DIRECT
  - DOMAIN-SUFFIX,dytt8.net,DIRECT
  - DOMAIN-SUFFIX,easou.com,DIRECT
  - DOMAIN-SUFFIX,ecitic.com,DIRECT
  - DOMAIN-SUFFIX,ecitic.net,DIRECT
  - DOMAIN-SUFFIX,eudic.net,DIRECT
  - DOMAIN-SUFFIX,ewqcxz.com,DIRECT
  - DOMAIN-SUFFIX,feng.com,DIRECT
  - DOMAIN-SUFFIX,fir.im,DIRECT
  - DOMAIN-SUFFIX,firefox.com,DIRECT
  - DOMAIN-SUFFIX,frdic.com,DIRECT
  - DOMAIN-SUFFIX,fresh-ideas.cc,DIRECT
  - DOMAIN-SUFFIX,gameloft.com,DIRECT
  - DOMAIN-SUFFIX,geetest.com,DIRECT
  - DOMAIN-SUFFIX,godic.net,DIRECT
  - DOMAIN-SUFFIX,goodread.com,DIRECT
  - DOMAIN-SUFFIX,gtimg.com,DIRECT
  - DOMAIN-SUFFIX,haibian.com,DIRECT
  - DOMAIN-SUFFIX,hao123.com,DIRECT
  - DOMAIN-SUFFIX,haosou.com,DIRECT
  - DOMAIN-SUFFIX,hdchina.org,DIRECT
  - DOMAIN-SUFFIX,hdcmct.org,DIRECT
  - DOMAIN-SUFFIX,hkserversolution.com,DIRECT
  - DOMAIN-SUFFIX,hollisterco.com,DIRECT
  - DOMAIN-SUFFIX,hongxiu.com,DIRECT
  - DOMAIN-SUFFIX,hxcdn.net,DIRECT
  - DOMAIN-SUFFIX,icedropper.com,DIRECT
  - DOMAIN-SUFFIX,iciba.com,DIRECT
  - DOMAIN-SUFFIX,ifeng.com,DIRECT
  - DOMAIN-SUFFIX,ifengimg.com,DIRECT
  - DOMAIN-SUFFIX,images-amazon.com,DIRECT
  - DOMAIN-SUFFIX,img4me.com,DIRECT
  - DOMAIN-SUFFIX,ithome.com,DIRECT
  - DOMAIN-SUFFIX,ixdzs.com,DIRECT
  - DOMAIN-SUFFIX,jd.com,DIRECT
  - DOMAIN-SUFFIX,jd.hk,DIRECT
  - DOMAIN-SUFFIX,jianshu.com,DIRECT
  - DOMAIN-SUFFIX,jianshu.io,DIRECT
  - DOMAIN-SUFFIX,jianshuapi.com,DIRECT
  - DOMAIN-SUFFIX,jiathis.com,DIRECT
  - DOMAIN-SUFFIX,jomodns.com,DIRECT
  - DOMAIN-SUFFIX,jsboxbbs.com,DIRECT
  - DOMAIN-SUFFIX,knewone.com,DIRECT
  - DOMAIN-SUFFIX,ksosoft.com,DIRECT
  - DOMAIN-SUFFIX,kuaidi100.com,DIRECT
  - DOMAIN-SUFFIX,kugou.com,DIRECT
  - DOMAIN-SUFFIX,lecloud.com,DIRECT
  - DOMAIN-SUFFIX,leaguehd.com,DIRECT
  - DOMAIN-SUFFIX,lemicp.com,DIRECT
  - DOMAIN-SUFFIX,letv.com,DIRECT
  - DOMAIN-SUFFIX,letvcloud.com,DIRECT
  - DOMAIN-SUFFIX,liyuans.com,DIRECT
  - DOMAIN-SUFFIX,lizhi.io,DIRECT
  - DOMAIN-SUFFIX,localizecdn.com,DIRECT
  - DOMAIN-SUFFIX,lucifr.com,DIRECT
  - DOMAIN-SUFFIX,luoo.net,DIRECT
  - DOMAIN-SUFFIX,lxdns.com,DIRECT
  - DOMAIN-SUFFIX,mai.tn,DIRECT
  - DOMAIN-SUFFIX,maoyan.com,DIRECT
  - DOMAIN-SUFFIX,maoyun.tv,DIRECT
  - DOMAIN-SUFFIX,meipai.com,DIRECT
  - DOMAIN-SUFFIX,meitu.com,DIRECT
  - DOMAIN-SUFFIX,meituan.com,DIRECT
  - DOMAIN-SUFFIX,meituan.net,DIRECT
  - DOMAIN-SUFFIX,mls-cdn.com,DIRECT
  - DOMAIN-SUFFIX,meitudata.com,DIRECT
  - DOMAIN-SUFFIX,meitustat.com,DIRECT
  - DOMAIN-SUFFIX,meizu.com,DIRECT
  - DOMAIN-SUFFIX,metatrader4.com,DIRECT
  - DOMAIN-SUFFIX,metatrader5.com,DIRECT
  - DOMAIN-SUFFIX,mi.com,DIRECT
  - DOMAIN-SUFFIX,miaopai.com,DIRECT
  - DOMAIN-SUFFIX,miui.com,DIRECT
  - DOMAIN-SUFFIX,miwifi.com,DIRECT
  - DOMAIN-SUFFIX,mob.com,DIRECT
  - DOMAIN-SUFFIX,moji.com,DIRECT
  - DOMAIN-SUFFIX,moke.com,DIRECT
  - DOMAIN-SUFFIX,mxhichina.com,DIRECT
  - DOMAIN-SUFFIX,myqcloud.com,DIRECT
  - DOMAIN-SUFFIX,myunlu.com,DIRECT
  - DOMAIN-SUFFIX,ngabbs.com,DIRECT
  - DOMAIN-SUFFIX,netease.com,DIRECT
  - DOMAIN-SUFFIX,nfoservers.com,DIRECT
  - DOMAIN-SUFFIX,nssurge.com,DIRECT
  - DOMAIN-SUFFIX,nuomi.com,DIRECT
  - DOMAIN-SUFFIX,ourbits.club,DIRECT
  - DOMAIN-SUFFIX,ourdvs.com,DIRECT
  - DOMAIN-SUFFIX,passthepopcorn.me,DIRECT
  - DOMAIN-SUFFIX,pgyer.com,DIRECT
  - DOMAIN-SUFFIX,pniao.com,DIRECT
  - DOMAIN-SUFFIX,privatehd.to,DIRECT
  - DOMAIN-SUFFIX,pstatp.com,DIRECT
  - DOMAIN-SUFFIX,qbox.me,DIRECT
  - DOMAIN-SUFFIX,qcloud.com,DIRECT
  - DOMAIN-SUFFIX,qdaily.com,DIRECT
  - DOMAIN-SUFFIX,qdmm.com,DIRECT
  - DOMAIN-SUFFIX,qhimg.com,DIRECT
  - DOMAIN-SUFFIX,qhres.com,DIRECT
  - DOMAIN-SUFFIX,qidian.com,DIRECT
  - DOMAIN-SUFFIX,qihucdn.com,DIRECT
  - DOMAIN-SUFFIX,qin.io,DIRECT
  - DOMAIN-SUFFIX,qingmang.me,DIRECT
  - DOMAIN-SUFFIX,qingmang.mobi,DIRECT
  - DOMAIN-SUFFIX,qiniucdn.com,DIRECT
  - DOMAIN-SUFFIX,qiniudn.com,DIRECT
  - DOMAIN-SUFFIX,qq.com,DIRECT
  - DOMAIN-SUFFIX,qqurl.com,DIRECT
  - DOMAIN-SUFFIX,rarbg.to,DIRECT
  - DOMAIN-SUFFIX,redacted.ch,DIRECT
  - DOMAIN-SUFFIX,rrmj.tv,DIRECT
  - DOMAIN-SUFFIX,rubyfish.cn,DIRECT
  - DOMAIN-SUFFIX,ruguoapp.com,DIRECT
  - DOMAIN-SUFFIX,sandai.net,DIRECT
  - DOMAIN-SUFFIX,sf-express.com,DIRECT
  - DOMAIN-SUFFIX,sinaapp.com,DIRECT
  - DOMAIN-SUFFIX,sinaimg.cn,DIRECT
  - DOMAIN-SUFFIX,sinaimg.com,DIRECT
  - DOMAIN-SUFFIX,sm.ms,DIRECT
  - DOMAIN-SUFFIX,smzdm.com,DIRECT
  - DOMAIN-SUFFIX,snssdk.com,DIRECT
  - DOMAIN-SUFFIX,snwx.com,DIRECT
  - DOMAIN-SUFFIX,so.com,DIRECT
  - DOMAIN-SUFFIX,sogou.com,DIRECT
  - DOMAIN-SUFFIX,sogoucdn.com,DIRECT
  - DOMAIN-SUFFIX,sohu.com,DIRECT
  - DOMAIN-SUFFIX,soku.com,DIRECT
  - DOMAIN-SUFFIX,soso.com,DIRECT
  - DOMAIN-SUFFIX,sspai.com,DIRECT
  - DOMAIN-SUFFIX,startssl.com,DIRECT
  - DOMAIN-SUFFIX,suning.com,DIRECT
  - DOMAIN-SUFFIX,symcd.com,DIRECT
  - DOMAIN-SUFFIX,taichi-maker.com,DIRECT
  - DOMAIN-SUFFIX,taobao.com,DIRECT
  - DOMAIN-SUFFIX,tawk.link,DIRECT
  - DOMAIN-SUFFIX,tawk.to,DIRECT
  - DOMAIN-SUFFIX,tenpay.com,DIRECT
  - DOMAIN-SUFFIX,tietuku.com,DIRECT
  - DOMAIN-SUFFIX,tmall.com,DIRECT
  - DOMAIN-SUFFIX,tmzvps.com,DIRECT
  - DOMAIN-SUFFIX,trello.com,DIRECT
  - DOMAIN-SUFFIX,trellocdn.com,DIRECT
  - DOMAIN-SUFFIX,totheglory.im,DIRECT
  - DOMAIN-SUFFIX,ttmeiju.com,DIRECT
  - DOMAIN-SUFFIX,tudou.com,DIRECT
  - DOMAIN-SUFFIX,udache.com,DIRECT
  - DOMAIN-SUFFIX,umengcloud.com,DIRECT
  - DOMAIN-SUFFIX,upaiyun.com,DIRECT
  - DOMAIN-SUFFIX,upyun.com,DIRECT
  - DOMAIN-SUFFIX,uxengine.net,DIRECT
  - DOMAIN-SUFFIX,wandoujia.com,DIRECT
  - DOMAIN-SUFFIX,weather.bjango.com,DIRECT
  - DOMAIN-SUFFIX,weather.com,DIRECT
  - DOMAIN-SUFFIX,webqxs.com,DIRECT
  - DOMAIN-SUFFIX,weibo.cn,DIRECT
  - DOMAIN-SUFFIX,weibo.com,DIRECT
  - DOMAIN-SUFFIX,weico.cc,DIRECT
  - DOMAIN-SUFFIX,weiphone.com,DIRECT
  - DOMAIN-SUFFIX,weiphone.net,DIRECT
  - DOMAIN-SUFFIX,wenku8.net,DIRECT
  - DOMAIN-SUFFIX,werewolf.53site.com,DIRECT
  - DOMAIN-SUFFIX,wkcdn.com,DIRECT
  - DOMAIN-SUFFIX,xdrig.com,DIRECT
  - DOMAIN-SUFFIX,xhostfire.com,DIRECT
  - DOMAIN-SUFFIX,xiami.com,DIRECT
  - DOMAIN-SUFFIX,xiami.net,DIRECT
  - DOMAIN-SUFFIX,xiaojukeji.com,DIRECT
  - DOMAIN-SUFFIX,xiaomi.com,DIRECT
  - DOMAIN-SUFFIX,xiaomi.net,DIRECT
  - DOMAIN-SUFFIX,xiaomicp.com,DIRECT
  - DOMAIN-SUFFIX,ximalaya.com,DIRECT
  - DOMAIN-SUFFIX,xitek.com,DIRECT
  - DOMAIN-SUFFIX,xmcdn.com,DIRECT
  - DOMAIN-SUFFIX,xslb.net,DIRECT
  - DOMAIN-SUFFIX,yach.me,DIRECT
  - DOMAIN-SUFFIX,yeepay.com,DIRECT
  - DOMAIN-SUFFIX,yhd.com,DIRECT
  - DOMAIN-SUFFIX,yinxiang.com,DIRECT
  - DOMAIN-SUFFIX,yixia.com,DIRECT
  - DOMAIN-SUFFIX,ykimg.com,DIRECT
  - DOMAIN-SUFFIX,youdao.com,DIRECT
  - DOMAIN-SUFFIX,youku.com,DIRECT
  - DOMAIN-SUFFIX,yunjiasu-cdn.net,DIRECT
  - DOMAIN-SUFFIX,zealer.com,DIRECT
  - DOMAIN-SUFFIX,zgslb.net,DIRECT
  - DOMAIN-SUFFIX,zhihu.com,DIRECT
  - DOMAIN-SUFFIX,zhimg.com,DIRECT
  - DOMAIN-SUFFIX,zimuzu.tv,DIRECT
  - DOMAIN-SUFFIX,zmz002.com,DIRECT
  - DOMAIN-SUFFIX,www.88dmw.com,DIRECT
  - DOMAIN-SUFFIX,tanx.com,DIRECT
  - DOMAIN-SUFFIX,alibaba.com,DIRECT
  - DOMAIN-SUFFIX,iqiyi.com,DIRECT
  - DOMAIN-SUFFIX,gdtimg.com,DIRECT
  - DOMAIN-SUFFIX,gtimg.cn,DIRECT
  - DOMAIN-SUFFIX,tencent.com,DIRECT
  - GEOIP,CN,DIRECT
  ## 您可以在此处插入您补充的自定义规则（请注意保持缩进）
  - PROCESS-NAME,msedgewebview2.exe,💬ChatGPT
  - DOMAIN-SUFFIX,poe.com,💬ChatGPT
  - DOMAIN-SUFFIX,sentry.io,💬ChatGPT
  - DOMAIN-SUFFIX,vimeocdn.com,💬ChatGPT
  - DOMAIN-SUFFIX,blob.core.windows.net,💬ChatGPT
  - DOMAIN-SUFFIX,googleapis.com,💬ChatGPT
  - DOMAIN-SUFFIX,azurefd.net,💬ChatGPT
  - DOMAIN-SUFFIX,azureedge.net,💬ChatGPT
  - DOMAIN-SUFFIX,cdn.cloudflare.net,💬ChatGPT
  - DOMAIN-SUFFIX,hcaptcha.com,💬ChatGPT
  - DOMAIN-SUFFIX,gstatic.com,💬ChatGPT
  - DOMAIN-SUFFIX,vimeo.com,💬ChatGPT
  - DOMAIN-SUFFIX,googletagmanager.com,💬ChatGPT
  - DOMAIN-SUFFIX,f7tk.com,💬ChatGPT
  - DOMAIN-SUFFIX,doubleclick.net,💬ChatGPT
  - DOMAIN-SUFFIX,google-analytics.com,💬ChatGPT
  - DOMAIN-SUFFIX,intercom.io,💬ChatGPT
  - DOMAIN-SUFFIX,statsigapi.net,💬ChatGPT
  - DOMAIN-SUFFIX,featuregates.org,💬ChatGPT
  - DOMAIN-SUFFIX,intercomcdn.com,💬ChatGPT
  - DOMAIN-SUFFIX,pki.goog,💬ChatGPT
  - DOMAIN-SUFFIX,cloudflareinsights.com,💬ChatGPT
  - DOMAIN-SUFFIX,edgecompute.app,💬ChatGPT
  - DOMAIN-SUFFIX,compute-pipe.com,💬ChatGPT
  - DOMAIN-SUFFIX,stripe.network,💬ChatGPT
  - DOMAIN-SUFFIX,gpt3sandbox.com,💬ChatGPT
  - DOMAIN-SUFFIX,oaistatic.com,💬ChatGPT
  - DOMAIN-SUFFIX,oaiusercontent.com,💬ChatGPT

  # Google 中国服务
  - DOMAIN-SUFFIX,services.googleapis.cn,🔄$app_name
  - DOMAIN-SUFFIX,xn--ngstr-lra8j.com,🔄$app_name
  - DOMAIN-KEYWORD,chatgpt,💬ChatGPT
  - DOMAIN-KEYWORD,openai,💬ChatGPT
  - DOMAIN-KEYWORD,ip.sb,💬ChatGPT    
  # Apple
  - DOMAIN,safebrowsing.urlsec.qq.com,DIRECT # 如果您并不信任此服务提供商或防止其下载消耗过多带宽资源，可以进入 Safari 设置，关闭 Fraudulent Website Warning 功能，并使用 REJECT 策略。
  - DOMAIN,safebrowsing.googleapis.com,DIRECT # 如果您并不信任此服务提供商或防止其下载消耗过多带宽资源，可以进入 Safari 设置，关闭 Fraudulent Website Warning 功能，并使用 REJECT 策略。
  - DOMAIN,developer.apple.com,🔄$app_name
  - DOMAIN-SUFFIX,digicert.com,🔄$app_name
  - DOMAIN,ocsp.apple.com,🔄$app_name
  - DOMAIN,ocsp.comodoca.com,🔄$app_name
  - DOMAIN,ocsp.usertrust.com,🔄$app_name
  - DOMAIN,ocsp.sectigo.com,🔄$app_name
  - DOMAIN,ocsp.verisign.net,🔄$app_name
  - DOMAIN-SUFFIX,apple-dns.net,🔄$app_name
  - DOMAIN,testflight.apple.com,🔄$app_name
  - DOMAIN,sandbox.itunes.apple.com,🔄$app_name
  - DOMAIN,itunes.apple.com,🔄$app_name
  - DOMAIN-SUFFIX,apps.apple.com,🔄$app_name
  - DOMAIN-SUFFIX,blobstore.apple.com,🔄$app_name
  - DOMAIN,cvws.icloud-content.com,🔄$app_name
  - DOMAIN-SUFFIX,mzstatic.com,DIRECT
  - DOMAIN-SUFFIX,itunes.apple.com,DIRECT
  - DOMAIN-SUFFIX,icloud.com,DIRECT
  - DOMAIN-SUFFIX,icloud-content.com,DIRECT
  - DOMAIN-SUFFIX,me.com,DIRECT
  - DOMAIN-SUFFIX,aaplimg.com,DIRECT
  - DOMAIN-SUFFIX,cdn20.com,DIRECT
  - DOMAIN-SUFFIX,cdn-apple.com,DIRECT
  - DOMAIN-SUFFIX,akadns.net,DIRECT
  - DOMAIN-SUFFIX,akamaiedge.net,DIRECT
  - DOMAIN-SUFFIX,edgekey.net,DIRECT
  - DOMAIN-SUFFIX,mwcloudcdn.com,DIRECT
  - DOMAIN-SUFFIX,mwcname.com,DIRECT
  - DOMAIN-SUFFIX,apple.com,DIRECT
  - DOMAIN-SUFFIX,apple-cloudkit.com,DIRECT
  - DOMAIN-SUFFIX,apple-mapkit.com,DIRECT
  # - DOMAIN,e.crashlytics.com,REJECT //注释此选项有助于大多数App开发者分析崩溃信息；如果您拒绝一切崩溃数据统计、搜集，请取消 # 注释。

  # 国内网站
  - DOMAIN-SUFFIX,126.com,DIRECT
  - DOMAIN-SUFFIX,126.net,DIRECT
  - DOMAIN-SUFFIX,127.net,DIRECT
  - DOMAIN-SUFFIX,163.com,DIRECT
  - DOMAIN-SUFFIX,360buyimg.com,DIRECT
  - DOMAIN-SUFFIX,36kr.com,DIRECT
  - DOMAIN-SUFFIX,acfun.tv,DIRECT
  - DOMAIN-SUFFIX,air-matters.com,DIRECT
  - DOMAIN-SUFFIX,aixifan.com,DIRECT
  - DOMAIN-KEYWORD,alicdn,DIRECT
  - DOMAIN-KEYWORD,alipay,DIRECT
  - DOMAIN-KEYWORD,taobao,DIRECT
  - DOMAIN-SUFFIX,amap.com,DIRECT
  - DOMAIN-SUFFIX,autonavi.com,DIRECT
  - DOMAIN-KEYWORD,baidu,DIRECT
  - DOMAIN-SUFFIX,bdimg.com,DIRECT
  - DOMAIN-SUFFIX,bdstatic.com,DIRECT
  - DOMAIN-SUFFIX,bilibili.com,DIRECT
  - DOMAIN-SUFFIX,bilivideo.com,DIRECT
  - DOMAIN-SUFFIX,caiyunapp.com,DIRECT
  - DOMAIN-SUFFIX,clouddn.com,DIRECT
  - DOMAIN-SUFFIX,cnbeta.com,DIRECT
  - DOMAIN-SUFFIX,cnbetacdn.com,DIRECT
  - DOMAIN-SUFFIX,cootekservice.com,DIRECT
  - DOMAIN-SUFFIX,csdn.net,DIRECT
  - DOMAIN-SUFFIX,ctrip.com,DIRECT
  - DOMAIN-SUFFIX,dgtle.com,DIRECT
  - DOMAIN-SUFFIX,dianping.com,DIRECT
  - DOMAIN-SUFFIX,douban.com,DIRECT
  - DOMAIN-SUFFIX,doubanio.com,DIRECT
  - DOMAIN-SUFFIX,duokan.com,DIRECT
  - DOMAIN-SUFFIX,easou.com,DIRECT
  - DOMAIN-SUFFIX,ele.me,DIRECT
  - DOMAIN-SUFFIX,feng.com,DIRECT
  - DOMAIN-SUFFIX,fir.im,DIRECT
  - DOMAIN-SUFFIX,frdic.com,DIRECT
  - DOMAIN-SUFFIX,g-cores.com,DIRECT
  - DOMAIN-SUFFIX,godic.net,DIRECT
  - DOMAIN-SUFFIX,gtimg.com,DIRECT
  - DOMAIN,cdn.hockeyapp.net,DIRECT
  - DOMAIN-SUFFIX,hongxiu.com,DIRECT
  - DOMAIN-SUFFIX,hxcdn.net,DIRECT
  - DOMAIN-SUFFIX,iciba.com,DIRECT
  - DOMAIN-SUFFIX,ifeng.com,DIRECT
  - DOMAIN-SUFFIX,ifengimg.com,DIRECT
  - DOMAIN-SUFFIX,ipip.net,DIRECT
  - DOMAIN-SUFFIX,iqiyi.com,DIRECT
  - DOMAIN-SUFFIX,jd.com,DIRECT
  - DOMAIN-SUFFIX,jianshu.com,DIRECT
  - DOMAIN-SUFFIX,knewone.com,DIRECT
  - DOMAIN-SUFFIX,le.com,DIRECT
  - DOMAIN-SUFFIX,lecloud.com,DIRECT
  - DOMAIN-SUFFIX,lemicp.com,DIRECT
  - DOMAIN-SUFFIX,licdn.com,DIRECT
  - DOMAIN-SUFFIX,luoo.net,DIRECT
  - DOMAIN-SUFFIX,meituan.com,DIRECT
  - DOMAIN-SUFFIX,meituan.net,DIRECT
  - DOMAIN-SUFFIX,mi.com,DIRECT
  - DOMAIN-SUFFIX,miaopai.com,DIRECT
  - DOMAIN-SUFFIX,microsoft.com,DIRECT
  - DOMAIN-SUFFIX,microsoftonline.com,DIRECT
  - DOMAIN-SUFFIX,miui.com,DIRECT
  - DOMAIN-SUFFIX,miwifi.com,DIRECT
  - DOMAIN-SUFFIX,mob.com,DIRECT
  - DOMAIN-SUFFIX,netease.com,DIRECT
  - DOMAIN-SUFFIX,office.com,DIRECT
  - DOMAIN-SUFFIX,office365.com,DIRECT
  - DOMAIN-KEYWORD,officecdn,DIRECT
  - DOMAIN-SUFFIX,oschina.net,DIRECT
  - DOMAIN-SUFFIX,ppsimg.com,DIRECT
  - DOMAIN-SUFFIX,pstatp.com,DIRECT
  - DOMAIN-SUFFIX,qcloud.com,DIRECT
  - DOMAIN-SUFFIX,qdaily.com,DIRECT
  - DOMAIN-SUFFIX,qdmm.com,DIRECT
  - DOMAIN-SUFFIX,qhimg.com,DIRECT
  - DOMAIN-SUFFIX,qhres.com,DIRECT
  - DOMAIN-SUFFIX,qidian.com,DIRECT
  - DOMAIN-SUFFIX,qihucdn.com,DIRECT
  - DOMAIN-SUFFIX,qiniu.com,DIRECT
  - DOMAIN-SUFFIX,qiniucdn.com,DIRECT
  - DOMAIN-SUFFIX,qiyipic.com,DIRECT
  - DOMAIN-SUFFIX,qq.com,DIRECT
  - DOMAIN-SUFFIX,qqurl.com,DIRECT
  - DOMAIN-SUFFIX,rarbg.to,DIRECT
  - DOMAIN-SUFFIX,ruguoapp.com,DIRECT
  - DOMAIN-SUFFIX,segmentfault.com,DIRECT
  - DOMAIN-SUFFIX,sinaapp.com,DIRECT
  - DOMAIN-SUFFIX,smzdm.com,DIRECT
  - DOMAIN-SUFFIX,snapdrop.net,DIRECT
  - DOMAIN-SUFFIX,sogou.com,DIRECT
  - DOMAIN-SUFFIX,sogoucdn.com,DIRECT
  - DOMAIN-SUFFIX,sohu.com,DIRECT
  - DOMAIN-SUFFIX,soku.com,DIRECT
  - DOMAIN-SUFFIX,speedtest.net,DIRECT
  - DOMAIN-SUFFIX,sspai.com,DIRECT
  - DOMAIN-SUFFIX,suning.com,DIRECT
  - DOMAIN-SUFFIX,taobao.com,DIRECT
  - DOMAIN-SUFFIX,tencent.com,DIRECT
  - DOMAIN-SUFFIX,tenpay.com,DIRECT
  - DOMAIN-SUFFIX,tianyancha.com,DIRECT
  - DOMAIN-SUFFIX,tmall.com,DIRECT
  - DOMAIN-SUFFIX,tudou.com,DIRECT
  - DOMAIN-SUFFIX,umetrip.com,DIRECT
  - DOMAIN-SUFFIX,upaiyun.com,DIRECT
  - DOMAIN-SUFFIX,upyun.com,DIRECT
  - DOMAIN-SUFFIX,veryzhun.com,DIRECT
  - DOMAIN-SUFFIX,weather.com,DIRECT
  - DOMAIN-SUFFIX,weibo.com,DIRECT
  - DOMAIN-SUFFIX,xiami.com,DIRECT
  - DOMAIN-SUFFIX,xiami.net,DIRECT
  - DOMAIN-SUFFIX,xiaomicp.com,DIRECT
  - DOMAIN-SUFFIX,ximalaya.com,DIRECT
  - DOMAIN-SUFFIX,xmcdn.com,DIRECT
  - DOMAIN-SUFFIX,xunlei.com,DIRECT
  - DOMAIN-SUFFIX,yhd.com,DIRECT
  - DOMAIN-SUFFIX,yihaodianimg.com,DIRECT
  - DOMAIN-SUFFIX,yinxiang.com,DIRECT
  - DOMAIN-SUFFIX,ykimg.com,DIRECT
  - DOMAIN-SUFFIX,youdao.com,DIRECT
  - DOMAIN-SUFFIX,youku.com,DIRECT
  - DOMAIN-SUFFIX,zealer.com,DIRECT
  - DOMAIN-SUFFIX,zhihu.com,DIRECT
  - DOMAIN-SUFFIX,zhimg.com,DIRECT
  - DOMAIN-SUFFIX,zimuzu.tv,DIRECT
  - DOMAIN-SUFFIX,zoho.com,DIRECT

  # 抗 DNS 污染
  - DOMAIN-KEYWORD,amazon,🔄$app_name
  - DOMAIN-KEYWORD,google,🔄$app_name
  - DOMAIN-KEYWORD,gmail,🔄$app_name
  - DOMAIN-KEYWORD,youtube,🔄$app_name
  - DOMAIN-KEYWORD,facebook,🔄$app_name
  - DOMAIN-SUFFIX,fb.me,🔄$app_name
  - DOMAIN-SUFFIX,fbcdn.net,🔄$app_name
  - DOMAIN-KEYWORD,twitter,🔄$app_name
  - DOMAIN-KEYWORD,instagram,🔄$app_name
  - DOMAIN-KEYWORD,dropbox,🔄$app_name
  - DOMAIN-SUFFIX,twimg.com,🔄$app_name
  - DOMAIN-KEYWORD,blogspot,🔄$app_name
  - DOMAIN-SUFFIX,youtu.be,🔄$app_name
  - DOMAIN-KEYWORD,whatsapp,🔄$app_name

  # 常见广告域名屏蔽
  - DOMAIN-KEYWORD,admarvel,REJECT
  - DOMAIN-KEYWORD,admaster,REJECT
  - DOMAIN-KEYWORD,adsage,REJECT
  - DOMAIN-KEYWORD,adsmogo,REJECT
  - DOMAIN-KEYWORD,adsrvmedia,REJECT
  - DOMAIN-KEYWORD,adwords,REJECT
  - DOMAIN-KEYWORD,adservice,REJECT
  - DOMAIN-SUFFIX,appsflyer.com,REJECT
  - DOMAIN-KEYWORD,domob,REJECT
  - DOMAIN-SUFFIX,doubleclick.net,REJECT
  - DOMAIN-KEYWORD,duomeng,REJECT
  - DOMAIN-KEYWORD,dwtrack,REJECT
  - DOMAIN-KEYWORD,guanggao,REJECT
  - DOMAIN-KEYWORD,lianmeng,REJECT
  - DOMAIN-SUFFIX,mmstat.com,REJECT
  - DOMAIN-KEYWORD,mopub,REJECT
  - DOMAIN-KEYWORD,omgmta,REJECT
  - DOMAIN-KEYWORD,openx,REJECT
  - DOMAIN-KEYWORD,partnerad,REJECT
  - DOMAIN-KEYWORD,pingfore,REJECT
  - DOMAIN-KEYWORD,supersonicads,REJECT
  - DOMAIN-KEYWORD,uedas,REJECT
  - DOMAIN-KEYWORD,umeng,REJECT
  - DOMAIN-KEYWORD,usage,REJECT
  - DOMAIN-SUFFIX,vungle.com,REJECT
  - DOMAIN-KEYWORD,wlmonitor,REJECT
  - DOMAIN-KEYWORD,zjtoolbar,REJECT

  # 国外网站
  - DOMAIN-SUFFIX,9to5mac.com,🔄$app_name
  - DOMAIN-SUFFIX,abpchina.org,🔄$app_name
  - DOMAIN-SUFFIX,adblockplus.org,🔄$app_name
  - DOMAIN-SUFFIX,adobe.com,🔄$app_name
  - DOMAIN-SUFFIX,akamaized.net,🔄$app_name
  - DOMAIN-SUFFIX,alfredapp.com,🔄$app_name
  - DOMAIN-SUFFIX,amplitude.com,🔄$app_name
  - DOMAIN-SUFFIX,ampproject.org,🔄$app_name
  - DOMAIN-SUFFIX,android.com,🔄$app_name
  - DOMAIN-SUFFIX,angularjs.org,🔄$app_name
  - DOMAIN-SUFFIX,aolcdn.com,🔄$app_name
  - DOMAIN-SUFFIX,apkpure.com,🔄$app_name
  - DOMAIN-SUFFIX,appledaily.com,🔄$app_name
  - DOMAIN-SUFFIX,appshopper.com,🔄$app_name
  - DOMAIN-SUFFIX,appspot.com,🔄$app_name
  - DOMAIN-SUFFIX,arcgis.com,🔄$app_name
  - DOMAIN-SUFFIX,archive.org,🔄$app_name
  - DOMAIN-SUFFIX,armorgames.com,🔄$app_name
  - DOMAIN-SUFFIX,aspnetcdn.com,🔄$app_name
  - DOMAIN-SUFFIX,att.com,🔄$app_name
  - DOMAIN-SUFFIX,awsstatic.com,🔄$app_name
  - DOMAIN-SUFFIX,azureedge.net,🔄$app_name
  - DOMAIN-SUFFIX,azurewebsites.net,🔄$app_name
  - DOMAIN-SUFFIX,bing.com,🔄$app_name
  - DOMAIN-SUFFIX,bintray.com,🔄$app_name
  - DOMAIN-SUFFIX,bit.com,🔄$app_name
  - DOMAIN-SUFFIX,bit.ly,🔄$app_name
  - DOMAIN-SUFFIX,bitbucket.org,🔄$app_name
  - DOMAIN-SUFFIX,bjango.com,🔄$app_name
  - DOMAIN-SUFFIX,bkrtx.com,🔄$app_name
  - DOMAIN-SUFFIX,blog.com,🔄$app_name
  - DOMAIN-SUFFIX,blogcdn.com,🔄$app_name
  - DOMAIN-SUFFIX,blogger.com,🔄$app_name
  - DOMAIN-SUFFIX,blogsmithmedia.com,🔄$app_name
  - DOMAIN-SUFFIX,blogspot.com,🔄$app_name
  - DOMAIN-SUFFIX,blogspot.hk,🔄$app_name
  - DOMAIN-SUFFIX,bloomberg.com,🔄$app_name
  - DOMAIN-SUFFIX,box.com,🔄$app_name
  - DOMAIN-SUFFIX,box.net,🔄$app_name
  - DOMAIN-SUFFIX,cachefly.net,🔄$app_name
  - DOMAIN-SUFFIX,chromium.org,🔄$app_name
  - DOMAIN-SUFFIX,cl.ly,🔄$app_name
  - DOMAIN-SUFFIX,cloudflare.com,🔄$app_name
  - DOMAIN-SUFFIX,cloudfront.net,🔄$app_name
  - DOMAIN-SUFFIX,cloudmagic.com,🔄$app_name
  - DOMAIN-SUFFIX,cmail19.com,🔄$app_name
  - DOMAIN-SUFFIX,cnet.com,🔄$app_name
  - DOMAIN-SUFFIX,cocoapods.org,🔄$app_name
  - DOMAIN-SUFFIX,comodoca.com,🔄$app_name
  - DOMAIN-SUFFIX,crashlytics.com,🔄$app_name
  - DOMAIN-SUFFIX,culturedcode.com,🔄$app_name
  - DOMAIN-SUFFIX,d.pr,🔄$app_name
  - DOMAIN-SUFFIX,danilo.to,🔄$app_name
  - DOMAIN-SUFFIX,dayone.me,🔄$app_name
  - DOMAIN-SUFFIX,db.tt,🔄$app_name
  - DOMAIN-SUFFIX,deskconnect.com,🔄$app_name
  - DOMAIN-SUFFIX,disq.us,🔄$app_name
  - DOMAIN-SUFFIX,disqus.com,🔄$app_name
  - DOMAIN-SUFFIX,disquscdn.com,🔄$app_name
  - DOMAIN-SUFFIX,dnsimple.com,🔄$app_name
  - DOMAIN-SUFFIX,docker.com,🔄$app_name
  - DOMAIN-SUFFIX,dribbble.com,🔄$app_name
  - DOMAIN-SUFFIX,droplr.com,🔄$app_name
  - DOMAIN-SUFFIX,duckduckgo.com,🔄$app_name
  - DOMAIN-SUFFIX,dueapp.com,🔄$app_name
  - DOMAIN-SUFFIX,dytt8.net,🔄$app_name
  - DOMAIN-SUFFIX,edgecastcdn.net,🔄$app_name
  - DOMAIN-SUFFIX,edgekey.net,🔄$app_name
  - DOMAIN-SUFFIX,edgesuite.net,🔄$app_name
  - DOMAIN-SUFFIX,engadget.com,🔄$app_name
  - DOMAIN-SUFFIX,entrust.net,🔄$app_name
  - DOMAIN-SUFFIX,eurekavpt.com,🔄$app_name
  - DOMAIN-SUFFIX,evernote.com,🔄$app_name
  - DOMAIN-SUFFIX,fabric.io,🔄$app_name
  - DOMAIN-SUFFIX,fast.com,🔄$app_name
  - DOMAIN-SUFFIX,fastly.net,🔄$app_name
  - DOMAIN-SUFFIX,fc2.com,🔄$app_name
  - DOMAIN-SUFFIX,feedburner.com,🔄$app_name
  - DOMAIN-SUFFIX,feedly.com,🔄$app_name
  - DOMAIN-SUFFIX,feedsportal.com,🔄$app_name
  - DOMAIN-SUFFIX,fiftythree.com,🔄$app_name
  - DOMAIN-SUFFIX,firebaseio.com,🔄$app_name
  - DOMAIN-SUFFIX,flexibits.com,🔄$app_name
  - DOMAIN-SUFFIX,flickr.com,🔄$app_name
  - DOMAIN-SUFFIX,flipboard.com,🔄$app_name
  - DOMAIN-SUFFIX,g.co,🔄$app_name
  - DOMAIN-SUFFIX,gabia.net,🔄$app_name
  - DOMAIN-SUFFIX,geni.us,🔄$app_name
  - DOMAIN-SUFFIX,gfx.ms,🔄$app_name
  - DOMAIN-SUFFIX,ggpht.com,🔄$app_name
  - DOMAIN-SUFFIX,ghostnoteapp.com,🔄$app_name
  - DOMAIN-SUFFIX,git.io,🔄$app_name
  - DOMAIN-KEYWORD,github,🔄$app_name
  - DOMAIN-SUFFIX,globalsign.com,🔄$app_name
  - DOMAIN-SUFFIX,gmodules.com,🔄$app_name
  - DOMAIN-SUFFIX,godaddy.com,🔄$app_name
  - DOMAIN-SUFFIX,golang.org,🔄$app_name
  - DOMAIN-SUFFIX,gongm.in,🔄$app_name
  - DOMAIN-SUFFIX,goo.gl,🔄$app_name
  - DOMAIN-SUFFIX,goodreaders.com,🔄$app_name
  - DOMAIN-SUFFIX,goodreads.com,🔄$app_name
  - DOMAIN-SUFFIX,gravatar.com,🔄$app_name
  - DOMAIN-SUFFIX,gstatic.com,🔄$app_name
  - DOMAIN-SUFFIX,gvt0.com,🔄$app_name
  - DOMAIN-SUFFIX,hockeyapp.net,🔄$app_name
  - DOMAIN-SUFFIX,hotmail.com,🔄$app_name
  - DOMAIN-SUFFIX,icons8.com,🔄$app_name
  - DOMAIN-SUFFIX,ifixit.com,🔄$app_name
  - DOMAIN-SUFFIX,ift.tt,🔄$app_name
  - DOMAIN-SUFFIX,ifttt.com,🔄$app_name
  - DOMAIN-SUFFIX,iherb.com,🔄$app_name
  - DOMAIN-SUFFIX,imageshack.us,🔄$app_name
  - DOMAIN-SUFFIX,img.ly,🔄$app_name
  - DOMAIN-SUFFIX,imgur.com,🔄$app_name
  - DOMAIN-SUFFIX,imore.com,🔄$app_name
  - DOMAIN-SUFFIX,instapaper.com,🔄$app_name
  - DOMAIN-SUFFIX,ipn.li,🔄$app_name
  - DOMAIN-SUFFIX,is.gd,🔄$app_name
  - DOMAIN-SUFFIX,issuu.com,🔄$app_name
  - DOMAIN-SUFFIX,itgonglun.com,🔄$app_name
  - DOMAIN-SUFFIX,itun.es,🔄$app_name
  - DOMAIN-SUFFIX,ixquick.com,🔄$app_name
  - DOMAIN-SUFFIX,j.mp,🔄$app_name
  - DOMAIN-SUFFIX,js.revsci.net,🔄$app_name
  - DOMAIN-SUFFIX,jshint.com,🔄$app_name
  - DOMAIN-SUFFIX,jtvnw.net,🔄$app_name
  - DOMAIN-SUFFIX,justgetflux.com,🔄$app_name
  - DOMAIN-SUFFIX,kat.cr,🔄$app_name
  - DOMAIN-SUFFIX,klip.me,🔄$app_name
  - DOMAIN-SUFFIX,libsyn.com,🔄$app_name
  - DOMAIN-SUFFIX,linkedin.com,🔄$app_name
  - DOMAIN-SUFFIX,line-apps.com,🔄$app_name
  - DOMAIN-SUFFIX,linode.com,🔄$app_name
  - DOMAIN-SUFFIX,lithium.com,🔄$app_name
  - DOMAIN-SUFFIX,littlehj.com,🔄$app_name
  - DOMAIN-SUFFIX,live.com,🔄$app_name
  - DOMAIN-SUFFIX,live.net,🔄$app_name
  - DOMAIN-SUFFIX,livefilestore.com,🔄$app_name
  - DOMAIN-SUFFIX,llnwd.net,🔄$app_name
  - DOMAIN-SUFFIX,macid.co,🔄$app_name
  - DOMAIN-SUFFIX,macromedia.com,🔄$app_name
  - DOMAIN-SUFFIX,macrumors.com,🔄$app_name
  - DOMAIN-SUFFIX,mashable.com,🔄$app_name
  - DOMAIN-SUFFIX,mathjax.org,🔄$app_name
  - DOMAIN-SUFFIX,medium.com,🔄$app_name
  - DOMAIN-SUFFIX,mega.co.nz,🔄$app_name
  - DOMAIN-SUFFIX,mega.nz,🔄$app_name
  - DOMAIN-SUFFIX,megaupload.com,🔄$app_name
  - DOMAIN-SUFFIX,microsofttranslator.com,🔄$app_name
  - DOMAIN-SUFFIX,mindnode.com,🔄$app_name
  - DOMAIN-SUFFIX,mobile01.com,🔄$app_name
  - DOMAIN-SUFFIX,modmyi.com,🔄$app_name
  - DOMAIN-SUFFIX,msedge.net,🔄$app_name
  - DOMAIN-SUFFIX,myfontastic.com,🔄$app_name
  - DOMAIN-SUFFIX,name.com,🔄$app_name
  - DOMAIN-SUFFIX,nextmedia.com,🔄$app_name
  - DOMAIN-SUFFIX,nsstatic.net,🔄$app_name
  - DOMAIN-SUFFIX,nssurge.com,🔄$app_name
  - DOMAIN-SUFFIX,nyt.com,🔄$app_name
  - DOMAIN-SUFFIX,nytimes.com,🔄$app_name
  - DOMAIN-SUFFIX,omnigroup.com,🔄$app_name
  - DOMAIN-SUFFIX,onedrive.com,🔄$app_name
  - DOMAIN-SUFFIX,onenote.com,🔄$app_name
  - DOMAIN-SUFFIX,ooyala.com,🔄$app_name
  - DOMAIN-SUFFIX,openvpn.net,🔄$app_name
  - DOMAIN-SUFFIX,openwrt.org,🔄$app_name
  - DOMAIN-SUFFIX,orkut.com,🔄$app_name
  - DOMAIN-SUFFIX,osxdaily.com,🔄$app_name
  - DOMAIN-SUFFIX,outlook.com,🔄$app_name
  - DOMAIN-SUFFIX,ow.ly,🔄$app_name
  - DOMAIN-SUFFIX,paddleapi.com,🔄$app_name
  - DOMAIN-SUFFIX,parallels.com,🔄$app_name
  - DOMAIN-SUFFIX,parse.com,🔄$app_name
  - DOMAIN-SUFFIX,pdfexpert.com,🔄$app_name
  - DOMAIN-SUFFIX,periscope.tv,🔄$app_name
  - DOMAIN-SUFFIX,pinboard.in,🔄$app_name
  - DOMAIN-SUFFIX,pinterest.com,🔄$app_name
  - DOMAIN-SUFFIX,pixelmator.com,🔄$app_name
  - DOMAIN-SUFFIX,pixiv.net,🔄$app_name
  - DOMAIN-SUFFIX,playpcesor.com,🔄$app_name
  - DOMAIN-SUFFIX,playstation.com,🔄$app_name
  - DOMAIN-SUFFIX,playstation.com.hk,🔄$app_name
  - DOMAIN-SUFFIX,playstation.net,🔄$app_name
  - DOMAIN-SUFFIX,playstationnetwork.com,🔄$app_name
  - DOMAIN-SUFFIX,pushwoosh.com,🔄$app_name
  - DOMAIN-SUFFIX,rime.im,🔄$app_name
  - DOMAIN-SUFFIX,servebom.com,🔄$app_name
  - DOMAIN-SUFFIX,sfx.ms,🔄$app_name
  - DOMAIN-SUFFIX,shadowsocks.org,🔄$app_name
  - DOMAIN-SUFFIX,sharethis.com,🔄$app_name
  - DOMAIN-SUFFIX,shazam.com,🔄$app_name
  - DOMAIN-SUFFIX,skype.com,🔄$app_name
  - DOMAIN-SUFFIX,smartdns🔄$app_name.com,🔄$app_name
  - DOMAIN-SUFFIX,smartmailcloud.com,🔄$app_name
  - DOMAIN-SUFFIX,sndcdn.com,🔄$app_name
  - DOMAIN-SUFFIX,sony.com,🔄$app_name
  - DOMAIN-SUFFIX,soundcloud.com,🔄$app_name
  - DOMAIN-SUFFIX,sourceforge.net,🔄$app_name
  - DOMAIN-SUFFIX,spotify.com,🔄$app_name
  - DOMAIN-SUFFIX,squarespace.com,🔄$app_name
  - DOMAIN-SUFFIX,sstatic.net,🔄$app_name
  - DOMAIN-SUFFIX,st.luluku.pw,🔄$app_name
  - DOMAIN-SUFFIX,stackoverflow.com,🔄$app_name
  - DOMAIN-SUFFIX,startpage.com,🔄$app_name
  - DOMAIN-SUFFIX,staticflickr.com,🔄$app_name
  - DOMAIN-SUFFIX,steamcommunity.com,🔄$app_name
  - DOMAIN-SUFFIX,symauth.com,🔄$app_name
  - DOMAIN-SUFFIX,symcb.com,🔄$app_name
  - DOMAIN-SUFFIX,symcd.com,🔄$app_name
  - DOMAIN-SUFFIX,tapbots.com,🔄$app_name
  - DOMAIN-SUFFIX,tapbots.net,🔄$app_name
  - DOMAIN-SUFFIX,tdesktop.com,🔄$app_name
  - DOMAIN-SUFFIX,techcrunch.com,🔄$app_name
  - DOMAIN-SUFFIX,techsmith.com,🔄$app_name
  - DOMAIN-SUFFIX,thepiratebay.org,🔄$app_name
  - DOMAIN-SUFFIX,theverge.com,🔄$app_name
  - DOMAIN-SUFFIX,time.com,🔄$app_name
  - DOMAIN-SUFFIX,timeinc.net,🔄$app_name
  - DOMAIN-SUFFIX,tiny.cc,🔄$app_name
  - DOMAIN-SUFFIX,tinypic.com,🔄$app_name
  - DOMAIN-SUFFIX,tmblr.co,🔄$app_name
  - DOMAIN-SUFFIX,todoist.com,🔄$app_name
  - DOMAIN-SUFFIX,trello.com,🔄$app_name
  - DOMAIN-SUFFIX,trustasiassl.com,🔄$app_name
  - DOMAIN-SUFFIX,tumblr.co,🔄$app_name
  - DOMAIN-SUFFIX,tumblr.com,🔄$app_name
  - DOMAIN-SUFFIX,tweetdeck.com,🔄$app_name
  - DOMAIN-SUFFIX,tweetmarker.net,🔄$app_name
  - DOMAIN-SUFFIX,twitch.tv,🔄$app_name
  - DOMAIN-SUFFIX,txmblr.com,🔄$app_name
  - DOMAIN-SUFFIX,typekit.net,🔄$app_name
  - DOMAIN-SUFFIX,ubertags.com,🔄$app_name
  - DOMAIN-SUFFIX,ublock.org,🔄$app_name
  - DOMAIN-SUFFIX,ubnt.com,🔄$app_name
  - DOMAIN-SUFFIX,ulyssesapp.com,🔄$app_name
  - DOMAIN-SUFFIX,urchin.com,🔄$app_name
  - DOMAIN-SUFFIX,usertrust.com,🔄$app_name
  - DOMAIN-SUFFIX,v.gd,🔄$app_name
  - DOMAIN-SUFFIX,v2ex.com,🔄$app_name
  - DOMAIN-SUFFIX,vimeo.com,🔄$app_name
  - DOMAIN-SUFFIX,vimeocdn.com,🔄$app_name
  - DOMAIN-SUFFIX,vine.co,🔄$app_name
  - DOMAIN-SUFFIX,vivaldi.com,🔄$app_name
  - DOMAIN-SUFFIX,vox-cdn.com,🔄$app_name
  - DOMAIN-SUFFIX,vsco.co,🔄$app_name
  - DOMAIN-SUFFIX,vultr.com,🔄$app_name
  - DOMAIN-SUFFIX,w.org,🔄$app_name
  - DOMAIN-SUFFIX,w3schools.com,🔄$app_name
  - DOMAIN-SUFFIX,webtype.com,🔄$app_name
  - DOMAIN-SUFFIX,wikiwand.com,🔄$app_name
  - DOMAIN-SUFFIX,wikileaks.org,🔄$app_name
  - DOMAIN-SUFFIX,wikimedia.org,🔄$app_name
  - DOMAIN-SUFFIX,wikipedia.com,🔄$app_name
  - DOMAIN-SUFFIX,wikipedia.org,🔄$app_name
  - DOMAIN-SUFFIX,windows.com,🔄$app_name
  - DOMAIN-SUFFIX,windows.net,🔄$app_name
  - DOMAIN-SUFFIX,wire.com,🔄$app_name
  - DOMAIN-SUFFIX,wordpress.com,🔄$app_name
  - DOMAIN-SUFFIX,workflowy.com,🔄$app_name
  - DOMAIN-SUFFIX,wp.com,🔄$app_name
  - DOMAIN-SUFFIX,wsj.com,🔄$app_name
  - DOMAIN-SUFFIX,wsj.net,🔄$app_name
  - DOMAIN-SUFFIX,xda-developers.com,🔄$app_name
  - DOMAIN-SUFFIX,xeeno.com,🔄$app_name
  - DOMAIN-SUFFIX,xiti.com,🔄$app_name
  - DOMAIN-SUFFIX,yahoo.com,🔄$app_name
  - DOMAIN-SUFFIX,yimg.com,🔄$app_name
  - DOMAIN-SUFFIX,ying.com,🔄$app_name
  - DOMAIN-SUFFIX,yoyo.org,🔄$app_name
  - DOMAIN-SUFFIX,ytimg.com,🔄$app_name

  # Telegram
  - DOMAIN-SUFFIX,telegra.ph,🔄$app_name
  - DOMAIN-SUFFIX,telegram.org,🔄$app_name
  - IP-CIDR,91.108.4.0/22,🔄$app_name,no-resolve
  - IP-CIDR,91.108.8.0/21,🔄$app_name,no-resolve
  - IP-CIDR,91.108.16.0/22,🔄$app_name,no-resolve
  - IP-CIDR,91.108.56.0/22,🔄$app_name,no-resolve
  - IP-CIDR,149.154.160.0/20,🔄$app_name,no-resolve
  - IP-CIDR6,2001:67c:4e8::/48,🔄$app_name,no-resolve
  - IP-CIDR6,2001:b28:f23d::/48,🔄$app_name,no-resolve
  - IP-CIDR6,2001:b28:f23f::/48,🔄$app_name,no-resolve

  # Google 中国服务 services.googleapis.cn
  - IP-CIDR,120.232.181.162/32,🔄$app_name,no-resolve
  - IP-CIDR,120.241.147.226/32,🔄$app_name,no-resolve
  - IP-CIDR,120.253.253.226/32,🔄$app_name,no-resolve
  - IP-CIDR,120.253.255.162/32,🔄$app_name,no-resolve
  - IP-CIDR,120.253.255.34/32,🔄$app_name,no-resolve
  - IP-CIDR,120.253.255.98/32,🔄$app_name,no-resolve
  - IP-CIDR,180.163.150.162/32,🔄$app_name,no-resolve
  - IP-CIDR,180.163.150.34/32,🔄$app_name,no-resolve
  - IP-CIDR,180.163.151.162/32,🔄$app_name,no-resolve
  - IP-CIDR,180.163.151.34/32,🔄$app_name,no-resolve
  - IP-CIDR,203.208.39.0/24,🔄$app_name,no-resolve
  - IP-CIDR,203.208.40.0/24,🔄$app_name,no-resolve
  - IP-CIDR,203.208.41.0/24,🔄$app_name,no-resolve
  - IP-CIDR,203.208.43.0/24,🔄$app_name,no-resolve
  - IP-CIDR,203.208.50.0/24,🔄$app_name,no-resolve
  - IP-CIDR,220.181.174.162/32,🔄$app_name,no-resolve
  - IP-CIDR,220.181.174.226/32,🔄$app_name,no-resolve
  - IP-CIDR,220.181.174.34/32,🔄$app_name,no-resolve

  # LAN
  - DOMAIN,injections.adguard.org,DIRECT
  - DOMAIN,local.adguard.org,DIRECT
  - DOMAIN-SUFFIX,local,DIRECT
  - IP-CIDR,127.0.0.0/8,DIRECT
  - IP-CIDR,172.16.0.0/12,DIRECT
  - IP-CIDR,192.168.0.0/16,DIRECT
  - IP-CIDR,10.0.0.0/8,DIRECT
  - IP-CIDR,17.0.0.0/8,DIRECT
  - IP-CIDR,100.64.0.0/10,DIRECT
  - IP-CIDR,224.0.0.0/4,DIRECT
  - IP-CIDR6,fe80::/10,DIRECT

  # 剩余未匹配的国内网站
  - DOMAIN,clash.razord.top,DIRECT
  - DOMAIN,yacd.haishan.me,DIRECT
  - GEOIP,LAN,DIRECT,no-resolve
  - GEOIP,CN,DIRECT,no-resolve
  - MATCH,🔄$app_name
```



# 双节点

```
Log:
  Level: warning # Log level: none, error, warning, info, debug
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/rouating.html for help
InboundConfigPath: # /etc/XrayR/custom_inbound.json # Path to custom inbound config, check https://xtls.github.io/config/inbound.html for help
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnectionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 30 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB
Nodes:
  - PanelType: "NewV2board" # Panel type: SSpanel, NewV2board, PMpanel, Proxypanel, V2RaySocks, GoV2Panel, BunPanel
    ApiConfig:
      ApiHost: "Xboard的URL/"
      ApiKey: "KEY"
      NodeID: 号码
      NodeType: Shadowsocks # Node type: V2ray, Vmess, Vless, Shadowsocks, Trojan, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: true  # Enable Vless for V2ray Type
      VlessFlow: "xtls-rprx-vision" # Only support vless
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 0 # Local settings will replace remote settings, 0 means disable
      RuleListPath: # /etc/XrayR/rulelist Path to local rulelist file
      DisableCustomConfig: false # disable custom config for sspanel
    ControllerConfig:
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      AutoSpeedLimitConfig:
        Limit: 0 # Warned speed. Set to 0 to disable AutoSpeedLimit (mbps)
        WarnTimes: 0 # After (WarnTimes) consecutive warnings, the user will be limited. Set to 0 to punish overspeed user immediately.
        LimitSpeed: 0 # The speedlimit of a limited user (unit: mbps)
        LimitDuration: 0 # How many minutes will the limiting last (unit: minute)
      GlobalDeviceLimitConfig:
        Enable: false # Enable the global device limit of a user
        RedisNetwork: tcp # Redis protocol, tcp or unix
        RedisAddr: 127.0.0.1:6379 # Redis server address, or unix socket path
        RedisUsername: # Redis username
        RedisPassword: YOUR PASSWORD # Redis password
        RedisDB: 0 # Redis DB
        Timeout: 5 # Timeout for redis request
        Expiry: 60 # Expiry time (second)
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        - SNI: # TLS SNI(Server Name Indication), Empty for any
          Alpn: # Alpn, Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback, check https://xtls.github.io/config/features/fallback.html for details.
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for disable
      DisableLocalREALITYConfig: true # disable local reality config
      EnableREALITY: true # Enable REALITY
      REALITYConfigs:
        Show: true # Show REALITY debug
        Dest: www.amazon.com:443 # Required, Same as fallback
        ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for disable
        ServerNames: # Required, list of available serverNames for the client, * wildcard is not supported at the moment.
          - www.amazon.com
        PrivateKey: YOUR_PRIVATE_KEY # Required, execute './XrayR x25519' to generate.
        MinClientVer: # Optional, minimum version of Xray client, format is x.y.z.
        MaxClientVer: # Optional, maximum version of Xray client, format is x.y.z.
        MaxTimeDiff: 0 # Optional, maximum allowed time difference, unit is in milliseconds.
        ShortIds: # Required, list of available shortIds for the client, can be used to differentiate between different clients.
          - ""
          - 0123456789abcdef
      CertConfig:
        CertMode: dns # Option about how to get certificate: none, file, http, tls, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "node1.test.com" # Domain to cert
        CertFile: /etc/XrayR/cert/node1.test.com.cert # Provided if the CertMode is file
        KeyFile: /etc/XrayR/cert/node1.test.com.key
        Provider: alidns # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          ALICLOUD_ACCESS_KEY: aaa
          ALICLOUD_SECRET_KEY: bbb
  - PanelType: "NewV2board"
    ApiConfig:
      ApiHost: "URL"
      ApiKey: "号码"
      NodeID: 2
      NodeType: Vless
      Timeout: 30
      EnableVless: true
      VlessFlow: "xtls-rprx-vision"
      SpeedLimit: 0
      DeviceLimit: 0
      RuleListPath:
      DisableCustomConfig: false
    ControllerConfig:
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60
      EnableDNS: false
      DNSType: AsIs
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 0
        WarnTimes: 0
        LimitSpeed: 0
        LimitDuration: 0
      GlobalDeviceLimitConfig:
        Enable: false
        RedisNetwork: tcp
        RedisAddr: 127.0.0.1:6379
        RedisUsername:
        RedisPassword: YOUR PASSWORD
        RedisDB: 0
        Timeout: 5
        Expiry: 60
      EnableFallback: false
      FallBackConfigs: []
      DisableLocalREALITYConfig: true
      EnableREALITY: true
      REALITYConfigs:
        Show: true
        Dest: www.amazon.com:443
        ProxyProtocolVer: 0
        ServerNames:
          - www.amazon.com
        PrivateKey: YOUR_PRIVATE_KEY
        MinClientVer:
        MaxClientVer:
        MaxTimeDiff: 0
        ShortIds:
          - ""
          - 0123456789abcdef
      CertConfig:
        CertMode: dns
        CertDomain: "node2.test.com"
        CertFile: /etc/XrayR/cert/node2.test.com.cert
        KeyFile: /etc/XrayR/cert/node2.test.com.key
        Provider: alidns
        Email: test@me.com
        DNSEnv:
          ALICLOUD_ACCESS_KEY: aaa
          ALICLOUD_SECRET_KEY: bbb
          
```

# Reality节点测试

```
for d in cdnssl.clicktale.net th.bing.com amd.com s7mbrstream.scene7.com b.6sc.co gray-wowt-prod.gtv-cdn.com electronics.sony.com www.nvidia.com tags.tiqcdn.com ocsp2.apple.com ; do t1=$(date +%s%3N); timeout 1 openssl s_client -connect $d:443 -servername $d </dev/null &>/dev/null && t2=$(date +%s%3N) && echo "$d: $((t2 - t1)) ms" || echo "$d: timeout"; done
```

```
for d in cdn.bizible.com logx.optimizely.com cdn77.api.userway.org ocsp2.apple.com store-images.s-microsoft.com c.s-microsoft.com configuration.ls.apple.com rum.hlx.page fpinit.itunes.apple.com s.go-mpulse.net ; do t1=$(date +%s%3N); timeout 1 openssl s_client -connect $d:443 -servername $d </dev/null &>/dev/null && t2=$(date +%s%3N) && echo "$d: $((t2 - t1)) ms" || echo "$d: timeout"; done
```

```
for d in tag-logger.demandbase.com www.xilinx.com gray.video-player.arcpublishing.com res-1.cdn.office.net logx.optimizely.com ce.mf.marsflag.com visualstudio.microsoft.com configuration.ls.apple.com www.bing.com ds-aksb-a.akamaihd.net ; do t1=$(date +%s%3N); timeout 1 openssl s_client -connect $d:443 -servername $d </dev/null &>/dev/null && t2=$(date +%s%3N) && echo "$d: $((t2 - t1)) ms" || echo "$d: timeout"; done
```

```
for d in c.s-microsoft.com beacon.gtv-pub.com ocsp2.apple.com s.go-mpulse.net intel.com amd.com a0.awsstatic.com github.gallerycdn.vsassets.io prod.us-east-1.ui.gcr-chat.marketing.aws.dev gray-config-prod.api.cdn.arcpublishing.com ; do t1=$(date +%s%3N); timeout 1 openssl s_client -connect $d:443 -servername $d </dev/null &>/dev/null && t2=$(date +%s%3N) && echo "$d: $((t2 - t1)) ms" || echo "$d: timeout"; done
```

```
for d in api.company-target.com gray.video-player.arcpublishing.com c.6sc.co s.company-target.com store-images.s-microsoft.com intelcorp.scene7.com a0.awsstatic.com www.sony.com ce.mf.marsflag.com iosapps.itunes.apple.com ; do t1=$(date +%s%3N); timeout 1 openssl s_client -connect $d:443 -servername $d </dev/null &>/dev/null && t2=$(date +%s%3N) && echo "$d: $((t2 - t1)) ms" || echo "$d: timeout"; done
```

```
for d in d1.awsstatic.com ms-vscode.gallerycdn.vsassets.io www.oracle.com ts4.tc.mm.bing.net www.aws.com a0.awsstatic.com devblogs.microsoft.com cdn.userway.org gray-config-prod.api.cdn.arcpublishing.com munchkin.marketo.net ; do t1=$(date +%s%3N); timeout 1 openssl s_client -connect $d:443 -servername $d </dev/null &>/dev/null && t2=$(date +%s%3N) && echo "$d: $((t2 - t1)) ms" || echo "$d: timeout"; done
```

```
for d in c.s-microsoft.com www.apple.com apps.apple.com acctcdn.msftauth.net www.aws.com statici.icloud.com gsp-ssl.ls.apple.com visualstudio.microsoft.com tag-logger.demandbase.com res-1.cdn.office.net ; do t1=$(date +%s%3N); timeout 1 openssl s_client -connect $d:443 -servername $d </dev/null &>/dev/null && t2=$(date +%s%3N) && echo "$d: $((t2 - t1)) ms" || echo "$d: timeout"; done
```

# DNS泄露问题

在我上面的Clash配置文件后



![image-20250913000408858](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250913000408858.png)

开启遵循路由即可

![image-20250913000428092](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250913000428092.png)

# 负载均衡

配置文件中添加如下即可

```
proxy-groups:
  - { name: "🔄$app_name", type: select, proxies: ["自动选择", "故障转移", "负载均衡"] }
  - { name: "💬ChatGPT", type: url-test, proxies: [/USA/],
      url: "https://chat.openai.com",
      interval: 600, timeout: 3000, tolerance: 80 }
  - { name: "🎬Netflix", type: select, proxies: [/SG/, /JP/] }
  - { name: "自动选择", type: url-test, proxies: [],
      url: "https://www.gstatic.com/generate_204",
      interval: 300, timeout: 3000, tolerance: 80 }
  - { name: "故障转移", type: fallback, proxies: [],
      url: "https://www.gstatic.com/generate_204",
      interval: 600, timeout: 3000 }
  - { name: "负载均衡", type: load-balance, proxies: [/USA/,/HK/,/TW/, /SG/, /JP/],
      url: "https://www.gstatic.com/generate_204",
      interval: 300, strategy: round-robin }
```

# UDP代理

https://browserleaks.com/webrtc

进行检测 可以很容易发现没有走代理 这是因为本网页发起 Stun请求 走的是UDP 但是UDP不走代理 所以是直连访问

![image-20250917160234649](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250917160234649.png)

最简单的方法就是开启TUN模式 这样你的全局都是走Clash代理 UDP TCP均是

![image-20250917160804045](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250917160804045.png)

在我开启TUN模式后 如图所示

当然要求你的节点开启UDP

![image-20250917160950897](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250917160950897.png)

所以我们游戏加速器 只要开启TUN即可

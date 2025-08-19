[来源](https://www.nodeseek.com/post-410959-1)

# 确定BBR加速

```
sysctl net.ipv4.tcp_congestion_control | grep bbr && echo "BBR 已启用" || echo "启用失败"
lsmod | grep bbr
```

# 如果没有打开

```
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
```

```
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
```

```
sudo sysctl -p
```

# 安装realm

```
mkdir realm 
cd realm
wget https://github.com/zhboner/realm/releases/download/v2.7.0/realm-x86_64-unknown-linux-gnu.tar.gz
tar -xzvf realm-x86_64-unknown-linux-gnu.tar.gz
chmod +x realm
sudo mv realm /usr/local/bin/
rm ./realm-x86_64-unknown-linux-gnu.tar.gz
vim realm.toml

```

# 配置文件

```
[log]
level = "warn"
output = "/root/realm.log"

#如果DNS异常才用这个
#[dns]
#mode = "ipv4_only"
#nameservers = ["8.8.8.8:53", "8.8.4.4:53"]  
#min_ttl = 300    
#max_ttl = 1800  
#cache_size = 128 

[network]
use_udp = true
tcp_timeout = 10
udp_timeout = 30
tcp_keepalive = 15

[[endpoints]]
listen = "0.0.0.0:端口"
remote = "目标IP:端口"

[[endpoints]]
listen = "0.0.0.0:端口"
remote = "目标IP:端口"
```

# 写入自启动

```
vim  /etc/systemd/system/realm.service
```

```
[Unit]
Description=Realm Proxy Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/realm -c /root/realm/realm.toml
Restart=on-failure
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
```

```
sudo systemctl daemon-reload
sudo systemctl enable realm
sudo systemctl restart realm
```

```
sudo systemctl status realm
```

结束
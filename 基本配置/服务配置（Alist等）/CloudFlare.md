购买了一个域名 现在正好复现一下如何通过CF代理整个网站

首先购买域名然后DNS设置为CF 就可以通过CF操作

![image-20250707230544956](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250707230544956.png)

首先为测试服务器添加一个DNS

![image-20250707230733439](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250707230733439.png)

配置TLS



![image-20250707230851450](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250707230851450.png)

复制两个到本地 然后添加到VPS

配置Nginx

```
    server {
        listen 443 ssl http2;
        server_name test.csdn.im;
        ssl_certificate /etc/nginx/cert/.xyz/cert.pem;  证书公钥地址
        ssl_certificate_key /etc/nginx/cert/.xyz/key.pem; 证书私钥地址
		/服务
        location / {
            proxy_pass http://127.0.0.1:5244;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection Upgrade;
            proxy_set_header Host $host;
        }
    }
    
```

配置TSL为完全模式

![image-20250708000237725](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250708000237725.png)

# 配置防火墙防止探测

进入域名

![image-20250520151508548](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250520151508548.png)

自定义规则 

规则1 阻止特定国家探测

![image-20250520151544990](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250520151544990.png)

```
(not ip.geoip.country in {"JP" "CN"})
```

规则2 允许我们的IP访问

![image-20250520151610630](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250520151610630.png)

```
(ip.src in $ip)
```

![image-20250520151622916](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250520151622916.png)

这样就可以防止大部分探测


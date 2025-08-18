# 搭建komari探针

可能是比nezha更年轻的一个探针 有很多优点

例如 30天的延迟等其他内容

https://komari-document.pages.dev/install/quick-start.html

## 搭建

```
curl -fsSL https://raw.githubusercontent.com/komari-monitor/komari/main/install-komari.sh -o install-komari.sh
chmod +x install-komari.sh
sudo ./install-komari.sh
```

搭建在NetJett VPS上

![image-20250818170134716](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250818170134716.png)

配置CF或者反向代理

我这里使用亚洲云JP实现反向代理

# 反向代理

签名

```
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx

# 创建证书存放目录（按你的要求）
sudo mkdir -p /etc/nginx/cert/web.xyz
sudo chown root:root /etc/nginx/cert/web.xyz
sudo chmod 700 /etc/nginx/cert/web.xyz

# 使用 certbot-nginx 为子域签发，并把证书写进你指定路径
sudo certbot --nginx \
  -d tantan.web.xyz \
  --key-path /etc/nginx/cert/web.xyz/privkey.pem \
  --fullchain-path /etc/nginx/cert/web.xyz/fullchain.pem \
  --email 你的邮箱@example.com \
  --agree-tos --no-eff-email

```



```
user  www-data;
worker_processes  auto;

pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 1024;
    # multi_accept on;
}

http {
    # 基础优化
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log  /var/log/nginx/error.log;

    # 反向代理超时
    proxy_connect_timeout 15s;
    proxy_send_timeout    60s;
    proxy_read_timeout    60s;

    # WebSocket/长连接升级
    map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
    }

    # ---------- 80: 仅重定向到 HTTPS ----------
    server {
        listen 80;
        server_name #域名;

        # 如系统存在默认站点占用，可考虑启用 default_server
        # listen 80 default_server;

        location / {
            return 301 https://$host$request_uri;
        }

        # 健康页（明文也可健康检查）
        location = /nginx-health {
            return 200 'ok';
            add_header Content-Type text/plain;
        }
    }

    # ---------- 443: HTTPS + 反向代理 ----------
    server {
        listen 443 ssl http2;
        server_name #域名;

        # ====== 证书路径（按你给的目录）======
        ssl_certificate     /etc/nginx/ #证书
        ssl_certificate_key /etc/nginx/privkey.pem;# 密钥

        # ====== TLS 推荐参数 ======
        ssl_session_timeout 1d;
        ssl_session_cache   shared:SSL:10m;
        ssl_session_tickets off;

        # TLS 版本（如需兼容非常老的客户端，可降到 TLSv1.2）
        ssl_protocols TLSv1.2 TLSv1.3;

        # 现代浏览器下 cipher 一般无需强制，交给 OpenSSL 默认即可
        # ssl_ciphers HIGH:!aNULL:!MD5;

        # 开启 OCSP Stapling（若有链路与权限）
        # ssl_stapling on;
        # ssl_stapling_verify on;
        # resolver 8.8.8.8 1.1.1.1 valid=300s;
        # resolver_timeout 5s;

        # 可选：HSTS（确认全站 HTTPS 后再开启，避免误伤）
        # add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

        # 上传与缓冲
        client_max_body_size 50M;
        proxy_buffering off;
        proxy_redirect  off;

        # 反代到上游
        location / {
            proxy_pass http://IP:25774; #你的IP

            # 透传 Host 与真实 IP
            proxy_set_header Host              $host;
            proxy_set_header X-Real-IP         $remote_addr;
            proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            # WebSocket/HTTP1.1
            proxy_http_version 1.1;
            proxy_set_header Upgrade           $http_upgrade;
            proxy_set_header Connection        $connection_upgrade;
        }

        # 健康页（HTTPS）
        location = /nginx-health {
            return 200 'ok';
            add_header Content-Type text/plain;
        }
    }

    # 你的 include 保留
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}

```

就可以实现反向代理了

最后就是没啥了
# Nezha CDN

```nginx
user  www-data;
worker_processes  auto;
pid        /run/nginx.pid;
error_log  /var/log/nginx/error.log warn;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    # —— 日志格式 —— 
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    sendfile           on;
    keepalive_timeout  65;
    access_log         /var/log/nginx/access.log main;

    # —— WebSocket 升级支持 —— 
    map $http_upgrade $connection_upgrade {
        default   upgrade;
        ""        close;
    }

    # —— 缓存区定义 —— 
    proxy_cache_path /var/cache/nginx/tan levels=1:2 keys_zone=tan_cache:100m max_size=5g inactive=30m use_temp_path=off;

    # —— 后端服务 —— 
    upstream dashboard {
        server 82.21.190.8:8008;   # 若后端在本机，可改成 127.0.0.1:8008
        keepalive 512;
    }

    # —— HTTP 强制重定向到 HTTPS —— 
    server {
        listen      80;
        listen      [::]:80;
        server_name tan.722225.xyz;
        return 301  https://$host$request_uri;
    }

    # —— HTTPS + HTTP/2 + SSL —— 
    server {
        listen       443 ssl http2;
        listen       [::]:443 ssl http2;
        server_name  tan.722225.xyz;

        # —— Let’s Encrypt 证书路径 —— 
        ssl_certificate     /etc/letsencrypt/live/tan.722225.xyz/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/tan.722225.xyz/privkey.pem;


        # —— SSL 优化参数 —— 
        ssl_protocols        TLSv1.2 TLSv1.3;
        ssl_prefer_server_ciphers on;
        ssl_session_timeout  1d;
        ssl_session_cache    shared:SSL:10m;
        ssl_ciphers          EECDH+AESGCM:EDH+AESGCM;

        # —— 真实客户端 IP —— 
        set_real_ip_from     0.0.0.0/0;
        real_ip_header       CF-Connecting-IP;

        # —— gRPC 转发 —— 
        location ^~ /proto.NezhaService/ {
            grpc_set_header   Host            $host;
            grpc_set_header   nz-realip       $http_CF_Connecting_IP;
            grpc_read_timeout 600s;
            grpc_send_timeout 600s;
            grpc_socket_keepalive on;
            client_max_body_size 10m;
            grpc_buffer_size   4m;
            grpc_pass          grpc://dashboard;
        }

        # —— WebSocket 转发 —— 
        location ~* ^/api/v1/ws/(server|terminal|file)(.*)$ {
            proxy_pass              http://dashboard;
            proxy_http_version      1.1;
            proxy_set_header        Upgrade           $http_upgrade;
            proxy_set_header        Connection        $connection_upgrade;
            proxy_set_header        Host              $host;
            proxy_set_header        nz-realip         $http_cf_connecting_ip;
            proxy_set_header        Origin            https://$host;
            proxy_read_timeout      3600s;
            proxy_send_timeout      3600s;
            proxy_buffering         off;
        }

        # —— 静态资源长缓存 —— 
        location ~* \.(?:css|js|jpg|jpeg|png|gif|svg|ico|woff2?|ttf|eot)$ {
            proxy_pass              http://dashboard;
            proxy_http_version      1.1;
            proxy_cache             tan_cache;
            proxy_cache_valid       200 301 302 30d;
            proxy_cache_valid       404      1m;
            proxy_cache_use_stale   error timeout updating http_500 http_502 http_503 http_504;
            proxy_cache_lock        on;
            proxy_cache_lock_timeout 5s;
            add_header              X-Cache-Status $upstream_cache_status;
        }

        # —— 普通 HTTP 请求 —— 
        location / {
            proxy_pass              http://dashboard;
            proxy_http_version      1.1;
            proxy_set_header        Host              $host;
            proxy_set_header        nz-realip         $http_cf_connecting_ip;
            proxy_set_header        X-Real-IP         $remote_addr;
            proxy_set_header        X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;
            proxy_read_timeout      3600s;
            proxy_send_timeout      3600s;
        }
    }
}

```

## 签名

```
sudo apt update
sudo apt install snapd
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

```

```
sudo certbot --nginx \
  -d dashboard.example.com \
  --email 1111@outlook.com \
  --agree-tos \
  --no-eff-email \
  --redirect

```


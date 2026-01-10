[优选域名1](https://www.wetest.vip/page/cloudfront/cname.html)

[优选域名2](https://www.baota.me/post-411.html)

[推荐youtuber](https://www.youtube.com/watch?v=o7N4lm_qNHc&t=84s)

首先我们需要一个 备用域名 b.com 现在先配置b.com

# 大前提

需要验证支付方式 没有这个都白搭

# b.com

我们先对b.com配置

通过VPS配置开始 这里说明一个全新VPS

## 构建依赖

```shell
apt install nginx -y
mkdir /etc/nginx/cert/b.com
touch /etc/nginx/cert/b.com/cert.pem
touch /etc/nginx/cert/b.com/key.pem
```

## 测试页面

```shell
mv /var/www/html/in* /var/www/html/index.html
```

写入下面内容进入 index.html

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>静态示例页 · Simple Static HTML</title>
  <meta name="description" content="一个干净现代的静态HTML示例页面" />
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
  <style>
    :root {
      --bg: #0f1220;
      --card: #161a2b;
      --muted: #8b90a6;
      --text: #e6e8ef;
      --accent: #7c5cff;
      --accent-2: #25d0a6;
      --ring: rgba(124, 92, 255, 0.35);
      --radius: 16px;
    }

    * { box-sizing: border-box; }
    html, body { height: 100%; }
    body {
      margin: 0;
      font-family: "Inter", system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial;
      color: var(--text);
      background: radial-gradient(1200px 600px at 80% -10%, rgba(124,92,255,.15), transparent 60%),
                  radial-gradient(900px 800px at -10% 10%, rgba(37,208,166,.12), transparent 55%),
                  var(--bg);
      line-height: 1.6;
    }

    .container { max-width: 1000px; margin: 0 auto; padding: 24px; }

    header {
      display: flex; align-items: center; justify-content: space-between;
      gap: 16px; padding: 18px 0; position: sticky; top: 0; backdrop-filter: blur(6px);
    }
    .brand { display: flex; align-items: center; gap: 12px; font-weight: 800; letter-spacing: .3px; }
    .logo { width: 36px; height: 36px; border-radius: 10px; background: linear-gradient(135deg, var(--accent), var(--accent-2)); box-shadow: 0 8px 30px rgba(124,92,255,.45); }
    nav a { color: var(--text); text-decoration: none; opacity: .8; margin-left: 18px; }
    nav a:hover { opacity: 1; }

    .hero { padding: 72px 0 48px; text-align: center; }
    .hero h1 { font-size: clamp(28px, 5vw, 48px); line-height: 1.1; margin: 0 0 12px; }
    .hero p { color: var(--muted); margin: 0 auto 24px; max-width: 680px; }

    .cta {
      display: inline-flex; align-items: center; gap: 10px; padding: 12px 18px; border-radius: 999px;
      background: linear-gradient(135deg, var(--accent), var(--accent-2)); color: white; font-weight: 600;
      text-decoration: none; box-shadow: 0 10px 24px var(--ring);
      transform: translateY(0); transition: transform .15s ease, box-shadow .15s ease;
    }
    .cta:hover { transform: translateY(-1px); box-shadow: 0 16px 32px var(--ring); }

    .grid { display: grid; gap: 16px; grid-template-columns: repeat(12, 1fr); margin-top: 24px; }
    .card { grid-column: span 4; background: linear-gradient(180deg, rgba(255,255,255,.04), rgba(255,255,255,.02));
            border: 1px solid rgba(255,255,255,.06); border-radius: var(--radius); padding: 18px; position: relative;
            box-shadow: 0 1px 0 rgba(255,255,255,.05) inset, 0 12px 40px rgba(0,0,0,.25);
    }
    .card h3 { margin: 0 0 6px; font-size: 18px; }
    .card p { margin: 0; color: var(--muted); }

    .badge { position: absolute; top: 14px; right: 14px; font-size: 12px; padding: 6px 10px; border-radius: 999px; color: #10131f; background: #d9fcee; }

    .code {
      margin-top: 28px; background: var(--card); border: 1px solid rgba(255,255,255,.08); border-radius: 12px; padding: 16px;
      overflow-x: auto; font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: 13px;
    }

    footer { margin: 40px 0 24px; text-align: center; color: var(--muted); font-size: 14px; }

    @media (max-width: 900px) { .card { grid-column: span 6; } }
    @media (max-width: 600px) {
      nav { display:none; }
      .card { grid-column: span 12; }
      .hero { padding-top: 54px; }
    }
  </style>
</head>
<body>
  <div class="container">
    <header>
      <div class="brand">
        <div class="logo" aria-hidden="true"></div>
        <span>Nova</span>
      </div>
      <nav>
        <a href="#features">特性</a>
        <a href="#code">代码</a>
        <a href="#about">关于</a>
      </nav>
    </header>

    <section class="hero" id="top">
      <h1>开箱即用的静态 HTML 示例</h1>
      <p>零依赖、单文件、现代外观。复制即可使用，适合做占位页、示例页、或快速原型。</p>
      <a class="cta" href="#code" aria-label="跳转到示例代码">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
          <path d="M7 7l-5 5 5 5M17 7l5 5-5 5M10 19l4-14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        查看代码
      </a>
    </section>

    <section id="features" class="grid" aria-label="页面特性">
      <article class="card">
        <span class="badge">响应式</span>
        <h3>响应式布局</h3>
        <p>使用 CSS Grid 与 clamp() 字体尺寸，在手机与桌面上都能保持良好布局。</p>
      </article>
      <article class="card">
        <h3>现代视觉</h3>
        <p>柔和霓虹、圆角与细腻的阴影，轻量又有质感。</p>
      </article>
      <article class="card">
        <h3>易于定制</h3>
        <p>通过 <code>:root</code> 变量快速调整主题色与圆角、阴影等样式。</p>
      </article>
    </section>

    <section id="code" class="code" aria-label="示例代码">
<pre><code>&lt;!-- 复制下面结构开始你的页面 --&gt;
&lt;!DOCTYPE html&gt;
&lt;html lang="zh-CN"&gt;
&lt;head&gt;...&lt;/head&gt;
&lt;body&gt;你的内容...&lt;/body&gt;
&lt;/html&gt;
</code></pre>
    </section>

    <section id="about" style="margin-top:24px">
      <div class="card" style="grid-column: 1/-1;">
        <h3 style="margin-top:0">关于</h3>
        <p style="margin:0">本页面不依赖任何框架或脚本文件，直接保存为 <code>.html</code> 后双击即可在浏览器中打开。</p>
      </div>
    </section>

    <footer>
      © <span id="year"></span> Nova · Made with ♥ 静态HTML
    </footer>
  </div>

  <script>
    // 仅用于展示当前年份，不影响静态渲染
    document.getElementById('year').textContent = new Date().getFullYear();
  </script>
</body>
</html>

```

## 配置nginx

a.com为最终需要展示的站点

进入 **/etc/nginx/nginx.conf**

```nginx
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 768;
	# multi_accept on;
}

http {
# /etc/nginx/sites-available/your_domain
# ======================================
server {
    listen 80;
    listen [::]:80;
    server_name your_domain www.your_domain;
    return 302 https://$server_name$request_uri;
}

server {

    # SSL configuration
    server_name a.com;

    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    # 证书
    ssl_certificate     /etc/nginx/cert/a.com/cert.pem;
    ssl_certificate_key /etc/nginx/cert/a.com/key.pem;



    root /var/www//html;
    index index.html index.htm index.nginx-debian.html;


    location / {
            try_files $uri $uri/ =404;
    }
}
	##
	# Basic Settings
	##

	sendfile on;
	tcp_nopush on;
	types_hash_max_size 2048;
	# server_tokens off;

	# server_names_hash_bucket_size 64;
	# server_name_in_redirect off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	##
	# SSL Settings
	##

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	##
	# Logging Settings
	##

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	##
	# Gzip Settings
	##

	gzip on;

	# gzip_vary on;
	# gzip_proxied any;
	# gzip_comp_level 6;
	# gzip_buffers 16 8k;
	# gzip_http_version 1.1;
	# gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

	##
	# Virtual Host Configs
	##

	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}


#mail {
#	# See sample authentication script at:
#	# http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#	# auth_http localhost/auth.php;
#	# pop3_capabilities "TOP" "USER";
#	# imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#	server {
#		listen     localhost:110;
#		protocol   pop3;
#		proxy      on;
#	}
#
#	server {
#		listen     localhost:143;
#		protocol   imap;
#		proxy      on;
#	}
#}

```

这样服务器配置 结束

## 配置CF

### 配置DNS

首先配置一个A类型 指向 VPS **开启小黄云**

![image-20251108222455118](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251108222455118.png)

其次构建一个CNAME类型 指向优选域名 **关闭小黄云**

![image-20251108222608793](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251108222608793.png)

到此 辅助域名的DNS结束

### 配置回退

填写真正服务指向的域名 a.com

![image-20251108223051597](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251108223051597.png)

如果正常 就是这样

![image-20251108223150420](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251108223150420.png)

![image-20251108223203372](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251108223203372.png)

这里填写的是你对外开放的域名

![image-20251108223225977](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251108223225977.png)

直接确定 

如图所示

![image-20251108223341017](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251108223341017.png)

下面进入a.com的配置了

# a.com

进入a.com 的DNS

使用TXT类型验证

注意 **名称的 .域名 需要删除**

![image-20251108223428840](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251108223428840.png)

同理 证书配置即可

最后 等待时间 去设置一个CNAME a.com 指向 cdn.b.com

这样实现了 选优

![image-20251108230351798](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251108230351798.png)
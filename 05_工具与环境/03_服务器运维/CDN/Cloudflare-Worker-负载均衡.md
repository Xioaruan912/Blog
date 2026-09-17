# 用 Cloudflare Worker 做多节点负载均衡：完整流程与踩坑记录

> 目标：用一台 Cloudflare Worker，把 `file / proxy / pw.sssssss` 三个域名，负载均衡到两个后端节点（香港、日本），节点再反代到真实源站（荷兰）。

```
用户 → Cloudflare (file/proxy/pw.sssssss) → Worker(my-lb)
        → 节点1 香港 1.1.1.1（nginx 反代）
        → 节点2 日本 2.2.2.2（nginx 反代）
        → 真实源站 3.3.3.3（荷兰）
```

---

## 一、Nginx代码

两台服务器只做**反代转发**，把所有流量统一转发到真实源站，结构一模一样：

```nginx
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    tcp_nopush      on;
    tcp_nodelay     on;
    keepalive_timeout  65;
    types_hash_max_size 2048;

    # 日志格式
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    # Gzip 压缩
    gzip on;
    gzip_disable "msie6";

    # =========================================================
    # 映射真实的 Host 标头：
    # 优先读取 Worker 传过来的 X-Forwarded-Host，如果为空则降级取 $host
    # =========================================================
    map $http_x_forwarded_host $real_host {
        default $http_x_forwarded_host;
        ""      $host;
    }

    # ---------------------------------------------------------
    # 路由 1: file.sssssss -> 端口 5244
    # ---------------------------------------------------------
    server {
        listen 5244 default_server;
        listen [::]:5244 default_server;
        server_name _;

        location / {
            # 还原真实的 Host 传给后端源站
            proxy_set_header Host $real_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;

            # 启用 WebSocket 支持（如 OpenList/AList 需要）
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            # 转发至最终源站（去掉末尾斜杠，避免路由拼接 403）
            proxy_pass http://0.0.0.0:5244;
        }
    }

    # ---------------------------------------------------------
    # 路由 2: proxy.sssssss -> 端口 8001
    # ---------------------------------------------------------
    server {
        listen 8001 default_server;
        listen [::]:8001 default_server;
        server_name _;

        location / {
            proxy_set_header Host $real_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;

            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            proxy_pass http://0.0.0.0:8001;
        }
    }

    # ---------------------------------------------------------
    # 路由 3: pw.sssssss -> 端口 8443
    # ---------------------------------------------------------
    server {
        listen 8443 default_server;
        listen [::]:8443 default_server;
        server_name _;

        location / {
            proxy_set_header Host $real_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;

            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            proxy_pass http://0.0.0.0:8443;
        }
    }
}
```

> 端口规划：`5244`=文件站、`8001`=订阅/proxy、`8443`=密码页。`server_name _` + `default_server` 让 nginx 不关心 Host，直接转发。

---

## 二、Worker 代码

首先安装

```
npm install -g wrangler
wrangler login
wrangler init my-lb
cd my-lb
npm install worker-lb
```

然后 写入到 `src/index.ts`

```ts
import { Endpoint, LoadBalancer } from 'worker-lb';

// 三个域名 -> 对应后端端口
const routes = {
  'proxy.sssssss': { port: 8001, lb: null },
  'file.sssssss':  { port: 5244, lb: null },
  'pw.sssssss':    { port: 8443, lb: null },
};

// 后端节点必须用「域名」！不能用裸 IP（见踩坑3）
const nodeHosts = ['node1.sssssss', 'node2.sssssss'];

for (const [domain, config] of Object.entries(routes)) {
  config.lb = new LoadBalancer({
    endpoints: nodeHosts.map(host =>
      new Endpoint(`http://${host}:${config.port}`)
    ),
  });
}

export default {
  async fetch(request) {
    const url = new URL(request.url);
    const hostname = url.hostname;
    const route = routes[hostname];
    if (!route) return new Response('Domain not configured', { status: 404 });

    // 关键：强制把 Host 设为原始域名（不要用 IP）
    const headers = new Headers(request.headers);
    headers.set('Host', hostname);

    const newRequest = new Request(request.url, {
      method: request.method,
      headers,
      body: request.body,
    });

    try {
      return await route.lb.handleRequest(newRequest);
    } catch (e) {
      return new Response('Backend unreachable', { status: 502 });
    }
  },
};
```

```
wrangler deploy
```

## 三、Cloudflare 面板端需要做的操作

### 1. 给后端节点建 A 记录（灰云！）
在 `sssssss` 的 **DNS** 里新建两条 **A 记录**：

| 名称 | 内容（IPv4） | 代理状态 |
|------|------------|---------|
| `node1` | `1.1.1.1` | **仅 DNS（灰云）** |
| `node2` | `2.2.2.2` | **仅 DNS（灰云）** |

### 2. 把三个域名绑定到 Worker（自定义域名）
在 Worker → `my-lb` → **设置 → 域和路由**，添加三个**自定义域名**：

```
file.sssssss    → my-lb
proxy.sssssss   → my-lb
pw.sssssss      → my-lb
```

### 3. 部署 Worker
```
npx wrangler deploy
```

---

## 四、踩坑记录（重点）

`file` / `proxy` 报 403，错误码 **1003 "Direct IP Access Not Allowed"**（最坑）

**现象**：浏览器访问返回 `error code: 1003`，但直接 `curl http://1.1.1.1:5244` 却是 200，后端完全正常。
**根因**：**Cloudflare Worker 的 `fetch()` 禁止请求裸 IP**（防 SSRF 滥用）。只要代码里写 `http://1.1.1.1:5244` 这种裸 IP，Worker 发出的请求就会被 Cloudflare 边缘直接拦下，返回 1003。只有从 Worker（Cloudflare 网络）发起才会触发，本地 curl 永远复现不了。
**解决**：把裸 IP 换成**域名**。在 Cloudflare 建 A 记录 `node1.sssssss → 1.1.1.1`，Worker 用 `fetch("http://node1.sssssss:5244")`。官方确认：Worker 只允许 fetch 域名，不允许 fetch 裸 IP。

> 注意：A 记录必须**灰云（仅 DNS）**。如果点了橙色云（代理），Worker fetch 时又会经过 Cloudflare 代理，可能再次出问题。

---

## 五、验证

```
curl -s -o /dev/null -w "%{http_code}\n" https://file.sssssss   # 200
curl -s -o /dev/null -w "%{http_code}\n" https://proxy.sssssss # 200
curl -s -o /dev/null -w "%{http_code}\n" https://pw.sssssss    # 200
```

响应头里出现 `x-load-balancer-endpoint` 就说明负载均衡器生效了。

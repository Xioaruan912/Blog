# 学习网站

[https://wiyi.org/socks5-protocol-in-deep.html](https://wiyi.org/socks5-protocol-in-deep.html)



# socks5传输过程

```
┌──────────────────┐
│   应用程序       │
│ (浏览器 / curl)  │
└────────┬─────────┘
         │
         │ 1️⃣ 连接代理 TCP
         ▼
┌──────────────────┐
│   SOCKS5 代理    │
└────────┬─────────┘
         │
         │ 2️⃣ 方法协商
         │  VER=5, METHODS=[无认证]
         │
         │◀────────── OK
         │
         │ 3️⃣ CONNECT 请求
         │  目标 = example.com:443
         │
         │──────────▶
         │
         │ 4️⃣ 代理建立连接
         │    (自己去连目标)
         │
         │◀────────── 成功/失败
         │
         │ 5️⃣ 进入转发模式
         │
═════════╪═══════════════════════════════
         │  ← SOCKS5 协议到此结束 →
═════════╪═══════════════════════════════
         │
         │ 6️⃣ 原始数据双向转发
         │
         ▼
┌──────────────────┐
│  目标服务器      │
│ example.com:443  │
└──────────────────┘

```

socks相当于在防火墙撕了一道口子，让合法的用户可以通过这个口子连接到内部，从而访问内部的一些资源和进行管理。

socks5传输过程主要经历握手阶段、请求阶段，Relay阶段

# 握手阶段

### 用户

在TCP链接后 SOCKS5进入握手阶段

```
+----+----------+----------+
|VER | NMETHODS | METHODS  |
+----+----------+----------+
| 1  |    1     |  1~255   |

```

VER： 固定05 代表socks5

NMETHODS：提供的认证方式 说明的是METHODS 有几个认证方式

```
05 02 00 02
socks5 提供2个认证方式 00 02
```

METHODS: 认证的具体方法 socks5有预设一些认证的方法

1.  `00` ：NO AUTH 无认证
2.  `01` ：GSSAPI
3.  `02` ：USERNAME/PASSWORD 账号密码 这也常见
4.  `0x03–0x7F` : IANA 分配
5.  `0x80–0xFE` : 私有方法
6.  `0xFF` : NO ACCEPTABLE METHODS 用于服务端拒绝时的回复

### 服务器

服务器接受到 握手的时候 选中一个 METHOD 返回给用户

```
+----+--------+
|VER | METHOD |
+----+--------+
| 1  |   1    |
+----+--------+
```

这样就协商完毕 握手

# 认证阶段

如果选中02 等其他方法 就需要认证

### 用户

客户端发送下列认证格式

```
+----+------+----------+------+----------+
|VER | ULEN |  UNAME   | PLEN |  PASSWD  |
+----+------+----------+------+----------+
| 1  |  1   | 1 to 255 |  1   | 1 to 255 |
+----+------+----------+------+----------+
```

VER: 版本 `0x01`

ULEN: 用户名长度

UNAME:  用户名 数据

PLEN: 密码长度

PASSWD: 密码 数据

### 服务器

服务器收到信息后 解析内容 验证 返回下列内容

```
+----+--------+
|VER | STATUS |
+----+--------+
| 1  |   1    |
+----+--------+
```

STATUS 00 则认证成功 其他均失败

# 请求阶段

### 用户发送

下面就是请求服务器发送数据

```
+----+-----+-------+------+----------+----------+
|VER | CMD |  RSV  | ATYP | DST.ADDR | DST.PORT |
+----+-----+-------+------+----------+----------+
| 1  |  1  | X'00' |  1   | Variable |    2     |
+----+-----+-------+------+----------+----------+
```

- VER: 版本号 默认 `0x05`

- CMD

  1. `0x01`表示CONNECT请求 帮我**主动连**一个目标

  2. `0x02`表示BIND请求 我等着，**让别人来连我**

  3. `0x03`表示UDP转发 帮我**转发 UDP 数据**

- RSV 保留字段，值为`0x00`

- ATYP 目标地址类型 表示` DST.ADDR` 的类型

  1. `0x01`表示IPv4地址

  2. `0x03`表示域名

  3. `0x04`表示IPv6地址

- DST.ADDR 一个可变长度的值

- DST.PORT 目标端口，固定2个字节

### 服务器接受

接受后返回如下内容

```
+----+-----+-------+------+----------+----------+
|VER | REP |  RSV  | ATYP | BND.ADDR | BND.PORT |
+----+-----+-------+------+----------+----------+
| 1  |  1  | X'00' |  1   | Variable |    2     |
+----+-----+-------+------+----------+----------+
```

- VER socks版本 `0x05`
- REP Relay field `代理是否成功完成了你刚才请求的那件事`
  - X’00’ succeeded `代表连接成功`
  - X’01’ general SOCKS server failure  `代理内部错误`
  - X’02’ connection not allowed by ruleset `策略 不允许这次连接`
  - X’03’ Network unreachable `网络层不可达`
  - X’04’ Host unreachable `网络能到，但目标主机不可达`
  - X’05’ Connection refused `目标主机明确拒绝`
  - X’06’ TTL expired `数据包在路由途中“跑太久死掉了”`
  - X’07’ Command not supported `代理不支持该 CMD`
  - X’08’ Address type not supported `代理不支持该 ATYP`
  - X’09’ to X’FF’ unassigned `自定义的没有实现`
- RSV 保留字段
- ATYPE 同请求的ATYPE
- BND.ADDR 服务绑定的地址 `服务器本地IP` 这里需要告知转发 客户端
- BND.PORT 服务绑定的端口DST.PORT `服务器的监听端口`

当我们的relay server和socks5 server是同一台服务器时，`BND.ADDR`和`BND.PORT`的值全部为0即可。

# Relay阶段

也就是服务器代替访问阶段

socks5服务器收到请求后，解析内容。

如果是UDP请求，服务器直接转发

如果是TCP请求，服务器向目标服务器建立TCP连接，后续负责把客户端的所有数据转发到目标服务。

# GO实现socks5

现在通过go实现一个socks5代理

## 握手阶段

### 用户

```go
package main

import (
	"bufio"
	"fmt"
	"io"
	"net"
	"time"
)

//用户端代码

const (
	//握手阶段
	socksVER                  = 0x05
	METHODS_NOAUTH            = 0x00
	METHODS_GSSAPI            = 0x01
	METHODS_USERNAME_PASSWORD = 0x02
	//请求阶段
	CMD_CONNECT = 0x01
	CMD_BIND    = 0x02
	CMD_UDP     = 0x03
	RSV         = 0x00
	ATYP_IPV4   = 0x01
	ATYP_URL    = 0x03
	ATYP_IPV6   = 0x04
)

func socks5Handshake(conn net.Conn) error { //传入的是net
	//构建握手 字节流
	greeting := []byte{socksVER, 0x03, METHODS_NOAUTH, METHODS_GSSAPI, METHODS_USERNAME_PASSWORD}
	// 使用 conn.Write 传输字节流
	_ = conn.SetDeadline(time.Now().Add(5 * time.Second))
	if _, err := conn.Write(greeting); err != nil {
		return fmt.Errorf("write greeting: %w", err)
	}
	br := bufio.NewReader(conn)
	//通过NewReader 获取接受到的内容 缓冲区
	reply := make([]byte, 2)
	if _, err := io.ReadFull(br, reply); err != nil {
		return fmt.Errorf("read method reply: %w", err)
	}
	if reply[0] != 0x05 {
		return fmt.Errorf("bad server version: 0x%02x", reply[0])
	}
	if reply[1] == 0xFF {
		return fmt.Errorf("no acceptable methods (server replied 0xFF)")
	}
	if reply[1] != 0x00 {
		return fmt.Errorf("server chose unsupported method: 0x%02x", reply[1])
	}

	// 握手（协商）成功
	_ = conn.SetDeadline(time.Time{}) // 取消超时，后续由上层控制
	return nil

}

func main() {
	// 代理地址（你的 socks5 server）
	proxyAddr := "127.0.0.1:1080"

	conn, err := net.Dial("tcp", proxyAddr)
	if err != nil {
		panic(err)
	}
	//兜底
	defer conn.Close() //等 main() 这个函数要结束的时候  conn.Close() 一定要执行

	if err := socks5Handshake(conn); err != nil {
		panic(err)
	}

	fmt.Println("SOCKS5 handshake OK (NO AUTH)")
}

```

### 服务端

```go
package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"net"
	"time"
)

func socks5HandshakeServer(conn net.Conn, br *bufio.Reader) error {
	VER, _ := br.ReadByte()
	if VER != byte(0x05) {
		_, _ = conn.Write([]byte{0x05, 0xFF})
		return fmt.Errorf("error VERSION")
	}
	//读取第二个字节
	METHODS_len, _ := br.ReadByte()
	if METHODS_len == 0 {
		_, _ = conn.Write([]byte{0x05, 0xFF})
		return fmt.Errorf("NMETHODS=0 invalid")
	}
	methods := make([]byte, int(METHODS_len))
	if _, err := io.ReadFull(br, methods); err != nil {
		return fmt.Errorf("read METHODS: %w", err)
	}
	const noAuth = 0x00
	ok := false
	for _, m := range methods {
		if m == noAuth {
			ok = true
			break
		}
	}

	if !ok {
		_, _ = conn.Write([]byte{0x05, 0xFF})
		return fmt.Errorf("no acceptable methods, client methods=%v", methods)
	}

	// Server choice: VER, METHOD
	if _, err := conn.Write([]byte{0x05, 0x00}); err != nil {
		return fmt.Errorf("write METHOD: %w", err)
	}

	return nil
}

func main() {
	addr := "127.0.0.1:1080"

	ln, err := net.Listen("tcp", addr)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("SOCKS5 server listening on %s\n", addr)

	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Println("accept:", err)
			continue
		}
		go func(c net.Conn) {
			defer c.Close()

			// 给协商阶段一个超时，避免卡死
			_ = c.SetDeadline(time.Now().Add(5 * time.Second))

			br := bufio.NewReader(c)
			if err := socks5HandshakeServer(c, br); err != nil {
				log.Println("handshake failed:", err)
				return
			}

			log.Printf("handshake OK from %s\n", c.RemoteAddr())
		}(conn)
	}
}

```

大概传输过程结束
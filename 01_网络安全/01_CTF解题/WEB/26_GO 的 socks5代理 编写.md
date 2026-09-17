# GO 的 socks5代理 编写

这里学习一下socks5代理的编写

网上有很多 学习一下

 [go 语言实战入门案例之实现Socks5 - 知乎](https://zhuanlan.zhihu.com/p/647728920) 

 [滑动验证页面](https://segmentfault.com/a/1190000038247560#item-6) 

 [socks5协议原理学习-腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1802233) 

首先我们要了解一下socks5的代理方式

socks5 是基于


- 认证
- 建立连接
- 转发数据

所形成的代理 我们只需要按照这三个写出代码即可

首先就是socks5的认证

## Socks5Atuth

这里首先要认证 那么我们首先要确定是不是socks5代理



<img src="https://i-blog.csdnimg.cn/blog_migrate/a67bf7f66c95553f4868dba1fc0db1e5.png" alt="" style="max-height:404px; box-sizing:content-box;" />


在socks5中 前两个字节 分别是 socks版本号 和 支持的认证方式



<img src="https://i-blog.csdnimg.cn/blog_migrate/226471189b82d092cbb071b350ffa85c.png" alt="" style="max-height:115px; box-sizing:content-box;" />


前面两个 1

所以这里我们开始读取前面的 版本号 ver socks5是固定值 0x05

这里开始编写一下监听

```cobol
package main
 
import (
	"bufio"
	"fmt"
	"log"
	"net"
)
 
const socks5Ver = 0x05
const cmdVer = 0x01
const aytpVerIpv4 = 0x01
const aytpVerUrl = 0x03   //这里是下面的常量 不需要理会即可 当作值即可
 
func main() {
	server, err := net.Listen("tcp", "127.0.0.1:1080")
	if err != nil {
		panic(err)
	}
	for {
		client, err := server.Accept()
		if err != nil {
			log.Printf("Accpet error :", err)
			continue
		}
		//确定ip端口 进行链接后 开始进程
		fmt.Println("开始监听", client, client.RemoteAddr())
	}
}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c1144253b78ba5d9c13c4ada15ba7573.png" alt="" style="max-height:74px; box-sizing:content-box;" />


然后开始处理数据

首先我们需要开启一个协程处理

```scss
func process(conn net.Conn) {
	defer conn.Close()
	readio := bufio.NewReader(conn)
	err := auth(readio, conn)
}
```

这里我们首先处理一下认证的信息

```cobol
	// +----+----------+----------+
	// |VER | NMETHODS | METHODS  |
	// +----+----------+----------+
	// | 1  |    1     | 1 to 255 |
	// +----+----------+----------+
	// VER: 协议版本，socks5为0x05
	// NMETHODS: 支持认证的方法数量
	// METHODS: 对应NMETHODS，NMETHODS的值为多少，METHODS就有多少个字节。RFC预定义了一些值的含义，内容如下:
	// X’00’ NO AUTHENTICATION REQUIRED
	// X’02’ USERNAME/PASSWORD
 
	// 版本和NMETHODS值都是单字节的，所以ReadByte读一个字节就好了
```

这里需要认证的东西就是这些 我们首先进行认证 ver

```go
func auth(readio *bufio.Reader, conn net.Conn) (err error) {
	ver, err := readio.ReadByte()
	fmt.Println(ver)
	return nil
}
```

这里是通过 readbyte 读取一个字节 我们输出一下就知道是多少了



<img src="https://i-blog.csdnimg.cn/blog_migrate/8507652e13e428cd3a4e2ffbf99b460f.png" alt="" style="max-height:211px; box-sizing:content-box;" />


发现我们通过浏览器进行代理 第一个byte是 5 对应 socks5

如果将代理设置为 socks4 那么这里就是对应4



<img src="https://i-blog.csdnimg.cn/blog_migrate/21bf32bb947caf6012825f29f3b9b013.png" alt="" style="max-height:163px; box-sizing:content-box;" />


然后这里进行匹配 如果不是就输出错误 这样 ver认证就结束了

### 认证的ver

```cobol
func auth(readio *bufio.Reader, conn net.Conn) (err error) {
	ver, err := readio.ReadByte()
	if err != nil {
		return fmt.Errorf("ver error:", err)
	}
	if ver != socks5Ver {
		return fmt.Errorf("ver num error: ", err)
	}
 
}
```

### 认证method

这里是socks5的认证，是否需要认证

```kotlin
	methodSize, err := readio.ReadByte()
	fmt.Println(methodSize)
	return
```

其实这里就是读取一个字节的大小

```cobol
func auth(readio *bufio.Reader, conn net.Conn) (err error) {
	ver, err := readio.ReadByte()
	if err != nil {
		return fmt.Errorf("ver error:", err)
	}
	if ver != socks5Ver {
		return fmt.Errorf("ver num error: ", err)
	}
	methodSize, err := readio.ReadByte() //确定切片大小 为 1字节
	method := make([]byte, methodSize)   //创建一个大小的切片
	_, err = io.ReadFull(readio, method) // 这里是判断是否读了
	if err != nil {
		return fmt.Errorf("read method error :", err)
	}
	_, err = conn.Write([]byte{socks5Ver, 0x00}) // 这里是握手的回复 说明我们不需要认证
	if err != nil {
		return fmt.Errorf("write error：", err)
	}
	return nil
}
```

这里注意

```cobol
_, err = conn.Write([]byte{socks5Ver, 0x00}) 
```

这里其实是监听后告诉 不需要进行 认证

当我们认证完后开始处理浏览器的报文

## Socks5Connect

```cobol
	// 读取浏览器发送的报文
	// +----+-----+-------+------+----------+----------+
	// |VER | CMD |  RSV  | ATYP | DST.ADDR | DST.PORT |
	// +----+-----+-------+------+----------+----------+
	// | 1  |  1  | X'00' |  1   | Variable |    2     |
	// +----+-----+-------+------+----------+----------+
	// VER 版本号，socks5的值为0x05
	// CMD 0x01表示CONNECT请求
	// RSV 保留字段，值为0x00
	// ATYP 目标地址类型，DST.ADDR的数据对应这个字段的类型。
	//   0x01表示IPv4地址，DST.ADDR为4个字节
	//   0x03表示域名，DST.ADDR是一个可变长度的域名
	// DST.ADDR 一个可变长度的值
	// DST.PORT 目标端口，固定2个字节
 
 
这里是浏览器发送的报文 我们依旧先进行鉴定
```

```cobol
func connnect(readio *bufio.Reader, conn net.Conn) (err error) {
	buf := make([]byte, 4)
	_, err = io.ReadFull(readio, buf) // 这里是读取字节数 读取前面4个作为一个切片
	if err != nil {
		return fmt.Errorf("read header error :", err)
	}
	var ver, cmd, atyp = buf[0], buf[1], buf[3] // 这里对应报文的字节认证的位置
	fmt.Println(ver, cmd, atyp)
	return
}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/04f2f71941527edacde91036cc515d8c.png" alt="" style="max-height:103px; box-sizing:content-box;" />


这里就很明显了 5 对应 socks5 1 对应 链接的请求 3 对应 url 是一个域名

```cobol
+----+--------+-------------------+--------------+---------------+
|VER |  CMD   |       ATYP        |   HOST SIZE  |      HOST     |
+----+--------+-------------------+--------------+---------------+
| 05 |  01    |       03          |      11      | www.exa.com   |
+----+--------+-------------------+--------------+---------------+
 
 
首先之前的都已经被读了
 
 
ver 
 
cmd
 
atyp
 
然后再读 就是 host size 这里是 后面 host 的地址长度
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c06ee1e6b1deacd7fe79fe48195bc2b7.png" alt="" style="max-height:205px; box-sizing:content-box;" />


这里开源发现 cn.bing.com的长度是11 因为url是可变的 所以后面的host也是可变的

我们首先读取字节长度 然后作为 值传递给切片 读取该长度的值 这样我们就开源获取到url地址

```cobol
	_, err = io.ReadFull(readio, buf[:2]) //再向后读取两个字节 是port
	if err != nil {
		return fmt.Errorf("port error:", err)
	}
	port := binary.BigEndian.Uint16(buf[:2])  //这里是大端序监听端口
	fmt.Println(port)
	fmt.Println(addr)
	return
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5700a051410cdddc4b08203984a8c16f.png" alt="" style="max-height:293px; box-sizing:content-box;" />


这里的原理是这样的

首先我们读取两个字节

```cobol
443 [1 187]
```

然后进行大端序排序 0 在高 80 在低

这个时候就是

```cobol
[1 187]
```

然后我们进uint16处理

```cobol
[1 187]
 
将高位字节（1）左移 8 位，使其占据 uint16 的高 8 位，得到结果 00000001 00000000
 
将低位字节（187）放在 uint16 的低 8 位，得到结果 00000001 10111011
 
 00000001 10111011
 
443
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b6c8d39a512c0e8778ac66720a4ca979.png" alt="" style="max-height:262px; box-sizing:content-box;" />


这样我们就获取到了端口

然后我们就可以进行拼接url

```perl
	dest := fmt.Sprintf("%v:%v", addr, port)  
	fmt.Println(dest)
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7cccfca5f2ebe4ba158317ab28b1ffde.png" alt="" style="max-height:183px; box-sizing:content-box;" />


然后我们开始建立tcp请求

```cobol
	dest, err := net.Dial("tcp", fmt.Sprintf("%v:%v", addr, port)) //建立tcp协议
	if err != nil {
		return fmt.Errorf("dial error:", err)
	}
	defer dest.Close()
	log.Println("访问:", addr, port)
```

## 完整代码



```cobol
package main
 
import (
	"bufio"
	"context"
	"encoding/binary"
	"fmt"
	"io"
	"log"
	"net"
)
 
const socks5Ver = 0x05
const cmdVer = 0x01
const aytpVerIpv4 = 0x01
const aytpVerUrl = 0x03
 
func main() {
	server, err := net.Listen("tcp", "127.0.0.1:1080")
	if err != nil {
		panic(err)
	}
	for {
		client, err := server.Accept()
		if err != nil {
			log.Printf("Accpet error :", err)
			continue
		}
		//确定ip端口 进行链接后 开始进程
		fmt.Println("开始监听")
		go process(client)
	}
}
func process(conn net.Conn) {
	defer conn.Close()
	readio := bufio.NewReader(conn)
	err := auth(readio, conn)
	if err != nil {
		fmt.Errorf("ip: %v,auth error :", conn.RemoteAddr().String(), err)
	}
	err = connnect(readio, conn)
}
 
func auth(readio *bufio.Reader, conn net.Conn) (err error) {
	ver, err := readio.ReadByte()
	if err != nil {
		return fmt.Errorf("ver error:", err)
	}
	if ver != socks5Ver {
		return fmt.Errorf("ver num error: ", err)
	}
	methodSize, err := readio.ReadByte() //确定切片大小 为 1字节
	method := make([]byte, methodSize)   //创建一个大小的切片
	_, err = io.ReadFull(readio, method) // 这里是判断是否读了
	if err != nil {
		return fmt.Errorf("read method error :", err)
	}
	_, err = conn.Write([]byte{socks5Ver, 0x00}) // 这里是握手的回复 说明我们不需要认证
	if err != nil {
		return fmt.Errorf("write error：", err)
	}
	return nil
}
 
func connnect(readio *bufio.Reader, conn net.Conn) (err error) {
	buf := make([]byte, 4)
	_, err = io.ReadFull(readio, buf) // 这里是读取字节数 读取前面4个作为一个切片
	if err != nil {
		return fmt.Errorf("read header error :", err)
	}
	var ver, cmd, atyp = buf[0], buf[1], buf[3] // 这里对应报文的字节认证的位置
	if ver != socks5Ver {
		return fmt.Errorf("connect ver error:", err)
	}
	if cmd != cmdVer {
		return fmt.Errorf("connect cmd	 error:", err)
	}
	addr := ""
	switch atyp {
	case aytpVerIpv4:
		_, err = io.ReadFull(readio, buf)
		if err != nil {
			return fmt.Errorf("ipv4 error:", err)
		}
 
		addr = fmt.Sprintf("%d.%d.%d.%d", buf[0], buf[1], buf[2], buf[3]) //读取ip地址
	case aytpVerUrl: //这里解析的是url
		hostSize, err := readio.ReadByte() //获取url的字节长度
		if err != nil {
			return fmt.Errorf("read hostSize failed:%w", err)
		}
		host := make([]byte, hostSize) //获取url字符的字节
		_, err = io.ReadFull(readio, host)
		if err != nil {
			return fmt.Errorf("read host failed:%w", err)
		}
		addr = string(host)
	default:
		return fmt.Errorf("not yet", atyp)
	}
 
	_, err = io.ReadFull(readio, buf[:2]) //再向后读取两个字节 是port
	if err != nil {
		return fmt.Errorf("port error:", err)
	}
	port := binary.BigEndian.Uint16(buf[:2])                       //这里是大端序监听端口
	dest, err := net.Dial("tcp", fmt.Sprintf("%v:%v", addr, port)) //建立tcp协议
	if err != nil {
		return fmt.Errorf("dial error:", err)
	}
	defer dest.Close()
	log.Println("访问:", addr, port)
	_, err = conn.Write([]byte{0x05, 0x00, 0x00, 0x01, 0, 0, 0, 0, 0, 0})
	if err != nil {
		return fmt.Errorf("写入错误:", err)
	}
	ctx, cancel := context.WithCancel(context.Background()) //启动一个可以取消的上下文功能
	defer cancel()
	go func() {
 
		_, _ = io.Copy(dest, readio) //这里是从我们的请求中读取出来 写入请求中
		cancel()
	}()
	go func() {
		_, _ = io.Copy(conn, dest) //这里从请求中写入返回报文中
		cancel()
	}()
	<-ctx.Done() // 这里是 只要管道输出内容了就停止 所以上面两个协程 只要有一个输出 就取消
	return nil
}
```
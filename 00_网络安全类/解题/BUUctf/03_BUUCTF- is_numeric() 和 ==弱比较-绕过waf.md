# BUUCTF- is_numeric() 和 ==弱比较-绕过waf

第六周



**目录**

[TOC]



## WEB

### [极客大挑战 2019]BuyFlag

查看源码



<img src="https://i-blog.csdnimg.cn/blog_migrate/7694863fcdbcb4c9efcc0eb83e19502f.png" alt="" style="max-height:123px; box-sizing:content-box;" />


发现了pay.php

查看一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/084f7c36a92196fd903a344bb4164b5f.png" alt="" style="max-height:289px; box-sizing:content-box;" />




给我们条件



<img src="https://i-blog.csdnimg.cn/blog_migrate/1b5364f770e723c40f388eeec204c5b3.png" alt="" style="max-height:244px; box-sizing:content-box;" />


发现 is_numeric() 和 ==弱比较

hackbar

<img src="https://i-blog.csdnimg.cn/blog_migrate/c2ca10f9b30f431beb726ca3ffde27d8.png" alt="" style="max-height:240px; box-sizing:content-box;" />


post

然后我们查看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/3f779f090445136eba6f4e90ab4f081f.png" alt="" style="max-height:153px; box-sizing:content-box;" />




发现不能购买

所以我们进行抓包





<img src="https://i-blog.csdnimg.cn/blog_migrate/9e2fbae4858a9a88fdf3a8694b59fc91.png" alt="" style="max-height:113px; box-sizing:content-box;" />


发现了cookie：user=0

这可能是进行判断 我们尝试把他改为1



<img src="https://i-blog.csdnimg.cn/blog_migrate/41de3dba045fe49d615293fb2901b17d.png" alt="" style="max-height:163px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/18f58f155ce453eac053e92c3cd43162.png" alt="" style="max-height:216px; box-sizing:content-box;" />


成功了 然后他返回数字的长度太长了 我们只有money的数字长度很长 所以进行改为科学计数法

1e9



<img src="https://i-blog.csdnimg.cn/blog_migrate/3a82aa213a1819f4b46c1091f1acb4e3.png" alt="" style="max-height:241px; box-sizing:content-box;" />


得到flag

### [RoarCTF 2019]Easy Calc



<img src="https://i-blog.csdnimg.cn/blog_migrate/2e540f39a1a0b83b3a9cb10018979608.png" alt="" style="max-height:260px; box-sizing:content-box;" />


查看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/5f2e89f1984c59c05837f5a864355720.png" alt="" style="max-height:396px; box-sizing:content-box;" />


发现里面有一个calc.php的文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/94f17709c580a1eec57b4627a3ffa9f0.png" alt="" style="max-height:487px; box-sizing:content-box;" />


进行代码审计

有一个黑名单

然后get num

我们在刚刚开始的时候 可以发现 我们只能输入数字 没办法输入字符

所以waf应该对num 进行过滤 我们要让waf 找不到num

#### 1.绕过waf

```dart
？num !=? num 中间有一个空格
 
这样waf就找不到num 但是? num在处理的时候会过滤空格
```

加上空格



<img src="https://i-blog.csdnimg.cn/blog_migrate/d03c89e2066c38ad9a6a64bfc6cbb6a5.png" alt="" style="max-height:537px; box-sizing:content-box;" />


没加



<img src="https://i-blog.csdnimg.cn/blog_migrate/4c52e7fc0f8bc28221d1c9df2aabbe75.png" alt="" style="max-height:253px; box-sizing:content-box;" />


#### 2.绕过黑名单查看文件

利用scandir()列出目录和文件,var_dump()用于输出

```erlang
scandir()函数返回指定目录中的文件和目录的数组。
scandir(/)相当于ls /
var_dump()相当于echo
```

因为过滤了/

所以我们构造 chr(47)

 [ASCII码对应表chr(9)、chr(10)、chr(13)、chr(34)、chr(39)、chr(46)_大虾.唐的博客-CSDN博客](https://blog.csdn.net/tangdasa/article/details/117654975) 

```cobol
? num=var_dump(scandir(chr(47)))
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ecc971b7b3c3d56c73cbed36626695d0.png" alt="" style="max-height:212px; box-sizing:content-box;" />


发现

f1agg

#### 3.绕过黑名单 读取文件

利用file_get_contents()读取并输出文件内容

```cobol
file_get_contents(/xxx.php)，读取/xxx.php的代码
```

所以我们构造

```cobol
? num=file_get_contents(chr(47).chr(102).chr(49).chr(97).chr(103).chr(103))
```

我们为什么f1agg也要转换 因为代码中还有一个黑名单 没有展现  是黑名单项目 所以过滤了这个文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/0895da2305ea5c995f7b1434e354a9df.png" alt="" style="max-height:191px; box-sizing:content-box;" />


## Crypto

## rsarsa

套代码

```cobol
import gmpy2
 
e = 65537
p = 9648423029010515676590551740010426534945737639235739800643989352039852507298491399561035009163427050370107570733633350911691280297777160200625281665378483
q = 11874843837980297032092405848653656852760910154543380907650040190704283358909208578251063047732443992230647903887510065547947313543299303261986053486569407
n = p * q
# 密文
C = 83208298995174604174773590298203639360540024871256126892889661345742403314929861939100492666605647316646576486526217457006376842280869728581726746401583705899941768214138742259689334840735633553053887641847651173776251820293087212885670180367406807406765923638973161375817392737747832762751690104423869019034
 
d = gmpy2.invert(e, (p - 1) * (q - 1))
# print(d)
# 求明文
M = pow(C, d, n)  # 快速求幂取模运算
print(M)
```

### Windows系统密码



<img src="https://i-blog.csdnimg.cn/blog_migrate/5bdb754c7161c87ba6265f753942e0ff.png" alt="" style="max-height:104px; box-sizing:content-box;" />


发现ctf关键词 然后有两个;;所以是两串 然后系统密码 想到md5

开始解密

 [MD5免费在线解密破解_MD5在线加密-SOMD5](https://www.somd5.com/) 



<img src="https://i-blog.csdnimg.cn/blog_migrate/bf814ff3b09d089d9d366a1809752d5d.png" alt="" style="max-height:300px; box-sizing:content-box;" />


第一个不行 尝试第二个



<img src="https://i-blog.csdnimg.cn/blog_migrate/ef71124730c5de6d77b105ae14c7e1f3.png" alt="" style="max-height:263px; box-sizing:content-box;" />


得到flag

## Misc

### 另外一个世界

下载文件放入010



<img src="https://i-blog.csdnimg.cn/blog_migrate/91163391064283131636ca99b1addf78.png" alt="" style="max-height:392px; box-sizing:content-box;" />


在文件最下面有 二进制 我们把他转为字符串

 [二进制与字符串互转](http://xiaoniutxt.com/binaryToString.html) 



<img src="https://i-blog.csdnimg.cn/blog_migrate/f191d66b253cfefd5c64dac7c1b15b6c.png" alt="" style="max-height:561px; box-sizing:content-box;" />


得到flag

### FLAG

下载文件 猜测 工具使用过去都没有 就猜测是不是LSB隐写



<img src="https://i-blog.csdnimg.cn/blog_migrate/4ee9bb9ef5589d777e498c2b83706a75.png" alt="" style="max-height:568px; box-sizing:content-box;" />


果然出现pk 是一个压缩包 我们save bin 保存为压缩包后缀



<img src="https://i-blog.csdnimg.cn/blog_migrate/456b74019330c34d38e567577f191ff6.png" alt="" style="max-height:381px; box-sizing:content-box;" />


我们打开压缩包文件 然后搜索ctf



<img src="https://i-blog.csdnimg.cn/blog_migrate/98a7130f5944b07e6f08f80cb9dc9b21.png" alt="" style="max-height:781px; box-sizing:content-box;" />


得到flag
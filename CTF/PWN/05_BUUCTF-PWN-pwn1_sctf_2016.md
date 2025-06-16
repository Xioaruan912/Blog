# BUUCTF-PWN-pwn1_sctf_2016

下载 放入ubuntu里查信息



<img src="https://i-blog.csdnimg.cn/blog_migrate/631798228e3c9b61b7f2b1c6d75169a5.png" alt="" style="max-height:374px; box-sizing:content-box;" />


现在这些保护我都没有遇到 以后慢慢做应该是会遇到的

然后进行发现是32 所以我们记住 如果栈溢出漏洞 我们需要4个字节填满基地址

放入ida32

查看字符串



<img src="https://i-blog.csdnimg.cn/blog_migrate/f636cf3acefe669c6dc717c332c3d9de.png" alt="" style="max-height:245px; box-sizing:content-box;" />


发现 cat flag 敏感字符串

然后我们就看引用



<img src="https://i-blog.csdnimg.cn/blog_migrate/e6608fd55c1d6856ece6553178cd6902.png" alt="" style="max-height:340px; box-sizing:content-box;" />


先记住地址

为

```cobol
0x8048F0D
```

然后开始进去 发现没有用 所以找到主函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/15551fd16e9e2881423906176c28adba.png" alt="" style="max-height:218px; box-sizing:content-box;" />


进入vuln函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/93dc28fe28a02ed74b99ac61d7e924a8.png" alt="" style="max-height:464px; box-sizing:content-box;" />


发现get  但是只能输入 32个 所以无法实现栈溢出

不管能不能用 先记住 s的地址

0x3c = 60字节 因为是32个 所以无法满足

原本看别人的博客 是说replace函数替换了 但是 我看不明白 很简单的办法

我们nc 这个 运行程序 输入 i you 看看发生了什么



<img src="https://i-blog.csdnimg.cn/blog_migrate/d2f62093d35aa456df62d2199dac5422.png" alt="" style="max-height:263px; box-sizing:content-box;" />




发现进行了替换 这样我们就可以执行栈溢出

因为you占3字节 我们只能输入 32个  一个i =三个字节 所以我们输入 20个I 就可以占 60 字节

就刚刚好满足了get的溢出 然后再输入4个垃圾字符 就可以 实现函数返回 再将 get flag返回地址填入即可

exp

```cobol
from pwn import *
p = remote('node4.buuoj.cn',29543)
payload=b'I'*20+b'b'*4+p64(0x8048F0D)
p.sendline(payload)
p.interactive()
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a6d19bd4bfe3d54ae6c11e049cf0c625.png" alt="" style="max-height:441px; box-sizing:content-box;" />


得到flag

这题我们发现 如果注意到replace函数要注意
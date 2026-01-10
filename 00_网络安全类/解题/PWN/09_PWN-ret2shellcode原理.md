# PWN-ret2shellcode原理

我们之前做过很简单的pwn题目

buuctf-rip这种 是在程序中存在shellcode直接返回地址改为这个shellcode的地址即可

但是如果程序里面没有呢

这种类型就是ret2shellcode



## 常见的shellcode

```cobol
shellcode = "\x31\xf6\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x56\x53\x54\x5f\x6a\x3b\x58\x31\xd2\x0f\x05"
```

这个shellcode只有23字节 是可以在能输入字节有限的地方进行使用

如果输入的字节可以存储特别大的话 我们可以使用pwntools的函数生成

```cobol
from pwn import *
context.arch='amd64'   #64位需要使用这个  32不用加
shellcode=asm(shellcraft.sh())
```

这是我理解的retshellcode的栈中的图

## 1.写入垃圾字符覆盖输入函数的变量和ebp



<img src="https://i-blog.csdnimg.cn/blog_migrate/4bb0283dbea8210c361224d0980a7eaa.png" alt="" style="max-height:782px; box-sizing:content-box;" />


## 2.写入shellcode的地址 把返回地址覆盖掉 实现返回到shellcode的地址中



<img src="https://i-blog.csdnimg.cn/blog_migrate/2a16a06cc3a6f8cac203bc727957c6fe.png" alt="" style="max-height:690px; box-sizing:content-box;" />


## 3.写入shellcode



<img src="https://i-blog.csdnimg.cn/blog_migrate/0e99b9337132f545432890f9a6278abe.png" alt="" style="max-height:700px; box-sizing:content-box;" />


这篇只是最简单的自我认识原理

例题

 [CTFHUB-PWN-ret2shellcode_双层小牛堡的博客-CSDN博客](https://blog.csdn.net/m0_64180167/article/details/130181350?spm=1001.2014.3001.5501)
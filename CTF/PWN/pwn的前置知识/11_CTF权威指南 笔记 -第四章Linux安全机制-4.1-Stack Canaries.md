# CTF权威指南 笔记 -第四章Linux安全机制-4.1-Stack Canaries

**目录**

[TOC]





## Stack Canaries

是对抗栈溢出攻击的技术  SSP安全机制

Canary 的值 栈上的一个随机数

在程序启动时 随机生成并且保存在比返回地址更低值

栈溢出是从低地址向高地址进行溢出

如果攻击者要攻击 就一定要覆盖到canary

然后在函数返回前 进行检查

就可以发现有没有栈溢出漏洞

## 简介

canaries可以分为3类

terminator random random XOR

具体实现是

```cobol
terminator canaries: 
栈溢出许多都是由于字符串操作不正当 (strcpy)所产生的
字符串的结尾一般都是NULL  \X00 结尾 换个角度就是容易被 00截断
这里就是把低位设置为 \x00 既可以防止被泄露 又可以防止被伪造
截断字符还包括 CR(0X0d) LF(0x0a) EOF(0xff)
```

```cobol
Random canaries:
防止canaries 被攻击者猜到 random canaries 通常在程序初始化的时候
生成随机数 并且保存在相对安全的位置 
当然 如果攻击者知道他的位置 还是有可能被读取
随机数通常由/dev/urandom 生成 有时候也是使用当前时间的哈希
 
```

```cobol
Random XOR canaries:
和random canaries 类似 但是多了一个XOR操作
这样无论是canaries被篡改 还是 XOR的控制数据被篡改
 
都会报错 加深了攻击难度
```

## 我们进行简单的例子

### 64

```cpp
#name canary.c
#include<stdio.h>
void main(){
    char buf[10];
    scanf("%s",buf);
}
```

```csharp
gcc -fno-stack-protector canary.c -o fno.out
 
警用了保护
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/47900d13e74771f0d4a91c9442537932.png" alt="" style="max-height:104px; box-sizing:content-box;" />


出现了报错 我们看看开启保护

```csharp
gcc -fstack-protector canary.c -o f.out
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c8fabbb2fa119ecafac1e5843c4df06f.png" alt="" style="max-height:94px; box-sizing:content-box;" />


发现检测到了栈溢出

我们看看开启保护的反汇编



<img src="https://i-blog.csdnimg.cn/blog_migrate/f0bcd80e0f390bb6261d96767c1aff9d.png" alt="" style="max-height:614px; box-sizing:content-box;" />




```cobol
在其中的
1175:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
我们可以发现调用了fs寄存器
 
 
在linux中 fs寄存器是用来存放线程局部存储 TLS的
 
主要就是为了避免多个线程同时访问一个全局变量 或者静态变量 从而冲突
 
尤其是多个变量如果都要同时修改这个变量
 
TSL为每一个使用该全局变量的线程都提供了一个全局变量的副本
就好像每一个线程都拥有了这个全局变量
 
从全局变量的角度看 就是克隆了许多备份
每一个备份都可以被一个线程独立使用
 
在glibc的实现里
TSL的结构体 tcbhead_t是下面的   而偏移量 0X28就是stack_guard
```

```cpp
typedef struct{
    void *tcb;
    dtv_t *dtv;
    void *self;
    int multiple_threads;
    int gscope_flag; 
    uintptr_t sysinfo;
    uintptr_t stack_guard;
    uintptr_t pointer_guard;
.....
}tcbhead_t;
 
 
 
uintptr_t stack_guard; 这里我们可以发现取出了canary
```

从TLS取出canary后 把他存入 rbp-0x8的位置保存



<img src="https://i-blog.csdnimg.cn/blog_migrate/f4aab5d3fdd19491d01aeef0fcbe507f.png" alt="" style="max-height:92px; box-sizing:content-box;" />


在函数返回前 又程序取出 并且和TLS中的canary进行异或比较 我这里是进行减法



<img src="https://i-blog.csdnimg.cn/blog_migrate/b1ff2f3878faf42422e989e97c8503f0.png" alt="" style="max-height:139px; box-sizing:content-box;" />




然后进行比较 发现如果不相同 就说明是栈溢出 然后就跳转到 _stack_chk_file的函数中

终止程序并且抛出错误 否则正常退出



<img src="https://i-blog.csdnimg.cn/blog_migrate/d02ead468b5449caa3e4f218f7dd76b1.png" alt="" style="max-height:206px; box-sizing:content-box;" />


这里是64位的程序

如果是32位呢

### 32



<img src="https://i-blog.csdnimg.cn/blog_migrate/9451db0d5595664c08a84e8720466301.png" alt="" style="max-height:855px; box-sizing:content-box;" />


我们发现是用gs寄存器 并且是在偏移 0x14的地方

### checksec

使用checksec脚本对canary的检测也是根据 _stack_chk_fail(_intel_security_cookie)

来进行判断
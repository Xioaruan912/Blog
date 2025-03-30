# 加密与解密 基础篇/win API/小端序大端序

**目录**

[TOC]







## 1.1加密和解密的概念

是侧重于windows的加密保护和解密技术

### 

首先我们先要了解

### 软件逆向工程

```haskell
可执行程序->反编译->源代码
 
这就是逆向工程
```

接着

### 逆向分析技术是什么

```undefined
静态调试 和动态调试 主要分为这俩类
```

#### 1.通过软件的执行 来分析程序

我们可以通过阅读程序的执行 或者说明 来了解程序是怎么执行的

#### 2.静态分析技术

通过IDA这种软件 可以实现静态分析

主要是通过人机交互实现 在用户输入的正确 错误来判断 程序

#### 3.动态分析技术

如果我们需要了解细节 静态调试 还是不够的 所以我们需要通过动态调试

可以说 静态调试 是我们的第一步

动态跟踪 才是分析软件的关键

主要工具有 OllyDbgWinDbg等

对软件进行一步一步的分析

这里就出现 为什么要进行动态分析的疑问

```csharp
程序执行 有的时候不是一个函数就执行结束
是多模块的执行结果 
前一个执行结果是后一个输入结果是常有的事情
只有跟踪得到前一个的结果 我们才可以看到后面的事情
并且 如果出现switch这种函数 会有许多分支 如果单单使用静态
是无法得出结果的
 
 
并且 在程序执行的时候 有一些 是开始的程序对后面程序的初始化
并不依靠重定向
 
 
如果一个程序 具有加密程序 防止非法阅读 这就是需要动态调试
 
加密程序既要阻止跟踪 又要对下一程序的明文进行解密 如果单单依靠静态
是无法得到的
```

#### 那我们如何有效的进行动态调试呢

```cobol
（1）对软件进行粗跟踪
就是进行大块大块的跟踪 遇到 CALL REP LOOP指令的时候
不进行跟踪 而是根据执行结果 判断程序的运行
 
因为程序开始执行 只有一个关键程序是我们需要的
如果每一个程序都细心分析 那么就浪费时间
 
这里就需要注意 如何设置断点
 
需要了解Win32 API函数
 
例如 拦截对话框 
我们就要对MessageBoxA函数进行拦截 对这个函数进行断点 
程序只要一调用这个函数 就会进行中断
 
对这个函数进行断点 我们就可以对这个函数的执行进行判断
 
（2）对关键部分进行细跟踪
 
这个是建立在对程序进行粗跟踪后 我们就可以得到我们需要分析的模块
这样 我们就可以对我们关心的程序进行具体 详细的跟踪
 
一般情况下 我们需要对关键部分进行多次的跟踪 才可以了解程序的执行
 
每一次都记录下来 关键的中间结果和指令地址 这样就会对分析有很大的帮助
```

## 1.2文本字符

我们最熟悉的就是ASCII码

### ASCII码

是通过 7位二进制 来表示 128个字符

百度百科上就能找到



<img src="https://i-blog.csdnimg.cn/blog_migrate/c8f598b6aaf24bb1e0aaeccad0d4ebaf.png" alt="" style="max-height:618px; box-sizing:content-box;" />


因为ASCII 只能表示 128字符 所以 有了通过ASCII的衍生和扩展

### Unicode

是一个ASCII的扩展 在windows中 通过2字节对其进行编码

所以 我们也称呼 Unicode为 宽字符集

```cobol
使用 0~65535的双字节无符号数 对每个字符进行编码
所有字符都是 16位的 其中所有的7位ASCII都被扩展为16位的Unicode
（这里高位扩充的 都为0）
例如 pediy的ASCII码是
 
70h 65h 64h 69h 79h
 
其Unicode码为
 
0070h 0065h 0064h 0069h 0079h
 
这里我们需要知道
 
Intel处理器 在内存中将一个字存入存储器 需要占用相继的2个字节
 
并且这个字符 在存放的时候 是按照Little-endian方式存入
 
低位字节存入低地址 高位字节存入高地址
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/467c569041bd00823ce87df6e0028cf4.png" alt="" style="max-height:778px; box-sizing:content-box;" />


### 字节存储顺序

这里就是上面的 Little-endian

```scss
这里就是 字节该以什么方式进行传输
Little-endian（小端序）
低字节存入低地址 高字节存入高地址
Big-endian(大端序)
高字节存入低地址 低字节存入高地址
```

12345678h 存入方式



<img src="https://i-blog.csdnimg.cn/blog_migrate/64978b4cc3b338fdc67d0a5eacd07b24.png" alt="" style="max-height:711px; box-sizing:content-box;" />




```cobol
一般来书 
x86系列CPU都是小端序 Little-endian存入方式
 
PowerPc通常是大端序 Big-endian存入方式
 
注意 大端序在网络协议中 经常使用 所以也叫做 网络字节序
```

## 1.3Windows操作系统

### win32API函数

对调试程序 是要和系统基层打交道 所以我们需要了解API函数的基础

对我来说 API 我只知道是一个接口

而API其实是 应用程序编程接口

```undefined
对于 windows开始占据主导位置
 
windows需要开发出为人提供的应用程序
 
但是windows编程人员 只有 API函数
 
这个函数提供应用程序需要的 对内存管理 窗口管理 图形设备接口等服务功能
 
这些功能 通过 函数库 组合在一起
 
叫做 Win API
 
Win API子系统 负责将API调用 转换为 windows操作系统的系统服务调用
 
可以认为 API就是windows框架的基石
 
他下面是 windows系统操作核心 上面是应用程序
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3d274d4fd18b6b66b8d6211403c9265f.png" alt="" style="max-height:566px; box-sizing:content-box;" />


这里就是开始枯燥的解读

```cobol
16位的windows API叫做 Win16 (Windows 1.0~3.1)
 
用于 32位的windows的API叫做 Win32 (windows 9x/NT/2000/XP/7/10)
 
64位的windows API的功能和名称 基本没有变化
还是使用的是32位的函数名 只不过是通过 64位代码实现
 
API调用在Win16到Win32的转变中 保持兼容 并且在功能和数量上进行了增加
 
Windows 1.0 只有 不到450个函数 现在已经有几千个了
```

```cobol
所有的32位windows 都支持 Win16 API（确保和旧程序的兼容）和Win32 API(确保新程序的运行)
 
在windows NT/2000/XP/7和windows 9x 的工作方式不同
 
在windows NT/2000/XP/7中 Win16函数是通过 一个转换层 来变为 Win32函数调用
然后再被系统处理
 
在windows 9x中却相反 win32函数调用 是通过 转换层 转换为win16函数调用 
然后再被系统处理
因为windows 9x 使用的是 16位代码模式
而windows NT/2000/XP/7 使用的是32位代码模式 
所以是不一样的
```

```cobol
windows 的运转核心是动态链接
windows提供了非常丰富的应用程序可利用的函数调用
 
这些函数调用 采用动态链接库 DLL 实现
 
在windows 9x中 DLL 位于 \WINDOWS\SYSTEM子目录中
 
windows NT/2000/XP/7中 DLL位于系统安装目录的 \SYSTEM和\SYSTEM32子目录中
 
 
在早期的系统 
windows主要依靠3个动态链接库 实现 分别代表了windows 3个子系统
 
Kernel(由Kernel32.dll)实现 ：操作系统核心功能服务 主要包括了
进程和线程的控制 内存管理 文件访问等
 
User(由USER32.DLL)实现：负责处理用户接口 包括键盘 鼠标的输入，窗口和菜单管理等
 
GDI(由GDI32.DLL)实现：图形设备接口，允许程序在屏幕和打印机上显示文本和图像
```

除了上面的模块 windows还提供了很多的DLL 来支持更多的功能

包括 对象安全性，注册表操作(ADVAPI32.DLL)

公共对话框(COMDLG32.DLL)

用户界面外壳(SHELL32.DLL)

网络(NEWAPI32.DLL)



Win API是基于 C语言的接口

但是 Win API 可以通过不同的语言进行编写的程序调用

```vbnet
Unicode影响了计算机的每个部分
 
对操作系统和编程语言的影响最大
 
NT系统是使用Unicode标准字符集进行开发
 
其核心完全使用 Unicode函数工作的 
如果希望调用一个windows函数 并且传递他一个ANSI字符串(是一个扩展的ASCII字符集)
 
系统会先把ANSI字符串转为Unicode字符串
然后进行传入操作系统
 
如果程序希望返回ANSI字符串
 
那么系统会把Unicode字符串变为 ANSI 然后返回
 
所以 在NT框架下 win32 API 能接受 Unicode和ANSI 两个编码方式
 
但是他的内核 只能接受Unicode字符集
 
虽然这些对于用户都是透明的 但是转换字符串需要消耗资源
```

```vbnet
在Win 32 API函数字符集中 "A"表示 ANSI "W"表示 Widechars（就是Unicode）
ANSI通常是单字节方式
Unicode通常是宽字节方式 这样可以处理双字节字符
 
如果程序在编写的时候 使用了MessageBox函数 
就会去调用这个函数 可是实际上 在USER32.DLL中 
并不会存在这个函数的入口 而是存在 MessageBoxA 和MessageBoxW 这两个函数入口
 
而这不是我们自己选择的 在我们调用了MessageBox函数
开发工具的编译模块 就会自动根据设定来决定使用A 还是 W 
 
 
直白的说 MassageBox是一个宏定义 在不同环境下变为A W类型
```

这里给出MassageBox函数的原型 这个函数主要是在用户模块中创建和显示信息框

```csharp
int MassageBox{
    HWND hwnd,       父窗口句柄
    LPCTSTR lpText,    消息框文本地址
    LPCTSTR lpCaption,    消息框标题地址
    uint uType    消息框样式
};
```

我们可以再看一看windows 2000中 MassageBoxA函数的内部结构

```scss
int MassageBoxA{
    MessageBoxExA{  调用这个函数 MessageBoxExA函数
    MBToWCSEx()  将MessageBoxA的消息框的主体文字转换为 Unicode字符串
    MBToWCSEx()  将MessageBoxA的消息框的标题栏的文字转为Unicode字符串
    MessageBoxExW() 调用这个函数 MessageBoxExW
    HeapFree() 释放内存
    }
};
```

MassageBoxExA其实是一个替换翻译层 用于分配内存

并且把 ANSI字符串变为Unicode字符串

所以系统调用Unicode的MassageBoxExW执行

所以如果应用程序是ANSI版本的 就需要更多的内存和CPU资源

如果是Unicode版本 就是符合NT框架 执行效率就会快很多





win32程序大量调用系统提供的API函数 在win32平台的OllyDbg

恰好有对API函数设置断点的强大功能 所以掌握常见API函数的 用法 会给程序的跟踪调试带来大的方便

### WOW64

WOW64是64位操作系统上的子系统 可以使大多数32位程序应用在不修改的情况下运行在64位上

64位的windows 除了带有64位操作系统应有的系统文件 还带着32位系统的系统文件



64位系统的系统文件存放在SYSTEM32的文件夹中 在\Windows\system32文件夹中

包含着原生的64位映像文件

为了兼容32位程序 还增加了\Windows\SysWOW64文件夹 里面就存放着32位系统文件

```cobol
64位程序 会加载System32目录下64位的kernel32.dll user32.dll ntdll.dll
当32位程序开始加载的时候 WOW64会建立32位的ntdll.dll所要求的环境
并且把CPU模式变为32位模式
并且开始执行32位的加载器
这样就会像在32位的机器上一样
 
 
WOW64会对32位的ntdll.dll调用重定向到ntdll.dll（64位） 
而不是发出原生的32位系统调用指令 WOW64接着重新转回64位模式
捕获系统调用有关的参数 发出64位的系统调用 如果原生系统返回了
WOW64在返回32位模式之前 将所有输出参数从64位转为32位
 
 
简单来说WOW64为32位程序提供虚拟的32位环境
然后如果需要API的时候 先到64位中找到对应的API 然后翻译成32位的
然后输入给程序
```

### Windows消息机制

Windows是一个消息驱动式系统 windows消息提供在应用程序和应用程序之间、应用程序和Windows之间

应用程序想要实现的功能 由消息触发 通过消息的响应和处理完成



```undefined
Windows系统有两个消息队列 ：
系统消息队列
应用程序消息队列
 
计算机的所有输入设备都是Windows监控
每当一个事情发生的时候 Windows先把输入 的消息放入系统消息队列
再把输入的消息复制到相对应的应用程序队列中 
应用程序中的消息循环在他的消息队列中检索每个信息 
然后发送给相应的窗口函数
 
 
每一个事情的发生 都要经历上面的过程
 
消息是非抢先性 就是 无论时期是否急缓 都是按照到达进行排队
（一些系统消息除外） 所以容易导致一个实时事情无法及时处理
```

因为Windows本身是由消息驱动的 所以在调试跟踪的时候 会得到一个相当底层的答案

下面是Windows常见的消息函数

```objectivec
SendMessage函数
这个函数作用是调用一个窗口函数 将一条消息发给那个窗口 
除非消息处理完毕 否则函数不会返回
 
LRESULT SendMessage{
    HWND hWnd，     目的窗口的句柄   HWND 是一个数据类型 代表一个窗口的句柄
    UINT Msg，        消息标识符        UINT无符号整数
    WPARAM wParam，    消息的WPARAM域
    LPARAM LParam        消息的LPARAM域
};
 
如果消息投递成功 就返回 TRUE
```

```cobol
WM_COMMAND消息
当用户从菜单或者按钮中选择一条指令或者一个控件的时候
把他发送给他的父窗口的
或者 一个快捷键被释放时发送
 
下面是C++对WINUSER.H的定义 WM_COMMAND所对应的16进制是 0111h
 
WM_COMMAND
    wNotifyCode = HIWORD(wParam);      通告代码
    wID = LOWORD(wParam);              菜单条目 空间或者快捷键标识符
    hwndCtl = （HWND）lParam;            控件句柄
 
返回值 如果应用程序处理了这个消息 那么返回值为0
```

```cobol
WM_DESTROY
当一个窗口被销毁的时候 发送这个消息 该消息的十六进制是 02h 没有参数
 
返回值 如果应用程序处理这个消息 那么返回值为 0 
 
 
作用就是销毁程序 释放内存
```

```cobol
WM_GETTEXT
应用程序发送一条WM_GETTEXT的消息 把一个对应窗口的文本复制到一个由呼叫程序提供的缓存区中 
这个的十六进制是 0Dh
 
WM_GETTEXT
    wParam = （wParam） cchTextMax；    需要复制的字符数
    lParam = （LPARAM） lpszText；       接受文本的缓存区地址
 
 
返回值 是被复制的字符数
```

```java
WM_QUIT
当系统调用 PostQuitMassage函数的时候 生成 WM_QUIT消息 十六进制是 012h
 
WM_QUIT
    nExitCode = （int）wParam;     退出代码
 
 
没有返回值
 
停止循环 退出程序
```

```cobol
WM_LBUTTONDOWN 
光标停在一个窗口的客户区 并且按下左键的时候 WM_LBUTTONDOWN发生消息
如果光标没有被捕获 就发给光标下的窗口 如果捕获了 就发送 已经捕获动作的窗口
 
WM_LBUTTONDOWN
fwKeys = wParam；                key旗帜
xPos = LOWORD(lParam)；          光标的水平位置  
yPos = HIWORD(lParam)；          光标的垂直位置
 
 
返回值 如果应用程序处理了这条消息 那么返回值为0
```

### 深入理解windows 消息机制_system.windows.interop.msg message 值解释_大林子先森的博客-CSDN博客

### 虚拟内存

默认情况下 32位 Windows操作系统的地址空间在4GB内 win32点平坦内存模式

可以让每一个进程都有自己的虚拟空间

对32位进程来说 这个地址空间是4GB

因为32位指针有00000000h~FFFFFFFFh 的任意值

这个时候 程序的代码和数据都存放在同一地址空间中 不需要区分代码段和数据段

```cobol
虚拟内存并不是真实的内存
他是通过映射的方式 把可用虚拟内存地址可以达到4GB大小
所以每一个程序可以得到2GB的虚拟地址 剩下的2GB留着操作系统自用
 
在 Windows NT 应用程序甚至可以得到3GB
 
Windows 是一个分时的多任务操作系统 
CPU时间 再被分成一个一个时间片后分配给不同的程序
在一个时间片中 和这个程序不相干的不会映射到线性地址中 
所以每个程序都有自己的4GB寻址空间 互不干扰 
在物理内存中 操作系统和系统DLL代码需要供给每一个程序调用
所以他们在任意时刻都被映射 
用户的 EXE程序 只会在执行的时间片中被映射 用户 DLL则是有选择的被映射
```

```cobol
下面是虚拟内存的实现方法和过程
 
1 应用程序执行启动 操作系统创建一个进程 给这个程序分配2GB的虚拟地址（只是地址 不是空间）
2 虚拟内存管理器把应用程序的代码映射到和应用程序虚拟地址中的某个位置 并且把当前需要的代码写入物理地址（虚拟地址和应用程序代码在屋里内存中的位置是没有关系的）
3 如果使用DLL DLL也会被映射到虚拟地址空间中，在需要的时候才会写入物理地址
4 其他项目（数据，堆栈等）的空间从物理内存进行分配 然后被映射到虚拟地址空间中
5 应用程序通过使用其虚拟地址空间的地址 开始执行 然后 虚拟内存管理器把每次内存访问映射到物理地址
 
总结
 
应用程序不会直接存入物理空间中
虚拟内存管理器通过虚拟地址的访问请求来控制所有物理空间的访问
每个程序都有自己独立的4GB空间 不同应用程序的地址空间是相互隔离的
DLL程序没有自己的空间 他们总是被映射到其他应用程序的地址空间中 作为一部分进行执行
（因为如果DLL不和应用程序处于同一空间 就无法调用DLL）
 
使用虚拟内存的好处是 简化了内存的管理 弥补了内存的不足 可以防止多任务下程序的冲突
 
```

在64位CPU最大的寻址空间是 16TB

实际应用中

64位的windows 7 支持8~192GB点聂村

64位windows 10 支持 128GB~2TB的内存
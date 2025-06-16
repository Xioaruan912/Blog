# 加密与解密 调试篇 动态调试技术 （三）-OllyDbg 插件 Run/Hit 符号调试 加载程序

**目录**

[TOC]





## 插件

OllyDbg允许插件

### 这里给出一个命令行插件

```cobol
? 表达式                 计算表达式的值 ? 35-14
D(DB,DW,DD) 表达式       查看内存的数据  D 401000   D esp+c
BP表达四 [条件式]        设置断点 bp GerDlgItemTextA
Hw 表达式                设置硬件写断点
```

## Run Trace

```cobol
Run Trace 是可以吧被调试程序执行过的指令保存下来  
这样就可以知道之前发生了什么事情
```

```cobol
这个功能 可以把地址 寄存器的内容 消息 记录到Run Trace缓冲区
我们在运行Run Trace的时候 要把 缓冲区开大一点
否则会出现缓冲区溢出（OllyDbg会自动丢弃旧数据）
 
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b7542b78294bcb17f4293d37c7e8e67f.png" alt="" style="max-height:361px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/36bc3a865ee1716cd5d4477af6ecaca9.png" alt="" style="max-height:178px; box-sizing:content-box;" />


或者



<img src="https://i-blog.csdnimg.cn/blog_migrate/66d8098af98464bd495e990458c713ac.png" alt="" style="max-height:419px; box-sizing:content-box;" />




可以打开Run Trace 窗口 然后右键 可以保存到文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/e8ce597b6620fe10dedbbc04444ef204.png" alt="" style="max-height:255px; box-sizing:content-box;" />


### 运行

当我们需要运行 Run Trace的生活





<img src="https://i-blog.csdnimg.cn/blog_migrate/ae84604bf0ddea952fe8bb3a7bf9531a.png" alt="" style="max-height:352px; box-sizing:content-box;" />


这里可以打开

```csharp
打开后  OllyDbg会记录执行过程的所有暂停 
使用 '+'或者'-'可以浏览程序的执行线路
这个生活 OllyDbg会使用实际的内存状态来解释寄存器和栈的变化
```



程序显示进入被调试程序领空的时候 我们可以通过Run Trace 查看函数调用次数



<img src="https://i-blog.csdnimg.cn/blog_migrate/b8635467352b25c54cbe88460e0c1aa5.png" alt="" style="max-height:447px; box-sizing:content-box;" />


程序运行起来



<img src="https://i-blog.csdnimg.cn/blog_migrate/d2784a0a43d3b0117eaf40b89287107b.png" alt="" style="max-height:436px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/9d54a28a2507cc6e5c391a513c7deb70.png" alt="" style="max-height:253px; box-sizing:content-box;" />




## Hit Trace

```cobol
Hit Trace 可以让调试者识别哪一部分的指令被执行 哪一部分没有
 
OllyDbg实现的方式特别简单
 
在选中的区域中 每一条指令设置 INT3断点 当中断发生
OllyDbg就去除INT3断点
```

```undefined
注意！！
在使用Hit Trace 的时候 不能在数据中设置断点 不然有可能会崩溃
```

```undefined
使用场景
 
 
在遇到跳转分支很多的代码  需要了解程序的执行路线的时候 可以使用Hit Trace
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/6057656c1d403b68f3ab89ef82b74c3c.png" alt="" style="max-height:377px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/3e0264ee218d32b2aa5b1488d91f90d4.png" alt="" style="max-height:522px; box-sizing:content-box;" />


会显示哪些被执行了

## 符号调试

```undefined
调试符号是 被调试程序的二进制信息与源程序之间的桥梁
 
是在编辑器把源文件编译成可执行程序的过程中 支持调试二摘录的调试信息
 
调试信息包括 
 
变量 类型 函数名 源代码行等
```

### 符号格式

```undefined
符号表  也叫做调试符
 
作用是把十六进制数转换为源文件代码行 函数名 变量名
 
符号表中还包括程序使用的类型信息 
 
调试器使用类型信息可以获取原始数据 并且把 原始数据显示未程序中所定义的结构和变量
 
```

#### 1.SYM格式

```cobol
SYM格式早期用于MS-DOS和16位的windows系统
现在只作为windows 9x的调试符使用 (windows 9x多为 16位内核)
 
```

#### 2.COFF格式

```cobol
COFF格式 是 UNIX供应商所遵循规范的一部分 
由 windows NT2.1首次引进 现在几乎被抛弃
```

#### 3.CodeView格式

```cobol
CV最早是在MS-DOS下作为 Microsoft C/C++ 7的一部分出现的 现在已经支持win32系统了
 
CodeView 是早期微软调试器的名称 其支持的调试符号为 C7格式
 
c7格式在执行模块是自我包含 符号信息和二进制代码混合（这样调试文件会非常的大）
```

#### 4.PDB格式

```cobol
PDB格式是现在最常用的格式 是微软自己定义的未公开格式
Viusal C++和Visual Basic都支持PDB格式 
 
和CV不同的是
 
PDB符号根据应用程序不同的连接方式保存在单独或者多个文件中
```

#### 5.DBG格式

```cobol
DBG是系统调试符 有了系统调试符 调试器才可以显示系统函数名
 
DBG文件和其他符号格式不同 因为链接器不创建DBG文件
 
 
DBG文件基本上是一个包含其他调试符的文件
(例如包含COFF或者C7等类型的调试符）
 
微软把操作系统调试符 分配在DBG文件中
 
这些文件中包含公共信息和全局信息 例如ntdll.dbg kernel32.dbg
```

#### 6.MAP文件

```undefined
MAP文件是全局符号 源文件和代码行号信息的唯一文本表示方式
 
MAP文件在 任何地方 任何时候都可以使用  不需要程序支持 通用性好
```

### 创建调试文件

如果我们要进行源代码级的首要条件是生成文件中包含的调试信息

```undefined
调试信息包括程序里每个变量类型和在可执行文件中的地址映射以及源代码的行号
 
调试器利用这些信息可以 让源代码和机器码相关联
 
```

这里我们以VisualC++W为例子

```cobol
1. build中选择set avtive configuration选项
在对话框中选择 win32 debug
 
2.在 project中 选择 setting选项 打开设置对话框
 
点击 C/C++选项 在 category中下拉列表框中选择 general
 
在debug info中 选择 program database
这里会产生存储程序信息的数据文件 其中包含类型信息和符号调试信息
 
 
3.点击 LINK 在 category 中选择debug
 
在debug info 选择'debug info' 'Microsoft format' 'separate type' 
也可以选择 Generate mapfile选项来生成 MAP文件
```

## 加载程序

OllyDbg有两个方式加载目标程序 进行调试

```cobol
1 通过CreateProcess 创建进程
 
2 通过DebugActiveProcess函数把调试器捆绑到一个在运行的程序上
 
 
就是一个是没有运行 然后通过创建进行加载
 
一个是程序运行了 然后使用通过捆绑调试器 来加载
```

### 1.CreateProcess

File->Open/或者按F3 打开目标文件 可以调用CreateProcess创建一个用于调试的进程

OllyDbg将受到目标进程发送的调试事件信息

但是对它的子进程的调试事件将不给予理财

### 2.将OllyDbg附加到一个正在运行的程序上

这也是调试的实用功能 叫做附加

```undefined
这个功能利用了 DebugActiveProcess 函数
 
这个函数可以将调试器捆绑到一个正在运行的进程上
 
如果执行成功 效果类似于使用CreateProcess函数
```

File->附加



<img src="https://i-blog.csdnimg.cn/blog_migrate/f7f047b5a897a18d0e5b1fbd11c17bee.png" alt="" style="max-height:483px; box-sizing:content-box;" />


如果我们是隐藏的进程 那就不能使用上面的方式

OllyDbg有一个 -p的启动参数

我们只需要得到我们想附加进程的pid 就可以附加

使用 PC Hunter 、GMER可以获得隐藏进程的pid

然后在cmd中

```css
OllyDbg.exe -p pid值
```

就可以附加到隐藏进程

```less
给出一个例子
我们运行 A.exe 他会调用B.exe 这个时候如果我们使用OllyDbg附加B.exe
会无响应
 
我们只需要 options-> just in time debugging
 
把OllyDbg设置为临时调试器
 
把B.exe的入口设置为 INT3 断点
 
并且我们记下源指令是什么
 
然后运行 A.exe 调用B.exe 运行到INT3 触发断点
 
OllyDbg会作为临时调试器来加载B.exe 
 
然后把INT3 恢复为之前的代码 就可以调试了
```
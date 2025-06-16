# 加密与解密 调试篇 动态调试技术 （五）-WinDbg

windbg主要厉害的地方是在他可以对内核调试

并且本身微软的产品 对windows调试适配度够高



注意 windbg给出的图形操作并不好用  主要是使用命令行来进行操作



我们省略安装

## 直接进入调试

```perl
file 
 
可以打开软件 可以附加
 
也可以分析dump文件
 
 
还可以进行内核和 远程调试
 
```

```cobol
内核调试分为5种
 
NET  USB 1394 COM和本地调试
 
 
前面四种是双机调试模式  
 
附加进程的非入侵模式调试 dump文件调试和本地内核调试都是属于非实时调试模式
不能直接控制被调试目标的中断和运行
 
一般是用来观察的
 
也可以用来修改内存数据
```

> ### 1.开始调试

```cobol
Ctrl+E 打开程序
 
F6可以附加调试
 
在windbg中反汇编代码默认停止在 ntdll.dll 的系统断点处
 
并不会停在程序入口处
```

```php
 
我们需要在命令窗口 输入
 
 
g@$exentery 转到程序入口
```

> ### 2.这里给出目标的执行命令

| 命令 | 快捷键 | 功能 |
|:---:|:---:|:---:|
| t | F8/F11 | 跟踪执行，进入call |
| p | F10 | 单步执行，不进入call |
| g | F5 | 运行程序 |
| pa 地址 |  | 单步到指定地址 并且不进入call |
| ta 地址 |  | 追踪到指定地址 并且进入call |
| pc [count] |  | 单步执行到下一个call调用 |
| tc [count] |  | 追踪到下一个call调用，遇到call进行跟进 |
| tb [count] |  | 追踪到下一条分支指令 遇到call进行跟进

【只适用于内核调试】 |
| pt |  | 单步执行到下一条call的返回 |
| tt |  | 追踪到下一条call的返回，并且遇到call进行跟进 |
| ph |  | 单步执行到下一条分支指令 |
| th |  | 追踪执行到下一条分支指令，遇到call进行跟踪 |
| wt |  | 自动追踪函数执行过程 |



```cobol
$ra代表当前函数的的返回地址
 
所以使用
“pa @$ra”
 
来走出当前函数
 
 
 
pc和tc都是执行到下一个call指令
 
count用于指定 遇到call的个数
 
默认是1
 
如果count为1 pc和tc这两个指令是等价的
```

> ### 3.这里给出的是断点指令

### 1.软件断点

#### bp断点

```less
bp[ID] [Options] [Address [Passes]] ["CommandString"]
```

```cobol
ID : 指定断点
 
options:
/l :一次性断点
/c :指定最大调用深度 大于这个深度断点不工作
/C :指定最小调用深度 小于这个深度断点不工作
 
 
Address:
地址或符号 例如 MessageBoxW
 
Passes:忽略中断的次数
 
CommandString : 指定一组命令 当断点中断的时候 自动执行这些命令
 
用双引号来包裹指令  分号来区分多指令
```

#### bu断点

```cobol
bu用于对某一个符号断点
 
bu kernel32!GetVersiono
 
 
和bp的区别：
 
 
bu是和符号关联 如果符号的地址改变了
断点会保持和源符号的关联
 
 
bp是和地址的关联 如果模块把地址的指令转移到其他地址
断点不会移动 依然是在原地址
 
并且 bu会保存在 windbg的工作空间 下次启动自动断点
```

#### bm断点

```cobol
bm断点是支持一次性创建多个bp或bu断点的指令
 
例如 对 msvcr80d模块的 print开头的函数都进行断点
 
bm msvcr80d!print*
```

#### 实例

TraceMe.exe



<img src="https://i-blog.csdnimg.cn/blog_migrate/007a8cf70b567743b9fd129ebad6e237.png" alt="" style="max-height:400px; box-sizing:content-box;" />


自动在命令行处进行加载

我们设置断点

```cobol
bp kernel32!GetVersion
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2e7e36e71a13ac99472932ba1f4d9c5b.png" alt="" style="max-height:61px; box-sizing:content-box;" />


然后使用g来运行程序

### 2.硬件断点

```less
硬件断点可以实现 监视I/O访问等功能 这些是软件断点无法实现的
```

#### ba

```less
ba[ID] Access Size [Options] [Address [Passes]] ["CommandString"]
```

```cobol
ID : 指定断点
 
Access : 指定断点触发断点的访问方式
 
e :在读取指令或执行指令的时候触发断点
r :在读取指令的时候触发断点
w :在写入数据的时候触发断点
i :在执行输入/输出访问(I/O)触发断点
 
Size :
访问的长度  
在X86可以为 1，2,4 代表 字节 字 双字
在X64多了一个 8   8字节访问
 
Address : 断点的地址 地址值按Size的值进行内存对齐
 
Passes和CommandString
和软件断点用法一样
```

### 3.条件断点

软件断点和硬件断点都支持 条件断点

断点触发后 WinDbg会执行一些自定义的判断 并且执行命令

```csharp
bp|bu|bm|ba _Adddress "j (Condition) 'OptionalCommands';'gc'"
 
bp|bu|bm|ba _Adddress ".if (Condition) {OptionalCommands} .else {gc}"
 
```

```cobol
例子
 
bp kernel32!GetVersion ".if(@eax=0x12ffc4){}.else{gc}"
 
当 GetVersion调用的时候 检测 eax
如果值为 0x12ffc4就中断
否则 gc指令继续执行
 
但是当值为 0x12ffc4的时候 不一定能断下
因为在内核态   MASM会对 eax进行符号扩展
 
 
0x12ffc4会变为 0xFFFFFFFFc012ffc4
 
 
这个时候就可以使用 & 把eax的高位清零
 
bp kernel32!GetVersion ".if(@eax& 0x0`ffffffff)=0xc012ffc4{}.else{gc}"
```

```cobol
例子2
在不中断的情况下 打印 CreateFileA的函数调用
 
bp kernel32!CreateFileA ".echo;.printf\"CreateFileA(%ma,%p,%p),ret=\",poi(esp+4),dwo(esp+8),dwo(esp+c);gu;.printf\"%N\",eaxl.echo;g"
```

### 4.管理断点

#### bl

```cobol
bl 列出断点
 
bc bd be 来删除 禁止 启动断点
 
 
 
bd 1-3,4   禁止 1234断点
 
bc * 删除所有断点
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3b6d1c1c8b07b5c240a267d1fc57ee66.png" alt="" style="max-height:90px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/7ca4cd410b9ab6dba8eedd6e2edfa0f6.png" alt="" style="max-height:121px; box-sizing:content-box;" />


> ## 4.栈窗口

栈是观测函数调用的重要调试手段

因为 call指令会把返回地址记录在栈中



我们就可以通过遍历栈帧来追溯函数调用过程

这里我遇到一个问题 就是怎么一直在 系统领空

```php
这里是我忘记了windbg会自动在系统断点停止
 
 
g @$exentry 
 
就可以调到程序领空
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/98705901dc37d01ff5394b2abc6d25b7.png" alt="" style="max-height:258px; box-sizing:content-box;" />


这里我们开始看栈中的函数

### k命令



<img src="https://i-blog.csdnimg.cn/blog_migrate/522c391590bd53d7db27ebf6dbd46a7e.png" alt="" style="max-height:122px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/231cad05809150ee94a2d03f91f53050.png" alt="" style="max-height:140px; box-sizing:content-box;" />




```vbscript
栈帧的基地址是通过EBP来访问的 所以是childebp
 
 
下面是返回地址 就是调用本函数的那条call指令的下一条地址 就是作为返回地址
```

### kb命令

```cobol
只用于显示放在栈上的前3个参数
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/531b0671dc830520ac6f5170c3e445c3.png" alt="" style="max-height:129px; box-sizing:content-box;" />


### 其他的k命令

```undefined
kp 可以吧参数和参数值以函数的原型返回出来 包括
 
参数类型 名字 取值
 
kv命令可以在kb的基础上增加 栈指针省略信息和调用约定
 
 
kd命令用于列出栈的数据
```

## 内存命令

### 1.查看内存

> #### d命令

```cobol
d [类型][地址范围]
 
dd 4001000 L4
 
L4可以指定显示前4个
```

字节

```cobol
d命令有很多衍生
 
dw 双字word  
 
dd 四个字节
 
dq 八个字节
 
df 四个字节单精度浮点数格式
 
dD 八个字节双精度浮点数格式
 
dp 指针大小格式 在32位中为4字节 64中为 8字节
 
```

ASCII

```cobol
da 表示字符串
 
db 表示字节和字符串
 
dc dword和ASCII
 
du 表示unicode字符串
 
dW 表示双字节word 和 ASCII
 
ds 用于显示 ANSI_STRING
 
dS 用于显示 UNICODE_STRING
```

二进制

```undefined
dyb 表示二进制和字节
 
dyd 表示二进制和dword
```

结构

```less
dt [模块名!]类型名 用于显示数据类型和数据结构
 
例如 
 
dt ntdll!* 可以列出NTDLL模块的所有结构
 
dt _PEB 可以显示 PEB的结构
 
```

地址

```undefined
dds dps dqs 用于显示 地址和相关符号
```

拿 0040115Eh来举例子



<img src="https://i-blog.csdnimg.cn/blog_migrate/9baa3323edaec17dfc96f5cec65f4d27.png" alt="" style="max-height:148px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/2eab9c69279cba3e5f08455657b57831.png" alt="" style="max-height:135px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/f97029d1b2b32caa6c9d452250095c11.png" alt="" style="max-height:123px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/429a6571f7b5d17153a681d6776ad51c.png" alt="" style="max-height:137px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/050f50d0e9ef30bbca0d28466c78c57e.png" alt="" style="max-height:85px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/0daa4a3106d0b062d1d41d1fb3c4e644.png" alt="" style="max-height:119px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/dccfb856b46caaf089eebb7fc689540e.png" alt="" style="max-height:51px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/f68ea0a16cb09f16e3c35b60fd642092.png" alt="" style="max-height:144px; box-sizing:content-box;" />


### 2.搜索指令

> s指令

```sql
s - [type] range pattern
 
```

```cobol
type :
 
搜索的数据类型 
 
b 比特
w word
d dword
a ascii
u unicode
 
默认为 b
 
range : 地址范围 可以用两个方式
1.起始地址+终止地址
2.起始地址+L（长度）
 
如果超过 256MB 使用 L?length
 
 
pattern:指定要搜索的内容 可以使用空格分隔要搜索的值
```

例如

```cobol
s -u 400000 430000 "pediy"
 
在 400000 到 430000中 搜索 unicode字符串 pediy
 
s -a 0x000000000 L?0x7fffffff mytest
 
表示在 2GB的 user mode 内存空间中搜索 ASCII字符串mytest
```

### 3.修改内存

> e命令

写入字符串

```cobol
e{a|u|za|zu} address "String"
```

```cobol
za zu 是表示以 0 结尾的 ASCII 和 UNICODE 字符串
 
a u 表示不以0 结尾
 
 
例如
 
eaz 298438 "pediy"
就是在 298438 这个地址 写入 pediy这个ASCII 并且以0结尾
 
```

写入数值

```cobol
e{a|b|d|D|f|q|u|w} address [values]
 
 
a ascii
 
b bite
 
d dword
 
D DOUBLE
 
f float
 
q 八个字节
 
u unicode
 
w word
 
 
eb 298438 70 65 64 69 79
 
会在 298438 写入 pediy 的数值形式
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/594ad1d50ffa317920cfdfdcf4bbe083.png" alt="" style="max-height:167px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/5a15926e9209bff18e218668fc39d7cf.png" alt="" style="max-height:174px; box-sizing:content-box;" />




### 4.观察内存属性

```less
!address [Address]
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/84c5912b2fe4f7a7f1b8e34a32fdf2c7.png" alt="" style="max-height:440px; box-sizing:content-box;" />


> ## 5.脚本

windbg的脚本是一个语言

例如

我们想输出 helloword

```php
.echo helloword
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ecefacd22b5d1f172e01b03349a4bdc8.png" alt="" style="max-height:57px; box-sizing:content-box;" />




### 1.伪寄存器

windbg给了很多伪寄存器

在表达式中使用伪寄存器 必须要使用转义符 @

```bash
$exentry 当前进程的入口地址 运行 g @$exentry 可以到达程序入扣
 
$ip 当前的指针寄存器
 
$ra 当前函数的返回地址
 
$retreg  当前函数返回地址存在这个寄存器中
 
$csp 当前的栈指针 esp/rsp
 
$tpid 当前进程的标识
 
$tid 当前线程的标识
 
$ea 最后一天被执行指令的有效地址
 
$p 最后一条 d 命令打印的值
 
$bpNumber 对应断点的地址
 
$t0~$t19 自定义伪寄存器
```

### 2.别名

类似 define宏

一个是固定别名

一个是自定义别名

#### 固定别名

```cobol
windbg提供了10个固定别名
 
$u0~$u9
 
在定义固定别名的时候需要使用 r 命令
 
r $.u0="helloword"
.echo $u0
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c79d12bf3b9ae4d1879d0ebbaae85207.png" alt="" style="max-height:92px; box-sizing:content-box;" />


#### 自定义别名

```cobol
自定义别名的命令有3个
 
as ad al
 
 
as为内存中的字符串定义别名
 
ad 删除别名     ad Name   ad *
 
 
al 列出别名
```

```cobol
as /选项 别名名称 别名实体
 
选项的选择
 
/ma ASCII
 
/mu Unicode
 
/msa ANSI_STRING
 
/msu UNICODE_STRING
 
/e 指定的环境变量
 
/f 指定文件的内容
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/36320ffa70461a9d7b9c690e0d8f6abe.png" alt="" style="max-height:76px; box-sizing:content-box;" />


```cobol
as /ma bookname 0040115e
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/547cbdeae374539d010589cba72900b3.png" alt="" style="max-height:102px; box-sizing:content-box;" />


### 3.表达式

windbg识别两个表达式  MASM / c++

默认使用MASM

```bash
.expr 可以显示表达式语法
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4b319677b1975f37476ba7772d36d3c7.png" alt="" style="max-height:66px; box-sizing:content-box;" />


```less
使用
 
@@c++()可以指定c++表达式
 
@@masm()可以指定 masm表达式
```

#### MASM表达式

```cobol
除了 +-*/这些算术运算符
 
还支持转型运算符
 
hi/low 可以得到32位数的高16 或 低16
 
by/wo 可以得到指定地址的地位1字节/1字的值
 
dwo/pwo 可以得到指定地址的DWORD/QWORD
 
poi 可以得到指定地址的指针长度
```

为了支持复杂的调试命令 Windbg还定义了特殊的运算符

```cobol
$fnsucc(FnAddress,RetVal,Flag)
 
将RetVal作为 FnAddress处的函数的返回值 如果返回值是一个成功码
 
$fnsucc返回 true 否则false
 
 
 
 
$iment(Address)
返回加载模块列表中的映像入口地址
 
 
$scmp("string1","string2")：比较  -1 0 1
$sicmp("string1","string2"):比较  -1 0 1
 
它们的差别在于比较时是否忽略大小写。
 
 
$spat("string","pattern")
根据 string匹配 pattern 计算得到 true or false
 
$vvalid(Address,Length)判断Address起Length的内存是否有效
有效返回1 否则 0 
```

#### C++表达式

```cobol
支持C++的操作符 
包括 . ->
 
C++会把数值作为十进制 所以 要加上 0x
 
```

#### 注释

支持两个注释方式  * 和 $$

```crystal
* 后所有都会被当做注释
 
$$ 到 ; 结束为注释
```

> ### 6.例子

我们的要求是 打开CreateFileA函数 并且判断是不是 c:1212.txt

如果是就断点 如果不是就继续

命令行是

```swift
bp kernel32!CreateFileA "$<D:\\test.txt"
```

在D：\\test.txt的内容是

```cobol
as /ma ${/v:fname} poi(esp+4)
.if ($sicmp("${fname}","c:\1212.txt")=0) {.echo ${fname}} .else{gc}
```

我们打入断点指令后

g运行程序



<img src="https://i-blog.csdnimg.cn/blog_migrate/4752d3a897af4d84c7e6b23c23df5054.png" alt="" style="max-height:98px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/52f84fb6161c26d3cedc7d041c2cc323.png" alt="" style="max-height:205px; box-sizing:content-box;" />


发现在原本读取 1212.txt的地方中断了



到此 windbg的基础就结束了
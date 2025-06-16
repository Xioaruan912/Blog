# 加密与解密 调试篇 动态调试技术 （一）-OllyDbg的使用 TraceMe的逆向

**目录**

[TOC]



## OllyDbg调试器的使用

### CPU窗口



<img src="https://i-blog.csdnimg.cn/blog_migrate/8593d477b60e21dec2eea5e4df7c0e70.png" alt="" style="max-height:676px; box-sizing:content-box;" />


我们进行载入的时候 主要返回的是CPU窗口 是最主要的窗口 对应面板的C



<img src="https://i-blog.csdnimg.cn/blog_migrate/ea32e39b2924269af69799932451590b.png" alt="" style="max-height:676px; box-sizing:content-box;" />


#### 反汇编窗口

我们先查看CPU窗口 打开后是有 5个面板



<img src="https://i-blog.csdnimg.cn/blog_migrate/07f5330b98b920b8132e16ab62216595.png" alt="" style="max-height:1048px; box-sizing:content-box;" />


主要查看反汇编窗口

<img src="https://i-blog.csdnimg.cn/blog_migrate/666930d85bfc598980f2bf84f033d404.png" alt="" style="max-height:414px; box-sizing:content-box;" />


我们可以对这些列进行操作

```undefined
操作都是进行双击
 
地址： 显示被双击行地址的相对地址 再次双击返回标准地址模式
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/eb638823f3ba4e15edbc36da71e2b98b.png" alt="" style="max-height:154px; box-sizing:content-box;" />


这里就能出现相对于双击地址的其他地址的偏移量

```cobol
十六进制机器码：设置或取消无条件断点 对应快捷键是F12
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7369280b172ef687b68b97dbce3e3553.png" alt="" style="max-height:113px; box-sizing:content-box;" />




```undefined
反汇编：调用汇编器 可直接修改汇编代码 快捷键是空格
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/796f354fa7b8c9e5192224164dfa78de.png" alt="" style="max-height:351px; box-sizing:content-box;" />




```undefined
注释：添加注释 快捷键是；
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/21ea472a72179d5e9bff8f2c2de7ca87.png" alt="" style="max-height:182px; box-sizing:content-box;" />




```cobol
从键盘选择多行 按住shift +上下键 可以实现 也可以右键快捷菜单命令实现
ctrl + 上下 可以滚动汇编（对于数据和代码混合 这个方式很有用）
```

#### 信息面板

在进行动态跟踪的时候 信息面板窗口 显示指令和寄存器的值 API函数的调用提示和跳转信息

#### 数据面板

数据面板是以十六进制和字符方式显示文件在内存中的数据

```cobol
 要显示制定的内存地址数据
右键快捷键的 go to expression 或者 ctrl+G 实现
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/669c92f5f181f87bccd83ada1e58fb61.png" alt="" style="max-height:156px; box-sizing:content-box;" />


#### 寄存器面板

寄存器面板显示CPU各个寄存器的值 支持浮点、MMX、3DNow！寄存器

可以右键或者窗口标题切换显示寄存器的方式

#### 栈面板

显示栈的内容 就是 ESP指向地址的内容 将数据存入栈叫做入栈

从栈取出数据叫做出栈

栈窗口很重要 各个API函数和子程序都是利用它传递参数

## OllyDbg的配置



<img src="https://i-blog.csdnimg.cn/blog_migrate/f8bc394c5991b76fb73b9a2c8ba21c39.png" alt="" style="max-height:1080px; box-sizing:content-box;" />


在选项界面 有两个设置 一个是界面设置 一个是调试设置

### 界面设置



<img src="https://i-blog.csdnimg.cn/blog_migrate/09a54051eff25c08da2e0503f8022b31.png" alt="" style="max-height:361px; box-sizing:content-box;" />




这里存放着两个路径

```undefined
UDD 是 OllyDbg的工程文件 保存着当前调试的一些状态 
断点 注释等
 
插件是用于扩充功能 当我们把插件复制到 plugin目录中 
相对应的选项就会在 插件中显示出来
```

### 调试设置



<img src="https://i-blog.csdnimg.cn/blog_migrate/b5e3692da9284e4bc444462cbd4e3f6b.png" alt="" style="max-height:361px; box-sizing:content-box;" />


### 加载符号文件

使用lib文件（符号库） 可以让OllyDbg 以函数名字显示DLL 中的函数

在调试中 选择导入库



<img src="https://i-blog.csdnimg.cn/blog_migrate/ae4afc485967f8616fcc96fd7579f7d5.png" alt="" style="max-height:265px; box-sizing:content-box;" />


## 基本操作

对于windows程序 只要API被调用 我们几乎就可以得到消息

```undefined
所以对于一个windows程序 
 
选择API函数作为切入点就很重要 只要有经验 就可以很容易
```

这里看雪给出了一个测试软件



<img src="https://i-blog.csdnimg.cn/blog_migrate/2bfdac9c6a070a74c0ed5fd0354666e6.png" alt="" style="max-height:205px; box-sizing:content-box;" />


通过看雪我们可以了解程序的运行



<img src="https://i-blog.csdnimg.cn/blog_migrate/24ca432616dfab0c2708471884f00ad5.png" alt="" style="max-height:498px; box-sizing:content-box;" />


这个就是这个程序的流程

我们进行OllyDbg调试

### 调试



<img src="https://i-blog.csdnimg.cn/blog_migrate/80b813ec93735ce82ce2d86320fa164d.png" alt="" style="max-height:361px; box-sizing:content-box;" />


因为我们设置了 winmain处

所以打开程序后会得到程序执行的第一条指令处



<img src="https://i-blog.csdnimg.cn/blog_migrate/2f629aa1bf8edce1f94640bb0766dfd6.png" alt="" style="max-height:127px; box-sizing:content-box;" />


这里 004013A0就是这个程序的入口（EntryPoint）

通过快捷键F7可以执行一条指令

```undefined
EIP指向当前要执行的指令 然后我们进行执行 EIP就会指向下一条指令
```

我们可以通过对地址右键 然后选择此处为新的EIP来让程序从此处开始



<img src="https://i-blog.csdnimg.cn/blog_migrate/ee9f9dd4ed21181b2ac2992a07fe3e21.png" alt="" style="max-height:1080px; box-sizing:content-box;" />


#### 单步跟踪

```cobol
F7     单步步进 遇到call指令进行跟进
F8     单步步过 遇到cal指令路过 不跟进
Ctrl+F9    直到ret指令中断
ATL+F9     如果进入系统领空 此命令可以瞬间返回到程序领空
F9        运行程序
F2        设置断点
```

其中 F8在调试的时候很频繁



<img src="https://i-blog.csdnimg.cn/blog_migrate/7783e036f4226b8fa7fb7f2e6e14bd46.png" alt="" style="max-height:73px; box-sizing:content-box;" />


如果F8 遇到就路过这个call

```cobol
F7 F8的区别就是
遇到call loop 是否跳过或者跟进
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f854d4c118d97e3665c28166445f35bf.png" alt="" style="max-height:92px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/ccac34efd128acfbc2bceea3ca4ccff8.png" alt="" style="max-height:304px; box-sizing:content-box;" />


遇到call 就会去call 里面

```cobol
call 00401DA0就是调用 这个地址的子程序
一旦子程序运行完毕 就会返回call的下一条指令 
这里就是 004013FFh 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9d7b1d26a19af99aebbb24923428d347.png" alt="" style="max-height:1048px; box-sizing:content-box;" />


看栈窗口就能发现 调用call 下一条指令的地址就被压入栈内

```undefined
按-号可以返回上一步地址
双击EIP可以返回当前地址
```

```cobol
如果需要重复 F8 F7 我们可以使用CTRL+F8/F7
 
这个快捷键会直到用户 按esc 或者 F12 或者遇到其他断点 停止
```

```cobol
如果我们已经进入了call 指令 想返回原本调用call的地方 我们可以使用ctrl+F9
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b30faea1b1a669dc3263a442966d8e80.png" alt="" style="max-height:85px; box-sizing:content-box;" />


这里进入了系统领空



<img src="https://i-blog.csdnimg.cn/blog_migrate/0c7a61bf8521b3700bf432744fc54345.png" alt="" style="max-height:244px; box-sizing:content-box;" />


按Ctrl+F9返回程序领空 因为这里进入了 DLL地址



<img src="https://i-blog.csdnimg.cn/blog_migrate/a79f69869bd7edff304688aec1368357.png" alt="" style="max-height:129px; box-sizing:content-box;" />




```undefined
领空 就是在某一时刻CPU的 cs:EIP执行某段代码的所有者
```

#### 如果我们想直接运行



<img src="https://i-blog.csdnimg.cn/blog_migrate/5b2871bb05dd84b5870170c623f9a3eb.png" alt="" style="max-height:89px; box-sizing:content-box;" />


#### 如果想重新运行



<img src="https://i-blog.csdnimg.cn/blog_migrate/a403aed062638e237172127d0d9acd18.png" alt="" style="max-height:176px; box-sizing:content-box;" />


或者 Ctrl+F12

如果程序进入死循环 F12暂停程序

### 设置断点

断点是调试器非常重要的部分

可以让程序中断在指定的地方

F12作为快捷键 就可以设置断点



<img src="https://i-blog.csdnimg.cn/blog_migrate/54c69a01f3277a7cfa7280c1a105123b.png" alt="" style="max-height:89px; box-sizing:content-box;" />


设置断点后 通过ALT+B 或者

<img src="https://i-blog.csdnimg.cn/blog_migrate/fcc78c290764f6d7a1caacc63592679a.png" alt="" style="max-height:67px; box-sizing:content-box;" />


可以访问断点窗口

我们可以在窗口中对断点进行操作



## 下面对这个程序进行完整的调试分析

先按F9 让程序运行起来

#### 方法1 猜函数

然后我们可以猜测函数

因为我们是输入文本框里面 所以肯定会调用 读取文本框的API函数

```cobol
16位：GetDlgItemText  GetWindowText
32位（ANSI）：GetDlgItemTextA     GetWindowTextA
32位（Unicode）：GetDlgItemTextW    GetWindowTextW
```

我们通过ctrl+G 查找



<img src="https://i-blog.csdnimg.cn/blog_migrate/6d8dace800aca186d66e8e42bec98769.png" alt="" style="max-height:366px; box-sizing:content-box;" />


跳转到这个程序的入口了  然后对这个进行设置断点

#### 方法2 命令窗口查看

我们通过CTRL+N能调出所有的系统动态链接库的函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/26108a7e62a44b35ac16f0b69489b250.png" alt="" style="max-height:371px; box-sizing:content-box;" />


然后我们可以通过命令 直接对这个函数进行断点



<img src="https://i-blog.csdnimg.cn/blog_migrate/80ab96ddd024c08fe96e293dde8e8c11.png" alt="" style="max-height:46px; box-sizing:content-box;" />


bp 就是断点



<img src="https://i-blog.csdnimg.cn/blog_migrate/803d87ed1fd81b24f39de6fc98895aa5.png" alt="" style="max-height:424px; box-sizing:content-box;" />


然后我们开始执行程序F9进行执行



<img src="https://i-blog.csdnimg.cn/blog_migrate/bd3701226a7d76ef032ab961cbaa539e.png" alt="" style="max-height:205px; box-sizing:content-box;" />


会执行到让我们输入 因为我们断点在 文本框读取字符 所以我们输入了 然后check了 他就会中断



<img src="https://i-blog.csdnimg.cn/blog_migrate/309bc1fc0b55ed2178534e6fdf494032.png" alt="" style="max-height:205px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/dbc0bf26daa27555f234f327f026146c.png" alt="" style="max-height:204px; box-sizing:content-box;" />


发生中断 地址在 004011B6



这里就是调用GetDlgItemTextA的函数参数

我们先解释一下这个函数的作用

```objectivec
UINT GetDlgItemTextA{
    HWND hDlg,                对话框
    int nIDDlgItem,           控件标识（id）
    LPTSRE lpString,          文本缓冲区指针
    int nMaxCount             字符缓冲区的长度
};
 
返回值 是 如果成功了就返回文本长度 如果失败就返回0
```

然后我们进继续 F8进入程序领空



<img src="https://i-blog.csdnimg.cn/blog_migrate/3a229de32b4ad161aa35e0bd7e4e9e94.png" alt="" style="max-height:325px; box-sizing:content-box;" />


注意这里调用了GetWindowTextA函数

#### 这里还有另一个确定关键函数的方式

我们去找GetWindowTextA函数

CTRL+F2结束进程并且重新加载程序



继续查找GetWindowTextA 并且打上断点

开始执行

并且进入

程序领空后我们能发现结果是一样的



<img src="https://i-blog.csdnimg.cn/blog_migrate/2491699706bdc80c97930a5c2f5c835d.png" alt="" style="max-height:135px; box-sizing:content-box;" />


并且根据之前的 call GetWindowTextA 我们能了解 是GetDlgItemTextA函数调用了 GetWindowTextA函数

这里我们就已经完全明白了 我们输入的值是被GetDlgItemTextA函数读取了

所以我们继续重新来

#### 再一次调试程序

CTRL+F2重新来

并且在GetDlgItemTextA函数打上断点

执行到函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/ba0df66dae6839ff19f16d6ef7d0553c.png" alt="" style="max-height:117px; box-sizing:content-box;" />


我们就可以开始看这个函数的作用了

```cobol
004011AA                                 .  8D4424 4C           lea     eax, dword ptr [esp+4C]
这里是调用 参数缓冲区地址
004011AE                                 .  6A 51               push    51                               ; /Count = 51 (81.)
这里是参数最大长度
004011B0
                                 .  50                  push    eax                              ; |Buffer
这里是把参数 缓冲区指针压入栈
004011B1                                 .  6A 6E               push    6E                               ; |ControlID = 6E (110.)
这里是参数 id 在文件resource.h中存在
004011B3                                 .  56                  push    esi                              ; |hWnd
这里是参数对话框句柄
004011B4                                 .  FFD7                call    edi                              ; \GetDlgItemTextA
调用函数 取得用户名   如果执行成功 就把用户名长度存入eax中
004011B6                                 .  8D8C24 9C000000     lea     ecx, dword ptr [esp+9C]
这里又是调用函数GetDlgTextA
004011BD                                 .  6A 65               push    65                               ; /Count = 65 (101.)
最大字符
004011BF                                 .  51                  push    ecx                              ; |Buffer
缓冲区指针
004011C0                                 .  68 E8030000         push    3E8                              ; |ControlID = 3E8 (1000.)
控件id
004011C5                                 .  56                  push    esi                              ; |hWnd
句柄
004011C6                                 .  8BD8                mov     ebx, eax                         ; |
把长度存入ebx中
004011C8                                 .  FFD7                call    edi                              ; \GetDlgItemTextA
调用函数 取得序列号 到这里 程序就取得了 用户名和序列号
004011CA                                 .  8A4424 4C           mov     al, byte ptr [esp+4C]
把长度存入al中
004011CE                                 .  84C0                test    al, al
判断是否为空
004011D0                                 .  74 76               je      short 00401248
为空就跳到报错
004011D2                                 .  83FB 05             cmp     ebx, 5
和5比大小 
004011D5                                 .  7C 71               jl      short 00401248
如果小于5 就继续跳到报错
004011D7                                 .  8D5424 4C           lea     edx, dword ptr [esp+4C]
把用户名地址存入edx
004011DB                                 .  53                  push    ebx
把长度压入栈内
004011DC                                 .  8D8424 A0000000     lea     eax, dword ptr [esp+A0]
把序列号存入eax
004011E3                                 .  52                  push    edx
把用户名压入栈
004011E4                                 .  50                  push    eax
把序列号压入栈
004011E5                                 .  E8 56010000         call    00401340
对序列号进行判断
004011EA                                 .  8B3D BC404000       mov     edi, dword ptr [<&USER32.GetDlgI>;  USER32.GetDlgItem
 
004011F0                                 .  83C4 0C             add     esp, 0C
栈平衡 符合c的调用
004011F3                                 .  85C0                test    eax, eax
对比 eax 如果eax为0 表示注册失败 如果eax=1表示成功
004011F5                                 .  74 37               je      short 0040122E
 
```

这里是我们全部的执行过程

当程序读取完 用户名的时候



<img src="https://i-blog.csdnimg.cn/blog_migrate/6509a33682182193228efdab7c4e8325.png" alt="" style="max-height:123px; box-sizing:content-box;" />


参数已经压入栈内了

这里我们已经找到关键判断

```cobol
004011F3                                 .  85C0                test    eax, eax
对比 eax 如果eax为0 表示注册失败 如果eax=1表示成功
004011F5                                 .  74 37               je      short 0040122E
不跳转代表成功 
```

我们需要注意

je是通过zf标志位进行判断 是否跳转 当zf为1 就进行跳转 如果为0 就不进行 跳转

因为不跳转就代表成功注册 所以我们把zf改为 0 就可以不跳转

原本应该对该标志位修改就可以绕过跳转 但是我这里无论改了还是没改都没有用

最简单直接把je命令 换位 nop 直接不执行 je即可

所以我们进行更改



<img src="https://i-blog.csdnimg.cn/blog_migrate/93e0fba6c1ca552d016bf027ec215fab.png" alt="" style="max-height:126px; box-sizing:content-box;" />


双击更改





<img src="https://i-blog.csdnimg.cn/blog_migrate/4d53458460b6b43ecb4ff6935b08a57b.png" alt="" style="max-height:107px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/4e308567315584b1de8cca5f4b14e548.png" alt="" style="max-height:146px; box-sizing:content-box;" />


然后保存



<img src="https://i-blog.csdnimg.cn/blog_migrate/c95da046f2ccf3360c6f8b6e5e9d5617.png" alt="" style="max-height:1080px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/c2fd03b344c15377901702d79cc30608.png" alt="" style="max-height:1080px; box-sizing:content-box;" />


这个时候



<img src="https://i-blog.csdnimg.cn/blog_migrate/8af6f62ce8b59c2b3ada05d3072b5301.png" alt="" style="max-height:205px; box-sizing:content-box;" />


我们成功绕过了

这种方式是爆破

#### 我们看看能不能直接取得序列码

我们首先要对算法进行分析

我们在之前明白了

```cobol
004011E5                                 .  E8 56010000         call    00401340
对序列号进行判断
```

所以我们F7跟进查看是如何判断的



<img src="https://i-blog.csdnimg.cn/blog_migrate/0dbdaf39b9f000efa016a31b9365b3dc.png" alt="" style="max-height:669px; box-sizing:content-box;" />


这里是他的主要函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/7955f1586d251d6f52ce76a48ad92353.png" alt="" style="max-height:86px; box-sizing:content-box;" />


我们能发现这里面有进行对比 因为我们的序列号要和计算出来的对比

所以我们可以尝试 看看能不能在这个函数里面取得我们的序列号



<img src="https://i-blog.csdnimg.cn/blog_migrate/3805c40408fb971b83d61b45110bebd1.png" alt="" style="max-height:502px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/3e80e4eaf085e9c64aa1af1515b232ce.png" alt="" style="max-height:502px; box-sizing:content-box;" />


这里是对比函数的内部 我们进行运行



<img src="https://i-blog.csdnimg.cn/blog_migrate/0532f7fa280ed841ac34dd68e92a5626.png" alt="" style="max-height:909px; box-sizing:content-box;" />


再栈窗口中

我们能发现出现了两个字符串 因为我当时调试的时候没有输入 序列号 所以字符串1为空

字符串2出现了值

我们打开软件看看 字符串2和我们之前输入的能不能注册成功



<img src="https://i-blog.csdnimg.cn/blog_migrate/d1c7d3d202b3f7214b4f36b1f4dfa9d2.png" alt="" style="max-height:224px; box-sizing:content-box;" />


发现成功

到这里 我们就程序分析完
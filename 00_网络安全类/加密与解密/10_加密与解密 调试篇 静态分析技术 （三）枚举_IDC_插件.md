# 加密与解密 调试篇 静态分析技术 （三）枚举/IDC/插件

**目录**

[TOC]





## 1.枚举类型

这是一段c语言源代码

```perl
#include <stdio.h> 
int main(void)
{
	enum weekday { MONDAY, TUESDAY, WEDNESDAY, THUSDAY, FRIDAY, SATURDAY, SUNDAY }; 
 
	printf("%d,%d,%d,%d,%d,%d,%d",MONDAY,TUESDAY, WEDNESDAY, THUSDAY, FRIDAY, SATURDAY, SUNDAY );
 
	return 0;
}
```

在IDA的反汇编中却成为了没有意义的数字



<img src="https://i-blog.csdnimg.cn/blog_migrate/0facf05bb954ae0a3b9bd5bfa6080a4a.png" alt="" style="max-height:337px; box-sizing:content-box;" />


因为是有规律的 所以我们可以使用枚举类型来表示这个数字

> View ->Open subviews->Enumerations->Shift+0

插入一个新的weekday



<img src="https://i-blog.csdnimg.cn/blog_migrate/99834a39a799e20ff755985f5a71b2ce.png" alt="" style="max-height:420px; box-sizing:content-box;" />




然后在 weekday枚举中 按N



<img src="https://i-blog.csdnimg.cn/blog_migrate/ce06583600a79847948b7a0a6b59c0ec.png" alt="" style="max-height:268px; box-sizing:content-box;" />


我们重新选择需要定义的数据处



<img src="https://i-blog.csdnimg.cn/blog_migrate/5b1defe2b5e5cb9747696f257bb98304.png" alt="" style="max-height:202px; box-sizing:content-box;" />




> Edit->Operand types->Enum member



<img src="https://i-blog.csdnimg.cn/blog_migrate/2229198e0736e7cecbfd7795cf54e68e.png" alt="" style="max-height:394px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/d02cfb868e13c09597ae0f77b775cdbe.png" alt="" style="max-height:237px; box-sizing:content-box;" />


如果我们想在操作数类型中重新定义现有数据

> Edit->Operand types -> Enum member /按M/右键->Symbolic constant

## 2.FLIRT

FLIRT（库文件快速识别与鉴定技术）

可以让IDA在一系列编译器的标准库文件里自动找出调用的函数，使反汇编更加清晰

### 1.应用FLIRT签名

一般反汇编 无法给出具体函数名字

例如

```cobol
C语言 strlen 函数
在一般中 可能只会显示
 
call 406E40
```

这样的反汇编虽然正确但是没有意义

而IDA中FLIRT却可以正确标记所调用的库函数名称

```vbscript
call strlen
```

IDA通常可以识别一些编译器 但是不一定成功

```markdown
1. 反汇编一些特定版本编译器产生的程序 
 
例如 微软的记事本
 
2. 程序中的编译器资料被删除了
 
例如 高级语言编写的病毒程序
 
3. 编译器不支持导致识别失败
```

打开随书文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/1f259ffddf49f35127e25f707cd89bd7.png" alt="" style="max-height:175px; box-sizing:content-box;" />


我们假设这里的call无法识别

我们主要要学会如何载入

> View->Open subviews->Signatures /shift +F5



<img src="https://i-blog.csdnimg.cn/blog_migrate/efb1e15e78203afc4599f263b7910dad.png" alt="" style="max-height:334px; box-sizing:content-box;" />




> Apply new signature



<img src="https://i-blog.csdnimg.cn/blog_migrate/50c1625680df5e5a8dbbff7040a1ec05.png" alt="" style="max-height:152px; box-sizing:content-box;" />


选中后应该是会自动重新分析代码

如果没有

> Options -> Analysis  -> Reanalyse program

## 3.IDC脚本

IDA可以使用脚本来提升控制

IDA支持两个语言编写脚本 IDC、pyhton

IDA的原始嵌入脚本语言叫做IDC

IDC原本就是一种类C语言的脚本控制器、语法和C语言类似

IDC的脚本中都一条包含ida.idc语句

这是IDA的标准库函数

变量定义形式为autovar

其他逻辑、循环等语句与C语言类似

随书带有3个例子

我们看看第二个

### IDC分析加密代码

载入程序

分析一下入口代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/b7dab0320937b1be54bea8e9acc66c30.png" alt="" style="max-height:217px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/6ec806387680924f5c29cde8b6c60f34.png" alt="" style="max-height:671px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/c512085a14f34d0b97b6751d9e1b8cc1.png" alt="" style="max-height:416px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/8e84949fa6190d4eef00b27fbcff37ef.png" alt="" style="max-height:283px; box-sizing:content-box;" />


这里我们能发现 sub_401080       是对 sub_401060的解密

```vbscript
这段代码利用了 SMC （自己修改自己代码技术）
 
可执行文件中保存着加密文件 然后只有在程序运行 才会通过一处返回正确的代码
 
 
call  解密子程序
call  解密后的子程序
```

我们分析一下解密代码

```cobol
.text:00401080 ; =============== S U B R O U T I N E =======================================
.text:00401080
.text:00401080
.text:00401080 sub_401080      proc near               ; CODE XREF: sub_401020+6↑p
.text:00401080                 mov     eax, offset loc_401060
 
eax中存入 401060
 
.text:00401085
.text:00401085 loc_401085:                             ; CODE XREF: sub_401080+14↓j
.text:00401085                 mov     bl, [eax]
 
把eax中的401060首地址 放入 bl
 
.text:00401087                 xor     bl, 1
 
和1进行异或
 
.text:0040108A                 mov     [eax], bl
 
把异或后的结果存回eax的地址
 
.text:0040108C                 inc     eax
 
把eax的地址进入下一个字节
 
.text:0040108D                 cmp     eax, (offset loc_401070+4)
 
检查待查的指令是否结束
 
.text:00401092                 jg      short locret_401096
 
结束就调到 401096
 
.text:00401094                 jmp     short loc_401085
 
没有就继续
 
.text:00401096 ; ---------------------------------------------------------------------------
.text:00401096
.text:00401096 locret_401096:                          ; CODE XREF: sub_401080+12↑j
.text:00401096                 retn
.text:00401096 sub_401080      endp
.text:00401096
.text:00401096 ; ---------------------------------------------------------------------------
```

我们使用随书的代码

```cobol
 
#include <idc.idc>
static decrypt(from, size, key ) { 
   auto i, x; 
   for ( i=0; i < size; i=i+1 ) { 
      x = Byte(from); 
      x = (x^key); 
      PatchByte(from,x); 
      from = from + 1;
   } 
 Message("\n" + "Decrypt Complete\n");
} 
 
```

> File->Script file
> 
> File->Script command /shift +F12



<img src="https://i-blog.csdnimg.cn/blog_migrate/652f6107a6c05088649361695df437ae.png" alt="" style="max-height:358px; box-sizing:content-box;" />


run

然后重新对 401060 进行分析

选中 401060的代码 然后U 然后重新选中 按 C

就可以出现解密后的代码了



<img src="https://i-blog.csdnimg.cn/blog_migrate/c0fc247d807cd0daf229a318fee07bf1.png" alt="" style="max-height:183px; box-sizing:content-box;" />


```csharp
在实际环境中
 
大多数程序的加密都比这复杂
 
但是思路都是一样
 
通过汇编看看是如何解密 然后就写出脚本来解密即可
 
 
在IDA中 对于由 SMC和其他加密技术的代码 也可以使用其他方式来解密
 
（OllyDbg的动态调试）然后通过IDA的"Additional binary file" 将解密文件程序加载
 
这样就会比自己写代码来的有效
 
```

## 4.插件

这里我们就介绍一个插件

已经集成在IDA中了

Hex-Rays

在进行IDA反汇编分析前

> View->Open Subviews-> F5/Pseudocode



<img src="https://i-blog.csdnimg.cn/blog_migrate/ae06da331a1fe6b433124eca71114428.png" alt="" style="max-height:363px; box-sizing:content-box;" />


这样就能返回高级语言

## 5.IDA调试器

### 1.加载目标文件

> Debugger->Select Debugger

选中 LocalWindowsdebugger



<img src="https://i-blog.csdnimg.cn/blog_migrate/cf6dc682367dd7d243736da8a148a96e.png" alt="" style="max-height:378px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/618da03740da34eb068755e370a1a348.png" alt="" style="max-height:321px; box-sizing:content-box;" />




### 2.调试器界面

### 



### 3.调试跟踪

| F7 | 单步步进，遇到call指令时跟进 |
|:---:|:---:|
| F8 | 单步步过，遇到call指令时路过，不跟进 |
| F4 | 运行到光标所在行 |
| Ctrl+F7 | 直到该函数返回时才停止 |
| F9 | 运行程序 |
| Ctrl+F2 | 终止一个正在运行的程序 |
| F2 | 设置断点 |



### 4.断点

F2进行断点

> Debugger -> Breakpoints -> Breakpoints List

也支持条件断点

```haskell
设置断点后 
 
右键 -> Edit Breakpoints
 
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/da3adcb4b38e6e910bb03e91c5f9a561.png" alt="" style="max-height:430px; box-sizing:content-box;" />


### 5.跟踪

IDA分为两个分类

```cobol
一类是 指令跟踪
 
Debugger -> Taceing -> Instruction Tracing
 
 
IDA负责 记录地址、指令和寄存器的值
 
 
另一类是函数跟踪
 
Debugger -> Tracing -> Function Tracing
 
```

## 6.十六进制工具

HexWorkshop ，WinHex，Hiew

```vbnet
HexWorkshop:
提供了文件比较功能
 
WinHex:
可以查看内存映像文件
 
Hiew：
可以在汇编状态下修改代码
```

### Hiew

修改指令

> 按 ENTER 可以在十六进制 文本 汇编代码中循环切换

> F1可以查看帮助

```cobol
注意跳转指令 
jmp xxxx 将转换成 0E9 xx xx的形式
 
所以 近转移 jmp指令 0EB
需要按照 jmp short xxxxx 或者 jmps xxxxx的形式输入
 
 
远转移指令的形式是 jmp xxxxx
其中 xxxxx是文件偏移地址
 
 
如果将近转移指令写出长指令形式
或者将偏移地址写成虚拟地址 在 Hiew中可能没有问题
但是执行就会出错
```

这里给出例子来修改指令

> 为 ReverseMe增加 水平和垂直滚动条

滚动条的显示 是通过 CreateWindowsEx函数来控制



<img src="https://i-blog.csdnimg.cn/blog_migrate/c8dd4c08d6e04caab4987d5cd80fbe6a.png" alt="" style="max-height:214px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/593d29af18b7a02afaa4ec6cad410c42.png" alt="" style="max-height:255px; box-sizing:content-box;" />


发现这里是调用 CreateWindowsExA的参数等

而如果我们需要显示滚动条

只需要dwStyle参数加入 WS_HSCROLL和WS_VSCROLL两个参数即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/7f51030cbe3579396ce006bc06b43f8d.png" alt="" style="max-height:112px; box-sizing:content-box;" />


两个参数在 winuser.h的参数是这些

因为要加上这两个 所以通过OR运算来加入数值 计算机就识别然后添加

所以我们只需要在 0040109E中写入

```cobol
00CF0000h OR 100000h OR 200000h
=00FF0000h
```

我们通过 Hiew打开文件

#### 跳转

> F5-> .40109E

#### 修改

> F3进入编辑状态
> 
> F2 或者在 行上按ENTER

进入修改汇编



<img src="https://i-blog.csdnimg.cn/blog_migrate/9a4b4a7ec9517d2e187d404902aa8714.png" alt="" style="max-height:208px; box-sizing:content-box;" />


按 ENTER ESC即可

#### 保存

> F9存盘



<img src="https://i-blog.csdnimg.cn/blog_migrate/cfcc2217ef45921c0ea12842c10fe816.png" alt="" style="max-height:759px; box-sizing:content-box;" />


这样就出现了 滚动框

## 7.静态分析技术应用实例

### 1.爆破



<img src="https://i-blog.csdnimg.cn/blog_migrate/43563489d41c3e1624dbcd28c4588b37.png" alt="" style="max-height:186px; box-sizing:content-box;" />


打开ida



<img src="https://i-blog.csdnimg.cn/blog_migrate/b6c868801557e2cdbb825b654eec656a.png" alt="" style="max-height:655px; box-sizing:content-box;" />




主要通过报错的地方来修改

对比的核心代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/c18e8db1dc10ddc2b523edcf378db399.png" alt="" style="max-height:152px; box-sizing:content-box;" />


我们只需要对jnz 修改为 nop 他就会执行下面的OK

修改汇编

> Edit -> Patch program -> Assemble

应用到程序

> Edit -> Patch program -> Apply patches to input file



<img src="https://i-blog.csdnimg.cn/blog_migrate/a9e39e1bf0823123ebf99eba0f9f4390.png" alt="" style="max-height:270px; box-sizing:content-box;" />


2.算法



<img src="https://i-blog.csdnimg.cn/blog_migrate/6185751df57d63de6f8f8179dbf5e487.png" alt="" style="max-height:185px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/04c75cca5d288f7a3390e6d7d068c33c.png" alt="" style="max-height:194px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/28f7cdfd0df0c6fe496e314df3cad1a2.png" alt="" style="max-height:634px; box-sizing:content-box;" />


能发现就是对 String2进行比对 然后上面 String2 又是 9981



<img src="https://i-blog.csdnimg.cn/blog_migrate/f0d0200a4d953eae7a2c2a70b3a8287c.png" alt="" style="max-height:104px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/d742ab65571303ade397c2ec20dedd35.png" alt="" style="max-height:136px; box-sizing:content-box;" />


所以序列号就是 9981

<img src="https://i-blog.csdnimg.cn/blog_migrate/9fb0141aac8646ed0bec059b6c31a354.png" alt="" style="max-height:249px; box-sizing:content-box;" />


## 8.逆向工程初步

```cobol
要求：
1.移除报错对话框
2.显示一个对话框 然后输出用户输出的内容
3.显示对话框 告知用户输入错误还是正确
4.修改 not reversed 为 - reversed -
5.修改序列号为 pediy
```

### 1.移除报错对话框

首先通过字符串窗口查看



<img src="https://i-blog.csdnimg.cn/blog_migrate/6a13844ba2b15c03a62e4feedc5e1336.png" alt="" style="max-height:177px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/2c7fccb5b811d94c1bd1f45fc6922432.png" alt="" style="max-height:326px; box-sizing:content-box;" />




```cobol
text:0040123B loc_40123B:                             ; DATA XREF: sub_401110+FC↑o
.text:0040123B                 push    0               ; uType
获取消息样式
.text:0040123D                 push    offset Caption  ; "ReverseMe #1"
标题
.text:00401242                 push    offset aOkayForNowMiss ; "Okay, for now, mission failed !"
文本内容
.text:00401247                 push    0               ; hWnd
父窗口句柄
.text:00401249                 call    MessageBoxA
显示窗口
```

我们只需要直接修改跳转到 MessageBoxA函数执行完的地址即可绕过

```cobol
jmp 0040124Eh
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8885b8e1caec0ed7ed16887272525b97.png" alt="" style="max-height:142px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/049499b00c820d55d621e75cdb722dfe.png" alt="" style="max-height:320px; box-sizing:content-box;" />


### 2.显示一个对话框 然后输出用户输出的内容

首先 先了解程序用什么api来获取输入

在input窗口中



<img src="https://i-blog.csdnimg.cn/blog_migrate/88fac71f1d8b2f861f21d896562b4455.png" alt="" style="max-height:431px; box-sizing:content-box;" />


发现了GetWindowsTextA

我们进入看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/7d33279774d702590c4d87f0862bf3cd.png" alt="" style="max-height:239px; box-sizing:content-box;" />


```cobol
t:00401202                 cmp     ax, 3
.text:00401206                 jnz     loc_4012EC
.text:0040120C                 mov     eax, offset loc_40123B
存入40123B地址
.text:00401211                 jmp     eax
跳到 40123B
.text:00401213 ; ---------------------------------------------------------------------------
.text:00401213                 push    200h            ; nMaxCount
获取字符串长度
.text:00401218                 push    offset Text     ; lpString
获取缓冲区地址
.text:0040121D                 push    hWnd            ; hWnd
获取句柄
.text:00401223                 call    GetWindowTextA
获取文本
.text:00401228                 push    0               ; uType
.text:0040122A                 push    offset Caption  ; "ReverseMe #1"
.text:0040122F                 push    offset Text     ; lpText
.text:00401234                 push    0               ; hWnd
.text:00401236                 call    MessageBoxA
```

这里明显无法执行 因为跳转到了40123B 所以我们把跳转 nop即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/269be9fa8e80440424170f65ee0b5ec0.png" alt="" style="max-height:281px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/230fc1b525d2391f7b003e21d630b676.png" alt="" style="max-height:202px; box-sizing:content-box;" />


### 3.修改字符串内容

使用 HexWorkshop搜索 Not Reversed



<img src="https://i-blog.csdnimg.cn/blog_migrate/cacf9af79539da1baa60c613b8dc0743.png" alt="" style="max-height:180px; box-sizing:content-box;" />


修改为 - Reversed -



同时搜索 bad 和 good

修改



<img src="https://i-blog.csdnimg.cn/blog_migrate/a8c6f8cbef665171795d516b3f5371d9.png" alt="" style="max-height:201px; box-sizing:content-box;" />


保存即可

在保存后放入ida



<img src="https://i-blog.csdnimg.cn/blog_migrate/23bc37316872c70dc23045b1384c0298.png" alt="" style="max-height:138px; box-sizing:content-box;" />




发现已经修改了



### 4.修改序列号

修改序列号要通过修改汇编代码来完成

Hiew



<img src="https://i-blog.csdnimg.cn/blog_migrate/110f2513fb40e70c1d372207f5d3438d.png" alt="" style="max-height:384px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/cc8398f334461adc8050c5ef19e907d6.png" alt="" style="max-height:201px; box-sizing:content-box;" />
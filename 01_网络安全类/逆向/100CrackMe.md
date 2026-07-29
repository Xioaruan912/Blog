# Acid burn.exe

![image-20250207125101676](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207125101676.png)

显示字符串

我们进入ollydbg动调

首先我们要知道 win32api 编程里 什么api可以 调出对话框

### 处理MessageBox

`MessageBox`

其中又存在 MessageBoxA 和 MessageW

![image-20250207125408799](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207125408799.png)

这里是gpt给的回答

![image-20250207125607382](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207125607382.png)

我们可以通过动态调试 来测试是 MessageBoxA还是MessageBoxW

ollydbg里 我们通过 Ctrl + G 打开

![image-20250207125701906](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207125701906.png)

双击即可跳转到api函数里 我们下断点 然后执行

![image-20250207125739491](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207125739491.png)

在堆栈里可以发现 就是我们的Message

```
int MessageBoxA(
  [in, optional] HWND   hWnd,
  [in, optional] LPCSTR lpText,
  [in, optional] LPCSTR lpCaption,
  [in]           UINT   uType
);
```

通过微软的api介绍可以发现

https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messageboxa

第一个是句柄 第二个是内容 第三个是`The dialog box title` 对话框标题

第四个是内容和行为 这里就是按钮什么的 附加操作

这里有一个思路 调用完需要返回 我们看看是什么 调用的 F8走下去

### 处理函数调用

这里我们首先要知道函数调用流程

![image-20250207131536587](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207131536587.png)

这里是我找到谁调用的

首先会传入参数

这里MessageBox要的参数如上

然后调用函数

```
style
Title
Text
hawd
调用函数MessageA
```

是这样的执行过程

所以我们可以定位到这里是调用第一个弹窗的MessageBoxA 我们直接修改代码

把call直接nop调

![image-20250207132222206](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207132222206.png)

这样我们就把最开始弹窗nop掉

但是这里出现问题 我们把messageboxA nop调 后面所有的都无法MessageBoxA 所以这里我们还需要继续往回找

![image-20250207132655004](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207132655004.png)

这里发现 调用了函数 我们nop看看

![image-20250207132804388](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207132804388.png)

这里彻底发现了调用函数的内容

可以发现这里前面的push 和栈里面的内容 明确这里是 对话框的弹出

但是这里其实是user32.dll里的调用 所以还需要继续往回走

![image-20250207134421473](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207134421473.png)

走到这里之后其实我们还是不知道 是不是继续回走 我们继续执行 如果弹出交互框那么就是这块了

![image-20250207134556643](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207134556643.png)

可以发现上面就是调用

我们把上面的

`call dword ptr ds:[ebx+0x1CC]`

`0042563D`

nop即可

这里我们给个备注

第二个我们来看看这里

![image-20250207132326603](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207132326603.png)

这里check it 的判断找到

这里我们可以发现输入错误继续是MessageBoxA 所以我们继续断点 直到 出现错误提示

![image-20250207134859942](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207134859942.png)

断住 向上走 我们看看什么调用

这里注意

判断一般有

```
if(){

}
else(){

}
```

所以我们注意跳转

这里我们发现为什么要回去两次呢

![image-20250207135145836](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207135145836.png)

回去两次才到我们主程序

之前分别是 user32.dll apphelp.dll 这两个动态链接库

![image-20250207135525638](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207135525638.png)

找到了一个很大的跳转 这里就是判断

这里存在bug 我们去把52 插件里面的 中文搜索.dll 拉出重新即可

`0042FB37` Ctrl+G定位

![image-20250207175041523](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207175041523.png)

修复

把 `0042FB03` 修改为 nop即可

这样就饶过了第一个

### 定位常量字符串

![image-20250207175410152](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207175410152.png)

通过定位try again来实现

![image-20250207175448297](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207175448297.png)

![image-20250207175500964](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207175500964.png)

直接获取双击进入

这里对常量有用

例如

```
key = "Try Again"
```

但是如果用下面

```
byte key[] = [0x54,0x72,0x79,0x20,0x41,0x67,0x61,0x6E]
```

![image-20250207175745066](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207175745066.png)

这种就需要通过二进制查找

这样我们直接定位到了

```
0042F4D5  |. /75 1A         jnz short Acid_bur.0042F4F1
```

![image-20250207175908076](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207175908076.png)

改为nop即可

### 找到key

这里我们重新下载 看看 key在哪里

定位到判断

0019F750   00AAA51C  ASCII "CW-4018-CRACKED"

![image-20250207180700669](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207180700669.png)

这里我两次 可以发现中间是随机数字

所以我们要去找到这个随机数生成地址

![image-20250207180733802](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207180733802.png)

可以找到前俩个的拼接 直接下断点判断

分析后发现

```
0042FA87  |.  8B45 F0       mov eax,[local.4]                        ;  获取字符串长度
0042FA8A  |.  0FB600        movzx eax,byte ptr ds:[eax]              ;  获取第一个字符串的ascii值
0042FA8D  |.  F72D 50174300 imul dword ptr ds:[0x431750]             ;  乘以 0x29
0042FA93  |.  A3 50174300   mov dword ptr ds:[0x431750],eax
0042FA98  |.  A1 50174300   mov eax,dword ptr ds:[0x431750]
0042FA9D  |.  0105 50174300 add dword ptr ds:[0x431750],eax          ;  eax的值*2

```

![image-20250207184920859](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207184920859.png)

这里我们看看是不是这个注册码

![image-20250207184937314](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250207184937314.png)

正确的

这里我们就可以写注册机了

我用python写

```python

if __name__ == '__main__':
    name = input("输入名字：")
    name_key = name[0]
    key_ascii = ord(name_key) * 0x29 * 2
    print(f"{name}的注册码为")
    print("CW-"+str(key_ascii)+"-CRACKED")

```

另一个注册码为

`"Hello Dude!"`

可以直接再内存里找到 

到这里 这个题目结束


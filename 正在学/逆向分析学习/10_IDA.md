主要是学习如何使用IDA

# IDA

主要是静态分析软件 可以轻易通过 反汇编操作实现反汇编

IDA可以分析多个处理器架构的二进制程序 `x86` `arm` `x64` `MIPS` 以及 `Java字节码`

IDA可以自动分析 标准化函数和库函数 减少我们分析的复杂性

IDA还支持通过插件和脚本 辅助分析 

# PDB文件

我们知道 编译一个PE后 没有专门的 结构体 变量名字了 但是这些内容 会写入一个 PDB文件中 如果 IDA 有PDB文件 那么加载后可以 对逆向流程更加清晰

# 函数窗口

![image-20260126092850162](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260126092850162.png)

具有下面的类别：

`stub开头`：主要是程序的函数 `stub`后面跟的是函数地址

`__开头`：具有完整名字 一般是静态编译 后的 库函数

`完整函数名字并且背景是粉红`：一般是外部引入函数

# 反汇编窗口

默认的 `View-A` 就是 反汇编窗口

![image-20260126093223294](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260126093223294.png)

包含两个模式 我们可以通过 `空格` 进行切换

# 十六进制窗口

`Hex View-1` 就是 十六进制窗口 和我们通过`Winhex` 分析 PE的一样 但是这里的地址是 `RVA` 也就是文件加载到内存后的样子展示的 

与`View-A`联动 如果我们点击 某个地址 那么反汇编窗口也会定位到这个位置上

![image-20260126093400101](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260126093400101.png)

# 结构体窗口与枚举类型窗口

![image-20260126093536029](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260126093536029.png)

我们可以通过 找到分析 结构体和枚举 从而在这两个页面添加 结构体信息 这样我们逆向分析的可读性就提高了

# 导入导出表窗口

![image-20260126093823233](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260126093823233.png)

# 字符串窗口

这也是逆向经常使用的窗口

通过 `shift + F12` 快速打开

![image-20260126093921139](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260126093921139.png)

# 反编译

通过`View-A` 按下 `F5` 直接分析当前光标的 反汇编

# 对函数和变量命名

我们通过对函数和变量 `右键+N` 就可以全局重命名

# 重定位

我们如果打开一个 动态调试器 并且需要配合 IDA分析 那么我们需要对 IDA 设置一个 基地址 从而快速定位

![image-20260126094520293](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260126094520293.png)

# 查看函数引用情况

我们可以对函数 按下`Ctrl + X ` 就可以得到一个与当前函数相关的 过程

# 函数调用关系网

这两个说明 是以当前函数为起点 还是以当前函数为终点的 函数调用关系网

![image-20260126094700864](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260126094700864.png)

# 实际分析过程

```c
#include <windows.h>
#include <stdio.h>

int main()
{
    unsigned char shellcode[] = 
        "\x31\xd2\xb2\x30\x64\x8b\x12\x8b\x52\x0c\x8b\x52\x1c\x8b\x42"
        "\x08\x8b\x72\x20\x8b\x12\x80\x7e\x0c\x33\x75\xf2\x89\xc7\x03"
        "\x78\x3c\x8b\x57\x78\x01\xc2\x8b\x7a\x20\x01\xc7\x31\xed\x8b"
        "\x34\xaf\x01\xc6\x45\x81\x3e\x46\x61\x74\x61\x75\xf2\x81\x7e"
        "\x08\x45\x78\x69\x74\x75\xe9\x8b\x7a\x24\x01\xc7\x66\x8b\x2c"
        "\x6f\x8b\x7a\x1c\x01\xc7\x8b\x7c\xaf\xfc\x01\xc7"
        "\x68\x75\x61\x6e\x01\x68\x75\x61\x6e\x79\x68\x20\x20\x40\x78"
        "\x89\xe1\xfe\x49\x0b\x31\xc0\x51\x50\xff\xd7";
	
    // 1. 申请一块具有可读、可写、可执行权限的内存空间 (RWX)
    PVOID page = VirtualAlloc(NULL, 4096, MEM_RESERVE | MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    
    if (page) {
        // 2. 清空内存并把 shellcode 拷贝进去
        ZeroMemory(page, 4096);
        CopyMemory(page, shellcode, sizeof(shellcode));
		
        // 3. 创建一个新线程从 shellcode 的起始位置开始执行
        DWORD threadId = 0;
        HANDLE hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)page, NULL, 0, &threadId);
		
        if (hThread != NULL) {
            printf("create thread success!\n");
            // 4. 等待线程执行结束，否则主程序退出会导致 shellcode 停止运行
            WaitForSingleObject(hThread, INFINITE);
        }
        else {
            printf("create thread error!\n");
        }
    }
    else {
        printf("VirtualAlloc failed, error = %d\n", GetLastError());
    }
	
    return 0;
}
```

这是一段` shellcode` 打包好放入 IDA分析 可以看见 a1就是我们的shellcode

![image-20260126100145587](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260126100145587.png)

我们可以直接强制转化为 code代码

![Capturer_2026-01-26_100225_701](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-26_100225_701.gif)

# 构建结构体

```c
#include <stdio.h>
#include <math.h>

struct Point {
    float x;
    float y;
    float z;
};

float distance(struct Point* p1, struct Point* p2) {
    return sqrt(pow(p2->x - p1->x, 2) + pow(p2->y - p1->y, 2) + pow(p2->z - p1->z, 2));
}

int main() {
    struct Point p1 = {1, 2, 3};
    struct Point p2 = {4, 5, 6};

    printf("distance = %f\n", distance(&p1, &p2));

    return 0;
}
```

反汇编后内容如下

![image-20260126100845091](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260126100845091.png)

可以发现 和源代码还是有区别的 IDA9 改版为 `local type`

![image-20260126101404939](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260126101404939.png)

右键 增加结构体

我们通过 对 `下括号` `按下D` 可以增加成员 `右键 按Y ` 修改

```
00000000 struct __fixed point // sizeof=0xC
00000000 {
00000000     float x;
00000004     float y;
00000008     float z;
0000000C };
```

 ![Capturer_2026-01-26_105928_397](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-26_105928_397.gif)

这样就实现了 结构体构建
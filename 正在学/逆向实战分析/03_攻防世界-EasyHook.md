首先查壳

![image-20260215185434615](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260215185434615.png)

没有壳并且 是 C写的 我们直接 IDA分析一下

首先分析一下执行过程 

![Capturer_2026-02-15_185551_235](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-02-15_185551_235.gif)

其实很简单很清晰

# IDA分析

我们开始 F5分析

```c
int __cdecl main(int argc, const char **argv, const char **envp)
{
  HANDLE FileA; // eax
  DWORD NumberOfBytesWritten; // [esp+4h] [ebp-24h] BYREF
  char Buffer[32]; // [esp+8h] [ebp-20h] BYREF

  sub_401370(aPleaseInputFla);                  // 这里后面是一个字符串 所以我们认为是 printf
  scanf("%31s", Buffer);
  if ( strlen(Buffer) == 19 )
  {
    sub_401220();
    FileA = CreateFileA(FileName, 0x40000000u, 0, 0, 2u, 0x80u, 0);  //通过CreateFileA 构建文件
    WriteFile(FileA, Buffer, 0x13u, &NumberOfBytesWritten, 0);
    sub_401240(Buffer, &NumberOfBytesWritten);
    if ( NumberOfBytesWritten == 1 )
      sub_401370(aRightFlagIsYou); //比对成功就 输出
    else
      sub_401370(aWrong);
    system(Command);
    return 0;
  }
  else
  {
    sub_401370(aWrong);
    system(Command);
    return 0;
  }
}
```

我们现在直接对 `printf` 修改 可以通过快捷键 `N` 快速修改名字

![Capturer_2026-02-15_185906_297](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-02-15_185906_297.gif)

我们确定关键算法后

```c
int __cdecl sub_401240(const char *a1, _DWORD *a2)
{
  int result; // eax
  unsigned int v3; // kr04_4
  char v4[24]; // [esp+Ch] [ebp-18h] BYREF

  result = 0;
  strcpy(v4, "This_is_not_the_flag");
  v3 = strlen(a1) + 1;
  if ( (int)(v3 - 1) > 0 )
  {
    while ( v4[a1 - v4 + result] == v4[result] )
    {
      if ( ++result >= (int)(v3 - 1) )
      {
        if ( result == 21 )
        {
          result = (int)a2;
          *a2 = 1;
        }
        return result;
      }
    }
  }
  return result;
}
```

可以发现是 在 `401240`地址处的函数

下面两个方法 得到`flag`

# 动态调试

这里通过`x64dbg` 分析

首先初始会断点在` ntdll.dll`代码处

我们需要运行到 用户代码

![image-20260215223541720](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260215223541720.png)

通过`Ctrl+G` 跳转到之前关键函数位置`401240`

依据IDA分析 输入19个字符

![image-20260215224236972](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260215224236972.png)

这里发现输入的内容 被修改了

![image-20260215230018922](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260215230018922.png)

遵循`__cdecl` 从右向左压入栈 那么上面那个乱七八糟的字符串就是 我们输入的`buffer`

那么说明存在一个函数 修改了` buffer`

回到IDA 发现 有一个函数我们没有查看

![image-20260215230132006](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260215230132006.png)

算法如下

```c
int sub_401220()
{
  HMODULE LibraryA; // eax
  DWORD CurrentProcessId; // eax

  CurrentProcessId = GetCurrentProcessId();
  hProcess = OpenProcess(0x1F0FFFu, 0, CurrentProcessId);
  LibraryA = LoadLibraryA(LibFileName);
  //下面是在寻找 CreateFile 函数 可以猜测是不是HOOK
  WriteFile_0 = (BOOL (__stdcall *)(HANDLE, LPCVOID, DWORD, LPDWORD, LPOVERLAPPED))GetProcAddress(LibraryA, ProcName);
  lpAddress = WriteFile_0;
  if ( !WriteFile_0 )
    return printf(&unk_40A044);
  unk_40C9B4 = *(_DWORD *)lpAddress;
  *((_BYTE *)&unk_40C9B4 + 4) = *((_BYTE *)lpAddress + 4);
  byte_40C9BC = -23;
  dword_40C9BD = (char *)sub_401080 - (char *)lpAddress - 5;
  return sub_4010D0();
}
```

我们从下面可以发现 就是HOOK操作

```c
  dword_40C9BD = (char *)sub_401080 - (char *)lpAddress - 5;
```

这里就和我们之前HOOK自己函数一样 通过 上面的`-23` 通过16进制转 就是 `0xE9`

最后一个`return`函数

```c
BOOL sub_4010D0()
{
  DWORD v1; // [esp+4h] [ebp-8h] BYREF
  DWORD flOldProtect; // [esp+8h] [ebp-4h] BYREF

  v1 = 0;
  VirtualProtectEx(hProcess, lpAddress, 5u, 4u, &flOldProtect);
  WriteProcessMemory(hProcess, lpAddress, &byte_40C9BC, 5u, 0);
  return VirtualProtectEx(hProcess, lpAddress, 5u, flOldProtect, &v1);
}
```

标准的写入内存内容 那么我们需要看看hook的函数内容是什么

![image-20260215230344292](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260215230344292.png)

```c
int __stdcall sub_401080(
        HANDLE hFile,
        LPCVOID lpBuffer,
        DWORD nNumberOfBytesToWrite,
        LPDWORD lpNumberOfBytesWritten,
        LPOVERLAPPED lpOverlapped)
{
  int v5; // ebx

  v5 = sub_401000((int)lpBuffer, nNumberOfBytesToWrite);
  sub_401140(); //这里一定取消HOOK 否则下面再调用 进入死循环
  WriteFile(hFile, lpBuffer, nNumberOfBytesToWrite, lpNumberOfBytesWritten, lpOverlapped);
  if ( v5 )
  //核心点
    *lpNumberOfBytesWritten = 1;
  return 0;
}
```

可以发现这里才是核心点 因为设置了 `lpNumberOfBytesWritten = 1 `

最后我们发现 是通过 `sub_401000`函数实现

```c
int __cdecl sub_401000(int a1, int a2)
{
  char i; // al
  char v3; // bl
  char v4; // cl
  int v5; // eax
//对输入进行算法发
  for ( i = 0; i < a2; ++i )
  {
    if ( i == 18 )
    {
      *(_BYTE *)(a1 + 18) ^= 0x13u;
    }
    else
    {
      if ( i % 2 )
        v3 = *(_BYTE *)(i + a1) - i;
      else
        v3 = *(_BYTE *)(i + a1 + 2);
      *(_BYTE *)(i + a1) = i ^ v3;
    }
  }
  v4 = 0;
  if ( a2 <= 0 )
    return 1;
  v5 = 0;
  //算法结果和字符串比对 如果正确 那么就是flag 
  while ( byte_40A030[v5] == *(_BYTE *)(v5 + a1) )
  {
    v5 = ++v4;
    if ( v4 >= a2 )
      return 1;
  }
  return 0;
}
```

所以我们只需要反向分析即可 输入 比对字符串进行异或 然后输出就可以得到flag

```c

#include <stdint.h>
#include <stdio.h>
unsigned int  data[] = {
    0x61, 0x6A, 0x79, 0x67, 0x6B, 0x46, 0x6D, 0x2E,
    0x7F, 0x5F, 0x7E, 0x2D, 0x53, 0x56, 0x7B, 0x38,
    0x6D, 0x4C, 0x6E
};

unsigned char flag[20] = { 0 };

int main() {
    int v3;
    for (int i = 0; i < 19; ++i)
    {
        if (i == 18)
        {
             data[i] ^= 0x13;
        }
        else
        {
            if (i % 2)
                /*
                原本算法是 data[i] =  i ^( buffer[i] - i);
                我们有数据 需要反向算法
                buffer[i] = (data[i]^i) +1
                */
                flag[i] = (i ^ data[i]) + i;
            else

                /*
                原本算法是 
                data[i] = i ^ buffer[i+2];
                现在需要还原
                flag[i+2] = data[i] ^ i 
                */
                flag[i+2] = i ^ data[i];
        }
    }
    printf((const char*)flag);
}
```

这里需要反向算法的分析

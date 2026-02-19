

![image-20260216041927093](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260216041927093.png)qi

并且是一个` MessageBox` 的调用 通过`MB_OK_CANCLE`

# IDA

```
int __cdecl __noreturn main(int argc, const char **argv, const char **envp)
{
  int v3; // ecx
  CHAR *lpMem; // [esp+8h] [ebp-Ch]
  HANDLE hHeap; // [esp+10h] [ebp-4h]

  hHeap = HeapCreate(0x40000u, 0, 0);
  lpMem = (CHAR *)HeapAlloc(hHeap, 8u, SourceSize + 1);
  memcpy_s(lpMem, SourceSize, &unk_409B10, SourceSize);
  if ( !sub_40102A() && !IsDebuggerPresent() )
  {
    MessageBoxA(0, lpMem + 1, "Flag", 2u);
    HeapFree(hHeap, 0, lpMem);
    HeapDestroy(hHeap);
    ExitProcess(0);
  }
  __debugbreak();
  sub_401000(v3 + 4, lpMem);
  ExitProcess(0xFFFFFFFF);
}
```

`__noreturn`会终止程序的执行

# 绕过反调试

我们可以发现存在一个判断

```
IsDebuggerPresent()
```

可以发现有一个完全不会触发的函数

```
  __debugbreak();
  sub_401000(v3 + 4, lpMem);
```

那么就直接分析即可

```c
#include <stdint.h>
#include <string.h>
#include <stdio.h>

unsigned int sub_401000_C(uint8_t* a2)
{
    uint32_t key = 0xDDCCAABB;  // dword_409B38
    size_t len = strlen((const char*)(a2 + 1)); // 从 a2+1 开始算字符串长度
    unsigned int count = (unsigned int)(len >> 2) + 1;

    for (unsigned int i = 0; i < count; ++i) {
        uint32_t w;
        memcpy(&w, a2 + 4 * i, 4);
        w ^= key;
        memcpy(a2 + 4 * i, &w, 4);
    }
    return count;
}

int main(void)
{
    uint8_t data[] = {
        0xBB, 0xCC, 0xA0, 0xBC, 0xDC, 0xD1, 0xBE, 0xB8, 0xCD, 0xCF, 0xBE, 0xAE, 0xD2, 0xC4, 0xAB, 0x82,
        0xD2, 0xD9, 0x93, 0xB3, 0xD4, 0xDE, 0x93, 0xA9, 0xD3, 0xCB, 0xB8, 0x82, 0xD3, 0xCB, 0xBE, 0xB9,
        0x9A, 0xD7, 0xCC, 0xDD
    };

    sub_401000_C(data);
    printf("%s\n", (char*)(data + 1));
    return 0;
}

```


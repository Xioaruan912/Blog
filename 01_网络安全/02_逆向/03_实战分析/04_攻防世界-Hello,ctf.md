# 查壳

![image-20260215233009584](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260215233009584.png)

没有加壳

执行查看流程

```
please input your serial:123123
wrong!
please input your serial:123123
wrong!
please input your serial:
```

IDA分析一下

```c
int __cdecl main(int argc, const char **argv, const char **envp)
{
  int i; // ebx
  char v4; // al
  int result; // eax
  int v6; // [esp+0h] [ebp-70h]
  int v7; // [esp+0h] [ebp-70h]
  char Buffer[2]; // [esp+12h] [ebp-5Eh] BYREF
  char v9[20]; // [esp+14h] [ebp-5Ch] BYREF
  char v10[32]; // [esp+28h] [ebp-48h] BYREF
  __int16 v11; // [esp+48h] [ebp-28h]
  char v12; // [esp+4Ah] [ebp-26h]
  char v13[36]; // [esp+4Ch] [ebp-24h] BYREF

  strcpy(v13, "437261636b4d654a757374466f7246756e");
  while ( 1 )
  {
    memset(v10, 0, sizeof(v10));
    v11 = 0;
    v12 = 0;
    printf(aPleaseInputYou, v6);
    scanf("%s", v9);                            // 写入17个字符
    if ( strlen(v9) > 17 )
      break;
    for ( i = 0; i < 17; ++i )
    {
      v4 = v9[i];
      if ( !v4 )
        break;
      sprintf(Buffer, "%x", v4);
      strcat(v10, Buffer);                      // buffer 写入 V10
    }
    if ( !strcmp(v10, v13) )
      printf(aSuccess, v7);
    else
      printf(aWrong, v7);
  }
  printf(aWrong, v7);
  result = --Stream._cnt;
  if ( Stream._cnt < 0 )
    return _filbuf(&Stream);
  ++Stream._ptr;
  return result;
}
```

这里其实挺清晰的

```
      sprintf(Buffer, "%x", v4);
```

通过 `sprintf` 修改16进制写入 buffer

![image-20260215234409568](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260215234409568.png)

所以我们只需要 转化回 即可

![image-20260215234449604](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260215234449604.png)

算法也不是很难

```c
#include <stdio.h>
#include <string.h>

const char* hex = "437261636b4d654a757374466f7246756e";

int main() {
    char str[80];
    int len = strlen(hex) / 2;

    for (int i = 0; i < len; i++) {
        sscanf_s(hex + 2 * i, "%2hhx", &str[i]);
    }
    str[len] = '\0';
    printf("%s\n", str);
    return 0;
}

```

https://www.runoob.com/cprogramming/c-function-sscanf.html


没有壳

![image-20260217213112359](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260217213112359.png)

直接IDA分析

```c
int __cdecl main(int argc, const char **argv, const char **envp)
{
  int v3; // edx
  char *v4; // esi
  char v5; // al
  unsigned int i; // edx
  int v7; // eax
  char Arglist[16]; // [esp+2h] [ebp-24h] BYREF
  __int64 v10; // [esp+12h] [ebp-14h] BYREF
  int v11; // [esp+1Ah] [ebp-Ch]
  __int16 v12; // [esp+1Eh] [ebp-8h]

  printf(Format);
  v11 = 0;
  v12 = 0;
  *(_OWORD *)Arglist = 0LL;
  v10 = 0LL;
  scanf("%s", (char)Arglist);
  if ( strlen(Arglist) == 24 )
  {
    v3 = 0;
    v4 = (char *)&v10 + 7;
    do
    {
      v5 = *v4--;
      byte_40336C[v3++] = v5;
    }
    while ( v3 < 24 );
    for ( i = 0; i < 0x18; ++i )
      byte_40336C[i] = (byte_40336C[i] + 1) ^ 6;
    v7 = strcmp(byte_40336C, aXircjR2twsv3pt);
    if ( v7 )
      v7 = v7 < 0 ? -1 : 1;
    if ( !v7 )
    {
      printf("right\n");
      system("pause");
    }
  }
  return 0;
}
```

直接依据算法写出逆向算法即可

算法还是简单

```c
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

uint8_t data[] = "xIrCj~<r|2tWsv3PtI\x7Fzndka";
uint8_t flag[] = { 0 };
int main() {
    for (uint32_t i = 0; i < 0x18; ++i)
        flag[i] = (data[i]  ^ 6) -1;

    char* flag_str = _strrev((char*)flag);
    printf("%s", flag_str);
    return 1;
}



```

但是这里还是需要分析一下啊

```
  if ( strlen(Arglist) == 24 )
  {
    v3 = 0;
    v4 = (char *)&v10 + 7;
    do
    {
      v5 = *v4--;
      byte_40336C[v3++] = v5;
    }
    while ( v3 < 24 );
```

`0LL`是 0（long long 常量） 也就是清零操作

这里需要分析一下堆栈

```
__int64 v10; // [esp+12h] [ebp-14h]
```

存储在 `ebp-14h` 处 `v4`取这个地址 +7 变为了 `ebp-7h`

```
char Arglist[16]; // [esp+2h] [ebp-24h] BYREF
```

这里我们知道 数组结尾是 `ebp-24h + 16h` = `ebp-8` 

那么v4就是我们输入的最后一个字符了

这里代码需要修改为 `for`

```
uint8_t v10 = 0LL;
v4 = (char *)&v10 + 7;
for(int v3 =0 ;v3 < 24;v3++)}{
	v5 = *v4--;
	byte_40336C[v3++] = v5;
}
```

很清晰就是 逆置算法了 逆置完存入 `byte_40336C`

`flag{xNqU4otPq3ys9wkDsN}`

![image-20260217220514736](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260217220514736.png)

IDA分析

首先逆向分析一下输入的`key`

```
BOOL __cdecl check_key(int a1)
{
  int i; // [esp+8h] [ebp-8h]
  int v3; // [esp+Ch] [ebp-4h]

  v3 = 0;
  for ( i = 0; i <= 4; ++i )
    v3 += *(_DWORD *)(4 * i + a1);
  return v3 == 0xDEADBEEF;
}
```


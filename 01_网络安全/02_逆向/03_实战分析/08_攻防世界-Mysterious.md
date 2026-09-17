![image-20260216053420311](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260216053420311.png)

直接IDA分析

```c
int __stdcall DialogFunc_0(HWND hWnd, int a2, int a3, int a4)
{
  int v4; // eax
  char Source[260]; // [esp+50h] [ebp-310h] BYREF
  _BYTE Text[257]; // [esp+154h] [ebp-20Ch] BYREF
  __int16 v8; // [esp+255h] [ebp-10Bh]
  char v9; // [esp+257h] [ebp-109h]
  int Value; // [esp+258h] [ebp-108h]
  CHAR String[260]; // [esp+25Ch] [ebp-104h] BYREF

  memset(String, 0, sizeof(String));
  Value = 0;
  if ( a2 == 16 )
  {
    DestroyWindow(hWnd);
    PostQuitMessage(0);
  }
  else if ( a2 == 273 )
  {
    if ( a3 == 1000 )
    {
      GetDlgItemTextA(hWnd, 1002, String, 260);
      strlen(String);
      if ( strlen(String) > 6 )
        ExitProcess(0);
      v4 = atoi(String);
      Value = v4 + 1;
      if ( v4 == 122 && String[3] == 'x' && String[5] == 'z' && String[4] == 'y' )
      {
        strcpy(Text, "flag");
        memset(&Text[5], 0, 0xFCu);
        v8 = 0;
        v9 = 0;
        _itoa(Value, Source, 10);
        strcat(Text, "{");
        strcat(Text, Source);
        strcat(Text, "_");
        strcat(Text, "Buff3r_0v3rf|0w");
        strcat(Text, "}");
        MessageBoxA(0, Text, "well done", 0);
      }
      SetTimer(hWnd, 1u, 0x3E8u, TimerFunc);
    }
    if ( a3 == 1001 )
      KillTimer(hWnd, 1u);
  }
  return 0;
}
```

结构清晰

转化为字符串

```
v4 = atoi(String);
```

需要通过下面的匹配

```
if ( v4 == 122 && String[3] == 'x' && String[5] == 'z' && String[4] == 'y' )
```

输出下面的flag

```
        _itoa(Value, Source, 10);
        strcat(Text, "{");
        strcat(Text, Source);
        strcat(Text, "_");
        strcat(Text, "Buff3r_0v3rf|0w");
        strcat(Text, "}");
        MessageBoxA(0, Text, "well done", 0);
```

那么通过动调或者其他方法 flag就可以直接出现 主要是

```
        strcat(Text, Source);
```

需要确定 也就是` 123`

```
flag{123_Buff3r_0v3rf|0w}
```


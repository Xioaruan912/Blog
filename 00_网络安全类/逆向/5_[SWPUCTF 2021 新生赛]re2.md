# [SWPUCTF 2021 新生赛]re2

```cobol
int __cdecl main(int argc, const char **argv, const char **envp)
{
  char Str2[64]; // [rsp+20h] [rbp-90h] BYREF
  char Str[68]; // [rsp+60h] [rbp-50h] BYREF
  int v7; // [rsp+A8h] [rbp-8h]
  int i; // [rsp+ACh] [rbp-4h]
 
  _main();
  strcpy(Str2, "ylqq]aycqyp{");
  printf(&Format);
  gets(Str);
  v7 = strlen(Str);
  for ( i = 0; i < v7; ++i )
  {
    if ( (Str[i] <= 96 || Str[i] > 98) && (Str[i] <= 64 || Str[i] > 66) )
      Str[i] -= 2;
    else
      Str[i] += 24;
  }
  if ( strcmp(Str, Str2) )
    printf(&byte_404024);
  else
    printf(aBingo);
  system("pause");
  return 0;
}
```

获取到反汇编的内容

已经发现了简单的逆向

我们对此进行逆向即可

开始分析

```cobol
  for ( i = 0; i < v7; ++i )
  {
    if ( (Str[i] <= 96 || Str[i] > 98) && (Str[i] <= 64 || Str[i] > 66) )
      Str[i] -= 2;
    else
      Str[i] += 24;
  }
 
 
这里是通过v7 v7 是长度 所以python中直接写  for i in str2 即可
 
然后这里我们需要匹配 小于 96 或大于 98 就 -2
 
逆向的话 我们就需要站在已经是-2  如何回去的方向看
 
这里是     小于94 或 大于 96  我们就+2 那么这里不就将 i的值 逆向回去了
 
所以这里的脚本很好写
 
```

EXP

```cobol
str2= "ylqq]aycqyp{"
flag =''
for i in str2:
    if (ord(i)<= 94 or ord(i)>96) and (ord(i) <= 62 or ord(i) > 64):
        flag  +=chr(ord(i)+2)
    else:
        flag += chr(ord(i)-24)
print(flag)
```

输出为

```undefined
{nss_c{es{r}
```

但是这里应该是{ ----> a

所以内容是

```undefined
{nss_caesar}
```
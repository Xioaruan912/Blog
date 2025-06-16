# [SWPUCTF 2021 新生赛]re1

上ida分析

```cobol
int __cdecl main(int argc, const char **argv, const char **envp)
{
  char Str2[1008]; // [rsp+20h] [rbp-60h] BYREF
  char Str1[1000]; // [rsp+410h] [rbp+390h] BYREF
  int i; // [rsp+7FCh] [rbp+77Ch]
 
  _main();
  strcpy(Str2, "{34sy_r3v3rs3}");
  printf("please put your flag:");
  scanf("%s", Str1);
  for ( i = 0; i <= 665; ++i )
  {
    if ( Str1[i] == 101 )
      Str1[i] = 51;
  }
  for ( i = 0; i <= 665; ++i )
  {
    if ( Str1[i] == 97 )
      Str1[i] = 52;
  }
  if ( strcmp(Str1, Str2) )
    printf("you are wrong,see again!");
  else
    printf("you are right!");
  system("pause");
  return 0;
}
```

这里可以发现 对我们的输入进行了两次操作

```cobol
  for ( i = 0; i <= 665; ++i )
  {
    if ( Str1[i] == 101 )
      Str1[i] = 51;
  }
  for ( i = 0; i <= 665; ++i )
  {
    if ( Str1[i] == 97 )
      Str1[i] = 52;
  }
```

并且操作完的内容需要和Str2相同

```cpp
  strcpy(Str2, "{34sy_r3v3rs3}");
```

感觉挺简单的 就是替换

```cobol
101 是 e
 
51 是 3
 
97 是 a
 
52 是 4
```

```cobol
Str2 = '{34sy_r3v3rs3}'
 
flag = Str2.replace('3','e').replace('4','a')
 
print(flag)
```
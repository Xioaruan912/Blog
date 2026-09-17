# HTML的学习

知己知彼百战不殆

打算学习一下javascript

所以先从基础的html语言开始

其实就是头部 和身体



头部控制整个 html的语言 title等

```cobol
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>学习测试一下网站解法</title>
</head>
```

然后就是body



```cobol
<body>
    <h1> 我需要学会html语言基本 </h1>
    <h2> 基础的东西我也要会</h2>
    <p>  段落和标题的区别
        就是这个 其实我就是正文 </p>
    <p> 不同段落需要 重新获取p标签</p>
    <a href="http://47.115.211.64:8000/login">这是一个木马链接</a>
    <img src="帅照.jpg" width=1280  height="100"    alt="网速太慢">
</body>
</html>
```

这里有

```less
h标签 ： 标题
 
p标签 ： 段落
 
a标签 : 跳转
 
img标签 ： 导入图片
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/bb8f846bee90658fd2dc412580961ecb.png" alt="" style="max-height:383px; box-sizing:content-box;" />


内容就是如图所示

HTML 标签对大小写不敏感 所以 <P> = <p>

HTML属性

其实就是可以附加东西的标签

如果我们想对文本进行操作

```cobol
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>菜鸟教程(runoob.com)</title>
</head>
 
<body>
 
<b>这个文本是加粗的</b>
 
<br />
 
<strong>这个文本是加粗的</strong>
 
<br />
 
<big>这个文本字体放大</big>
 
<br />
 
<em>这个文本是斜体的</em>
 
<br />
 
<i>这个文本是斜体的</i>
 
<br />
 
<small>这个文本是缩小的</small>
 
<br />
 
这个文本包含
<sub>下标</sub>
 
<br />
 
这个文本包含
<sup>上标</sup>
 
</body>
</html>
```

a标签的属性

```cobol
href：url地址
 
target ：  _blank  _self  从本页面跳转 还是从新开一个页面跳转
```

这里可以通过嵌套的方式将图片设置为跳转

```cobol
    <a href="http://47.115.211.64:8000/login" ><img src="帅照.jpg" alt=""></a>
```

然后我们通过点击图片就可以进行跳转了

这里还有一个锚点

```xml
<a href="#section2">跳转到第二部分</a>
<!-- 在页面中的某个位置 -->
<a name="section2"></a>
```

通过点击 就可以进入到 下面那个a标签所在的位置

如果是想下载 指定download即可

id属性

```cobol
id 属性可用于创建一个 HTML 文档书签。
 
提示: 书签不会以任何特殊方式显示，即在 HTML 页面中是不显示的，所以对于读者来说是隐藏的。
实例
 
在HTML文档中插入ID:
 
<a id="tips">有用的提示部分</a>
 
在HTML文档中创建一个链接到"有用的提示部分(id="tips"）"：
 
<a href="#tips">访问有用的提示部分</a>
 
或者，从另一个页面创建一个链接到"有用的提示部分(id="tips"）"：
 
<a href="https://www.runoob.com/html/html-links.html#tips">
访问有用的提示部分</a>
```

我觉得写的很好了 菜鸟教程 就是 通过一个占位符 然后可以通过a标签 访问占位符

头标签

这里介绍一下 link 就是用于链接外部资源

介绍一下html设置表格

```cobol
<p> 这里介绍一下表格</p>
 
 <table border="12">
    <thead>
        <tr>
            <th> id</th>
            <th> name</th>
            <th> passwd</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td> 1</td>
            <td> admin</td>
            <td> admin123</td>
        </tr>
 
    </tbody>
 </table>       
 <p> 这里介绍一下列表</p>
 <ul>
    <li>1111111:</li>
    <li>2222222:</li>
 </ul>
 
</body>
</html>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b76f1d4cc7cdaf6790ecb18c64043a3e.png" alt="" style="max-height:194px; box-sizing:content-box;" />




div的布局

```cobol
<div id="menu" style="background-color:#FFD700;height:200px;width:100px;float:left;">
<b>菜单</b><br>
HTML<br>
CSS<br>
JavaScript</div>
 
<div id="content" style="background-color:#EEEEEE;height:200px;width:400px;float:left;">
内容在这里</div>
 
<div id="footer" style="background-color:#FFA500;clear:both;text-align:center;">
版权 © runoob.com</div>
```

这里我们其实运行后可以发现 就是通过 <div id="名字" style 中的style进行布局控制



## ★★HTML的表单

这个要好好看一下

是参数传递的功能

```undefined
表单是收集用户信息
```

```cobol
<form> 是创建表单的 参数包括 action: 提交的url  method:提交的方式 POST/GET/PUT等
 
 
<input> 创建文本框  type 定义输入框类型  id 用于关联 table 元素
 
name 用于标识
```

```cobol
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登入界面</title>
</head>
<body>
    <form action="/test-web/dir.php" method="post">
        <label for="name">用户名：</label>
        <input type="text" name="name" id="name" required>
 
        <br>
 
        <label for="passwd">密码:</label>
        <input type="password" name="passwd" id="passwd" required>
 
        <br>
 
        <input type="submit" value="提交">
    </form>
    
</body>
</html>
```

最基本的写法

差不多会了 写个登入查询是否存在用户的网站吧

index.html

```cobol
<<!DOCTYPE html>
<html lang="en">
<!---flag{fuc3-yo3}-->
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>学习测试一下网站解法</title>
</head>
<body>
    <h1> 我需要学会html语言基本 </h1>
    <hr>
    <h2> 基础的东西我也要会</h2>
    <p>  段落和标题的区别
        就是这个 其实我就是正文 </p>
        <hr>
    <p> 不同段落需要 重新获取p标签</p>
    <a href="帅照.jpg" download>下载帅照</a>
    <p>这是一个段落标签<br>但是我使用br分段</p>
 
 
<p> 这里介绍一下表格</p>
 
 <table border="12">
    <thead>
        <tr>
            <th> id</th>
            <th> name</th>
            <th> passwd</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td> 1</td>
            <td> admin</td>
            <td> admin123</td>
        </tr>
 
    </tbody>
 </table>       
 <p> 这里介绍一下列表</p>
 <ul>
    <li>1111111:</li>
    <li>2222222:</li>
 </ul>
 <form action="/test-web/dir.php" method="post"> 
    <label for="name">用户名</label>
    <input type="text" name="name" id="name">
    <br>
    <label for="passwd">密码:</label>
    <input type="password" name="passwd" id="passwd">
    <br>
    <input type="submit" value="提交">
    <a href="http://127.0.0.1:3000/zhuce.php">注册</a>
</form>
 
</body>
</html>
```

dir.php

```php
<?php
// highlight_file(__FILE__);	
$m = new MongoDB\Driver\Manager("mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb");
$name = $_POST['name'];
$passwd = $_POST['passwd'];
$id = $_POST['id'];
if(!$id){
	$query = new MongoDB\Driver\Query(['name'=>$name,'password'=>$passwd]);
 
	$res = $m -> executeQuery('test.admin',$query)->toArray();
 
	$count = count($res);
	// $queryString = json_encode($res);
	// echo '查询结果: ' . $queryString . '<br>';
	if($count>0){
		foreach($res as $a){
			$a = (array)$a;
			echo '====Login Success====<br>';
			echo 'username: ' . $a['name'] . '<br>'; 
		}
	}else{
		echo '<script>alert("账号密码错误"); window.location="index.html";</script>';
	}
}else{
$bulk = new MongoDB\Driver\BulkWrite();
 
// 创建要插入的文档
$document = [
    '_id' => new MongoDB\BSON\ObjectID(),
    'id' => $id,
    'name' => $name,
    'password' => $passwd
];
 
// 添加插入操作
$bulk->insert($document);
 
// 指定数据库和集合名称
$database = 'test';
$collection = 'admin';
 
// 执行写入操作
$writeConcern = new MongoDB\Driver\WriteConcern(MongoDB\Driver\WriteConcern::MAJORITY, 1000);
$result = $m->executeBulkWrite("$database.$collection", $bulk, $writeConcern);
 
if ($result->getInsertedCount() > 0) {
    echo "注册成功";
} else {
    echo "注册失败";
}
}
```

zhuce.php

```cobol
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册界面</title>
</head>
<body>
    <form action="/test-web/dir.php" method="post">
        <label for="id">ID值</label>
        <input type="id" name="id" id='id'>
        <br>
        <label for="name">用户名</label>
        <input type="text" name='name' id ='name'>
        <br>
        <label for="passwd">密码</label>
        <input type="password" name="passwd" id="passwd">
        <input type="submit" value="注册">
        <a href="http://127.0.0.1:3000/index.html">返回</a>
    </form>
    
</body>
</html>
```

最基本的查询网站 加入了注册界面
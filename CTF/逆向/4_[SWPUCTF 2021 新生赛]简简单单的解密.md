# [SWPUCTF 2021 新生赛]简简单单的解密

代码看着很慌张

```cobol
import base64,urllib.parse
key = "HereIsFlagggg"
flag = "xxxxxxxxxxxxxxxxxxx"
 
s_box = list(range(256))
j = 0
for i in range(256):
    j = (j + s_box[i] + ord(key[i % len(key)])) % 256
    s_box[i], s_box[j] = s_box[j], s_box[i]
res = []
i = j = 0
for s in flag:
    i = (i + 1) % 256
    j = (j + s_box[i]) % 256
    s_box[i], s_box[j] = s_box[j], s_box[i]
    t = (s_box[i] + s_box[j]) % 256
    k = s_box[t]
    res.append(chr(ord(s) ^ k))
cipher = "".join(res)
crypt = (str(base64.b64encode(cipher.encode('utf-8')), 'utf-8'))
enc = str(base64.b64decode(crypt),'utf-8')
enc = urllib.parse.quote(enc)
print(enc)
# enc = %C2%A6n%C2%87Y%1Ag%3F%C2%A01.%C2%9C%C3%B7%C3%8A%02%C3%80%C2%92W%C3%8C%C3%BA
```

乱七八糟密密麻麻，但是其实自习看 就能看出门道来

首先看我们最后的输出 来决定逆向的第一步

```cobol
crypt = (str(base64.b64encode(cipher.encode('utf-8')), 'utf-8'))
enc = str(base64.b64decode(crypt),'utf-8')
enc = urllib.parse.quote(enc)
print(enc)
 
 
这里我们发现 url加密 并且 解密 然后加密 （这里base64是误导的 所以没用）
 
 
所以其实这里 enc的urldecode 就已经是 cipher
 
然后我们看看flag的处理
 
for s in flag:
    i = (i + 1) % 256
    j = (j + s_box[i]) % 256
    s_box[i], s_box[j] = s_box[j], s_box[i]
    t = (s_box[i] + s_box[j]) % 256
    k = s_box[t]
    res.append(chr(ord(s) ^ k))
cipher = "".join(res)
 
这里是对flag的处理 s_box我们其实不用管 没有变量 所以输出肯定是恒定的
 
然后我们发现 其实这里面我们不知道的 就是 flag-->s
 
并且对s的处理 只有
 
    res.append(chr(ord(s) ^ k))
 
异或的逆向就是异或 所以我们直接将flag修改为 crypt即可获得flag
```

```cobol
import base64
import urllib.parse
enc = "%C2%A6n%C2%87Y%1Ag%3F%C2%A01.%C2%9C%C3%B7%C3%8A%02%C3%80%C2%92W%C3%8C%C3%BA"
key = "HereIsFlagggg"
flag =''
crypt = urllib.parse.unquote(enc)
s_box = list(range(256))
j = 0
for i in range(256):
    j = (j + s_box[i] + ord(key[i % len(key)])) % 256
    s_box[i], s_box[j] = s_box[j], s_box[i]
res = []
i = j = 0
 
for s in crypt:
    i = (i + 1) % 256
    j = (j + s_box[i]) % 256
    s_box[i], s_box[j] = s_box[j], s_box[i]
    t = (s_box[i] + s_box[j]) % 256
    k = s_box[t]
    res.append(chr(ord(s) ^ k))
flag   = "".join(res)
print(flag)
```
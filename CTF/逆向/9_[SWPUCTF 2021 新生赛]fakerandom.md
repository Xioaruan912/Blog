# [SWPUCTF 2021 新生赛]fakerandom

分析代码

```cobol
import random
flag = 'xxxxxxxxxxxxxxxxxxxx'
random.seed(1)
l = []
for i in range(4):
    l.append(random.getrandbits(8))
result=[]
for i in range(len(l)):
    random.seed(l[i])
    for n in range(5):
        result.append(ord(flag[i*5+n])^random.getrandbits(8))
print(result)
# result = [201, 8, 198, 68, 131, 152, 186, 136, 13, 130, 190, 112, 251, 93, 212, 1, 31, 214, 116, 244]
 
伪随机 然后 处理是在
 
        result.append(ord(flag[i*5+n])^random.getrandbits(8))
 
所以我们关注这里就行了 这里是对flag的 第 i*5+n位进行异或
 
那么只是对单个单个位子进行操作
 
所以我们可以原封不动的逆向
```

EXP

```cobol
import random
result = [201, 8, 198, 68, 131, 152, 186, 136, 13, 130, 190, 112, 251, 93, 212, 1, 31, 214, 116, 244]
random.seed(1)
l = []
flag = ''
for i in range(4):
    l.append(random.getrandbits(8))
for i in range(len(l)):
    random.seed(l[i])
    for n in range(5):
        flag += chr(result[i*5+n]^random.getrandbits(8))
print(flag)
```
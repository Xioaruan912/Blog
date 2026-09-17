# [SWPUCTF 2021 新生赛]简简单单的逻辑-- 算法逆向

```cobol
flag = 'xxxxxxxxxxxxxxxxxx'
list = [47, 138, 127, 57, 117, 188, 51, 143, 17, 84, 42, 135, 76, 105, 28, 169, 25]
result = ''
for i in range(len(list)):
    key = (list[i]>>4)+((list[i] & 0xf)<<4)
    result += str(hex(ord(flag[i])^key))[2:].zfill(2)
print(result)
# result=bcfba4d0038d48bd4b00f82796d393dfec
```

这里提示我们如果存在flag后result的内容是注释掉的

这里我们直接反着写即可

### 代码解释

```cobol
result += str(hex(ord(flag[i])^key))[2:].zfill(2)
 
我们来读懂这个代码
 
首先是 通过 ord 将字符串变为 十进制的ascii值 并且异或
 
然后再通过 hex()[2:]  将十进制的ascii 变为十六进制
 
然后 如果长度没达到2 就用0 在左边补齐
 
然后通过chr 将字符组合为字符串
 
 
我们逆向如何逆向呢
 
首先我们可以将现在的十六进制字符串 变为 ascii 十进制  这里我们使用 int(x,16)
 
会将 x 转换为一个 10进制的整数 
 
但是这里有一个问题 我们result 是一串字符串 所以我们需要切片操作 并且 并且是按照 2个2个出现
 
所以这里我们使用 [2*i:2*i+2] 进行操作
 
int(result[2*i:2*i+2],16)
 
然后对内容进行异或操作
 
这个时候我们就已经获取到了ascii的 flag 最后通过chr函数将ascii变为ascii值
```

### EXP

```cobol
list = [47, 138, 127, 57, 117, 188, 51, 143, 17, 84, 42, 135, 76, 105, 28, 169, 25]
flag =''
result = 'bcfba4d0038d48bd4b00f82796d393dfec'
for i in range(len(list)):
    key = (list[i] >> 4) + ((list[i] & 0xf) << 4)
    flag += chr(int(result[2*i:2*i+2],16)^key)
print(flag)
```

### 具体解释一下

```cobol
key = (list[i]>>4)+((list[i] & 0xf)<<4)

具体解释一下key的生成
 
 
首先是对(list[i]>>4) 的解释

这里是获取 list的第i个值 并且 >>4

>>4是什么呢

 
我们举例子 i = 0  list[i]=47
 
47>>4是什么呢

我们先将 47转换为二进制数   00101111
 
然后将高位向右移动 4 为 就是 00101111  -----> 00000010  = 10
 
然后我们再分析((list[i] & 0xf)<<4)
 
首先一样的    (47 & 0xf) 这是什么呢
 
00101111  &  00001111  这两个数进行与运算 值为  00001111 
 
然后再低位左移 4   变为 1111 0000 =240
 
所以加起来 242
 
 
 
```

我们查看动态分析看看是不是正确的



<img src="https://i-blog.csdnimg.cn/blog_migrate/276302b28d27955ef9ec6e625f0a2dbb.png" alt="" style="max-height:128px; box-sizing:content-box;" />


确实是这样 这样 这道题就分析完了
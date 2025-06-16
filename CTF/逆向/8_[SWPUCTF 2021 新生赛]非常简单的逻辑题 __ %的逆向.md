# [SWPUCTF 2021 新生赛]非常简单的逻辑题 // %的逆向

代码解密题

```cobol
flag = 'xxxxxxxxxxxxxxxxxxxxx'
s = 'wesyvbniazxchjko1973652048@$+-&*<>'
result = ''
for i in range(len(flag)):
    s1 = ord(flag[i])//17
    s2 = ord(flag[i])%17
    result += s[(s1+i)%34]+s[-(s2+i+1)%34]
print(result)
# result = 'v0b9n1nkajz@j0c4jjo3oi1h1i937b395i5y5e0e$i'
```

这道题 看大家都是通过一个 爆破的方式来做的

我第一次没想到这个要咋整 看了wp发现 爆破确实ok

这里解释一下命令

```cobol
for i in range(len(flag)):
    s1 = ord(flag[i])//17
    s2 = ord(flag[i])%17
    result += s[(s1+i)%34]+s[-(s2+i+1)%34]
 
 
先查看加密的方法 
 
首先根据flag的长度 获取i
 
然后 将 flag的i位 分别 // 和 % 一个地板除 一个取余数
 
然后result的取证 是两个 s 字符串相加 
 
并且 第一个 s 是通过 (s1+i)%34 第二个 s 是通过-(s2+i+1)%34 两个获得 s的位数
```

分析完这个后 我们思考一下如何爆破

```cobol
s = 'wesyvbniazxchjko1973652048@$+-&*<>'
result = 'v0b9n1nkajz@j0c4jjo3oi1h1i937b395i5y5e0e$i'
flag = ''
for i in range(len(result)//2):
    for j in range(33,125):
        s1 = j//17
        s2 = j%17
        a=(s1+i)%34
        b=-(s2+i+1)%34
        if (result[2 * i] == s[a] and result[2 * i + 1] == s[b]):
            flag += chr(j)
            break
    print(flag)
```

我们来解释一下

```cobol
首先 len()//2 的原因是 result= s[x]+s[y]
 
所以是2倍长 我们需要//2
 
其次for i in range(32,128)是在ascii a-z1-9进行爆破
 
s1 s2 我们通过爆破的方式确定
 
然后a b 就是s的位数
 
最后通过 result 进行比对 [2*i ] 也是因为其中存在2位
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/6f139083e38b7619b501b2d764c42096.png" alt="" style="max-height:475px; box-sizing:content-box;" />


这里就知道了 因为是2个2个加的 所以我们比对 也需要 *2

如果第一位和第二位都和 result一样 那么这个时候 取的flag[i] 也就符合flag的值了
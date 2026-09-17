SHA系列包括 `SHA1` `SHA2` `SHA3`

特点

1. 不可逆
2. 位数唯一

- **SHA-1**：40 位（十六进制字符数）
- **SHA-256**：64 位
- **SHA-512**：128 位
- **SHA3-512**：128 位
- **SHA3-384**：96 位
- **SHA3-256**：64 位
- **SHA3-224**：56 位

可以通过位数判断算法

# SHA使用

```js
const Crypto = require('crypto-js')

function sha1(text) {
    return Crypto.SHA1(text).toString()
};

console.log(sha1('12312313'))
```

# 混合哈希的实战 SHA+MD5

`https://www.cls.cn/depth?id=1000`

![image-20260110214429304](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260110214429304.png)

找到要分析的包 这里主要内容就是 sign分析一下

![image-20260110215000331](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260110215000331.png)

下断点发现自己会断住 并且值就是 sign的内容 所以这里开始分析

r是一个 object 作为参数传入 a中

跟入p

![image-20260110215744964](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260110215744964.png)

看这个算法

![image-20260110215753263](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260110215753263.png)

可以发现就是 把object的内容 变为一个字符串 然后进行 sync操作 我们看看是什么

![image-20260110215837129](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260110215837129.png)

可以很清晰的发现是 SHA1 我们尝试加密看看

```js
const Crypto = require('crypto-js')

function sha1(text) {
    return Crypto.SHA1(text).toString()
}

console.log(sha1('app=CailianpressWeb&hasFirstVipArticle=1&lastTime=1768053297&os=web&rn=20&subscribedColumnIds=&sv=8.4.6'))
```

结果是：

```
5eb0314bac687910262f978a5080f9034457b29d
```

最后经过一个 `t = o(t)`

输出一个32位的我们猜测是 md5 所以尝试一下

![image-20260110220632321](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260110220632321.png)

答案是正确的 就是SHA 后 MD5加密 得到结果

# 实战2 SHA1+salt

`https://aerfaying.com/`

```
console.log("b0661d22276577acc4284315a30fad5bb12b4bcf".length)
```

40位 猜测是SHA1

这里可以发现 这里的 名字就是单一名字 不好搜索 所以我们通过

启动器看看 能不能获取

![image-20260111093529538](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260111093529538.png)

首先进入 send函数看看

![image-20260111093609927](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260111093609927.png)

可以发现 这个时候已经构建完毕数据了

继续跟栈 可以发现：



![image-20260111094453569](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260111094453569.png)

可以发现这里就生成了内容

![image-20260111094834666](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260111094834666.png)

进入函数内部

![image-20260111095108175](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260111095108175.png)

可以发现又拼接了 时间戳

这样我们算法就直接逆出来了

```
sha1(路径?username=xx&password=xxx盐值&&时间戳=)
"/WebApi/Users/Login?username=admin&password=123123123DUE$DEHFYE(YRUEHD*&&t=1770688276337"
```

![image-20260111095504841](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260111095504841.png)

到此结束

# 实战3

`https://v.6.cn/channel/index.php`

测试登入逆向

![image-20260111100542354](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260111100542354.png)

看看长度

40位 可以判断是不是 sha1

我这里查找其他关键字 例如 `servertime`

![image-20260111100819712](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260111100819712.png)

一下就看到了 这里直接断点看看

```
            encode: function(e) {
                return this.hex_sha1(e)
            },
```

可以看到 这个加密就是sha1

![image-20260111101122507](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260111101122507.png)

一下就逆向出来了 

但是我们发现 `nonce`每次都会改变 所以我们也要看看这个怎么出来的

![image-20260111101211130](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260111101211130.png)

本文件搜索一下 `nonce `可以发现有一个 `createnonce`

![image-20260111101306187](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260111101306187.png)

但是我们发现一直断不住 所以根本没有使用这个函数 所以不是这里 我们回去数据报可以看到 有一个 `prelogin`

![image-20260111102019377](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260111102019377.png)

里面的返回值就是这个 到此结束
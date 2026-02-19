HMAC是用于 身份验证和数据完整性的保护

1. 需要一个 `KEY `的哈希算法
2. 通过 哈希函数 例如 SHA 然后内容+KEY 计算出来

与加盐不同 ： 加盐是 字符串 后面添加一个 动态或者静态的 字符串 从而计算出不同内容

# 用法

```js
const Crypto = require('crypto-js')

const key = '123456';
function sha1(text) {
    return Crypto.HmacMD5(text, key).toString()
};

console.log(sha1('12312313'))
```

# 实战

`https:/qcc.com`

![image-20260113105420428](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260113105420428.png)

128位 猜测是 SHA-256

可以发现 不只是 内容加密 名字也是加密的

 ![image-20260113105543598](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260113105543598.png)

这里对于header有关键字

`header`,`headers:`,`header[`,`headers[`

![image-20260113105744588](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260113105744588.png)

先下一个断点看看

![image-20260113105805318](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260113105805318.png)

可以发现断住了 这里就可以继续分析

![image-20260113105820694](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260113105820694.png)

与请求包里的内容一样的

```js

const CryptoJS = require("crypto-js");

function Hmac(text, key) {
    return CryptoJS.HmacSHA512(text, key).toString();
}


const a = {
    default: {
        n: 20,
        codes: {
            0: "W",
            1: "l",
            2: "k",
            3: "B",
            4: "Q",
            5: "g",
            6: "f",
            7: "i",
            8: "i",
            9: "r",
            10: "v",
            11: "6",
            12: "A",
            13: "K",
            14: "N",
            15: "k",
            16: "4",
            17: "L",
            18: "1",
            19: "8"
        }
    }
};
neiceng = function () {
    for (var e = (arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : "/").toLowerCase(), t = e + e, n = "", i = 0; i < t.length; ++i) {
        var o = t[i].charCodeAt() % a.default.n;
        n += a.default.codes[o]
    }
    return n
}
waiceng = function (e, t) {
    return Hmac(e, t).toString()
}

const t = '/api/home/getnewsflash?firstrankindex=&lastrankindex=1768309697101&lastranktime=1768309697101&pagesize=10'
const n = '{}'
var jiami = waiceng(t + n, neiceng(t)).toString()
var res = jiami.toLowerCase().substr(8, 20)
console.log(res)

```

头部的逆向分析 结束 加密内容 就是一样的过程
只是混淆不同

`window,tid`和`n + "pathString" + i + t,o.default(n)`

这里就不再分析了
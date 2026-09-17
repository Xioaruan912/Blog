# AES的特点

1. 也是对称加密算法 用于保护机密性
2. 使用固定长度 加密密钥 128 256位
3. 加密出来的值比DES长
4. AES在硬件和软件上实现 都有良好的条件

参数是和DES一样的

```js
const Crypto = require('crypto-js')

var key = Crypto.enc.Utf8.parse("123123")
var iv = Crypto.enc.Utf8.parse("454545")
var text = Crypto.enc.Utf8.parse("加密内容")

enctext = Crypto.AES.encrypt(text, key, {
    iv: iv,
    mode: Crypto.mode.CBC,
    padding: Crypto.pad.Pkcs7
}).toString()


console.log(enctext)
```

# 实战1

`https://passport2.chaoxing.com/login?fid=&newversion=true&refer=https%3A%2F%2Fi.chaoxing.com`

![image-20260115093332551](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115093332551.png)

可以看出可能是 对称加密算法

去启动器找即可

![image-20260115093753969](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115093753969.png)

可以发现AES加密

```js
function encryptByAES(message, key) {
    let CBCOptions = {
        iv: CryptoJS.enc.Utf8.parse(key),
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
    };
    let aeskey = CryptoJS.enc.Utf8.parse(key);
    let secretData = CryptoJS.enc.Utf8.parse(message);
    let encrypted = CryptoJS.AES.encrypt(
        secretData,
        aeskey,
        CBCOptions
    );
    return CryptoJS.enc.Base64.stringify(encrypted.ciphertext);
}
```

就是很标准的 AES加密算法

# 实战2

`https://jzsc.mohurd.gov.cn/data/company`

![image-20260115094205336](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115094205336.png)

## 方法1

直接hook 

因为 这里返回的是一个密文 猜测是 JSON格式 要转为字符串 所以我们 hook `JSON.parse`

```
(function() {
	var parse_ = JSON.parse;
	JSON.parse = function(a){
		console.log(a);
		debugger;
		return parse_(a)
	}})()
```

![image-20260115095113561](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115095113561.png)

断住了 我们需要断到明文位置

![image-20260115095201777](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115095201777.png)

跟栈

![image-20260115095220799](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115095220799.png)

一下就找到了

![image-20260115095339951](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115095339951.png)

## 方法2

XHR断点 我们直接断API 然后查找

`webApi`

![image-20260115095453028](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115095453028.png)

这个时候是发送信息

![image-20260115095512280](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115095512280.png)

跟下去主要找到密文 和 明文 那么解密方法就在这两个内部

![image-20260115095940603](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115095940603.png)

找到密文了

![image-20260115095959219](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115095959219.png)

依旧找到了算法

但是这里有坑 f 不是上面定义的内容

我们复制下来 报错了 并且看 f是在闭包中的 所以我们可以正则找一下

![image-20260115100912981](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115100912981.png)

`\bf\b`

![image-20260115100956600](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115100956600.png)

这里才是真的 位置

# 实战3

`https://cas.hebau.edu.cn/authserver/login`

![image-20260115101135709](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115101135709.png)

![image-20260115101331143](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115101331143.png)

直接搜 貌似都没有分析 就可以直接输入了

我们直接分析一下 算法过程

```js
const CryptoJS = require('crypto-js')


function getAesString(n, f, c) {
    f = f.replace(/(^\s+)|(\s+$)/g, "");
    f = CryptoJS.enc.Utf8.parse(f);
    c = CryptoJS.enc.Utf8.parse(c);
    return CryptoJS.AES.encrypt(n, f, {
        iv: c,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
    }).toString()
}

var $aes_chars = "ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678", aes_chars_len = $aes_chars.length;

function randomString(n) {
    var f = "";
    for (i = 0; i < n; i++)
        f += $aes_chars.charAt(Math.floor(Math.random() * aes_chars_len));
    return f
}

function encryptAES(n, f) {
    return f ? getAesString(randomString(64) + n, f, randomString(16)) : n
}
function encryptPassword(n, f) {

    return encryptAES(n, f)

}

var password = encryptPassword(123456,'ZJXwtou0dOQQmLko');
console.log(password)
```

可以发现 就是随机值 后端他怎么 操作的 我们不需要在意 构造这个请求即可


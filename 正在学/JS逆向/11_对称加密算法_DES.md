直接实战

https://ctbpsp.com/

![image-20260115091746807](../../../../../AppData/Roaming/Typora/typora-user-images/image-20260115091746807.png)

可以尝试一下 hook

```js
(function() {
	var parse_ = JSON.parse;
	JSON.parse = function(a){
		console.log("断住了");
		debugger;
		return parse_(a)
	}})()
```

密文：

![image-20260115091826126](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115091826126.png)

明文：

![image-20260115092329241](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115092329241.png)

跟栈即可

![image-20260115092348527](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115092348527.png)

![image-20260115092355680](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115092355680.png)

一下就找到了 解密的地方

```
        function X(e) {
            var t = x.a.enc.Utf8.parse("1qaz@wsx3e")
              , i = x.a.DES.decrypt({
                ciphertext: x.a.enc.Base64.parse(e)
            }, t, {
                mode: x.a.mode.ECB,
                padding: x.a.pad.Pkcs7
            });
            return i.toString(x.a.enc.Utf8)
        }
```

直接写回即可逆向成功

# 实战2

https://www.91118.com/Passport/Account/Login

![image-20260115092605381](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115092605381.png)

一下就搜到了 DES加密

```js
(function () {
   
var _key = 'k1fsa01v';
var _iv = 'k1fsa01v';
function encryptByDES(message) {
    var keyHex = CryptoJS.enc.Utf8.parse(_key);
    var encrypted = CryptoJS.DES.encrypt(message, keyHex, {
        iv: CryptoJS.enc.Utf8.parse(_iv),
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.Pkcs7
    });
    return encrypted.toString();
```

加密算法直接结束

DES实战就此结束


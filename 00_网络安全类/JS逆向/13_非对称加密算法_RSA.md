非对称加密就是 加密和解密 密钥是不同的

![image-20260116095448686](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260116095448686.png)

1. `公钥`：用于加密 可以交给别人 【直接放在前端】
2. ` 私钥`：用于解密 不可以被外人知道 【放在后端】

主要产生是基于数学问题难以解决 从而保证了 非对称加密算法的安全性

性能比对称加密算法 低一些

# 使用

## 方法1

通过 `git bash` 可以实现生成

```sh
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private_key.pem
openssl pkey -in private_key.pem -pubout -out public_key.pem
```

这样就会生成

安装 `npm i jsencrypt`

```js
globalThis.self = globalThis;
const jsencrypt = require('jsencrypt')
var encrypt = new jsencrypt()
const public_key = `公钥`
const private_key = `私钥`


// 使用公钥进行加密
function encryptMessage(message,public_key){
    encrypt.setPublicKey(public_key)
    return encrypt.encrypt(message)
}


var enc = encryptMessage("123123",public_key)
console.log(enc)


//使用私钥解密

function decryptMessage(message,private_key){
    encrypt.setPrivateKey(private_key)
    return encrypt.decrypt(message)
}

var dec = decryptMessage(enc,private_key)
console.log(dec)
```

## 方法2

安装 `npm i node-forge`

```js
const forge = require('node-forge');

const public_key = `-----BEGIN PUBLIC KEY-----
...你的公钥内容...
-----END PUBLIC KEY-----`;

const private_key = `-----BEGIN PRIVATE KEY-----
...你的私钥内容...
-----END PRIVATE KEY-----`;


function encryptMessage(message, publicKeyPem) {
  const publicKey = forge.pki.publicKeyFromPem(publicKeyPem);
  const bytes = forge.util.encodeUtf8(message);
  const encryptedBytes = publicKey.encrypt(bytes, 'RSAES-PKCS1-V1_5');
  return forge.util.encode64(encryptedBytes); //如果没有base64 可能输出乱码
}

function decryptMessage(cipherBase64, privateKeyPem) {
  const privateKey = forge.pki.privateKeyFromPem(privateKeyPem);

  const encryptedBytes = forge.util.decode64(cipherBase64);
  const decryptedBytes = privateKey.decrypt(encryptedBytes, 'RSAES-PKCS1-V1_5');

  return forge.util.decodeUtf8(decryptedBytes);
}

const enc = encryptMessage("123123", public_key);
console.log("enc(base64) =", enc);

const dec = decryptMessage(enc, private_key);
console.log("dec =", dec);

```

# 实战1

`https://tms.newchinalife.com/ex//app/login/login.jsp`

![image-20260116111604914](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260116111604914.png)

直接定位

![image-20260116111829024](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260116111829024.png)

直接重构算法看看

```js
const JSEncrypt = require('jsencrypt')


var PUBLICKEY="-----BEGIN PUBLIC KEY-----"
+"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqCvtrtBBeP/LIO6VtFAUItx9Dwi9lXRX"
+"sSHT8C9p/yQ9FaUjB8YQTI7FL/HxggTU+P61A3a17GK23Whm4VNkriIDJZVd7opqnGzGC0XAdeml"
+"LCxmutZIypbUEhQmd68pZ+74e6QH2lu/lcukFFSdeI6p5IaWAUgvOjzPGUCZLKuABfhw8LoOmcFW"
+"LgPMQy6BZheKBqiLvFTx5eX9VbzaPCfZsSCxPRXb4snL5QyIbtBppamPW5TkUcGPECMNdbpfbIoX"
+"LBGhcxqrYEGNtXEwu47eOUBLbPPrE0o5KZ7sw3b1LepoxH3MXKpDHcBg1n3jUreE5ZfcNLX1GWKs"
+"eyNQiQIDAQAB"
+"-----END PUBLIC KEY-----";

var RSAClient = function () {
  this.encryptObj = new JSEncrypt();
  this.decryptObj = new JSEncrypt(); 
  this.encryptObj.setPublicKey(PUBLICKEY);
};

RSAClient.prototype.encrypt = function (plainText) {
  return this.encryptObj.encrypt(plainText);
};

var j_pwd = "asdasda";
var client = new RSAClient();
var value = client.encrypt(j_pwd);

console.log(value);

```

这里 构建的 都是随机值 所以每次输出结果都不同

因为 RSA 的 padding会加入 **随机填充字节**

# 实战2

`https://passport.suning.com/ids/login`

直接走启动器 跟`ajax`的栈 就可以找到

![image-20260116120256494](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260116120256494.png)

直接结束了

可以发现 RSA 要验证是否正确 就需 可以正常登录的密码 或者 判断相同长度 密文实现

# 判断方法

如果我们输入一个非常非常长的内容 无法加密 出现报错  那么说明是RSA

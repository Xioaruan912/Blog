# cookie

保存在本地的一块数据 按照域名划分保存

自动将域名下的cookie发送给服务端

可以保证不用再次登入

```
服务器通过 set-cookie 设定cookie
```

# express设置cookie

## 单次销毁

```java
var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.cookie("name","zhangsan") //在浏览器关闭的时候销毁
  res.send('respond with a resource');
});

module.exports = router;

```



这里我们就设置了cookie

## 持久保存

```java
var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.cookie("name","zhangsan",{maxAge:60 * 1000}) //保存一分钟 并且浏览器关闭后不销毁
  res.send('respond with a resource');
});

module.exports = router;

```

# 删除Cookie

```java
var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.cookie("name","zhangsan",{maxAge:60 * 1000}) //保存一分钟 并且浏览器关闭后不销毁
  res.send('respond with a resource');
});

router.get('/remove_cookie',(req,res) => {
  //删除特殊字段cookie
  res.clearCookie('name')
})
module.exports = router;
 
```

# 读取cookie

安装cookie-parser

```
npm i cookie-parser
```

```java
var express = require('express');
var router = express.Router();
var cookieParser = require('cookie-parser');
app.use(cookieParser());
/* GET users listing. */
router.get('/', function(req, res, next) {
  res.cookie("name","zhangsan",{maxAge:60 * 1000}) //保存一分钟 并且浏览器关闭后不销毁
  res.send('respond with a resource');
});

router.get('/remove_cookie',(req,res) => {
  //删除特殊字段cookie
  res.clearCookie('name')
})

router.get('/get_cookie',(req,res) => {
  //获取cookie
  console.log(req.cookies)
  req.send("OOk")
})

module.exports = router;
 
```


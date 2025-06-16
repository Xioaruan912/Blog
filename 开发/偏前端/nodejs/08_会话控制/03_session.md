session是保存在服务端的信息 用于保存用户信息

通过cookie的方式传递回浏览器

通过session就可以保持用户登入，通过比对session就可以保持访问控制 

# express-session

我们需要session写入数据库

```
npm i express-session connect-mongo
```

引入包

```
const session = require('express-session')
const MongoStore = require('connect-mongo')
```

### 设置中间件

```javascript
app.use(session({
    name:'sid',  //设置cookid 的字段名字 可灵活
    secret:'abcdefght', //盐
    saveUninitialized:false,  //是否对所有请求都发送session
    resave:true, //每次都请求重新保存session
    store:MongoStore.create({
      mongoUrl:"mongodb://xxxxx:xxxxxx@xxxxx:27017/session?authSource=admin"
    }),
    cookie:{
      httpOnly:true,   //开启后前端无法访问cookie
      maxAge:1000 * 60 //60分钟
    }
}))
```

# 设置session

```java
var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  req.session.username = 'admin'
  res.render('index', { title: 'Express' });
});

module.exports = router;

```

# 读取session

```java
router.get('/cart', function(req, res, next) {
  if(req.session.username){
    res.render('index', { title: '登入成功！！！' });
  }else{
    res.render('index', { title: '登入失败' });
  }

});
```

# 销毁session

```
router.get('/logout', function(req, res, next) {
  req.session.destroy()
});
```


```
npm i -g express-generator
```

```
express
```

即可快速生成

![image-20250525163029314](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250525163029314.png)

这里可以看看他的快速生成的

```
app.use('/', indexRouter);
app.use('/users', usersRouter);
```

我们之前提到的 模板 这里补充一点

usersRouter.js

```java
var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});
router.get('/test', function(req, res, next) {
  res.send('test');
});

module.exports = router;

```

如果修改为这个 那么路由就是 /users/test
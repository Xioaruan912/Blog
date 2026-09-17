```shell
npm i mongoose@6.9.2
```

# 连接数据库

```java
const mongoose = require('mongoose')
mongoose.connect('mongodb://账户:密码@服务器ip:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.5.1' )

mongoose.connection.on('open',() =>{
  console.log("mongodb连接成功");
})

mongoose.connection.on('error',() =>{
  console.log("mongodb错误发生");
})

mongoose.connection.on('close',() =>{
  console.log("mongodb断开");
})
```

延时关闭 3s关闭

```java
setTimeout(() => {
  mongoose.disconnect()
},3000)
```

但是其实回调函数

```
mongoose.connection.on('open',() =>{
  console.log("mongodb连接成功");
})

推荐使用

mongoose.connection.once('open',() =>{
  console.log("mongodb连接成功");
})
```

区别在于

```
如果意外掉线 就不会重新执行回调函数  
```


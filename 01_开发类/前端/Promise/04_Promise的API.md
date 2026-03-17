# 构造函数

```
Promise(函数)
函数: (reslove,reject) => {}
```

# Then方法

```
指定回调函数 (reslove,reject) => {}
```

# Catch方法

```
指定失败的回调函数
```

```
p.catch(reason => {
	console.log('失败')
})
```

# Reslove方法

```
Promise.reslove
```

```java
const ults = require("util")
const fs = require('fs')

let p1 = Promise.resolve(11111)
console.log(p1)
```

```
如果传入 非promise 就返回成功promise
如果传入 promise 那么传入的promise 决定返回结果
```

# Reject方法

与上面相反

传入如果是成功Promise对象  还是返回失败 就是一直返回失败的Promise对象 ，并且结果是成功的数据

# ALL方法

```
接受 Promise数组
```

只有所有成功 才成功 有一个错误就返回错误s

# Race方法

```
接受 Promise数组
```

返回第一个完成的Promise结果与状态

类似赛跑

# 链式调用

串联多个任务

```java
const ults = require("util")
const fs = require('fs')


let mineReadFile = ults.promisify(fs.readFile)

mineReadFile('./inde111x.html').then((value)=>{
    console.log("正确")
},(reason)=>{
    console.log("错误")
    rejects(reason)  //把then的Promise 改变为 错误的状态
    //或者 throw reason
}).catch(reason =>{
    console.log("链式错误触发")
})
```

可以发现触发了两个错误

# 异常穿透

![image-20250527112940194](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250527112940194.png)

# 中断Promise链条

只有一个方法 需要返回一个 padding的 Promise

```
return new Promise(() => {})
```


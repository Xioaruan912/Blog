Promise 是一个技术 异步编程 是 一个构造函数 

```
Promise 对象封装一个异步操作 并且可以获取成功和失败
```

# 异步编程

```
fs 的文件异步
mongodb 数据库处理
定时器
```

在之前 我们通过

```java
const fs = require('fs')
fs.readFile('./file.txt',(err,data) => {})
//通过回调函数处理结果
  setTimeout(()=>{},2000)
```

# 优势

支持链式调用,可以解决回调地狱

## 回调地狱

![image-20250527102719160](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250527102719160.png)

在之前学习的时候 我们知道 我们写一个内容回调函数 里面继续写其他的回调函数 很痛苦 不便于阅读

错误处理每次都需要

Promise就是可以解决这些问题

# 初体验

index.html

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>初体验</title>
</head>
<body>
    <h1> Promise 初体验</h1>
    <hr>
    <button id="btn1">点击抽奖</button>
    <script src="./index.js "></script>
</body>
</html>
```

index.js

```javascript
const btn1 = document.getElementById("btn1")

function rand(m,n){
    return  Math.ceil(Math.random() * (n-m+1) +m-1)
}

btn1.onclick = () =>{
        setTimeout(() => {
            let n  =rand(1,100)
            if(n < 30) {
                alert("中奖")
            }else{
                alert("NoNoNo")
            } 
        },1000)
}
```

实现一个简单的抽奖

这里的setTimeout 就是一个异步操作 所以可以通过promise封装

## 通过promise进行封装

```java
const btn1 = document.getElementById("btn1")

function rand(m,n){
    return  Math.ceil(Math.random() * (n-m+1) +m-1)
}

btn1.onclick = () =>{
    //resolve 成功后的函数
    //reject 失败后的函数
    const promise = new Promise((resolve,reject) => {
        setTimeout(() => {
            let n  =rand(1,100)
            if(n < 30) {
                resolve()
            }else{
                reject()
            } 
        },1000)
    })
}
```

现在我们需要对异步成功失败进行实现

```java
    //调用then方法解决成功失败函数
    //两个参数都是函数
    //第一个是成功回调 第二个是错误回调
    promise.then(()=>{
        alert("中奖")
    },()=>{
        alert("未中奖")
    })
```

总的代码就实现了

```java
const btn1 = document.getElementById("btn1")

function rand(m,n){
    return  Math.ceil(Math.random() * (n-m+1) +m-1)
}

btn1.onclick = () =>{
    //resolve 成功后的函数
    //reject 失败后的函数
    const promise = new Promise((resolve,reject) => {
        setTimeout(() => {
            let n  =rand(1,100)
            if(n < 30) {
                resolve()
            }else{
                reject()
            } 
        },1000)
    })
    //调用then方法解决成功失败函数
    //两个参数都是函数
    //第一个是成功回调 第二个是错误回调
    promise.then(()=>{
        alert("中奖")
    },()=>{
        alert("未中奖")
    })
}
```

## 给then传递参数

```
    promise.then(()=>{
        alert("数字是 xxx 中奖")
    },()=>{
        alert("数字是 xxx 未中奖")
    })
```

如何传递呢 通过resolve  reject 

```javascript
const btn1 = document.getElementById("btn1")

function rand(m,n){
    return  Math.ceil(Math.random() * (n-m+1) +m-1)
}

btn1.onclick = () =>{
    //resolve 成功后的函数
    //reject 失败后的函数
    const promise = new Promise((resolve,reject) => {
        setTimeout(() => {
            let n  =rand(1,100)
            if(n < 30) {
                resolve(n)  //将n作为 成功失败函数的值 传递给then
            }else{
                reject(n)
            } 
        },1000)
    })
    //调用then方法解决成功失败函数
    //两个参数都是函数
    //第一个是成功回调 第二个是错误回调
    promise.then((value)=>{
        alert(`数字是 ${value} 中奖`)
    },(reason)=>{
        alert(`数字是 ${reason}  未中奖`)
    })
}
```

其实就是 成功的结果传递给resolve  reject  

然后通过 then方法 实现 resolve  reject 


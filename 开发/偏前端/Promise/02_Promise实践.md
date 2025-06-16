```java
const fs = require('fs')

const p = new Promise((reslove,reject) => {
    fs.readFile('./inde111x.html',(err,data) => {
    if(err) reject(err)
    reslove(data)
		})
	}).then((value)=>{
    console.log(`获取到数据 ${value}`)
		},(reason)=>{
    console.log("错误")
		})
```

# 封装函数 mineReadFile

```
参数是path 返回promise
```

```java

const fs = require('fs')

function mineReadFile(path){
    return new Promise((resolve,rejects) => {
        fs.readFile(path,(err,data) =>{
            if(err) return rejects(err)
            console.log(`找到文件 ${path}`)
            resolve(data.toString()) 
        })
    }).then((value)=>{
        console.log(value)
    },(reason)=>{
        console.log('error')
    })
}


mineReadFile('./ind1111e1x.h1l')
```

# 将回调函数风格直接转化为Promise

使用 util.promisify

```java
const ults = require("util")
const fs = require('fs')

let mineReadFile = ults.promisify(fs.readFile)

mineReadFile('./index1.html').then((value)=>{
    console.log(value.toString())
},(reason)=>{
    console.log("error")
})
```


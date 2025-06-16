# async 

 可以标志函数返回一个Promise对象

```
async function test() {  
 //返回值决定 是 成功还是失败
}
```

```
返回值是 非Promise 那么就是成功

如果是 Promise 就依照Promise结果
```

# await

```
如果 await 右侧是promise对象 返回成功值
如果 其他值 就直接返回

```

## 注意

```
await一定要写在 async函数中

但是函数可以没有await
```

```
如果 promise失败 那么会抛出异常 通过 try catch捕获异常
```

```java
async function test() {
    let p = new Promise((reslove,reject) => {
        reject('error')
    })

    try{
        let res = await p
    }catch(e){
        console.log(e)
    }
}

test()
```

# async和await实践

```
读取多个文件 
```

```java
const fs = require('fs')
const util = require('util')
let ReadFile = util.promisify(fs.readFile)

async function ReadALLFile(){
    try{
        let file1 = await ReadFile('./1.txt')
        let file2 = await ReadFile('./2.txt')
        let file3 = await ReadFile('./4.txt')
        console.log(file1 + file2 + file3)
    }catch(e){
        console.log(e)
    }
}

ReadALLFile()
```

这样整个代码就不会和之前一样难看了
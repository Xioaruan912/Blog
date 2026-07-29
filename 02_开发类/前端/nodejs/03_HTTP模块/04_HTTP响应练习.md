通过请求返回HTML内容

```javascript
const http = require("http")

const server  = http.createServer((req,response) => {
    response.end("<table  border='1'><tr><td>test</td></tr></table>")
})


server.listen("9000",() =>{
    console.log("监听")
})
```

但是这里不是很好  可以直接将html的代码整体复制到end后

通过 `` 实现 这里都是前端内容了 不再深究

通过前面的fs模块实现文件读取

```javascript
const http = require("http")
const fs = require("fs")
const server  = http.createServer((req,response) => {
    const data = fs.readFileSync('./test.html')
    response.write(data)
    response.end()
})


server.listen("9000",() =>{
    console.log("监听")
})
```

但是这里有问题 就是如果服务去找 css 还是会解析 data这个变量，所以这里代码不应该这样编写

使用上面的pathname 去区分 但是写法很痛苦

```javascript
let {pathname} = new URL(req.url,"http://127.0.0.1")
const filepath = __dirname + pathname
fs.readFile(filepath,(err,data) => {
	if(err){
		response.statusCode == 500
		response.end("data")
	}
	response.end("data")
})
```


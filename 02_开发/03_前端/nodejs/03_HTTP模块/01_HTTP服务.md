# 使用HTTP模块创建一个HTTP服务

```javascript
const http = require("http")

const server = http.createServer((req,data) => {

    data.end("HTTP server")

})

server.listen("9000","0.0.0.0", ()=>{
    console.log("服务开启")
})
```

# 中文乱码

```javascript
const http = require("http")

const server = http.createServer((req,data) => {
    data.setHeader("content-type","text/html;charset=utf-8")
    data.end("你好")
})

server.listen("9000","0.0.0.0", ()=>{
    console.log("服务开启")
})
```


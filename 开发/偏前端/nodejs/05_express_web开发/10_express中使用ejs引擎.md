```java
const ejs = require('ejs')
const path = require('path')
const express = require('express')
const app = express()
const xiyou = ['唐僧','孙悟空','猪八戒','沙僧','白龙马']
//设定前端模板引擎为ejs
app.set('view egine','ejs')
//设定模板文件存放位置
app.set('views',path.resolve(__dirname,'./public'))

app.get('/',(req,res) => {
    res.render('index.ejs',{xiyou})
})

app.listen(3000,()=>{
    console.log("服务开启")
})
```

```
index  
  |----app.js
  |----public
  		  |----inedx.ejs
```

index.ejs

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>登录</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Roboto', sans-serif;
    }
    body {
      height: 100vh;
      background: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .login-container {
      background: #fff;
      padding: 40px 30px;
      width: 360px;
      border-radius: 12px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.2);
    }
    .login-container h2 {
      text-align: center;
      margin-bottom: 24px;
      color: #333;
      font-weight: 500;
    }
    .input-group {
      margin-bottom: 20px;
    }
    .input-group input {
      width: 100%;
      padding: 12px 16px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 14px;
      transition: border-color .2s;
    }
    .input-group input:focus {
      outline: none;
      border-color: #6B73FF;
    }
    .remember {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 13px;
      margin-bottom: 24px;
    }
    .remember input {
      margin-right: 6px;
    }
    .remember a {
      color: #6B73FF;
      text-decoration: none;
      transition: opacity .2s;
    }
    .remember a:hover {
      opacity: .8;
    }
    .btn {
      width: 100%;
      padding: 12px 0;
      background: #6B73FF;
      color: #fff;
      border: none;
      border-radius: 6px;
      font-size: 16px;
      cursor: pointer;
      transition: background .2s;
    }
    .btn:hover {
      background: #5764e6;
    }
    .signup {
      text-align: center;
      margin-top: 16px;
      font-size: 13px;
      color: #666;
    }
    .signup a {
      color: #6B73FF;
      text-decoration: none;
      font-weight: 500;
      transition: opacity .2s;
    }
    .signup a:hover {
      opacity: .8;
    }
  </style>
</head>
<body>
    <ul>
 <% xiyou.forEach(item => { %>
  <f1><%= item %></f1> 
 <%  }) %>
    </ul>
</body>
</html>

```


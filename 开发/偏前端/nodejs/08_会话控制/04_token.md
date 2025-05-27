加密字符串 验证用户身份 主要是用在 app中

使用token后服务端很少

并且token需要手动携带

# JWT

跨域认证 基于token的身份验证

```
npm  i jsonwebtoken
```

### 创建token

```
let token = jwt.sign(用户数据，加密字符串，配置对象)
```

```
let token = jwt.sign({
  username:"xxxxx"
},"abcderaddsasd",{
  expiresIn:60//60 s
})
```

### 校验token

```
jwt.verify("token字符串",'加密字符串'，(err,data)=>{})
```


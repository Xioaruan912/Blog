# 操作路径



```javascript
const path = require("path")

//自动拼接
const path_str=  path.resolve(__dirname,"./fuckkkkkk")
console.log(path_str)
```

```
//查看操作系统的分割符号 这里是 \
console.log(path.sep)
```

```
//解释当前文件的绝对路径
console.log(__filename)
```

```
const data = path.parse(__filename)
//解析目录
console.log(data)

{
  root: 'C:\\',
  dir: '\\Desktop\\nodejs_code',
  base: 'test.js',
  ext: '.js',
  name: 'test'
}
```

```
path.dirname 目录名字
path.basename 文件名字
path.extname 后缀名
```


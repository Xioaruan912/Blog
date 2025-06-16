# 模板引擎

是分离用户界面和业务数据的一个技术 现在使用的不多了

可以当作分离html和js的

其中js是服务端的js 也就是下面的图片展示的数据

![image-20250525155521608](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250525155521608.png)

# EJS

是一个高效的JS模板引擎

```
npm i ejs --save
```

### 语法

```java
let china = "中国"
let result = ejs.render("nnnnn <%= china %>",{china:china})
console.log(result)
```

这样我们在编程 html的时候 就可以通过fs读入 然后通过ejs继续耦合

实现输出数据

主要解决了之前我们需要html代码写入send()函数中才可以添加node后端处理的数据 例如 ${code} 这种数据

![image-20250525160243285](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250525160243285.png)

# EJS列表渲染

希望循环输出到前端

```java
const ejs = require('ejs')
const fs = require('fs')

const xiyou = ['唐僧','孙悟空','猪八戒','沙僧','白龙马']

const html_data = fs.readFileSync('./public/index.html').toString()

let res = ejs.render(html_data,{xiyou})

```

```html
<body>
    <ul>
 <% xiyou.forEach(item => { %>
  <f1><%= item %></f1> 
 <%  }) %>
</body>
```

通过ejs语法实现

# EJS条件渲染

依据条件输出内容

```html
<% if(isLogin) { %>
<span>欢迎</span>
<% }else { %>
<button> 登入 </button>
<% } %>
```


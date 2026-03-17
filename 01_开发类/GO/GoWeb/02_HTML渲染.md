这里是通过 后端发送给前端服务 生成完整的HTML 从而传输给用户

# template 标准库

这是GO原生内置的模板库

我们写一个最基本的模板

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewpoint" content="width=device-width,inital-scale=1.0">
    <title>hello Go</title>
</head>

<body>
    <p>hello {{.}}</p>
</body>

</html>
```

写一个 原生Go解析

```go
package main

import (
	"fmt"
	"html/template"
	"net/http"
)

func sayBook(w http.ResponseWriter, r *http.Request) {
	//解析模板
	t, err := template.ParseFiles("./hello.tmpl")
	if err != nil {
		fmt.Println("template error ")
	}
	//渲染模板
    //写入哪里 传入的是什么
	t.Execute(w, "abce")
}

func main() {
	http.HandleFunc("/book", sayBook)
	err := http.ListenAndServe(":9000", nil)
	if err != nil {
		fmt.Printf("error %s", err)
	}

}

```


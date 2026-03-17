我们首先通过一个 基本代码了解一下 GIN

# 初识Gin

```go
package main

import "github.com/gin-gonic/gin"

func main() {
	//创建 路由引擎
	r := gin.Default()

	//处理Get请求 对于 book 路由的操作 通过匿名函数执行
	r.GET("/book", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Golang",
		}) //   gin.H 是 一个 type H map[string]any

	})
	//启动服务
	r.Run()
}

```

去访问 `http://127.0.0.1:8080/book`

![image-20251230204142693](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251230204142693.png)

当然还有一个其他方法写 处理路由的函数

```go
package main

import "github.com/gin-gonic/gin"

func getBook(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "Golang",
	})
}
func main() {
	//创建 路由引擎
	r := gin.Default()

	//处理Get请求 对于 book 路由的操作 通过匿名函数执行
	r.GET("/book", getBook)
	//启动服务
	r.Run()
}

```

# RESTful API

后端开发中 我们需要遵守 RESTful API 格式

```
对于book 的增改删查 如果不使用 就如下
	r.GET("/book", getBook)
    r.GET("/update_book", update_book)
    r.GET("/delete_book", delete_book)
    r.GET("/create_book", create_book)
```

如果使用 RESTful API 那么 我们通过 HTTP 方法 区分 操作类型

```
	r.GET("/book", getBook) //GET 作为查询操作
    r.POST("/book", create_book) //POST 作为创建操作
    r.DELETE("/book", delete_book) //DELETE 作为删除操作
    r.PUT("/book", update_book) // PUT 作为更新操作
```

从上述代码 我们遵守了 一个路由 但是通过不同方法 区分 这就遵守了 RESTful API 规范
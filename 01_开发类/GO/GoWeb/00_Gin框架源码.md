[https://github.com/gin-gonic/gin](https://github.com/gin-gonic/gin)

通过查看优秀的源代码 学习优秀的编写

# 路由

![image-20251230101832473](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251230101832473.png)

R作为公共前缀 直接作为 根 任何分叉

om ub 作为二级 放在根的左右子树中 这样就构建成 基数树

`gin框架`的实现就是基于基数树

```
r := gin.Default()

r.Get("/",func1)
r.Get("/search",func2)
r.Get("/support",func3)
r.Get("/blog",func4)
r.Get("/blog/:post/",func5)
r.Get("/about-us",func6)
r.Get("/about-us/team",func6)
r.Get("contact",func6)
```

我们得到如下图的基数树

![image-20251230102230186](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251230102230186.png)

```
/ 作为树根
分出四叉 s bolg about-us 和 contact

优先级从上到下
```

```
/blog/:post/
这里的 :post 只是实际文章的占位符 动态的 
```

`Gin`中不同方法 都维护一个独立的树  

## 优先级

 就是子节点 注册的句柄数量

```
1. 快速定位
2. 成本补偿： 长的路径先被匹配
```

## 路由树

我们可以看看 基数树的 代码是什么

```go
package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	//注册 路由器
	r := gin.Default()
	r.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "ok")
	})
	r.Run()
}

```

这就是最基本的最简单的

我们去看看`r.Run()`是如何处理的

```go
func (engine *Engine) Run(addr ...string) (err error) {
	defer func() { debugPrintError(err) }()

	if engine.isUnsafeTrustedProxies() {
		debugPrint("[WARNING] You trusted all proxies, this is NOT safe. We recommend you to set a value.\n" +
			"Please check https://github.com/gin-gonic/gin/blob/master/docs/doc.md#dont-trust-all-proxies for details.")
	}
	engine.updateRouteTrees()
	address := resolveAddress(addr)
	debugPrint("Listening and serving HTTP on %s\n", address)
	err = http.ListenAndServe(address, engine.Handler())
	return
}
```

可以发现关键启动就是 `http.ListenAndServe(address, engine.Handler())`

通过 GoSDK 的`net/http` 打开一个 服务 可以发现最底层就是 SDK

我们进入 http可以发现

```go
func ListenAndServe(addr string, handler Handler) error {
```

有一个 `handler Handler` 是一个接口 他必须实现

```go
type Handler interface {
	ServeHTTP(ResponseWriter, *Request)
}
```

所以我们看看

`engine.Handler()`

![image-20251230104925158](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251230104925158.png)

我们去看看 Handler 方法

最后就可以找到 engine实现是如何实现的

```go
// ServeHTTP conforms to the http.Handler interface.
func (engine *Engine) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	c := engine.pool.Get().(*Context)
	c.writermem.reset(w)
	c.Request = req
	c.reset()

	engine.handleHTTPRequest(c)

	engine.pool.Put(c) //返回池子中
}
```

我们看看 `handleHTTPRequest` 是如何实现的

```go
func (engine *Engine) handleHTTPRequest(c *Context) {
	httpMethod := c.Request.Method
	rPath := c.Request.URL.Path
	unescape := false
	if engine.UseRawPath && len(c.Request.URL.RawPath) > 0 {
		rPath = c.Request.URL.RawPath
		unescape = engine.UnescapePathValues
	}

	if engine.RemoveExtraSlash {
		rPath = cleanPath(rPath)
	}

	// Find root of the tree for the given HTTP method
	t := engine.trees
	// 基数树 然后遍历基数树
	//这里的写法很好 不需要每次计算t 而是直接初始化
	for i, tl := 0, len(t); i < tl; i++ {
	//如果不是 http方法 就推出 不可能的条件 先写到代码前面
		if t[i].method != httpMethod {
			continue
		}
		//获取根
		root := t[i].root
		// 查找路由
		value := root.getValue(rPath, c.params, c.skippedNodes, unescape)
		if value.params != nil {
			c.Params = *value.params
		}
		if value.handlers != nil {
			c.handlers = value.handlers
			c.fullPath = value.fullPath
			c.Next()
			c.writermem.WriteHeaderNow()
			return
		}
		if httpMethod != http.MethodConnect && rPath != "/" {
			if value.tsr && engine.RedirectTrailingSlash {
				redirectTrailingSlash(c)
				return
			}
			if engine.RedirectFixedPath && redirectFixedPath(c, root, engine.RedirectFixedPath) {
				return
			}
		}
		break
	}

	if engine.HandleMethodNotAllowed && len(t) > 0 {
		// According to RFC 7231 section 6.5.5, MUST generate an Allow header field in response
		// containing a list of the target resource's currently supported methods.
		allowed := make([]string, 0, len(t)-1)
		for _, tree := range engine.trees {
			if tree.method == httpMethod {
				continue
			}
			if value := tree.root.getValue(rPath, nil, c.skippedNodes, unescape); value.handlers != nil {
				allowed = append(allowed, tree.method)
			}
		}
		if len(allowed) > 0 {
			c.handlers = engine.allNoMethod
			c.writermem.Header().Set("Allow", strings.Join(allowed, ", "))
			serveError(c, http.StatusMethodNotAllowed, default405Body)
			return
		}
	}

	c.handlers = engine.allNoRoute
	serveError(c, http.StatusNotFound, default404Body)
}

```

我们看看tree

```go
	trees            methodTrees
```

```go
type methodTree struct {
	method string
	root   *node
}

//map比 slice 更占用内存 所以 我们通过slice 降低内存
type methodTrees []methodTree //是一个slice类型
```

节点的结构体

```go
type node struct {
	path      string
    //存储后续节点的所有第一个字母
	indices   string
	wildChild bool
    //节点是什么类型的
	nType     nodeType
	priority  uint32
	children  []*node // child nodes, at most 1 :param style node at the end of the array
	handlers  HandlersChain
	fullPath  string
}
```

# 注册路由

我们看完树和节点 我们看看注册路由是怎么实现的

```go
// GET is a shortcut for router.Handle("GET", path, handlers).
func (group *RouterGroup) GET(relativePath string, handlers ...HandlerFunc) IRoutes {
	return group.handle(http.MethodGet, relativePath, handlers)
}
```

进入 handle后看看 addRoute

```go
func (engine *Engine) addRoute(method, path string, handlers HandlersChain) {
	assert1(path[0] == '/', "path must begin with '/'")
	assert1(method != "", "HTTP method can not be empty")
	assert1(len(handlers) > 0, "there must be at least one handler")

	debugPrintRoute(method, path, handlers)

	root := engine.trees.get(method)
	if root == nil {
		root = new(node)
		root.fullPath = "/"
		engine.trees = append(engine.trees, methodTree{method: method, root: root})
	}
	root.addRoute(path, handlers)

	if paramsCount := countParams(path); paramsCount > engine.maxParams {
		engine.maxParams = paramsCount
	}

	if sectionsCount := countSections(path); sectionsCount > engine.maxSections {
		engine.maxSections = sectionsCount
	}
}

```

# 中间件

```
func Default(opts ...OptionFunc) *Engine {
    debugPrintWARNINGDefault()
    engine := New()
    engine.Use(Logger(), Recovery())
    return engine.With(opts...)
}
```

```
    engine.Use(Logger(), Recovery()) //中间件
```

```
func (engine *Engine) Use(middleware ...HandlerFunc) IRoutes {
	engine.RouterGroup.Use(middleware...)
	engine.rebuild404Handlers()
	engine.rebuild405Handlers()
	return engine
}
```


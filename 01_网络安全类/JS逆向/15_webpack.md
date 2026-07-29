# 推荐学习资源

`https://www.bilibili.com/video/BV13ec1e3Eg3/?share_source=copy_web&vd_source=84289680f04e153355b368620df7473b`

# 函数调用

之前我们通过 

```
函数名字()
```

就可以调用

其实还有调用的方法

```
函数名字.call()
函数名字.apply()
```

`webpack` 是通过 `函数名字.call()` 方法调用的



# webpack正向打包

`webpack` 是   前端项目的“打包工具/构建工具”

我们可能通过 TS 或者其他内容编写 前端 但是 浏览器只支持 JS HTML CSS等

所以我们需要通过 webpack 打包 转化为 浏览器支持的 语言 这就是webpack

下面是打包过程：

1. 开发人员给出 完整前端内容
2. `npm i ` 下载 包依赖内容 获取构建的全部模块
3. `npm run build` 构建打包
4. 进入 `dist` 目录 这里就生成的是 前端浏览器代码 
5. `dist` 丢入 服务器中 就可以直接部署路由即可

一般 `chunk` 开头的 都是打包后内容

# webpack原理

开发数据 模块化 通过 loader加载器和插件 对资源成立 打包成 前端可运行的内容

1. 缩小前端 体积
2. 模块化调用方便

如果我们逆向过程 遇见了 

 

这种格式 那么多半就是通过 `webpack` 加载器

![image-20260118095127779](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260118095127779.png)

`webpack`在逆向过程中 算是 扣代码的下一个进阶版本

1. 逆向过程中 对象不简单 不是扣JS代码就可以实现的
2. 涉及对象的引用

![image-20260118095638017](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260118095638017.png)

也就是引用了 `某个对象` 的 `某个方法`

如果遇见了` xxx = n(1000)` 这种结构 多半使用了 `webpack`

本地复原后 无论如何难扣 直接搞就行了、

`webpack` 具有下面格式： 通过匿名函数自执行的方法

```
!function(形参){加载器}([模块1,模块2])
!function(形参){加载器}({"k1":"模块1","k2":"模块2"})
//后面括号为 参数
```

# `数组webpack`

```js
window = global;
!function (e) {   //匿名函数
	//函数参数传入后的 执行过程
	
	//构建 缓存对象初始化
    var t = {};
	
	//这里就是加载器 【核心】
    function n(r) {
    
    	//如果此次调用的 在缓存中 直接调用返回
        if (t[r])
            return t[r].exports;
        //如果没有 那么就把 t[r] 初始化 并且赋值给o
        var o = t[r] = {
            i: r,
            l: !1,
            exports: {}
        };
        //e为下面函数数组 取出 下标 并且执行
        //函数可以接收任意数量参数，就算形参没写，也会被放在 arguments 里
        e[r].call(o.exports, o, o.exports, n);
        return o.exports.exports;
    }
    
    //给外部用
    window.loader = n;
    
	//下面是函数内部调用
    // n(0);

}([ function () { //函数的参数 在这里
        console.log("foo");
        this.exports = 100; //这个是返回值
    },
    function () {
        console.log("bar");
        this.exports = 200;
    },
]);

console.log(window.loader(0)) //传递的是数组下标
console.log(window.loader(1))
```

# `字典webpack`

```js
window = global;
!function (e) {
	
	//构建 缓存对象初始化
    var t = {};
	
	//这里就是加载器 【核心】
    function n(r) {
        if (t[r])
            return t[r].exports;
        var o = t[r] = {
            i: r,
            l: !1,
            exports: {}
        };
        e[r].call(o.exports, o, o.exports, n);
        return o.exports.exports;
    }
    
    //给外部用
    window.loader = n;
    
	//下面是函数内部调用
    // n("1002");

}({ //通过 字典方法 传递 函数内容 可以传递 1001
	"1001":function (){
		console.log("Foo");
        this.exports = 100;
	},
    "1002":function (){
		console.log("bar"); //这个是返回值
        this.exports = 100;
	},
});

console.log(window.loader("1001")) //传递的是关键字
```

# 实战1

`https://ec.minmetals.com.cn/open/home/purchase-info`

![image-20260118104710837](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260118104710837.png)

有很多方法 可以跟启动器 或者 直接定位关键字 我们这里直接 hook一下 JSON 转字符串

```
(function() {
	var parse_ = JSON.stringify;
	JSON.parse = function(a){
		console.log("断住了");
        console.log(a);
		debugger;
		return parse_(a)
	}})()
```

但是可能设置了反爬虫 hook 就无法显示数据 所以我们直接 XHR断点看看

我们发现 断了 `https://ec.minmetals.com.cn/open/homepage/zbs/by-lx-page` 分析半天 一点东西 都没有 所以我们看看分析 

`https://ec.minmetals.com.cn/open/homepage/public` 这个包 

直接全局搜索`/open/homepage/public`

![image-20260118110930121](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260118110930121.png)

直接就发现了问题 这里出现了 RSA类似的算法

```
把 public的返回值作为KEY  ：t.setPublicKey(r),
```

![image-20260118111203884](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260118111203884.png)

可以发现就是`MD5`运算 作为 `sign`

然后再作为参数加密

![image-20260118111252824](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260118111252824.png)

我们找找看这个` t`是什么

```
t = new d["a"],
```

接着找`d` 搜索 `d = `

```
 , d = t("9816");
```

这里这种调用 多半就是 加载器了 我们进入` t` 查看 下断点 然后刷新

![image-20260118113958847](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260118113958847.png)

标标准准的加载器 我们这里扣加载器的代码

![Capturer_2026-01-18_114012_566](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-18_114012_566.gif)

然后我们去找 `9816` 作为函数传入

![image-20260118114220179](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260118114220179.png)

![Capturer_2026-01-18_114229_429](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-18_114229_429.gif)

设置一下外部调用

1. 定义一个全部变量 ` jzq`
2. 把匿名函数内部自执行的 `t()` 删除 转化为 `jzq = o ` 这里的`o` 是标准加载器的函数名字

这样我们就可以在外部调用` jzq`了

![Capturer_2026-01-18_114519_585](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-18_114519_585.gif)

调用看看

报错 

```
window is not defined
```

加入 `window = globalThis`

报错

```
Uncaught TypeError TypeError: Cannot read properties of undefined (reading 'call')
```

`o`函数中加入` console.log `看看是不是前面又调用了其他的函数

```js
    function o(e) {
        if (n[e])
            return n[e].exports;
        var t = n[e] = {
            i: e,
            l: !1,
            exports: {}
        };
        console.log(e)
        return A[e].call(t.exports, t, t.exports, o),
        t.l = !0,
        t.exports
    }
```

输出

```
9816
a524
```

所以我们去找 `a524`

```js
    a524: function(e) {
        e.exports = JSON.parse('{"version":"3.2.1"}')
    },
```

执行 不报错了

下面复原 代码

```js
var r = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCkbfXHhKgKjaO2aBTyR2kk8xOaISXHqcFFbJtxGfDJlwz0QULu8prdYR8l195xAf/eULwk6PKwmgVIBL1MjFiVTxj6t0DKIdGvhY7BBDd2wJs6PUPrKjrBgP/lIuxdju/BxgJMJ09IHaQYkw9CgPzRahhIfNdNW6M9sGqUCKLZ8wIDAQAB'
d = jzq('9816')

a = {  //这里不分析a的内容
    "inviteMethod": "",
    "businessClassfication": "",
    "mc": "",
    "lx": "ZBGG",
    "dwmc": "",
    "pageIndex": 2,
    "sign": "cc3ad69e118a9e7a2def803e50cd3a73",
    "timeStamp": 1768708155467
}

t = new d["a"]
t.setPublicKey(r)
s = t.encryptLong(JSON.stringify(a))
```

报错

```
 t.encryptLong is not a function
```

去找咯 补全环境

```js
var r = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCkbfXHhKgKjaO2aBTyR2kk8xOaISXHqcFFbJtxGfDJlwz0QULu8prdYR8l195xAf/eULwk6PKwmgVIBL1MjFiVTxj6t0DKIdGvhY7BBDd2wJs6PUPrKjrBgP/lIuxdju/BxgJMJ09IHaQYkw9CgPzRahhIfNdNW6M9sGqUCKLZ8wIDAQAB'
d = jzq('9816')

a = {  //这里不分析a的内容
    "inviteMethod": "",
    "businessClassfication": "",
    "mc": "",
    "lx": "ZBGG",
    "dwmc": "",
    "pageIndex": 2,
    "sign": "cc3ad69e118a9e7a2def803e50cd3a73",
    "timeStamp": 1768708155467
}
d["a"].prototype.encryptLong = function(A) {
    var e = this.getKey()
        , t = (e.n.bitLength() + 7 >> 3) - 11;
    try {
        var n = ""
            , r = "";
        if (A.length > t)
            return n = A.match(/.{1,50}/g),
            n.forEach((function(A) {
                var t = e.encrypt(A);
                r += t
            }
            )),
            w(r);
        var a = e.encrypt(A)
            , s = w(a);
        return s
    } catch (i) {
        return i
    }
}
function w(A) {
    var e, t, n = "", r = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", a = "=";
    for (e = 0; e + 3 <= A.length; e += 3)
        t = parseInt(A.substring(e, e + 3), 16),
        n += r.charAt(t >> 6) + r.charAt(63 & t);
    e + 1 == A.length ? (t = parseInt(A.substring(e, e + 1), 16),
    n += r.charAt(t << 2)) : e + 2 == A.length && (t = parseInt(A.substring(e, e + 2), 16),
    n += r.charAt(t >> 2) + r.charAt((3 & t) << 4));
    while ((3 & n.length) > 0)
        n += a;
    return n
}
t = new d["a"]
t.setPublicKey(r)
s = t.encryptLong(JSON.stringify(a))
```

最后执行 输出

结束

# 实战2

`https://fuwu.nhsa.gov.cn/nationalHallSt/#/Search/pharmacies?code=90000`

直接下一页 然后搜搜关键字

![image-20260118130725444](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260118130725444.png)

发现了 SM 系列加密算法 可以发现 他都是 `t.` 我们去看看 定义`t`的地方

注意 对加载器打断点 需要 刷新界面 而不是点下一页

很明显 是 加载器 的内容 所以我们看到上面 有一个 `n("7726")`

![image-20260118130857199](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260118130857199.png)

![image-20260118131003308](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260118131003308.png)

直接定位到 加载器的地方 扣出代码 下面搜索方法 `7726:`

![image-20260118131208075](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260118131208075.png)

直接抠出来

修改初始调用结束

然后开始跟着算法走

# 实战3

`https://open.babytree.com/default#/`

登入抓包

![image-20260119093402726](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260119093402726.png)

开始分析 先尝试启动器跟着走

![image-20260119093515421](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260119093515421.png)

一进去就发现了关键点

![image-20260119093533847](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260119093533847.png)

下断点重新登入 然后进入函数内部 函数内部再断点 进入

![image-20260119093608494](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260119093608494.png)

发现明显是一个webpack 并且是函数内容 所以我们去找他的启动器 拉到最上面看看是不是这个启动器 

```
(window.webpackJsonp = window.webpackJsonp || []).push([[46],
```

![Capturer_2026-01-19_093920_999](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-19_093920_999.gif)

找到加载器了 扣下来即可

发现缺环境了 所以我们去补环境

最后我们调用报错 不是函数 所以我们去看看

```js
    363: function(t, e, n) {
        "use strict";
        var r = n(890);
        e.a = function(t) {
            var e = new r.JSEncrypt;
            return e.setPublicKey("-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2qC67Y3KF6mupPBsnsoIqEM1dfohMkMI4Rxj60Ae3MOT+Ch3vPZwCj4P5vVw+sVuRv0N94MqraNxLBlQfyeIf2Vu1KOdHD+gFfWneSrNM7Cs4b7Cn+ctCf9tJ239IrLilfsasV6iWc7kDHGIwInMJ9XqqTZTBnWP07SCQYf8J3mL/vw/PY1klBknwh8oLuJi8+BfAS1KPgMuK60NxTAMny+9h9Dno1kVGeLa0Osm4TkVWK9Uyx0XbbV0IfrnbpT/0FUxC6X+K+gHsWzmywrC7145+Bgz0lQo2kRTy551RcyMStlT41poc6ASn8mzCMD4u4MyNU+V0srtFBD8fdwZZwIDAQAB-----END PUBLIC KEY-----"),
            e.encrypt(t)
        }

    },
```

可以发现 他是 `e.a`为结果 我们为了外部调用 必须用全局接他

```js
        enc = e.a
```

![image-20260119095238260](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260119095238260.png)

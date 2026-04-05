依旧使用嘟嘟牛

我们可以搜索关键字`encrypt`

![image-20260405164528999](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260405164528999.png)

我们尝试Hook这个

那么我们就需要学习一下基本代码编写

```

Java.perform(function() {
    console.log("脚本已成功注入...");

    var ErrorSend = Java.use("com.dodonew.online.base.ProgressActivity");
    console.log("覆写输出内容：",ErrorSend);
    ErrorSend.onErrorResponse.implementation = function(volleyError){
        console.log("输出参数：",volleyError);
        this.onErrorResponse(volleyError);
    }
});
```

这个就是基本的代码 可以发现这里是传入一个 泛型 `map`

我们的Hook只是简单的输出罢了

```
frida -UF -l hello.js
```

这里覆写是因为 这里的嘟嘟牛的server出错 所以我们无法发出数据到加密内容去 所以这里直接Hook输出内容

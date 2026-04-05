依旧使用嘟嘟牛

# HOOK基本函数



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

我们的Hook只是简单的输出罢了

```
frida -UF -l hello.js
```

这里覆写是因为 这里的嘟嘟牛的server出错 所以我们无法发出数据到加密内容去 所以这里直接Hook输出内容

# 得到/修改函数参数与返回值

如果我们希望维持原本函数逻辑 只是希望对参数修改 那么可以通过下面方法

我们这里注意 虽然frida执行的是JS代码 但是我们只要在Java层执行的内容 就需要按照Java的格式去书写

比如对于map相关的操作 我们能不能通过`toString`得到参数呢 因为Java可以的

我们需要多态的转型

HashMap其实是一个接口 他继承于object父类从而得到`toString`

所以我们需要转型

```
var bb = Java.cast(具体参数,需要转化的类型);
```

比如我们需要转化到HashMap中

```
var bb = Java.cast(a,Java.use('java.util.Map'));
```

我们就可以把a 转化Map类型 从而可以对a进行Map的操作

这里都是基本操作 等后续介绍Frida具体API的时候 就可以更加深入的理解了

因为在2026年 嘟嘟牛已经不可以继续逆向分析了

![image-20260405201518890](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260405201518890.png)


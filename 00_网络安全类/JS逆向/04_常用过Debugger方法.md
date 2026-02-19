我们的学习网站为 https://www.fangdi.com.cn/

打开F12 看看如何绕过

# 一律不在此处断

![Capturer_2026-01-10_154249_860](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-10_154249_860.gif)

这里可以发现 一律不再此处后 会进入第二个debugger 所以这里适合只有一个的

# 添加条件断点

右键 条件断点 添加一个 false 判断

结果也是如此

# 停用断点

如果 注入 什么方法都不可以 就直接停用断点 分析

![image-20260110154515618](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260110154515618.png)

# 构造器注入

如果网站通过 构造器启动 并且 构造器里面有 debugger

那么直接 注入构造器

构造器重写1：

```js
var _constructor = constructor;

Function.prototype.constructor = function (s) {
  if (s == "debugger") {
    //console.log(s);
    return null;
  }
  return _constructor(s);
};

```

构造器重写2：

```js
Function.prototype.__constructor_back = Function.prototype.constructor;

Function.prototype.constructor = function () {
  if (arguments && typeof arguments[0] === 'string') {
    if ("debugger" === arguments[0]) {
      return; // 直接拦截
    }
  }
  return Function.prototype.__constructor_back.apply(this, arguments);
};

```



# 定时器置空

方法1：

```js
setInterval = function(){}
```

方法2：

```js
setinval_a = setInterval;

setInterval = function (a, b) {
  if (a.toString().indexOf('debugger') == -1) {
    console.log(a);
    return setinval_a(a, b);
  }
};

for (var i = 1; i < 99999; i++) window.clearInterval(i); // 清除定时器

```

# 替换

![image-20260110155012623](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260110155012623.png)

让网站加载 绕过的debugger 只适用于 固定文件

# function函数启动的

方法1：

```js
(() => {
  Function.prototype.__constructor = Function;

  Function = function () {
    if (arguments && typeof arguments[0] === "string") {
      if ("debugger" === arguments[0]) {
        return;
      }
    }
    return Function.apply(this, arguments);
  };
})();

```

方法2：

```js
eval_a = eval;

eval = function (a) {
  if (
    a ===
    "(function(){var a = new Date(); debugger; return new Date() - a > 100;})()"
  ) {
    return null; // 命中这段“反调试探测”代码就不执行
  } else {
    return eval_a(a); // 其他情况照常 eval
  }
};

```

# 不允许调试

http://www.aqistudy.cn/

![image-20260110155503833](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260110155503833.png)

通过设置 - 更多工具 - 开发者工具打开即可

![Capturer_2026-01-10_155556_770](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-10_155556_770.gif)

这里绕过debugger

一律不再此处暂停

![image-20260110155654039](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260110155654039.png)

# 遇见检测窗口

![image-20260110155713701](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260110155713701.png)

上面例子报错这个 这个时检测浏览器 是否屏幕中有 开发者 我们只需要把开发者控制台 作为新窗口即可

![Capturer_2026-01-10_155801_798](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-10_155801_798.gif)

这样就绕过了

![image-20260110155854901](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260110155854901.png)
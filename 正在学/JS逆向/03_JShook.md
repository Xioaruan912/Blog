# hook是什么

我们叫做钩子

1. 在访问网站的时候
2. 我们下载网站的源代码到浏览器中
3. 下载` js` 执行之前 在里面注入`js `断住方法
4. 从而进行调试

`jshook` 可以理解为 `js注入`

由于本地浏览器 权限最高 所以我们可以在任意地方进行注入

对于反调试 都可以进行hook 绕过

这里就提供一个思路 如果JSON返回的是一个密文 一定是解密后转化为字符串 然后返回 也就是通过 `JSON.parse()`

```js
(function() {
	var parse_ = JSON.parse;
	JSON.parse = function(a){
		console.log("断住了");
		debugger;
		return parse_(a)
	}})()
```

也就是 找到他解密或者运行的代码 断住 然后可以去看看栈的内容 是什么调用的 从而去找加解密的内容

一般都是固定的方法

XHR请求参数断：	

```js
(function () {
  var open = window.XMLHttpRequest.prototype.open;

  window.XMLHttpRequest.prototype.open = function (method, url, async) {
    if (url.indexOf("NECaptchaValidate") != -1) {
      debugger;
    }

    return open.apply(this, arguments);
  };
})();

```

如果设置 header那就通过下面代码 （也就是加密验证在header的时候：

```js
(function () {
  var sh = window.XMLHttpRequest.prototype.setRequestHeader;

  window.XMLHttpRequest.prototype.setRequestHeader = function (key, value) {
    if (key == 'enct') {
      debugger;
    }

    return sh.apply(this, arguments);
  };
})();

```

如果我们需要看看Cookie怎么设置的：

```js
(function () {
  var cookieTemp = '';

  Object.defineProperty(document, 'cookie', {
    set: function (val) {
      if (val.indexOf('v') != -1) {
        debugger;
      }

      console.log('Hook 捕获到 cookie 设置->', val);
      cookieTemp = val;
      return val;
    },
    get: function () {
      return cookieTemp;
    }
  });
})();

```


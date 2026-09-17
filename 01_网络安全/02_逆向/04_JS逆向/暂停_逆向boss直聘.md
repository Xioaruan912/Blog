最近 boss更新了 反调试机制 如果访问某页 就会转到 没有反调试的页面去例如

# 参考资料

https://linux.do/t/topic/640626/223

1. 相同原理的其它网站 - [讯飞星火-懂我的AI助手](https://xinghuo.xfyun.cn/desk)
2. 目标网站使用的用于阻止调试的库 - [GitHub - theajack/disable-devtool: Disable web developer tools from the f12 button, right-click and browser menu](https://github.com/theajack/disable-devtool)
3. 怎样阻止页面跳走 - [Window: beforeunload event - Web APIs | MDN](https://developer.mozilla.org/en-US/docs/Web/API/Window/beforeunload_event)
4. 目标网站中包含阻止调试逻辑的代码文件 - https://static.zhipin.com/fe-zhipin-geek/web/spa/v6304/static/js/app.6ff3a189.js
5. https://juejin.cn/post/7304556956428992546#heading-1

https://www.zhipin.com/web/geek/jobs 这里可以正常打开反调试 但是如果我们切换到

![image-20260113030038169](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260113030038169.png)

这里 打开反调试就会直接跳到之前那个界面

这里我们就要知道一下 DOM

# DOM

DOM 也叫做事件监听 我们可以直接对 前端的 DOM下断点

![image-20260113101008595](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260113101008595.png)

对加载DOM内容所有下断点即可

![image-20260113101103364](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260113101103364.png)

可以发现 成功断住 我们直接搜索 `about:blank`

全部下断点 然后开始分析
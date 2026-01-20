`https://www.bilibili.com/video/BV1UH14YkEn2/?share_source=copy_web&vd_source=84289680f04e153355b368620df7473b`

这里提出一个技术 `JSRPC` `jS`的远程调用服务

主要通过`ws`协议 我们找到了 加密函数后 不需要扣代码 不需要不补环境 让 接口传入  获取加密后的内容

![image-20260119221240370](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260119221240370.png)

本质上就是 通过流量传递

1. 我们需要注入 JS代码 到 本地客户端（浏览器） 让收到`ws`内容就传递给加密函数

实战

# JSRPC实践

`https://passport.meituan.com/account/unitivelogin`

也是跟着视频里面的内容 首先访问 `github`

`https://github.com/jxhczhl/JsRpc/releases/tag/v1.098` 【对于无法访问的 可以通过文末的百度网盘获取】

## 启动服务与hook注入

下载 对应的服务 这里我直接下载 windows 演示 【注意安装软件的安全性 如果害怕 请去虚拟机操作】

双击 启动服务

![image-20260120095646685](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120095646685.png)

访问 `https://github.com/jxhczhl/JsRpc/blob/main/resouces/JsEnv_Dev.js` 获取 浏览器注入窗口

我们知道 浏览器 对于前端代码 权限最高 所以我们可以直接 `hook 注入`

![Capturer_2026-01-20_095810_960](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-20_095810_960.gif)

## 找到加密函数

我们现在需要去定位加密函数 通过 启动器  堆栈 或者 关键字搜索 

花点 时间跟栈看看

![image-20260120101123285](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120101123285.png)

## 加入 通信函数

我们现在通过替换 让我们可以操作 这个JS代码

![image-20260120101235102](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120101235102.png)

通过RPC协议 远程调用

```
//前面的 hello2 是 下面 action的参数
var demo = new Hlclient("ws://127.0.0.1:12080/ws?group=xxxxxxx");
//bbbbbbbbb对应下面的 action 参数
demo.regAction("bbbbbbbbb", function (resolve,param) {
    resolve(encrypt.encrypt(param)); //这里修改为加密函数名字
})
```

```
http://127.0.0.1:12080/go?group=xxxxxxx&action=bbbbbbbbb&param=123456
```

如果一直没有上线 通过  `Ctrl + shift + R` 强制刷新

![image-20260120103716448](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120103716448.png)

这样我们就可以通过 参数传递了 我们尝试看看 传递 密码 `123456`

```
http://127.0.0.1:12080/go?group=xxxxxxx&action=bbbbbbbbb&param=123456
```

![image-20260120103746094](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120103746094.png)

成功输出结果 实现 远程调用 免去了分析代码

弊端：

1.  关闭浏览器界面 RPC 就消失 无法调用 对于普通爬虫 过于重了 需要打开一个浏览器 
2.  验证码 依旧无法绕过 需要特定设计

# 获取

`https://pan.baidu.com/s/1JjwEAqIJyRcJfi-_OD0mEw?pwd=y3bh`
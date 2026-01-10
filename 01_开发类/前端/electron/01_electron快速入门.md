![image-20250526214609065](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250526214609065.png)

# 入门

```
npm i electron  
```

```
const {app, BrowserWindow} = require('electron')
BrowserWindow new一个窗口
app 就是应用对象
```

## 构建一个小窗口

```java
const {app, BrowserWindow} = require('electron')

  //app 在 准备好了后  创建一个新的窗口
app.on('ready',()=>{
    new BrowserWindow({
        width:800,
        height:600
    })
})
```

# 窗口配置项目

更多参考 [electron官网](https://www.electronjs.org/zh/docs/latest/api/browser-window)

```
        autoHideMenuBar:true, //隐藏菜单栏
        width:800, //宽度
        height:600, //高度
        x:0,  //坐标
        y:0	
        alwaysOnTop:true // 置顶 
```

# 加载URL

```java
const {app, BrowserWindow} = require('electron')

app.on('ready',()=>{
    const win = new BrowserWindow({
        width:800,
        height:600,
        autoHideMenuBar:true, //隐藏菜单栏
    })
    //通过win对象直接展示URL
    win.loadURL("https://tan.722225.xyz")
})
```

# 加载本地文件

```java
const {app, BrowserWindow} = require('electron')
const path = require("path")
app.on('ready',()=>{
    const win = new BrowserWindow({
        width:800,
        height:600,
        autoHideMenuBar:true, //隐藏菜单栏
        alwaysOnTop:true
    })
    //通过win对象直接展示URL
    win.loadFile(path.resolve(__dirname,"./src/index.html"))
})
```

# 完善窗口行为

windows和linux 关闭窗口需要退出所有窗口

macos 不需要 doc还存在

```java
//在所有窗口关闭的时候
app.on('window-all-closed',() =>{
    if(process.platform !== 'darwin') app.quit()
        //如果不是macos 那么就退出
})
```

```java
const { app, BrowserWindow } = require('electron');
const path = require('path');

let mainWindow;                 // 全局保存主窗口引用，防止被 GC

// 只创建窗口，不负责加载页面
function createWindow() {
  return new BrowserWindow({
    width: 800,
    height: 600,
    autoHideMenuBar: true,
    alwaysOnTop: true
  });
}

// 单独封装加载首页的逻辑，避免重复硬编码路径

app.on('ready',() => {
  win = createWindow();  
  win.loadFile(path.join(__dirname, 'src', 'index.html'));   
});

// macOS：Dock 图标被点击且无窗口时重新创建
app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

// 全部窗口关闭时退出（macOS 除外）
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});

```

# Whenready

我们之前写的都是 on 可以改为wheready

```java

app.whenReady.then(()=>{
    win = createWindow()
    loadMainPage(win)
})

```

但是其实使用on 就跟好理解

# 配置自动重启

```
nodemon -exec  electron .
```


开始之前我们要下载burp 

这里我使用uv 管理

```shell
uv init 
uv venv
source ./.venv/bin/activate
uv add burp
```

在Burp插件编写的时候 需要使用 Extender类

```python
from burp import IBurpExtender

class BurpExtender(IBurpExtender):
    
```

在本类中开始编写代码

```
IBurpExtender	
All extensions must implement this interface.
所有插件都需要包含这个
```

它里面包含一个方法

```
void registerExtenderCallbacks(IBurpExtenderCallbacks callbacks)
注册插件
```

我们去看看这个callbacks 的内容

https://portswigger.net/burp/extender/api/burp/iburpextendercallbacks.html

```
IExtensionHelpers	getHelpers()
该方法用于获取一个 IExtensionHelpers 对象，扩展可以使用该对象执行许多有用的任务。
```

我们调用方法

```
setExtensionName(java.lang.String name)
该方法用于设置当前扩展的显示名称，该名称将在 Extender 工具的用户界面中显示。
```

```python
# -*- coding: utf-8 -*-
from burp import IBurpExtender
class BurpExtender(IBurpExtender):
    def registerExtenderCallbacks(self, callbacks):
        self._callbacks = callbacks
        self._helpers = callbacks.getHelpers()
        callbacks.setExtensionName(u"你好 Burp")
        print("你好 Burp")
```

如果要输出中文 一定要先声明

```
# -*- coding: utf-8 -*-
并且在需要使用(u"你好 Burp") 前面加个u

```

![image-20250515110104564](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250515110104564.png)

helper接口为

https://portswigger.net/burp/extender/api/burp/iextensionhelpers.html

# 路由检测

我们可以通过
```https://github.com/nxtrace/NTrace-core ```
更加直观了解
我是win

```
 winget install nexttrace
```

我们可以通过地图展示整个线路 希望快速使用就存入 **C:\Windows\System32** 即可
执行命令
```
nexttrace  <你的服务器IP> 
```
# 例子
就可以得到一个 URL 
下图是一个 路由去 CN2 GIA的 搬瓦工的 美国VPS 即使是个人买到最极值的 VPS 依旧 RTT高于100

![image-20250919223143927](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250919223143927.png)

所以实际上物理链路延迟是无法避免的 这里我再展示一个yxvm的3刀线路

![image-20250919223415676](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250919223415676.png)

亚洲云99元线路

# 实操
这里就操作最基本的内容
为了演示 我会使用两个服务器 进行演示 一个是 美国 一个是新加坡 
如果想购买 最下方有 `推荐（AFF）`的链接
## BHW 美国CN2GIA
### 执行命令
`nexttrace IP`

![](https://raw.githubusercontent.com/Xioaruan912/pic/main/1764166338058-8afa8257-971e-449d-9471-66f053947666.png)

可以看见 这里给出了我数据报的 传播 我是通过 `4837` 国内传输 也就是本地是联通网络
当然 为了直观 我们肯定要去看看 地图
### 看见传播动画

我们可以通过web界面 简单看见 数据的传播方法
![](https://raw.githubusercontent.com/Xioaruan912/pic/main/1764166140605-b5f38b2f-7c42-4b18-b00b-f143d393d887.gif)
还有许多配置 就留给大家了
## HighEndNetwork HK
这是一家直连香港路线 提供优质服务

![](https://raw.githubusercontent.com/Xioaruan912/pic/main/1764166363512-4e15163f-900c-45df-9ddd-2483969d7091.png)
可以看见 我们只需要20ms就可以连接
数据传播图如下

![](https://raw.githubusercontent.com/Xioaruan912/pic/main/1764166413440-40a575b7-b202-4bfb-8e36-53f9e165df4b.png)


# 购买链接
搬瓦工： `https://bandwagonhost.com/aff.php?aff=78674`
HighEndNetwork : `https://billing.highendnetwork.com/aff.php?aff=51`
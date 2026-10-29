这里我们进入PRF的说明

我们思考 如果Alice和Bob希望交流，那么必须要使用共享密钥

我们之前学习了PRG，我们可以基于短密钥产生长密钥

本节我们会介绍PRF，把PRG的思想进一步推进，基于PRF，我们可以把一个短密钥扩展到高效并且无限数量的秘密共享

# 6.1. Motivating and defining PRFs

这里我们讨论为什么需要PRF，之前我们已经有了PRG了，可以把短密钥产生到长的一个了 通过PRG的反馈构建

## Lazy random 字典

思考这个场景：

> 如果Alice和Bob希望通信一个字典结构的数据，并且里面的值是均匀采样随机的字符串

这个字典的键值也是一个字符串 位数是n位

键值的数据是m位的字符串

我们可以使用下面伪代码表示

![image-20261026105434766](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026105434851.png)

可以发现 在不同的X 会产生不同的随机值

但是 **如果我们调用相同的X 会产生相同的L[X]**

现在我们扩展 把n 变为安全参数*λ*

也就是让字典的项数变为了指数级大小，那么在上述伪代码中，我们需要指数级时间去初始化字典，因为要求事先准备好字典，那么对于调用程序来说，我们只可以在多项式时间内访问字典的一部分内容

但是思考一个问题，指数级时间不现实，我们如何构建‘指数级字典’在多项式时间？

我们可以转变思想，不要事先准备，而是调用时随机产生

也就是 lazy rand

![image-20261026105752451](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026105752490.png)

这两个唯一区别的就是 数据到底是事先准备好，还是在调用的时候产生

可以发现 输出的都是m位字符串，并且敌手可以多项式时间内视作是指数级别的，因为敌手完全不知道，他只知道自己一直无法访问完毕——当作指数级别

## Lazy random 字典应用PRF

那么这里我们就可以应用到PRF中了，我们要求PRF提供类似lazy random字典一样的功能

PRG：包含一个输入seed，产生伪随机的输出

PRF：包含两个输入，一个是seed，一个是键值X

F是一个PRF，满足F:{0,1}^λ X {0,1}^n ->{0,1}^m

可以把F当作一个查表的行为，只是输出的m采样收到了seed的影响

敌手可以控制X的输入，但是Seed作为密钥只允许保密

下面是正式的定义，并且说明了安全性

![image-20261026110333975](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026110334032.png)

记住PRF是一个确定性函数，所以他会将相同输入【包含相同的K的情况下】映射到相同输出中

上述定义说明了

> 如果密钥K是均匀选择并且保存妥善的，PRF的输出就是伪随机的，无论敌手如何选择输入X

## 密钥导出

密钥导出可以看作是PRF的一个经典应用场景：

AliceBob希望通过一个密钥，写入不同的密码学算法中，实现通信

在原语这个是不安全的，因为很多密码学算法都要求密钥从未使用过，但是这里做的是让一个密钥加入不同的算法中，违背了安全性

但是如果我们使用PRF就可以实现

PRF接受两个输入，一个是密钥记作K，一个是键值X

我们可以思考AliceBob的密钥为主密钥，作为PRF的输，X作为对应的加密函数名字，这样PRF会产生具有伪随机的子密钥，作为输入即可

- F(K,xyz) 作为XYZ算法的密钥
- F(K,abc) 作为ABC算法的密钥

因为PRF输出和均匀选择具有不可区分性，所以可以保证安全

# 6.2. How to attack PRFs

上面我们说明了PRF内容，下面我们可以说如何攻击一个PRF呢？

> PRF是一个确定性函数，对于相同输入会产生相同输出

这里就是我们攻击的关键点，但是我们不可以人为构建相同输入，观察相同输出，这个不是攻击，因为real和rand库都会产生这个内容，攻击是无意义的

我们会使用下面的例子来说明，如果一个PRF内部是配置错误的，就很容易攻击

## 6.2.1. A first example

![image-20261026111128699](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026111128747.png)

这里是一个不安全的PRF，他基于的是安全的G，通过和键值XOR产生输出

我们知道 对于G的攻击，我们聚焦的是错误使用G

> G是一个PRG，如果每次输入都是不同的，就是安全的PRG

这里是这样吗？ 很明显是错误的，PRF要求的是产生一个密钥，敌手可以构造不同的键值X，从而进行攻击

这里G(K) 一直都是使用相同的密钥，所以产生的伪随机值，可能可以被区分，从而变得不安全

那么我们基于XOR 也可以实现攻击

我们构建两个输入 输出

![image-20261026111358391](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026111358416.png)

通过对Y1 Y2 xor，就可以直接把相同项G(K)抵消得到X1⊕X2

把敌手设置如下：

![image-20261026111508753](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026111508781.png)

对于real 敌手攻击成功的概率都是1，可以完美区分

对于rand 敌手攻击成功的概率是 1/2^m，因为X1X2都是不同的，那么使用lazy rand产生的Y也是不同的，都是均匀选择的

## 6.2.2. A second example

这里的PRF也是不安全的 即使他使用了安全的PRF

![image-20261026111646679](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026111646735.png)

可以发现，他采样了两个密钥，然后使用两次PRF的输出作为XOR，可以发现 这里的所有内容都是随机的，X1X2是敌手自己选择的，Ki是完全随机采样的，那么这里安全吗？

也是不安全的

因为敌手可以控制输入，那么PRF是一个确定性算法，对于相同的输入，会产生相同的输出，所以敌手聚焦构建相同输入，让算法H输出的Y可以区分，这样就实现攻击了

首先敌手构造输入 A||B 和 A||B’ 这里A是相同的B不同

![image-20261026111838690](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026111838714.png)

通过下面公式可以得到

![image-20261026111923269](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026111923294.png)

可以发现 这里不同的只有人为构造的B了，同理我们再次构造A不同 B相同的输入

那么就可以基于上面的不同输入 产生下面

![image-20261026112003842](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026112003868.png)

我们开始构建

![image-20261026112023102](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026112023125.png)

那么敌手只要可以分辨出 Y1⊕Y2==Y3⊕Y4 敌手就成功了

因为在lazy random 字典中，这个也是均匀的

敌手在real方案中的获胜概率一直是1，只要自行构造出上面的内容即可

敌手在rand方案中获胜的概率一直是1/2^m 因为输出都是均匀采样的

## PRF的黄金准则

使用PRF的时候 需要保证不同的输入

- 对于攻击，我们可以寻找对于算法H的输入，使得其PRF部件得到相同输入，从而攻击成功
- 对于证明安全，我们需要保证算法H无论输入什么都不会导致F输出重复的内容

# 6.3. An example proof involving PRFs

上面我们学习了如何攻击PRF 这里我们开始说明 通过PRF自己构建出一个PRF算法，并且证明他的安全性

![image-20261026142424557](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026142424598.png)

H是一个安全的PRF 只要F是一个安全的PRF即可，换一句话说我们具有F库不可区分，使得H库不可区分

![image-20261026142504508](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026142504568.png)

## 证明安全性

我们如何进行证明其安全性呢

其实很简单 我们只要依旧遵循 提取 替换 就可以证明完毕 因为我们说明了 F是一个安全的PRF

![image-20261026143011994](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026143012030.png)

现在 我们把输出F(K2,Y) 替换 以便后续证明

![image-20261026143056419](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026143056453.png)

现在我们把 Y:=F(K1,X) 提取出去 因为他满足了 F的PRF



![image-20261026143131332](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026143131369.png)

使用 rand 替换这个 QUERY

![image-20261026143147962](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026143147999.png)

同样操作对 Y(K2,Y) 拆开

![image-20261026143221101](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026143221144.png)

删除无用代码 和替换为随机值

![image-20261026143249868](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026143249908.png)

我们还需要保证 这里采样的内容是排除了之前的内容，也就是不会导致重复输入

![image-20261026143330458](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026143330491.png)

那么这里最终也是满足了 Rand 直接替换 证明完毕

![image-20261026143353999](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026143354028.png)

# 6.4. Building a PRG from a PRF: The CTR construction

这里会介绍 使用CTR模式 去使得PRF 构建出PRG

CTR就是计数器模式 我们可以设立一个i 让他自增 从而构建出密码方案

理论上我们需要使用简单的PRG去构建出复杂的PRF，但是实际上相反，我们需要通过PRF去获得PRG，因为PRF很简单

下面就是一个PRG例子 使用CRT构建出来的

![image-20261026180429526](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026180429611.png)

可以发现最后产生的G 是一个PRG 他把 安全参数的输入扩展到km

我们下面说明他的安全性

> 如果使用的PRF是安全的，那么基于CRT构建出的PRG 也是安全的

![image-20261026180523949](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026180524009.png)

这里不可以直接套用PRF的安全从而证明 我们思考为什么

- PRG的安全性，除了自己的构造 还基于一次seed只能使用一次
- PRF的安全性，除了自己的构造 还基于一次seed使用多次

可以发现我们是构造PRG，所以我们要求seed只能使用一次，但是我们之前证明的PRF的安全是密钥使用多次的情况下，所以不可以直接套用

## 混合序列

我们使用混合序列的方法证明，他具有下面内容

1. 敌手每调用一次 `prg.sample`，我们就在证明中安排一步 Hybrid 转换
2. 对于Hybrid 转换  h是整数，h之前都是使用 PRG.rand h之后都是使用PRG.real

基于上面两个内容 我们就可以分析 h+1和h混合中敌手是否可区分了

这样两个混合之间就只差一个G的调用——也就是到底是real还是rand，那么这里就固定了 PRF的seed 只调用一次，于是可以使用PRF安全问题 考虑h+1是否可区分了

![image-20261026180914610](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026180914650.png)

上图就很清晰了，h+1次才会产生不同

那么我们对混合库 构建成下面这样

![image-20261026181034108](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026181034150.png)

这个就是我们上面说到 h之前rand 之后real

那么我们其实可以思考这三个区间

- 对于L0 他一定是real的 因为他都走 else，所以和real是**可交换的**
- 对于Lq 这个q是多项式敌手调用的最大次数，一定是rand 因为他走的都是if，所以和rand是**可交换的**
- 对于中间值h，我们需要证明不可区分

那么最终我们就可以证明出来

![image-20261026181152323](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026181152354.png)

那么下面进入具体证明 和中间阶段的即可 我们需要证明的是 h 可以和h+1变为不可区分性的

那么这里我们尝试 构建出分支 h+1 让他走else 【因为起始是h】

![image-20261026181332179](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026181332230.png)

下面我们聚焦于 PRF 提取出去

![image-20261026181355128](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026181355173.png)

写回后就可以说明 PRF安全【因为这里基于单个SEED】 所以我们直接可以写入随机值

![image-20261026181429737](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026181429787.png)

然后我们就可以加入 if 语句中了 因为表达意思完全一致

![image-20261026181454807](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261026181454842.png)

那么这里不就是 h+1的混合了吗 证明完毕了
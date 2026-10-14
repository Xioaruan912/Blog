# BLS 论文阅读笔记

**论文**：Short signatures from the Weil pairing  
**作者**：Dan Boneh、Ben Lynn、Hovav Shacham  
**原文页码**：516–534

## 目录

- [1 引言](#1-引言)
- [2 基于 Gap Diffie–Hellman 的签名方案](#2-基于-gap-diffiehellman-的签名方案)
- [3 构建具有短表示的 GDH 群](#3-构建具有短表示的-gdh-群)
- [4 安全性定理的证明](#4-安全性定理的证明)
- [5 实验结果](#5-实验结果)

## 1 引言

> 原文：第 516 页

### 1.1 背景

这里是简单介绍了全文的背景<span style="color: rgb(255, 32, 32);">为什么需要</span>这个内容

1. 如果人类要<span style="color: rgb(255, 32, 32);">手工输入</span>签名，那么就需要短签名的产生
2. 如果我们的信道是<span style="color: rgb(255, 32, 32);">低带宽</span>，那么我们也需要短签名来传输

但是当时的环境下 RSA和DSA都提供了长签名

虽然有人探讨过 使用  变体椭圆曲线的ECDSA 也需要320bits长度，人类手工输入320bits还是太长了

### 1.2 作者的签名方案

BLS签名方案长度是DSA的一半也就是 160bits，但是安全性程度和320bits的DSA一样

主要抵抗的选择明文攻击的存在性伪造攻击
只要<span style="color: rgb(255, 32, 32);">基于特征3的有限域上的椭圆曲线的CDH是困难的</span>【无法解决】那么我们的签名方案就是安全的

通过标量乘法产生签名，通过双线性配对进行验证【这些都会在后面提到】

下面是基于本论文椭圆曲线产生的不同长度的签名方案【还不可以产生任意长度】

![原文截图：1.2 作者的签名方案](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261012195454175.png)

### 1.3 别人对短签名的尝试

前人<span style="color: rgb(255, 32, 32);">有尝试缩短DSA的签名长度</span>，但是依旧保持相同的安全

通过消息恢复的方法缩短DSA的签名长度
通过一次编码一部分，从而让全体都缩短

如果对于长消息 那么确实可以做到缩短为160bits
但是对于短消息，那么可能会反而导致扩展到 320bits

<span style="color: rgb(255, 32, 32);">我们的签名方案是不约束消息</span>的，都会生成长度为 160bits的签名

### 1.4 原理简述

这里签名方案是基于一个群——<span style="color: rgb(255, 32, 32);">CHD计算困难，但是DDH判断简单</span>

我们把满足上面的群叫做Gap DH群 或者叫做短GDH群

虽然之前有人基于GDH群产生签名方案，但是都是产生长签名方案，而不是短签名方案

## 2 基于 Gap Diffie–Hellman 的签名方案

> 原文：第 517 页

这里说明了签名方案 他是基于GDH群构建的

### 2.1 GDH 群的定义

> 原文：第 518 页

这里就介绍了 GDH群是什么

下面先引入一个群G 还有一些内容

1. 一个乘法群G 是一个循环群 $\langle g\rangle$ ，并且阶数是素数p——素数乘法循环群
2. 群运算是乘法：u,v in G find uv
3. <span style="color: rgb(255, 32, 32);">DDH问题</span>：a,b,c in $\mathbb{Z}_p^*$ 给定 $(g,g^a,g^b,g^c)$ ，要求判断c?=ab
4. <span style="color: rgb(255, 32, 32);">CDH问题</span>：a,b in $\mathbb{Z}_p^*$ 给定 $(g,g^a,g^b)$ ，要求计算出 $g^{ab}$

上面就是介绍了CDH DDH 还有这个群G的基本信息 下面开始正式定义出GDH群

定义1：G是一个<span style="color: rgb(255, 32, 32);">t-DDH</span>群 如果对于群运算可以在一个单位时间内执行，并且DDH可以被在t时间内计算完毕

![原文截图：2.1 GDH 群的定义](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092706214.png)

<span style="color: rgb(255, 32, 32);">【下面定义出攻击者】</span>

定义2：窃听者<span style="color: rgb(255, 32, 32);">A尝试去解决CDH</span>难题在G上并且概率定义如下：

![原文截图：2.1 GDH 群的定义（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261012195800663.png)

如果攻击概率超过投硬币正反概率，那么我们认为A是一个在G上(t,c)攻破CDH难题的算法，其中t是最多运行时间，c是最低攻破概率

![原文截图：2.1 GDH 群的定义（3）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092702962.png)

定义3：一个素数群G如果不存在任何(t,c)攻破CDH算法的存在，那么就是一个(t,T,c)的GDH群

![原文截图：2.1 GDH 群的定义（4）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092700986.png)

<span style="background-color: rgba(255, 102, 102, 0.5);">【基于DDH简单，CDH困难 从而定义出GDH群】</span>

到此位置我们已经知道了 GDH群就是CDH难 但是DDH简单的群

### 2.2 GDH 签名方案

> 原文：第 518 页

我们知道了GDH 那么开始基于GDH构建签名算法

<span style="background-color: rgba(255, 102, 102, 0.5);">【现在讨论的都是基于GDH群，还没有到椭圆曲线问题】</span>

先了解一下GDH签名方案的IO和系统参数

输入：是允许任意长度的M

输出：签名o，并且这个<span style="color: rgb(255, 32, 32);">签名是G中元素</span>

系统参数：基本群G和生成元g

我们定义 $G^*$ 是G排除1的集合

一个正常的签名方案存在三个程序，但是BLS还存在一个全域哈希函数h，目标是把<span style="color: rgb(255, 32, 32);">输入的消息M映射到 $G^*$ 上</span>，这里我们先认为他是 随机预言机，后续会具体说是什么和如何构建的

**Key Generation**

产生私钥和公钥的，从完全剩余中随机选择x in $\mathbb{Z}_p^*$ ，由私钥计算公钥 $v=g^x$

**Signing**

使用私钥x和消息M，先使用随机预言机计算 $h=h(M)$ 得到哈希结果，然后计算签名 $o=h^x$ 这个签名o in $G^*$

**Verification**

给定公钥v M 和o 先使用哈希计算 h 然后验证 $(g,v,h,o)$ 是否是一个合法的DDH群

因为签名o是 $G^*$ 上的元素 所以要求元素也是短的 这样才可以实现短签名

### 2.3 安全性

> 原文：第 519 页

分析一下GDH 基于 选择明文攻击的存在性伪造的安全性

下面定义的是<span style="color: rgb(255, 32, 32);">直接攻击 签名BLS的算法F</span>和攻击概率

![原文截图：2.3 安全性](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092658231.png)

询问的预言机 不会产生以前询问过的内容

下面开始定义 攻击BLS的算法

F是一个(t,qH,qS,c)攻破BLS签名算法，如果F运行时间为t 并且最多问询qH次哈希预言机，最多问询qS次签名预言机，并且攻破概率大于可忽略概率

![原文截图：2.3 安全性（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092656404.png)

基于F定义出BLS的安全

签名方案是(t,qH,qS,c)抵抗基于选择明文攻击的存在性伪造的安全签名算法如果没有任何F可以攻破

![原文截图：2.3 安全性（3）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261012195802794.png)

最后就是定义出基于这个GDH群构建的算法是安全的

![原文截图：2.3 安全性（4）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092653587.png)

在第四章有说明这个如何证明的

## 3 构建具有短表示的 GDH 群

> 原文：第 519 页

上面说过了GDH群是什么，但是如何构建得到GDH群呢——<span style="background-color: rgba(255, 102, 102, 0.5);">椭圆曲线</span>

### 3.1 椭圆曲线与 Weil 配对

> 原文：第 520 页

什么时候椭圆曲线可以被看作是GDH群？

只要满足GDH群性质即可：带有大素数阶的群G 在计算CDH是困难的 但是DDH是简单的

#### 安全乘子的定义

我们只要知道 这个定义即可 具有什么性质先不要管

![原文截图：安全乘子的定义](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092413592.png)

1. 因为P的阶数是m P为E的点 E有m个点
2. 基于拉格朗日定理 $q\mid m$
3. 所以实际要求  $q\mid m$ $q^2\nmid m$ 、
4. q是m的素因子，但是m不包含q^2这个因子

如果<span style="color: rgb(255, 32, 32);">p^l在乘法群 $\mathbb{F}_p^*$ 中的阶数是a</span> 那么我们认为子群 $\langle P\rangle$ 的安全乘子是a

前面那个阶数的数学表达就是：

![原文截图：安全乘子的定义（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092413601.png)

也就是书上的那个 $q\mid p^{la}-1$

第二个公式说的是在 a之前，没有更小的正整数指数可以得到 1

<span style="color: rgb(255, 32, 32);">安全乘子 a 就是  p^l 在模 q 乘法群中的阶</span>

对于CDH的要求 a不能太小 否则无法抵抗CDH

对于DDH的要求 a不能太大 否则无法高效计算

> 【不要深究为什么 后面会说 为什么】

后面我们会知道 $a=6$ 在超奇异椭圆曲线上是最优解

#### 椭圆曲线上的离散对数

> 【<span style="background-color: rgba(255, 102, 102, 0.5);">同时解释了 安全乘子a的作用</span>】

如何在椭圆曲线上计算离散对数呢

首先我们设定一个前提

$\langle P\rangle$ 是一个基于E/ $\mathbb{F}_{p^l}$ 阶数为q的子群，并且具有安全乘子a，开始在 $\langle P\rangle$ 上尝试解决离散对数问题

##### MOV 方法

使用一个高效的可计算同构——把基于 $\langle P\rangle$ 的离散对数难题映射到对 $\mathbb{F}_{p^l}$ 的扩展中也就是 $\mathbb{F}_{p^{li}}$

我们要求 $\langle P\rangle$ 的像在这个同构中变为 $\mathbb{F}_{p^{li}}^*$ 的子群 并且阶数也是q

这里的i 满足安全乘子的定义

所以<span style="color: rgb(255, 32, 32);"> MOV 可以让 $\langle P\rangle$ 转化为大域的离散对数难题</span>

所以a要大 才可以转化为大域中

> 【a 就是 有限域的扩张次数】

##### 通用算法（Generic）

如果直接计算离散对数难题 那么我们要求q 要很大

所以CDH问题 在GDH上要求 a和q都大

#### 椭圆曲线上的 DDH 判定

上面说了 CDH的难解性 这里说明DDH简单

P是E的点 阶数q并且 $\langle P\rangle$ 具有安全乘子a

我们假设 $q\nmid p^l-1$

在<span style="color: rgb(255, 32, 32);">同一条椭圆曲线在不同有限域</span>上有另一个点 Q和P<span style="color: rgb(255, 32, 32);">线性无关</span>——那么就可以使用weil配对进行验证

##### Weil 配对

这里先介绍weil配对，他就是可以把椭圆曲线的两个点映射到离散对数上

存在一个映射e：

输入： $E[q]$ 【椭圆曲线E上qP=O 的点构成的群】中的 两个点

输出： $\mathbb{F}_{p^{la}}^*$ 扩域中的一个非零元素

<span style="background-color: rgba(255, 102, 102, 0.5);">注意weil配对不要求两个点线性无关，是BLS要求的</span>

##### Weil 配对的性质

1. 同一性： $e(r,r)=1$
2. 双线性：<span style="color: rgb(255, 32, 32);"> $e(aR_1,bR_2)=e(R_1,R_2)^{ab}$ </span>
3. 非退化性： $e(R,R^{\prime})=1$ 如果R‘是E上q群中的任意点，R=O
4. 可计算的： $e(R_1,R_2)$ 可以被高效计算

线性无关保证了 不存在同一性和非退化性

我们主要利用的就是 双线性和可计算性

##### DDH 判定方式

知道了weil配对内容 我们下面探讨如何解决DDH

回顾一下

<span style="background-color: rgba(255, 102, 102, 0.5);">【标准DDH】</span>

给 $(g,g^a,g^b,g^c)$

判断 $g^{ab}$ ?= $g^c$

相当于判断 $ab=c\pmod q$

下面作者开始将非标准向标准DDH靠拢

<span style="background-color: rgba(255, 102, 102, 0.5);">【非标准DDH】</span>

$(P,aP,Q,bQ)$ 通过weil配对进行判别标量是否相同

使用两次weil配对分别计算

$$
e(P,bQ)=e(P,Q)^b
$$

$$
e(aP,Q)=e(P,Q)^a
$$

从而判定 $a\mathrel{?=}b\pmod q$

这里可以发现 weil配对可以比较得到 两个不同点的标量是否相同，所以我们尝试转向标准DDH去

> 【增加可计算同构】

o 作为一个同构 把群 $\langle P\rangle$ 同构到 $\langle Q\rangle$ 中

设定计算： $o(aP)=axQ$ 其中 $xQ=o(P)$

现在有可计算同构后 给定标准DDH四元组

$(P,aP,bP,cP)$ 通过两次weil配对和可计算同构转化得到

$$
e(P,o(cP))=e(P,cxQ)=e(P,Q)^{cx}
$$

`e(aP,o(bP))=e(aP,bx2Q)=e(P,Q)^abx`

这里的x是同一个x 由此 ab ?= c mod q可以验证 从而破解DDH难题

### 3.2 特殊的超奇异椭圆曲线

> 原文：第 521 页

上面说明了 椭圆曲线如何实现CDH困难，DDH简单，下面开始说明一个具体的椭圆曲线——<span style="color: rgb(255, 32, 32);">超奇异椭圆曲线</span>

$$
Y^2 = x^3 + 2x + 1
$$

基于 $\mathbb{F}_{3^l}$

#### 为什么使用这类超奇异曲线

因为我们上面说了 需要一个高效计算的同构，把点P映射到扩域中的点Q并且是线性无关的

$\langle P\rangle$ -> $\langle Q\rangle$ 超奇异椭圆曲线可以找到并且高效的找到

#### 安全乘子的确定

我们上面说 $a=6$ 下面给出查找到的过程

现在定义出两个 超奇异椭圆曲线 并且要求他们满足点的数量

![原文截图：安全乘子的确定](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092646437.png)

这里给出作者选好的椭圆曲线，并且说明 如果l的值知道了 那么这个椭圆曲线的点数也知道

下面说知道点数的意义是什么——尝试去证明6是本椭圆曲线的安全乘子

![原文截图：安全乘子的确定（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092644757.png)

这里就是说明 a|3^6l-1 从而得到 <span style="color: rgb(255, 32, 32);">6为a安全乘子的最大值</span>

1. q是m的因子【因为子群 $\langle P\rangle$ 阶数q】
2. 从而 $q\mid 3^{6l}-1$ ，基于安全乘子定义
3. $a\mid 6$

但是安全乘子要求是最小正整数 ，所以我们还要排除 {1,2,3}，可以通过证明 论文没有展开说明

#### 可计算同构

上面我们说了 需要一个可计算同构，将非标DDH 转化为DDH 这里开始说如何构建

我们从 扩域中找到3个元素 u,r+,r- ,满足下面公式：

1. $u^2=-1$
2. $r_+^3+2r_++2=0$
3. $r_-^3+2r_--2=0$

只要得到这三个 就可以构建出 具体的 同构o

![原文截图：可计算同构](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092642526.png)

下面说明只要有这个在扩域上的同构，在 $\mathbb{F}_{3^l}$ 上的点P 扩域被同构为一个在扩域上线性无关的点

到此位置 我们构建出了 满足<span style="color: rgb(255, 32, 32);">GDH的椭圆曲线，安全乘子，同构</span>

到此 一个完整的GDH群都实现了

### 3.3 哈希到椭圆曲线

> 原文：第 522 页

注意 这里进入的是GDH签名，之前已经构造了GDH群了 现在进入签名方案

签名需要一个哈希函数 让输入的消息 映射到 $G^*$ 上【GDH群去掉1】

GDH群又是基于椭圆曲线的点产生的子群构建的

但是我们非常难在椭圆曲线的子群上找到这个哈希算法实现映射，所以我们修改了程序

E/ $\mathbb{F}_{p^l}$ 是一个椭圆曲线 并且阶数m 形式为 y^2 = f(x)的

P in E 阶数为q 并且 q^2 !\ m

基于P设定一个群 作为GDH群 $\langle P\rangle$ 开始构建签名方案

现在 我们基于<span style="color: rgb(255, 32, 32);">标准密码学算法</span>构架出一个哈希函数h’：{0,1}\* -> $\mathbb{F}_{p^l}$ x {0,1}

输入是任意长度的消息

输出是GDH群上的点和随随机比特01

我们现在把这个h‘视为随机预言机

下面开始讨论 MapToGroup这个哈希程序【有两个哈希程序】

要求是 {0,1}\*-> $G^*$

开始说明之前我们固定参数 I

![原文截图：3.3 哈希到椭圆曲线](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092640219.png)

δ为失效概率的期望界

#### MapToGroup 算法

1. 给M {0,1}\* 并且设定i=0【这个是执行次数】

2. 运行随机预言机h得到输出(x,b)

3. 计算f(x)如果<span style="color: rgb(255, 32, 32);">是二次剩余 </span>就做

    1. 计算f(x)的平方根 y0 y1
    2. 用有限域元素的多项式表示来确定这两个根的顺序，并按<span style="color: rgb(255, 32, 32);">常数项的大小排列</span>【这里的意思是用常数项排大小，y0 y1顺序要严格 y0常数\<y1】
    3. 使用随机比特b 确定选择 y0还是y1【排序后的】
    4. <span style="color: rgb(255, 32, 32);">输出点Pm^~ </span>坐标是(x,y\_b)
    5. 计算Pm(m/q)Pm^\~ 并且确定Pm在G中
    6. 如果<span style="color: rgb(255, 32, 32);">Pm在 $G^*$ 中 那么就输出 Pm</span> 当作哈希结果 算法阶数

4. 如果f(x)都没有二次剩余 自增i 进入step2，如果i到达 $2^I$ 程序失败

每次成功运行的概率是 $1/2$

所以h' 期望调用2次

到此 {0,1}\*-> $G^*$ 的MapToGroup也定义完毕了

#### 安全性证明

![原文截图：安全性证明](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092637567.png)

这里要证明 使用 MapToGroup是和使用随机预言机h 具有一样的安全性

F’：攻击带有MapToGroup的BLS签名

F：攻击具有随机预言机哈希h的BLS签名

1. F主动调用F’，并且使用 随机预言机h去模拟 MapToGroup

    1. 使用一个二维数组 里面的元素是 之前MapToGroup中密码学哈希函数的元素
    2. 初始化的时候 sij会被(xi,b) 填充满
    3. F会追踪F'运行的时候对所有不同消息 所请求的h'哈希
    4. F只要收到没有遇见过的消息，去那一行开始计算 类似MapToGroup的step3 一个一个计算过去 直到计算出 $G^*$ 结果
    5. 【核心】F将会把自己h生成的预言结果哈希替换这个值

2. F通过自己随机生成的哈希交给F’，如果F’可以攻破带有MapToGroup的BLS，那么F也可以攻破带有随机预言机h的BLS

到此安全归约完毕 因为我们说h是安全的，所以不存在F’ 可以攻破带有MapToGroup的BLS

### 3.4 具体的短签名方案

> 原文：第 524 页

到这里为止 所有都有了 GDH群 MapToGroup哈希程序 所以可以构建真正的BLS签名方案了

使用椭圆曲线 y^2 = x^3 +2x +-1 构建出GDH群  

使用MapToGroup 去让Message映射到E的点上

对于不同的l 具有不同的签名长度和安全性，如下图：

![原文截图：3.4 具体的短签名方案](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092635121.png)

#### 具体签名方案

**Key Generation**

使用上表选择一个l 构建对应的椭圆曲线E， E上阶为素数 q 的点 P，构造素数阶加法循环群G= $\langle P\rangle$ ，随机从剩余类q中得到x 作为私钥，计算xP得到R 设立四元组(l,q,P,R)作为公钥

**Signing**

给定M，经过算法MapToGroup映射到 $G^*$ 得到点Pm 计算签名 xPm->Sm，输出x坐标作为签名o

**Verification**

得到o 公钥(l,q,P,R)和消息M

1. 通过x坐标查找椭圆曲线上满足x坐标的点S，如果没有直接失败
2. 设定<span style="color: rgb(255, 32, 32);"> u = e(P,o(S)) v=e(R,o(h(M)) </span>这里的e是weil配对，o是上面提到的同构
3. 如果u=v 或者u=v^-1 验证成功 否则失败

我们来看看是不是我们之前说的那样计算两次weil实现验证

$$
S=xh(M)
$$

h(M)=kP【这里因为在 $G^*$ 上 所以可以使用生成元表示】

1. $e(P,o(xh(M)))=e(P,o(xkP))=e(P,xkQ)=e(P,Q)^{xk}$
2. e(R,o(h(M)) =e(xP,kQ)=e(P,Q)^xk

可以发现 很简单就可以check是不是DDH了

#### 安全性证明

这里的安全性和证明MapToGroup类似的规约方法

![原文截图：安全性证明（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092632286.png)

这里其实第四章会说如何证明 这里简单规约一下

G是一个GDH群，MapToGroup看作是随机预言机，在GDH安全分析中我们知道

![原文截图：安全性证明（3）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092415962.png)

现在把预言机转化为MapToGroup

由于随机预言机的时间损失 所以时间变为了

![原文截图：安全性证明（4）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092628548.png)

设立A攻击带有随机预言机的BLS签名

F攻击带有MapToGroup的签名

A开始运行F 如果可以攻破 说明A也可以攻破带有随机预言机的BLS，违背了之前的安全性 所以失败【具体的第四章会说到】

### 3.5 开放问题：具有更高安全性的短签名

> 原文：第 526 页

这里开放了一个问题，如何提升安全性在BLS中

作者提出两个

1. <span style="color: rgb(255, 32, 32);">不使用超奇异椭圆曲线</span>
2. <span style="color: rgb(255, 32, 32);">使用更高亏格的超奇异椭圆曲线</span>

我们聚焦第一个

在不是超奇异椭圆曲线上使用更大的a 虽然会增加验证的消耗，但是对Mov攻击具有更强的抵抗——在签名比特长度相近的情况下

其实主要关注的点就是 构建出两个 线性无关的点，阶数都是q 一个属于原本椭圆曲线，一个属于扩域椭圆曲线【<span style="color: rgb(255, 32, 32);">这两个椭圆曲线都是一样的</span>】

不再使用同构的方式-因为在标准椭圆曲线下，不一定存在那种同构

转化为直接使用 使用这两个群 $\langle P\rangle$ $\langle Q\rangle$

#### co-DH 问题

基于这个不同群 产生coDH问题

<span style="color: rgb(255, 32, 32);">co-DDH</span>：这里基于weil配对是很简单解决co-DDH的【不知道a和b的值】

<span style="color: rgb(255, 32, 32);">co-CDH</span>：给出三元组，并且不知道a 计算aP

下面是作者提出的 <span style="color: rgb(255, 32, 32);">co-GDH签名方案</span>

**Key Generation**

PQ 来自一条的椭圆曲线——扩域和没有阔，并且他们的阶数相同 还是线性无关的，基于q的剩余类中随机选择x 作为私钥，使用Q 进行参与计算得到(E/F\_p^l,q,Q,R)作为公钥

**Signing**

给定M，经过算法MapToGroup映射到 $G^*$ 得到点Pm 计算签名 xPm->Sm，输出x坐标作为签名o

**Verification**

得到o 公钥(E/F\_p^l,q,Q,R)和消息M

1. 通过x坐标查找椭圆曲线上满足x坐标的点S，如果没有直接失败
2. 设定 u = e(Q,S) v=e(R,h(M) 这里的e是weil配对，o是上面提到的同构
3. 如果u=v 或者u=v^-1 验证成功 否则失败

依旧分析一下验证程序

1. $e(Q,S)=e(Q,xh(M))$
2. $e(R,h(M))=e(xQ,h(M))$

可以发现 依旧可以得到 co-DDH简单问题，不使用同构， 不使用超奇异椭圆曲线 依旧可以做到 BLS签名

但是如何构造安全乘子a 更大的椭圆曲线，仍然是一个研究难题

到此 具体GDH群构建，MapToGroup构建，BLS签名构建，co\_BLS签名构建都结束了

## 4 安全性定理的证明

> 原文：第 527 页

之前我们探讨的内容都是基于GDH在随机预言机下都是安全的情况下，说明具体GDH安全

这里开始具体分析在 <span style="color: rgb(255, 32, 32);">GDH群下通用GDH签名方案 是否真实安全</span>

首先给出定理 说明G如果是一个GDH群 那么基于这个群产生的GDH签名方案是安全的，可以抵抗已知明文攻击的存在性伪造

![原文截图：4 安全性定理的证明](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092624815.png)

![原文截图：4 安全性定理的证明（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092623335.png)

时间与概率为下图：

![原文截图：4 安全性定理的证明（3）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092419963.png)

这个我们在之前都遇见过

### 4.1 证明概述

> 原文：第 528 页

这里就是下面所要讲解的大概内容，下面部分是具体如何构建A和F并且分析安全性

这里我们先总体概述一下 两个攻击算法

F：直接攻击通用BLS签名方案

A：直接攻击CDH难题，运行F

1. A运行F进行攻击BLS
2. F会进行两次闻讯 一次是哈希 一次是签名
3. F会输出哈希和签名 然后使用伪造消息M\* 生成伪造签名 也输出给A
4. A收到后 维系一个表 内容是每个消息、哈希、签名【如果有的话】

   ![原文截图：4.1 证明概述](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092619893.png)

5. 然后使用F返回的伪造签名 去挑战CDH

### 4.2 算法 A 的构造

> 原文：第 528 页

由于A要做的事情非常多，所以我们会让A不断进行闯关，不断增加A的变体并且允许F，直到最后一个变体——A6 就是我们上面所提到的A

并且在每个游戏中 会分析增加的内容是否影响了F成功概率 下面开始探讨

#### Game 1

A1被给出 $(g,g^a,g^b)$ 的CDH难题，初始化参数 公钥： $g^a$ ，然后对于每个i【i的上界是闻讯哈希次数】都有一个<span style="color: rgb(255, 32, 32);">随机概率B返回一个随机bit si</span>——【B会按照c的概率返回1,1-c的概率返回0】从q的完全剩余类中返回ri 这个其实就是私钥 然后开始<span style="color: rgb(255, 32, 32);">计算哈希 $h_i=g^{r_i}$ </span>【这里因为A1不知道私钥a，所以是直接构建自己的哈希】然后就是<span style="color: rgb(255, 32, 32);">签名 $o_i=(g^a)^{r_i}$ </span>——这里是使用自己的哈希仿造BLS因为他不知道私钥

<span style="background-color: rgba(255, 102, 102, 0.5);">这里可以发现A1不知道私钥的信息，所以自己伪造私钥去构建哈希和签名从而应对F的问询</span>

得到BLS四元组 $(g,g^a,h_i,o_i)$ 如果是一个GDH 那么就认为是一个BLS签名

上面就是GAME1完整的定义内容 需要深刻记忆

下面是GAME1运行过程

1. F对Mi进行请求hash

2. A1 返回自己构造的哈希hi

3. F对Mi进行请求签名

4. A1 返回自己构造的签名oi

5. F 收到后会停止 分为两个情况

    1. 失败，伪造的内容无法通过签名认证
    2. 成功，基于A给的信息产生一个新的伪造签名(M\* ,o\*)【<span style="color: rgb(255, 32, 32);">o*是F没有向A1请求过的</span>】

6. A1基于F的成功与否 就会输出 成功或者失败

到这里整个内容都结束了 我们开始分析一下A1成功打破CDH的概率

1. A选择的r产生的哈希和签名都是基于q的完全剩余类随机产生的—— $1/2$
2. F接受到A的内容，视为随机预言机

![原文截图：Game 1](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092616130.png)

上面是对A1的概率定义 进行延申就是到F是否可以通过验证程序

![原文截图：Game 1（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092614727.png)

所以 A1成功概率就是 F成功攻破BLS的概率 e

#### Game 2

基于GAME1产生的内容增加一点点

1. 如果F失败 那么A2直接输出失败

2. 如果F成功，输出了伪造对，那么A会输出失败或者成功

    1. s\_i^\* = 1的时候 输出成功
    2. s\_i^\*  = 0的时候 输出失败
    3. <span style="color: rgb(255, 32, 32);">s_i^* 是s 和 i* i*是选择第i个进行伪造的意思</span>

可以发现 这里对F没有任何操作

但是对A来说 需要判别si 是不是为1

si是从B中按照c的概率随机抽取的=1

所以A的获胜概率如下：

![原文截图：Game 2](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092612175.png)

#### Game 3

基于GAME2继续增加内容

1. 如果F失败 A也宣布失败

2. 如果F成功 A会在下面情况宣布成功 否则失败

    1. F伪造的消息si标识为1
    2. F请求签名的消息 si标识都为0
    3. 上面这两个就是：<span style="color: rgb(255, 32, 32);">必须成功伪造一个有效签名，且该消息此前没有请求过签名</span>

在这里依旧是对A3宣布胜利的情况进行要求 但是增加了前面请求si都要为0的情况

![原文截图：Game 3](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092610161.png)

后面乘上的也就是 前面请求si都要为0的情况

之前请求过签名的<span style="color: rgb(255, 32, 32);"> k 条不同消息</span>，其 si 全部为 0的概率为 $(1-c)^k$

#### Game 4

基于GAME3继续增加内容

1. 如果F对si=1的消息请求签名，A直接宣布失败

因为A和F的随机性，共同决定了选择消息的si

我们可以认为 <span style="color: rgb(255, 32, 32);">si=1是不幸运的</span>，即使F找到了伪造 但是由于不幸 所以A依旧宣布失败，这里A4的修改没有触及概率问题

![原文截图：Game 4](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092607844.png)

#### Game 5

基于GAME4继续增加内容

1. 在A的初始设置阶段进行修订
2. 如果遇见si=1的Message 直接设定哈希为 $g^b\cdot g^{r_i}$ ，签名使用一个占位符说明
3. 如果遇见si=0的Message 就是和之前一样 计算哈希和签名返回

这里我们解决两个问题

1. 为什么设定哈希为 $g^b\cdot g^{r_i}$

    1. A的最终目标是计算出 $g^{ab}$ 【ab都不知道】
    2. 把 $g^b\cdot g^{r_i}$ 带入标准BLS的签名算法中 可以得到
        1. 

![原文截图：Game 5](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092422272.png)

    3. 可以发现 A其实知道里面的 $g^{ar_i}$
    4. 如果F可以解决si=1的伪造签名
    5. 那么A就可以破解得到 $g^{ab}$

2. 为什么A5修改了哈希，F依旧可以尝试伪造

    1. G是一个素数循环群
    2. ri是 $\mathbb{Z}_p^*$ 下的随机选择 这个时候乘了g^b 相当于<span style="color: rgb(255, 32, 32);">重新排列</span>所有可能的指数
    3. 所有值仍然出现一次，概率不变

我们理解上面内容就知道了 A面对si=1的时候可以提供哈希，但是由于无法破解CDH难题 无法提供 签名

如果F可以破解伪造 si=1的签名 那么A就可以实现得到 $g^{ab}$ 破解CDH

由于GAME5 只是是修改了A5的setup，所以概率依旧没有变化

![原文截图：Game 5（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092550324.png)

#### Game 6

基于GAME5继续增加内容

1. 只是修改了A5宣布胜利的时候，A6也要输出 o\* / $g^{ar_i}$ 的结果【也就是 $g^{ab}$ 】

依旧没有修改概率内容 所以概率依旧是

![原文截图：Game 6](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092422571.png)

如果A6成功输出，那么CDH难题破解，算法成功

到这里我们就学习了BLS如何一步一步设立游戏，不断增加A的功能，然后分析概率，从而归约成功的

### 4.3 优化与结论

> 原文：第 530 页

下面就是正式的总结和优化了

上面攻击成功概率我们可以发现，我们只可以对c进行调优，也就是<span style="color: rgb(255, 32, 32);">B出现1或者0的概率</span>

论文发现 如果使用k = qS的时候 是最优解

![原文截图：4.3 优化与结论](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092423930.png)

把这个带入 A攻击成功概率中 可以计算得到

![原文截图：4.3 优化与结论（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092545101.png)

如果qS不断增大 就可以接近 <span style="color: rgb(255, 32, 32);"> $1/e$ </span>

下面开始分析运行时间

A的额外开销就是 回应F请求的签名和哈希

每一次都需要 2lgP的群计算 那么次数最多是(qS+qH) 增加上一个额外c\_A 得到最终时间

![原文截图：4.3 优化与结论（3）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092542838.png)

所以下面定理说的是：

如果存在伪造签名算法F 可以打破BLS 那么就存在算法A可以攻破CDH 并且时间与概率为

![原文截图：4.3 优化与结论（4）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092424413.png)

反过来说：

如果G是一个安全的GDH群 那么就不存在一个F 可以攻破GDH签名方案，并且这个F的攻击时间和概率为：

![原文截图：4.3 优化与结论（5）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092538520.png)

这里就是移项

## 5 实验结果

> 原文：第 531 页

### 5.1 实现细节

> 原文：第 531 页

这里探讨的是<span style="color: rgb(255, 32, 32);">实际工作中对BLS的优化</span>

首先作者说明 <span style="color: rgb(255, 32, 32);">验证才是花时间的大头</span>

验证需要计算两次weil配对 并且基于 $\mathbb{F}_{3^{6l}}$ 这个非常大的有限域

所以作者开始优化

#### 有限域优化

作者不聚焦于 $\mathbb{F}_{3^{6l}}$ 而是<span style="color: rgb(255, 32, 32);">变为l次的 $\mathbb{F}_{3^6}$ </span>

并且设立一个查询表，目的是为了让两个元素乘法更快得到

然后作者说 因为 $\mathbb{F}_{3^6}$ 里面的任意元素都可以用<span style="color: rgb(255, 32, 32);">生成元来代替</span> 那么这里又可以简化有限域里的乘法除法加法运算了

<span style="color: rgb(255, 32, 32);">乘法</span>：两个元素相乘，转化为基于生成元的<span style="color: rgb(255, 32, 32);">指数相加</span>

<span style="color: rgb(255, 32, 32);">除法</span>：两个元素相处，转化为基于生成元的<span style="color: rgb(255, 32, 32);">指数相减</span>

<span style="color: rgb(255, 32, 32);">加法</span>：两个元素相加，通过乘除法转化

![原文截图：有限域优化](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092532830.png)

然后就是自同构里的元素 r+ r- u 可以通过暴力搜索F36 得到

最后就是元素

在 $\mathbb{F}_3$ 中的元素a 可以被用F3的系数多项式表示，并且我们可以找到被用F36l的系数多项式表示

#### 配对优化

weil配对在计算机细节中会使用两次的 Miller算法 还有一次除法

tate配对只会使用一次 Miller算法 还有一次指数运算

所以我们可以使用 tate代替weil配对 进行提高运算速度

#### Miller 算法优化

由于配对都基于这个算法 所以可以对这个算法优化

这个算法要求用到很多除法

1. 我们可以通过<span style="color: rgb(255, 32, 32);">缩放分子分母 </span>减少若干次除法
2. 对类指数运算使用<span style="color: rgb(255, 32, 32);">滑动窗口</span>【有限域指数运算，Miller和椭圆曲线乘法】
3. 点乘又可以使用 <span style="color: rgb(255, 32, 32);">带符号的滑动窗口</span>或者 转换为<span style="color: rgb(255, 32, 32);">加权射影坐标</span>【不一定能提高效率】 又或者<span style="color: rgb(255, 32, 32);">利用系统中某些点固定不变的元素特点</span> 进行优化

#### 验证方式

我们使用tate配对替换了weil配对 那么到底如何验证呢？

tate输出的是有限域中<span style="color: rgb(255, 32, 32);">陪集</span>

验证程序依赖相同的陪集 执行两次Tate

先计算出两个<span style="color: rgb(255, 32, 32);">陪集的商</span> 然后进行k次运算 最后和<span style="color: rgb(255, 32, 32);">单位元比较</span> 从而判断是否属于一个陪集

上面有用到一个除法 这里的除法我们还可以使用 一个<span style="color: rgb(255, 32, 32);">基于Tate双线性的乘法代替</span>

乘上 $1/e$ (A, B) 可以代替 除以 e(A, B)、

![原文截图：验证方式](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092425740.png)

最后的  签名是有限域中的一个元素并且可以通过 l-1次多项式表示

输出是以三进制 然后通过base64加密的

### 5.2 运行时间

> 原文：第 532 页

这里说了使用 tate配对后的计算时间

![原文截图：5.2 运行时间](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092426150.png)

作者还说 有可能是因为特征3所以导致计算速度慢，如果基于高亏格可能提速

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

### 1.1 背景

这里是简单介绍了全文的背景<span style="color: rgb(255, 32, 32);">为什么需要</span>这个内容

1. 如果人类要<span style="color: rgb(255, 32, 32);">手工输入</span>签名，那么就需要短签名的产生
2. 如果我们的信道是<span style="color: rgb(255, 32, 32);">低带宽</span>，那么我们也需要短签名来传输

但是当时的环境下 RSA和DSA都提供了长签名

虽然有人探讨过 使用  变体椭圆曲线的ECDSA 也需要320bits长度，人类手工输入320bits还是太长了

### 1.2 作者的签名方案

BLS签名方案长度是DSA的一半也就是 160bits，但是安全性程度和320bits的DSA一样

主要抵抗选择消息攻击下的存在性伪造攻击。
只要<span style="color: rgb(255, 32, 32);">特征 3 有限域上椭圆曲线的 CDH 是困难的</span>【无法解决】，那么我们的签名方案就是安全的。

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

这里签名方案是基于一个群——<span style="color: rgb(255, 32, 32);">CDH 计算困难，但是DDH判断简单</span>

我们把满足上面性质的群叫做 Gap DH 群（简称 GDH 群）

虽然之前有人基于GDH群产生签名方案，但是都是产生长签名方案，而不是短签名方案

## 2 基于 Gap Diffie–Hellman 的签名方案

> 原文：第 517 页

这里说明了签名方案 他是基于GDH群构建的

### 2.1 GDH 群的定义

> 原文：第 518 页

这里就介绍了 GDH群是什么

下面先引入一个群G 还有一些内容

1. 一个乘法群 $G$ 是一个循环群 $\langle g\rangle$，并且阶数是素数 $p$——素数阶乘法循环群。
2. 群运算为乘法：$u,v \in G$，计算 $uv$。
3. <span style="color: rgb(255, 32, 32);">DDH 问题</span>：$a,b,c \in \mathbb{Z}_p$，给定 $(g,g^a,g^b,g^c)$，要求判断 $c \stackrel{?}{=} ab \pmod p$。
4. <span style="color: rgb(255, 32, 32);">CDH 问题</span>：$a,b \in \mathbb{Z}_p$，给定 $(g,g^a,g^b)$，要求计算出 $g^{ab}$。

上面就是介绍了CDH DDH 还有这个群G的基本信息 下面开始正式定义出GDH群

定义 1：$G$ 是一个 <span style="color: rgb(255, 32, 32);">$t$-DDH</span> 群，如果群运算可以在单位时间内执行，并且 DDH 可以在时间 $t$ 内判定完毕。

![原文截图：2.1 GDH 群的定义](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092706214.png)

<span style="color: rgb(255, 32, 32);">【下面定义出攻击者】</span>

定义 2：敌手 <span style="color: rgb(255, 32, 32);">$A$ 尝试在 $G$ 上解决 CDH</span> 难题，其成功概率定义如下：

![原文截图：2.1 GDH 群的定义（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261012195800663.png)

如果 $A$ 在最多运行时间 $t$ 内以至少 $\varepsilon$ 的概率输出 $g^{ab}$，那么称 $A$ 是一个在 $G$ 上 $(t,\varepsilon)$ 攻破 CDH 的算法。

![原文截图：2.1 GDH 群的定义（3）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092702962.png)

定义 3：如果不存在 $(t,\varepsilon)$ 攻破 CDH 的算法，但存在在时间 $T$ 内判定 DDH 的算法，那么称素数阶群 $G$ 是一个 $(t,T,\varepsilon)$-GDH 群。

![原文截图：2.1 GDH 群的定义（4）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092700986.png)

<span style="background-color: rgba(255, 102, 102, 0.5);">【基于DDH简单，CDH困难 从而定义出GDH群】</span>

到此为止，我们已经知道了 GDH 群就是 CDH 难、但是 DDH 简单的群。

### 2.2 GDH 签名方案

> 原文：第 518 页

我们知道了GDH 那么开始基于GDH构建签名算法

<span style="background-color: rgba(255, 102, 102, 0.5);">【现在讨论的都是基于GDH群，还没有到椭圆曲线问题】</span>

先了解一下GDH签名方案的IO和系统参数

输入：是允许任意长度的M

输出：签名 $\sigma$，并且这个<span style="color: rgb(255, 32, 32);">签名是 $G$ 中的元素</span>。

系统参数：基本群G和生成元g

我们定义 $G^*$ 是G排除1的集合

一个正常的签名方案存在三个程序，但是BLS还存在一个全域哈希函数h，目标是把<span style="color: rgb(255, 32, 32);">输入的消息M映射到 $G^*$ 上</span>，这里我们先认为他是 随机预言机，后续会具体说是什么和如何构建的

**Key Generation**

产生私钥和公钥的，从 $\mathbb{Z}_p^*$ 中随机选择 $x$，由私钥计算公钥 $v=g^x$。

**Signing**

使用私钥x和消息M，先使用随机预言机计算 $h=h(M)$ 得到哈希结果，然后计算签名 $\sigma=h^x$，其中 $\sigma \in G^*$。

**Verification**

给定公钥 $v$、消息 $M$ 和签名 $\sigma$，先使用哈希计算 $h$，然后验证 $(g,v,h,\sigma)$ 是否是一个合法的 DDH 四元组。

因为签名 $\sigma$ 是 $G^*$ 上的元素，所以要求元素也是短的，这样才可以实现短签名。

### 2.3 安全性

> 原文：第 519 页

分析 GDH 签名在选择消息攻击下的存在性不可伪造安全性。

下面定义的是<span style="color: rgb(255, 32, 32);">直接攻击 签名BLS的算法F</span>和攻击概率

![原文截图：2.3 安全性](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092658231.png)

询问的预言机 不会产生以前询问过的内容

下面开始定义 攻击BLS的算法

$F$ 是一个 $(t,q_H,q_S,\varepsilon)$ 攻破 BLS 签名算法的敌手，如果 $F$ 运行时间为 $t$，最多询问 $q_H$ 次哈希预言机、$q_S$ 次签名预言机，并且攻破概率大于可忽略概率。

![原文截图：2.3 安全性（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092656404.png)

基于F定义出BLS的安全

如果不存在这样的 $F$，则称签名方案是 $(t,q_H,q_S,\varepsilon)$-存在性不可伪造的。

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

只要满足 GDH 群性质即可：带有大素数阶的群 $G$ 在计算 CDH 时是困难的，但是判定 DDH 是简单的。

#### 安全乘子的定义

我们只要知道 这个定义即可 具有什么性质先不要管

![原文截图：安全乘子的定义](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092413592.png)

1. $P$ 的阶数是 $q$，$P$ 为 $E$ 上的点，$E$ 有 $m$ 个点。
2. 基于拉格朗日定理 $q\mid m$
3. 所以实际要求  $q\mid m$ $q^2\nmid m$ 、
4. $q$ 是 $m$ 的素因子，但是 $m$ 不包含 $q^2$ 这个因子。

如果<span style="color: rgb(255, 32, 32);">$p^l$ 在模 $q$ 的乘法群 $(\mathbb{Z}/q\mathbb{Z})^*$ 中的阶数是 $a$</span>，那么我们认为子群 $\langle P\rangle$ 的安全乘子是 $a$。

前面那个阶数的数学表达就是：

![原文截图：安全乘子的定义（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092413601.png)

也就是书上的那个 $q\mid p^{la}-1$

第二个公式说的是在 a之前，没有更小的正整数指数可以得到 1

<span style="color: rgb(255, 32, 32);">安全乘子 $a$ 就是 $p^l$ 在模 $q$ 乘法群中的阶。</span>

对于CDH的要求 a不能太小 否则无法抵抗CDH

对于DDH的要求 a不能太大 否则无法高效计算

> 【不要深究为什么 后面会说 为什么】

后面我们会知道 $a=6$ 在超奇异椭圆曲线上是最优解

#### 椭圆曲线上的离散对数

> 【<span style="background-color: rgba(255, 102, 102, 0.5);">同时解释了 安全乘子a的作用</span>】

如何在椭圆曲线上计算离散对数呢

首先我们设定一个前提

$\langle P\rangle$ 是一个基于 $E/\mathbb{F}_{p^l}$、阶数为 $q$ 的子群，并且具有安全乘子 $a$；开始在 $\langle P\rangle$ 上尝试解决离散对数问题。

##### MOV 方法

使用一个高效的可计算同构——把基于 $\langle P\rangle$ 的离散对数难题映射到 $\mathbb{F}_{p^l}$ 的扩域中，也就是 $\mathbb{F}_{p^{li}}$。

我们要求 $\langle P\rangle$ 的像在这个同构中变为 $\mathbb{F}_{p^{li}}^*$ 的子群 并且阶数也是q

这里的i 满足安全乘子的定义

所以<span style="color: rgb(255, 32, 32);"> MOV 可以把 $\langle P\rangle$ 上的离散对数转化为扩域中的离散对数难题</span>。

所以 $a$ 要大，才可以转化为扩域中的离散对数。

> 【a 就是 有限域的扩张次数】

##### 通用算法（Generic）

如果直接计算离散对数，那么我们要求 $q$ 要很大。

所以 CDH 问题在 GDH 群上要求 $a$ 和 $q$ 都大。

#### 椭圆曲线上的 DDH 判定

上面说了 CDH的难解性 这里说明DDH简单

P是E的点 阶数q并且 $\langle P\rangle$ 具有安全乘子a

我们假设 $q\nmid p^l-1$

在<span style="color: rgb(255, 32, 32);">同一条椭圆曲线的扩域</span>上有另一个点 $Q$ 和 $P$ <span style="color: rgb(255, 32, 32);">线性无关</span>——那么就可以使用 Weil 配对进行验证。

##### Weil 配对

这里先介绍 Weil 配对，它可以把椭圆曲线上的两个点映射到有限域的乘法群中。

存在一个映射e：

输入：$E[q]$【椭圆曲线 $E$ 上满足 $qQ=O$ 的点构成的群】中的两个点。

输出： $\mathbb{F}_{p^{la}}^*$ 扩域中的一个非零元素

<span style="background-color: rgba(255, 102, 102, 0.5);">注意weil配对不要求两个点线性无关，是BLS要求的</span>

##### Weil 配对的性质

1. 交错性：$e(R,R)=1$。
2. 双线性：<span style="color: rgb(255, 32, 32);"> $e(aR_1,bR_2)=e(R_1,R_2)^{ab}$ </span>
3. 非退化性：如果对所有 $R' \in E[q]$ 都有 $e(R,R')=1$，则 $R=O$。
4. 可计算的： $e(R_1,R_2)$ 可以被高效计算

线性无关保证了配对值不恒为 $1$，即满足非退化性。

我们主要利用的就是 双线性和可计算性

##### DDH 判定方式

知道了weil配对内容 我们下面探讨如何解决DDH

回顾一下

<span style="background-color: rgba(255, 102, 102, 0.5);">【标准DDH】</span>

给 $(g,g^a,g^b,g^c)$

判断 $g^{ab} \stackrel{?}{=} g^c$。

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

从而判定 $a \stackrel{?}{=} b \pmod q$。

这里可以发现 weil配对可以比较得到 两个不同点的标量是否相同，所以我们尝试转向标准DDH去

> 【增加可计算同构】

$\varphi$ 作为一个同构，把群 $\langle P\rangle$ 同构到 $\langle Q\rangle$ 中。

设定计算：$\varphi(aP)=a x Q$，其中 $xQ=\varphi(P)$。

现在有可计算同构后 给定标准DDH四元组

$(P,aP,bP,cP)$ 通过两次weil配对和可计算同构转化得到

$$
e(P,\varphi(cP))=e(P,cxQ)=e(P,Q)^{cx}
$$

$$ e(aP,\varphi(bP))=e(aP,bxQ)=e(P,Q)^{abx} $$

这里的 $x$ 是同一个 $x$。由此可以验证 $ab \stackrel{?}{=} c \pmod q$，从而破解 DDH 难题。

### 3.2 特殊的超奇异椭圆曲线

> 原文：第 521 页

上面说明了 椭圆曲线如何实现CDH困难，DDH简单，下面开始说明一个具体的椭圆曲线——<span style="color: rgb(255, 32, 32);">超奇异椭圆曲线</span>

$$
y^2 = x^3 + 2x + 1
$$

基于 $\mathbb{F}_{3^l}$

#### 为什么使用这类超奇异曲线

因为我们上面说了，需要一个高效计算的同构，把点 $P$ 映射到扩域中的点 $Q$，并且两者线性无关。

$\langle P\rangle \to \langle Q\rangle$：在超奇异椭圆曲线上可以高效地找到这样的同构。

#### 安全乘子的确定

我们上面说 $a=6$，下面给出确定它的过程。

现在定义出两个 超奇异椭圆曲线 并且要求他们满足点的数量

![原文截图：安全乘子的确定](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092646437.png)

这里给出作者选好的椭圆曲线，并且说明：如果 $l$ 的值知道了，那么这个椭圆曲线的点数也就知道了。

下面说知道点数的意义是什么——尝试去证明6是本椭圆曲线的安全乘子

![原文截图：安全乘子的确定（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092644757.png)

这里说明 $q \mid 3^{6l}-1$。因为 $a$ 是 $3^l \bmod q$ 的阶，所以 $a \mid 6l$；论文进一步结合曲线族的具体结构，把最小安全乘子确定为 $6$。

1. $q$ 是 $m$ 的因子【因为子群 $\langle P\rangle$ 的阶数是 $q$】。
2. 从而 $q \mid 3^{6l}-1$，基于安全乘子的定义，$a \mid 6l$。
3. 论文进一步论证在该曲线族上最小安全乘子为 $6$。

但是安全乘子要求是最小正整数，所以我们还要排除 $\{1,2,3\}$；这一步可以通过证明完成，论文没有展开说明。

#### 可计算同构

上面我们说了 需要一个可计算同构，将非标DDH 转化为DDH 这里开始说如何构建

我们从扩域中找到 3 个元素 $u,r_+,r_-$，满足下面公式：

1. $u^2=-1$
2. $r_+^3+2r_++2=0$
3. $r_-^3+2r_--2=0$

只要得到这三个元素，就可以构建出具体的同构 $\varphi$。

![原文截图：可计算同构](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092642526.png)

下面说明：只要有这个扩域上的同构，$\mathbb{F}_{3^l}$ 上的点 $P$ 就会被同构为扩域上一个与它线性无关的点。

到此为止，我们构建出了满足<span style="color: rgb(255, 32, 32);">GDH 的椭圆曲线、安全乘子和同构</span>。

到此 一个完整的GDH群都实现了

### 3.3 哈希到椭圆曲线

> 原文：第 522 页

注意，这里进入的是 GDH 签名；前面已经构造了 GDH 群，现在进入签名方案。

签名需要一个哈希函数，把输入的消息映射到 $G^*$ 上【GDH 群去掉单位元 $1$】。

GDH 群又是基于椭圆曲线上的点产生的子群构建的。

但是我们很难在椭圆曲线的子群上直接构造这样的哈希映射，所以修改了方案。

$E/\mathbb{F}_{p^l}$ 是一条椭圆曲线，阶数为 $m$，形式为 $y^2=f(x)$。

$P \in E$，阶数为 $q$，并且 $q^2 \nmid m$。

基于 $P$ 设定一个群作为 GDH 群 $\langle P\rangle$，开始构建签名方案。

现在我们基于<span style="color: rgb(255, 32, 32);">标准密码学算法</span>构造出一个哈希函数 $h'$：$\{0,1\}^* \to \mathbb{F}_{p^l} \times \{0,1\}$。

输入是任意长度的消息

输出是有限域元素和随机比特 $0/1$。

我们现在把 $h'$ 视为随机预言机。

下面开始讨论 MapToGroup 这个哈希程序【有两个哈希程序】。

要求是 $\{0,1\}^* \to G^*$。

开始说明之前，我们固定参数 $I$。

![原文截图：3.3 哈希到椭圆曲线](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092640219.png)

$\delta$ 为失效概率的期望界。

#### MapToGroup 算法

1. 给定 $M \in \{0,1\}^*$，并且设定 $i=0$【$i$ 是执行次数】。

2. 运行随机预言机 $h$ 得到输出 $(x,b)$。

3. 计算 $f(x)$，如果<span style="color: rgb(255, 32, 32);">它是二次剩余</span>就继续：

    1. 计算 $f(x)$ 的平方根 $y_0,y_1$。
    2. 用有限域元素的多项式表示来确定这两个根的顺序，并按<span style="color: rgb(255, 32, 32);">常数项的大小排列</span>【即按常数项排序，要求 $y_0$ 的常数项小于 $y_1$ 的常数项】。
    3. 使用随机比特 $b$ 确定选择 $y_0$ 还是 $y_1$【排序后的】。
    4. <span style="color: rgb(255, 32, 32);">输出点 $\tilde{P_m}$</span>，坐标是 $(x,y_b)$。
    5. 计算 $P_m=(m/q)\tilde{P_m}$，并确定 $P_m$ 在 $G$ 中。
    6. 如果<span style="color: rgb(255, 32, 32);">$P_m$ 在 $G^*$ 中，那么就输出 $P_m$</span> 作为哈希结果，算法结束。

4. 如果 $f(x)$ 不是二次剩余，则自增 $i$ 并回到第 2 步；如果 $i$ 到达 $2^I$，程序失败。

每次成功运行的概率约为 $1/2$。

所以 $h'$ 期望调用 2 次。

到此，$\{0,1\}^* \to G^*$ 的 MapToGroup 也定义完毕了。

#### 安全性证明

![原文截图：安全性证明](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092637567.png)

这里要证明：使用 MapToGroup 与使用随机预言机 $h$ 具有一样的安全性。

$F'$：攻击带有 MapToGroup 的 BLS 签名。

$F$：攻击具有随机预言机哈希 $h$ 的 BLS 签名。

1. $F$ 主动调用 $F'$，并且使用随机预言机 $h$ 去模拟 MapToGroup。

    1. 使用一个二维数组，里面的元素是之前 MapToGroup 中密码学哈希函数的输出。
    2. 初始化的时候 $s_{ij}$ 会被 $(x_i,b)$ 填充满。
    3. $F$ 会追踪 $F'$ 运行时对所有不同消息所请求的 $h'$ 哈希。
    4. $F$ 只要收到没有遇见过的消息，就去对应行开始计算，类似 MapToGroup 的第 3 步，逐个计算过去，直到计算出 $G^*$ 中的结果。
    5. 【核心】$F$ 会把自己用 $h$ 生成的预言机结果替换这个值。

2. $F$ 把自己随机生成的哈希交给 $F'$；如果 $F'$ 可以攻破带有 MapToGroup 的 BLS，那么 $F$ 也可以攻破带有随机预言机 $h$ 的 BLS。

到此安全归约完毕。因为 $h$ 是安全的，所以不存在 $F'$ 可以攻破带有 MapToGroup 的 BLS。

### 3.4 具体的短签名方案

> 原文：第 524 页

到这里为止，GDH 群和 MapToGroup 哈希程序都有了，所以可以构建真正的 BLS 签名方案了。

使用椭圆曲线 $y^2=x^3+2x+1$ 构建出 GDH 群。  

使用 MapToGroup 让消息映射到 $E$ 的点上。

对于不同的 $l$，具有不同的签名长度和安全性，如下图：

![原文截图：3.4 具体的短签名方案](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092635121.png)

#### 具体签名方案

**Key Generation**

使用上表选择一个 $l$，构建对应的椭圆曲线 $E$，取 $E$ 上阶为素数 $q$ 的点 $P$，构造素数阶加法循环群 $G=\langle P\rangle$；从 $\mathbb{Z}_q^*$ 中随机选择 $x$ 作为私钥，计算 $R=xP$，设立四元组 $(l,q,P,R)$ 作为公钥。

**Signing**

给定 $M$，经过 MapToGroup 映射到 $G^*$ 得到点 $P_m$，计算签名 $S_m=xP_m$，输出其 $x$ 坐标作为签名 $\sigma$。

**Verification**

得到 $\sigma$、公钥 $(l,q,P,R)$ 和消息 $M$。

1. 通过 $x$ 坐标查找椭圆曲线上满足该 $x$ 坐标的点 $S$；如果不存在，直接失败。
2. 设定 <span style="color: rgb(255, 32, 32);">$u=e(P,\varphi(S))$，$v=e(R,\varphi(h(M)))$</span>；这里的 $e$ 是 Weil 配对，$\varphi$ 是上面提到的同构。
3. 如果 $u=v$ 或者 $u=v^{-1}$，验证成功；否则失败。

我们来看看是不是像之前说的那样，计算两次 Weil 配对实现验证。

$$
S=xh(M)
$$

$h(M)=kP$【这里因为在 $G^*$ 上，所以可以使用生成元表示】。

1. $e(P,\varphi(xh(M)))=e(P,\varphi(xkP))=e(P,xkQ)=e(P,Q)^{xk}$。
2. $e(R,\varphi(h(M)))=e(xP,kQ)=e(P,Q)^{xk}$。

可以发现，很简单就可以检查是不是 DDH 了。

#### 安全性证明

这里的安全性和证明 MapToGroup 时类似，使用规约方法。

![原文截图：安全性证明（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092632286.png)

这里其实第四章会说如何证明 这里简单规约一下

$G$ 是一个 GDH 群，MapToGroup 看作是随机预言机；在 GDH 安全分析中我们知道：

![原文截图：安全性证明（3）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092415962.png)

现在把预言机转化为 MapToGroup。

由于随机预言机的时间损失，所以时间变为：

![原文截图：安全性证明（4）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092628548.png)

设立 $A$ 攻击带有随机预言机的 BLS 签名。

$F$ 攻击带有 MapToGroup 的签名。

$A$ 开始运行 $F$；如果可以攻破，说明 $A$ 也可以攻破带有随机预言机的 BLS，违背了之前的安全性，所以失败【具体在第四章会说到】。

### 3.5 开放问题：具有更高安全性的短签名

> 原文：第 526 页

这里提出了一个开放问题：如何提升 BLS 的安全性。

作者提出两个

1. <span style="color: rgb(255, 32, 32);">不使用超奇异椭圆曲线</span>
2. <span style="color: rgb(255, 32, 32);">使用更高亏格的超奇异椭圆曲线</span>

我们聚焦第一个

在非超奇异椭圆曲线上使用更大的 $a$，虽然会增加验证的消耗，但是对 MOV 攻击具有更强的抵抗——在签名比特长度相近的情况下。

其实主要关注的点就是构建出两个线性无关的点，阶数都是 $q$，一个属于原本的椭圆曲线，一个属于扩域椭圆曲线【<span style="color: rgb(255, 32, 32);">这两个椭圆曲线都是一样的</span>】。

不再使用同构的方式——因为在标准椭圆曲线下，不一定存在那种同构。

转化为直接使用这两个群 $\langle P\rangle$、$\langle Q\rangle$。

#### co-DH 问题

基于这两个不同的群，产生 co-DH 问题。

<span style="color: rgb(255, 32, 32);">co-DDH</span>：这里基于 Weil 配对可以很容易解决 co-DDH【不需要知道 $a$ 和 $b$ 的值】。

<span style="color: rgb(255, 32, 32);">co-CDH</span>：给定 $(P,aP,Q)$，在不知道 $a$ 的情况下计算 $aQ$。

下面是作者提出的 <span style="color: rgb(255, 32, 32);">co-GDH签名方案</span>

**Key Generation**

$P,Q$ 来自同一条椭圆曲线的扩域和基域，并且它们的阶数相同、线性无关；从 $\mathbb{Z}_q^*$ 中随机选择 $x$ 作为私钥，使用 $Q$ 参与计算，得到 $(E/\mathbb{F}_{p^l},q,Q,R)$ 作为公钥。

**Signing**

给定 $M$，经过 MapToGroup 映射到 $G^*$ 得到点 $P_m$，计算签名 $S_m=xP_m$，输出其 $x$ 坐标作为签名 $\sigma$。

**Verification**

得到 $\sigma$、公钥 $(E/\mathbb{F}_{p^l},q,Q,R)$ 和消息 $M$。

1. 通过 $x$ 坐标查找椭圆曲线上满足该 $x$ 坐标的点 $S$；如果不存在，直接失败。
2. 设定 $u=e(Q,S)$，$v=e(R,h(M))$；这里的 $e$ 是 Weil 配对。
3. 如果 $u=v$ 或者 $u=v^{-1}$，验证成功；否则失败。

依旧分析一下验证程序

1. $e(Q,S)=e(Q,xh(M))$
2. $e(R,h(M))=e(xQ,h(M))$

可以发现，依旧可以得到 co-DDH 简单问题；不使用同构、不使用超奇异椭圆曲线，依旧可以做到 BLS 签名。

但是如何构造安全乘子 $a$ 更大的椭圆曲线，仍然是一个研究难题。

到此，具体 GDH 群构建、MapToGroup 构建、BLS 签名构建、co-BLS 签名构建都结束了。

## 4 安全性定理的证明

> 原文：第 527 页

之前我们探讨的内容都是基于“GDH 在随机预言机下是安全的”这一前提，来说明具体 GDH 的安全性。

这里开始具体分析 <span style="color: rgb(255, 32, 32);">GDH 群下的通用 GDH 签名方案是否真正安全</span>。

首先给出定理：如果 $G$ 是一个 GDH 群，那么基于这个群产生的 GDH 签名方案是安全的，可以抵抗选择消息攻击下的存在性伪造。

![原文截图：4 安全性定理的证明](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092624815.png)

![原文截图：4 安全性定理的证明（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092623335.png)

时间与概率为下图：

![原文截图：4 安全性定理的证明（3）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092419963.png)

这个我们在之前都遇见过。

### 4.1 证明概述

> 原文：第 528 页

这里先概述下面要讲解的大概内容，后面部分具体说明如何构建 $A$ 和 $F$，并分析安全性。

这里我们先总体概述两个攻击算法：

$F$：直接攻击通用 BLS 签名方案。

$A$：直接攻击 CDH 难题，并运行 $F$。

1. $A$ 运行 $F$ 攻击 BLS。
2. $F$ 会进行两类询问：一次是哈希，一次是签名。
3. $F$ 会输出哈希和签名，然后使用伪造消息 $M^*$ 生成伪造签名，也输出给 $A$。
4. $A$ 收到后维护一个表，内容是每个消息、哈希和签名【如果有的话】。

   ![原文截图：4.1 证明概述](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092619893.png)

5. 然后使用 $F$ 返回的伪造签名去挑战 CDH。

### 4.2 算法 A 的构造

> 原文：第 528 页

由于 $A$ 要做的事情非常多，所以我们会让 $A$ 不断闯关，不断增加 $A$ 的变体并且允许 $F$ 参与，直到最后一个变体 $A_6$——它就是上面提到的 $A$。

并且在每个游戏中分析增加的内容是否影响 $F$ 的成功概率。下面开始探讨。

#### Game 1

$A_1$ 被给出 $(g,g^a,g^b)$ 这一 CDH 难题，初始化参数与公钥 $g^a$。对于每个 $i$【$i$ 的上界是哈希询问次数】，以一个随机比特 $s_i$ 决定后续处理——以概率 $c$ 取 $1$，以概率 $1-c$ 取 $0$；从 $\mathbb{Z}_q$ 中随机选择 $r_i$，把它当作私钥，然后<span style="color: rgb(255, 32, 32);">计算哈希 $h_i=g^{r_i}$</span>【这里因为 $A_1$ 不知道私钥 $a$，所以直接构建自己的哈希】，接着<span style="color: rgb(255, 32, 32);">计算签名 $\sigma_i=(g^a)^{r_i}$</span>——这里是使用自己的哈希伪造 BLS，因为它不知道私钥。

<span style="background-color: rgba(255, 102, 102, 0.5);">这里可以发现 $A_1$ 不知道私钥的信息，所以自己伪造私钥去构建哈希和签名，从而应对 $F$ 的询问。</span>

得到 BLS 四元组 $(g,g^a,h_i,\sigma_i)$；如果它是一个 GDH 四元组，那么就认为是一个 BLS 签名。

上面就是 Game 1 完整的定义内容，需要深刻记忆。

下面是 Game 1 的运行过程：

1. $F$ 对 $M_i$ 请求哈希。

2. $A_1$ 返回自己构造的哈希 $h_i$。

3. $F$ 对 $M_i$ 请求签名。

4. $A_1$ 返回自己构造的签名 $\sigma_i$。

5. $F$ 收到后会停止，分为两个情况：

    1. 失败，伪造的内容无法通过签名认证
    2. 成功，基于 $A$ 给的信息产生一个新的伪造签名 $(M^*,\sigma^*)$【<span style="color: rgb(255, 32, 32);">$\sigma^*$ 是 $F$ 没有向 $A_1$ 请求过的</span>】。

6. $A_1$ 基于 $F$ 的成功与否，输出成功或者失败。

到这里整个内容都结束了。我们开始分析 $A_1$ 成功打破 CDH 的概率。

1. $A$ 选择的 $r$ 产生的哈希和签名都是基于 $\mathbb{Z}_q$ 随机产生的。
2. $F$ 接收 $A$ 的内容，并把它视为随机预言机。

![原文截图：Game 1](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092616130.png)

上面是对 $A_1$ 的概率定义，进一步延伸就是 $F$ 是否可以通过验证程序。

![原文截图：Game 1（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092614727.png)

所以 $A_1$ 的成功概率就是 $F$ 成功攻破 BLS 的概率 $\varepsilon$。

#### Game 2

基于 Game 1 的内容增加一点点。

1. 如果 $F$ 失败，那么 $A_2$ 直接输出失败。

2. 如果 $F$ 成功，输出了伪造对，那么 $A_2$ 会输出失败或者成功：

    1. $s_i^*=1$ 的时候输出成功。
    2. $s_i^*=0$ 的时候输出失败。
    3. <span style="color: rgb(255, 32, 32);">$s_i^*$ 是 $s_{i^*}$，其中 $i^*$ 表示选择第 $i$ 个进行伪造</span>。

可以发现，这里对 $F$ 没有任何操作。

但是对 $A$ 来说，需要判别 $s_i$ 是不是为 $1$。

$s_i$ 是按照概率 $c$ 随机抽取得到 $1$ 的。

所以 $A$ 的获胜概率如下：

![原文截图：Game 2](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092612175.png)

#### Game 3

基于 Game 2 继续增加内容。

1. 如果 $F$ 失败，$A$ 也宣布失败。

2. 如果 $F$ 成功，$A$ 在下面情况宣布成功，否则失败：

    1. $F$ 伪造的消息的 $s_i$ 标识为 $1$。
    2. $F$ 请求签名的消息的 $s_i$ 标识都为 $0$。
    3. 上面这两个就是：<span style="color: rgb(255, 32, 32);">必须成功伪造一个有效签名，且该消息此前没有请求过签名</span>。

这里依旧是对 $A_3$ 宣布胜利的情况进行要求，但是增加了前面请求的 $s_i$ 都要为 $0$ 的情况。

![原文截图：Game 3](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092610161.png)

后面乘上的也就是前面请求的 $s_i$ 都要为 $0$ 的概率。

之前请求过签名的 <span style="color: rgb(255, 32, 32);">$k$ 条不同消息</span>，其 $s_i$ 全部为 $0$ 的概率为 $(1-c)^k$。

#### Game 4

基于 Game 3 继续增加内容。

1. 如果 $F$ 对 $s_i=1$ 的消息请求签名，$A$ 直接宣布失败。

因为 $A$ 和 $F$ 的随机性共同决定了选择消息的 $s_i$。

我们可以认为 <span style="color: rgb(255, 32, 32);">$s_i=1$ 是不幸运的</span>；即使 $F$ 找到了伪造，但由于不幸，$A$ 依旧宣布失败。这里 $A_4$ 的修改没有触及概率问题。

![原文截图：Game 4](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092607844.png)

#### Game 5

基于 Game 4 继续增加内容。

1. 在 $A$ 的初始设置阶段进行修订。
2. 如果遇见 $s_i=1$ 的消息，直接设定哈希为 $g^b\cdot g^{r_i}$，签名使用一个占位符说明。
3. 如果遇见 $s_i=0$ 的消息，就和之前一样，计算哈希和签名返回。

这里我们解决两个问题：

1. 为什么设定哈希为 $g^b\cdot g^{r_i}$？

    1. $A$ 的最终目标是计算出 $g^{ab}$【$a,b$ 都不知道】。
    2. 把 $g^b\cdot g^{r_i}$ 带入标准 BLS 的签名算法中，可以得到：
        1. 

![原文截图：Game 5](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092422272.png)

    3. 可以发现 $A$ 其实知道里面的 $g^{a r_i}$。
    4. 如果 $F$ 可以解决 $s_i=1$ 的伪造签名。
    5. 那么 $A$ 就可以破解得到 $g^{ab}$。

2. 为什么 $A_5$ 修改了哈希，$F$ 依旧可以尝试伪造？

    1. $G$ 是一个素数阶循环群。
    2. $r_i$ 是 $\mathbb{Z}_q$ 下的随机选择；此时乘了 $g^b$，相当于<span style="color: rgb(255, 32, 32);">重新排列</span>所有可能的指数。
    3. 所有值仍然出现一次，概率不变。

理解上面内容就知道了：$A$ 面对 $s_i=1$ 的时候可以提供哈希，但是由于无法破解 CDH 难题，无法提供签名。

如果 $F$ 可以破解伪造 $s_i=1$ 的签名，那么 $A$ 就可以得到 $g^{ab}$，破解 CDH。

由于 Game 5 只是修改了 $A_5$ 的 setup，所以概率依旧没有变化。

![原文截图：Game 5（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092550324.png)

#### Game 6

基于 Game 5 继续增加内容。

1. 只是修改了 $A_5$ 宣布胜利的时候，$A_6$ 也要输出 $\sigma^*/g^{a r_i}$ 的结果【也就是 $g^{ab}$】。

依旧没有修改概率内容，所以概率依旧是：

![原文截图：Game 6](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092422571.png)

如果 $A_6$ 成功输出，那么 CDH 难题破解，算法成功。

到这里我们就学习了 BLS 如何一步一步设立游戏、不断增加 $A$ 的功能，然后分析概率，从而完成归约。

### 4.3 优化与结论

> 原文：第 530 页

下面就是正式的总结和优化。

从上面的攻击成功概率可以发现，我们只可以对 $c$ 进行调优，也就是控制<span style="color: rgb(255, 32, 32);">随机比特取 $1$ 或 $0$ 的概率</span>。

论文发现，取 $c=1/(q_S+1)$ 并令 $k=q_S$ 时是最优解。

![原文截图：4.3 优化与结论](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092423930.png)

把这个带入 $A$ 的攻击成功概率中，可以计算得到：

![原文截图：4.3 优化与结论（2）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092545101.png)

如果 $q_S$ 不断增大，攻击优势就可以接近 <span style="color: rgb(255, 32, 32);">$1/e$</span> 这个因子。

下面开始分析运行时间

$A$ 的额外开销就是回应 $F$ 请求的签名和哈希。

每一次都需要 $O(\log p)$ 次群计算，那么次数最多是 $(q_S+q_H)$，再加上一个额外开销 $c_A$，得到最终时间。

![原文截图：4.3 优化与结论（3）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092542838.png)

所以下面的定理说的是：

如果存在伪造签名算法 $F$ 可以打破 BLS，那么就存在算法 $A$ 可以攻破 CDH，并且时间与概率为：

![原文截图：4.3 优化与结论（4）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092424413.png)

反过来说：

如果 $G$ 是一个安全的 GDH 群，那么就不存在一个 $F$ 可以攻破 GDH 签名方案，并且这个 $F$ 的攻击时间和概率为：

![原文截图：4.3 优化与结论（5）](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092538520.png)

这里就是移项。

## 5 实验结果

> 原文：第 531 页

### 5.1 实现细节

> 原文：第 531 页

这里探讨的是<span style="color: rgb(255, 32, 32);">实际工作中对 BLS 的优化</span>。

首先作者说明：<span style="color: rgb(255, 32, 32);">验证才是耗时的主要部分</span>。

验证需要计算两次 Weil 配对，并且基于 $\mathbb{F}_{3^{6l}}$ 这个非常大的有限域。

所以作者开始优化。

#### 有限域优化

作者不直接聚焦于 $\mathbb{F}_{3^{6l}}$，而是<span style="color: rgb(255, 32, 32);">把它看成 $\mathbb{F}_{3^6}$ 的 $l$ 次扩域</span>。

并且设立一个查询表，目的是让两个元素的乘法更快完成。

然后作者说，因为 $\mathbb{F}_{3^6}$ 里面的任意非零元素都可以用<span style="color: rgb(255, 32, 32);">生成元来表示</span>，那么这里又可以简化有限域里的乘法、除法和加法运算了。

<span style="color: rgb(255, 32, 32);">乘法</span>：两个元素相乘，转化为基于生成元的<span style="color: rgb(255, 32, 32);">指数相加</span>。

<span style="color: rgb(255, 32, 32);">除法</span>：两个元素相除，转化为基于生成元的<span style="color: rgb(255, 32, 32);">指数相减</span>。

<span style="color: rgb(255, 32, 32);">加法</span>：两个元素相加，通过乘除法转化。

![原文截图：有限域优化](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092532830.png)

然后就是自同构里的元素 $r_+,r_-,u$，可以通过暴力搜索 $\mathbb{F}_{3^6}$ 得到。

最后就是元素的表示。

$\mathbb{F}_3$ 中的元素 $a$ 可以用 $\mathbb{F}_3$ 上的系数多项式表示，并且可以找到它在 $\mathbb{F}_{3^{6l}}$ 上的系数多项式表示。

#### 配对优化

Weil 配对在具体实现中会使用两次 Miller 算法，还有一次除法。

Tate 配对只会使用一次 Miller 算法，还有一次指数运算。

所以我们可以使用 Tate 配对代替 Weil 配对，以提高运算速度。

#### Miller 算法优化

由于配对都基于这个算法，所以可以对这个算法进行优化。

这个算法需要用到很多除法。

1. 我们可以通过<span style="color: rgb(255, 32, 32);">缩放分子分母</span>减少若干次除法。
2. 对指数运算使用<span style="color: rgb(255, 32, 32);">滑动窗口</span>【有限域指数运算、Miller 算法和椭圆曲线乘法】。
3. 点乘又可以使用<span style="color: rgb(255, 32, 32);">带符号的滑动窗口</span>，或者转换为<span style="color: rgb(255, 32, 32);">加权射影坐标</span>【不一定能提高效率】，又或者<span style="color: rgb(255, 32, 32);">利用系统中某些点固定不变的特点</span>进行优化。

#### 验证方式

我们使用 Tate 配对替换了 Weil 配对，那么到底如何验证呢？

Tate 配对输出的是有限域中的<span style="color: rgb(255, 32, 32);">陪集</span>。

验证程序依赖相同的陪集，执行两次 Tate 配对。

先计算出两个<span style="color: rgb(255, 32, 32);">陪集的商</span>，然后进行 $k$ 次幂运算，最后和<span style="color: rgb(255, 32, 32);">单位元比较</span>，从而判断是否属于同一个陪集。

上面用到了一个除法；这里的除法还可以使用一个<span style="color: rgb(255, 32, 32);">基于 Tate 双线性的乘法代替</span>。

乘上 $1/e(A,B)$ 可以代替除以 $e(A,B)$。

![原文截图：验证方式](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092425740.png)

最后的签名是有限域中的一个元素，并且可以通过 $l-1$ 次多项式表示。

输出以三进制表示，然后通过 Base64 编码。

### 5.2 运行时间

> 原文：第 532 页

这里说明了使用 Tate 配对后的计算时间。

![原文截图：5.2 运行时间](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261014092426150.png)

作者还说，有可能是因为特征 3 导致计算速度慢；如果基于高亏格曲线，可能提速。

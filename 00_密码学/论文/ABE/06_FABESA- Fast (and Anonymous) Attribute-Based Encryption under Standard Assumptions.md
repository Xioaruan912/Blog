# FABESA: Fast (and Anonymous) Attribute-Based Encryption under Standard Assumptions

这篇是24年发布在四大安全顶会ACM CCS 2024的文章

刚刚学习完 Waters CP-ABE，可以接着学习这篇文章，可以学习到一些内容

# ABSTRACT

ABE提供了细粒度的访问控制，对于加密消息和应用场景都适用

ABE 一般都是在<span style="color: rgb(255, 32, 32);">安全和效率</span>之间做权衡

当下最优秀的自适应安全ABE算法提供了自适应安全在标准假设下，是FAME在17年提出的

略慢于当下在通用群模型GGM安全假设下最快的ABE（FABEO）

传统ABE只会对消息进行加密，而不对属性加密，所以后续提出了 匿名ABE 也就是A²BE，对消息和属性都进行了加密

但是A²BE因为复杂性，所以效率很低，当下最快的A²BE是基于GGM模型的FEASE，在24年本篇同作者发布的

那么这篇论文，会说明一个新的ABE构建

具有下面性质：

1.  不会对访问公式做任何约束
2.  不会对属性或者策略大小类型做任何约束
3.  达到基于标准DLIN假设下的自适应安全
4.  对于解密只需要4次配对
5.  对密文提供匿名
6.  可以通过方法转化到A²BE使得A²BE达到同等效率和安全

最后作者还会比较同类型的ABE

# 1 INTRODUCTION

这里开始作者介绍整个ABE的发展过程

可以带我们梳理当下ABE发展到哪里了

ABE从公钥加密中脱颖而出，介绍了<span style="color: rgb(255, 32, 32);">细粒度的访问控制在CP-ABE和FIBE中</span>

并且ABE已经在实际应用中实现了，许多内容都是基于ABE实现的

<span style="color: rgb(255, 32, 32);">ABE可以划分为CP-ABE和KP-ABE</span>

主要看策略是跟着密文走还是用户解密密钥走

## ABE期望

一般来说，ABE我们看重的是

1.  表达性
2.  安全
3.  效率

对于表达性：是否允许实用复杂，高等级的多项式展示复杂访问控制

对于安全：我们需要保证 ABE 可以提供自适应安全，这样用户才可以信任 ABE 系统；人们更希望将 ABE 方案的安全性归约到那些经过广泛研究、长期检验的标准计算困难性假设上，如 BDH 或 BDHE

对于效率：许多系统不接受时延，所以效率是非常重要的

那么这些是我们对ABE的期望，现在的ABE研究到什么情况了？

## ABE的研究情况

### 效率和安全

目前最好的ABE算法是：

1.  FAME-KP-ABE和CP-ABE 可以满足基于标准假设下的自适应安全

使用了双系统证明框架，复杂度增加，所以效率降低

1.  FABEO-KP-ABE 和 CP-ABE 强调了在 GGM 模型下的自适应安全的效率

FABEO超越了FAME的速度

所以这里提出了一个问题

> 我们能否在保证基于标准假设的自适应安全的情况下构建出更快的KP-ABE和CP-ABE？

### 匿名

传统ABE只会对消息加密，对于Payload（也就是属性和策略）不会加密——有的跟着密文一起发送

Payload：与私钥或密文一起提供、用于描述其访问控制条件的辅助信息

即使不跟着密文发送，加密者也不会对Payload进行加密

比如FABEO是最快的KP-ABE，敌手可以很简单区分两个属性u1 和u0，并且判断出密文到底属于哪个属性

但是实际应用中需要匿名的情况，比如健康机构等

所以提出了 A²BE

1.  Payload：对于Payload不会揭露任何和属性值有关的内容
2.  Ciphertext：密文不会揭露任何和消息和属性值有关的内容

同样的匿名ABE也分为了 KP和CP

那么在研究中，会把A²BE划分为两个种类

Fully A²BE：代表是 IPE，加密策略和属性当作向量 $x$ 和 $y$，加入密钥和密文中，如果 $x\cdot y=0$ 就可以解密成功

这个情况是把整个payload都隐藏了，达到了强大的匿名性

但是因为约束了策略和属性的大小，并且需要把策略或属性编码成向量，导致效率明显下降

从而不切实际

<span style="color: rgb(255, 32, 32);">Partially A²BE：聚焦让密文匿名和隐藏部分结构匿名</span>

一般来说是保护属性值和暴露出属性名，这个也是我们研究的匿名ABE

这种方法更加适用于现实情况，即使牺牲了一些匿名性

最好的A²BE：

1.  CP-A²BE ——FEASE达到了最好的效率，但是是在GGM中的自适应安全
2.  KP-A²BE ——CDW+达到了选择性安全，但是效率低下

当下的A²BE都受到安全和效率的约束

所以提出了一个问题

> 能不能基于标准假设下构建出自适应安全并且快速的KP-A²BE 和 CP-A²BE？

## 本文贡献

本文回答了 上面两个问题

提出了快速的KP-ABE和CP-ABE，具有下面特点

1.  表现力：提供任意策略，并且可以通过任意属性公式构建
2.  群运算：基于高效的第三类型配对构建
3.  属性：不对属性进行任何约束
4.  安全：实现基于DLIN下的自适应安全，安全证明使用到了随机预言机
5.  效率：加密和密钥产生的效率与属性数量线性相关，解密只需要 4 次配对
6.  密文匿名：保护了消息和属性值的保密性

我们还可以通过隐藏部分结构转化我们的ABE到A²BE，并且继承了上面1-4的特点，效率几乎没有损失

本文方案在兼顾了最好的速度并且达到了自适应安全

本文方案比FAME快速，接近于FABEO

本文的 KP-A²BE 接近了 FEASE，CP-A²BE 超越了 CDW+

# 2 PRELIMINARIES

这里开始前置知识，因为内容很多 所以我会细致说明，并且后续内容我会重复提及

*   $[n]=\{1,\ldots,n\}$
*   对于素数 $p$，$\mathbb{Z}_p=\{0,\ldots,p-1\}$，$\mathbb{Z}_p^*=\{1,\ldots,p-1\}$
*   在 $\mathbb{Z}_p$ 上做加法或乘法时需要模 $p$
*   $\lambda$ 表示安全参数
*   $s\gets S$ 表示从集合 $S$ 中随机采样 $s$
*   概率多项式时间算法记作 PPT
*   向量 $v$ 一般看作列向量
*   $v_k$ 表示列向量 $v$ 的第 $k$ 个元素
*   $\|$ 表示两个列向量的拼接
*   $M_i$ 和 $M_{ij}$ 分别表示矩阵的第 $i$ 行和第 $i$ 行第 $j$ 列元素
*   $M^T$ 表示矩阵 $M$ 的转置

到这里都是基本数学内容和符号描述，下面我们会进入各个组件的前置知识

## 2.1 Access structure

*   单调性：如果随着认证用户的增加，依旧可以保证访问特权，就说明这个访问结构是单调的
*   布尔公式：由AND和OR组合，其余元素为在域U属性集合中的属性
*   属性满足：如果S满足布尔公式，也就是把公式映射到S中，某个属性都为真，其余都是假

### MSP

这个是重点 是一个更加通用的函数

我们会把一个访问结构编码为策略 $(M,\pi)$

其中 $M$ 是 $\mathbb{Z}_p$ 上的 $\ell\times n$ 矩阵，$\pi:\{1,\ldots,\ell\}\to U$ 是映射

$\pi(i)$ 表示第 $i$ 行对应的属性

我们可以通过 Lewko–Waters 的特定转换算法，把任何布尔公式转化到一个 MSP $(M,\pi)$ 结构中

每一行都是 $F$ 的输入，列的数量与 $F$ 的 AND 门数量相关

所以 <span style="color: rgb(255, 32, 32);">$M$ 中元素要么是 $0,1$，要么是 $-1$</span>【和一般 LSSS 不同，因为使用了特殊转化法】

我们设立集合 $S=\{u_i\}_{i\in[m]}$，其中 $m=|S|$

并且这个集合在 $U$ 中，就是我们的属性集合

设立 $I=\{i\in[\ell]:\pi(i)\in S\}$，即属性集合对应的行索引

通过映射 $\pi$，找到矩阵中所有对应于属性集合 $S$ 的行索引，构成集合 $I$

到这里我们得到了访问结构和属性集合，那么怎么判断满足认证呢？

$(M,\pi)$ 接受 $S$，如果存在一个线性组合，让 $S$ 对应 $M$ 中的矩阵行能够线性张成目标向量 $(1,0,\ldots,0)$，并且这个线性组合可以在多项式时间内计算完成；那么就说明 $S$ 能满足我们的访问结构

那么这里我们就可以从单调布尔公式转化到Lewko–Waters要求的MSP，然后基于属性得到了验证

## 2.2 Partially hidden structure

我们如何隐藏我们的payload?

作者说最简单就是删除payload，但是payload是我们的属性，如果删除了 ABE就没有存在的意义了

所以本文使用了 部分隐藏结构

*   $S$ 是我们的属性集合 $S=\{u_i\}_{i\in[m]}$，$m$ 是 $S$ 中不同类型属性的数量
*   进一步拆分 $u_i$ 为 $n_i$ 和 $v_i$，分别代表属性名和属性值；我们要保护的是属性值，因为它包含个人隐私，即 $u_i=(n_i,v_i)$
*   访问结构 $A=(M,\pi,\{\pi(i)\}_{i\in[\ell]})$；$\pi$ 把行转化为属性，所以可以拆分 $\pi(i)=(n_{\pi(i)},v_{\pi(i)})$

然后我们可以应用部分隐藏结构：访问结构 $A$ 中的 $v_{\pi(i)}$ 和属性集合中的 $v_i$ 不会在密文或密钥中暴露

我们只会对外公开 $n_i$，也就是属性名

我们会在后续说明  部分隐藏结构  如何实现

下面给个例子说明：

如果有一个访问结构是：

(Title: Professor OR Years: 10) AND (Subject: Surgery)

属性集合是

\[Title: Doctor, Years: 5, Subject: Surgery]

那么部分隐藏结构就是：

(Title OR Years) AND Subject

那么部分隐藏属性值是：

\[Title, Years, Subject]

## 2.3 Bilinear maps and assumption

这里我们会介绍Type3类型的双线性配对和DLIN假设

## 第三类非对称双线性配对

之前学习的配对都是基于一个群的输入，但 Type-3 配对增加了一个群

所以映射为 $e:G_1\times G_2\to G_T$

其中 $G_1,G_2,G_T$ 都是阶数为 $p$ 的循环群

并且有一个条件：

$G_1$ 和 $G_2$ 之间不存在高效可计算的同构

如果存在高效可计算的映射 $\phi:G_1\to G_2$ 并保持群运算，那么由于阶数都是素数，它可以升级为同构；Type-3 配对假设这样的高效同构不存在

无法高效计算：你知道 $g_1^a$ 这个群元素，但不代表你知道指数 $a$

所以即使知道 $g_1^a$，也无法高效计算出 $g_2^a$，除非能破解离散对数

## DLIN假设(判定性线性假设)

我们构建参数

$$\mathsf{par}\gets\mathsf{GroupGen}(1^\lambda)$$

从 $\mathbb{Z}_p$ 中随机选择 $x_1,x_2,y_1,y_2,R$

设立：

$$D=(g_1^{x_1},g_1^{x_2},g_2^{x_1},g_2^{x_2},g_1^{x_1y_1},g_1^{x_2y_2},g_2^{x_1y_1},g_2^{x_2y_2})$$

$$T_0=(g_1^{y_1+y_2},g_2^{y_1+y_2})$$

$$T_1=(g_1^R,g_2^R)$$

DLIN 要求区分 $T_0$ 和 $T_1$

# 2.4 Security definitions of ABE and A²BE

这里会对安全性和匿名性进行安全模型和GAME的定义

因为本文主要是针对 CP-ABE和KP-ABE

并且他们具有细小不同，所以尝试使用同一的定义

我们使用描述 $x,y$ 作为访问结构 $A$ 和属性集合 $S$

*   对于 KP-ABE 和 KP-A²BE：$x=A$ 是访问结构，$y=S$ 是属性集合
*   对于 CP-ABE 和 CP-A²BE：$x=S$，$y=A$
*   定义函数 $P(x,y)$：如果属性集合 $S$ 满足结构 $A$ 输出 1，否则输出 0
*   定义 $pl_x$ 为与私钥关联的 Payload，$pl_y$ 为与密文关联的 Payload
*   对于部分 A²BE：$pl_S=\{n_i\}_{i\in[m]}$，$pl_A=(M,\pi,\{n_{\pi(i)}\}_{i\in[\ell]})$

ok这里我们重新梳理一下 这样进入下面就不会混乱

1.  x是和密钥绑定的访问控制信息

2.  y是和密文绑定的访问控制信息

    1.  这两个在CP和KP都有对应的
    2.  KP中 x就是访问机构A y就是用户属性
    3.  CP中 x就是用户的属性 y就是访问结构

3.  ply是可以暴露的密文相关的访问控制信息

4.  plx是可以暴露的密钥相关的访问控制信息

下面我们将会定义ABE/A²BE的语法 和表明他的正确性：

### Syntax

对于一个具有明文空间M的ABE（A²BE)：

*   $\mathsf{Setup}(1^\lambda)$：输入安全参数，输出公开参数 $PK$ 和主密钥 $MK$
*   $\mathsf{KeyGen}(PK,MK,x)$：输入私钥绑定的访问控制信息 $x$、$MK$ 和 $PK$，产生对应的 $sk_x$ 和 $pl_x$（允许直接暴露的访问控制信息）
*   $\mathsf{Enc}(PK,y,m)$：输入公开参数 $PK$ 和密文侧访问控制信息 $y$，输出密文和可以暴露的密文访问控制信息 $pl_y$
*   $\mathsf{Dec}(pl_x,pl_y,ct_y,sk_x)$：
    *   $pl_x$ 是可以暴露的密钥访问控制信息
    *   $pl_y$ 是可以暴露的密文访问控制信息
    *   $ct_y$ 是基于密文访问控制信息产生的密文
    *   $sk_x$ 是基于密钥访问控制信息产生的密钥
    *   如果 $P(x,y)=1$ 就输出 $M$，否则输出 $\bot$

### Correctness

正确性：如果 $P(x,y)=1$ 且 $m\in\mathcal{M}$，那么解密是确定性的，并且

$$\Pr[\mathsf{Dec}(pl_x,pl_y,ct_y,sk_x)=m]=1$$

那么 ABE表示的是 密文不会揭露任何和明文有关的信息——IND-CPA【选择明文攻击下的不可区分性】

那么对于A²BE我们需要增加，使得密文不会揭露任何和明文与属性值相关的信息——Anonymous(Anon)

### IND-CPA安全

这里简单描述一下 IND-CPA安全

*   **Setup**：产生 $PK$ 和 $MK$，把 $PK$ 交给敌手
*   **P1**：敌手请求密钥产生预言机，获得 $(sk_x,pl_x)$
*   **Challenge**：敌手声明挑战的密文侧访问控制信息 $y^*$，选择两个等长消息 $m_0,m_1$，要求之前查询过的 $x$ 都不满足 $P(x,y^*)=1$；然后获得挑战密文 $CT$ 和 $pl_{y^*}$
*   **P2**：和 P1 一样，但不能查询满足 $P(x,y^*)=1$ 的 $x$
*   **Guess**：敌手输出 $b'$

> 一个 ABE 方案是自适应 IND-CPA 安全的，如果
>
> $$\mathsf{Adv}^{\mathsf{CPA}}_{\mathsf{Game1},\mathcal{A}}(\lambda)=|\Pr[b'=b]-1/2|$$
>
> 是可忽略的

### Anonymous安全

对于A²BE方案，我们需要保证匿名：

*   Payload隐私：对于和密文一起发送的Payload不会揭露任何属性值
*   密文隐私：对于密文，不会揭露任何明文相关和属性值

我们依旧可以使用一个安全游戏描述Anonymous

*   **Setup**：输入安全参数，输出 $MK$ 和 $PK$，把 $PK$ 交给敌手
*   **P1**：敌手请求密钥产生预言机，获得 $(sk_x,pl_x)$
*   **Challenge**：敌手输出两个等长明文和两个不同的密文侧访问控制信息 $y_0,y_1$，要求之前查询过的所有 $x$ 都满足 $P(x,y_0)=P(x,y_1)$；Game 随机选择 $b$，选择对应的明文和 $y_b$，把 $(ct,pl_{y_b})$ 交给敌手
*   **P2**：和 P1 一样
*   **Guess**：猜测 $b$

> 一个 A²BE 方案是自适应 anonymous 的，如果
>
> $$\mathsf{Adv}^{\mathsf{Anon}}_{\mathsf{Game2},\mathcal{A}}(\lambda)=|\Pr[b'=b]-1/2|$$
>
> 是可忽略的

# 3 OUR SCHEMES

这里是论文核心内容，所以是一个难啃的骨头，我们一起加油

我们会从最快的KP-ABE开始说明：FABEO，这个ABE提供了下面功能：

1.  任意的布尔公式
2.  不会约束属性的类型和大小
3.  通过第三类型的配对构建
4.  对于解密只需要恒定两个配对即可

但是他也有没做到的内容：

1.  没有实现匿名
2.  IND-CPA的安全是基于GGM的

所以后续基于FABEO 又提出了 FEASE，从而实现匿名，但是FEASE也是基于GGM的

所以本文路线出现了：

1.  通过FABEO KP-ABE 使用随机性拆分技术转化到 FEASE KP-ABE上
2.  修改FEASE KP-ABE达到基于DLIN假设下的密文匿名
3.  转化FEASE KP-ABE 到 FEASE CP-ABE
4.  应用部分隐藏结构，让FEASE转化到FABESA 实现Anon

所以本文其实主要是 让FEASE 提升到 DLIN的安全假设下，其他都是构建组件等

路线如下：

![\<img alt="" width="1689" height="189" data-attachment-key="SQ6MVN26" src="attachments/SQ6MVN26.png" ztype="zimage"> | 1689](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261114093246713.png)

现在我们会开始一个一个说明 首先进入FABEO

## 3.1 From FABEO KP-ABE to FEASE KP-ABE

首先我们进入

### FABEO  的架构

#### 1. Setup

> - **输入**：安全参数
> - **输出**：公开参数 $PK$、主密钥 $MK$

- 运行群产生函数，得到 $\mathsf{par}=(p,e,G_1,G_2,G_T,g_1,g_2)$
- 从 $\mathbb{Z}_p$ 随机选择 $a$
- 构建哈希函数 $H$，把随机字符串映射到 $G_1$
- $PK=(\mathsf{par},H,e(g_1,g_2)^a)$，$MK=a$

#### 2. KeyGen

> - **输入**：访问结构 $A$、$MK$、$PK$
> - **输出**：解密密钥 $sk$、公开信息 $pl_A$

- 随机选择 $r,v\in\mathbb{Z}_p$
- $sk_1=g_2^r$
- 对每行 $i$：$sk_{2,i}=g_1^{M_i(\alpha\|v)^T}H(\pi(i))^r$

其中 $sk_1$ 是完全随机值；$sk_{2,i}$ 是用户份额；$g_1^{M_i(\alpha\|v)^T}$ 用 LSSS 把秘密份额编码到群元素中；$H(\pi(i))^r$ 把私钥组件与对应属性关联，并利用 $r$ 随机化

#### 3. Enc

> - **输入**：$PK$、属性集合 $S$
> - **输出**：密文 $ct$、$pl_S=S$

- 随机选择 $s\in\mathbb{Z}_p$
- $ct_{1,i}=H(u_i)^s$，把属性转到群中
- $ct_2=g_2^s$，保留随机值
- $ct_3=e(g_1,g_2)^{as}\cdot \mathsf{msg}$，主要密文
- 输出 $ct=(\{ct_{1,i}\},ct_2,ct_3)$，$pl_S=S$

#### 4. Dec

> - **输入**：$ct$、$sk$
> - **输出**：明文或 $\bot$

- 如果子集 $I$ 能在 $A$ 中匹配到 $S$，允许解密，否则输出 $\bot$
- 计算重建系数 $\gamma_i$，使得 $\sum_{i\in I}\gamma_i M_i=(1,0,\ldots,0)$
- 通过 Type-3 配对计算明文：

![\<img alt="" width="628" height="198" data-attachment-key="F4VYV9QV" src="attachments/F4VYV9QV.png" ztype="zimage"> | 628](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261114093246715.png)

可以发现整个 FABEO   思路还是简单的，没有什么困难的地方，密钥和密文嵌入也挺清晰的，那么我们需要解决FABEO  的两个缺点：

1.  不提供 payload 保护：FABEO 会直接暴露 $S$ 的属性值和属性名，也就是不提供 Anon
2.  不提供密文匿名：密文基于不同属性加密，敌手可以通过属性直接判断出密文
    1.  我们使用两个属性 $u_0,u_1$
    2.  构建密文 $ct=(ct_{1,u_b},ct_2)$
    3.  敌手可以直接通过配对判断出 $b$ 是 0 还是 1
    4.  $e(ct_{1,u_b},g_2)=e(H(u_b),ct_2)$

所以在后面我们需要使用部分隐藏结构去转化到 Anon 上

下面我们介绍 FEASE，但是由于之前发布的主要是 FABEO  Anon类型，所以我们需要先去除 部分隐藏结构 我们才可以构建出我们的方案，从而规约到 DLIN上

所以下面介绍

### 去除匿名的FEASE架构

#### 1. Setup

> - **输入**：安全参数
> - **输出**：$PK$、$MK$

- 使用群产生算法得到 $\mathsf{par}=(p,e,G_1,G_2,G_T,g_1,g_2)$
- 随机选择 $a,b_1,b_2\in\mathbb{Z}_p$
- 构建哈希函数 $H$ 映射到 $G_1$
- $PK=(\mathsf{par},H,g_2^{b_1},g_2^{b_2},e(g_1,g_2)^a)$，$MK=(a,b_1,b_2)$

#### 2. KeyGen

> - **输入**：$PK$、$MK$、$A$
> - **输出**：解密密钥 $sk$、公开信息 $pl_A$

- 随机选择 $r,v\in\mathbb{Z}_p$
- $sk_1=g_2^r$
- $sk_{2,i}=(g_1^{M_i(\alpha\|v)^T}H(\pi(i))^r)^{1/b_1}$
- $sk_{3,i}=(g_1^{M_i(\alpha\|v)^T}H(\pi(i))^r)^{1/b_2}$
- 输出 $sk=(sk_1,\{sk_{2,i},sk_{3,i}\})$，$pl_A=A$

#### 3. Enc

> - **输入**：明文 $m$、$PK$、属性集合 $S$
> - **输出**：密文 $ct$、$pl_S=S$

- 随机选择 $s_1,s_2\in\mathbb{Z}_p$，令 $s=s_1+s_2$
- $ct_{1,i}=H(u_i)^s$
- $ct_2=g_2^{b_1s_1}$
- $ct_3=g_2^{b_2s_2}$
- $ct_4=e(g_1,g_2)^{as}m$
- 输出 $ct=(\{ct_{1,i}\},ct_2,ct_3,ct_4)$，$pl_S=S$

可以发现 $A$ 和 $S$ 都没有被隐藏，<span style="color: rgb(255, 32, 32);">这只是基于 FEASE 的标准 KP-ABE</span>

#### 4. Dec

> - **输入**：$ct$、$sk$
> - **输出**：明文或 $\bot$

- 如果子集 $I$ 能在 $sk$ 的 $A$ 中匹配到 $ct$ 中的 $S$，允许解密
- 计算重建系数 $\gamma_i$，满足 $\sum_{i\in I}\gamma_i M_i=(1,0,\ldots,0)$
- 恢复消息：

![\<img alt="" width="882" height="198" data-attachment-key="TBJENIML" src="attachments/TBJENIML.png" ztype="zimage"> | 882](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261114093246716.png)

到这里 不匿名的FEASE 构架完毕了

我们可以使用 <span style="color: rgb(255, 32, 32);">随机分裂技术 转化到实现密文匿名，但是没有实现 Anon（因为 payload 没有匿名）</span>

### 随机分裂技术

可以观察到，我们把随机值 $s$ 拆为 $s_1,s_2$，满足 $s=s_1+s_2$

并且产生了多个密文组件 $ct_{1,i},ct_2,ct_3$

修改私钥：FEASE 把 $sk_2$ 组件复制成两份，分别使用 $1/b_1$ 和 $1/b_2$ 作为指数

这里的目的是在配对中抵消随机值，最终恢复原来的 $s$

总的来说：FEASE 通过随机数拆分修改密文，同时调整私钥，使合法解密仍然成立，并阻止原 FABEO 中直接利用 Pairing 猜测属性的攻击

那么到此 FEASE 基于随机分裂技术在 FABEO 上构建出了密文匿名的特点

但是这个版本只能基于 GGM 假设证明安全

如果我们强行降低到 DLIN假设，我们无法模拟所有的密文组件

并且对于敌手的密钥问询，模拟者无法很好通过DLIN元组给出

所以这里提出了问题：

> 如何模拟密文和密钥，对于使用DLIN元组的FEASE  KP-ABE算法，并且不会折损效率

那么就进入到本文修改的算法了

## 3.2 From FEASE KP-ABE to our ABE schemes

我会先进行介绍 本文ABE 具体架构是什么

然后说明是如何从FEASE 一步一步构造到本文方案中的

#### 1. Setup

> - **输入**：安全参数
> - **输出**：$PK$、$MK$

- 运行群产生算法，得到 $\mathsf{par}=(p,e,G_1,G_2,G_T,g_1,g_2)$
- 随机选择 $a,b_1,b_2\in\mathbb{Z}_p$
- 构建哈希函数 $H$，把随机字符串映射到群上
- $PK=(H,\mathsf{par},g_2^{b_1},g_2^{b_2},e(g_1,g_2)^a)$
- $MK=(a,b_1,b_2)$

#### 2. KeyGen

> - **输入**：访问结构 $A$、$PK$、$MK$
> - **输出**：嵌入 $A$ 的密钥 $SK$、$pl_A=A$

- 随机选择 $r,v\in\mathbb{Z}_p$
- $sk_1=g_2^r$
- $sk_{2,i}=g_1^{M_i(\alpha\|v)^T}H(\pi(i))^{-r}$
- $sk_{3,i}=H(0\|\pi(i))^{r/b_1}$
- $sk_{4,i}=H(1\|\pi(i))^{r/b_2}$
- 输出 $sk=(sk_1,\{sk_{2,i},sk_{3,i},sk_{4,i}\})$，$pl_A=A$

#### 3. Enc

> - **输入**：$PK$、消息 $M$、属性集合 $S$
> - **输出**：密文 $ct$、$pl_S=S$

- 随机选择 $s_1,s_2\in\mathbb{Z}_p$，令 $s=s_1+s_2$
- $ct_{1,i}=H(u_i)^s H(0\|u_i)^{s_1}H(1\|u_i)^{s_2}$
- $ct_2=g_2^s$
- $ct_3=g_2^{b_1s_1}$
- $ct_4=g_2^{b_2s_2}$
- $ct_5=e(g_1,g_2)^{as}M$
- 输出 $ct=(\{ct_{1,i}\},ct_2,ct_3,ct_4,ct_5)$，$pl_S=S$

#### 4. Dec

> - **输入**：$SK$、$CT$、$pl_A$、$pl_S$
> - **输出**：明文或 $\bot$

- 如果 $I$ 能在 $sk$ 的 $A$ 中匹配到 $S$，允许解密
- 只需计算单位向量并使用 4 次配对：

![\<img alt="" width="749" height="152" data-attachment-key="25Q2Y8M2" src="attachments/25Q2Y8M2.png" ztype="zimage"> | 749](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261114093246717.png)

<span style="background-color: rgba(255, 102, 102, 0.5);">从FEASE到本文ABE方案：主要解决的事情是密文匿名</span>

所以我们需要关注的是：

1.  密文是如何变化的
2.  私钥是如何变化的
3.  解密是如何进行的

因为需要规约到 DLIN，DLIN 给定的条件是

$$\mathsf{par}=(p,G_1,G_2,G_T,e,g_1,g_2)$$

以及挑战元组

$$g_1^{b_1},\quad g_1^{b_2},\quad g_1^{b_1s_1},\quad g_1^{b_2s_2},\quad T$$

我们需要通过这些已知条件模拟 GAME，从而完成规约

需要看 FEASE 中什么是无法模拟的——其实就是随机选择的 $b_1,b_2$

![\<img alt="" width="858" height="77" data-attachment-key="8KTSC9JS" src="attachments/8KTSC9JS.png" ztype="zimage"> | 858](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261114093246718.png)

所以我们直接对原始 FEASE 修改，强行构造新的 $sk_{2,i}$ 和 $sk_{3,i}$：

$$sk_{2,i}=g_1^{M_i(\alpha\|v)^T}H(\pi(i))^{r/b_1}$$

$$sk_{3,i}=g_1^{M_i(\alpha\|v)^T}H(\pi(i))^{r/b_2}$$

因为修改了私钥组件，所以也需要修改密文 $ct_4$，让它能正确解密：

$$ct_4=e(g_1,g_2)^{a b_1 s_1 + a b_2 s_2}$$

这样随机数 $b_i$ 只会出现在随机预言机的指数上，并且可以保证解密正常

然后使用 FAME 的技术去除 $b_1,b_2$

### FAME 技术

我们使用 $u=\pi(i)$，现在需要模拟 $H(u)^{r/b_1}$

但是 DLIN 只会提供 $g^{b_1}$

因为不知道 $b_1$，所以无法计算出 $r/b_1$

于是 FAME 把哈希输入分成两种：$H(0\|u)$ 和 $H(1\|u)$

在安全证明中可以设立随机预言机：

$$H(0\|u)=(g_1^{b_1})^t$$

其中 $t$ 是模拟器选择的

现在计算私钥：

$$H(0\|u)^{r/b_1}=((g_1^{b_1})^t)^{r/b_1}=g_1^{tr}$$

可以发现 $b_1$ 被消去了，只留下已知的 $r$ 和 $t$，从而模拟器可以给出私钥组件

### 后续内容

但是这个时候出现问题了：<span style="background-color: rgba(255, 102, 102, 0.5);">密文和私钥中的哈希值不再匹配，导致无法正确解密</span>

所以需要对密文组件 $ct_{1,i}$ 也修改：

$$ct_{1,i}=H(0\|u_i)^{s_1}H(1\|u_i)^{s_2}$$

这样就解决了不匹配的问题

但是可以发现，这里没有了 DLIN 需要判别的 $g_1^s$

所以需要继续加入 $H(u_i)^s$，最终得到：

$$ct_{1,i}=H(u_i)^s H(0\|u_i)^{s_1}H(1\|u_i)^{s_2}$$

现在可以把 $ct_{1,i}$ 归约到 DLIN 上，下一步是把 $ct_5$ 规约到 DLIN 上

也就是

$$ct_5=e(g_1,g_2)^{a b_1 s_1 + a b_2 s_2}M$$

但是 DLIN 的 $g^{s_1+s_2}$ 没有出现在 $ct_5$ 中

所以需要构造出

$$ct_5=e(g_1,g_2)^{as}M$$

的结构

于是构造

$$sk_{2,i}=g_1^{M_i(\alpha\|v)^T}H(\pi(i))^{-r}$$

我们记

$$\lambda_i=M_i(\alpha\|v)^T$$

之前的 LSSS 份额在 $sk_3$ 和 $sk_4$ 中，我们迁移到 $sk_2$ 去：<span style="background-color: rgba(255, 102, 102, 0.5);">因为我们希望得到的是 $\alpha s$，而不是 $\alpha(b_1s_1+b_2s_2)$</span>

之前得到了

$$ct_2=g_2^s$$

所以作者直接让份额和这个配对，从而构造出

于是秘密份额直接迁移到 $sk_2$ 上：

$$\boxed{sk_{2,i}=g_1^{\lambda_i}H(\pi(i))^{-r}}$$

使用配对对 $sk_2$ 和 $ct_2$ 就可以构建出

$$e(g_1,g_2)^{as}$$

于是可以直接改写 $ct_5$ 作为密文：

$$ct_5=e(g_1,g_2)^{as}M$$

那么对于 $sk_3,sk_4$，就是直接迁移走，保留下：

$$H(0\|u)^{r/b_1},\qquad H(1\|u)^{r/b_2}$$

到此全部构建完成

重新梳理过程：

1. 强行修改 $sk_{2,i}$ 和 $sk_{3,i}$，去除 $b_i$ 的影响
2. FAME 修改哈希输入；为了解密成功，密文组件中的属性组件 $ct_{1,i}$ 也需要修改
3. 但即使修改了也没有规约需要的 $g^s$，所以 $ct_{1,i}$ 继续增加内容
4. 因为 $ct_{1,i}$ 增加了，所以还需要一个组件去去除；新增 $sk_{2,i}$ 和 $ct_2$ 都修改以便解密时去除，<span style="color: rgb(255, 32, 32);">这个时候之前的 $sk_{2,i},sk_{3,i}$ 变为了 $sk_{3,i},sk_{4,i}$</span>
5. 对于 $ct_5$ 还发现问题：需要构造出 $g^s$ 而不是 $g^{b_1s_1+b_2s_2}$，否则不符合 DLIN 假设格式
6. 把 LSSS 份额从 $sk_{3,i},sk_{4,i}$ 迁移到 $sk_{2,i}$，这样 $sk_{2,i}$ 和 $ct_2$ 配对可以构建出 DLIN 需要的内容

### Natural transformation to CP-ABE

上面构建出一个 KP-ABE，我们可以通过语法转换构建出对应的 CP-ABE

访问结构和密文相联系

也就是把 $ct_{1,i}$ 中的 $H(u_i)^s$ 改为访问策略，并且后续转化为 LSSS 份额即可

并且从迁移过程中，我们保持了密文匿名——后面证明会说明为什么保证了匿名

## 3.3 From our ABE to our A²BE schemes

现在我们保证了密文的匿名，为了构建出 Anon（payload privacy），需要增加部分隐藏结构，让 ABE 达到 A²BE

1.  对于访问结构 $A$，转化为 $A=\{(n_{\pi(i)},v_{\pi(i)})\}_{i\in[\ell]}$，对外暴露的内容记作 $pl_A=(M,\pi,\{n_{\pi(i)}\}_{i\in[\ell]})$
2.  对于身份属性 $S$，转化为 $S=\{(n_i,v_i)\}_{i\in[m]}$，对外暴露的 $pl_S=\{n_i\}_{i\in[m]}$

3.  那么现在对于解密算法 $\mathsf{Dec}$：
    1.  测试 $pl_S$ 中是否可以匹配到 $pl_A$ 的属性名，如果连属性名都匹配不到就别说值了
    2.  检查是否存在可能满足访问策略的矩阵行集合 $I$
    3.  如果不满足就终止
    4.  如果满足就找到重建系数 $\gamma_i$，构建 $\sum_{i\in I}\gamma_i M_i=(1,0,\ldots,0)$
    5.  然后使用对应密文组件和私钥组件进行 Pairing 尝试恢复明文
    6.  如果消息是错误的，那么就找另一个可能满足访问策略的矩阵行集合 $I$
    7.  如果消息对于所有子集都无法恢复，那么就终止

为什么需要测试所有的 $I$？

我们的 $A$ 要求 (角色=医生) OR (角色=护士)，但是我的密文属性是 (角色=医生)

所以进行恢复的时候会测试两个分支  (角色=医生) 和   (角色=护士) 有一个通过就可以

所以需要比较所有的分支才可以

那么到这里 所有架构构造就结束了，下面就进入安全分析和其他内容，然后就是具体数据比较

## 3.4 Further remarks

这里说明一下和不同方案我们的优势

### 技术层面

FAME 基于 k-Lin（k=1 时为 DLIN）

FEASE 达到了基于 GGM 的密文匿名

*   对于这两个，本文方案避免了 $b_1,b_2$ 的规约约束
*   对于 FAME：本文的密文直接和 $g^s$ 关联，而 FAME 是和 $g^{s_1},g^{s_2}$ 关联的，所以我们可以基于 DLIN 安全假设
*   对于 FEASE，我们使用不同的 Oracle 去模拟 $b$ 并且规约到了 DLIN 下，而它只规约到了 GGM 下的安全并且使用了一个随机 oracle

### 应用层面

*   我们基于大属性域，属性可以任意组合没有约束
*   表达：使用了MSP，可以构建不同的单调布尔
*   属性多次出现，我们使用随机化处理，防止一个属性多次出现导致的错误

# 4 SECURITY ANALYSIS OF OUR SCHEMES

现在进入安全规约 并且证明我们的方案基于DLIN假设

> Theorem 1. Our KP-ABE scheme is adaptively IND-CPA secure in the random oracle model under the DLIN assumption

开始证明 我们有一个模拟者B 去解决DLIN难题

有一个敌手A 去攻击本文方案KP-ABE，基于IND-CPAgame

## 对于KP-ABE的安全规约

现在我们设立B已知的条件

$$x_1=b_1,\quad x_2=b_2,\quad y_1=s_1,\quad y_2=s_2$$

这里是把方案中的随机值写入 DLIN 的未知条件，这样敌手后面攻击时，$B$ 就可以基于这些内容攻破 DLIN

现在设立元组 $(A,B,C,D,E,F,G,H,I,J,Y,Z)$ 并交给模拟者 $B$，$B$ 基于这个元组解决 DLIN 难题

*   $A=g_1$
*   $B=g_2$
*   $C=g_1^{b_1}$
*   $D=g_1^{b_2}$
*   $E=g_2^{b_1}$
*   $F=g_2^{b_2}$
*   $G=g_1^{b_1s_1}$
*   $H=g_1^{b_2s_2}$
*   $I=g_2^{b_1s_1}$
*   $J=g_2^{b_2s_2}$
*   $Y$
*   $Z$

我们要求 $s=s_1+s_2$

$B$ 对于解决 DLIN 难题设立如下：

1.  $B$ 抛硬币选择比特 $0/1$
2.  如果是 0，就基于 DLIN 元组得到 $Y=g_1^s$，$Z=g_2^s$
3.  如果是 1，就随机选择得到 $Y=g_1^R$，$Z=g_2^R$

B的目标是对于得到的内容 输出判断这个比特是0还是1，那么他要解决这个问题就要基于敌手A攻破本文方案：

### GAME

*   **Setup**：$B$ 随机选择 $a\in\mathbb{Z}_p$，并产生公开参数
    *   $B$ 把 $PK=(H,p,G_1,G_2,G_T,e,A,B,E,F,e(A,B)^a)$ 交给 $A$
    *   $B$ 保留 $MK=a$

*   **P1**：$A$ 可以询问两个预言机：随机哈希预言机 $H$ 和密钥产生预言机 $O_k$；$B$ 模拟这两个预言机
    *   $H(\cdot)$：$B$ 维护三个列表 $(x_i,h_i,k_i)$、$(0\|x_i,h_{0i},t_i)$、$(1\|x_i,h_{1i},\delta_i)$
    *   $A$ 可以请求三种输出：
        *   $x_i$：若列表已有，输出 $H(x_i)=h_i$；否则随机选择 $k_i\in\mathbb{Z}_p$，计算 $h_i=A^{k_i}$，写入列表并输出
        *   $0\|x_i$：若列表已有，输出 $H(0\|x_i)=h_{0i}$；否则随机选择 $t_i\in\mathbb{Z}_p$，计算 $h_{0i}=C^{t_i}$，写入列表并输出
        *   $1\|x_i$：若列表已有，输出 $H(1\|x_i)=h_{1i}$；否则随机选择 $\delta_i\in\mathbb{Z}_p$，计算 $h_{1i}=D^{\delta_i}$，写入列表并输出
    *   $O_k(\cdot)$：$A$ 询问访问结构对应的私钥
        *   $B$ 运行 $H(\cdot)$，对每个属性计算上面三个内容
        *   随机选择 $r\in\mathbb{Z}_p$，向量 $v\in\mathbb{Z}_p^n$
        *   计算私钥组件：
            *   $sk_1=B^r$
            *   $sk_{2,i}=A^{M_i(\alpha\|v)^T-k_ir}$
            *   $sk_{3,i}=A^{t_ir}$
            *   $sk_{4,i}=A^{\delta_ir}$
        *   <span style="color: rgb(255, 32, 32);">这里的 $b_i$ 被抵消了，所以可以规约到 DLIN</span>

*   **Challenge**：$A$ 输出两个等长消息，并自适应选择挑战属性集合 $S^*$；$B$ 检查之前问询过的访问结构是否都不接受 $S^*$如果没有，随机选择 $\beta\in\{0,1\}$ 计算密文
    *   $B$ 运行随机预言机 $H$ 得到 $S^*$ 中所有哈希值
    *   计算挑战密文：
        *   $ct_{1,i}=Y^{k_i}G^{t_i}H^{\delta_i}$
        *   $ct_2=Z$
        *   $ct_3=I$
        *   $ct_4=J$
        *   $ct_5=e(Y,B)^a M^*$
    *   这里应用了 $B$ 对 DLIN 的挑战；如果 $B$ 抛硬币是 0，就使用 DLIN 元素，否则里面的内容都是随机选择的

*   **P2**：和 P1 一样进行问询

*   **Guess**：$A$ 基于信息输出 $\beta$ 的值，$B$ 基于猜测值输出 DLIN 难题的答案

到这里对于本方案 KP-ABE 的规约结束

其实就是：成功把 $b_1,b_2$ 消除后，$B$ 就可以基于已知消息全部模拟出 $A$ 的问询，从而规约完毕

后续的安全规约不再说明

大概思路就是这样，只是参数不同

并且论文在这里也没有讨论基于 DLIN 假设下的自适应匿名

# 5 IMPLEMENTATIONS

这章节其实就是一些数据和比较 说明自己处于的位置在哪里

首先说明了基于 BN254 曲线上的配对速度

![\<img alt="" width="830" height="180" data-attachment-key="TAQ9D9LT" src="attachments/TAQ9D9LT.png" ztype="zimage"> | 830](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261114093246719.png)

然后比较了 使用CGW测量100单位属性的ABE方案的setuptime

![\<img alt="" width="746" height="305" data-attachment-key="G2B65NKM" src="attachments/G2B65NKM.png" ztype="zimage"> | 746](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261114093246720.png)

后面给出了大量对比图 测速图

上面是KP-ABE的下面是CP-ABE的

![\<img alt="" width="1846" height="1048" data-attachment-key="ZHQAYP6E" src="attachments/ZHQAYP6E.png" ztype="zimage"> | 1846](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261114093246721.png)

还有具体的群元素相关的比较

![\<img alt="" width="1563" height="529" data-attachment-key="Y278MNQ7" src="attachments/Y278MNQ7.png" ztype="zimage"> | 1563](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261114093246722.png)

这里我们就继续跳过

# 6 RELATED WORKS

其实我觉得这一章节更应该在前面提及

可以为我们展示很好的框架

## 6.1 State-of-the-art ABE schemes

目前最好的ABE方案 具有下面类型

*   BSW CP-ABE
*   GPSW KP-ABE
*   Waters CP-ABE
*   CGW KP-ABE and CP-ABE
*   ABGW KP-ABE and CP-ABE
*   FAME KP-ABE and CP-ABE
*   FABEO KP-ABE and CP-ABE

只有 BSW 和 FABEO 提供了大属性域、任意属性字符串和单一属性多次出现的功能

本文ABE方案基于的是FABEO 所以天然继承了这些优点

ABE 的证明模型常见有两类：

*   ROM：random oracle model，假设哈希函数被当作随机预言机
*   STM：standard model，不依赖随机预言机

具体方案：

*   BSW：GGM
*   GPSW：标准模型（选择性安全，DBDH）
*   Waters：标准模型
*   FAME：标准模型（k-Lin + 双系统加密）
*   FABEO：GGM
*   CGW、ABGW：标准模型
*   本文：ROM + DLIN

对于安全规约，常见有两类：

*   GGM：generic group model，敌手只能进行通用群运算
*   Standard Assumption：基于 DH 类困难问题，比 GGM 的假设更标准

BSW、FABEO 基于 GGM；CGW、FAME 基于 k-Lin 和双系统加密；GPSW、Waters 可以达到标准假设下的安全

本文基于DLIN安全假设和ROM模型，构建出自适应的安全，并且证明方法比使用双重加密框架更加简便

保证了我们 在达到高安全的情况下，达到了高效率

但是找到一个方法让 STM 代替 ROM 依旧是一个研究方向

![\<img alt="" width="1673" height="298" data-attachment-key="VJNGDYTA" src="attachments/VJNGDYTA.png" ztype="zimage"> | 1673](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261114093246723.png)

## 6.2 Anonymous ABE schemes

对于 Fully A²BE 提出了 IPE 方案，实现了富有表现力的 A²BE，并且开展了后续发展，但是 IPE 具有许多受限的内容

所以我们基于的是 Partially A²BE

最开始只可以支持 AND 门，并且 KP-A²BE 的关注比 CP-A²BE 少

后面有人提出了部分隐藏结构，可以转化 ABE 方案到 A²BE

并且继续提出了支持 NOT 门的访问结构策略

![\<img alt="" width="1736" height="431" data-attachment-key="FATVG78Y" src="attachments/FATVG78Y.png" ztype="zimage"> | 1736](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261114093246724.png)

# 7 CONCLUSION

到达本文最后了，这里会进入总结下

本文使用了 DLIN 安全假设，使得 fast ABE 达到了自适应安全

并且让其包含了密文匿名，并且可以通过部分隐藏结构转换到 A²BE 去

那么未来工作就是不再基于 ROM 模型证明安全

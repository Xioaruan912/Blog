# Ciphertext-Policy Attribute-Based Encryption: An Expressive, Efficient, and Provably Secure Realization

这里介绍 CP-ABE 的一个新构造，解决之前 CP-ABE 的密文/密钥大小问题

之前的 CP-ABE 在证明中使用的是通用群模型（generic group model），对敌手的群运算作了限制

本文的 CP-ABE 可以在标准模型下证明安全

# Abstract

本文展示了一个具体的 CP-ABE 构造，安全证明基于标准模型

在支持任意访问控制公式的前提下，密文大小、加密时间和解密时间都与访问控制公式线性相关

后续会展示该框架下的几个构造：

1. 在 PBDHE（Decisional Parallel Bilinear Diffie-Hellman Exponent）假设下给出选择性安全构造；PBDHE 可以看作 BDHE 的平行扩展
2. 进一步把安全性归约到更弱的 BDHE 和 BDH 假设

**BDHE（Bilinear Diffie-Hellman Exponent）**：

给敌手

$$g,\ g^s,\ g^a,\ g^{a^2},\ldots,g^{a^d},\ g^{a^{d+2}},\ldots,g^{a^{2d}}$$

这里故意少给 $g^{a^{d+1}}$，再给一个目标元素 $T$，要求敌手判断

$$T=e(g,g)^{a^{d+1}s}$$

还是 $T$ 是随机群元素

**DBDH（Decisional Bilinear Diffie-Hellman）**：

给定 $g^a,g^b,g^c$ 和一个元素 $T$，判断

$$T=e(g,g)^{abc}$$

还是 $T=e(g,g)^z$

# 1 Introduction

这里从公钥密码学慢慢说明到我们的CP-ABE，那么这里我跳过公钥密码学直接到FIBE开始说明

## FIBE

因为 FIBE 首次提出了 ABE 的思想：数据提供者给出一个函数 $f(\cdot)$ 描述他希望分享的数据，用户的私钥与自己的身份关联

如果 $f(x)=1$，那么具有身份 $x$ 的用户可以解密这个数据

FIBE 使用的是用户身份；在 ABE 的思想中，这个身份被扩展为属性集合

Sahai-Waters（SW）的方案受初始化的门限限制——只支持一个门限门

## KP-ABE 和 CP-ABE

后续研究首先出现了 KP-ABE，接着是 CP-ABE

KP-ABE 具有很强的表现力，允许把访问策略嵌入密钥中，并且可以证明在 DBDH 下安全；之后他们把 CP-ABE 作为一个开放问题

接下来出现了 CP-ABE：加密者可以把访问策略 $f$ 嵌入密文；但它的证明模型并不理想——使用的是通用群模型（generic group model），敌手只能进行通用群运算

随着 CP-ABE 使用需求增大，通用群模型已经不够，需要标准模型下的安全证明

## Ciphertext Policy ABE in the Standard Model

首先可以把 FIBE 看作一个只支持单个门限的 KP-ABE；通过引入“虚拟属性”，可以把它转化为 CP-ABE；这是后来的视角，在当时还没有 KP-ABE/CP-ABE 的区分

**为什么FIBE更像KP-ABE？**

因为解密门限在 Setup 时就固定，不受加密者控制；这正是 CP-ABE 要解决的问题

**如何把 FIBE 转化到 CP-ABE？**

加密者只需要对密文增加一些“虚拟属性”，就可以决定谁可以解密

Cheung-Newport（CN）给出了一个基于单个 AND 门的 CP-ABE，在 DBDH 假设下安全；但它要求属性固定，且只支持一个 AND 门，表现力甚至低于 SW 的转化

更近的研究给出了把 KP-ABE 转化为 CP-ABE 的方法，使用的是通用访问树

**通用访问树**：不再每次重新生成树，而是事先在 Setup 中确定门限数量和公式最大深度，构建出一棵固定的树

这个方法与 FIBE 的虚拟属性类似

但它有明显缺点：为了容纳大小为 $n$ 的访问公式，需要先把树转化为平衡树，再转化为完全树，规模很大

虽然它首次展示了 CP-ABE 在标准模型下的安全，但密文和私钥太大，实用性不高

## Our Contribution

本文的主要贡献是：用 LSSS 代替访问树，给出标准模型下可证明安全、且密文/密钥大小与访问公式线性相关的 CP-ABE 构造

# 2 Background

这里作者介绍了基本 CP-ABE、LSSS、安全模型和 PBDHE 难题

我们先需要理解 LSSS 和 PBDHE

## 2.1 Access Structures

这里和 CP-ABE 一样，我们复习一下

设属性域为 $U=\{P_1,P_2,\ldots,P_n\}$，其幂集为 $2^U$

访问结构 $A$ 是 $2^U$ 的一个非空子集，即 $A\subseteq 2^U$；$A$ 中的元素是“授权属性集合”

如果对于任意 $B,C$，只要 $B\in A$ 且 $B\subseteq C\subseteq U$，就有 $C\in A$，则称 $A$ 是单调的

不在 $A$ 中的集合称为未授权集合

后续我们直接使用 $A$ 表示访问结构，即所有授权属性集合组成的集合

## 2.2 Linear Secret Sharing Schemes

LSSS 是线性秘密共享方案，也是本文优化的核心：用 LSSS 代替访问树

与 SSS 不同，LSSS 使用矩阵构造，而不是多项式插值

一个秘密共享方案是线性的，只要满足：

1. 每个参与方的份额可以组成 $\mathbb{Z}_p$ 中的一个向量
2. 存在一个 $\ell\times n$ 的份额生成矩阵 $M$，以及：
   - 一个映射 $\rho$：把矩阵的第 $i$ 行分配给属性/参与方 $\rho(i)$；
   - 一个列向量 $v=(s,r_2,\ldots,r_n)$，其中 $s$ 是要共享的秘密，$r_2,\ldots,r_n\in\mathbb{Z}_p$ 随机选择；
   - 第 $i$ 个份额为 $\lambda_i=(Mv)_i$，并依据 $\rho(i)$ 分配给对应属性

到此实现了秘密共享；接下来要保证授权集合可以恢复秘密

原始的 LSSS 论文证明了：只要满足上述要求，LSSS 就具有线性重建性质

设 $S$ 是一个授权集合，$I=\{i:\rho(i)\in S\}$ 是对应行的下标集合；对于任意授权集合 $S$，都存在一组系数 $w_i\in\mathbb{Z}_p$，使得

$$\sum_{i\in I} w_i\lambda_i=s$$

并且这些 $w_i$ 可以在多项式时间内求出

**如何计算 $w_i$？**

使用目标向量 $(1,0,\ldots,0)$，只要找到系数 $w_i$ 使得

$$\sum_{i\in I} w_i M_i=(1,0,\ldots,0)$$

其中 $M_i$ 是 $M$ 的第 $i$ 行，就说明这组 $w_i$ 可以用于恢复秘密

目标向量也可以判断一个集合是否有资格恢复秘密：能解出 $w_i$ 就有资格，否则没有资格

对于未授权集合，一定存在向量 $w$，使得

$$w\cdot(1,0,\ldots,0)=-1,\qquad w\cdot M_i=0\quad(i\in I)$$

在 SSS 中，要求 $d$ 个点复原 $d-1$ 次多项式；而在 LSSS 中不再约束 $d$ 的数量，而是判断某个授权集合对应的矩阵能否通过线性组合转化为目标向量

**为什么可以恢复出 $s$？**

秘密共享基于 $v=(s,r_2,\ldots,r_n)$，通过 $Mv$ 得到一个列向量，每一行都包含 $s$ 和随机值的线性组合；比如：

![\<img alt="" width="565" height="180" data-attachment-key="XMQ6MHY3" src="attachments/XMQ6MHY3.png" ztype="zimage"> | 565](attachments/XMQ6MHY3.png)

通过上述运算可以得到下面内容：

![\<img alt="" width="448" height="184" data-attachment-key="FILRI9BP" src="attachments/FILRI9BP.png" ztype="zimage"> | 448](attachments/FILRI9BP.png)

每一行都分配给一个用户

假设我们获得前两行 $s+r$ 和 $s+2r$，目标是

$$w_1\lambda_1+w_2\lambda_2=s$$

代入：

$$w_1(s+r)+w_2(s+2r)=s$$

$$(w_1+w_2)s+(w_1+2w_2)r=s$$

得到方程组：

$$w_1+w_2=1,\qquad w_1+2w_2=0$$

解得：

$$w_1=2,\qquad w_2=-1$$

于是可以恢复 $s$

这里没有直接使用目标向量 $(1,0)$，但如果代入份额系数可以发现

$$2(1,1)-(1,2)=(1,0)$$

也就是

$$\begin{pmatrix}1&0\end{pmatrix}\begin{pmatrix}s\\r\end{pmatrix}=s$$

所以目标向量只是把“解方程”简化成矩阵运算；实际思想仍然是解方程

前面的工作使用的是访问树模型；我们可以用标准方法把任意单调布尔公式转化为 LSSS，也就是把访问树的 $\ell$ 个叶子节点转化为 LSSS 矩阵的 $\ell$ 行

到这里就理解了 LSSS 的思想

## 2.3 Ciphertext-Policy ABE

CP-ABE 由四个基本算法和一个可选的委托算法组成

### 1. Setup：生成公开参数和主密钥

> - **输入**：安全参数
> - **输出**：公开参数 $PK$、主密钥 $MK$

- 随机化算法

### 2. Enc：加密消息

> - **输入**：公开参数 $PK$、明文 $M$、访问结构 $A$
> - **输出**：密文 $CT$

- 加密者把访问结构 $A$ 嵌入密文；只有属性集合满足 $A$ 的用户才能解密

### 3. KeyGen：生成用户私钥

> - **输入**：主密钥 $MK$、用户属性集合 $S$
> - **输出**：解密私钥 $SK$

- 可信机构可以在任意时刻为用户属性集合 $S$ 生成私钥

### 4. Dec：解密

> - **输入**：公开参数 $PK$、密文 $CT$、私钥 $SK$
> - **输出**：明文 $M$ 或 $\bot$

- 如果 $SK$ 中的属性集合 $S$ 满足密文中的访问结构 $A$，则输出明文 $M$

### 安全模型

CP-ABE 的密文包含访问结构，私钥包含用户属性

安全要求：敌手可以选择要攻击的访问结构 $A^*$，但查询的私钥对应的属性集合不能满足 $A^*$

- **Setup**：挑战者运行 $Setup$，得到 $PK$ 和 $MK$，把 $PK$ 交给敌手
- **P1**：敌手可以多次查询不同属性集合对应的私钥 $SK$
- **Challenge**：敌手提交两个等长明文 $M_0,M_1$ 和挑战访问结构 $A^*$，要求之前查询过的属性集合都不满足 $A^*$；挑战者随机选择 $b$，用 $A^*$ 加密 $M_b$，把密文交给敌手
- **P2**：敌手继续查询私钥，但不能查询满足 $A^*$ 的属性集合
- **Guess**：敌手猜测 $b'$

我们还可以考虑选择性安全模型：敌手在全局最开始增加一个 **Init** 阶段，先提交要挑战的访问结构 $A^*$；后续会讨论基于 LSSS 的 CP-ABE 在这个模型下的安全性

## 2.4 Bilinear Maps

依旧和 CP-ABE 一样，使用双线性配对

主要使用的是非退化和双线性计算特点

## 2.5 Decisional Parallel Bilinear Diffie-Hellman Exponent Assumption

PBDHE 是本文提出的 DH 假设，是对 BDHE 的平行扩展

**回顾 BDHE**：

选择一个阶数为 $p$、生成元为 $g$ 的双线性群 $G$；随机选择 $a,s\in\mathbb{Z}_p$，给定敌手

$$g,\ g^s,\ g^a,\ g^{a^2},\ldots,g^{a^d},\ g^{a^{d+2}},\ldots,g^{a^{2d}}$$

敌手即使掌握这些信息，也无法区分

$$e(g,g)^{a^{d+1}s}$$

和随机群元素

**PBDHE** 增加了更多元素，主要是为了让 LSSS 的矩阵运算可以规约，因此更复杂

选择一个阶数为 $p$、生成元为 $g$ 的双线性群 $G$；随机选择

$$a,s,b_1,\ldots,b_q\in\mathbb{Z}_p$$

给定敌手：

$$g^a,\ g^{a^2},\ldots,g^{a^q},\ g^{a^{q+2}},\ldots,g^{a^{2q}}$$

$$\left\{g^{s b_j},\ g^{a/b_j},\ldots,g^{a^q/b_j},\ g^{a^{q+2}/b_j},\ldots,g^{a^{2q}/b_j}\right\}_{j=1,\ldots,q}$$

$$\left\{g^{a s b_k/b_j},\ldots,g^{a^q s b_k/b_j}\right\}_{j,k=1,\ldots,q}$$

敌手即使掌握这些信息，也无法区分

$$e(g,g)^{a^{q+1}s}$$

和随机群元素

如果 $\mathcal{B}$ 能解决 PBDHE，其优势为：

![\<img alt="" width="1262" height="147" data-attachment-key="HS6MCKRC" src="attachments/HS6MCKRC.png" ztype="zimage"> | 1262](attachments/HS6MCKRC.png)

# 3 Our Most Efficient Construction

这里说明两个构造及其正确性；安全性证明只讲规约思路，不深入参数构造

上面学习了 LSSS，现在尝试把 LSSS 引入 CP-ABE，并保证随机化使不同用户的 SK 无法共谋

## 1. Setup：生成公开参数和主密钥

> - **输入**：属性域 $U$
> - **输出**：公开参数 $PK$、主密钥 $MK$

- 选择阶数为 $p$、生成元为 $g$ 的双线性群 $G$
- 对每个属性 $x\in U$，随机选择 $h_x\in G$，把属性 $x$ 与 $h_x$ 绑定
- 随机选择 $\alpha,a\in\mathbb{Z}_p$
- 公开参数和主密钥为：

$$PK=\left\{g,\ e(g,g)^\alpha,\ g^a,\ \{h_x\}_{x\in U}\right\}$$

$$MK=g^\alpha$$

## 2. Enc：加密消息

> - **输入**：公开参数 $PK$、LSSS 访问结构 $(M,\rho)$、明文 $m$
> - **输出**：密文 $CT$

- 依据 LSSS 构造秘密共享，秘密为随机选择的 $s\in\mathbb{Z}_p$
- 设 $M$ 是 $\ell\times n$ 矩阵，选择随机向量 $v=(s,v_2,\ldots,v_n)$，计算份额 $\lambda_i=(Mv)_i$
- 对每行 $i$，随机选择 $r_i\in\mathbb{Z}_p$，生成密文：

![\<img alt="" width="1279" height="177" data-attachment-key="LXHJAWPB" src="attachments/LXHJAWPB.png" ztype="zimage"> | 1279](attachments/LXHJAWPB.png)

- 后续解密需要恢复出 $s$，才能对 $C$ 解密
- $C_i,D_i$ 用于恢复份额并消去 $h$ 项，保证拥有对应属性的用户才能恢复份额

## 3. KeyGen：生成用户私钥

> - **输入**：主密钥 $MK$、用户属性集合 $S$
> - **输出**：解密私钥 $SK$

- 随机选择 $t\in\mathbb{Z}_p$
- 基于公开参数生成：

![\<img alt="" width="768" height="89" data-attachment-key="BYHKPBN9" src="attachments/BYHKPBN9.png" ztype="zimage"> | 768](attachments/BYHKPBN9.png)

## 4. Dec：解密

> - **输入**：密文 $CT$、私钥 $SK$
> - **输出**：明文 $m$ 或 $\bot$

- 如果 $S$ 满足访问结构 $(M,\rho)$，利用线性重建系数 $\omega_i$ 计算：

![\<img alt="" width="1096" height="165" data-attachment-key="T79N9GEZ" src="attachments/T79N9GEZ.png" ztype="zimage"> | 1096](attachments/T79N9GEZ.png)

- 得到 $e(g,g)^{\alpha s}$ 后，从 $C$ 中恢复 $m$

## 3.1 Proof

这里不展开安全规约，只说明它基于 PBDHE 假设

因为使用了矩阵 $M$，描述较复杂，所以需要一个较强的假设；PBDHE 不够经典，后续工作尝试归约到 BDHE 和 BDH

# 4 Constructions from Weaker Assumptions

正如之前说的，为了更具有说服力，我们需要规约到 BDHE 和 BDH

可以规约到 BDHE，但需要约束“属性在访问公式中出现的最大次数”，记作 $k_{\max}$

还可以归约到 BDH，但需要在 $k_{\max}$ 的基础上，再约束 LSSS 矩阵的最大列数为 $n_{\max}$

# 5 Bilinear Diffie-Hellman Construction

这里修改之前的 CP-ABE，使其安全性可以归约到 BDH

因为 BDH 给模拟者的信息更少，所以很难把矩阵 $M$ 特殊设置到公开参数中

因此需要扩展密文和公开参数空间来克服这个困难

下面是修改版本的 CP-ABE

## 1. Setup：生成公开参数和主密钥

> - **输入**：属性域 $U$、LSSS 矩阵最大列数 $n_{\max}$
> - **输出**：公开参数 $PK$、主密钥 $MK$

- 生成双线性群 $G$，素数阶 $p$，生成元 $g$
- 对每个属性 $x\in U$ 和每个 $j=1,\ldots,n_{\max}$，随机选择 $h_{j,x}\in G$
- 随机选择 $\alpha,a\in\mathbb{Z}_p$
- 公开参数和主密钥为：

$$PK=\left(g,\ e(g,g)^\alpha,\ g^a,\ \{h_{j,x}\}_{j=1,\ldots,n_{\max},\ x\in U}\right)$$

$$MK=g^\alpha$$

## 2. Enc：加密消息

> - **输入**：公开参数 $PK$、LSSS 访问结构 $(M,\rho)$、明文 $m$
> - **输出**：密文 $CT$

- 和之前一样，使用 LSSS 构造随机化值 $s$
- 对每一行和每一列都构建密文组件：

![\<img alt="" width="1264" height="145" data-attachment-key="PZB3RCGH" src="attachments/PZB3RCGH.png" ztype="zimage"> | 1264](attachments/PZB3RCGH.png)

## 3. KeyGen：生成用户私钥

> - **输入**：主密钥 $MK$、用户属性集合 $S$
> - **输出**：解密私钥 $SK$

- 随机选择 $t_1,\ldots,t_{n_{\max}}\in\mathbb{Z}_p$
- 生成身份组件：

![\<img alt="" width="914" height="240" data-attachment-key="2E9CXFKR" src="attachments/2E9CXFKR.png" ztype="zimage"> | 914](attachments/2E9CXFKR.png)

（图中最后的 $L_n$ 应为 $L_{n_{\max}}$）

## 4. Dec：解密

> - **输入**：密文 $CT$、私钥 $SK$
> - **输出**：明文 $m$ 或 $\bot$

- 通过线性重建得到 $e(g,g)^{\alpha s}$，再从 $C$ 中恢复 $m$：

![\<img alt="" width="1106" height="763" data-attachment-key="8ALDESUR" src="attachments/8ALDESUR.png" ztype="zimage"> | 1106](attachments/8ALDESUR.png)

这里不需要太深入；本文的核心是：基于 LSSS 可以构建出标准假设下的安全性，而不是限制在通用群模型/群预言机中

到这里结束

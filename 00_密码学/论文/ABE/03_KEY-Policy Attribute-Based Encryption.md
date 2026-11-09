# KEY-Policy Attribute-Based Encryption

上面学习了 FIBE 这里进入KPABE

ABE就是FIBE 中第一次提出来的属性基加密

本论文主要讨论的是细粒度的ABE，什么是细粒度后续会说明

# ABSTRACT

这里说明了本文的内容

之前的ABE都是粗粒度的：要么自己解密大量数据，要么把私钥提交给第三方

本文做的是 <span style="color: rgb(255, 32, 32);">Key-Policy ABE</span>

基于密钥策略的属性加密

1.  密文由属性集合标注
2.  私钥与访问结构相关联，访问结构控制用户能够解密哪些密文

# 1. INTRODUCTION

对于我们个人用户的数据 一般都是存储在web企业的数据中的

我们的数据存储在这些web中，但是对于这些web的攻击，每天都在增加，所以我们会担心我们的信息安全问题

于是乎我们会思考 使用加密的方法存储我们的数据

但是这严重限制了用户在细粒度级别上有选择地共享加密数据的能力

> <span style="color: rgb(255, 32, 32);">细粒度访问控制</span>：可以根据用户具有的属性、满足的条件，精确决定谁能访问哪些数据

有一个审计人员 Bob希望查看日志，但是只看10月1日至10月7日且来源 IP 属于 `192.168.1.*` 子网的日志

但是我们不允许Bob查看所有日志，那么我们只有两个选择

1.  <span style="color: rgb(255, 32, 32);">我代替Bob查看</span>，每次都来找我，我解密后发给他
2.  直接把<span style="color: rgb(255, 32, 32);">解密私钥交给 Bob</span>

可以发现这两个都有问题——这里就引出了ABE解决的一个应用 日志审查

## 本文贡献

在本文中 每个密文都由一个属性集合标注

每个密钥都和一个访问结构相关

我们还可以使用逻辑表达式来作为门限

构建出一个 访问树结构，如果密文的属性集合满足私钥中嵌入的访问树，那么这个密文就可以解密

<span style="color: rgb(255, 32, 32);">先有访问树 $T$，再根据这棵树生成对应的私钥 $DK$</span>

我们最后还会说明应用：

1.  委托机构：一个拥有较大解密权限的用户，可以把自己的一部分解密权限授予别人，但不能通过委托扩大权限
2.  日志审查

# 2. RELATED WORK

这里说一下 与本篇文章相关的工作们

## Fine-grained Access Control

这里就是细粒度访问控制：保证不同访问权限的人员允许访问不同数据

一般情况下 都是通过部署访问控制服务去对内部人员进行约束，这个方法依赖于软件的检查，那么软件会存在漏洞问题，所以导致认证可能潜在问题

那么本篇介绍的细粒度就是\
1\. 数据是存储在一个服务上，并且是加密的\
2\. 用户只允许解密自己属性支持的加密内容

## Secret-Sharing Schemes

SSS 秘密共享 是 Shamir 提出来的并且说明了一个基于插值法的多项式门限内容

我们可以通过SSS找到一个树类型的访问权限结构

节点是各个门限，叶子是各个属性

在SSS中 必须要合作才可以恢复出masterKEY，所以必须允许合作

但是在我们的ABE中，即使用户串谋、合并各自的解密密钥，也无法解密任何他们单独都不满足的密文，更无法恢复MasterKey

## Identity-Based Encryption and Extensions

IBE也是Shamir提出的，但是在后续的才具有完整的方案，基于的是双线性配对

这里后面又提出了一个FIBE（Fuzzy IBE）这是增加了一个容错率的IBE，允许身份扩展为属性集合，并且属性集合交集大小不小于阈值 $d$ 的允许解密，他也是基于多项式插值法的门限方法复原的——可以用在生物信息解密技术上

但是在权限控制中，容错率不被允许

并且FIBE只支持了一个门限，也就是 $|w\cap w'|\ge d$，这里的 $d$ 是一开始就设置完毕了的

# 3. BACKGROUND

这里我们会开始说明 KPABE 也就是本文内容 下面会给出一些基础定义和技术内容

## 3.1 Definitions

### Access Structure

这里介绍一下 访问结构

存在一个属性集合 $S=\{P_1,P_2,P_3\}$ 这些是三个不同的属性

那么有一个集合 $E=2^S$ 是上述集合 $S$ 的幂集，访问结构 $A$ 是 $E$ 的一个非空子集

![\<img alt="" width="518" height="180" data-attachment-key="2AGACRL9" src="attachments/2AGACRL9.png" ztype="zimage"> | 518](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261105142520500.png)

$A\subseteq 2^S$

集合满足单调性：对于任意 $B,C$，如果 $B\in A$ 且 $B\subseteq C\subseteq S$，那么 $C\in A$

那么如果一个(单调性)访问结构是 $2^S$ 的一个非空子集，那么 $A$ 中的集合就叫做<span style="color: rgb(255, 32, 32);">认证集合</span>

不在 $A$ 中的集合叫做<span style="color: rgb(255, 32, 32);">未授权集合</span>

### Key-Policy Attribute Based Encryption

这里会介绍一个普通的ABE 他其实就可以看作是IBE的扩展 也包含4个部件构成

#### 1. Setup：生成公开参数和主密钥

> - **输入**：安全参数
> - **输出**：<span style="color: rgb(255, 32, 32);">公开参数 $PK$ 和主密钥 $MK$</span>

- 随机化算法。

#### 2. Enc：加密消息

> - **输入**：消息 $m$、<span style="color: rgb(255, 32, 32);">属性集合 $\gamma$（密文实际具有哪些属性）</span>、公开参数 $PK$
> - **输出**：密文 $E$

- 随机化算法。

#### 3. KeyGen：生成解密密钥

> - **输入**：<span style="color: rgb(255, 32, 32);">权限结构 $A$（私钥允许解密哪些属性组合）</span>、主密钥 $MK$
> - **输出**：解密密钥 $DK$

- 随机化算法。
- <span style="color: rgb(255, 32, 32);">$DK$ 包含允许解密哪种密文的权限</span>。

#### 4. Dec：解密

> - **输入**：密文 $E$、属性集合 $\gamma$、解密密钥 $DK$、公开参数 $PK$
> - **输出**：明文 $M$ 或 $\bot$

- 确定性算法。
- 若 $\gamma\in A$（即 $T(\gamma)=1$），输出明文 $M$。

那么这里就是基本的ABE架构了

1.  $KeyGen$ 产生的 $DK$ 是管理层决定给某个人解密哪些密文的能力
2.  $Enc$ 加密信息的时候会写入 $\gamma$，表示该密文具有哪些属性

### Selective-Set Model for ABE

ABE的安全讨论基于的是 Selective-set 模型 其实就是一个Game

- **Init**：敌手事先说明需要挑战的属性集合 $\gamma$。
- **Setup**：挑战者运行 $Setup$，得到公开参数交给敌手。
- **P1**：敌手可以提交多个访问结构的问询，要求 $\gamma\notin A$（即 $T(\gamma)=0$）。
- **Challenge**：敌手提交两个等长消息 $M_0,M_1$，挑战者随机选择 $b$，基于 $\gamma$ 加密 $M_b$ 返回。
- **P2**：敌手和 P1 一样继续问询。
- **Guess**：敌手猜测加密的到底是自己提交的哪个 $M$。

## 3.2 Bilinear Maps

双线性配对 这里又是老朋友了 不再说明了

## 3.3 The Decisional Bilinear Diffie-Hellman (BDH) Assumption

BDH困难问题 这里其实也是老朋友了 在FIBE中就说明过

也就是给定 $(g,g^a,g^b,g^c)$，区分 $Z=e(g,g)^{abc}$ 还是 $Z=e(g,g)^z$，其中 $a,b,c,z$ 都是随机数

# 4. CONSTRUCTION FOR ACCESS TREES

这里就进入本文核心了，本文是通过一个访问权限树来验证到底 $DK$ 能不能解密 $E$ 的

1.  每个密文都关联一个属性集合
2.  每个叶子都对应一个属性
3.  每个节点都是一个门限门

## 4.1 Access Trees

门限树是基于访问结构 $A$（所有授权集合组成的集合）构建出来的

如果我们授权的 $A$ 是下面：

![\<img alt="" width="588" height="103" data-attachment-key="3EUCJZLF" src="attachments/3EUCJZLF.png" ztype="zimage"> | 588](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261105142520501.png)

可以发现这里授权的是

1.  要有 $P_1$
2.  $P_2,P_3$ 只要有一个就可以

那么我们可以改写为逻辑表达式：

$T=P_1\land(P_2\lor P_3)$

构建出权限树【注意这里不一定一定要是二叉树】

![\<img alt="" width="1260" height="812" data-attachment-key="NSZYWF6P" src="attachments/NSZYWF6P.png" ztype="zimage"> | 1260](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261105142520502.png)

*   $num_x$ 描述的是点 $x$ 的孩子数量
*   $k_x$ 描述的是点 $x$ 的门限值，$1\le k_x\le num_x$
*   如果 $k_x=1$ 那么他就是OR门限
*   如果 $k_x=num_x$ 那么他就是AND门限
*   叶子节点的门限 $k_x=1$，主要是描述属性的
*   $parent(x)$ 函数是表示 $x$ 节点的父亲节点
*   $att(x)$ 描述的是如果 $x$ 是叶子节点，那么 $x$ 的属性是什么
*   $index(x)$ 描述的是 $x$ 节点的编号，我们会为所有节点设立单独的编号

### Satisfying an access tree

我们将会使用一个函数 <span style="color: rgb(12, 39, 74);">$T_x(\gamma)=1$</span> 用于描述的是 <span style="color: rgb(255, 32, 32);">一个节点是否满足密文属性</span>

他是一个递归算法：

1.  如果 $x$ 是非叶节点，就递归检查它的子节点

2.  如果 $x$ 是叶节点，执行 $att(x)$，获取该叶节点对应的属性

3.  判断 $att(x)\in$ <span style="color: rgb(12, 39, 74);">$\gamma$</span>：

    *   如果在，返回 1
    *   如果不在，返回 0

4.  父节点收集所有子节点的返回值，统计其中有多少个 1

5.  如果 1 的数量达到父节点的门限值 $k_x$，父节点返回 1，否则返回 0

6.  这个过程不断向上传递，直到根节点返回最终结果

也就是<span style="color: rgb(255, 32, 32);"> $T_x(\gamma)$ 是用于判断这个节点 $x$ 是否满足了密文属性 $\gamma$ 的</span>

## 4.2 Our Construction

这里进入了 真正的 KPABE了 大致构成和 基础ABE类似，但是具体实现不同

在开始之前我们设立符号

*   $G_1$ 是一个双线性群，阶数为 $p$，生成元是 $g$
*   $e:G_1\times G_1\to G_2$ 是双线性映射
*   $k$ 是安全参数，决定了群的大小
*   $\Delta_{i,S}$ 是拉格朗日系数，用于后续插值法

我们下面开始说明 KPABE的构成，并且说明他的正确性

### 1. Setup：生成公开参数和主密钥

> - **输入**：安全参数、属性域 $\{1,\ldots,n\}$
> - **输出**：公开参数 $PK$、主密钥 $MK$

- 每个属性用 $\{1,\ldots,n\}$ 中的一个唯一整数表示。
- 从 $\mathbb{Z}_p$ 随机选择 $n$ 个 $t_i$ 和 $y$。
- 公开参数和主密钥为：

$$PK=\{T_i=g^{t_i},\ Y=e(g,g)^y\}$$

$$MK=\{t_i,y\}$$

### 2. Enc：加密消息

> - **输入**：消息 $M$、密文属性集合 $\gamma$、公开参数 $PK$
> - **输出**：密文 $E$

- 随机选择 $s\in\mathbb{Z}_p$。
- 计算密文：

$$E=(\gamma,\ E'=M Y^s,\ \{E_i=T_i^s\}_{i\in\gamma})$$

### 3. KeyGen：生成解密密钥

> - **输入**：访问树 $T$、主密钥 $MK$
> - **输出**：解密密钥 $DK$

- <span style="color: rgb(255, 32, 32);">$T$ 规定了该用户能解密哪些密文。</span>

1.  对树 $T$ 中每个节点自顶向下构造多项式。
2.  每个节点的多项式次数为 $d_x=k_x-1$。
3.  规定特殊点 $0$ 的取值：
    - 根节点：$q_T(0)=y$——<span style="color: rgb(255, 32, 32);">从 $MK$ 中得到的 $y$</span>。
    - 其他节点：$q_x(0)=q_{parent(x)}(index(x))$。
4.  多项式确定后，为每个叶子节点构造<span style="color: rgb(255, 32, 32);">解密组件 $D_i$</span>：

$$D_x=g^{q_x(0)/t_i},\quad i=att(x)$$

其中 $t_i$ 从 $MK$ 得到。

5.  所有<span style="color: rgb(255, 32, 32);">解密组件 $D_i$ 组成解密密钥 $D$</span>。

总结：KeyGen 输入管理层设定的权限树 $T$，输出允许该用户解密的密钥 $DK$。

### 4. Dec：解密

> - **输入**：密文 $E$、解密密钥 $D$
> - **输出**：明文 $M$ 或 $\bot$

- 定义递归算法 $DecNode(E,D,x)$，输出 $G_2$ 上的元素或 $\bot$。

**叶子节点**：若 $x$ 是叶子且 $att(x)$ 在密文属性集合中，返回

![\<img alt="" width="889" height="205" data-attachment-key="WLNFJYEM" src="attachments/WLNFJYEM.png" ztype="zimage"> | 889](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261105142520503.png)

也就是说，叶子节点返回 $e(g,g)^{s q_x(0)}$，其中 $q_x(0)$ 是叶子自己的多项式；否则返回 $\bot$。

**非叶子节点**：对每个孩子 $z$ 递归调用 $DecNode(E,D,z)$，得到 $F_z$。

![\<img alt="" width="1521" height="681" data-attachment-key="GZDH9HQB" src="attachments/GZDH9HQB.png" ztype="zimage"> | 1521](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261105142520504.png)

例如 $x$ 是 2-of-3 门限，两个孩子成功、一个失败：

*   $\mathrm{DecNode}(E,D,z_1)=e(g,g)^{s q_{z_1}(0)}$
*   $\mathrm{DecNode}(E,D,z_2)=e(g,g)^{s q_{z_2}(0)}$
*   $\mathrm{DecNode}(E,D,z_3)=\bot$

因为 $q_z(0)=q_x(index(z))$，子节点提供了父节点多项式在不同位置的指数信息，所以通过拉格朗日插值可以恢复

$$F_x=e(g,g)^{s q_x(0)}$$

注意：这里没有恢复出 $q_x(0)$ 本身，只恢复了 $e(g,g)^{s q_x(0)}$。

**根节点**：一直递归到根，得到

$$F_r=e(g,g)^{sy}=Y^s$$

因为 $E'=M\cdot Y^s$，已知 $Y^s$ 即可恢复 $M$。

**总结**：$KeyGen$ 由管理层基于访问结构 $A$ 生成私钥；$Dec$ 从叶子开始执行 $DecNode$，逐层检查门限并恢复 $F_x$，最终得到 $Y^s$ 并解出 $M$。

## 4.3 Proof of Security

下面我们进入如何把BDH困难问题嵌入到敌手 $A$ 的攻击中

$B$：模拟器，用于攻击BDH困难问题，模拟并且回答敌手 $A$ 在Selective-set模型中的问询，$B$ 知道的内容：

*   $A=g^a$，$B=g^b$，$C=g^c$（注意：这里的 $A/B/C$ 是群元素，和敌手 $A$、模拟器 $B$ 重名）

$A$：敌手，专注攻击KPABE算法，运行在Selective-set模型中

那么我们下面进入 Selective-set模型 然后看看 $B$ 如何模拟和回应 $A$

**Init**：敌手 $A$ 宣布要挑战的属性集合 $\gamma$

**Setup（模拟）**：$B$ 开始运行 $Setup$ 算法 并且嵌入BDH困难问题

1.  $Y=e(g,g)^{ab}$

2.  $T_i$ 分为两个情况

    1.  如果 $i\in\gamma$，那么就随机选择 $r_i$，使得 $T_i=g^{r_i}$，此时 $t_i=r_i$
    2.  如果 $i\notin\gamma$，那么就随机选择一个 $\beta_i\in\mathbb{Z}_p$，设立 $T_i=g^{b\beta_i}=B^{\beta_i}$，此时 $t_i=b\beta_i$

那么这里 $PK=\{T_i,Y\}$；注意模拟器 $B$ 并不知道 $a,b$，因此它并不真正掌握 $MK=\{ab,t_i\}$，只是在模拟中隐式对应。其中 $t_i$ 也分为两个情况

**P1（密钥问询）**：敌手开始问询一些权限树 $T$，这些权限树不可以是 $\gamma$ 满足的，也就是 $T(\gamma)=0$

敌手 $A$ 在正常的Selective-set模型中的P1 问询的是得到这个树 $T$ 解密密钥 $DK$

那么 $B$ 需要在不知道 $a,b,c$ 的情况下返回解密密钥 $DK$，也就是成功设计出对于 $T$ 的所有多项式，他会设立两个算法 $PolySat$ 和 $PolyUnSat$

这里说明的是 P1 要求 $\gamma$ 不能满足整个树 $T$，但是对于节点的子树可以满足 $\gamma$，那么满足与否就会产生下面两个：

### 1. PolySat：节点 $x$ 满足 $\gamma$

> - **签名**：$PolySat(T_x,\gamma,\lambda_x)$
> - **输入**：子树 $T_x$、挑战属性 $\gamma$、整数 $\lambda_x$
> - **条件**：$T_x(\gamma)=1$

- **构造**：令 $q_x(0)=\lambda_x$，其余系数随机选取，从而确定 $q_x$。
- **递归**：对每个孩子 $x'$，根据它是否满足 $\gamma$ 调用 $PolySat$ 或 $PolyUnSat$。

---

### 2. PolyUnSat：节点 $x$ 不满足 $\gamma$

> - **签名**：$PolyUnSat(T_x,\gamma,g^{\lambda_x})$
> - **输入**：子树 $T_x$、挑战属性 $\gamma$、群元素 $g^{\lambda_x}\in G_1$
> - **条件**：$T_x(\gamma)=0$

- **定义**：令 $q_x(0)=\lambda_x$（模拟器只知道 $g^{\lambda_x}$）。
- **关键限制**：满足 $\gamma$ 的孩子数 $h_x\le d_x=k_x-1$，达不到门限 $k_x$。
- **满足的孩子**：对每个满足 $\gamma$ 的 $x'$，随机选 $\lambda_{x'}\in\mathbb{Z}_p$，令 $q_x(index(x'))=\lambda_{x'}$，并递归调用 $PolySat(T_{x'},\gamma,\lambda_{x'})$。
- **不满足的孩子**：递归调用 $PolyUnSat(T_{x'},\gamma,g^{q_x(index(x'))})$。
- **补点**：剩下的 $d_x-h_x$ 个点随机选取，从而唯一确定 $q_x$。

那么这里我们就对点 $x$ 构建出了多项式，即使他不满足挑战属性

那么基于上面两个算法，我们就可以构建出整个树的多项式了，那么下面就是如何生成对应 $T$ 的私钥了

1.  $B$ 运行 $PolyUnSat(T,\gamma,g^a)$，因为要求不满足 $\gamma$ 的每个节点都产生多项式

2.  对于根节点设立 $q_r(0)=a$

3.  对于 $T$ 中的叶子节点

    1.  该叶节点满足条件，$B$ 就完全知道多项式 $q_x$
    2.  该叶节点不满足条件，$B$ 就至少知道 $g^{q_x(0)}$

那么这里前置都OK了

最后设立多项式 $Q_x=bq_x$，那么 $Q_x(0)=bq_x(0)$；特别地，对根节点 $r$，$Q_r(0)=bq_r(0)=ab=y$。由此构建出：

![\<img alt="" width="726" height="149" data-attachment-key="7RQAV9JR" src="attachments/7RQAV9JR.png" ztype="zimage"> | 726](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261105142520506.png)

可以发现 这里已经把 $ab$ 嵌入了敌手攻击中了

**Challenge**：敌手 $A$ 会提交两个等长消息 $m_0,m_1$ 给 $B$，$B$ 随机选择 $\nu\in\{0,1\}$ 并加密 $m_\nu$ 返回密文

![\<img alt="" width="599" height="70" data-attachment-key="6XC6UJ7Y" src="attachments/6XC6UJ7Y.png" ztype="zimage"> | 599](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261105142520507.png)

如果 $\nu=0$，那么 $Z=e(g,g)^{abc}$；我们让 $s=c$，那么 $Y^s=e(g,g)^{abc}$

如果 $\nu=1$，那么 $Z=e(g,g)^z$

**P2**：和 P1 一样继续问询。

**Guess**：敌手 $A$ 开始猜测。

## Chosen-Ciphertext Security

我们可以使用 NIZK的技术扩展到选择密文安全上

# 5. LARGE UNIVERSE CONSTRUCTION

和FIBE一样，为了防止公开参数随着属性增加而增加，我们可以把方案扩展到全域上，并且固定属性的上限为 $n$，那么公开参数只会和上限线性相关，为了实现上述目标我们需要修改：

1.  增加一个抗碰撞哈希函数 $H:\{0,1\}^*\to\mathbb{Z}_p^*$
2.  我们可以使用随意长度的字符串作为属性

## 5.1 Description

这里将会开始说明这个方案和他的完善性

*   $G_1$ 是一个双线性群，生成元是 $g$，阶数是 $p$
*   $e:G_1\times G_1\to G_2$ 是双线性映射
*   $k$ 是安全参数，表示群的大小
*   $\Delta_{i,S}$ 是拉格朗日系数，$i\in\mathbb{Z}_p$，$S\subseteq\mathbb{Z}_p$
*   数据会在属性集合 $\gamma$ 下加密，其中 $|\gamma|\le n$

### 1. Setup(n)：生成公开参数和主密钥

> - **输入**：属性上限 $n$
> - **输出**：公开参数 $PK$、主密钥 $MK$

- 随机选择 $y$，令 $g_1=g^y$。
- 随机选择 $g_2\in G_1$。
- 独立均匀随机选择 $t_1,\ldots,t_{n+1}\in G_1$。
- 令 $N=\{1,\ldots,n+1\}$，定义函数

$$T(X)=g_2^{X^n}\prod_{i=1}^{n+1} t_i^{\Delta_{i,N}(X)}$$

这个函数也可以写成两个群元素的乘积：

$$\boxed{T(X)=g_2^{X^n}\cdot g_2^{h(X)}}$$

其中 $h$ 是 $n$ 次多项式。于是

$$PK=\{g_1,g_2,t_1,\ldots,t_{n+1}\}$$

$$MK=y$$

### 2. Enc：加密消息

> - **输入**：消息 $m\in G_2$、属性集合 $\gamma$、公开参数 $PK$
> - **输出**：密文 $E$

- 随机选择 $s\in\mathbb{Z}_p$。
- 计算密文：

$$E=(\gamma,\ E'=m e(g_1,g_2)^s,\ E''=g^s,\ \{E_i=T(i)^s\}_{i\in\gamma})$$

其中：

- $E'$ 是真实密文；
- $E''$ 用于传递 $s$；
- $E_i$ 是加密组件。

### 3. KeyGen：生成解密密钥

> - **输入**：访问树 $T$、主密钥 $MK$、公开参数 $PK$
> - **输出**：解密私钥 $DK$

- 为权限树 $T$ 的所有节点构造多项式。
- 对非叶子节点 $x$，多项式次数为 $k_x-1$。
- 自顶向下构造：
  - 根节点：$q_r(0)=y$；
  - 其他节点：$q_x(0)=q_{parent(x)}(index(x))$；
  - 其余点随机选择。
- 多项式确定后，为每个叶子节点构造解密组件：

$$D_x=g_2^{q_x(0)}\cdot T(i)^{r_x},\quad i=att(x)$$

$$R_x=g^{r_x}$$

其中 $r_x$ 随机选择。集合 $\{D_x,R_x\}$ 作为解密私钥 $DK$。

### 4. Dec：解密

> - **输入**：密文 $E$、解密私钥 $DK$
> - **输出**：明文 $m$

- 定义递归算法 $DecNode(E,D,x)$。
- 从下到上恢复 $e(g,g_2)^{s q_x(0)}$，最后得到 $e(g,g_2)^{sy}=e(g_1,g_2)^s$。

**叶子节点**：执行上述算法，得到

$$e(g,g_2)^{s q_x(0)}$$

![\<img alt="" width="863" height="264" data-attachment-key="RUM3WV4J" src="attachments/RUM3WV4J.png" ztype="zimage"> | 863](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261105142520508.png)

**非叶子节点**：

![\<img alt="" width="921" height="459" data-attachment-key="CUJYBKIW" src="attachments/CUJYBKIW.png" ztype="zimage"> | 921](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261105142520509.png)

通过插值法得到非叶子节点 $x$ 的

$$e(g,g_2)^{s q_x(0)}$$

因为密文 $E'=m e(g_1,g_2)^s$，且

$$e(g,g_2)^{ys}=e(g_1,g_2)^s$$

所以可以恢复出 $m$，正确性证明完毕。

那么到这里，全域中的 KPABE 就实现了；公开参数的大小与属性上限 $n$ 线性相关。

# 6. DELEGATION OF PRIVATE KEYS

这里开始讨论基于KPABE的私钥委托问题

这里委托的是解密密钥

对于访问权限树 $T$ 可以构建出一个解密私钥 $DK$

那么基于这个 $DK$ 我们可以构建出一个更加严格的权限访问树 $T'$，从而继续构建一个解锁要求严格的子私钥 $DK'$

这样就可以实现私钥委托

为了实现上述内容 我们需要对已经有的解密 $DK$ 进行一系列修改才可以构建

并且我们需要一步一步修改访问权限树 $T$ 到目标访问权限树 $T'$

为了下面的内容 提前说明 $(t,n)$-门 表示的是门限值 $t$，并且他的孩子数量是 $n$

下面是三个不同的操作

## 1) Adding a new trivial gate to T

> **目标**：在访问树中插入一个不影响解密结果的“平凡门”。

- 在已存在的节点 $x$ 之上增加一个节点 $y$，$y$ 是 $(1,1)$-门。
- $y$ 的孩子只有 $x$。
- $y$ 的父亲 $z$ 是 $x$ 以前的父亲。
- $y$ 的多项式是零次（常数）多项式：
  - $q_x(0)=q_y(index(x))$（固定常数）
  - $q_y(0)=q_z(index(y))$（常数）

经过这个修改，没有改变任何 $D_i$ 内容，所以输出的 $DK$ 依旧是原本该输出的。

## 2.1) Converting a (t, n)-gate to a (t+1, n)-gate

> **目标**：把门限从 $t$ 提高到 $t+1$，使访问权限更严格。

- $x$ 是一个 $(t,n)$ 门，$q_x$ 的次数为 $t-1$。
- 构造新多项式：

$$q'_x(X)=(X+1)q_x(X)$$

- 因为 $q'_x(0)=q_x(0)$，所以 $x$ 以外的部分不受影响。
- 对每个孩子 $y$，整棵子树统一乘以 $C_y=index(y)+1$：

$$q'_y(0)=(index(y)+1)q_y(0)$$

- 叶子解密组件相应变为：

$$D'_z=(D_z)^{C_y},\quad R'_z=(R_z)^{C_y}$$

## 2.2) Converting a (t, n)-gate to a (t+1, n+1)-gate

> **目标**：增加一个新子树，同时把门限和子节点数都加 1。

- 增加一个新的子树，作为目标节点 $x$ 的孩子；设其根为 $z$，$index(z)=v$。
- 这样会把 $x$ 的多项式次数加 1。
- 改写：

$$q'_x(X)=(aX+1)q_x(X),\quad a=-1/v$$

- 因为 $q'_x(v)=0$，所以 $q_z(0)=q'_x(index(z))=0$。
- 已知 $q_z(0)$ 后，按 $KeyGen$ 的方法构造 $z$ 的子树。
- 对原有孩子 $y$，用 $C_y=a\cdot index(y)+1$ 缩放整棵子树。

结果：

*   目标节点 $x$ 扩展为 $(t+1,n+1)$ 门；
*   新子树 $z$ 的多项式满足 $q_z(0)=0$；
*   其余原本子树通过 $C_y$ 缩放得到解密组件。

## 2.3) Converting a (t, n)-gate to a (t, n-1)-gate

> **目标**：删除一个孩子，使子节点数从 $n$ 减到 $n-1$。

- 删除孩子 $y$。
- 只需删除 $T_y$ 中所有叶子对应的解密组件。

## 3) Re-randomizing the obtained key

> **目标**：让新生成的 $DK$ 独立于原始 $DK$。

- 通过操作 1) 和 2) 得到目标访问树 $T'$。
- 对节点 $x$ 构造已知常数 $C_x$：
  1. 随机选择多项式 $p_x$，次数为 $d_x$，并保证 $p_x(0)=C_x$；
  2. 根节点令 $p_r(0)=0$；
  3. 定义新多项式 $q'_x(X)=q_x(X)+p_x(X)$；
  4. 用 $q'_x$ 作为节点 $x$ 的新多项式；
  5. 对所有孩子令 $C_y=p_x(index(y))$；
  6. 递归到叶子后构造新 $DK$。
- 叶子组件更新为：

$$D'_y=D_y\cdot g_2^{C_y}\cdot T(i)^{r'_y}$$

$$R'_y=R_y\cdot g^{r'_y}$$

其中 $i=att(y)$，$r'_y$ 随机选择。

到此整个过程就结束了，我们可以把新 $DK$ 分发给别人了。

# 7. AUDIT LOG APPLICATION

我们现在把KPABE 应用在 日志审查系统中

其实就是很简单 我们作为管理者 ，可以得到所有密文

我们可以选择提交日志用于检查，但是不可以把完整日志展示，所以我们对需要展示的进行KPABE加密

给日志密文标注其属性（例如日期、来源 IP 等）；再给法官生成访问树为（日期在 10/1–10/7 ∧ 来源 IP 属于 192.168.1.*）的私钥，只有属性满足该树的密文才可以解密

通过 $KeyGen$ 构建出解密 $DK$ 发送给法官

于是法官只可以解密属性满足该访问树的密文，而无法解密其他内容

方案本身具有抗共谋性：每个密钥都绑定了 $MK$ 的随机化份额，即使共谋也无法得到未授权信息

# 8. APPLICATION TO BROADCAST ENCRYPTION: TARGETED BROADCAST

这里是应用在广播中的， 提出了一个新的技术 有针对性的广播

比如有一个发行者 具有10季节目

在以前他需要广播给订阅者，必须全部广播，订阅者必须要签约全部节目

现在使用KPABE

订阅者可以订阅自己想看的季

广播依旧广播全部节目（可以使用对称加密加密广播节目），并使用 KP-ABE 加密对称密钥

于是乎只有订阅者得到的 $DK$ 才能解出节目密钥

从而可以观看

# 9. DISCUSSION AND EXTENSIONS

这里作者进行了讨论和延展

## Construction for any LSSS-realizable access structure.

不一定需要访问树结构 而是转向了 LSSS结构

也就是使用 线性代数表示访问规则的数学工具\
MSP 是表示访问控制规则的另一种方式，只不过它不是用 AND、OR 门构建访问树，而是用线性代数的矩阵和向量来表达访问条件

## Achieving CCA-Security and HIBE from Delegation

可以通过简单修改 达到 CCA 安全，并构造 HIBE

## Ciphertext-Policy Attribute-Based Encryption

本文是把密文与属性集合相关联，密钥和访问策略相关联

那么也就存在另一个：CPABE

用户密钥和属性集合相关联，密文和访问策略相关联

## Searching on Encrypted Data

在前面的日志审查中，密文标注的属性集合是公开的（没有隐藏）；访问策略在私钥中

# Identity-Based Encryption from the Weil Pairing

这里进入IBE，这里其实是一个具体实现

shmair在此之前已经提出过了 IBE思想了，但是那个时候并没有具体的方案，所以这里是第一次产生了具体并且安全的方案

# 1 Introduction

### 前景知识

shmair提出的是一个公钥算法，他的公钥可以是任意长度的字符串，这个方案包含4个子程序

1.  setup：用于初始化公共参数和masterKey
2.  Extract：用masterKey产生任意长度公钥的合法私钥，这里公钥记作ID
3.  Enc：使用ID和M获得密文C
4.  Dec：使用私钥和ID和C 获得明文

那么Shamir提出这个是为了 邮件系统：

1.  Alice 基于Bob 的域名作为公钥发送消息
2.  Bob 通过对PKG进行身份认证获得自己的私钥
3.  从而解密

那么他的优点：

1.  就是不需要从CA认证身份了
2.  Alice可以随时发送，即使Bob私钥没有生成
3.  密钥托管可以实现，PKG保存Bob的密钥

虽然也有很多类IBE的产生，但是都是约束很多的，虽然IBE还没有产生，但是IBS却构建出来了

### 本文

那么本文会构建出一个具有理想功能的IBE方案

我们基于的是 CDH假设，并且是在椭圆曲线上的

我们还可以使用门限密码 分发masterKey，让他不再保存在一个PKG中，使得PKG都不需要了

我们基于的是双线性weil配对这个算法

最后我们还会说明一个 ELGamal加密嵌入密钥托管

我们的安全性还会比标准选择密文安全更加强大，因为我们允许敌手选择ID并且获得私钥，然后选择需要攻击的ID

## 1.1 Applications for Identity-Based Encryption

这里我们会讨论 基于IBE构建的一些应用是什么

### 密钥撤销

这里是第一个例子：

我们可以让公钥包含一个过期时间，这样就可以进行密钥撤销了

Alice获得Bob的整数，其中包含过期时间

ALice 通过Bob的公钥加密，那么他的公钥包含信息：<bob@hotmail.com> ‖ current-year

那么这里说明 Bob只可以使用自己私钥在current-year 解密消息

那么这样Bob就要<span style="color: rgb(255, 32, 32);">每一年都去PKG请求一个私钥</span>

Alice不需要每次都保存一个证书

下面是第二个例子：

如果Bob是公司员工，PKG是公司架构，那么Bob每天都需要和PKG申请一个私钥

如果Bob离职，那么PKG就驳回私钥

但是<span style="color: rgb(255, 32, 32);">别人都还可以给Bob邮件发送信息，但是Bob无法查看</span>了

### 密钥托管

这里的密钥托管是<span style="color: rgb(255, 32, 32);">托管解密的能力</span>

下面 Bob 是作为PKG的视角，运行Setup，获得参数和masterKey

这里参数认为就是Bob的公钥了，和一个CA申请公钥的证书

Alice基于公钥和证书发送消息给Bob

### 1. Delegation to a laptop

Alice通过IBE的加密KEY发送邮件给Bob

Bob 有masterKey 所以它可以解密

如果Bob出去7天，他可以将masterKey生成的私钥放在手提电脑上

如果是普通的加密：如果手提电脑被偷了，私钥就泄露，

如果Bob使用IBEmasterKey构建出7个密钥，那么只有这些天的密钥泄露了，<span style="color: rgb(255, 32, 32);">MasterKey不受影响</span>

### 2. Delegation of duties

可以基于部门的身份来托管，Bob可以基于职责发送对应的私钥给员工，<span style="color: rgb(255, 32, 32);">他只可以解锁自己的内容</span>

# 2 Definitions

这里我们会说明一些介绍，主要是对于一些前置知识

### 双线性映射

这里先把后面一直要用到的工具说明一下

我们有两个阶都是素数 $q$ 的循环群，分别记作 $G_1$ 和 $G_2$

$G_1$ 用加法表示；$G_2$ 用乘法表示，所以 $aP$ 是点的标量乘法

我们需要一个映射：

$$
\hat e:G_1\times G_1\rightarrow G_2
$$

它最重要的性质就是双线性：

$$
\hat e(aP,bQ)=\hat e(P,Q)^{ab}
$$

那么这里可以理解成：<span style="color: rgb(255, 32, 32);">左边两个点上的系数，可以在配对之后一起进入指数</span>

后面发送方和接收方<span style="color: rgb(255, 32, 32);">虽然知道的秘密不一样</span>，但是可以通过这个性质算出同一个值，这就是整个方案能解密的关键

### WDH 假设

那么前面说基于 CDH，这里需要写得更加准确一点：本文实际使用的是 WDH 假设

给出：

$$
P,\ aP,\ bP,\ cP
$$

我们希望计算：

$$
\hat e(P,P)^{abc}
$$

WDH 假设就是说，这个计算问题对于有效率的敌手是困难的

这里不能直接说“CDH 困难，所以 WDH 一定困难”

论文说明的是<span style="color: rgb(255, 32, 32);"> WDH 困难会推出 <span class="math">$G_1$</span> 上 CDH 困难，反方向不能直接这样认为</span>

### IBE 的定义

这里还是前面的四个算法，但是把输入输出写清楚：

1.  Setup：输入安全参数，输出公开的 params 和秘密的 masterKey
2.  Extract：输入 params、masterKey 和 ID，输出这个 ID 对应的私钥  $d_{ID}$
3.  Encrypt：输入 params、ID 和明文  $M$ ，输出密文  $C$
4.  Decrypt：输入 params、ID、密文  $C$  和私钥  $d_{ID}$ ，输出明文

那么这里要满足正确性：给同一个 ID 生成私钥，再用这个私钥解密发给这个 ID 的合法密文，应该得到原来的消息

ID 是公开字符串，真正需要<span style="color: rgb(255, 32, 32);">保密的是 masterKey 和用户私钥</span>

发送方还需要拿到可信的系统公共参数，并不是只知道一个邮箱就可以脱离整个系统加密

### 选择密文安全 IND-ID-CCA

那么这里为什么不能直接沿用普通公钥加密的安全定义？

因为 IBE 中所有用户的私钥都由同一个 masterKey 生成，敌手可能已经拥有很多其他身份的私钥，我们仍然希望目标身份的消息是安全的

这里安全游戏分为几个步骤：

1.  挑战者运行 Setup，把 params 给敌手，自己保留 masterKey
2.  敌手可以申请一些 ID 的私钥，也可以提交 ID 和密文<span style="color: rgb(255, 32, 32);">要求解密后面的查询 </span>可以根据前面的回答决定
3.  敌手选择<span style="color: rgb(255, 32, 32);">挑战目标身份 <span class="math">$ID^*$</span></span>，以及两个明文  $M_0,M_1$ 。目标身份不能是之前已经申请过私钥的身份
4.  挑战者随机选择  $b\in\{0,1\}$ ，返回  $C^*=Encrypt(params,ID^*,M_b)$
5.  敌手继续查询，但是不能申请  $ID^*$  的私钥，也不能要求解密挑战对  $(ID^*,C^*)$
6.  最后敌手猜测  $b$

那么这里不是完全禁止查询目标身份的解密，而是不能直接拿目标身份的挑战密文去问答案

敌手的优势定义为：

$$
Adv=\left|\Pr[b'=b]-\frac12\right|
$$

如果所有多项式时间敌手的优势都可以忽略，那么方案满足 IND-ID-CCA

这里 ID 的选择也是自适应的：<span style="color: rgb(255, 32, 32);">敌手可以先观察参数、做查询，再决定攻击谁</span>

### 单向安全 ID-OWE

下面还有一个<span style="color: rgb(255, 32, 32);">比较弱的安全定义</span>，后面证明 BasicIdent 会用到

挑战者随机选择一个明文，给敌手它的密文，敌手要恢复完整明文

敌手仍然可以选择目标 ID，并且申请其他身份的私钥，但是这里<span style="color: rgb(255, 32, 32);">没有前面 CCA 游戏中的解密查询</span>

那么这里的区别是：ID-OWE 要求敌手不能恢复完整的随机明文；IND-ID-CCA 要求敌手即使有解密查询能力，也不能区分选定的两个明文

不能把“恢复不了完整明文”直接理解成“关于明文什么都不知道”

# 3 Properties of the Weil Pairing

这里作者开始说明，前面的双线性映射可以怎么具体实现

选取素数 $p,q$，满足：

$$
p=6q-1,\qquad p\equiv2\pmod3
$$

使用椭圆曲线，这里叫做<span style="color: rgb(255, 32, 32);">超奇异椭圆曲线</span>：

$$
E:y^2=x^3+1
$$

曲线在 $\mathbb F_p$ 上有 $p+1=6q$ 个。我们取其中阶为 $q$ 的子群 $G_q$，取生成元 $P$。

这里还有一个映射 $\varphi$ ，把点移到扩域上的另一个方向，因为这里超奇异椭圆曲线，所以这个映射会很容易找到

然后定义修改后的 Weil 配对：

$$
\hat e(P,Q)=e(P,\varphi(Q))
$$

所以后面算法中使用的 $\hat e$，要注意是修改后的配对

它有三个性质：

1.  双线性： $\hat e(aP,bQ)=\hat e(P,Q)^{ab}$
2.  非退化： $\hat e(P,P)$  的阶为  $q$ ，不会所有东西都映射成  $1$
3.  可计算：存在有效率的算法计算这个配对

那么这里只需要先抓住这三个性质，后面构造主要依靠它们

### DDH 容易，为什么还可以做加密

给出 $P,aP,bP,cP$，我们可以检查：

$$
\hat e(P,cP)\stackrel{?}{=}\hat e(aP,bP)
$$

等式成立就意味着 $c=ab\pmod q$。

所以这个群上的 DDH 是容易的，不能直接使用 DDH 困难假设

但是能判断一个点是不是 $abP$，不代表可以计算出 $abP$，更不代表可以计算出 $\hat e(P,P)^{abc}$。

那么配对一方面让 DDH 容易了，另一方面也给了我们构建 IBE 的工具安全性依靠的是前面的 WDH

# 4 Our Identity-Based Encryption Scheme

作者不是直接给出最终方案，而是<span style="color: rgb(255, 32, 32);">先给一个容易理解的 BasicIdent，再用变换获得 FullIdent</span>

### 4.1 MapToPoint

那么 输入的ID 是字符串，但配对的输入却是曲线点，所以首先要把 ID 转成一个点 $Q_{ID}$。

这里用哈希 $G:\{0,1\}^*\rightarrow\mathbb F_p$：

1.  计算  $y_0=G(ID)$ 。
2.  计算  $x_0=(y_0^2-1)^{1/3}\pmod p$ ，得到曲线点  $Q=(x_0,y_0)$ 。
3.  计算  $Q_{ID}=6Q$ ，把点映射到阶为  $q$  的子群。

这里极少数输入会得到无穷远点，论文为了简化描述把这些 ID 当作无效输入

需要特别注意：不要随意把这里改成“先算一个公开标量 $h(ID)$，再令 $Q_{ID}=h(ID)P$。

因为这样的话，任何人都可以用公开参数计算：

$$
d_{ID}=sQ_{ID}=h(ID)sP=h(ID)P_{pub}
$$

那么私钥就变成公开可计算的了这里需要的是把 ID 映射到点，同时不能公开它相对 $P$ 的离散对。这个反例是根据后面的私钥公式推出来。

### 4.2 BasicIdent

#### Setup

PKG 随机选择主密钥：

$$
s\in\mathbb Z_q^*
$$

再计算主公钥：

$$
P_{pub}=sP
$$

那么 $s$ 保密，$P$、$P_{pub}$、曲线参数和哈希函数等放入 params 公开

使用两个哈希： $G$ 用来把身份映射到点，$H$ 用来把配对结果转换成消息长度的比特

#### Extract

对于一个身份 ID：

$$
Q_{ID}=MapToPoint_G(ID)
$$

$$
d_{ID}=sQ_{ID}
$$

那么用户拿到的是一个基于身份的私钥/椭圆曲线上的点 $d_{ID}$，并不是主密钥 $s$

也就是说，PKG 用同一个masterKEY $s$，为不同身份的点生成不同的私钥 $d_{ID}$

#### Encrypt

Alice 要给 Bob 加密，先根据 Bob 的 ID 算出 $Q_{ID}$【通过MapToPoint】，再计算：

$$
g_{ID}=\hat e(Q_{ID},P_{pub})
$$

随机选择 $r$，输出：

$$
U=rP
$$

$$
V=M\oplus H(g_{ID}^{r})
$$

$$
C=\langle U,V\rangle
$$

那么 Alice 只需要公共参数和 Bob 的身份，不需要 Bob 的私钥，也不需要知道 $s$。

#### Decrypt

Bob 先检查 $U$ 是不是合法的阶为 $q$ 的点，再计算：

$$
M=V\oplus H(\hat e(d_{ID},U))
$$

这里为什么可以得到同一个掩码？

$$
\hat e(d_{ID},U)=\hat e(sQ_{ID},rP)=\hat e(Q_{ID},P)^{sr}=\hat e(Q_{ID},P_{pub})^r
$$

那么发送方使用 $P_{pub}$ 和自己选择的 $r$；接收方使用 $d_{ID}$ 和密文里的 $U$。两边通过双线性算到了同一个。

#### BasicIdent 的安全性和证明思路

这里论文只证明了它在随机预言机模型、WDH 假设下满足 ID-OWE，不能把它当作最终的 CCA 安全方案

证明引入了一个普通公钥加密方案 PubKeyEnc，把身份点固定放进公钥，然后分两步：

1.  如果能攻破 BasicIdent 的 ID-OWE，就可以攻破 PubKeyEnc 的 OWE
2.  如果能攻破 PubKeyEnc 的 OWE，就可以求解 WDH

那么整个证明思路就是：如果存在有效攻击，就能利用这个攻击解决我们假设困难的数学问题

这里是归约证明，不是通过枚举所有攻击说明安全论文会议版把两个引理的详细证明放在了完整版中

### 4.3 Identity-Based Encryption with Chosen Ciphertext Security

这里就是 FullIdent，使用 Fujisaki–Okamoto，也就是 FO 变换，把前面的基本方案转换成 CCA 安全的方案

Setup 和 Extract 基本不变，额外增加：

$$
H_1:\{0,1\}^n\times\{0,1\}^n\rightarrow\mathbb F_q
$$

$$
G_1:\{0,1\}^n\rightarrow\{0,1\}^n
$$

注意这里沿用本篇论文的符号：$G$ 是身份哈希，$H$ 是配对结果哈希，$H_1$ 生成随机数，$G_1$ 生成消息掩。

#### Encrypt

1.  先得到身份点  $Q_{ID}$ 。
2.  随机选择  $\sigma\in\{0,1\}^n$ 。
3.  令  $r=H_1(\sigma,M)$ 。
4.  计算三部分密文：

$$
U=rP
$$

$$
V=\sigma\oplus H(g_{ID}^{r})
$$

$$
W=M\oplus G_1(\sigma)
$$

$$
C=\langle U,V,W\rangle
$$

那么这里和 BasicIdent 的区别是：配对产生的掩码先保护随机串 $\sigma$，再用 $\sigma$ 保护真正的消息 $M$。

而且 $r$ 不是独立随机选择的了，它由 $\sigma$ 和 $M$ 一起决。

#### Decrypt

先检查 $U$ 是合法的阶为 $q$ 的点，然后：

1.  恢复  $\sigma=V\oplus H(\hat e(d_{ID},U))$ 。
2.  恢复  $M=W\oplus G_1(\sigma)$ 。
3.  重新计算  $r=H_1(\sigma,M)$ 。
4.  检查  $U\stackrel{?}{=}rP$ 。
5.  如果不相等就拒绝，检查通过才输出  $M$ 。

那么最后这个检查很关键：恢复出来的 $\sigma$、$M$，必须和密文中的 $U$ 对得。

这样修改密文的某个部分，就可能破坏各部分之间的对应关系这里可以把它理解成对密文内部关系的检查，但是完整的 CCA 安全性还需要 FO 变换和归约证明，不能只靠这句直观解释

#### FullIdent 的安全证明

证明的方向是：

攻破 FullIdent 的 IND-ID-CCA → 攻破普通公钥混合方案的 IND-CCA → 攻破 PubKeyEnc 的 OWE → 求解 WDH

第一步处理 IBE 中的身份和私钥提取查询；第二步使用 FO 定理；第三步接上前面 BasicIdent 证明中使用的引理

那么最后得到的是：在随机预言机模型和 WDH 假设下，FullIdent 满足 IND-ID-CCA

这里随机预言机模型是证明条件的一部分，不能省略成“只要 WDH 困难就无条件安全”

# 5 Extensions and Observations

### 配对和曲线可以替换

这里并不是只能使用这一条曲线和 Weil 配对，也可以考虑 Tate 配对等实现来提高效率

但是替换以后仍然需要满足双线性、可计算性、相应的 WDH 困难性，以及合适的身份到点的映射

### 分布式 PKG

那么前面说“使得 PKG 都不需要了”，这里要修正一下：不是没有 PKG，而是把 PKG 的职责分散给多个节点

把 $s$ 用 Shamir 秘密共享分成 $n$ 份 $s_i$，至少需要其中 $t$ 份合。

每个参与的节点返回：

$$
d_{ID}^{(i)}=s_iQ_{ID}
$$

用户通过拉格朗日系数 $\lambda_i$ 合并：

$$
d_{ID}=\sum_i\lambda_i d_{ID}^{(i)}=sQ_{ID}
$$

那么这里不需要先把 $s$ 恢复出来，再计算用户私钥，而是直接合并私钥份。

每个节点公开 $P_{pub}^{(i)}=s_iP$，用户可以检查：

$$
\hat e(d_{ID}^{(i)},P)\stackrel{?}{=}\hat e(Q_{ID},P_{pub}^{(i)})
$$

如果某个节点返回错误份额，就可以发现

前面 DDH 容易看起来像一个限制，但这里反而让我们可以直接验证份额，不需要另外使用零知识证明

分布式以后仍然存在信任要求：达到门限的节点合作，仍然可以生成用户私钥

### IBE 还可以导出签名

这里把 IBE 的 masterKey 当作签名私钥，把 params 当作验签公钥

要签名消息 $M$，就把 $M$ 当成身份：

$$
ID=M
$$

签名就是这个身份对应的 IBE 私钥 $d_M$。

验证者随机选择一个消息 $M'$，以 $ID=M$ 加密它，再用收到的签名尝试解。如果恢复出了 $M'$，就通过验。

那么这里验签是随机化的，而且签名者是掌握 masterKey 的一方，并不是说普通 IBE 用户直接用自己的身份私钥就可以签任意消息

# 6 Escrow ElGamal Encryption

这里作者另外给出一个有全局托管解密能力的 ElGamal 类方案

系统选择托管密钥 $s$，公开 $Q=sP$。

用户自己选择私钥 $x$，公开用户公钥 $P_{pub}=xP$。所以这里用户公钥不再直接是身份字符。

加密时选择 $r$，计算：

$$
U=rP,\qquad V=M\oplus H(\hat e(P_{pub},Q)^r)
$$

用户用自己的秘密计算 $\hat e(U,xQ)$；托管方用托管密钥计算 $\hat e(U,sP_{pub})$。

两者都等于 $\hat e(P,P)^{rxs}$，所以都可以获得相同掩码并解。

那么这里托管的是全局解密能力，托管方并不需要先知道每个用户自己选择的私钥 $x$。

本节说明的是在随机预言机模型、WDH 假设下的语义安全，不能直接把 FullIdent 的 CCA 安全结论套到这个方案上

# 7 Summary and Open Problems

那么本文主要完成了两件事情：给出带身份私钥提取查询的安全模型，并通过配对实现满足这个模型的 IBE

BasicIdent 帮助理解构造，FullIdent 才是这里满足 IND-ID-CCA 的最终方案

作者在本文结尾留下的问题包括：进一步理解 WDH 的困难性，以及构建不依赖随机预言机模型的 CCA 安全 IBE这里记的是作者在 2001 年提出的问题，不表示这些问题今天仍然全部未解决

### 回看前面笔记时需要注意的地方

1.  Shamir 提出了 IBE 的思想，这篇论文给出了基于配对的具体实现
2.  本文的准确安全假设是 WDH，不能直接等同于普通 CDH
3.  不需要逐个取得用户公钥证书，不代表不需要可信公共参数，也不代表 PKG 发私钥时不需要核验身份
4.  把日期放入 ID 实现的是按时间段停止发放后续私钥已经拿到的某一天的私钥，之后仍然可以解密发给那个完整 ID 的密文，不会自动失效这一点可以直接从解密算法不检查当前时间看出
5.  分布式 PKG 分散的是主密钥和发钥职责，并没有消除达到门限的节点所具有的托管能力

那么回头看整个构造，最需要记住的一条式子还是：

$$
\hat e(sQ_{ID},rP)=\hat e(Q_{ID},sP)^r
$$

它把 PKG 生成的身份私钥，和发送方只用公共信息产生的密文联系了起来

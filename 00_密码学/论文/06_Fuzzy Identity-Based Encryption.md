# Fuzzy Identity-Based Encryption

这里对 IBE 向前推进一步 提出了 Fuzzy IBE

1.  把单一用户的身份提升到了属性集合
2.  允许对于属性集合 w 的私钥可以解密另一个属性集合 w’的密文

当然 2 对这两个属性集合具有一些要求 后续会说明 我们把这个叫做<span style="color: rgb(255, 32, 32);">容错率</span>

我们还可以使用 FuzzyIBE 构建出 属性基加密

# 1 Introduction

现在开始介绍一下这个论文的内容

IBE 的提出，允许不需要公钥证书就可以进行加密信息

那么我们之前看到的 IBE 就是他的身份是一个随机长度字符串

那么这里的 FuzzyIBE 把身份看作的是一个<span style="color: rgb(255, 32, 32);">描述属性集合</span>

一个属性集合 w 的私钥 可以解密另一个属性集合 w’的密文，只要这两个属性包含一定距离的重叠

所以 FuzzyIBE 也可以看作是一个具有容错的身份认证

那么他的实际应用 有两个

1.  基于生物信息的 IBE 系统
2.  FuzzyIBE 构建出属性基加密

生物识别：我们知道 对于一个人的识别都不一定完全准确，那么 FuzzyIBE 提供了容错率，允许在大部分重合的情况下加密或者解密，这里我们注意 不能使用现有存在的 IBE

属性基加密：就是对于满足某个属性的人，允许其解密得到消息，这可以在公司中使用，只有你的身份包含某个属性，才允许解密这个文件，因为 FuzzyIBE 使用的是 属性集合作为身份，所以很自然的可以作为属性基加密的构建

下面我们具体说一下 生物识别

## 生物识别

基于生物信息的加密系统是很自然和强大的，那么我们这里描述的场景是有一个监管操作员，控制信任者进行生物识别——而不是通过上传生物读数

一般的身份认证，都需要用户提出合法身份和文件，审批通过后才可以，那么在文件上传等内容中 很容易出现问题

但是使用生物信息就不会出现这个问题，如果 监管操作员可以识别到 到底是不是真人，那么这里唯一安全问题只会出现在 生物信息识别技术本身了

那么现在我们需要对抗的是 敌手没有生物信息，但是欺骗认证者 他就是本人

其次生物信息的优点就是不需要多次申请公钥，因为他个人就是一个公钥

## 对抗共谋敌手

IBE 也存在这个问题 如何对抗共谋敌手？

也就是我们要求 没有一组用户可以和他们的私钥结合，从而破解未授权的信息

## 本文贡献

提出了 Fuzzy IBE，并且给出了具体实现，使用的是 高效双线性映射，并且基于的是 CDH 困难问题

我们将用户的<span style="color: rgb(255, 32, 32);">私钥构造成一个由多个私钥组件组成的集合</span>，其中用户身份中的每一个属性都对应一个私钥组件

也就是<span style="color: rgb(255, 32, 32);">每个属性生成一个私钥组件</span>，总共<span style="color: rgb(255, 32, 32);">合起来作为一个私钥</span>

我们将使用 Shamir 秘密共享方法，把主秘密拆分成多个份额，并将这些份额放在用户私钥各个组件的指数中

并且我们的容错率也是 Shamir 秘密共享提供的，因为他只需要 t 个就可以重构得到主密钥

方案还可以抵抗共谋攻击：不同用户是通过不同随机多项式产生的私钥组件，即使多个用户共谋，无法有效的结合他们的私钥组件，因为使用的是不同的多项式

<span style="color: rgb(255, 32, 32);">这样即使共谋 也无法解密他们原本无权解密的密文</span>

我们的方案可以抵抗 Selective-ID 攻击 不需要使用随机预言机

我们主要规约到类似 BDH 上 后续会介绍

## 1.1 Related Work

这里会介绍相关工作

1.  Shmair 提出 IBE 系统 但是没有构建出实际安全和实用的
2.  Boneh 和 Franklin 第一次构建出安全并且实用的 IBE 系统，基于双线性配对
3.  Canetti 构建出不需要随机预言机的 IBE 系统，他们使用的是较弱按群的 Selective-ID 模型

上述就是对于 IBE 的一些相关工作

下面说明对于生物识别的：

密码学对生物信息的主要内容就是如何从生物信息中推导出密钥

这个密钥可以作为对称加密或者单体加密

但是我们使用的是把生物信息当作公钥

属性基加密：

Yao 说明了可以基于 IBE 系统构建出 多等级身份并且可以抵抗共谋攻击

他们也说明了他们的技术还可以使用在 ABE 上

## 1.2 Organization

这里说的就是论文的一些构成

下面进入正式说明

# 2 Preliminaries

这里作者为我们提供了一些预备知识

以便我们看懂后续内容

## 2.1 Definitions

这部分我们会说明 Fuzzy IBE 基于的是 Selective-ID 模型，但是又有所不同，是修改后的

唯一区别就是敌手只被允许去访问和目标具有 d 重合的那些身份

### Fuzzy Selective-ID

这里说明下这个模型

Init：敌手事先说明需要攻击的身份 记作 a

Setup：挑战者运行 setup 程序，告诉敌手公开参数

P1：敌手允许提交对某个私钥 y 的问询，并且要求|y∩a|\< d

Challenge：敌手提交两个长度相同的明文，挑战者随机选择一个 b 加密其中一个明文，把密文交给敌手

P2：敌手收到密文依旧可以继续问询 和 P1 一样

Guess：敌手猜测 b’ 如果 b = b’ 获得胜利

那么敌手的优势概率为 Pr\[b′ = b] − 1/2

基于实验我们就可以定义出安全

### 安全定义

有一个方案是满足 Fuzzy Selective-ID 的，如果敌手基于上述 game 的优势概率是可忽略的

## Bilinear Maps

双线性映射 这里是基于群上的双线性而不是椭圆曲线上的

G1 G2 都是阶数为素数 p 的群，其中 g 是 G1 的生成元

我们可以说 G1 具有 双线性映射 ：

e : G1 × G1 → G2

这里需要满足两个条件

1.  e(g^a, g^b)= e(g, g)^ab
2.  e(g, g)!= 1

## Complexity Assumptions

这里说明本文的难题 主要是 BDH 和 MBDH

BDH：基于双线性的 DH 问题

1.  随机选择 a, b, c, z
2.  构建四元组（A = g^a, B = g^b, C = g^c, Z = e(g, g)^abc) 和(A = g^a, B = g^b, C = g^c, Z = e(g, g)^z)
3.  敌手以可忽略概率成功区分出到底是哪个

MBDH：

1.  随机选择 a, b, c, z
2.  构建四元组（A = g^a, B = g^b, C = g^c, Z = e(g, g)^ab/c) 和(A = g^a, B = g^b, C = g^c, Z = e(g, g)^z)
3.  敌手以可忽略概率成功区分出到底是哪个

区别就是区分的到底是 abc 还是 ab/c

# 3 Other Approaches

在说明本论文方案前，会先说明一下失败的方案，并且会讨论为什么失败

## 失败方案 1

这个方案主要是考虑 "修正" 生物特征测量误差的可行性，然后使用标准的 IBE 对修正输入下的消息进行加密

但是这个研究依赖于错误的假设：

1.  每次测量结果只是相对于某个固定的“真实值”产生了微小偏差
2.  所有可能的真实值都事先已知

但是实际情况不是这样的，我们只可以假设测量的偏差是不会超出一定范围的

那么也有人尝试做过 Fuzzy Sketch

会保存第一次生物特征采样的辅助信息，之后进行新的测量时，可以利用这份辅助信息，将新测量结果校正到与第一次采样相对应的值

## 失败方案 2

权威机构交给用户对应属性的不同密钥，也就是把属性作为身份，每一个属性给一个私钥

这种方案很容易被共谋攻击，他们可以结合他们的属性

那么我们到底需要多少个 KYE?

一个密钥机构会测量输入 w 使用一个方案

构建出标准 IBE 给每个 w’ 这里要求|w∩w’|> d

也就是需要重叠部分比较多 才会分发

但是这里会导致密钥膨胀过多

所以作者引出自己的方案了

# 4 Our Construction

## 大致思路

身份是一个集合，里面包含这个用户的属性，令 d 值表示最小集合重叠的容错度

*   一个用户的私钥会和一个 d-1 多项式 q(x)绑定
*   每个用户都具有自己的随机 d-1 多项式并且 q(0)均为 y
*   对于用户的属性，KEYGEN 会基于多项式 q(x)产生对应的私钥组件
*   当收到密文的时候，只需要匹配到 d 个密钥组件，即可恢复自己的多项式，从而得到解密能力

我们可以发现 每个用户只有得到了自己的多项式，才可以解密，这样就防止了共谋，因为你即使和别人一起谋划，也无法构建出对应的随机多项式来解密

## 4.1 Description

这里进入正式关于 Fuzzy IBE 的描述

*   w 是身份属性集合
*   w’是和 w 重合的集合 也就是|w∩w’|>= d
*   G1 是一个阶数为 p 的具有双线性的群
*   g 是 G1 的生成元
*   e：G1 x G1 -> G2
*   k 是安全参数，决定群的大小
*   ∆i, S 是拉格朗日系数，i 是随机选择的，S 是 Zp 中的一个集合

![\< img alt = "" width = "579" height = "140" data-attachment-key = "U4DCHQPM" src = "attachments/U4DCHQPM.png" ztype = "zimage" > | 579](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112311.png)

*   身份将被表示为某个全集 U 的子集
*   我们会把每个元素和 Zp 中唯一整数联系起来

那么下面进入正式的 FuzzyIBE 的构建了

### 完整方案

*   Setup(d)：

    1.  我们先需要定义出全集 U，因为要确定身份的范围，也就是从 Zp 中选择唯一的数 并且要 modp 大小为|U|
    2.  从 Zp 中随机选择 ti 和 y
    3.  公开参数：Ti = g^ti 和 Y = e(g, g)^y
    4.  masterKey：ti 和 y

*   KEY GENERATION：权威机构开始基于收到的 w 构建对应的私钥了

    1.  对于身份 w 随机选择一个多项式，要求 q(0)= y
    2.  私钥由组件组合而成，是私钥组件的集合
    3.  Di 为私钥组件 i 是 w 中的一个属性，计算为 Di = g^q(i)/ti

*   Encryption：为了说明 w 可以解密 w’密文，这里使用 w’作为公钥，加密消息 M in G2

    1.  随机选择一个随机值 s in Zp
    2.  E =(w’, E’= MY^s,{Ei = Ti^s}) 构建密文三元组发送
    3.  w’是公钥，E’是加密后的信息 {Ei = Ti^s} 是密文组件

*   Decryption：E 是使用 w’加密得到的，我们假设 |w∩w’|> d 那么我们就可以使用 w 的私钥解密 E 了

    1.  我们选择 w∩w’ 的 d 个元素组成集合 S
    2.  使用下面公式解密即可

![\< img alt = "" width = "931" height = "525" data-attachment-key = "4V954Y6S" src = "attachments/4V954Y6S.png" ztype = "zimage" > | 931](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112312.png)

### 说明解密正确性：

格式化后如下：

![\< img alt = "" width = "480" height = "159" data-attachment-key = "TSNWNHQN" src = "attachments/TSNWNHQN.png" ztype = "zimage" > | 480](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112313.png)

这里参数非常多我们说明下：

*   E‘：密文中的消息部分
*   Di：密钥组件
*   Ei：密文组件
*   S：d 个重叠的属性
*   ∆：拉格朗日系数

依据上面的定义 我们可以对 E’ Di 和 Ei 写开

*   E’= Me(g, g)^sy
*   Di = g^q(i)/ti
*   Ei = Ti^s = g^tis

带入公式

![\< img alt = "" width = "537" height = "179" data-attachment-key = "FHTQ79CL" src = "attachments/FHTQ79CL.png" ztype = "zimage" > | 537](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112314.png)

对于分母 使用双线性配对

*   e(g^q(i)/ti, g^tis)= e(g, g)^q(i)/ti\*tis = e(g, g)^q(i)s

![\< img alt = "" width = "473" height = "179" data-attachment-key = "GUTQYRTN" src = "attachments/GUTQYRTN.png" ztype = "zimage" > | 473](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112315.png)

对于分母使用拉格朗日插值法

![\< img alt = "" width = "459" height = "137" data-attachment-key = "RC6VTXR7" src = "attachments/RC6VTXR7.png" ztype = "zimage" > | 459](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112316.png)

因为底数相同，所以改写为幂相乘

![\< img alt = "" width = "418" height = "86" data-attachment-key = "MZFVPYNS" src = "attachments/MZFVPYNS.png" ztype = "zimage" > | 418](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112317.png)

*   q 为 d-1 阶多项式
*   S 中有 d 个元素

基于拉格朗日插值法满足

![\< img alt = "" width = "518" height = "151" data-attachment-key = "9855I3GN" src = "attachments/9855I3GN.png" ztype = "zimage" > | 518](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112318.png)

最后就改写为了

![\< img alt = "" width = "630" height = "152" data-attachment-key = "URUMJAVV" src = "attachments/URUMJAVV.png" ztype = "zimage" > | 630](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112319.png)

从而得到了 M

## 4.2 Efficiency and Key Sizes

这里分析一下效率和密钥大小

*   G1 中所需的幂运算次数，与该身份属性有关，线性关系
*   解密需要的花费和双线性计算有关
*   群元素也和身份属性有关

## 4.3 Flexible Error-Tolerance

在上面方案中 我们设立容忍值为 d

但是实际构建中 可能需要一个灵活的容忍值

比如 生物信息输入系统具有较低可信度，那么我们需要让我们的容忍值升高

比如在属性基加密中我们希望在访问文档所需的属性数量上具有灵活性

那么这里有两个很简单的方法灵活操作容忍值

1.  构建多个系统，满足不同容忍值的使用
2.  权威机构 保留一些属性，它将作为其身份的一部分发布给每个关键持有者，发送者可以修改默认值的数量提升权威机构的容忍值

到达很难的地方了 这里我们需要证明他的安全性

# 5 Proof of Security

我们先需要梳理好

我们需要证明的定理：

> 如果一个敌手可以攻破 Fuzzy IBE，那么存在一个模拟器可以构建一个游戏攻破 MBDH 游戏

那么思路就是

1.  构建模拟 B 去运行敌手 A
2.  A 会提交问询给 B B 模拟返回问询
3.  如果 A 基于 B 给的内容 成功攻破 那么 B 也可以解决 MBDH 困难问题

那么这里对模拟器提前说明一下

*   模拟器会设置两个群和之前是一样的
*   B 来投掷 选择展示的到底是 (g^a, g^b, g^c, e(g, g)^ab/c)还是(g^a, g^b, g^c, e(g, g)^z)

现在开始模拟器的准备

### 模拟器要做的事情

让攻击者 A 以为自己正在与一个正常的 Fuzzy IBE 系统交互，模拟真正的 Setup 算法生成公共参数的过程

B 拥有的只有 MBDH 中的元素

![\< img alt = "" width = "578" height = "96" data-attachment-key = "C6FSMDWP" src = "attachments/C6FSMDWP.png" ztype = "zimage" > | 578](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112320.png)

并且不知道具体的 abc 值

*   B 在运行 A 的时候会收到 A 要攻击的目标 记作 a

*   Setup：B 需要模拟公开参数，也就是我们之前 FuzzyIBE 设立好的公开参数需要交给 A

    *   设立 masterKey，把 a 当 masterKey，那么就可以构造出 Y，这个公开参数解决，下面解决解密组件 Ti
    *   如果 i 在身份属性集合 a 中 那么就直接计算 Ti = C^B = g^cB 这里 B 是随机选择的
    *   如果 i 不在身份属性集合 a 中 那么就直接随机选择即可 Ti = g^wi wi 是随机选择的

原本 Ti 就是基于随机选择的 ti 所以在和不在都会产生均匀的解密组件

1.  这里让敌手挑战的 a 中包含模拟器不知道的 c
2.  让不属于 a 的属性包含模拟器知道的 wi

然后这里就可以提交 Y 和 Ti 给敌手了

*   Phase1：

    *   敌手对具有重叠的属性集合请求对应的私钥
    *   这个时候模拟器需要模拟私钥产生并且返回给敌手

假设 敌手请求身份 γ 的私钥 我们后续会定义出 3 个集合

T：这个集合中是 即使 γ 又是 a 的属性

T’：这个集合是 把 T 扩展到 d-1 个元素

S：这个集合是把 T’中缺失的 0 补齐

那么现在构建出解密组件 Di = g^q(i)/ti，就可以构造出私钥了 因为私钥是组件的集合

*   如果 i 在 T 中 那么就基于标准 FuzzyIBE 生成 Di = g^si——完全是随机的，因为之前的 Ti 如果在 a 中，那么设立的是 cB，c 完全不知道，所以直接随机，并且合法构造出
*   如果 i 在 T’-T 中 也就是不在 γ 和 a 交集中，只在 γ 里面的属性，那么敌手之前知道了 Ti 里面的内容是 wi，所以构造 Di = g^λ/w

到这里我们就构建了 T’ 的所有组件

但是我们的私钥要求所有属性都有一个组件

所以现在还要 γ -T’个组件要生成，那么怎么生成呢？

就是基于插值法的多项式构建出来，我们现在知道一小部分的多项式的点，构成如下：

![\< img alt = "" width = "564" height = "170" data-attachment-key = "SFA5V4GR" src = "attachments/SFA5V4GR.png" ztype = "zimage" > | 564](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112321.png)

并且我们还知道 q(0)= a   这里模拟不知道 a 的具体值，但是我们有 d 个点了 可以构建出 d-1 阶数的多项式 q(x)了——a 不知道但是 g^a 知道

最后对于 i 随机从 γ -T’中选择

就可以得到完整的私钥了

我们再梳理一下：

1.  我们需要私钥是 γ 所有属性的私钥组件

2.  我们可以基于 T 和 T‘-T 构建出 d-1 个组件

    1.  里面 T 的组件是完全随机的
    2.  T’-T 的组件是增加了模拟知道的 wi

3.  我们基于 q(0)= a 和 d-1 个组件可以复原出 q(x)

4.  i 从 γ -T’ 随机选择恢复出剩下的组件

5.  所有组件组合一个集合当作私钥返回给问询的 A

*   Challenge：

    *   敌手 A 提交两个 M 给模拟
    *   模拟选择一个加密得到 E 并且交付 A

![\< img alt = "" width = "884" height = "126" data-attachment-key = "7V9AQLSE" src = "attachments/7V9AQLSE.png" ztype = "zimage" > | 884](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112322.png)

这里的 Z 基于 u 的选择 也就是到底给的是 e(g, g)^ab/c 还是 e(g, g)^z

如果 u = 0 交付 e(g, g)^ab/c

我们把 r’= b/c

*   e(g, g)^ab/c = e(g, g)^ar‘= Y^r’
*   Ei = B^b = g^bb = g^rcb = Ti^r’

这样就构造完毕密文了

如果 u = 1 交付 e(g, g)^z，那么都是随机的了

*   Phase 2：和 1 一样的操作
*   Guess：敌手 A 提交 v 验证

那么如果 A 可以破解出 FuzzyIBE

B 就可以得到计算 ab/c 和 z 的差距

现在推测破解 MBDH 的概率

u = 1 的情况下敌手其实没有办法获得任何消息所以概率为：

![\< img alt = "" width = "509" height = "63" data-attachment-key = "6YEXV7RP" src = "attachments/6YEXV7RP.png" ztype = "zimage" > | 509](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112323.png)

u = 0 就需要考虑了 敌手如果可以以 e 的优势，那么攻破的概率就是 1/2 + e

那么破解 MBDH 的概率就是

![\< img alt = "" width = "1537" height = "75" data-attachment-key = "5U7GGYG7" src = "attachments/5U7GGYG7.png" ztype = "zimage" > | 1537](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112324.png)

到此安全性证明完毕了 难度还是非常大的

# 6 Large Universe Construction

为了解决前面所提出来的 公开参数大小会随着属性的数量线性增加的问题，我们提出基于大域的结构

通过固定属性最大数量，可以保证每个属性字符串可以任意长度，并且公开参数只会和属性最大数量有关

我们修改得到下面：

*   一个抵抗共谋的哈希函数 H，把字符串映射到群上
*   任意长度的属性字符串

那么我们开始说明整个方案构成，这里我们不会继续探讨安全问题，因为和上面的思路一样，通过模拟，让敌手 A 攻破方案的同时，攻破困难问题

## 6.1 Description

setup：

*   随机选择 y，计算 g1 = g^y g2 随机选择
*   随机选择 n+1 个 t 从 G1 中，N 作为整数 1…n+1 的集合，现在设立一个函数用于输出公开参数
*   公钥是：g1, g2, t1…tn+1
*   私钥是 y
*   ![\< img alt = "" width = "592" height = "200" data-attachment-key = "A7T9Y6TX" src = "attachments/A7T9Y6TX.png" ztype = "zimage" > | 592](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112325.png)

Key Gen：

*   基于身份 w 产生其私钥
*   随机生成 d-1 多项式，q(0)= y
*   私钥是两个集合组成的{Di, di}
*   ![\< img alt = "" width = "485" height = "128" data-attachment-key = "IKC6WXNV" src = "attachments/IKC6WXNV.png" ztype = "zimage" > | 485](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112326.png)
*   Di 可以发现使用了上面的公开参数，和公开算法 Ti
*   ![\< img alt = "" width = "334" height = "102" data-attachment-key = "8AVT4D3R" src = "attachments/8AVT4D3R.png" ztype = "zimage" > | 334](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112327.png)
*   这里的 r 都是随机选的

Enc：

*   用户使用 w’的身份加密密文
*   s 是随机选择的字符串，那么密文如下：
*   ![\< img alt = "" width = "1197" height = "116" data-attachment-key = "4GEUNWHE" src = "attachments/4GEUNWHE.png" ztype = "zimage" > | 1197](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112328.png)

Dec：

*   如果 w 和 w’具有重叠部分大于等于 d，那么可以解密
*   ![\< img alt = "" width = "1297" height = "733" data-attachment-key = "5M4XQ9R2" src = "attachments/5M4XQ9R2.png" ztype = "zimage" > | 1297](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261102092112329.png)

那么到这里 FuzzyIBE 结束

主要是在 IBE 的基础上增加为属性集合还有允许重叠人员解密

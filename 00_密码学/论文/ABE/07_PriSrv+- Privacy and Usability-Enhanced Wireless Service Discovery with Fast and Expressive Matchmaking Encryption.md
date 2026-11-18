# PriSrv+: Privacy and Usability-Enhanced Wireless Service Discovery with Fast and Expressive Matchmaking Encryption

我们学习了 FABESA后 可以进入这个论文看看

这论文是可以使用到我们 FABESA的内容

这里讨论的密码原语是ME（match Enc）

我们来看看这个论文说了什么

# Abstract

SD（service discovery） 是现在互联网的基础程序了，所有内容都依赖着SD，比如蓝牙，WIFI等

本文是提出一个具有强大隐私保护和易用性增强的SD协议，基于的是24年的 PriSrv构建出PriSrv+

在表达方式，隐私保护和效率上都有很大的提升

那么PriSrv主要基于的密码原语是ME，并且是提升的FEME（Fast And Expressive ME）

*   这是一个 ME，允许容纳大属性域
*   允许属性是任意字符串

# I. INTRODUCTION

这里我们会从 SD开始介绍，并且说明他的问题，然后一些工作，最后进入 第二章Related Work

SD 包含了一些知名协议 Wifi，AirDrop，BLE 这些都是现代无线网络的内容

但是明显的缺乏了健壮的隐私保护，也就是会被追踪和识别

SSDP 和 UPnP，但是它们依旧使用明文，并且缺乏认证，从而会被 MitM 和 DoS 攻击

虽然存在一些 隐私保护的协议 比如 WTSB 和 PrivateDrop，但是依旧有明显短处，依旧会导致用户行踪被追踪

那么就在 24年的 NDSS上，出现了 PriSrv，目标是隐私和易用性在SD上的

他使用了双层架构确保了只有授权的客户端才能发现服务，保护了交互过程中的敏感信息

PriSrv提供了双向隐私控制，通过ACME（Anonymous Credential-Based Matchmaking Encryption）从而防止了 MITM攻击，追踪和信息收集

但是这个协议也是有缺点的

1.  他受限于ACME，这个原语暴露了公开属性在外层，具有潜在被追踪的可能
2.  使用了 二进制属性向量控制，从而约束了属性表达性，并且在大属性域中的计算消耗明显增加
3.  对于小域的设计需要重构一些新的属性

那么为了克服这些困难，本文设计了 FEME 去替换 ACME，也提供了 ME 的原语，但是不同于前面的 IBME，FEME 能够基于任何字符串的表达策略

FEME 介绍了一个双重随机化和绑定技术，防止密钥提取和篡改

FEME达到了双向的控制，使用了部分隐藏结构去让属性值隐藏匿名，使用了随机切分技术，提供了一个具有表达能力的ME

那么本文的贡献可以由下面组成，不会具体展开解释，等待我们看完整个论文，就知道了

*   Fast and Expressive Matchmaking Encryption (FEME)
*   Enhanced Protocol Scalability and Flexibility
*   Optimized Performance and Scalability
*   Interoperability with Existing Protocols
*   Versatile Implementation across Platforms
*   Formal Security and Privacy Guarantees

# II. RELATED WORK

这里就是介绍一些相关的内容 比如SD、ME

## A. Service Discovery Protocols

SD就是我们很经常的内容 Wifi AirDrop 和蓝牙

主要是在动态的网络中自动探测和定位设备

但是这些协议会暴露重要的隐私信息，对于某些不希望泄露信息的用户，这些协议都会影响

敌手可以直接依据暴露的设备名字，对你的身份进行测绘

大部分的协议都缺乏隐私保护，从而受到 MITM、欺诈和 DoS 攻击，那么出现的原因就是以明文方式出现，直接暴露了设备信息；即使有一些提供隐私监听认证的协议 CBN，依旧无法抵抗 MITM 攻击

有一些协议是具有安全性的 比如 AirDrop，PrivateDrop 和 WTSB 通过加密和认证增强了 SD隐私

但是在面对多方认证和匿名的情况下，依旧会暴露威胁

我们可以使用一个简单的例子说明：

一位用户 三个位置 公司 商城和家庭

三个地方使用蓝牙开启 SD，三个位置都出现了 UUID 设备 ID，对于具有目的性的敌手，就可以描绘出你一天的行踪，这就违背了我们的不可关联性，让不同时间不同地点的加密设备关联起来了

那么基于上述安全问题，24年的NDSS中提出了 PriSrv协议：一个隐私SD协议，允许服务提供者通过细粒度访问控制监听，增加了多方认证

但是PriSrv 成也 ACME 败也ACME，由于ACME，对于大的消息会产生很大的延迟

所以本文提出了 PriSrv+

## B. Matchmaking Encryption (ME)

ME作为一个新的密码原语，在19年首次提出，主要要求 发送者和接收者双方进行策略认证

加密者的身份或者属性 记作 σ ，并且定义了一个允许解密策略R

解密者的身份或者属性 记作 p ，并且定义了一个允许加密策略S

那么解密只可以在 σ 满足 S 和 p满足R的情况下进行

那么基于ME，后续提出了 IBME，可以基于平等身份的ME——发送方认证通过嵌入加密密钥来实现

那么这个时候的ME 都被约束在平等身份和1对1 的数据分享下

为了提供1对多的交互，提出了 PSME和CLME

扩展了 IBME到多用户设置——主要使用了身份广播加密

后续又介绍了 FBME 也就是Fuzzy，允许重叠值的解密，但是他的门限约束了表达性和导致高开销的解密

在24年 NDSS提出了 ACME

一个具有匿名凭证的ME方案

但是ACME遭受了 大密文和小域的约束

于是本文提出 FEME 用于解决ACME问题

# III. PRELIMINARY

这里介绍的是 FEME的基础知识 从这里可以了解所有方案构建的基本内容

## A. Notation and Bilinear Pairing

介绍符号和双线性配对

*   $[m,n]$ 表示整数集合 $\{m,m+1,\ldots,n\}$
*   $[n]$ 表示整数集合 $\{1,\ldots,n\}$
*   $\mathbb{Z}_p$ 表示素数 $p$ 下的集合 $\{0,\ldots,p-1\}$，乘法和加法都需要模 $p$
*   $\mathbb{Z}_p^*$ 表示 $\mathbb{Z}_p$ 去掉 0 的集合 $\{1,\ldots,p-1\}$
*   安全参数使用 $\lambda$
*   $v$ 表示列向量
*   $v_k$ 表示列向量的第 $k$ 个元素
*   $M$ 表示一个矩阵
*   $M_i$ 表示矩阵的第 $i$ 行，$M_{ij}$ 表示第 $i$ 行第 $j$ 列元素
*   $s\gets S$ 表示 $s$ 从 $S$ 中随机采样
*   $y\gets\mathsf{Algo}(x)$ 表示算法 $\mathsf{Algo}$ 输入 $x$，输出 $y$
*   算法被认为运行在 PPT 时间
*   基于第三类型配对的双线性群记作 $\mathsf{BG}(G_1,G_2,G_T,e,p)$
*   要求 $G_1,G_2$ 不存在高效的同构计算
*   $g_1\in G_1$，$g_2\in G_2$，配对表示 $e(g_1,g_2)\to G_T$
*   对于 $a,b\gets\mathbb{Z}_p^*$，存在 $e(g_1^a,g_2^b)=e(g_1,g_2)^{ab}$

## B. Access Structure

和之前的访问结构说明的是一样的

对于两个集合 S 和 T 如果 S 属于 T，那么S如果可以被认证，那么T也可以被认证

这样就确保了 任意用户只要他的属性满足，那么他被赋予额外属性的时候 依旧满足原本策略

## C. Linear Secret Sharing Scheme (LSSS)

LSSS 被叫做是线性的，如果它满足下面内容：

1.  每个用户的份额构建出 $\mathbb{Z}_p$ 的一个向量
2.  存在一个 Share-Gen 矩阵 $A$，具有 $m$ 行、$n$ 列
    1.  对于所有的行，存在一个函数 $p$，使得 $p(i),i\in[m]$ 得到一个属性【也就是说属性和一行绑定】
    2.  存在一个列向量 $v=(s,r_2,\ldots,r_n)$，其中 $s$ 是秘密，$r_i$ 是随机选择的
    3.  我们可以基于 $Av$ 计算出 $m$ 个份额，并和 $p(i)$ 绑定到对应属性上

LSSS 天生具有线性重构特性

对于授权集合，存在常数 $w_i$，使得

$$\sum_{i\in I}w_i A_i=(1,0,\ldots,0)$$

基于 $w_i$ 和用户份额集合 $\lambda$，可以恢复秘密：

$$\sum_{i\in I}w_i\lambda_i=s$$

### Boolean Formulas

布尔公式是一个对于访问扩展的常规方案，任意布尔公式可以基于转换，变为LSSS模式

## D. Partially Hidden Access Structure

我们会把属性 拆开为 属性名和属性值

我们需要匿名的是属性值

通过部分隐藏结构，我们可以让属性值匿名，只暴露出属性名

我们设立 $u$ 为属性，$n$ 为属性名，$v$ 是属性值

$$u_i=(n_i,v_i)$$

存在一个访问策略 $A=(M,\pi,T)$

其中 $M$ 是 LSSS 矩阵，$\pi$ 是联系 $M$ 行向量和属性的函数，$T$ 是访问策略需要比较的属性 $T_i=(n_{\pi(i)},v_{\pi(i)})$

经过部分隐藏策略后，会修改为：

$$u_i=n_i$$

$$T_i=n_{\pi(i)}$$

我们定义部分满足：

$$S_{\text{partial}}\models A_{\text{partial}}$$

也就是如果属性名匹配上了

定义全部满足：

$$S\models A$$

要求 $S_{\text{partial}}\models A_{\text{partial}}$ 且属性值全部匹配

# IV. FAST AND EXPRESSIVE MATCHMAKING ENCRYPTION (FEME)

那么这节就进入了 FEME了 他是作为 PriSrv+协议的核心内容

也是ME的一个新方向

## A. Technical Roadmap

这里开始介绍一下技术路线

在ME系统中，发送方和接收方都需要相互认证，并且需要匹配到属性，那么我们就可以基于ABE原语进行构建

![\<img alt="" width="896" height="219" data-attachment-key="KZD6FYTU" src="attachments/KZD6FYTU.png" ztype="zimage"> | 896](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261117162247729.png)

上图就是本方案构建路径

出发是 FABEO，但是他不存在密文匿名安全，所以我们使用了  部分隐藏结构让他达到了 Anon，并且他也有计算开销的缺点，所以我们改进了

然后使用 Randomness Splitting 防止 FABEO 的 KP-ABE 方案中如果重复使用同一个随机数 $s$，导致的 Attribute Guessing Attack（属性猜测攻击）

最后通过解决 ME 和 ABE 之前的差距——发送方认证，从而构建出3个ABE方案，通过三个方案最后构建出  FEME

![\<img alt="" width="856" height="361" data-attachment-key="X8AA8XN3" src="attachments/X8AA8XN3.png" ztype="zimage"> | 856](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261117162247730.png)

## B. Novelty of FEME

从现有ABE出发

### Distinct from Existing ABE-Based Solutions

FEME需要达到的内容是双边访问扩展，双边部分匿名还有发送认证

即使是现有最优的 FABEO FEASE FABESA 都缺乏了这些功能，即使他们在ABE上的效率、表达和为可搜索加密提供单边匿名都达到了很好的程度

### Technical Challenges and Innovations

为了基于ABE设计出ME 我们需要解决的问题就是 Sender  Auth

如果没有这个功能，敌手可以直接基于虚假属性伪造密文，尝试模仿和欺诈

虽然 FEASE 和 FABESA 也在 FABEO 上使用了部分隐藏结构和随机切分技术，但是在双边情况下依旧无法保证安全

为了克服 ABE 无法解决的问题，FEME 提出了<span style="color: rgb(255, 32, 32);"> 双重随机化和绑定技术</span>

在兼顾效率的同时确保了发送者认证

第一个随机化是基于共享参数随机化了加密密钥组件，防止敌手基于配对直接恢复发送方的加密密钥

第二个随机化是额外增加给了密文组件，强制绑定了密文和其他密文元素，确保不会构建出伪造消息，并且还删除了 属性值，保证了 匿名性

那么到这里都只是大概说明下，下面需要进入真正的架构了

## C. Technical Details

我们会划分3个步骤进行操作

### Stage 1

我们基于 FABEO 构建出 Anon 版本的 KP-ABE 和 CP-ABE

那么我们会使用到之前一直提到的两个技术：部分隐藏结构和随机切分技术；通过这两个技术就可以实现 Anon，下面具体解释一个 ABE，另一个其实也是一样构建

### A-KP-ABE：Anon KP-ABE

#### 1. Setup

> - **输入**：安全参数
> - **输出**：$PK$、$MK$

- 运行 $\mathsf{GenGroup}$ 产生 $\mathsf{par}=(p,G_1,G_2,G_T,e,g_1,g_2)$
- 随机选择 $a,b_1,b_2\in\mathbb{Z}_p^*$
- 设立哈希函数 $H:\{0,1\}^*\to G_1$
- $PK=(\mathsf{par},H,e(g_1,g_2)^a,g_2^{b_1},g_2^{b_2})$
- $MK=(a,b_1,b_2)$

#### 2. KeyGen

> - **输入**：$PK$、访问结构 $A$
> - **输出**：解密组件 $SK_A$

- 从 $A$ 中提取可解密属性：$\Psi(\pi(i))=\{(n_{\pi(i)},v_{\pi(i)})\}_{i\in[m]}$
- 随机选择 $r',y$
- $sk_1=g_2^{r'}$
- $sk_{2,i}=(g_1^{A_i(a\|y)^T}H(\Psi(\pi(i)))^{r'})^{1/b_1}$（使用完整属性参与计算）
- $sk_{3,i}=(g_1^{A_i(a\|y)^T}H(\Psi(\pi(i)))^{r'})^{1/b_2}$（使用完整属性参与计算）
- 输出 $SK_A=((A,\pi,\{n_{\pi(i)}\}),sk_1,\{sk_{2,i},sk_{3,i}\})$（只公开属性名，不公开属性值）
- 上述已经使用了部分隐藏结构

#### 3. Enc

> - **输入**：用户选择的属性
> - **输出**：密文 $CT$

- 随机选择 $s',s''\in\mathbb{Z}_p^*$，令 $s=s'+s''$（随机切分技术）
- $ct_0=e(g_1,g_2)^{as}m$
- $ct_{1,i}=H(u_i)^s$（使用完整属性参与计算）
- $ct_2=g_2^{b_1s'}$
- $ct_3=g_2^{b_2s''}$
- 输出 $CT=(\{n_i\},ct_0,\{ct_{1,i}\},ct_2,ct_3)$（只公开属性名，不公开属性值）
- 上述已经使用了部分隐藏结构

#### 4. Dec

> - **输入**：$SK$、$CT$
> - **输出**：明文或 $\bot$

- 如果任何子集 $I$ 可以匹配 $A$ 的策略，允许解密
- 计算常数 $w_i$，使得 LSSS 成功恢复出 $s$：

![\<img alt="" width="943" height="109" data-attachment-key="9TF637T2" src="attachments/9TF637T2.png" ztype="zimage"> | 943](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261117162247731.png)

那么到这里，我们使用两个技术让 FABEO 转化到了 Anon ABE，同理上述过程也可以使用在 CP-ABE

![\<img alt="" width="1215" height="1008" data-attachment-key="XE8WPEV6" src="attachments/XE8WPEV6.png" ztype="zimage"> | 1215](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261117162247732.png)

可以发现只是 $S$ 和 $A$ 出现的地方变为了 KeyGen 和 Enc，其他没有什么很大的改变

对于上面和原始 FABEO 的比较可以发现

我们又对其增加了内容【上面的方案已经是修改过了的】

1.  使用 $h\gets G_1$ 代替了 FABEO 中的固定项目 $H(|U|+1)$，可以保证属性域的扩大
2.  使用 $s'$ 修改了 CP-ABE，让它的解密速度增加

### Stage 2

这里我们需要说明下 混合ABE——Hybrid BE

这种 ABE 桥接了 CP-ABE 和 KP-ABE，并且解决了和 ME 的问题；我们先进入具体算法看看

#### 1. Setup

> - **输入**：安全参数
> - **输出**：$MK$、$PK$

- $\mathsf{GenGroup}$ 产生 $\mathsf{par}=(p,G_1,G_2,G_T,e,g_1,g_2)$
- 随机选择 $x,u,b_1,b_2\in\mathbb{Z}_p^*$
- 随机选择 $h\in G_1$
- 构建哈希函数 $H:\{0,1\}^*\to G_1$
- $Y=e(g_1,g_2)^{xu}$，$\delta_0=g_2^u$，$\delta_1=g_2^{b_1}$，$\delta_2=g_2^{b_2}$
- $PK=(\mathsf{par},H,Y,h,\delta_0,\delta_1,\delta_2)$
- $MK=(x,u,b_1,b_2)$

#### 2. KEGen

> - **输入**：$MK$、发送者属性 $S_{send}$
> - **输出**：发送者加密密钥 $EK_{s_{send}}$

- 随机选择 $t\in\mathbb{Z}_p^*$
- $ek_1=g_1^x h^t$
- $ek_{2,i}=H(u_i)^t$
- $ek_3=\delta_1^t$
- $ek_{4,i}=\delta_2^t$
- 输出 $EK_{s_{send}}=(\{n_i\},ek_1,ek_{2,i},ek_3,ek_4)$

#### 3. PolGen

> - **输入**：接收方访问结构 $A$、$MK$
> - **输出**：基于 $A$ 的解密密钥 $SK_{rcv}$

- 随机选择 $r'\in\mathbb{Z}_p^*$ 和 $y\in\mathbb{Z}_p^{n-1}$
- $sk_1=g_2^{r'}$
- $sk_{2,i}=(h^{M_i(s_1\|y)^T}H(\Psi(\pi(i)))^{r'})^{1/b_1}$
- $sk_{3,i}=(h^{M_i(s_1\|y)^T}H(\Psi(\pi(i)))^{r'})^{1/b_2}$
- 输出 $SK_{rcv}=((A,\pi,\{n_{\pi(i)}\}),sk_1,\{sk_{2,i},sk_{3,i}\})$

#### 4. Enc

> - **输入**：$EK_{s_{send}}$、明文 $m$
> - **输出**：密文 $CT_{send}$

- 随机选择 $t',s',s''\in\mathbb{Z}_p^*$，其中 $s=s'+s''$
- $CT_0=Y^s m$
- $CT_{1,i}=(ek_{1,i}H(u_i)^{t'})^s$
- $CT_2=(ek_2\delta_1^{t'})^{s'}$
- $CT_3=(ek_2\delta_2^{t'})^{s''}$
- $CT_4=(ek_4 h^{t'})^s$
- 输出 $CT_{send}=(CT_0,CT_{1,i},CT_2,CT_3,CT_4)$

#### 5. Dec

> - **输入**：密文 $CT_{send}$、解密密钥 $SK_{rcv}$
> - **输出**：明文或 $\bot$

- 如果子集 $I$ 匹配到 $A$ 中内容，允许解密
- 基于 LSSS 计算出 $x$ 等主密钥参数，开始恢复：

![\<img alt="" width="791" height="100" data-attachment-key="3ZEG29Z3" src="attachments/3ZEG29Z3.png" ztype="zimage"> | 791](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261117162247733.png)

基于Hybrid ABE 我们成功构建出了 Send 认证的方案，在EKGen中，我们接受了send 的属性，并且产生了对应的加密密钥

PolGen中，接受了接收方的解密属性，产生了解密密钥

## Stage 3

到这里我们就进入今天的主角ME了 这里开始介绍 FEME的架构

#### 1. Setup

> - **输入**：安全参数
> - **输出**：$MK$、$PK$

- 运行 $\mathsf{GenGroup}$ 产生 $\mathsf{par}=(p,G_1,G_2,G_T,e,g_1,g_2)$
- 随机选择 $a,x,u,b_1,b_2\in\mathbb{Z}_p^*$
- 随机选择 $h\in G_1$
- 构建哈希函数 $H:\{0,1\}^*\to G_1$
- 构建函数 $\hat H:G_T\to\{0,1\}^{\ell_0}$
- 设立多项式时间可计算填充函数 $\phi:\{0,1\}^n\to\{0,1\}^{\ell_0}$
- $Z=e(g_1,g_2)^a$，$Y=e(g_1,g_2)^{xu}$，$\delta_0=g_2^u$，$\delta_1=g_2^{b_1}$，$\delta_2=g_2^{b_2}$
- $PK=(\mathsf{par},H,\hat H,Z,Y,h,\delta_0,\delta_1,\delta_2)$
- $MK=(a,x,u,b_1,b_2)$

#### 2. EKGen

> - **输入**：发送方身份 $S_{sen}$、$MK$
> - **输出**：发送方加密密钥 $EK_{send}$

- 随机选择 $t\in\mathbb{Z}_p^*$
- $ek_{1,i}=H(u_i)^t$
- $ek_2=\delta_1^t$
- $ek_3=\delta_2^t$
- $ek_4=g_1^x h^t$
- 输出 $EK_{send}=(\{n_i\},\{ek_{1,i}\},ek_2,ek_3,ek_4)$

#### 3. DKGen

> - **输入**：解密者身份 $S_{rcv}$、$MK$
> - **输出**：解密密钥 $DK_{rcv}$

- 随机选择 $r\in\mathbb{Z}_p^*$
- $dk_1=g_1^a h^r$
- $dk_{2,i}=H(u_i)^r$
- $dk_3=g_2^r$
- 输出 $DK_{rcv}=(\{n_i\},dk_1,\{dk_{2,i}\},dk_3)$

#### 4. PolGen

> - **输入**：解密者访问策略 $A_{rcv}$、$MK$
> - **输出**：基于访问策略的解密密钥 $SK_{rcv}$

- 随机选择 $r'\in\mathbb{Z}_p^*$
- 随机选择向量 $y\in\mathbb{Z}_p^{n-1}$
- $sk_1=g_2^{r'}$
- $sk_{2,i}=(g_1^{A_i(a\|y)^T}H(\Psi(\pi(i)))^{r'})^{1/b_1}$
- $sk_{3,i}=(g_1^{A_i(a\|y)^T}H(\Psi(\pi(i)))^{r'})^{1/b_2}$
- $sk_{4,i}=(g_1^{A_i(u\|y)^T}H(\Psi(\pi(i)))^{r'})^{1/b_1}$
- $sk_{5,i}=(g_1^{A_i(u\|y)^T}H(\Psi(\pi(i)))^{r'})^{1/b_2}$
- 输出 $SK_{rcv}=((A,\pi,\{n_i\}),sk_1,\{sk_{2,i},sk_{3,i},sk_{4,i},sk_{5,i}\})$

#### 5. Enc

> - **输入**：$EK_{send}$、$A_{send}$、明文
> - **输出**：密文 $CT_{send}$

- 随机选择 $s_1,s_2',s_2'',s_3',s_3''\in\mathbb{Z}_p^*$
- 随机选择向量 $v\in\mathbb{Z}_p^{n-1}$
- 要求 $s_2=s_2'+s_2''$，$s_3=s_3'+s_3''$
- $V=Z^{s_1+s_2}Y^{s_3}$
- $ct_0=\phi(m)\oplus\hat H(V)$
- $ct_1=g_2^{s_1}$
- $ct_2=g_2^{s_3}$
- $ct_{3,i}=h^{M_i(s_1\|v)^T}H(\Psi(\pi(i)))^{s_3}$
- $ct_{4,1}=\delta_1^{s_2'}$
- $ct_{4,2}=\delta_2^{s_2''}$
- $ct_{5,i}=H(u_i)^{s_2}$
- $ct_{6,i}=(ek_{1,i}H(u_i)^{t'})^{s_3}$
- $ct_7=(ek_2\delta_1^{t'})^{s_3'}$
- $ct_8=(ek_3\delta_2^{t'})^{s_3''}$
- $ct_9=(ek_4 h^{t'})^{s_3}$
- 输出 $CT_{send}=((M,\pi,\{n_i\}),ct_0,ct_1,ct_2,\{ct_{3,i}\},ct_{4,1},ct_{4,2},\{ct_{5,i},ct_{6,i}\},ct_7,ct_8,ct_9)$

#### 6. Dec

> - **输入**：$DK_{rcv}$、$SK_{rcv}$、$CT_{send}$
> - **输出**：明文或 $\bot$

- 如果 $S_{rcv}\models A_{send}$，表明解密者身份通过了加密要求，开始解密
- 计算常数 $\gamma_i$，使得 $\sum_{i\in I}\gamma_i M_i=(1,0,\ldots,0)$
- 再次验证：如果 $S_{send}\models A_{rcv}$，表示发送方身份通过了接收方要求
- 计算常数 $w_i$，使得 $\sum_{i\in I}w_i A_i=(1,0,\ldots,0)$
- 恢复 $V$：

![\<img alt="" width="1446" height="235" data-attachment-key="4X3T9QFM" src="attachments/4X3T9QFM.png" ztype="zimage"> | 1446](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261117162247734.png)

- 得到 $V$ 后恢复 $m$：$\phi(m)=ct_0\oplus\hat H(V)$

由于算法过多，我们这里重新梳理一下通信过程，这样就更好的理解每个算法具体是在干嘛了

### 通信例子

假设 A 和 B 进行通信

A 具有自己的属性 $S_A$，并且要求接收方属性满足自己的策略 $A_A$

B 也有自己的属性 $S_B$，并且要求接收方属性满足自己的策略 $A_B$

KGC 初始化时执行 $\mathsf{Setup}$ 产生 $PK$ 和 $MK$

当 A、B 加入通信的时候，A、B 会进行注册

KGC 使用 $PK$ 和 $MK$ 给 A 和 B 产生三个密钥

*   $\mathsf{EKGen}$：$EK_{A,B}$ 属性加密密钥，根据用户的属性集合生成加密密钥
*   $\mathsf{DKGen}$：$DK_{A,B}$ 属性解密密钥，根据用户的属性集合生成属性解密密钥
*   $\mathsf{PolGen}$：$SK_{A_A,A_B}$ 策略解密密钥，根据用户自己的访问策略生成策略解密密钥

现在 A 广播消息，只有满足自己策略的才可以解密获得消息

调用 $\mathsf{Enc}(EK_A,A_A,m)$ 产生消息

B 收到消息后，先进行属性匹配

1.  B 的属性<span style="color: rgb(255, 32, 32);">名</span>是否满足 A 的策略？
2.  A 的属性<span style="color: rgb(255, 32, 32);">名</span>是否满足 B 的策略？

两个条件都满足，进入 $\mathsf{FEME.Dec}$

在这里面进行真正的双向属性验证

$$M=\mathsf{Dec}(DK_B,SK_{A,B},CT_B)$$

B 会使用两个密钥检测

1.  $DK_B$ 检查 B 是否能够满足 $A_A$（CP-ABE）
2.  $SK_{A,B}$ 检查 A 的完整属性是否满足 B 的策略（KP-ABE）

完全检测通过后就可以恢复出密钥了

对于安全 FEME 是基于 GGM上的安全保证

![\<img alt="" width="919" height="362" data-attachment-key="YXBZCRLC" src="attachments/YXBZCRLC.png" ztype="zimage"> | 919](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261117162247735.png)

分别是 安全 匿名 和认证

那么在表达上，FEME克服了 ACME的小域问题，还有要求事先约定好的固定二进制向量

在安全和隐私上面，ACME具有安全风险，FEME基于双重随机化方法，弥补了其安全问题

在易用性上 FEME 把认证信息直接集成在密文中，提供了高可用和可扩展

# V. PRISRV+ PROTOCOL

我们把上面的内容迁移到真实 PRISRV+协议的表达上

PriSrv+是一个 私有服务发现协议，基于FEME架构，保证了双边认证，那么大概流程如下：

1.  开始阶段 KGC 产生属性加密密钥、属性解密密钥、策略解密密钥，交给服务提供者 S 和客户 C
2.  在广播阶段，S提供基于FEME的匿名广播密文，里面嵌入了S的策略，服务细节和DH公钥还有MAC认证密钥
3.  在服务查找阶段，C会先检查密文中的属性名是否匹配，如果匹配就进入FEME解密阶段，通过自己的密钥 验证隐藏在密文中的属性值是否匹配，如果属性值都匹配，那么C产生一个回应，并且基于FEME加密 自己的策略，认证TAG，给S
4.  S 解密并验证 C 的回应，发送一个确认信息
5.  双边计算出一个共享的密钥用于通信

那么大概思路就如上面说的

## A. Security and Threat Models of PriSrv+

### 安全模型

PriSrv+是跟着PriSrv协议的，需要的是 服务查找安全和双边匿名

服务查找安全：确保私有 和双边匿名认证

双边匿名：如果双方不满足对方策略，那么不会得到任何有关对方的信息

### 威胁模型

PriSrv+ 构建一个完全可信的KGC

服务提供S 和 客户C 则是完全不可信

## B. PriSrv+ Construction

这里从细节开始说明 PriSrv+的完全构成

因为他是一个SD广播协议，所以这里说一下

广播身份 bid 是在每次广播循环中唯一的

会话身份 sid 是每次会话唯一的

完整过程如图：

![\<img alt="" width="1740" height="761" data-attachment-key="IICAW2HI" src="attachments/IICAW2HI.png" ztype="zimage"> | 1740](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261117162247736.png)

我这里会具体说明交互过程

大概过程会分为：Service Broadcast 阶段、 Anonymous Mutual Authentication阶段

### Service Broadcast

初始化广播，S 选择一个自己的策略，并要求允许 C 满足；S 再选择一个 DH 指数 $z$，计算 $Z=h^z$，并对此内容产生 MAC 密钥 $K_c$需要广播的消息组成如下：

$$MSG_B=(bid\|Z\|ServiceType\|ServicePar\|K_c)$$

S 使用 $\mathsf{FEME.Enc}$ 加密得到 $CT_B$ 广播出去

### Anonymous Mutual Authentication

1.  **Client Response**：C 检查密文中的属性名是否满足自己的策略，同时检查自己的属性名是否满足 S 的策略；如果都满足就进入解密如果解密成功，C 产生 DH 参数 $X_1=g^{x_1}$、$X_2=h^{x_2}$，设立回应消息 $M=(\text{“C”}\to\text{“S”},bid,sid,X_1,X_2,Z)$，并使用 $K_c$ 计算认证 tag $\sigma_c$，最后基于 FEME 计算产生密文发送给 S
2.  **Service Provider Response**：S 解密并验证 $\sigma_c$，产生自己的 DH 值 $Y\gets g^y$，产生消息 $M=(\text{“S”}\to\text{“C”},bid,sid,X_1,X_2,Y,Z)$ 和 $\sigma_s$，然后计算会话密钥 $SSK\gets\hat H(X_1^y,X_2^z)$，发送 $M,\sigma_s$ 给 C
3.  **Client Finalization**：接受 S 发送的内容，验证 $\sigma_s$；如果有效，C 也计算 $SSK\gets\hat H(Y^{x_1},Z^{x_2})$，到此双方协商好会话密钥

对于安全性：

> 假设DDH假设成立，FEME是安全的，MAC是不可伪造的，H是随机的，那么PriSrv+就是一个安全的SD协议和满足双边匿名的

SD安全由 FEME支撑，双边匿名也是基于FEME的匿名性

## C. Comparative Advantages of PriSrv+

在PriSrv文章中 会和10种不同的 SD协议进行比较，那么本文 我们只会对 PriSrv进行比较

![\<img alt="" width="1152" height="203" data-attachment-key="YU6N5XV2" src="attachments/YU6N5XV2.png" ztype="zimage"> | 1152](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261117162247737.png)

从 表达，安全和保密以及易用性上进行了比较

## D. Discussions

这里我具体说明一下作者如何思考对抗 DoS 攻击

DoS 攻击来自过度属性提交

PriSrv+可以 融入灵活的工作量证明、也就是CF盾类似的内容

服务提供者嵌入一个难度等级在广播身份中，用户必须计算出一个 sid 并且满足这个难度

上述方法对正常的用户开销增加是很小的，但是对于批量请求攻击者的开销是大的

# VI. IMPLEMENTATION AND EVALUATION

对于这个的评估我就不深入说明了 可以看原文 ，大概就是使用相同环境开始

# VII. LIMITATIONS AND FUTURE WORK

1.  依赖于对属性的无条件相信
2.  不包含撤销机制
3.  无法缓解客户滥用行为，也就是不存在用户问责系统

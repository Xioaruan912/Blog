这里我们进入一个新的内容 叫做秘密共享方案，下面我们给出一个引例：

> DNS 是用于把 URL 映射到 IP 的一个协议，在最开始 DNS 是无身份的，也就是无论是哪里来的 IP，DNS 都会相应，但是这样就导致了问题，所以后面引入了 DNSSEC，使用密码学的方式控制协议

DNSSEC 需要一个叫做 主密钥 的密钥，该密钥拥有对整个互联网 DNS 信息的控制权  

我们关注的点是这个密钥的管理是什么：<span style="color:#FF3333;">主密钥会划分为 7 部分</span>，每个部分交给一个可信人员，如果你要复原密钥 K，最少需要集齐 5 个可信人员，才可以恢复密钥，否则无法获得有关于<span style="text-decoration:underline;">密钥的任何信息</span>

上面的讲述内容 其实就是密码学原语：**秘密共享方案**

# 3.1. Defining secret sharing

秘密共享是一个把消息 M 加密为多个部分——叫做共享

把共享和一个阈值 t 联合起来，满足下面性质：

- 如果你<span style="color:#FF0000;">有任何 t 个共享，就可以恢复秘密 M</span>
- 如果你只有少于 t 个共享，那么就不会得到有关于 M 的任何信息

我们考虑这个场景：

有一个人叫做经销商，拥有秘密 M，并且产生共享，然后把共享划分交给用户

这个虽然不是秘密共享的唯一方案，但是是最简单的方案

## Filter 函数

下面我们会设立一个 Filter 函数，用于用于设立哪些是愿意恢复密钥的人，让其共享上交，不愿意的人让其 保持 NULL

- 拥有可信用户 n 个
- 共享也具有 n 个 记作 Sn
- 设立一个子集 U，<span style="color:#FF0000;">这个 U 是我们允许复原密钥的人的集合</span>，数量是 t，**t < n**

 ![image-20261021170124694](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021170124796.png)

可以发现 这里我们人为让有些可信用户的共享是 NULL

![image-20261021170149697](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021170149740.png)

为什么不直接删除，而是要让其作为 NULL？

因为我们不想泄露任何有关于 M 的信息，也不想泄露密钥到底是在谁手上

## 语法

我们知道了 秘密共享是一个原语，那么这里就要说明他的语法是什么

> 有一个 t-out-of-n 的秘密共享方案，由下面算法构成：

- Share 算法：是一个随机算法，输入 M，输出切分【带有加密的】好的 S_n
- Reconstruct：是一个确定性算法，输入可复原人数集合，集合大小为 t 和他们的 S，输出 M
- t 是这个算法的阈值

## 正确性

说明完语法我们还需要说明是否正确，也就是划分完毕的内容是否都可以基于上面的算法恢复

![image-20261021170850033](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021170850069.png)

1. 通过 Share 切分 M
2. 通过 Filter 用于得到希望恢复秘密的 人员的共享 Si
3. 通过 Reconstruction 基于恢复子集 U，就可以得到秘密 M

## 安全属性

现在考虑是否安全，我们的安全目的就是 如果少于 t 就无法知道关于 M 的任何信息，那么我们 设立攻击场景

- 敌手可以完整控制 Share 算法，因为不涉及任何密钥内容
- Share 的输出，经过 Filter 的过滤后才交给敌手，这是确保敌手只会看到比 t 还少的共享【Filter 输出多少，依赖于 U，U 才是可复原密钥集合】【这里会在后面进行约束】
- 使用 Real or Rand 说明安全性

下面我们考虑存在两个库，一个是 real 一个是 rand

他们都输出的是 Filter 结果 给敌手

那么剩下最后一个问题：U 到底多大？

直接交给敌手，让敌手选择，并且<span style="color:#FF0000;">敌手选择的 U 一定要小于 t</span>

这样就可以确保 无法直接通过 U 复原

下面我们就可以说明安全性

![image-20261021171534509](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021171534562.png)

只要满足这两个库是可互换的，那么这个秘密共享算法就是安全的

这里可以看到 如果敌手选择的 U 大于 t 就直接报错

## 一个幼稚的秘密共享方案

如果我们只是简单的切分 M 分配给各个用户，我们看看什么情况

![image-20261021171646870](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021171646917.png)

可以发现 只是进行了切分，没有进行任何加密

我们可以很简单的看到 real or rand 模型是不可互换的

![image-20261021171756979](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021171757017.png)

因为只要敌手进行构造 输入 M 为全 0 字符串

![image-20261021171813595](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021171813625.png)

那么就可以凭借 1 的概率获胜

但是如果是 rand 只会有 1/2^k 的概率获胜 k 是字符串长度

敌手的获胜目标也在里面哦 就是判断 S1 是不是为全 0 字符串

# 3.2. 2-out-of-2 secret sharing

这里使用一个简单的例子说明 秘密共享

2-out-of-2 秘密共享

- 密钥只是划分为两个共享
- 两个共享都需要被使用才可以恢复 M
- <span style="color:#FF0000;">U 只能选择 {} {1} {2}</span>

实际上我们思考 OTP 就是一个 2-out-of-2

1. 对于 share 的两个内容是 **密钥和密文**
2. 只有 **密钥和密文** 都获得了 才可以恢复明文
3. 如果只有其中一个，**不会对明文泄露任何信息**

![image-20261021185614736](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021185614804.png)

我们基于 OTP 构建出一个秘密共享方案

## 正确性

我们看看他正确性：

基于 xor 算法 可以正确恢复明文

![image-20261021185648021](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021185648044.png)

## 安全性

现在开始分析一下安全性 其实就是使用上面的两个库来验证基于 OTP 的秘密共享方案是否安全

> 上面所声称的方案是一个安全的 2-out-of-2 秘密共享方案，只要满足：

![image-20261021190153567](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021190153607.png)

### 证明

我们上面说过了 U 只可以选择空集 或者{1} {2}

- 对于空集 无所谓因为敌手完全不知道内容
- 对于 U1 只会输出 S1，也无所谓因为是均匀分布的
- 对于 U2 就要分析一次保密的 OTP 了，因为基于 OTP 的

下面我们开始对 U2 分析一下

首先第一步，我们把 Filter 填入算法

 ![image-20261021170124694](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021170124796.png)

这里先回顾一下 Filter 是什么，上图，下面是扩写开，不使用 `for` 的表达形式

![image-20261021190420754](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021190420815.png)

 把 Filter 的三个不同集合都扩写开来，然后继续分析

我们可以直接简化为下面：把注释删掉和无用代码删掉

![image-20261021190515345](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021190515383.png)

我们聚焦于 OTP 

![image-20261021190531536](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021190531559.png)

由于 OTP 安全 所以我们可以直接使用均匀采样代替

![image-20261021190550711](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021190550737.png)

这里其实核心就做完了，现在我们提出 Filter

![image-20261021190617392](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021190617424.png)

那么这里不就证明完毕了吗

# 3.3. Polynomial interpolation

我们下面要学习 Shamir secret sharing 所以这里是给 Shamir secret sharing 打<span style="color:#FF0000;">数学基础</span>

> 我们知道 两个点确定一个直线，三个点确定一个抛物线

后面构建的秘密共享方案就基于

> <span style="color:#FF0000;">d+1 个点决定唯一阶数为 d 的多项式</span>

## 符号

我们先学习一下简单的符号，F 是一个阶数为 d 的多项式：

![image-20261021193347437](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021193347464.png)

阶数也就是最大次数，并且最大次数，其实应该说<span style="color:#FF0000;">至多 d 次</span>，因为 cd 可以为 0

我们使用 X 表述多项式的输入参数 xi 表述多项式中阶数为 i 的那个元素

通过<span style="color:#FF0000;">点的集合，找到一个唯一多项式，这个就是 **插值**</span>

## Polynomial interpolation

- (xi, yi) 是在 R^2【就是实数空间】 中抽取的，并且要求 <span style="color:#FF0000;">xi 完全不同</span>
- 存在一个唯一阶数为 d 的多项式 F(x)
- 对于实数 i 具有 <span style="color:#FF0000;">yi = F(xi)</span>

这个就是插值多项式的基本定义

## 证明

我们思考一个简单的 d+1 阶多项式

![image-20261021193630203](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021193630227.png)

- 输入 x1 不为 0
- 输入 xi i!= 1  全为 0

我们只考虑 x1 点 特殊点  我们可以基于 A(X)构建出一个新的多项式

![image-20261021193747046](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021193747073.png)

基于这个多项式继续扩展可以得到下面多项式

![image-20261021193813500](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021193813525.png)

这里是基于 x1 的 依据这里我们可以进行扩展得到所有多项式

![image-20261021193842503](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021193842527.png)

他们的阶数全部都是 d，这个就是 **拉格朗日多项式**

最后我们考虑基于拉格朗日多项式构建的一个多项式

![image-20261021193918258](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021193918282.png)

我们可以验证 输入对应的 xi 可以得到 y1

比如我们输入 x1 只有 L1 会返回 1 其他均返回 0 那么这样就得到了

F(x1) = y1 这里就证明了 

只要每个 xi 都不相同，就可以基于插值得到 F 并且阶数至多为 d，这是我们使用 <span style="color:#FF0000;">d+1 个点插值出来的</span>

### 唯一性

现在我们证明唯一性

假设存在两个不一样的 F 可以得到相同的结论，那么我们可以构建出一个 d 的多项式

![image-20261021194204368](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021194204392.png)

因为我们知道 d+1 阶数确定 d 阶多项式 但是我们发现 只有根 0 是 d+1 阶，所以说一定是 d+1 个 0 确定 G

于是就可以得到 F 是唯一的

## 使用具体例子理解

考虑下面例子

![image-20261021194329476](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021194329512.png)

可以发现 xi 都是不同的

构建拉格朗日多项式

![image-20261021194359807](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021194359848.png)

这里可以检查 是不是只有 i = j 才会导致 1 的产生

现在我们通分一下

![image-20261021194428398](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021194428428.png)

开始求和

![image-20261021194437167](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021194437209.png)

可以发现 4 个点确定一个 3 阶多项式

# 3.4. Multiplicative inverses modulo a prime

这里我们需要学习一下基本的<span style="color:#FF0000;">模运算</span>

加法 减法 乘法都可以在模运算中很好的实现 

我们定义运算： Zn 是模 n 下所有元素的集合，如果经过运算后的结果全部都落在 Zn 中

现在我们尝试构建 <span style="color:#FF0000;">基于模 n 的除法</span>

首先我们从代数理解 如果 x 除以 2 那么可以使用 

可以使用 2x = 1 来查找 

我们转化到模运算中 如果 x in Zn 满足 2x =_n 1 那么就说明 x 被除以 2 了

下面是一些 可以除以 2 的例子 和不可以的例子

![image-20261021211437742](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021211437884.png)

可以发现 除法在有些情况下无解

如果除以 b 和乘上 x <span style="color:#FF0000;">满足 xb = 1 那么我们就说 x 是 b 在模 n 下的乘法逆元</span>

![image-20261021211607539](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021211607603.png)

## 计算乘法逆元

加法 减法 乘法 都可以先运算后进行模操作

但是除法不可以，一定需要得到乘法逆元才可以

其实这里很简单 你要得到

1. 你要得到 b 在 mod n 下的乘法逆元
2. 设立 bx = 1 成立【如果成立就有乘法逆元】
3. <span style="color:#FF0000;">运算 bx = 1modn 如果存在 x 实现 这个 x 就是 b 的乘法逆元</span>

## 素数模数

我们之前看到 乘法逆元有可能存在 也有可能不存在

什么时候存在？ 其实<span style="color:#FF0000;">只要模数是素数，就会有乘法逆元</span>

![image-20261021211737713](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021211737754.png)

这个是 模素数在密码学一直适用的基本原因

## 证明

我们使用反证法

假设 我们需要求解 模素数 n 下的 b 的乘法逆元，假设都没有

xb = 1 mod n 满足

现在我们计算所有的余数 b%n , 2b %n ….

可以得到 {0,….n-1}的 n 个余数 因为我们假设了不会有 b = 1mod n 的存在 所以说 只有 n-1 个元素

n 个余数 但是只有 n-1 个元素，所以一定有两个元素的余数相同

于是我们可以构建

ib %n = jb %n i!= b

那么我们通过运算可以得到 |i-j|b = 0

下面我们有一个基于素数的性质

![image-20261021212047932](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021212047978.png)

<span style="color:#FF0000;">只要你是素数， 整除两个相除的 那么就整除其中一个</span>

但是有一个问题 |i-j| 和 b 都是小于 n 的 

n 不可能整除一个比自己小的 于是矛盾

说明我们假设的错误

## 插值

我们之前说过了 实数的插值

那么其实模也是适用的，因为我们说了 n 是素数就可以除法

那么基于拉格朗日的证明就正确

唯一性和之前一样证明 也是正确

所以我们可以完美迁移 素数模数 n 到插值实数上

# 3.5. Shamir secret sharing

我们学习了上面那么多知识 又是插值得到多项式 又是乘法逆元

都是在这里作用

- 乘法逆元可以保证 基于模素数下 除法可以实现
- 插值可以保证 d+1 个点可以恢复出 d 阶多项式

Shamir 秘密共享 就是基于 多项式插值法

1. <span style="color:#FF0000;">共享是一个 t-1 阶多项式 Q(X)的点集 可能有 n 个点</span>
2. 我们只需要 t 个点 其中 t < n 就可以恢复出这个多项式
3. <span style="color:#FF0000;">我们使用 Q(0)= M 存储秘密</span>，只有恢复了多项式才可以得到秘密

核心思想就是上面的内容

下面我们来看具体方案

> p 是一个素数，t 和 n 是 t <= n < p 的整数

我们首先来看 Share

![image-20261022090827129](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261022090827208.png)

其实做的事情很简单

1. 固定常数项为秘密 M
2. 其他<span style="color:#FF0000;">系数均从 Zp 中随机收取</span>
3. 构建出唯一的 t-1 阶多项式 Q(X)
4. 把 i 作为 xi 输入 Q 得到 yi 作为共享 Si

到这里我们其实就做完了 秘密共享，这里会产生 n 份的共享

下面我们看看 Reconstruct

![image-20261022091000921](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261022091000959.png)

1. 接受一个数量为 n 的共享集合，里面是愿意恢复 M 的人的共享 Si，如果不愿意的共享就是 NULL
2. 检查 Si 如果愿意就加入恢复集合 I 中
3. 基于多项式插值法，只要检测有 t 个点，就可以唯一确定 t-1 阶多项式 Q(X)
4. 最后基于常数项得到秘密 M

这里还有 n < q 是为了保证 每个计算出来的余数唯一

也就是 `Q(i) % q` 唯一

## 安全性

抓住我们的分析目标，我们只需要分析 敌手拿到 t-1 共享的时候 尝试去破解，是不是看到的是随机值

1. 我们假设 U = t-1 那么 U 的选择就是具有 1/p^t-1 的可能
2. 也就是说 作为 Share 的输入，我们只有 1/p^t-1 的可能 可以确定到真正的输入
3. 那么继续传递 也就是说 Share 输出得到真实 Si 的结果的可能 也是依赖于 U 的输入概率 也就是 1/p^t-1 的可能
4. 只有 Q(i)= Si 的时候 才可以发生
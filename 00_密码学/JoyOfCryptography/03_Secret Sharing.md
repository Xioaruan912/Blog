这里我们进入一个新的内容 叫做秘密共享方案，下面我们给出一个引例：

> DNS是用于把URL映射到IP的一个协议，在最开始DNS是无身份的，也就是无论是哪里来的IP，DNS都会相应，但是这样就导致了问题，所以后面引入了DNSSEC，使用密码学的方式控制协议

DNSSEC需要一个叫做 主密钥 的密钥，该密钥拥有对整个互联网 DNS 信息的控制权  

我们关注的点是这个密钥的管理是什么：主密钥会划分为7部分，每个部分交给一个可信人员，如果你要复原密钥K，最少需要集齐5个可信人员，才可以恢复密钥，否则无法获得有关于密钥的任何信息

上面的讲述内容 其实就是密码学原语：**秘密共享方案**

# 3.1. Defining secret sharing

秘密共享是一个把消息M加密为多个部分——叫做共享

把共享和一个阈值t联合起来，满足下面性质：

- 如果你有任何t个共享，就可以恢复秘密M
- 如果你只有少于t个共享，那么就不会得到有关于M的任何信息

我们考虑这个场景：

有一个人叫做经销商，拥有秘密M，并且产生共享，然后把共享划分交给用户

这个虽然不是秘密共享的唯一方案，但是是最简单的方案

## Filter函数

下面我们会设立一个Filter函数，用于说明n个可信用户，但是我们人为要求t个可恢复

- 拥有可信用户 n个
- 共享也具有n个 记作Sn
- 在 n个用户中设立一个子集U，这个U是我们允许复原密钥的人，数量是t

 ![image-20261021170124694](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021170124796.png)

可以发现 这里我们人为让有些可信用户的共享是NULL

![image-20261021170149697](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021170149740.png)

为什么不直接删除，而是要让其作为NULL？

因为我们不想泄露任何有关于M的信息，也不想泄露密钥到底是在谁手上

## 语法

我们知道了 秘密共享是一个原语，那么这里就要说明他的语法是什么

> 有一个 t-out-of-n的秘密共享方案，由下面算法构成：

- Share算法：是一个随机算法，输入M，输出切分【带有加密的】好的S_n
- Reconstruct：是一个确定性算法，输入可复原人数集合，集合大小为t和他们的S，输出M
- t是这个算法的阈值

## 正确性

说明完语法我们还需要说明是否正确，也就是划分完毕的内容是否都可以基于上面的算法恢复

![image-20261021170850033](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021170850069.png)

1. 通过Share 切分M
2. 通过Filter 分发Share切分的值给可复原用户集合U中的用户
3. 通过Reconstruction 基于恢复子集U，就可以得到秘密M

## 安全属性

现在考虑是否安全，我们的安全目的就是 如果少于t 就无法知道关于M的任何信息，那么我们 设立攻击场景

- 敌手可以完整控制Share算法，因为不涉及任何密钥内容
- Share的输出，经过Filter的过滤后才交给敌手，这是确保敌手只会看到比t还少的共享【Filter输出多少，依赖于U，U才是可复原密钥集合】【这里会在后面进行约束】
- 使用Real or Rand 说明安全性

下面我们考虑存在两个库，一个是real 一个是rand

他们都输出的是 Filter结果 给敌手

那么剩下最后一个问题：U到底多大？

直接交给敌手，让敌手选择，并且敌手选择的U 一定要小于t

这样就可以确保 无法直接通过U 复原

下面我们就可以说明安全性

![image-20261021171534509](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021171534562.png)

只要满足这两个库是可互换的，那么这个秘密共享算法就是安全的

这里可以看到 如果敌手选择的U 大于t 就直接报错

## 一个幼稚的秘密共享方案

如果我们只是简单的切分M 分配给各个用户，我们看看什么情况

![image-20261021171646870](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021171646917.png)

可以发现 只是进行了切分，没有进行任何加密

我们可以很简单的看到 real or rand模型是不可互换的

![image-20261021171756979](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021171757017.png)

因为只要敌手进行构造 输入M为全0字符串

![image-20261021171813595](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021171813625.png)

那么就可以凭借 1的概率获胜

但是如果是rand 只会有 1/2^k的概率获胜 k是字符串长度

敌手的获胜目标也在里面哦 就是判断S1 是不是为全0字符串

# 3.2. 2-out-of-2 secret sharing

这里使用一个简单的例子说明 秘密共享

2-out-of-2秘密共享

- 密钥只是划分为两个共享
- 两个共享都需要被使用才可以恢复M
- U只能选择空集 或者{1} {2}

实际上我们思考OTP 就是一个2-out-of-2

1. 对于share的两个内容是密钥和密文
2. 只有密钥和密文都获得了 才可以恢复明文
3. 如果只有其中一个，不会对明文泄露任何信息

![image-20261021185614736](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021185614804.png)

我们基于OTP构建出一个秘密共享方案

## 正确性

我们看看他正确性：

基于xor算法 可以正确恢复明文

![image-20261021185648021](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021185648044.png)

## 安全性

现在开始分析一下安全性 其实就是使用上面的两个库来验证基于OTP的秘密共享方案是否安全

> 上面所声称的方案是一个安全的2-out-of-2秘密共享方案，只要满足：

![image-20261021190153567](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021190153607.png)

### 证明

我们上面说过了 U只可以选择空集 或者{1} {2}

- 对于空集 无所谓因为敌手完全不知道内容
- 对于U1 只会输出S1，也无所谓因为是均匀分布的
- 对于U2 就要分析一次保密的OTP了，因为基于OTP的

下面我们开始对U2分析一下

首先第一步，我们把Filter填入算法

 ![image-20261021170124694](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021170124796.png)

这里先回顾一下Filter是什么，上图，下面是扩写开，不使用`for` 的表达形式

![image-20261021190420754](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021190420815.png)

 把Filter的三个不懂集合都扩写开来，然后继续分析

我们可以直接简化为下面：把注释删掉和无用代码删掉

![image-20261021190515345](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021190515383.png)

我们聚焦于 OTP 

![image-20261021190531536](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021190531559.png)

由于OTP安全 所以我们可以直接使用均匀采样代替

![image-20261021190550711](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021190550737.png)

这里其实核心就做完了，现在我们提出 Filter

![image-20261021190617392](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021190617424.png)

那么这里不就证明完毕了吗

# 3.3. Polynomial interpolation

我们下面要学习 Shamir secret sharing 所以这里是给Shamir secret sharing打数学基础

> 我们知道 两个点确定一个直线，三个点确定一个抛物线

后面构建的秘密共享方案就基于

> d+1个点决定唯一阶数为d的多项式

## 符号

我们先学习一下简答的符号，F是一个阶数为d的多项式：

![image-20261021193347437](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021193347464.png)

阶数也就是最大次数，并且最大次数，其实应该说至多d次，因为cd可以为0

我们使用X表述多项式的输入参数 xi表述多项式中阶数为i的那个元素

通过点的集合，找到一个唯一多项式，这个就是**插值**

## Polynomial interpolation

- (xi,yi) 是在R^2中抽取的，并且要求xi完全不同
- 存在一个唯一阶数为d的多项式F(x)
- 对于实数i 具有 yi=F(xi)

这个就是插值多项式的基本定义

## 证明

我们思考一个简单的d+1阶多项式

![image-20261021193630203](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021193630227.png)

- 输入x1 不为0
- 输入xi i!=0 全为0

我们只考虑x1点 特殊点  我们可以基于A(X)构建出一个新的多项式

![image-20261021193747046](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021193747073.png)

基于这个多项式继续扩展可以得到下面多项式

![image-20261021193813500](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021193813525.png)

这里是基于 x1的 依据这里我们可以进行扩展得到所有多项式

![image-20261021193842503](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021193842527.png)

他们的阶数全部都是d，这个就是**拉格朗日多项式**

最后我们考虑基于拉格朗日多项式构建的一个多项式

![image-20261021193918258](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021193918282.png)

我们可以验证 输入对应的xi 可以得到y1

比如我们输入x1 只有L1会返回1 其他均返回0 那么这样就得到了

F(x1) = y1 这里就证明了 

只要每个xi都不相同，就可以基于插值得到F 并且阶数至多为d，这是我们使用d+1个点插值出来的

### 唯一性

现在我们证明唯一性

假设存在两个不一样的F可以得到相同的结论，那么我们可以构建出一个 d的多项式

![image-20261021194204368](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021194204392.png)

因为我们知道 d+1阶数确定d阶多项式 但是我们发现 只有根0是d+1阶，所以说一定是d+1个0确定G

于是就可以得到F是唯一的

## 使用具体例子理解

考虑下面例子

![image-20261021194329476](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021194329512.png)

可以发现xi都是不同的

构建拉格朗日多项式

![image-20261021194359807](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021194359848.png)

这里可以检查 是不是只有 i=j才会导致1的产生

现在我们通分一下

![image-20261021194428398](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021194428428.png)

开始求和

![image-20261021194437167](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021194437209.png)

可以发现 4个点确定一个3阶多项式

# 3.4. Multiplicative inverses modulo a prime

这里我们需要学习一下基本的模运算

加法 减法 乘法都可以在模运算中很好的实现 

我们定义运算： Zn 是模n下所有元素的集合，如果经过运算后的结果全部都落在Zn中

现在我们尝试构建 基于模n的除法

首先我们从代数理解 如果 x 除以2 那么可以使用 

可以使用 2x=1 来查找 

我们转化到模运算中 如果x in Zn 满足 2x=_n 1 那么就说明x被除以2了

下面是一些 可以除以2的例子 和不可以的例子

![image-20261021211437742](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021211437884.png)

可以发现 除法在有些情况下无解

如果除以b 和乘上x 满足 xb=1 那么我们就说x是b在模n下的乘法逆元

![image-20261021211607539](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021211607603.png)

## 计算乘法逆元

加法 减法 乘法 都可以先运算后进行模操作

但是除法不可以，一定需要得到乘法逆元才可以

其实这里很简单 你要得到

1. 你要得到 b在mod n下的乘法逆元
2. 设立bx=1 成立【如果成立就有乘法逆元】
3. 运算 bx=1modn 如果存在x实现 这个 x就是b的乘法逆元

## 素数模数

我们之前看到 乘法逆元有可能存在 也有可能不存在

什么时候存在？ 其实只要模数是素数，就会有乘法逆元

![image-20261021211737713](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021211737754.png)

这个是 模素数在密码学一直适用的基本原因

## 证明

我们使用反证法

假设 我们需要求解 模素数n下的b的乘法逆元，假设都没有

xb=1 mod n 满足

现在我们计算所有的余数 b%n , 2b %n ….

可以得到 {0,….n-1}的n个余数 因为我们假设了不会有b=1mod n的存在 所以说 只有n-1个元素

n个余数 但是只有n-1个元素，所以一定有两个元素的余数相同

于是我们可以构建

ib %n = jb %n i!=b

那么我们通过运算可以得到 |i-j|b = 0

下面我们有一个基于素数的性质

![image-20261021212047932](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261021212047978.png)

只要你是素数， 整除两个相除的 那么就整除其中一个

但是有一个问题 |i-j| 和 b 都是小于n 的 

n不可能整除一个比自己小的 于是矛盾

说明我们假设的错误

## 插值

我们之前说过了 实数的插值

那么其实模也是适用的，因为我们说了 n是素数就可以除法

那么基于拉格朗日的证明就正确

唯一性和之前一样证明 也是正确

所以我们可以完美迁移 素数模数n到插值实数上

# 3.5. Shamir secret sharing

我们学习了上面那么多知识 又是插值得到多项式 又是乘法逆元

都是在这里作用

- 乘法逆元可以保证 基于模素数下 除法可以实现
- 插值可以保证 d+1个点可以恢复出d阶多项式

Shamir秘密共享 就是基于 多项式插值法

1. 共享是一个t-1阶多项式Q(X)的点集 可能有n个点
2. 我们只需要 t个点 其中 t<n 就可以恢复出这个多项式
3. 我们使用Q(0)=M 存储秘密，只有恢复了多项式才可以得到秘密

核心思想就是上面的内容

下面我们来看具体方案

> p是一个素数，t和n是 t<=n<p的整数

我们首先来看 Share

![image-20261022090827129](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261022090827208.png)

其实做的事情很简单

1. 固定常数项为秘密M
2. 其他系数均从Zp中随机收取
3. 构建出唯一的t-1阶多项式Q(X)
4. 把i作为xi 输入Q 得到yi 作为共享Si

到这里我们其实就做完了 秘密共享，这里会产生n份的共享

下面我们看看 Reconstruct

![image-20261022091000921](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261022091000959.png)

1. 接受一个数量为n的共享集合，里面是愿意恢复M的人的共享Si，如果不愿意的共享就是NULL
2. 检查NULL 如果愿意就加入恢复集合I中
3. 基于多项式插值法，只要检测有t个点，就可以唯一确定多项式Q(X)
4. 最后基于常数项得到秘密M

这里还有 n<q是为了保证 每个计算出来的余数唯一

也就是 `Q(i) % q` 唯一

## 安全性

抓住我们的分析目标，我们只需要分析 敌手拿到 t-1共享的时候 尝试去破解，是不是看到的是随机值

1. 我们假设U=t-1 那么U的选择就是具有 1/p^t-1的可能
2. 也就是说 作为Share的输入，我们只有 1/p^t-1的可能 可以确定到真正的输入
3. 那么继续传递 也就是说 Share输出得到真实Si的结果的可能 也是依赖于U的输入概率 也就是 1/p^t-1的可能
4. 只有Q(i)=Si的时候 才可以发生
# RSA——<span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FZX54WUGS%22%2C%22pageLabel%22%3A%22120%22%2C%22position%22%3A%7B%22pageIndex%22%3A0%2C%22rects%22%3A%5B%5B56.16%2C692.12568%2C251.04957544799984%2C709.18968%5D%2C%5B56.88119212000001%2C673.88616%2C292.00880197999993%2C690.9501600000001%5D%2C%5B56.64136986%2C655.64664%2C207.52166272399992%2C672.71064%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22120%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/ZX54WUGS?page=1">“A Method for Obtaining Digital Signatures and PublicKey Cryptosystems”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22120%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/AU794KG9">Rivest 等, 1978, p. 120</a></span>)</span>

这里开始梳理RSA原始论文

论文开始说明了 公钥密码的好处

1.  不需要协商密钥了，发送者公开使用对方的公钥加密自己的消息，接收者得到消息后使用私钥解密
2.  使用私钥签名可以保证身份验证和防止否认消息

同时介绍了 RSA是什么 基于什么数学难题的——<span style="color: rgb(255, 32, 32);">大数分解</span>

<span style="color: rgb(255, 32, 32);">作者还说DH虽然提出了公钥密码体系，但是并没有提出任何基于原论文“单向门限函数“的具体算法</span>

RSA算是作者能想到的第一个 门限单向函数——只有得到秘密信息的人可以快速计算 否则其他人无法计算

# <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FZX54WUGS%22%2C%22pageLabel%22%3A%22120%22%2C%22position%22%3A%7B%22pageIndex%22%3A0%2C%22rects%22%3A%5B%5B333.36036624%2C532.77264%2C448.5711182879996%2C541.84464%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22120%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/ZX54WUGS?page=1">“Public-Key Cryptosystems”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22120%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/AU794KG9">Rivest 等, 1978, p. 120</a></span>)</span>

作者在这里大概介绍了一下 公钥密码体系是什么

主要围绕下面四个性质进行

![\<img alt="" width="807" height="522" data-attachment-key="UHIMURAE" src="attachments/UHIMURAE.png" ztype="zimage"> | 807](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261012112314664.png)

第一个可以确保加密和解密——<span style="color: rgb(255, 32, 32);">保护隐私</span>

第二个是确保E和D 即公钥和私钥很容易生成

第三个是公开的E不会导致任何关于D的泄露

第四个是确保可以进行签名和验证签名——<span style="color: rgb(255, 32, 32);">身份认证</span>

<span style="color: rgb(255, 32, 32);">作者还说 基于DH的论文 只要有一个算法满足 a-c 就可以说明这个函数是一个单向门限函数</span>

单向门限函数—— 首先他是一个单向函数，从Y计算X是非常困难的，其次具有门限问题，如果一个人掌握了门限信息，那么从Y计算出X将会非常简单

DH的算法为：$x \longmapsto g^x \pmod p$ 计算是很容易的 但是反向计算很困难，并且没有任何额外秘密信息可以从Y计算出X——所以<span style="background-color: rgba(255, 102, 102, 0.5);">DH的密钥分发不是一个单向门限函数</span>

# <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FZX54WUGS%22%2C%22pageLabel%22%3A%22121%22%2C%22position%22%3A%7B%22pageIndex%22%3A1%2C%22rects%22%3A%5B%5B58.0608%2C450.43224%2C110.13954829999999%2C460.58424%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22121%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/ZX54WUGS?page=2">“Privacy”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22121%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/AU794KG9">Rivest 等, 1978, p. 121</a></span>)</span>

在公钥密码提出之前 所有的经典算法都有 <span style="color: rgb(255, 32, 32);">密钥分发的苦难</span>

公钥密码出现

只有在初始阶段需要他们 生成私钥和公钥，并且把公钥对外开放，可以存入公开档案中，以便交流

RSA文章还提出 公钥加密 允许直接在不安全的信道上传输公钥即可

因为公钥是对外开发的 敌手得到公钥 无法得到私钥的任何信息 也就没有任何作用了

RSA还提出 可以使用公钥密码体系用于建立密钥交换，使用对称加密算法进行算法加密

# <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FZX54WUGS%22%2C%22pageLabel%22%3A%22121%22%2C%22position%22%3A%7B%22pageIndex%22%3A1%2C%22rects%22%3A%5B%5B336.23987233%2C309.07223999999997%2C379.92234472999996%2C319.22424%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22121%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/ZX54WUGS?page=2">“Signatures”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22121%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/AU794KG9">Rivest 等, 1978, p. 121</a></span>)</span>

作者提出 以前的身份完整性存在的问题：如果收到消息，反而要去自证这个消息没有被篡改过

那么公钥算法给出了 防止这个不必要的自证的签名

1.  使用发送方的私钥进行签名
2.  发送给接收方（这里没有考虑隐私保护）
3.  接收方使用发送方的公钥验证消息合法性

甚至可以附加名字在消息上，以便接收者去查找公钥

这样一次通信完成了两个内容

<span style="color: rgb(255, 32, 32);">防止否认消息</span>：你发送消息给我了 因为我可以使用你的公钥验证

<span style="color: rgb(255, 32, 32);">防止篡改</span>：使用公钥验证，说明只有你的私钥可以加密，我没有任何能力修改甚至伪造

# <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FZX54WUGS%22%2C%22pageLabel%22%3A%22122%22%2C%22position%22%3A%7B%22pageIndex%22%3A2%2C%22rects%22%3A%5B%5B325.44066048%2C501.04055999999997%2C487.5589528939999%2C510.32856%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22122%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/ZX54WUGS?page=3">“Encryption and Decryption Methods”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22122%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/AU794KG9">Rivest 等, 1978, p. 122</a></span>)</span>

上面只是基于DH的公钥密码体系 说明了什么是公钥密码，公钥密码可以做到什么，如何进行；下面开始对RSA算法进行具体的说明

下面开始RSA算法过程（忽略参数的产生）

1.  M使用一个0\~n-1的整数表示，超过n就分块
2.  初始化程序产生 公钥(e,n)，公开
3.  计算C = M^e mod n ，这里C就是密文 发送
4.  计算D = C^d mod n，这里D就是明文

这里就是一个RSA的通信过程

1.  没有对消息增加任何的附加体积——保证加密后还是原始大小
2.  加密密钥就是一个正整数对（e,n)；解密密钥就是一个正整数对（d,n)

下面开始更加具体说明一下内容：

1.  n = pq ，其中pq是随机产生的并且是很大的素数，然后可以公开n了，【pq需要保证私密】
2.  开始采样d ，基于pq开始计算d，选取随机大整数，要求和(p-1)(q-1)互素 即  $gcd(d,(p-1)(q-1))=1$
3.  开始计算e，基于pq和d，要求e是在模(p-1)(q-1)下与d的乘法逆元，即 $e*d = 1 \mod ((p-1)(q-1))$
4.  最后公开(e,n)作为公钥，(d,n)作为私钥

下面阐述 <span style="color: rgb(255, 32, 32);">数学证明加密和解密的合法性</span>

也就是通过数学推导，让M可以被加密为C 再次复原为M

欧拉定理：$M^{φ(n)} \equiv 1 (\mod n)$，<span style="color: rgb(255, 32, 32);">M和n互素</span>

通过欧拉函数的性质可以知道

$$
φ(n) = φ(pq)=φ(p)φ(q) = (p-1)(q-1)=n-(p+q)-1
$$

通过上面数学基础开始证明<span style="color: rgb(255, 32, 32);">（当前假设M和n互素）</span>

$$
D(E(M))= E(D(M)) =M^{ed} (\mod n)
$$

首先我们说过 ed是和(p-1)(q-1)互素 所以可以用欧拉表示

$$
M^{ed} \equiv M^{kφ(n)+1}(\mod n)
$$

我们之前知道 M和n互素，那也和p互素（p是n的因子）

所以利用<span style="color: rgb(255, 32, 32);">费马小定理</span>得到

$$
M^{p-1} \equiv 1(\mod n)
$$

 同样q也如此

那么就证明完毕了 因为：

$$
M^{ed} \equiv M^{kφ(n)+1}(\mod n) \equiv M^{kφ(n)}M(\mod n)
$$

φ(n)化简为p-1q-1化简为1 至此证明完毕

$$
M^{ed}  \equiv M(\mod n)
$$

从而实现数学上的加密解密证明

# <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FZX54WUGS%22%2C%22pageLabel%22%3A%22123%22%2C%22position%22%3A%7B%22pageIndex%22%3A3%2C%22rects%22%3A%5B%5B339.1198824%2C488.08056%2C387.1943196239999%2C497.36856%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22123%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/ZX54WUGS?page=4">“Algorithms”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22123%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/AU794KG9">Rivest 等, 1978, p. 123</a></span>)</span>

这里进入了具体实现

## <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FZX54WUGS%22%2C%22pageLabel%22%3A%22123%22%2C%22position%22%3A%7B%22pageIndex%22%3A3%2C%22rects%22%3A%5B%5B332.15991768000004%2C434.56056%2C509.49636216%2C443.84856%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22123%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/ZX54WUGS?page=4">“How to Encrypt and Decrypt Efficiently”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22123%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/AU794KG9">Rivest 等, 1978, p. 123</a></span>)</span>

如何计算的速度非常快呢？

我们得到了e和M并且M是二进制流

1.  把e展开为二进制流

2.  设定一个变量 C 为 1

3.  使用下面的ab子程序对e的所有字节进行操作 最高位到最低位

    1.  首先计算C^2被n分解的余数 并且重载给C  $C = C^2 \mod n$
    2.  如果当下处理的字节=1 那么设定C 作为C\*M被n分解后的余数  $C = C*M \mod n$

4.  现在所有的C就是M的加密后的内容

上面的算法其实就是通过多次<span style="color: rgb(255, 32, 32);">平方乘</span>执行

## <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FZX54WUGS%22%2C%22pageLabel%22%3A%22123%22%2C%22position%22%3A%7B%22pageIndex%22%3A3%2C%22rects%22%3A%5B%5B332.88038279999995%2C81.04056%2C489.986937888%2C90.32856%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22123%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/ZX54WUGS?page=4">“How to Find Large Prime Numbers”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22123%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/AU794KG9">Rivest 等, 1978, p. 123</a></span>)</span>

我们了解了整个计算过程 但是最开始的pq的产生如何快速并且高效的进行？

首先我们确定 大素数有多大，作者认为 100位的p、q产生200位的n可以保证安全性

主要是用随机产生的 100位十进制数的素性，<span style="color: rgb(255, 32, 32);">Solovay–Strassen 素性检验</span> 还有<span style="color: rgb(255, 32, 32);">雅可比符号</span> 这里我先跳过

## <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FZX54WUGS%22%2C%22pageLabel%22%3A%22124%22%2C%22position%22%3A%7B%22pageIndex%22%3A4%2C%22rects%22%3A%5B%5B331.44030979999997%2C707.88888%2C407.53918109999995%2C716.31288%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22124%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/ZX54WUGS?page=5">“How to Choose d”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22124%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/AU794KG9">Rivest 等, 1978, p. 124</a></span>)</span>

依赖于φ(n)，很容易选择出现

## <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FZX54WUGS%22%2C%22pageLabel%22%3A%22124%22%2C%22position%22%3A%7B%22pageIndex%22%3A4%2C%22rects%22%3A%5B%5B332.39957332%2C625.56888%2C490.34752092400004%2C633.99288%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22124%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/ZX54WUGS?page=5">“H o w to Compute e from d and ,p(n)”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22124%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/AU794KG9">Rivest 等, 1978, p. 124</a></span>)</span>

e和d在φ(n)下互为乘法逆元

只要先使用欧几里得除法，得到 φ(n)和d的最大公因数

并且计算过程中使用广义欧几里得除法 得到 uφ(n)+vd=1

这样mod φ(n）即可计算出e

![\<img alt="" width="1169" height="335" data-attachment-key="LCXY37G2" src="attachments/LCXY37G2.png" ztype="zimage"> | 1169](https://raw.githubusercontent.com/Xioaruan912/pic/main/20261012112322955.png)

# <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FZX54WUGS%22%2C%22pageLabel%22%3A%22125%22%2C%22position%22%3A%7B%22pageIndex%22%3A5%2C%22rects%22%3A%5B%5B77.28%2C748.29264%2C243.8632128%2C757.36464%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22125%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/ZX54WUGS?page=6">“Security of the Method: Cryptanalytic”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22125%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/AU794KG9">Rivest 等, 1978, p. 125</a></span>)</span>

开始进行数学的分析安全性

首先说明 如何证明一个算法是安全的？——只要可以抵抗密码学分析者的协同攻击，那么我们就认为这个方案是安全的（暂时的）

首先进行第一个方面：<span style="color: rgb(255, 32, 32);">解决n=pq的数学难题</span>

这个内容经过300年数学家的验证，是非常困难的；没有算法可以在多项式时间内计算出结果

下面进行第二个方面：<span style="color: rgb(255, 32, 32);">通过公钥破解私钥</span>

<span style="color: rgb(255, 119, 0);">分解n</span>，虽然存在一些高效的算法，但是依旧很困难，使用当时最优算法破解200位的n依旧需要3.8 \* 10^9年

<span style="color: rgb(255, 119, 0);">从n中计算φ(n) </span>如果一个密码分析师 可以计算出 欧拉n，那么就可以通过计算出d 从而破解算法，但是依旧困难

<span style="color: rgb(255, 119, 0);">找到d‘去代替d </span>如果一个加密方案无法防止伪造密钥，更不可能是安全的

# <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FZX54WUGS%22%2C%22pageLabel%22%3A%22126%22%2C%22position%22%3A%7B%22pageIndex%22%3A6%2C%22rects%22%3A%5B%5B73.92%2C463.30848000000003%2C296.4523759999999%2C472.81248000000005%5D%2C%5B57.36%2C451.54848%2C93.05042400000002%2C461.05248%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22126%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/ZX54WUGS?page=7">“Avoiding "Reblocking" when Encrypting a Signed Message”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FAU794KG9%22%5D%2C%22locator%22%3A%22126%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/AU794KG9">Rivest 等, 1978, p. 126</a></span>)</span>

上面提到 对于M 我们限制长度200位，如果超过了就需要分块，但是对于 基于RSA签名算法的RSA加密，如果分块传输太过于麻烦，作者提出两个方法

一、每个用户都保留两个对外公开的 公钥对 一个是用于加密的 一个用于签名

但是是有限制的 加密算法的n大于签名算法的n，这样就可以保证加密签名消息不用分块

二、<span style="color: rgb(255, 32, 32);">cycle walking（循环行走）</span>只用保留一个 公钥对 n基于h和2h之间，那么所有的M要求加密到小于n，才允许——也就是不停加密，直到小于n

到此为止 RSA的基础论文归纳完毕

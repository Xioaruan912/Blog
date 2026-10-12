# ELGAMAL算法

作者开始说明了 本篇论文基于离散对数难题的——和DH密钥分发是一样的 说明这个数学底层<span style="color: rgb(255, 32, 32);">不是</span>一个单向门限函数

这里其实是基于DH的密钥分发系统扩展的新的基于有限域的离散对数难题的新的数字签名算法

# <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FBA6CPWW5%22%2C%22pageLabel%22%3A%22469%22%2C%22position%22%3A%7B%22pageIndex%22%3A0%2C%22rects%22%3A%5B%5B128.88%2C275.87039999999996%2C238.25457489%2C287.93399999999997%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22469%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/BA6CPWW5?page=1">“THE PUBLIC KEY SYSTEM”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22469%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/JSBH933Q">Elgamal, 1985, p. 469</a></span>)</span>

和RSA一样 作者刚刚开始先介绍了 公钥体系还有DH的密钥分发

AB需要协商一个密钥K 基于A和B自己的私钥

我们设定 p是一个大素数，a是modp下的原根，那么DH密钥分发基于下面的数学计算 实现协商密钥

$$
K_{AB} \equiv a^{X_AX_B} \mod p
$$

那么 这里可以发现都是使用私钥得到的，这不现实 所以我们定义公钥为：

$$
Y_A \equiv a^{X_A} \mod p
$$

对于B也是同理的 那么K就可以基于对方的公钥和自己的私钥进行协商了：

$$
K_{AB} \equiv Y_{A}^{X_B} \mod p
$$

对于B也是同理可以生成密钥

攻击者无法高效计算出K 因为当前不存在高效的解决离散对数难题的算法

<span style="color: rgb(255, 32, 32);">只要你的系统是基于离散对数的 都要求P是一个大素数</span>

## 基于离散对数的隐私保护方案

A需要给B发送一个消息M，M转为二进制在 0\~p-1之间

1.  A选择一个0\~p-1之间唯一的数字k，设定k为A的随机私钥
2.  基于Y\_B 计算出协商密钥 K\_AB
3.  生成(A的临时公钥，密文）密文对发送给用户B
4.  用户B基于A的临时公钥 和自己的私钥 得到K
5.  从而反向计算出M

从而可以基于离散对数实现隐私保护，下面是具体算法

这里是计算通信密钥：$K \equiv y_{b}^{k} \mod p$ (k就是A的临时私钥）

下面计算两个秘密信息c1 c2

$$
c_1 \equiv a^k \mod p
$$

$$
c_2 \equiv Km \mod p
$$

最后组合成密文对(c\_1,c\_2)发送

可以发现 使用这个方法<span style="color: rgb(255, 32, 32);">传输的密文是明文的两倍<br></span>这里还有一个保证安全的前提：<span style="background-color: rgba(255, 102, 102, 0.5);">k不允许多次使用</span>

如果k被多次使用 通过简单数学运算即可恢复（下面的K是基于一个k产生的）

$$
c_1 \equiv Km_1 \mod p
$$

$$
c_2 \equiv Km_2 \mod p
$$

我们只需要进行除法即可

$$
c_2/c_1 \equiv m_2/m_1
$$

 如果我们已经知道了 m1 那么就可以非常快速的得到m2

# <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FBA6CPWW5%22%2C%22pageLabel%22%3A%22470%22%2C%22position%22%3A%7B%22pageIndex%22%3A1%2C%22rects%22%3A%5B%5B116.88012860000002%2C653.1504%2C244.10889498600014%2C665.2139999999999%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22470%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/BA6CPWW5?page=2">“A DIGITALSIGNATURESCHEME”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22470%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/JSBH933Q">Elgamal, 1985, p. 470</a></span>)</span>

这里是 Elgamal的比较核心的内容 也就是提出了一个新的 数字签名方案

m是一个需要被签名的文件 大小为0\~p-1

并且公钥依旧是通过 DH的原始生成算法实现的 ELgamal提出的算法如下：

$$
a^m \equiv y^rr^s \mod p
$$

这个是整个签名核心的算法，并且对外公开(r,s)

任何人都可以使用这个算法 还有发布者公布的 (r,s)验证签名的合法性

### <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FBA6CPWW5%22%2C%22pageLabel%22%3A%22470%22%2C%22position%22%3A%7B%22pageIndex%22%3A1%2C%22rects%22%3A%5B%5B60.48036444%2C433.75392%2C151.9746710640001%2C444.74519999999995%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22470%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/BA6CPWW5?page=2">“The Signing Procedure”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22470%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/JSBH933Q">Elgamal, 1985, p. 470</a></span>)</span>

首先进入签名算法，主要是三个步骤组成的

1.  随机选择 临时私钥k，并且k要和p-1互素
2.  计算 $r \equiv a^k \mod p$  得到 参数r
3.  那么验证程序就可以改写为 $a^m \equiv a^{xr}a^{ks} \mod p$
4.  因为a 是生成元，所以指数按照群的阶 p-1  来比较
5.  计算 $s \equiv xr + ks \mod (p-1)$  得到参数s（<span style="color: rgb(255, 32, 32);">只要k和p-1互素那么这个同余式就有解</span>）

这样就生成了 r和s，可以发送出去作为 验证密钥

### <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FBA6CPWW5%22%2C%22pageLabel%22%3A%22470%22%2C%22position%22%3A%7B%22pageIndex%22%3A1%2C%22rects%22%3A%5B%5B59.5203534%2C230.47392%2C168.0550686540001%2C241.4652%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22470%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/BA6CPWW5?page=2">“The Verification Procedure”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22470%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/JSBH933Q">Elgamal, 1985, p. 470</a></span>)</span>

验证方得到的是 m, r, s那么可以通过上面的验证算法很简单的计算 等式是否相等

到此 整个签名和验证算法全部结束

# <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FBA6CPWW5%22%2C%22pageLabel%22%3A%22470%22%2C%22position%22%3A%7B%22pageIndex%22%3A1%2C%22rects%22%3A%5B%5B90.48%2C104.5104%2C266.26659319199996%2C116.57400000000001%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22470%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/BA6CPWW5?page=2">“SOME ATTACKS ON THE SIGNATURE SCHEME”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22470%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/JSBH933Q">Elgamal, 1985, p. 470</a></span>)</span>

这里作者开始讨论了一些针对本签名算法的攻击 主要是分为两类，通过公开信息恢复私钥的 还有就是通过伪造签名的

## <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FBA6CPWW5%22%2C%22pageLabel%22%3A%22470%22%2C%22position%22%3A%7B%22pageIndex%22%3A1%2C%22rects%22%3A%5B%5B320.64034236%2C602.9539199999999%2C440.42195894400004%2C613.9452%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22470%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/BA6CPWW5?page=2">“Attacks Aiming to Recover x”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22470%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/JSBH933Q">Elgamal, 1985, p. 470</a></span>)</span>

这里讨论的 是 通过公开的m r s 直接攻击k尝试恢复私钥，从而破解签名算法

但是这里遇见的问题是，即使给你多个明文密文对，你无法通过等式构建出 k的关系，也就是即使你列出一个同余方程组，但是他们之间的k是不存在关系的，也就无法联立 从而计算

并且这里的攻击其实等价于直接攻击离散对数，我们之前说了 当下没有一个良好的算法可以高效的攻击离散对数问题，所以这里依旧无法实现

## <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FBA6CPWW5%22%2C%22pageLabel%22%3A%22470%22%2C%22position%22%3A%7B%22pageIndex%22%3A1%2C%22rects%22%3A%5B%5B319.92033132%2C269.35392%2C445.90946155200004%2C280.3452%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22470%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/BA6CPWW5?page=2">“Attacks for Forging Signatures”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22470%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/JSBH933Q">Elgamal, 1985, p. 470</a></span>)</span>

这里的攻击就是通过构造自己的r和s 从而满足之前的验证方程

即使你r被随机选择的j所固定，你要计算出s还是要解决离散对数问题

所以虽然 计算难度不如离散对数，但是依旧不存在多项式时间内可以攻击实现的

# <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FBA6CPWW5%22%2C%22pageLabel%22%3A%22471%22%2C%22position%22%3A%7B%22pageIndex%22%3A2%2C%22rects%22%3A%5B%5B82.32%2C276.5904%2C283.1649400859999%2C288.654%5D%2C%5B94.08038661%2C265.03392%2C247.87897075200004%2C276.0252%5D%2C%5B127.20107127%2C252.79391999999999%2C221.94937867199994%2C263.7852%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22471%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/BA6CPWW5?page=3">“PROPERTIESOF OUR SYSTEMAND COMPARISON TO OTHER SIGNATURESCHEMESAND PUBLIC KEY SYSTEMS”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22471%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/JSBH933Q">Elgamal, 1985, p. 471</a></span>)</span>

这里与前面出现的RSA进行了一些比较

说明了我们的数据规模 必须要和RSA一样大才能保证安全(RSA的n是200位十进制）

下面阐述的是本论文提出的 密码方案和签名算法方案 新的特性

## <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FBA6CPWW5%22%2C%22pageLabel%22%3A%22471%22%2C%22position%22%3A%7B%22pageIndex%22%3A2%2C%22rects%22%3A%5B%5B321.8403534%2C680.5104%2C471.14825768400004%2C693.1452%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22471%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/BA6CPWW5?page=3">“Properties of the Public Key System”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22471%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/JSBH933Q">Elgamal, 1985, p. 471</a></span>)</span>

添加了随机私钥k 即使相同的密文，都会产生不同的密文对，p的要求和RSA中p的要求一样，但是会产生2倍的密文

## <span class="highlight" data-annotation="%7B%22attachmentURI%22%3A%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FBA6CPWW5%22%2C%22pageLabel%22%3A%22471%22%2C%22position%22%3A%7B%22pageIndex%22%3A2%2C%22rects%22%3A%5B%5B320.40030921%2C349.99392%2C467.19047351400013%2C360.98519999999996%5D%5D%7D%2C%22citationItem%22%3A%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22471%22%7D%7D" ztype="zhighlight"><a href="zotero://open/library/items/BA6CPWW5?page=3">“Properties of the Signature Scheme”</a></span> <span class="citation" data-citation="%7B%22citationItems%22%3A%5B%7B%22uris%22%3A%5B%22http%3A%2F%2Fzotero.org%2Fusers%2F20501408%2Fitems%2FJSBH933Q%22%5D%2C%22locator%22%3A%22471%22%7D%5D%2C%22properties%22%3A%7B%7D%7D" ztype="zcitation">(<span class="citation-item"><a href="zotero://select/library/items/JSBH933Q">Elgamal, 1985, p. 471</a></span>)</span>

需要的参数和RSA差不多，但是签名需要文件的2倍大小

因为映射集合大小不同的存在，任何一个文件可以有很多的签名，但是一个签名只可以倍映射在一个文件中

到此ELGAMAL算法结束

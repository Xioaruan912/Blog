# [ASIS 2019]Unicorn shop unicode编码问题

这一道题很新奇 没有想到

首先还是信息收集

输入大于两个字符就会报错



<img src="https://i-blog.csdnimg.cn/blog_migrate/3d3c27827af1c8ae0a818c7f8d6bd4af.png" alt="" style="max-height:170px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/f8dfe0df1a2a33ff0b0ad2685a7f194a.png" alt="" style="max-height:188px; box-sizing:content-box;" />


存在4个类型 这里注意只有第四个的价格是大于两位数 这里就出现矛盾了

既然他的价格为4位 那我只能输入一位 这些也是后话 现在都没有想到这种东西



<img src="https://i-blog.csdnimg.cn/blog_migrate/2cba4490cabe8620d3db3e7534b7c565.png" alt="" style="max-height:194px; box-sizing:content-box;" />


源代码中存在这个（我一直以为这个有点用。。。。）

dirsearch扫没有发现东西

那我们就开始着重查看这如何购买id=4 的吧



<img src="https://i-blog.csdnimg.cn/blog_migrate/a2d93fd9f2996f5ec055e95c90e86521.png" alt="" style="max-height:49px; box-sizing:content-box;" />


很像unicode

所以这里的考点就出来了

## unicode的编码安全问题

 [浅谈Unicode设计的安全性 - 先知社区](https://xz.aliyun.com/t/5402#toc-0) 

主要就是 我们可以得到一个字符 但是比1000还大 是因为编码的问题

 [Unicode - Compart](https://www.compart.com/en/unicode/) 

直接搜ten thousand



<img src="https://i-blog.csdnimg.cn/blog_migrate/364795580a9ef6e5675a38305a716e40.png" alt="" style="max-height:502px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/7e556ad3d6576f5e97dd2bf677f18db2.png" alt="" style="max-height:169px; box-sizing:content-box;" />
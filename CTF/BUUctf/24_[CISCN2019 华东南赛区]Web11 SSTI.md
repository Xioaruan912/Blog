# [CISCN2019 华东南赛区]Web11 SSTI

这道SSTI差点给我渗透的感觉了 全是API 我还想去访问API看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/c9a6e0926b0eb0daf4d29e764b329b0c.png" alt="" style="max-height:829px; box-sizing:content-box;" />


发现这里读取了我们的ip

我们抓包看看是如何做到的



<img src="https://i-blog.csdnimg.cn/blog_migrate/7d2f03cfc29c40653f8095b3f1e830c9.png" alt="" style="max-height:452px; box-sizing:content-box;" />


没有东西 我们看看还有什么提示



<img src="https://i-blog.csdnimg.cn/blog_migrate/5ff0260ce44212dfdf53065e893e1628.png" alt="" style="max-height:336px; box-sizing:content-box;" />


欸  那我们可不可以直接修改参数呢

我们传递看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/a98b0696188acc0ef163edb982665085.png" alt="" style="max-height:350px; box-sizing:content-box;" />


发现成功了 是受控的 这里我就开始没有思路了

于是看了wp 说是ssti

那我们看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/e639ce8ec2b92c59f6bb7d7efa127a6f.png" alt="" style="max-height:414px; box-sizing:content-box;" />


确实是 好吧

我们直接开测

{{system('cat /f*')}}



<img src="https://i-blog.csdnimg.cn/blog_migrate/e036eab43bbf91e2cdf8a6002a8d4ffa.png" alt="" style="max-height:348px; box-sizing:content-box;" />


还是很简单的
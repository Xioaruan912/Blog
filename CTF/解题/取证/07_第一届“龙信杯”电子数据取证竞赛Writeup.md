# 第一届“龙信杯”电子数据取证竞赛Writeup

**目录**

[TOC]











检材密码

RLEQc2Xe65Q5GiCuRNMFrw==

## 移动终端取证

### 请分析涉案手机的设备标识是_______。（标准格式：12345678）

晕了不知道为什么龙信的软件取证取了巨久  85069625

直接梭哈就行了



<img src="https://i-blog.csdnimg.cn/blog_migrate/39299d304de00f004bfdebb607efe640.png" alt="" style="max-height:320px; box-sizing:content-box;" />


### 请确认嫌疑人首次安装目标APP的安装时间是______。（标准格式：2023-09-13.11:32:23）

这里我原本以为是安装 蝙蝠 结果是后面这个螺聊的

2022-11-16 19:11:26



<img src="https://i-blog.csdnimg.cn/blog_migrate/0799dd4c8585173fa8b9fc4381a347ed.png" alt="" style="max-height:99px; box-sizing:content-box;" />


### 此检材共连接过______个WiFi。（标准格式：1）

6

### 

### 嫌疑人手机短信记录中未读的短信共有______条。（标准格式：12）

这里龙信看不了 去老大哥那边看

17



<img src="https://i-blog.csdnimg.cn/blog_migrate/4bebfef96f35028550630f14778e83ab.png" alt="" style="max-height:517px; box-sizing:content-box;" />


看to神 去翻了数据库

我也来学一下 去看看数据库

userdata\data\com.android.providers.telephony\databases



<img src="https://i-blog.csdnimg.cn/blog_migrate/6565fcec7c1b593e87f3b3de83063346.png" alt="" style="max-height:474px; box-sizing:content-box;" />


### 嫌疑人检材手机在浏览器中下载海报背景图的网址是_______。（标准格式：http://www.baidu.com/admin/index.html）



<img src="https://i-blog.csdnimg.cn/blog_migrate/945b4666863f8f5c5b9bedaccf31035b.png" alt="" style="max-height:297px; box-sizing:content-box;" />


[电影中的车钥匙海报设计集 - 资源狐网站](http://m.ziyuanhu.com/pics/1725.html) 

### 请分析涉案海报的推广ID是________。（标准格式：123456）

去看短信

114092



<img src="https://i-blog.csdnimg.cn/blog_migrate/f105012841b7bca198622077801cb48a.png" alt="" style="max-height:279px; box-sizing:content-box;" />


### 嫌疑人通过短信群发去推广APP，请问收件人中有__个号码是无效的。（标准格式：12）

去看短信

1



<img src="https://i-blog.csdnimg.cn/blog_migrate/6256709fc1e94b7dfe7f5648302e594a.png" alt="" style="max-height:263px; box-sizing:content-box;" />


### 通过分析，嫌疑人推送的微信账号是______。（标准格式：Lx20230916）

晕了 没看到下面

Gq20221101



<img src="https://i-blog.csdnimg.cn/blog_migrate/e11ddd44e3e169f60408aadea58f755d.png" alt="" style="max-height:277px; box-sizing:content-box;" />


### 请校验嫌疑人使用的“变声器”APK的包名是________。（标准格式：com.baidu.com）

com.chuci.voice

### 号商的联系人注册APP的ID是_________。（标准格式：12345678）

36991915



<img src="https://i-blog.csdnimg.cn/blog_migrate/901db288ac1da599330e4a1e519c5142.png" alt="" style="max-height:201px; box-sizing:content-box;" />


### 嫌疑人于2022年11月份在_______城市。（标准格式：成都）

太相信 聊天记录 我们直接去看图片ip

江苏



<img src="https://i-blog.csdnimg.cn/blog_migrate/f3ac2351ef4ef616dfb74884aeb74df2.png" alt="" style="max-height:263px; box-sizing:content-box;" />


### 嫌疑人共购买_______个QQ号。（标准格式：1）

8



<img src="https://i-blog.csdnimg.cn/blog_migrate/b6e11b4dfe03cfb6fca213d2dd891fc2.png" alt="" style="max-height:257px; box-sizing:content-box;" />


## 

## 

## 

## 

## APK取证

### 分析手机镜像，导出涉案apk，此apk的md5值是________。（标准格式：abc123）

找了半天 直接解压img 然后找就可以

d56e1574c1e48375256510c58c2e92e5



<img src="https://i-blog.csdnimg.cn/blog_migrate/9ccc15eae5baf121b54cf260cd826a7e.png" alt="" style="max-height:170px; box-sizing:content-box;" />


### 分析该apk，apk的包名是________。（标准格式：com.qqj.123）

lx.tiantian.com

### 分析该apk，app的内部版本号是__________。（标准格式：1.1）



<img src="https://i-blog.csdnimg.cn/blog_migrate/6eb2f5a931c47109cd522e0798c27d95.png" alt="" style="max-height:329px; box-sizing:content-box;" />


### 分析该apk，请问该apk最高支持运行的安卓版本是_______。（标准格式：11）

12

这题我确实没想到 没做过



<img src="https://i-blog.csdnimg.cn/blog_migrate/d4789fcc2c9aa4c9f4af7a6285bc7cc7.png" alt="" style="max-height:134px; box-sizing:content-box;" />


```vbnet
android:targetSdkVersion="32
```

这个是 这个软件版本 稳定运行的版本

我们需要转换为 安卓版本



<img src="https://i-blog.csdnimg.cn/blog_migrate/02b991d16a439b219ee7c4a7b7f32dbd.png" alt="" style="max-height:185px; box-sizing:content-box;" />


### 分析该apk，app的主函数入口是_________。（标准格式：com.qqj.123.MainActivity）

lx.tiantian.com.activity.MainActivity



<img src="https://i-blog.csdnimg.cn/blog_migrate/f6f006f7e2ddc1f77cb54f46d66ef94d.png" alt="" style="max-height:186px; box-sizing:content-box;" />


### 分析该apk，请问窃取短信的权限名称是________。（标准格式：android.permission.NETWORK）

出来是错的 不知道为什么

android.permission.READ_SMS



<img src="https://i-blog.csdnimg.cn/blog_migrate/5031f120f4bea415a225f656d72e86ad.png" alt="" style="max-height:177px; box-sizing:content-box;" />


### APP使用的OPPO的appkey值是________。（标准格式：AB-12345678）

```
OP-264m10v633PC8ws8cwOOc4c0w
```



### 分析apk源码，该APK后台地址是________。（标准格式：com.qqj.123）

```
app.goyasha.com
```

### 

### 分析apk源码，APP 后台地址登录的盐值是_______。（标准格式：123abc=%$&）

```
73g=s%!lvi8h=i7a4ge*o3s@h2n^5_yk=-y#@p6)feidfjol8@
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1fee6bd0d084c08e2dbdf4bffaa2b697.png" alt="" style="max-height:476px; box-sizing:content-box;" />


### 分析apk源码，该APK后台地址登录密码是______。（标准格式：longxin123）

```
lxtiantiancom
```

### 

### 对 APP 安装包进行分析，该 APP打包平台调证值是______。（标准格式：HER45678）

这里是通过题目提示判断的 因为没有发现 打包平台  
H5D9D11EA



<img src="https://i-blog.csdnimg.cn/blog_migrate/e1810e15bb34eee84168bc5b15a173f7.png" alt="" style="max-height:121px; box-sizing:content-box;" />


### 此apk抓包获取到的可访问网站域名IP地址是_______。（标准格式：192.168.1.1）

```
192.168.5.80
```

### 

### 分析apk源码，该apk的加密方式key值是________。（标准格式：12345678）

```
ade4b1f8a9e6b666
```

### 

### 结合计算机镜像，综合分析，请问该apk开发者公司的座机号码是__。（标准格式：4001122334）

结合后面做吧











## 介质取证

### 对PC镜像分析，请确定涉案电脑的开机密码是_______。（标准格式：123456）

Longxin360004



<img src="https://i-blog.csdnimg.cn/blog_migrate/b7bbb18338e7c341b2a1e05f2e53945a.png" alt="" style="max-height:291px; box-sizing:content-box;" />


这里出现了 提示 然后我们火眼取证一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/233022678bede67ff5a2a7d68b689251.png" alt="" style="max-height:315px; box-sizing:content-box;" />


发现bitlocker

我们用取证大师取秘钥

380633-655996-366696-540353-708532-680647-516516-119647



<img src="https://i-blog.csdnimg.cn/blog_migrate/4481f313e196cbb379b3b728f08ba1ae.png" alt="" style="max-height:580px; box-sizing:content-box;" />


然后取证就可以了



<img src="https://i-blog.csdnimg.cn/blog_migrate/02e2ca6851ce8691ea9e77fe89d6b725.png" alt="" style="max-height:457px; box-sizing:content-box;" />


发现工号

### 涉案计算机最后一次正常关机时间_______。（标准格式：2023-1-11.11:11:11）

2023-09-16 18:20:34



<img src="https://i-blog.csdnimg.cn/blog_migrate/f342d51e5a4421ec9165844d542b860c.png" alt="" style="max-height:213px; box-sizing:content-box;" />


### 对PC镜像分析，请确认微信是否是开机自启动程序。（标准格式：是/否）

是



<img src="https://i-blog.csdnimg.cn/blog_migrate/da2a292861ef9a52a316fec7f79d85ff.png" alt="" style="max-height:512px; box-sizing:content-box;" />


### 检材硬盘中有一个加密分区，给出其中“我的秘密.jpg”文档的解密内容。（标准格式：Longxin0924）

搜一下

TWltaTEyMzQ=

Mimi1234

<img src="https://i-blog.csdnimg.cn/blog_migrate/eabc505e44bb18cfa10dc7c1e1b8b42f.png" alt="" style="max-height:476px; box-sizing:content-box;" />


### 接上题，请问该嫌疑人10月份工资是_______元。（标准格式：123）

19821

通过

Mimi1234

解压 文件.zip 里面才是真正的工资条



<img src="https://i-blog.csdnimg.cn/blog_migrate/8a40d79e4f899a986b6889a7744582c2.png" alt="" style="max-height:174px; box-sizing:content-box;" />


### 对PC镜像进行分析，浏览器中使用过QQ邮箱，请问该邮箱的密码是______。（标准格式：Longxin0924）

Longxin@2023

这里又被坑了 火眼取证 不会存在

但是龙信又可以。。。 工具太多了。。。。



<img src="https://i-blog.csdnimg.cn/blog_migrate/e40bf09297fd4735b5b6d3e5decd6f9a.png" alt="" style="max-height:359px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/5d8cbd5557f31f7dc6b77280b7bc47f2.png" alt="" style="max-height:225px; box-sizing:content-box;" />


### 结合手机镜像分析，得出一个推广ID，请在此检材找到此海报，请写出路径。（标准格式：D:\X\X\1.txt）

```
C:\Program Files (x86)\Tencent\WeChat\2.png
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d22388f4d957cabe312bd5cb109215f4.png" alt="" style="max-height:185px; box-sizing:content-box;" />


跟进看看

### 请找出嫌疑人的2022年收入共_______。（标准格式：123）

205673

谁能想到 是把海报当密钥文件。。。。。。

通过提取出来 然后用海报当做 truecrypt秘钥文件

然后火眼取证磁盘 就可以取证到删除文件的内容





<img src="https://i-blog.csdnimg.cn/blog_migrate/a88bd66182f42b3c3d12dbedf7fde9f6.png" alt="" style="max-height:442px; box-sizing:content-box;" />


### 分析此海报，请找到嫌疑人的银行卡号。（标准格式：62225123456321654）

6320005020052013476

提示分析海报了 我们放入 010看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/6802239473810d8681c6727518f53a40.png" alt="" style="max-height:259px; box-sizing:content-box;" />


发现了 银行卡









## 虚拟币分析

### 分析涉案计算机，正确填写中转地址当前的代币种类______。（标准格式：BNB）

ETHEREUM



<img src="https://i-blog.csdnimg.cn/blog_migrate/68834910dd2b403a14b1fcada805419f.png" alt="" style="max-height:410px; box-sizing:content-box;" />


解压 111 获得 然后我们火眼加载 nox



<img src="https://i-blog.csdnimg.cn/blog_migrate/78e8c69de3cd75deef57fb52f1cbf97b.png" alt="" style="max-height:283px; box-sizing:content-box;" />


### 分析涉案计算机，正确填写中转地址当前的代币余额数量_______。（标准格式：1.23）

4.4981

确实没有想到 npbk 我们使用夜神模拟器导入   作为备份文件 其实上网搜一下 npbk即可

打开是 0  但是不是 我们需要断开网络进入



<img src="https://i-blog.csdnimg.cn/blog_migrate/7f7dac496e66cdbe6ab8a85649e4ec08.png" alt="" style="max-height:218px; box-sizing:content-box;" />




### 根据中转地址转账记录找出买币方地址。买币方地址：_____（标准格式：0x123ABC)

0x63AA203086938f82380A6A3521cCBf9c56d111eA

从案件详情里可以看见 是先转入0.5到买方

### 



<img src="https://i-blog.csdnimg.cn/blog_migrate/0a14f9aaa9c851626f10d5ce83cf7e46.png" alt="" style="max-height:645px; box-sizing:content-box;" />


### 根据中转地址转账记录统计买方地址转账金额。转账金额：____ ETH.（标准格式:12.3）

150.5

看题目 那就是依据里面的内容了



<img src="https://i-blog.csdnimg.cn/blog_migrate/d70177ea89b280600c6ef708e99ff19f.png" alt="" style="max-height:411px; box-sizing:content-box;" />


### 在创建钱包时，应用APP都会建议我们进行助记词备份，方便以后忘记密码后找回钱包，在办案过程中时常会拿到犯罪嫌疑人备份的助记词的情况。请从以下三组助记词中判断出格式正确的一组（ ）

感觉很理论 直接丢给gpt

A



<img src="https://i-blog.csdnimg.cn/blog_migrate/cfc996eb8be3636f0dfa483374e46f08.png" alt="" style="max-height:58px; box-sizing:content-box;" />


### 假设上题中正确的助记词为通过侦察找到的嫌疑人钱包助记词备份（已知地址属于以太坊链），请在模拟器中通过imToken APP恢复嫌疑人钱包，并选出正确钱包地址（ ）

管理钱包 - 创建钱包 - 导入助记词  密码随便

0x63AA203086938f82380A6A3521cCBf9c56d111eA分析“数据包1.cap”，请问客户端为什么访问不了服务器。（ ）











## 流量分析

### 分析“数据包1.cap”，请问客户端为什么访问不了服务器。（ ）

DoS攻击

首先 访问不了服务器 多半就是拒绝服务攻击

```undefined
DDoS 是 僵尸机发送废物请求
 
 
dos 是 多次大量请求 没有相应 实现三次握手
```

我们开始看看

首先

统计->会话 查看一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/d857ab01cea54cbb58200f3dd8973b1d.png" alt="" style="max-height:191px; box-sizing:content-box;" />


发现这个 120.210.129.29 访问异常的高

然后我们查看一下 目的为 10.5.0.19的包

```cobol
ip.dst==10.5.0.19
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/305611008a15deb025bff4d7ec5e64ae.png" alt="" style="max-height:252px; box-sizing:content-box;" />
我们能发现 确实符合 多次ip请求 没有实现握手

### 分析“数据包1.cap”，出问题的服务器IP地址是_______。（格式：127.0.0.1）

10.5.0.19

被攻击的服务器

### 分析“数据包1.cap”，文件下发服务器的IP地址是_______。（标准格式：127.0.0.1）

120.210.129.29

导出 ->http对象列表



<img src="https://i-blog.csdnimg.cn/blog_migrate/8365c74e7c5f52f932d94d7a0331f4a9.png" alt="" style="max-height:162px; box-sizing:content-box;" />


我们在看请求包的时候 就可以看见 下发了 java.log文件

### 分析“数据包1.cap”，攻击者利用_______漏洞进行远程代码执行。（标准格式：小写，无中文）

struts2

我们首先知道了是java.log

我们指定内容为 java.log

```sql
http contains "java.log" 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8dd29d1965628f34e8fe6c3f5d6e7503.png" alt="" style="max-height:428px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/6335a78ed032eade0b398e58ae2fbf00.png" alt="" style="max-height:908px; box-sizing:content-box;" />


### 分析“数据包1.cap”，请提取恶意文件，并校验该文件的MD5值为_______。(标准格式:abcd)

87540c645d003e6eebf1102e6f904197



<img src="https://i-blog.csdnimg.cn/blog_migrate/62a071489d76aa9f2c2f2d641096dbbe.png" alt="" style="max-height:550px; box-sizing:content-box;" />


### 分析“数据包2.cap”，其获取文件的路径是________。（标准格式：D:/X/X/1.txt）

/C:/Users/Administrator/Downloads/新建文件夹/新建文件夹/mail.png



<img src="https://i-blog.csdnimg.cn/blog_migrate/754bbf2c69ba5edd9defa5f4e8d1bcad.png" alt="" style="max-height:310px; box-sizing:content-box;" />




可疑



<img src="https://i-blog.csdnimg.cn/blog_migrate/5326de315aa85dfdab7666952e7947c9.png" alt="" style="max-height:559px; box-sizing:content-box;" />


集合答案格式 就是这个了

### 分析“数据包2.cap”，文件下载服务器的认证账号密码是_______。（标准格式：123）

admin:passwd



<img src="https://i-blog.csdnimg.cn/blog_migrate/7c85c629980e1b62e59bed223c9b39ff.png" alt="" style="max-height:358px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/53d27df165fafd3103d280cd9795cab6.png" alt="" style="max-height:680px; box-sizing:content-box;" />


### 分析“数据包2.cap”，其下载的文件大小有________字节。（标准格式

211625

直接导出 mail.png

然后看属性即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/03925bc1c1cf120f0d57fa3be78f0626.png" alt="" style="max-height:210px; box-sizing:content-box;" />
















## 服务器取证1

### 服务器系统的版本号是_______。（格式：1.1.1111）

7.9.2009



<img src="https://i-blog.csdnimg.cn/blog_migrate/a1dea0738a9ac72840d390c58fecfd0a.png" alt="" style="max-height:324px; box-sizing:content-box;" />


### 网站数据库的版本号是_______。（格式：1.1.1111）

```cobol
5.6.50
```

仿真看看吧



```cobol
 bt 23|bt 24|bt 10|bt 12
```

乱七八糟的限制都关了

然后修改密码 进入看

进去后自定义菜单把那些数据库啥的都拖出来



<img src="https://i-blog.csdnimg.cn/blog_migrate/1f3c8a4d2e25c234b5b4b387ff37c579.png" alt="" style="max-height:415px; box-sizing:content-box;" />


### 宝塔面板的“超时”时间是_______分钟。（格式：50）

120

没看到是分钟。。。。



<img src="https://i-blog.csdnimg.cn/blog_migrate/be04ccb2e967774162db14c4e0dc6c91.png" alt="" style="max-height:221px; box-sizing:content-box;" />


### 网站源码备份压缩文件SHA256值是_______。（格式：64位小写）

0bdeeacf755126dae9efd38f6a6d70323aa95217b629fd389e0e81f9b406be39

不知道为什么计算错的



<img src="https://i-blog.csdnimg.cn/blog_migrate/40dd84846085f272394ae5100ebba0df.png" alt="" style="max-height:272px; box-sizing:content-box;" />


计算一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/b3055226831af7e31d26daca474852e3.png" alt="" style="max-height:109px; box-sizing:content-box;" />


### 分发网站sb.wiiudot.cn管理员密码默认MD5加密盐值是_______。（格式：abcd）

7f5918fe56f4a01d8b206f6a8aee40f2

首先我们先把网站启起来

先修改域名 改为ip地址（虚拟机）



<img src="https://i-blog.csdnimg.cn/blog_migrate/526483add8860c39a88123bf9144ef5c.png" alt="" style="max-height:404px; box-sizing:content-box;" />


然后访问/admin



<img src="https://i-blog.csdnimg.cn/blog_migrate/570c59f4ef1aaab6db6173871524bb63.png" alt="" style="max-height:285px; box-sizing:content-box;" />


我们去把报错信息打开 app/config

'show_error_msg'         => false  改为true

能发现是数据库没有恢复

我们开始恢复数据库

进入 app/database.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/efdb24b3e2d0f7d437de7eb61665fc6d.png" alt="" style="max-height:405px; box-sizing:content-box;" />


然后去数据库页面



<img src="https://i-blog.csdnimg.cn/blog_migrate/197c971e80bef7e0cbb5c4bb0488cae5.png" alt="" style="max-height:235px; box-sizing:content-box;" />


修改为123456

就可以访问了



<img src="https://i-blog.csdnimg.cn/blog_migrate/66172882ac0e9d8f244e813b32ea1d08.png" alt="" style="max-height:387px; box-sizing:content-box;" />


然后随便输入



<img src="https://i-blog.csdnimg.cn/blog_migrate/859e31a9187bf3909628d68d75e618aa.png" alt="" style="max-height:133px; box-sizing:content-box;" />


我们去搜搜看

<img src="https://i-blog.csdnimg.cn/blog_migrate/e276cd78d8893ad5bf59a055082cfe4b.png" alt="" style="max-height:405px; box-sizing:content-box;" />


这里发现 password 处理密码 我们去看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/b85e0e186a139f412c17b9dad901b497.png" alt="" style="max-height:254px; box-sizing:content-box;" />


发现盐值就是这个数的md5

### 分发网站sb.wiiudot.cn一共存放了_______条通讯录数据。（标准格式：1234）

67097

我们直接修改

代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/6d16a6460104bdf53559841656c507b7.png" alt="" style="max-height:127px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/62c7d5efae594b35e3f63a71ddd0b295.png" alt="" style="max-height:475px; box-sizing:content-box;" />


进入admin里看看

去通讯录查看



<img src="https://i-blog.csdnimg.cn/blog_migrate/705ceca4a90c0fba2ce76cbfcf2b7529.png" alt="" style="max-height:81px; box-sizing:content-box;" />


### 全部网站一共有_______名受害人。（格式：xxx。不去重,不进行数据恢复）

506

问的是全部网站

我们看看服务器1有几个



<img src="https://i-blog.csdnimg.cn/blog_migrate/4bd691a1e5ca35add178a68d6f09b8e4.png" alt="" style="max-height:191px; box-sizing:content-box;" />


去看看他们的数据库是什么



<img src="https://i-blog.csdnimg.cn/blog_migrate/4463bb6a45bd65d753ce7b810e79aab7.png" alt="" style="max-height:100px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/a54d9784b0170feaa02d88ba9045a9e3.png" alt="" style="max-height:124px; box-sizing:content-box;" />


然后我们去数据库里看看

在 mobile的表中存在受害人的手机

这里的不去重是三个网站不去重 单个需要去重



<img src="https://i-blog.csdnimg.cn/blog_migrate/931aa52fe5a4cf9d44f7d7c6777a0325.png" alt="" style="max-height:305px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/0799405da7c1084fb0b15b64e3248c38.png" alt="" style="max-height:201px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/c2596cffc0583604f53e0d1cf8bbe21d.png" alt="" style="max-height:232px; box-sizing:content-box;" />


### 分发网站tf.chongwuxiaoyouxi.com里面一共有_______位“组员级别”的管理员。（格式：数字）

26

一样把网站骑起来看

<img src="https://i-blog.csdnimg.cn/blog_migrate/c97832066400a73f5b10c2655e1501d3.png" alt="" style="max-height:493px; box-sizing:content-box;" />


发现无法实现 但是刚刚那个可以 我们复制刚刚那个的规则 因为我们看到现在 这几个都是一个框架



<img src="https://i-blog.csdnimg.cn/blog_migrate/1dfc425d54325a3d7d53a86ac0ee5383.png" alt="" style="max-height:799px; box-sizing:content-box;" />


修改角色为组员

### 分发网站sb.wiiudot.cn管理员名为“0820”的邀请码是_______。（格式：xxx）

443074

这里去数据库看

首先在网站里 我们可以发现 昵称为20



<img src="https://i-blog.csdnimg.cn/blog_migrate/6c90d1dcb862346c1114f1ca1c91848c.png" alt="" style="max-height:201px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/e52e4ddb68381f3c6b879e8bbfdd6fc2.png" alt="" style="max-height:154px; box-sizing:content-box;" />


id是141 然后去 appconfig那个查看



<img src="https://i-blog.csdnimg.cn/blog_migrate/22a224e5aed4a27c65a8e1911d46abb8.png" alt="" style="max-height:327px; box-sizing:content-box;" />


### 分发网站sb.wiiudot.cn本地数据库用户sb_wiiudot_cn的密码是_______。（格式：xxx）

KE5f3xnFHYAnG5Dt

这里我重新启动一台镜像

因为我们已经修改了本地mysql密码

我们如果要尝试 就不可以实现

然后我们需要获取之前的密码



<img src="https://i-blog.csdnimg.cn/blog_migrate/c852d5252c78cc48e0e91bfab919bcae.png" alt="" style="max-height:205px; box-sizing:content-box;" />


发现无法获取 我们又想起来存在一个备份文件 我们解压使用里面的访问成功











## 服务器取证2

### 请分析宝塔面板中默认建站目录是_______。（标准格式：/etc/www）

/home/wwwroot



<img src="https://i-blog.csdnimg.cn/blog_migrate/4b2db0baa3e8c53217092a06d0ab1a75.png" alt="" style="max-height:156px; box-sizing:content-box;" />


没取证出来

```cobol
 bt 23|bt 24|bt 10|bt 12
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2910d3753aa1f5be2cd742ca8f5d1028.png" alt="" style="max-height:118px; box-sizing:content-box;" />


没有给内网

直接贴上ip 和后面的端口目录即可

### 在宝塔数据库目录有一个只含有一个表结构的数据库，请找到该“表结构文件”并分析出第六个字段的字段类型是_______。（标准格式：int(11)）

在www/server/data下 gtc存在一个文件 我们进去看看

```scss
char(128)
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/6ed5004552391db5ba681eba2af167b2.png" alt="" style="max-height:757px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/c42e96204908348d2706c88ef6d788ca.png" alt="" style="max-height:236px; box-sizing:content-box;" />


### 请分析“乐享金融”网站绑定的域名是_______。（标准格式：www.baidu.com） jinrong.goyasha.com

### 

### 请访问“乐享金融”数据库并找到用户表，假设密码为123456，还原uid为2909，用户名为goyasha加密后密码的值是_______。（标准格式：abcdefghijklmnopqrstuvwsyz）

d2174d958131ebd43bf900e616a752e1



<img src="https://i-blog.csdnimg.cn/blog_migrate/e0729cf13a814997ae1edb3bf3b4412d.png" alt="" style="max-height:242px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/6fd2a4747b110e75c181fc1d77bcc6b8.png" alt="" style="max-height:523px; box-sizing:content-box;" />
所以内容就是 1234561635837124

### 请重建“乐享金融”，访问平台前台登陆界面，会员登陆界面顶部LOGO上的几个字是_______。（标准格式：爱金融）

睿文化

无论如何 我们去访问index 看看





<img src="https://i-blog.csdnimg.cn/blog_migrate/ac8b89739c6c9e0d9b58e97b59c878e9.png" alt="" style="max-height:688px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/f013901274331f11422a4bb606c10284.png" alt="" style="max-height:612px; box-sizing:content-box;" />


### 请分析“乐享金融”一共添加了_______个非外汇产品。（标准格式：5）

1



<img src="https://i-blog.csdnimg.cn/blog_migrate/a3c7b08243a6dbb9aed208b4f3a6260d.png" alt="" style="max-height:418px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/59dd059103ce5924daf91ed710e2daa4.png" alt="" style="max-height:333px; box-sizing:content-box;" />


### 请分析“乐享金融”设置充值泰达币的地址是_______。（标准格式：EDFGF97B46234FDADSDF0270CB3E）

85CF33F97B46A88C7386286D0270CB3E



<img src="https://i-blog.csdnimg.cn/blog_migrate/bf78f51ade24744aaacf53b775594f24.png" alt="" style="max-height:598px; box-sizing:content-box;" />


### 请分析“乐享金融”充值金额大于582402元的受害人充值总金额是_______。（标准格式：12345678）

101000087



<img src="https://i-blog.csdnimg.cn/blog_migrate/c31efd85f0c33d73f6953b3e80cfbefe.png" alt="" style="max-height:414px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/969fb7421bd6eb5813404ba8a6476d9d.png" alt="" style="max-height:258px; box-sizing:content-box;" />


### 请分析“乐享金融”银行卡号“6239039472846284913”绑定用户的用户名是_______。（标准格式：张三）

kongxin



<img src="https://i-blog.csdnimg.cn/blog_migrate/66d2a90691db2fd74f7bad123116a6cb.png" alt="" style="max-height:285px; box-sizing:content-box;" />


2917去看看id



<img src="https://i-blog.csdnimg.cn/blog_migrate/33b21218a870888ee4e42ed49f86c51d.png" alt="" style="max-height:348px; box-sizing:content-box;" />


### 请分析“乐享金融”建仓时间为“2022/03/01 18:44:01”，平仓时间为“2022/03/01 18:52:01”，以太坊/泰达币的这一笔交易的平仓价格是_______。（标准格式：1888.668）

2896.924



<img src="https://i-blog.csdnimg.cn/blog_migrate/d21b4870f9324c7b12d0e7f12048b3aa.png" alt="" style="max-height:671px; box-sizing:content-box;" />


### 请分析“乐享金融”订单编号为“202112090946233262”平仓时间是_______。（标准格式：2022-1-11.1:22:43）

2021-12-09 09:52:23

这个找不到 一样 去找一下备份文件

然后倒入sql文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/72a17ae293b9cff31a457e47a4935a18.png" alt="" style="max-height:539px; box-sizing:content-box;" />


### 宝塔面板某用户曾尝试进行一次POST请求，参数为“/BTCloud?action=UploadFilesData”，请问该用户疑似使用的（ ）电脑系统进行访问请求的。

Windows8.1



<img src="https://i-blog.csdnimg.cn/blog_migrate/b9a0d1dce4145c253cdcb53fe57a5e0d.png" alt="" style="max-height:669px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/72760a8744c22caae030acbb39f031ae.png" alt="" style="max-height:277px; box-sizing:content-box;" />


### 请分析该服务器镜像最高权限“root”账户的密码是_______。（标准格式：a123456）

g123123

通过john 暴力破解



<img src="https://i-blog.csdnimg.cn/blog_migrate/e758f60f121e2afe329767141044659c.png" alt="" style="max-height:228px; box-sizing:content-box;" />


首先去取证保存 etc/passwd 和 etc/shadow

用unshadow 合并

```cobol
unshadow /etc/passwd /etc/shadow > mima
```

然后使用 rockyou.txt字典来爆破

```cobol
john mima  -w=/usr/share/wordlists/rockyou.txt
```
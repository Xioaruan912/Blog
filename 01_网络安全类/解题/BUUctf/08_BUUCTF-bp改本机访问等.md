# BUUCTF-bp改本机访问等

第五周 4.2

**目录**

[TOC]



## web

### [极客大挑战 2019]Http

打开环境

什么都没有 查看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/fbae7c63a1480fbb7fdd7b61a11c129b.png" alt="" style="max-height:567px; box-sizing:content-box;" />


发现一个php文件 我们访问该文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/30059cf3c9871b1ced85f795d22118b3.png" alt="" style="max-height:421px; box-sizing:content-box;" />


提示我们不是从这里来的 我们进行抓包改

```ruby
Referer:https://Sycsecret.buuoj.cn
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0bda4283b3a5087a07584e3aad51fb0a.png" alt="" style="max-height:200px; box-sizing:content-box;" />


发送

```sql
User-Agent: Syclover
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/39aa27dab56b03275d0bb52c6776f275.png" alt="" style="max-height:254px; box-sizing:content-box;" />


提示我们用这个浏览器



<img src="https://i-blog.csdnimg.cn/blog_migrate/279076f3e9f27304e46828bfac914238.png" alt="" style="max-height:121px; box-sizing:content-box;" />


把UA改为这个



<img src="https://i-blog.csdnimg.cn/blog_migrate/32926edfe28207b1887fa5797452a9a9.png" alt="" style="max-height:296px; box-sizing:content-box;" />




说我们要当地的

```cobol
X-Forwarded-For:127.0.0.1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c8e12b3ea90cb6e21f7e61daca1c7ae0.png" alt="" style="max-height:288px; box-sizing:content-box;" />


得到flag

### [极客大挑战 2019]Knife

看名字想到是菜刀 文件上传



<img src="https://i-blog.csdnimg.cn/blog_migrate/198166a28dab1c718f45a1741d7db7d6.png" alt="" style="max-height:317px; box-sizing:content-box;" />


打开环境 直接给我们一个一句话木马 我们打开蚁剑看看能不能直接注入



<img src="https://i-blog.csdnimg.cn/blog_migrate/cf6f3f90f2d2ea2b309608a8a9063c23.png" alt="" style="max-height:699px; box-sizing:content-box;" />


发现可以

直接找到flag

<img src="https://i-blog.csdnimg.cn/blog_migrate/1cf2814f0f56a5dea8ecba0bd7a9d9e5.png" alt="" style="max-height:699px; box-sizing:content-box;" />


## Crypto

### Rabbit

新品种 rabbit加密



### 

### 篱笆墙的影子

看名字 想到栅栏密码



<img src="https://i-blog.csdnimg.cn/blog_migrate/a15aef10c89e8c09d79dbb5dbff03d3c.png" alt="" style="max-height:363px; box-sizing:content-box;" />


得到flag

## Misc

### LSB

下载文件 看到LSB

想到放入StegSolve



<img src="https://i-blog.csdnimg.cn/blog_migrate/a64d28391ea86dc8dbfe157369a8aa03.png" alt="" style="max-height:269px; box-sizing:content-box;" />




发现上面出现东西 我们开始找 lsb的数目

```cobol
red 0
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fe67c41ba8b090e1b032a3089207cd56.png" alt="" style="max-height:305px; box-sizing:content-box;" />




```cobol
green 0
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a92229c77ab95f0a6919df333f1e14bc.png" alt="" style="max-height:313px; box-sizing:content-box;" />


```cobol
blue 0
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/189c3685584964fc52b9694be5e077f6.png" alt="" style="max-height:197px; box-sizing:content-box;" />


我们使用data extract



<img src="https://i-blog.csdnimg.cn/blog_migrate/ef546c1523f316f54580733ff3bfe134.png" alt="" style="max-height:568px; box-sizing:content-box;" />


保存为 bin  命名为png结尾

得到二维码



<img src="https://i-blog.csdnimg.cn/blog_migrate/7d9746a0a17ca31a1523cf161c028843.png" alt="" style="max-height:665px; box-sizing:content-box;" />


得到flag

### zip伪加密

伪加密放入010



<img src="https://i-blog.csdnimg.cn/blog_migrate/565789dc27cc65612bb8006e0b691f32.png" alt="" style="max-height:385px; box-sizing:content-box;" />


更改为8 或偶数



<img src="https://i-blog.csdnimg.cn/blog_migrate/7e1aed0ed934859d49d31b4c19a8fa77.png" alt="" style="max-height:781px; box-sizing:content-box;" />


得到flag

## Reverse

### 不一样的flag

下载 放入 ida32

搜索字符串

<img src="https://i-blog.csdnimg.cn/blog_migrate/19fe24196d6188c22636d06000fdf597.png" alt="" style="max-height:343px; box-sizing:content-box;" />


然后查看哪里使用了



<img src="https://i-blog.csdnimg.cn/blog_migrate/6189055497849a45502782e1789289d3.png" alt="" style="max-height:911px; box-sizing:content-box;" />


得到伪代码

发现前面有一个data_start

然后我们进行查看



<img src="https://i-blog.csdnimg.cn/blog_migrate/24d10612a607b3e7eeb2c4d8a94c3923.png" alt="" style="max-height:117px; box-sizing:content-box;" />


发现是这个

猜测是地图

然后#是出口

```cobol
5x5
*1111
 
01000
 
01010
 
00010
 
1111#
 
 
```

运行程序



<img src="https://i-blog.csdnimg.cn/blog_migrate/547c47408ff198245b0229e4267e63b6.png" alt="" style="max-height:414px; box-sizing:content-box;" />


发现就是走迷宫 我们进行操作

```cobol
 
flag{222441144222}
```
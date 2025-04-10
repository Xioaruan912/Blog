# 生成式对抗网络 （GAN）

## 生成式 （generator）

到目前 我们学习的 model 都是function 处理不同x 和不同的y

这里我们要将network 拿来生成

那么这样 我们就会加上一个Z 可以用于生成内容 这个Z都是随机生成的

![image-20250409103931136](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250409103931136.png)

这里生成Z的 函数 是一个简单的函数 就是我们自己设计的函数 

这个时候我们y的输出 不在单一

![image-20250409104043404](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250409104043404.png)

## 为什么要输出分布（distribution）

预测游戏画面

![image-20250409104210888](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250409104210888.png)

在传统的NW中 会输出不同的方向转角 因为是之前训练资料中存在的

但是我们希望他能够生成一些分布可以单一决定向左向右

我们希望我们的model 有多种输出 并且存在一些创造性 

# **判别器（Discriminator）**

这是一个函数 传入一个iamge 输出一个范围

就是代表输出好不好

判别器主要就是自己来设定 例如用多个 卷积层等

# 为什么要这两个

```
核心思想是通过两者的对抗训练，生成逼真的数据
```

学习过程

#### 第一代 

参数完全随机 生成完全垃圾

判别器 直接判断

#### 第二代

调整参数 骗过 判别器

如果判别器认为通过 那么就骗通过第一代 判别器

#### 第三代

判别器找出差异 那么就继续攻击

![image-20250409212406895](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250409212406895.png)

# 从函数上重新理解

假设参数都初始化

1. 定住 产生器 Generater 训练 discriminator

   ![image-20250409212951268](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250409212951268.png)

训练真实二次元 和 fake 二次元的差异 学习出来 那么判别器 就可以 回归或者分类 直接训练

2. 训练好discriminator 后 训练generator

   骗过 判别器 大概训练如下

   ![image-20250409213736984](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250409213736984.png)

​	判别器固定 并且 要求 输出值训练高

​	也可以这样看待

![image-20250409213817901](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250409213817901.png)

3. 接下来就是反复训练 直到输出很好的图片为止
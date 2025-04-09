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
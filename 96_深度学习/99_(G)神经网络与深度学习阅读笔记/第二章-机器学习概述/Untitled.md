# 机器学习概述

首先一个例子可以引出如何 Mechine Learning

通过手写数字 人类可以很好的 了解 和识别每个数字 但是机器无法

![image-20250330175753487](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330175753487.png)

这里我们通过的方法就是 人类进行标识 然后通过大量数据 机器学习 实现**积攒经验** 从而实现识别

## 基本概念的学习

首先我们学习一下基本概念

我们通过购买芒果实现学习

```
1. 购买一些随机的芒果 来判断好坏
```

#### 特征

我们通过对芒果的颜色 大小等 我们叫做特征

#### 标签

这个是我们需要预测的值 例如 甜度 又可以是离散的好坏

#### 样本

我们通过写好的标签和特征 与芒果组合 变为样本

#### 训练集和测试集

通过样本 进行分布 一些用于测试预测结果 一些用于模型训练

#### 特征向量

我们使用一组 N维向量 来表示特征

![image-20250330180606146](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330180606146.png)

标签则是通过y来表示

那么 假如每个数据都是相互独立的 我们的训练集可以写为

![image-20250330180710793](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330180710793.png)

下面就是 训练集 告诉你内容和结果 测试集 只告诉你输入 不告诉你输出 让你预测

![image-20250330181925338](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330181925338.png)

即对每个特征都有一个标签

我们希望 通过一堆的函数中 可以获取到最优预测函数

```
如何寻找这个“最优” 的函数 𝑓∗(𝒙) 是机器学习的关键， 一般需要通过学习算法 （Learning Algorithm)
```

所以机器学习的事例 我们可以由下图展示

![image-20250330180858404](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330180858404.png)

通过学习算法 获取最优函数 然后可以实现输入 x 即特征 输出一个 预测其标签的值

## 机器学习的三大要素

#### 模型

我们知道 模型就是一个函数 我们可以通过 x输入 获取y的输出

这里其实存在两个类型 线形和非线性模型

![image-20250330181707031](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330181707031.png)

分为线形模型和非线形模型

### 线形模型

最基础的模型 

![image-20250331130019249](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250331130019249.png)

概念如下

**w** : 权重 是一个向量 代表 不同x 对f的影响

**b** ：偏置值 代表 对函数的轻调整

### 非线形模型

![image-20250331130232065](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250331130232065.png)

是通过 权重w 和偏置 b 对 函数族

这也可以提升到神经网络 就是 函数族为可学习函数![image-20250331130410208](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250331130410208.png)



### 损失函数 Loss 

这个是我们在 李宏毅老师课程里学习到的内容

#### 01损失函数

![image-20250331130444843](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250331130444843.png)

缺点是太过于离散 

#### 平方损失函数

![image-20250331130531408](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250331130531408.png)

#### 交叉熵损失函数

![image-20250331130605424](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250331130605424.png)

输出一个概率分布问题 

## 风险最小化准则

#### 经验风险函数

![image-20250331130910937](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250331130910937.png)

#### 过拟合

**拟合**（Overfitting）是机器学习中一个常见的问题，指的是模型在训练数据上表现得非常好，但在新的、未见过的数据上表现较差的现象

模型学习了训练数据中的噪声和细节，而不是捕捉到数据中的一般规律。

这不是我们希望的 我们希望的是可以总结出一般规律

# 线形回归模型

通过线形回归模型了解一个模型的过程

线形回归就是通过自变量和因变量之间的关系 建立的模型 

自变量个数为1 的时候 我们叫做简单回归 而自变量为多个时候 为 多元回归

模型如下

![image-20250331131340626](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250331131340626.png)

```
y 是预测的输出（因变量）。
x1,x2,…,xn是输入特征（自变量）。
w1,w2,…,wn是权重 对不同的x对应不同的w
```

![image-20250331131518686](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250331131518686.png)

所以我们可以知道线形回归就是通过 找到最好的 w和b 进行预测

下面引出不同的参数评估方法

```
由于线性回归的标签 𝑦 和模型输出都为连续的实数值，因此平方损失函数非常合适衡量真实标签和预测标签之间的差异
```

这里其实就是 最小化所有训练样本的预测误差的平方和 这就是最小二乘法

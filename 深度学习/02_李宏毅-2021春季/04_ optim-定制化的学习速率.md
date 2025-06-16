![image-20250406153352582](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406153352582.png)

上图为 学习速率为 10^-2 次方

![image-20250406153417139](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406153417139.png)

这里是 学习速率为 -7次方 可以发现 一个定的学习速率 无法很好的到达我们希望的地点

我们如何在 梯度下降法中 使用良好的 学习速率 这就是我们需要进行 定制化 学习速率

```
如果该方向 导数过小 就调大学习速率 反之调小
```

我们原本的学习速率为

![image-20250406154517336](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406154517336.png)

现在我们需要更新

![image-20250406154535529](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406154535529.png)

 所以总的来说

```
我们通过 前一个的下降 取平均求平方和 计算出定制化的 学习速率 这样就可以在不同的 梯度的时候 就可以变化
```

我们叫做**Adagrad（自适应梯度算法)**

# **Adagrad（自适应梯度算法)**

```
频繁出现的特征（如常见单词）的梯度较小，适合较小的学习率。
稀疏特征（如罕见单词）的梯度较大，适合较大的学习率。
```

![image-20250406155631779](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406155631779.png)

![image-20250406155657380](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406155657380.png)

![image-20250406160501684](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406160501684.png)

这里可以发现有问题呢 在后面 突然就开始爆炸了 

因为他是吸收之前所有的 阶梯 那么后面就开始在 梯度小的地方爆炸 但是最后在梯度大的时候

又减小开始回归 这里我们可以添加上 **学习速率减小** 与时间有关系

![image-20250406160656653](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406160656653.png)

**Warmup（学习率预热）** 

![image-20250406160803604](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406160803604.png)

先增大 后减小 其实这里是比较黑科技的 因为我们这里的优化都是 统计数据 通过统计 才可以很好调整学习速率

# **RMSprop（均方根传播）**

主要提出 Adagrad问题  是积累了所有梯度的平方根

所以RMSprop改进了 这里我们可以动态调整现在的 g有多重要

![image-20250406155951964](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406155951964.png)

总的来说 RMSprop 就是 可以通过 贝塔项 控制重要性 这个贝塔项 是 (0,1) 区间的

但是现在我们最常用的 优化策略 其实是 Adam 

# **Adam（自适应矩估计）**

他是我们之前的 Momentum + RMSProp

![image-20250406160331936](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406160331936.png)

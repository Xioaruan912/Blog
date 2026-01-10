![image-20250406161447986](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406161447986.png)

这里就是一个分类

输出一个 y 他要和不同类别的数字越接近越好

但是这个时候 不大可行

```
这样 输出的内容 就代表 class 1 和class 3 是不类似的
但是有些图片又恰好类似 class 1/3 呢
所以这个方法不大行
```

常见做法为 使用向量 如果有3个内容 就如下

![image-20250406161657854](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406161657854.png)

我们之前是输出一个数字 现在我们需要输出3个值

![image-20250406161748427](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406161748427.png)

这样我们就可以从回归转变为分类问题

# 归一化函数（softmax）

我们在通过 这个方法获取到的y 我们再会通过一个 **softmax归一化函数**的函数 转变为回归

```
在分类任务中，神经网络的最后一层通常输出一个实数向量，例如：
原始输出： [2.0, 1.0, 0.1]
直接使用这些值无法解释为概率（因为可能为负数、总和不为 1）
 那么softmax就通过下面方法
1.指数化：将每个值转换为正数（因为 e^x>0）。
2.归一化：将所有指数结果除以它们的总和，得到概率。
```

```
假设神经网络输出 logits 为 [2.0,1.0,0.1]，Softmax 计算过程如下
```

![image-20250406162109227](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406162109227.png)

![image-20250406162113975](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406162113975.png)

从这个的解释 就很简单理解 softmax的运作 归一化的运作

# **交叉熵损失（Cross-Entropy Loss）**

```
用于衡量模型预测概率分布与真实标签分布之间的差异
```

![image-20250406163237467](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406163237467.png)

![image-20250406163243399](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406163243399.png)

![image-20250406163248220](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406163248220.png)

**黄金组合**：交叉熵损失 + Softmax激活函数

#### 具体例子

```
神经网络最后一层的原始输出（未归一化）：
猫: 2.0  
狗: 1.0  
兔子: 0.1

该图片实际是猫，用one-hot编码表示为：

[1, 0, 0]  # 猫(1), 狗(0), 兔子(0)
```

那么我们会通过 softmax 进行归一化

然后通过 cross Entropy 计算Loss

![image-20250406163432649](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406163432649.png)

就可以看计算
$$
L=−[1×log(0.659)+0×log(0.242)+0×log(0.099)]=−log(0.659)≈0.417
$$
可以通过平方差计算 对比 可以发现 使用 cross entropy 函数可以 放大错误预测的惩罚
$$
LMSE
 =(1−0.659) 
2
 +(0−0.242) 
2
 +(0−0.099) 
2
 ≈0.198
$$

```
交叉熵更能放大错误预测的惩罚（0.417 vs 0.198）
```

在pytorch中 softmax 会被和 cross entropy 捆绑在一起 只要使用了 cross-Entropy 那么softmax自动加载在最后一层
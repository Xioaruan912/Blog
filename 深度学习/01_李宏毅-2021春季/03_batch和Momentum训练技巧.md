## BATCH

不是对所有data 进行微分

而是讲data换算为 batch 然后对batch计算

我们可以理解为 一个资料分为多个batch 算Loss

对一个训练资料计算我们叫做 epoch

### 为什么要用batch

 ![image-20250401143605735](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250401143605735.png)

这里是两个极端例子 一个是训练资料所有看完 一个是只看一个 训练出来的两个模型

可以发现 大概是差不多的

但是我们能不能越设越小呢 就1 1次就update

其实实际上 1个epoch中 大的 batch 反而更快 因为我们可以使用 GPU的平行运算

在上述图中 我们可以发现 小的bitch 不够稳定 但是事实上 不够稳定的 update 反而能够更好训练模型
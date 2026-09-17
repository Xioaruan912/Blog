这里就是 gradient descent + momentum

具体如下

![image-20250402181402114](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250402181402114.png)

我们回忆一下以前的gredient descent

# 以前的梯度下降

​	

![image-20250402181444174](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250402181444174.png)

反向传播 每次下降后 我们更新参数到反方向 没有其他添加

但是我们加上了 momentum 梯度动量

就是每次update的反方向 + 之前的向量 ---> 运用向量相加 组合一个折中的向量 那么这样 我们就有可能因为之前的动量大 突破 crtical point 

 ![image-20250402183040360](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250402183040360.png)

我们可以从上图 知道如何绕过 critical point
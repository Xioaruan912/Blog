# CNN(Convolutional Neural Network)

被用在 图像 上 目标是 分类

假设我们的图像为 100 x 100

![image-20250406173224600](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406173224600.png)

![image-20250406173248314](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406173248314.png)

这里是对我们的影像辨识系统 看看呀辨识的种类

# 如何把图片作为model的输入

图片是一个三维的 tensor 是一个数组（长，宽，chanel）

**chanel** 是 RGB三种颜色

![image-20250406173415214](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406173415214.png)

现在我们讲图片拉直 变为了 一个向量

![image-20250406173435786](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406173435786.png)

那么这样就可以输入model中了

我们之前学习的都是 全连接model

![image-20250406173509428](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406173509428.png)

那么这样传递的数据量过大了 这里只是100像素的内容 那么这样就会出现问题

这样我们产生了CNN

## 如何辨识

侦查特点 有没有找到特点 找到了就决定了 这个图片是什么

![image-20250406173709597](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406173709597.png)

我们可以让不同的神经元看不同的区域 这样我们就可以输出 每个神经元只需要观察自己的区域的内容 

那么这个就是把自己的区域拉直 然后输入神经元

```
CNN的设计灵感来源于人脑的 视觉皮层，通过局部感知和层次化抽象来处理图像
```

![image-20250406174258016](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250406174258016.png)

但是这里其实 范围是可以重叠的 这个范围我们叫做**感受野（Receptive Field）** 是指神经网络中**某一层特征图上的一个点**
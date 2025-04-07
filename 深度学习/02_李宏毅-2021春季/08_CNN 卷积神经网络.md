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

# 基本的感受野设置

1. 查看所有的chanel

   这样我们就可以考虑高和宽 这样高和宽我们叫做 **kernel size**

![image-20250407095527163](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407095527163.png)

​	同一个感受野 通常会有一排 例如 64个 坚守一个receptive filed

2. 制造新感受野

   通过stride 自设置参数 就可以控制新的 receptive filed

   ![image-20250407095722988](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407095722988.png)

​	我们希望每个感受野存在高度重叠

3. 超出范围

   ![image-20250407095804093](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407095804093.png)

​	一般超出范围我们也会考虑 所以这里可以使用padding **补0**

这样我们就可以扫过所有图片

# 同样特点可能出现不同区域

![image-20250407095959418](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407095959418.png)

这样其实没问题 鸟嘴出现在某个特定的 receptive field 中 然后被某个检测鸟嘴的 neuron检测到 

这里有一个想法 其实每个 neuron的作用是一样的 知识 receptive field 不同

## 共享参数

 ![image-20250407100310480](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407100310480.png)

其实就是**权重（weight）**是完全一样的

但是输入的x是不相同的 那么这样 就可以有点类似一个neuron 接受所有的输入

![image-20250407100450494](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407100450494.png)

可以发现输出不同

## 常见共享

![image-20250407100548265](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407100548265.png)

旁边代表是neuron 我们之前一组参数我们叫做 filter 

![image-20250407100629416](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407100629416.png)

# 卷积层

就是 receptive filed + 参数共享 = 卷积层 

# 如何抓取特征 pattern

tensor里面的数值我们知道了

![image-20250407101310584](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407101310584.png)

括号内的值和filter相乘 

![image-20250407101327838](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407101327838.png)

然后使用 stride 进行kernel移动

![image-20250407101432135](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407101432135.png)

我们可以看到 如果 输出为3 那么最大

![image-20250407101510723](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407101510723.png)

这样就可以得到一个 pattern

如果我们有 64个 那么就可以输出 特征图 变为 有64个chanel 的图片

![image-20250407101611844](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407101611844.png)

所以如果我们使用 这个图片继续 CNN 那么我们设置的filter 我们也要设置64 

第一层是看图片 如果RGB 那么3 如果黑白 就是 2

# 池化

我们把偶数的列 奇数的行全部拿掉 图片其实没有影响

**MaxPooling 最大池化** 不是学习的内容 就可以理解为是一个 sigmoid 函数 工具类

我们之前知道 每个 filter 就输出一组数字  我们把输出的数字 分为不同组 保留最大值即可 

 ![image-20250407102241510](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407102241510.png)

保存下来

![image-20250407102251648](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407102251648.png)

所以一般 卷积后 会 执行一次 pooling

![image-20250407102323121](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407102323121.png)

实际上 就交替使用 pooling 主要作用是减少运算 但是如果要辨识精细的图片 那么可以把pooling丢弃

# 如何得到最后结果

我们使用**Flatten 展开** 向量 

然后丢到全连接层 或者使用 softmax 最后输出结果

![image-20250407102632388](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407102632388.png)

事实上 CNN无法处理图片放大缩小旋转问题 哪怕他就是一个图片
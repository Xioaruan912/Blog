[DCGAN](https://pytorch.org/tutorials/beginner/dcgan_faces_tutorial.html)

跟随着 pytorch 开始 生成对抗网络的搭建

DCGAN 是

```
不同之处在于它在鉴别器和生成器中分别明确使用了卷积层和卷积转置层。
```

```
鉴别器由步幅卷积层、批量归一化层和 LeakyReLU 激活函数组成
输入是 3x64x64 的输入图像，输出是输入来自真实数据分布的标量概率。
```

```
生成器由卷积转置层、批量归一化层和 ReLU 激活函数组成
输入是从标准正态分布中提取的潜在向量 z
输出是 3x64x64 的 RGB 图像。
```

[数据](https://pan.baidu.com/s/1CRxxhoQ97A5qbsKO7iaAJg) （密码：rp0s）

![image-20250410205835163](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250410205835163.png)
他是一个 Seq2Seq 的model 输出的内容是函数自己决定的

其核心思想是将**可变长度的输入序列**映射为**可变长度的输出序列**

例如语音辨识

输入是一串的向量 输出由自己决定

![image-20250408093956826](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408093956826.png)

这种输入和输出没有字数关系的 需要机器自己来

所以对输出数目无法决定的 可以使用 **Seq2seq** 硬做

# Seq2seq

大概模型如下

![image-20250408100106325](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408100106325.png)

# 加密器 Encoder

输入一排 输出另外一排长度相同的向量

![image-20250408100200829](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408100200829.png)

一个 Block 可能做的如下

![image-20250408100243140](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408100243140.png)

在transformer 中 我们还不仅仅如上面一样 而是下图 input 加上output

![image-20250408100319438](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408100319438.png)

然后在进行 layer 标准化

![image-20250408100408091](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408100408091.png)

输出如下

![image-20250408100439472](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408100439472.png)

然后再传入全连接 再次加上input 和output 最后再进行一次标准化  输出了一个encoder的向量
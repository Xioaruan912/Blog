# Decoder

## Autoregressive decoder （AT）

例子为语音辨识

![image-20250408101138878](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408101138878.png)

把encoder 的 输出 读入 decoder

![image-20250408101408682](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408101408682.png)

首次接受黑的都Begin 的符号 然后输出一个被softmax 处理过的概率分布

这个分布是包括了 你接受的所有字典 例如3000个中文汉字

然后将第一个输出 作为第二个的输入 标识 为 向量

![image-20250408101533082](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408101533082.png)

就是这个过程反复学习

可以发现decoder 将自己的输出 作为input

我们现在专注Decoder内部

![image-20250408101721190](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408101721190.png)我们k

我们今天发现 中间其实差别不大

### Masked self_attention

Masked 的意思是 不同的self_attention

不能查看右边的部分![image-20250408101833986](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408101833986.png)

```
b1的产生 只能看a1
b2的产生 只能看a1,a2
b3的产生 只能看a1,a2,a3
.....
```

如何确定输出的长度呢 使用END 输出

![image-20250408102751226](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408102751226.png)

需要Transformer 输出 End 结束输出

## None Autoregressive decoder （NAT）

输入一排 begin 的 token 就直接输出一个句子

![image-20250408103336357](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408103336357.png)

但是我们不知道 要输入多少begin 所以要么就重新再设计一个 分类 输出数字 代表多少个begin

```
NAT 好处
1.平行输出
2.比较能够控制输出的长度
```

# CrossAttention

这里是decoder 的 特别 block

![image-20250408104210963](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408104210963.png)

这个步骤就是decoder 的 cross attention的过程

![image-20250408104243999](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408104243999.png)

# 训练 training

语音辨识 需要一个 语音和对应的中文

 例如 机器学习

![image-20250408104815391](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250408104815391.png)

那么第一个字 的 向量 就是这样 可以发现 这个和分类问题很类似


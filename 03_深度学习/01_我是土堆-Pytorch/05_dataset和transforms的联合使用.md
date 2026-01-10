PyTorch 的torchvision 存在图片识别类

[torchvision.dataset](https://pytorch.org/vision/main/datasets.html)

我们这次使用

[CIFAR-10](https://www.cs.toronto.edu/~kriz/cifar.html)

```py
import torchvision


#下载训练集和测试集
train_dataset = torchvision.datasets.CIFAR10("./dataset/train",download=True)
test_dataset = torchvision.datasets.CIFAR10("./dataset/test",train=False,download=True)


```



```
torchvision.datasets.CIFAR100(root: Union[str, Path], train: bool = True, transform: Optional[Callable] = None, target_transform: Optional[Callable] = None, download: bool = False)[source]  
```

![image-20250331133421025](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250331133421025.png)

 
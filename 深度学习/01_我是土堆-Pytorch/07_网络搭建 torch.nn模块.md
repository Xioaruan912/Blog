[**neural network**](https://pytorch.org/docs/stable/nn.html)

![image-20250401175522672](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250401175522672.png)

```
import torch.nn as nn
import torch.nn.functional as F

class Model(nn.Module):
    def __init__(self) -> None:
        super().__init__()
        self.conv1 = nn.Conv2d(1, 20, 5)
        self.conv2 = nn.Conv2d(20, 20, 5)

    def forward(self, x):
        x = F.relu(self.conv1(x))
        return F.relu(self.conv2(x))
```

创建一个 模型叫做 Model 这就是神经网络定义模版   

```
    def forward(self, x):
        x = F.relu(self.conv1(x))
        return F.relu(self.conv2(x))
        正向传播 如何返回数据
```

我们写一个最简单的模型

```c
import torch
from torch import nn
from torchvision import transforms
class MyezModel(nn.Module):
    def __init__(self) -> None:
        super().__init__()

    def forward(self, x):
        return x+1



ez = MyezModel()
x = torch.tensor(1)
y = ez(1)
print(y) 
```
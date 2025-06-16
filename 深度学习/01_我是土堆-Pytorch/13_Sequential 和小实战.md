![image-20250401200635828](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250401200635828.png)

依据这个图片进行编写

依据

### 卷积

![image-20250401200856450](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250401200856450.png)

计算出 是否需要padding  =2 stride = 1

dilation默认为1

```c
from torch.utils.data import DataLoader
from torchvision import datasets, transforms
from torch.utils.tensorboard import SummaryWriter
from torch import nn

# 数据加载
train_data = datasets.CIFAR10("./data", train=True, transform=transforms.ToTensor())
test_data = datasets.CIFAR10("./data", train=False, transform=transforms.ToTensor())

class FixCIFAR10(nn.Module):
    # def __init__(self):
    #     super(FixCIFAR10, self).__init__()
    #     self.conv2d = nn.Conv2d(in_channels=3,out_channels=32,kernel_size=5,stride= 1,padding=2)
    #     self.maxpool1 = nn.MaxPool2d(2)
    #     self.conv2d2 = nn.Conv2d(in_channels=32,out_channels=32,kernel_size=5,padding=2)
    #     self.maxpool2 = nn.MaxPool2d(2)
    #     self.conv2d3 = nn.Conv2d(in_channels=32,out_channels=64,kernel_size=5,padding=2)
    #     self.maxpool3 = nn.MaxPool2d(2)
    #     self.Flatten1 = nn.Flatten()
    #     self.liner1 = nn.Linear(1024,64)
    #     self.liner2 = nn.Linear(64,10)
    #
    # def forward(self,x):
    #     x = self.conv2d(x)
    #     x = self.maxpool1(x)
    #     x = self.conv2d2(x)
    #     x = self.maxpool2(x)
    #     x = self.conv2d3(x)
    #     x = self.conv2d3(x)
    #     x = self.Flatten1(x)
    #     x = self.liner1(x)
    #     return self.liner2(x)

    def __init__(self):
        super(FixCIFAR10, self).__init__()
        self.modul1 = nn.Sequential(  #使用Sequentiall简化
            nn.Conv2d(in_channels=3, out_channels=32, kernel_size=5, stride=1, padding=2),
            nn.MaxPool2d(2),
            nn.Conv2d(in_channels=32, out_channels=32, kernel_size=5, padding=2),
            nn.MaxPool2d(2),
            nn.Conv2d(in_channels=32, out_channels=64, kernel_size=5, padding=2),
            nn.MaxPool2d(2),
            nn.Flatten(),
            nn.Linear(1024, 64),
            nn.Linear(64, 10)
        )

    def forward(self,x):
        return self.modul1(x)
```

代码和sequential

如果我们希望通过 tensorboard展示模型

```py
from torch.utils.data import DataLoader
from torchvision import datasets, transforms
from torch.utils.tensorboard import SummaryWriter
from torch import nn ,ones
import torch
# 数据加载
train_data = datasets.CIFAR10("./data", train=True, transform=transforms.ToTensor())
test_data = datasets.CIFAR10("./data", train=False, transform=transforms.ToTensor())

class FixCIFAR10(nn.Module):
    # def __init__(self):
    #     super(FixCIFAR10, self).__init__()
    #     self.conv2d = nn.Conv2d(in_channels=3,out_channels=32,kernel_size=5,stride= 1,padding=2)
    #     self.maxpool1 = nn.MaxPool2d(2)
    #     self.conv2d2 = nn.Conv2d(in_channels=32,out_channels=32,kernel_size=5,padding=2)
    #     self.maxpool2 = nn.MaxPool2d(2)
    #     self.conv2d3 = nn.Conv2d(in_channels=32,out_channels=64,kernel_size=5,padding=2)
    #     self.maxpool3 = nn.MaxPool2d(2)
    #     self.Flatten1 = nn.Flatten()
    #     self.liner1 = nn.Linear(1024,64)
    #     self.liner2 = nn.Linear(64,10)
    #
    # def forward(self,x):
    #     x = self.conv2d(x)
    #     x = self.maxpool1(x)
    #     x = self.conv2d2(x)
    #     x = self.maxpool2(x)
    #     x = self.conv2d3(x)
    #     x = self.conv2d3(x)
    #     x = self.Flatten1(x)
    #     x = self.liner1(x)
    #     return self.liner2(x)

    def __init__(self):
        super(FixCIFAR10, self).__init__()
        self.modul1 = nn.Sequential(  #使用Sequentiall简化
            nn.Conv2d(in_channels=3, out_channels=32, kernel_size=5, stride=1, padding=2),
            nn.MaxPool2d(2),
            nn.Conv2d(in_channels=32, out_channels=32, kernel_size=5, padding=2),
            nn.MaxPool2d(2),
            nn.Conv2d(in_channels=32, out_channels=64, kernel_size=5, padding=2),
            nn.MaxPool2d(2),
            nn.Flatten(),
            nn.Linear(1024, 64),
            nn.Linear(64, 10)
        )

    def forward(self,x):
        return self.modul1(x)

ez = FixCIFAR10()
Writer = SummaryWriter("./logs")
data = ones((64,3,32,32))
Writer.add_graph(ez,data)
Writer.close()
```

![image-20250401203139092](../../../../Library/Application%20Support/typora-user-images/image-20250401203139092.png)
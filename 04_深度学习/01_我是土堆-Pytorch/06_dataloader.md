**dataloader** 是加载到神经网络中

dataset 是告诉数据在哪里

就是每次都是从dataset中取数据

首先下载数据

```py
from torch.utils.data import DataLoader
from torchvision import datasets
from torchvision import transforms

trans = transforms.ToTensor()

train_data = datasets.CIFAR10("./data",train= True ,transform=trans,download=True)
test_data = datasets.CIFAR10("./data",train= False ,transform=trans,download=True)


```

```
DataLoader(dataset, batch_size=1, shuffle=False, sampler=None,
           batch_sampler=None, num_workers=0, collate_fn=None,
           pin_memory=False, drop_last=False, timeout=0,
           worker_init_fn=None, *, prefetch_factor=2,
           persistent_workers=False)
dataset 数据
batch_size 分几份
shuffle 是否随机抽取
num_workers  工作多进程
drop_last 读取余出数据后是否舍去
```

所以我们读取数据

```python

test_loader  = DataLoader(dataset=test_data,batch_size= 4,shuffle= True,num_workers=0,drop_last=False)

#测试集数据
img ,traget = test_data[0]
print(img.shape)
print(traget)
```

输出如下

```
torch.Size([3, 32, 32])  //RGB 3通道 32x32像素  
3
```

**batch_size= 4**

就是通过 test_data 随机 取4个图片

![image-20250401172626940](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250401172626940.png)

我们通过tensorboard展示  

![image-20250401173628689](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250401173628689.png)

```
from torch.utils.data import DataLoader
from torchvision import datasets
from torchvision import transforms
from torch.utils.tensorboard import SummaryWriter

trans = transforms.ToTensor()

train_data = datasets.CIFAR10("./data", train=True, transform=trans, download=True)
test_data = datasets.CIFAR10("./data", train=False, transform=trans, download=True)

Writer = SummaryWriter("logs")

test_loader = DataLoader(dataset=test_data, batch_size=64, shuffle=True, num_workers=0, drop_last=False)

step = 0
for data in test_loader:
    imgs, targets = data
    Writer.add_images("Test_loader", imgs, step)
    step = step + 1

```

在数据最后

![image-20250401173722702](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250401173722702.png)

就可以很好解释drop_last  这个参数

如果我们多次读取训练集 就使用到了shuffle

读取次数不同 就会选取不同的照片

我们可以通过例子看看

```c
from torch.utils.data import DataLoader
from torchvision import datasets
from torchvision import transforms
from torch.utils.tensorboard import SummaryWriter

trans = transforms.ToTensor()

train_data = datasets.CIFAR10("./data", train=True, transform=trans, download=True)
test_data = datasets.CIFAR10("./data", train=False, transform=trans, download=True)

Writer = SummaryWriter("logs")

test_loader = DataLoader(dataset=test_data, batch_size=64, shuffle=False, num_workers=0, drop_last=True)

for epoch in range(2):
    step = 0
    for data in test_loader:
        imgs, targets = data
        Writer.add_images(f"epoch_{epoch}", imgs, step)
        step = step + 1

```


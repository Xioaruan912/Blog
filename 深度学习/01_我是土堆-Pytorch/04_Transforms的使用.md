## 基本学习

![image-20250330211414065](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330211414065.png)

在了解transforms的时候 我们需要了解tensor 这个数据类型 

```
from torchvision import transforms
from PIL import Image
PIL_IMG =  Image.open("hymenoptera_data/train/ants/0013035.jpg")


#创建
tensor_arr  = transforms.ToTensor()
tensor_pic = tensor_arr(PIL_IMG) 
```

这里是通过 PIL读取 我们也可以通过opencv读取

```
pip install opencv-python
```

```python
from torchvision import transforms
import cv2

cv_img =  cv2.imread("hymenoptera_data/train/ants/0013035.jpg")

print(type(cv_img))
#创建
tensor_arr  = transforms.ToTensor()
tensor_pic = tensor_arr(cv_img)
```

```
<class 'numpy.ndarray'>
```

所以这里 ToTensor 传入的是 numpy 和 PIL 类型

最后直接通过totensor传入

```
from torchvision import transforms
import cv2
from torch.utils.tensorboard import SummaryWriter
cv_img =  cv2.imread("hymenoptera_data/train/ants/0013035.jpg")

print(type(cv_img))
Writer = SummaryWriter("logs")
#创建
tensor_arr  = transforms.ToTensor()
tensor_pic = tensor_arr(cv_img)


Writer.add_image('test',tensor_pic,1,dataformats="CHW")

Writer.close()

```

这tensor 类型是对于机器学习用的数据类型 可以保存机器学习基本参数

下面学习一些常用的Transforms的函数

## Transforms函数

首先了解一下__call__

其实 这个在python里面就是类似于 C++ 构造函数  （并不是 ）

只是这个构造函数不会在创建类的时候就执行 而是可以直接通过类调用 例如

```py

class person:
    def __call__(self,name):
        print("hello" + "__call__" + name)

    def hello(self,name):
        print("hello" + name)

person_struct = person()
person_struct("nonono")
person_struct.hello("eeeee")
```

输出如下

```
hello__call__nonono
helloeeeee

```

接下来对Transforms 常用函数进行练习



### class Resize():

调整大小 

```
Resize the input image to the given size.
    If the image is torch Tensor, it is expected
    to have [..., H, W] shape, where ... means a maximum of two leading dimensions
```

可以发现
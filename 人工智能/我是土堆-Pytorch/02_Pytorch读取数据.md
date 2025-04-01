# 读取数据

[数据集](https://download.pytorch.org/tutorial/hymenoptera_data.zip)

```
from torch.utils.data import  Dataset #从 torch utils 这个工具箱里读取data 的dataset方法
```

我们去看看dataset 这个函数如何进行

```
from torch.utils.data import  Dataset
Dataset??
```

```
class Dataset(Generic[_T_co]):
    r"""An abstract class representing a :class:`Dataset`.

    All datasets that represent a map from keys to data samples should subclass
    it. All subclasses should overwrite :meth:`__getitem__`, supporting fetching a
    data sample for a given key. Subclasses could also optionally overwrite
    :meth:`__len__`, which is expected to return the size of the dataset by many
    :class:`~torch.utils.data.Sampler` implementations and the default options
    of :class:`~torch.utils.data.DataLoader`. Subclasses could also
    optionally implement :meth:`__getitems__`, for speedup batched samples
    loading. This method accepts list of indices of samples of batch and returns
    list of samples.
```

输出如下

所以我们首先要初始化类 并且重写 __getitem__ 

```python
from torch.utils.data import Dataset #从 torch utils 这个工具箱里读取data 的dataset方法
from PIL import Image

class Myclass(Dataset):
    def __init__(self):
        
    def __getitem__(self, idx)
```

如果我们需要更好的编程 就使用控制台

![image-20250330193829250](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330193829250.png)

![image-20250330193913743](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330193913743.png)

可以看到变量很好的显示在旁边

```
image_path = "hymenoptera_data/train/ants/0013035.jpg"
from PIL import Image
img = Image.open(image_path)
```

![image-20250330194026797](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330194026797.png)

这里很好的显示了 变量里面的参数

使用 

```
img.show()
```

即可显示图片

如何快速讲文件夹下面的东西生成为一个列表

```
import os
image_path_dir = "hymenoptera_data/train/ants"
image_list = os.listdir(image_path_dir)
```

![image-20250330194434087](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330194434087.png)

这里可以发现已经存储到列表中了   

```python
from torch.utils.data import Dataset #从 torch utils 这个工具箱里读取data 的dataset方法
from PIL import Image
import os
class Myclass(Dataset):
    def __init__(self,root_dir,lable_dir):
        self.root_dir = root_dir
        self.lable_dir  = lable_dir
        self.path   = os.path.join(self.root_dir,self.lable_dir ) #自动拼接目录
        self.image_path_list = os.listdir(self.path )


    def __getitem__(self, idx):
        #读取self中的 path
        img_name = self.image_path_list[idx]
        #获取每个图片的路径
        img_path =  os.path.join(self.root_dir,self.lable_dir,img_name)
        #对图片进行读取
        img = Image.open(img_path)
        lable  = self.lable_dir
        return  img,lable 
    def __len__(self):
        return  len(self.image_path_list)


#创建实例
root_dir = "hymenoptera_data/train"
ants_lable_dir = "antsv"
ant_dataset = Myclass(root_dir,ants_lable_dir )
```

我们去看看运行情况

![image-20250330200232350](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330200232350.png)



```c
from torch.utils.data import Dataset #从 torch utils 这个工具箱里读取data 的dataset方法
from PIL import Image
import os
class Myclass(Dataset):
    def __init__(self,root_dir,lable_dir):
        self.root_dir = root_dir
        self.lable_dir  = lable_dir
        self.path   = os.path.join(self.root_dir,self.lable_dir ) #自动拼接目录
        self.image_path_list = os.listdir(self.path )


    def __getitem__(self, idx):
        #读取self中的 path
        img_name = self.image_path_list[idx]
        #获取每个图片的路径
        img_path =  os.path.join(self.root_dir,self.lable_dir,img_name)
        #对图片进行读取
        img = Image.open(img_path)
        lable  = self.lable_dir
        return  img,lable 
    def __len__(self):
        return  len(self.image_path_list)


#创建实例
root_dir = "hymenoptera_data/train"
ants_lable_dir = "ants"
bees_lable_dir = "bees"
#读取两个数据集
ant_dataset = Myclass(root_dir,ants_lable_dir )
bee_dataset = Myclass(root_dir,bees_lable_dir )

#数据集结合
train_dataset = ant_dataset + bee_dataset
```

我们可以发现生成了下面的内容

![image-20250330200642122](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330200642122.png)
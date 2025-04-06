主要是输出图像和对图像的操作

```
from torch.utils.tensorboard import SummaryWriter
```

我们首先看看 类的使用 

我们可以通过转到 来查看

```
class SummaryWriter:
    """Writes entries directly to event files in the log_dir to be consumed by TensorBoard.

    The `SummaryWriter` class provides a high-level API to create an event file
    in a given directory and add summaries and events to it. The class updates the
    file contents asynchronously. This allows a training program to call methods
    to add data to the file directly from the training loop, without slowing down
    training.
    """
```

我们首先学习绘制出 直角坐标系的数据图像

```py
from torch.utils.tensorboard import SummaryWriter

#初始化实例
Writer = SummaryWriter("logs")   # 保存到logs文件夹下
Writer.add_scalar()
```



```python
 def add_scalar(
        self,
        tag,
        scalar_value,
        global_step=None,
        walltime=None,
        new_style=False,
        double_precision=False,
    ):
        """Add scalar data to summary.

        Args:
            tag (str): Data identifier
            scalar_value (float or string/blobname): Value to save
            global_step (int): Global step value to record
            walltime (float): Optional override default walltime (time.time())
              with seconds after epoch of event
            new_style (boolean): Whether to use new style (tensor field) or old
              style (simple_value field). New style could lead to faster data loading.
        Examples::

            from torch.utils.tensorboard import SummaryWriter
            writer = SummaryWriter()
            x = range(100)
            for i in x:
                writer.add_scalar('y=2x', i * 2, i)
            writer.close()

        Expected result:

        .. image:: _static/img/tensorboard/add_scalar.png 
           :scale: 50 %

        """
        torch._C._log_api_usage_once("tensorboard.logging.add_scalar")

        summary = scalar(
            tag, scalar_value, new_style=new_style, double_precision=double_precision
        )
        self._get_file_writer().add_summary(summary, global_step, walltime)
```

![image-20250330201631104](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330201631104.png)

执行后 报错 我们输入

``` 
conda activate pytorch
pip instsall tensorborad 
```

![image-20250330202339799](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330202339799.png)

生成文件后我们通过shell 输出项目

```
tensorboard --logdir = logs
```

![image-20250330202409481](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330202409481.png)

 

现在学习如何写入图像

```
    def add_image(
        self, tag, img_tensor, global_step=None, walltime=None, dataformats="CHW"
    ):
        """Add image data to summary.

        Note that this requires the ``pillow`` package.

        Args:
            tag (str): Data identifier
            img_tensor (torch.Tensor, numpy.ndarray, or string/blobname): Image data
            global_step (int): Global step value to record
            walltime (float): Optional override default walltime (time.time())
              seconds after epoch of event
            dataformats (str): Image data format specification of the form
              CHW, HWC, HW, WH, etc.
        Shape:
            img_tensor: Default is :math:`(3, H, W)`. You can use ``torchvision.utils.make_grid()`` to
            convert a batch of tensor into 3xHxW format or call ``add_images`` and let us do the job.
            Tensor with :math:`(1, H, W)`, :math:`(H, W)`, :math:`(H, W, 3)` is also suitable as long as
            corresponding ``dataformats`` argument is passed, e.g. ``CHW``, ``HWC``, ``HW``.
```

```py
from torch.utils.tensorboard import SummaryWriter
import numpy as np
from PIL import Image
#初始化实例
Writer = SummaryWriter("logs")   # 保存到logs文件夹下

image_path = Image.open("hymenoptera_data/train/ants/0013035.jpg")
numpy_arr = np.array(image_path)
#torch.Tensor, numpy.ndarray, or string/blobname 三种类型
Writer.add_image("test",numpy_arr,1,dataformats = "HWC")

Writer.close()
```

可以通过web查看

![image-20250330210745839](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330210745839.png)

确实读取了一个蚂蚁

```
Writer.add_image("test",numpy_arr,1,dataformats = "HWC") 这里最后一个参数 我们可以通过shape查看
```

```
(512, 768, 3)
```

可以发现属于HWC

我们可以通过Tensorborad 输出中间过程
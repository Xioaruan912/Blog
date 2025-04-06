[Anaconda](https://www.anaconda.com/download/success)

下载即可

### 管理环境

```shell
conda create  -n pytorch python=3.9
// -n 名字 版本
```

这样就会创建一个 名为 pytorch 的 python3.9

进入环境

```
conda activate pytorch   
```



#### 安装pytorch

[pytorch](https://pytorch.org/)

这里显示如下

![image-20250330190320249](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250330190320249.png)

我们通过pip 安装

```
pip3 install torch torchvision torchaudio
```

编译器我们主要是使用jupyter

```
conda install ipykernel
conda install -c conda-forge nb_conda
jupyter notebook
```

这样就打开了 jupyter
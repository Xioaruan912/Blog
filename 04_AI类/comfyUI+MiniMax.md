这次出现的 MiniMaxH3 我正好可以本地部署 所以这里跑一遍

# 安装

https://modelscope.cn/models/Comfy-Org/MiniMax-H3/

https://github.com/comfy-org/comfyui 

下载最新版本解压即可

然后 点击

![image-20260823225629830](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260823225629848.png)

选择下面随机一个

![image-20260823225641719](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260823225641798.png)



然后报错 会让你去下载 4个内容 下载即可 按照要求存入文件夹`\ComfyUI\models`下的

`ComfyUI\models\diffusion_models`

![image-20260823225739326](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260823225739343.png)

`\ComfyUI\models\text_encoders`

![image-20260823225757922](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260823225757940.png)



`ComfyUI\models\vae`

![image-20260823225805167](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260823225805183.png)

# 提示词生成

https://github.com/MiniMax-AI/MiniMax-H3/blob/main/README.zh-CN.md

但是我一般是去网站找好看的 然后修改



# 加速

https://huggingface.co/lightx2v/Minimax-h3-Turbo/tree/main

这个是lora加速

下载好后放入 `ComfyUI_windows_portable\ComfyUI\models\loras`

![image-20260823225827667](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260823225827681.png)

重新启动 `ComfyUI`

然后配置工作流

点击下面这个

![image-20260823225338235](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260823225338257.png)

双击空白处 

![image-20260823225404386](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260823225404415.png)

写入本地lora加速模型

按照下面这三条连线

![image-20260823225504480](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260823225504515.png)

设置step为8 即可

![image-20260823225523507](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260823225523521.png)

下面这个依据仓库执行即可

https://github.com/HELPMEEADICE/TE-Speed-MiniMaxH3-OSS


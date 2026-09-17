ImageView 主要是图片的展示 

![image-20260121095737976](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121095737976.png)

```
public class ImageView extends View {
```

继承 `view`

# src

需要把图片存入`res/drawable` 目录中

```
    android:src="@drawable/black">
```

![image-20260121100127330](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121100127330.png)

存入的内容会等比缩放 以便于存入内部

# scaleType

用于图片缩放

![image-20260121100213611](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121100213611.png)

我们设置 `center` 如果图片超过 那么就会被剪裁

`centerCrop` 通过短边填充 长边直接剪裁

# maxHight maxWidth

我们很难 把图片完全贴合 控件 通过设置 `maxXXX` 从而设置

配合`adjustViewBounds = treu` 允许缩放 实现填充
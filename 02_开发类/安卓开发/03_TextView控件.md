# TextView - 控件

我们不可能学习所有的控件 而是常见属性

基础属性

![image-20260120191800822](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120191800822.png)

我们通过代码 了解下面内容

我们定位到 `activity_main.xml`

重新编写

```java
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout android:layout_width="match_parent"
    android:layout_height="match_parent"
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    >


</LinearLayout>
```

这里内容先不需要了解 `LinearLayout ` 类似一个容器 

我们的固件 `TextView` 需要放入容器中

现在注册一个固件

```java
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout android:layout_width="match_parent"
    android:layout_height="match_parent"
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    >
<TextView
    android:layout_width=""
    android:layout_height="">

</TextView>

</LinearLayout>
```

## layout_width,layout_height

我们可以看看 `layout_width` 有什么可以写的 `ctrl + 左键` 点击进入

![Capturer_2026-01-20_192342_679](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-20_192342_679.gif)

可以发现 有 `[弃用]fill_parent`

 `match_parent`：取容器的总宽度

 `wrap_content`：依据控件内容自动取 但是不超过

`直接写数字`：`xxxdp` 可以直接固定

## id

也就是控件的 唯一`id `为了让`JAVA `代码去获取唯一`Id`

```
<TextView
    android:layout_width="200dp"
    android:layout_height="200dp"
    android:id="@+id/tv_one">
```

这里起名字就是 这个`id` 是 `tv_one`

通过下面`Java`代码可以唯一获取到这个控件对象

```
findViewById(R.id.tv_one)
```

## text

用于显示文本的

![image-20260120192947573](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120192947573.png)

这里不只是通过这个可以写 也可以通过Java写

去 `MainActivity` 中

```java
package com.example.myapplication;

import android.os.Bundle;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);

        TextView tv_one = findViewById(R.id.tv_one);
        tv_one.setText("n你你你你你你"); //通过调用这个方法 写东西
    }
}
```

并且会被覆盖

## textColor

设置文本颜色

```
android:textColor="#00000000"
```

两位一个含义

```
00000000
```

1. 前两个是透明度 00-FF 透明--不透明
2. 接着两个是红色 
3. 再两个是绿色
4. 最后是蓝色

![image-20260120193336185](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120193336185.png)

## textStyle

包含3个 `normal` 无效果 `bold` 加粗 `italic` 斜体

## textSize

文本大小 单位是 `dp`

## backGround

背景颜色 颜色依旧可以通过 `#00000000` 设置

![image-20260120193804062](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120193804062.png)

也可以通过图片设置背景

## gravity

设置内容 对齐方向 默认是靠左上角

![image-20260120193912627](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120193912627.png)

可以发现有很多布局地方

## 注意内容

如果正规开发 我们` text` 和` textColor`和`backGround` 不应该写入这里 而是写入`res/values` 中

```
    <string name="app_name">My Application</string>
```

`name`：标志文本 是唯一的 不允许重复

我们这里通过 `@string/app_name` 取得

```
        android:text="@string/app_name"
```

# 带阴影的TextView

![image-20260120194332291](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120194332291.png)

通过下面属性设置

Color和Radius 配合使用

## `shadowColor shadowRadius shadowDx shadowDy`

![image-20260120194658688](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120194658688.png)

# 跑马灯的TextView

 ![image-20260120194950461](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120194950461.png)

这里可以发现其实有点难理解 通过代码

`android:singleLine="true" `让 Text 强制一行输出

`android:ellipsize="marquee"` 省略号位置

`android:marqueeRepeatLimit="marquee_forever"` 跑马灯一直跑下去

`android:focusable="true"
android:focusableInTouchMode="true"`

设置有焦点了 才进行跑马灯

## 获取焦点

1.通过点击获取焦点

```
android:clickable="true"
```

这样我们点击一下就可以 跑马灯了

2.自定义个`textView`

构建一个类` MytextView` 继承`TextView`

```java
package com.example.myapplication;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.TextView;

import androidx.annotation.Nullable;

public class MytextView extends TextView {
    public MytextView(Context context) {
        super(context);
    }

    public MytextView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
    }

    public MytextView(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    //主要是这里 上面是重构 构造方法 这里让他一直是被 焦点的
    public boolean isFocused() {
        return true;
    }
}

```

回到 `activity`中

```xml
    <com.example.myapplication.MytextView
        android:id="@+id/tv_one"
        android:layout_width="match_parent"
        android:layout_height="194dp"
        android:background="#660ff0ff"
        android:gravity="center"
        android:shadowColor="@color/red"
        android:shadowDx="10.0"
        android:shadowDy="10.0"
        android:shadowRadius="3.0"
        android:singleLine="true"
        android:ellipsize="marquee"
        android:marqueeRepeatLimit="marquee_forever"
        android:focusable="true"
        android:focusableInTouchMode="true"
        android:text="@string/app_name"
        android:textColor="@color/black"
        android:textSize="30sp"
        android:textStyle="italic">
    </com.example.myapplication.MytextView>
```

这样就会打开app后自动 运行跑马灯

3.依旧使用`TextView`构造

```
        <requestFocus/>
```

添加这个 让 控件自己去请求焦点 从而实现跑马灯

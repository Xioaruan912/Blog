

`Button` 也就是按钮内容的

![image-20260120224945324](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120224945324.png)

是一个 `Drawable`的资源

`button` 继承 `textView`的 所以`textView`有的 `button` 都有

这里我们发现 背景色无法用

![image-20260120225311220](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120225311220.png)

我们需要去修改主题 `values/themes.xml`

```xml
    <style name="Base.Theme.MyApplication" parent="Theme.Material3.DayNight.NoActionBar">
```

修改为

```xml
    <style name="Base.Theme.MyApplication" parent="Theme.MaterialComponents.DayNight.Bridge">
```

即可

实现按下切换一个颜色

在`res/drawable` 中` new` 一个

![image-20260120225741212](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120225741212.png)

# drawable

要求传入的是一个`drawable`图片

![Capturer_2026-01-20_230009_063](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-20_230009_063.gif)

# state

这里是按钮的功能

![image-20260120230150096](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120230150096.png)

```
android:state_pressed="true"
```

按下的时候 设置为true

所以这里设置为

```xml
    <item android:drawable="@drawable/baseline_2k_24"
            android:state_pressed="true">
    </item>
    <item android:drawable="@drawable/baseline_3g_mobiledata_24">
    </item>
```

按下的时候 显示`2k`的图片  默认显示 `3G`

然后通过 `backGround` 调用这个

```xml
<Button
    android:background="@drawable/btn_selector"
    android:layout_width="200dp"
    android:layout_height="100dp">
</Button>
```

切换按钮的颜色 设置一个新的目录` color`

![image-20260120230753484](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120230753484.png)

```xml
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:color="@color/black"
        android:state_pressed="true">
    </item>
    <item android:color="#FF00FF00">
    </item>
</selector>
```

这样就实现了 按下 黑色 不按绿色

然后我们去调用 通过 `backGroundTint`

```xml
<Button
    android:background="@drawable/btn_selector"
    android:backgroundTint="@color/btn_select_color"
    android:layout_width="200dp"
    android:layout_height="100dp">
</Button>
```

![Capturer_2026-01-20_231019_145](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-20_231019_145.gif)

1. `drawable`资源可以设置 `backGround`的图标
2. 对于选择器 类型`selector`的 `item` 可以控制按钮按下的变化

# 事件处理

这里就需要`JAVA` 代码的辅助了 所以我们需要设置`id`

```xml
<Button
    android:id="@+id/btn"
    android:background="@drawable/btn_selector"
    android:backgroundTint="@color/btn_select_color"
    android:layout_width="200dp"
    android:layout_height="100dp">
</Button>
```

去`Java` 中获取一下

```java
Button btn = findViewById(R.id.btn);
```

一次点击的监听器

```java
package com.example.myapplication;

import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "你好你好";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        Button btn = findViewById(R.id.btn);

        //点击事件
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.e(TAG, "onClick: " );
            }
        });

        //长按事件
        btn.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                Log.e(TAG, "onLongClick: " );
                return false;
            }
        });

        //触摸事件
        btn.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                Log.e(TAG, "onTouch: " );
                return false;
            }
        });
    }

}
```

触发事件就是在回调函数执行过程 我们设置一个打印内容

```java
private static final String TAG = "你好你好";
Log.e(TAG, "onClick: " );
```

![image-20260120232250392](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120232250392.png)

我们通过 `Logcat` 获取日志

![image-20260120232422734](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120232422734.png)

可以发现输出了日志

我们发现 `onTouch` 输出了好多次 所以我们看看 里面的内容

![image-20260120232750202](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120232750202.png)

我们可以通过 `getAction()`方法获取当前是哪个

```java
        //触摸事件
        btn.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                Log.e(TAG, "onTouch: " + event.getAction() );
                return false;
            }
        });
```

也就是 移动 按下和 松开 三个方法

如果回调函数 设置为` true `返回 那么就说明被其他消费了 不会执行 其他事件的内容

消费优先级为 `OnTouch` > `OnLongClick` > `OnClick`

也就是 左边设置返回值为 `true` 右边就不会执行

# 通过xml设置监听事件

```xml
    android:onClick="btnclick"
```

对名字按 `ATL + ENTER` 构建 方法在` main`中

```java
    public void btnclick(View view) {
        Log.e(TAG, "onClick: " );
    }
```

这样就会类似上面的回调函数一样 执行
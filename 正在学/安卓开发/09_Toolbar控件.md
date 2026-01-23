`toolbar` 主要 用于替换 `theme` 的下面内容

![image-20260121165104858](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121165104858.png)

主要属性有下面的类型

![image-20260121165005906](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121165005906.png)

# 初始化

```xml
<androidx.appcompat.widget.Toolbar
    android:layout_width="match_parent"
    android:layout_height="?attr/actionBarSize"
    >

</androidx.appcompat.widget.Toolbar>
```

# `navigationIcon`

主要是 上标题的 图标 一般是通过点击后返回

```
app:navigationIcon="@drawable/btn_selector"
```

 ![image-20260121165723184](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121165723184.png)

# `title` `titleTextColor`

```
app:title="返回"
app:titleTextColor="#FFFF0000"
```

![image-20260121170041840](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121170041840.png)

# `titleMarginStart`

设置 距离开始多远

```
app:titleMarginStart="90dp"
```

![image-20260121170211153](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121170211153.png)

# `subtitle` `subtitleTextColor`

子标题  

```
    app:subtitle="这是子标题"
    app:subtitleTextColor="#FF00FF"
```

![image-20260121170309525](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121170309525.png)

# `logo`

```
app:logo="@mipmap/ic_launcher"
```

![image-20260121170523345](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121170523345.png)

# 点击后返回

如果我们对  ` Icon` 希望点击后返回 通过 添加监听实现

```xml
<androidx.appcompat.widget.Toolbar
    android:id="@+id/toolbar_id"
    android:background="#FF0"
    android:layout_width="match_parent"
    android:layout_height="?attr/actionBarSize"
    app:navigationIcon="@drawable/btn_selector"
    app:title="返回"
    app:titleTextColor="#FFFF0000"
    app:titleMarginStart="90dp"
    app:subtitle="这是子标题"
    app:subtitleTextColor="#FF00FF"
    app:logo="@mipmap/ic_launcher"
    >
```

回到`Java` 中写

```java
public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        Toolbar tb = findViewById(R.id.toolbar_id);

        tb.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.e("通知！：", "onClick: "+"点击返回咯" );
            }
        }); //设置 ICON 点击的监听
}
}
```

![image-20260121171400383](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121171400383.png)

# 通过`Java`对`toolbar` 设置

```
    <androidx.appcompat.widget.Toolbar
        android:id="@+id/tb2"
        android:background="#FFF0FFF0"
        android:layout_width="match_parent"
        android:layout_height="?attr/actionBarSize"
        android:layout_marginTop="20dp"
        >

    </androidx.appcompat.widget.Toolbar>
```

设置一个新的 `toolbar` 然后去 `Java`中设置

![image-20260121171743985](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121171743985.png)

可以发现这里 就和 `xml` 类似的内容
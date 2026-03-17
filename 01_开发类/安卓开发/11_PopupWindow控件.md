

`PopupWindow` 的作用是 点击后 弹出 布局 

![image-20260121193727933](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121193727933.png)

主要是`Java`的代码设置

# 初始化对象

```
PopupWindow pupw = new PopupWindow()
```

他包含 1-4 参数的构造函数  我们这里通过 3参数演示

![image-20260121194016574](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121194016574.png)

可以发现 需要传入一个 `View` 通过 

```java
View view = getLayoutInflater().inflate(R.layout.mylayout,null); // 这里构建一个 view
```



设置一个` View`

```java
                View view = getLayoutInflater().inflate(R.layout.mylayout,null); // 这里构建一个 view
                PopupWindow pp = new PopupWindow(view, ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
```

`ViewGroup.LayoutParams.WRAP_CONTENT` 和 `xml` 中设置为 ` wrap_content `效果一样

# `showAsDropDown`

一参数的： 是把 `window `展示在` view `的` 无偏移 下方`

```java
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        Button btn = findViewById(R.id.btn_adl);

        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                View view = getLayoutInflater().inflate(R.layout.mylayout,null);
                PopupWindow pp = new PopupWindow(view, ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
                pp.showAsDropDown(v); //显示在当前按钮下方
            }
        });
}
}
```

![Capturer_2026-01-21_195355_993](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-21_195355_993.gif)

三参数：传入` view` 和 `x y的偏移`

```java
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        Button btn = findViewById(R.id.btn_adl);

        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                View view = getLayoutInflater().inflate(R.layout.mylayout,null); // 这里构建一个 view
                PopupWindow pp = new PopupWindow(view, ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
                pp.showAsDropDown(v,200,200); //这里是三参数
            }
        });
}
}
```

![Capturer_2026-01-21_195553_960](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-21_195553_960.gif)

# 点击后关闭

1.通过构造的时候 让聚焦了 才打开 否则关闭 【也就是点击空白处 自动关闭】

```java
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        Button btn = findViewById(R.id.btn_adl);

        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                View view = getLayoutInflater().inflate(R.layout.mylayout,null);
                PopupWindow pp = new PopupWindow(view, ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT,true); //加入一个 true 用于 focus
                pp.showAsDropDown(v);
            }
        });
}
}
```

2.点击按钮后推出

```java
public class MainActivity extends AppCompatActivity {
    private PopupWindow pp;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        Button btn = findViewById(R.id.btn_adl);

        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (pp != null && pp.isShowing()) {  //之前就判断 是否是打开的 如果是打开的 就关闭
                    Log.e("TAG", "onClick: "+"再次点击 触发关闭" );
                    pp.dismiss();
                    return;
                }
                View view = getLayoutInflater().inflate(R.layout.mylayout,null); // 这里构建一个 view
                pp = new PopupWindow(view, ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
                pp.showAsDropDown(v);

            }
        });
}
}
```


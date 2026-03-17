

`AlertDialog` 主要是 对话框的内容 

![image-20260121172047297](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121172047297.png)

首先构建一个 `button` 去触发 这个 对话框的显示

```xml
<Button
    android:id="@+id/btn_adl"
    android:layout_width="200dp"
    android:layout_height="200dp"
    android:text="点击触发 AlertDialog"
    >

</Button>
```

现在去`Java`中 设置

# `setIcon` `setTitle` `setMessage`  `create` `show`

设置对话框的 图标

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
            public void onClick(View v) { //点击事件触发
                AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this); //设置一个 builder
                builder.setIcon(R.mipmap.ic_launcher) //设置对话框的 ICon
                        .setTitle("你好呀")   //标题
                        .setMessage("天气怎么样")  //发送信息
                        .create()  //构建对话框 一定要在 倒数第二个
                        .show();  // 展示 一定要在 最后一个

            }
        });
}
}
```

![image-20260121173303664](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121173303664.png)

# `setPositiveButton` `setNegativeButton` `setNeutralButton`

这是设置 对话框的按钮

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
            public void onClick(View v) { //点击事件触发
                AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this); //设置一个 builder
                builder.setIcon(R.mipmap.ic_launcher)
                        .setTitle("你好呀")
                        .setMessage("天气怎么样")
                        .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                Log.e("TAG", "onClick: "+"触发确定" );
                            }
                        })
                        .setNegativeButton("取消", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                Log.e("TAG", "onClick: "+"触发取消" );
                            }
                        })
                        .setNeutralButton("中间", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                Log.e("TAG", "onClick: "+"触发中间" );
                            }
                        })
                        .create()
                        .show();


            }
        });
}
}
```

![image-20260121173500252](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121173500252.png)

# `setView`

设置自定义布局

首先 构建一个 `layout` 文件

 

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
    android:layout_height="match_parent"
    android:layout_width="match_parent"
    android:orientation="horizontal"
    android:background="#FF00FF00"
    xmlns:android="http://schemas.android.com/apk/res/android"
    >
    
    <ImageView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:src="@mipmap/ic_launcher"
        >

    </ImageView>
    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="HAHAHHA"
        >

    </TextView>

</LinearLayout>
```

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
            public void onClick(View v) { //点击事件触发
                AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this); 
                View view = getLayoutInflater().inflate(R.layout.mylayout,null); // 这里构建一个 view
                builder.setIcon(R.mipmap.ic_launcher)
                        .setTitle("你好呀")
                        .setMessage("天气怎么样")
                        .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                Log.e("TAG", "onClick: "+"触发确定" );
                            }
                        })
                        .setNegativeButton("取消", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                Log.e("TAG", "onClick: "+"触发取消" );
                            }
                        })
                        .setNeutralButton("中间", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                Log.e("TAG", "onClick: "+"触发中间" );
                            }
                        }) 
                        .setView(view)  // 传入 view
                        .create()
                        .show();


            }
        });
}
}
```

![image-20260121193632321](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121193632321.png)

可以发现 这个 自定义布局的作用范围
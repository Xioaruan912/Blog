`ProgressBar` 也就是进度条

![image-20260121100906161](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121100906161.png)

```xml
<ProgressBar
    android:layout_width="wrap_content"
    android:layout_height="wrap_content">
    
</ProgressBar>
```

就可以展示基本的进度条

![Capturer_2026-01-21_101043_670](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-21_101043_670.gif)

这个一般是网络数据加载的时候构建的

# 显示和隐藏

我们通过按钮 从而实现显示和隐藏

并且双方赋值`id`

```xml
<ProgressBar
    android:id="@+id/loading"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content">

</ProgressBar>
<Button
    android:id="@+id/btn_loading"
    android:background="#FF00f00"
    android:text="显示和隐藏加载动画"
    android:layout_width="200dp"
    android:layout_height="50dp"
    >

</Button>
```

我们通过JAVA 去处理 点击问题

```java
package com.example.myapplication;

import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity {
    private  ProgressBar pbr;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        Button btn = findViewById(R.id.btn_loading);
        pbr= findViewById(R.id.loading);
        //设置button监听
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(pbr.getVisibility() == View.GONE){ // 这里表示 当前是隐藏的
                    pbr.setVisibility(View.VISIBLE);  //显示
                }else{
                    pbr.setVisibility(View.GONE); //否则隐藏
                }

            }
        });
}
}
```

这里我们可以通过 `Ctrl + 左键` 进入`getVisibility`

![image-20260121101748322](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121101748322.png)

大概知道了 需要填写什么东西 通过  `setVisibility` 设置可见度

![Capturer_2026-01-21_101920_404](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-21_101920_404.gif)

# 添加水平进度条 style MAX

需要通过 `style`设置

```xml
style="?android:attr/progressBarStyleHorizontal"
```

我们为了让他有 进度条的感觉 我们需要给他设置 `MAX`

##  点击后增加

```java
package com.example.myapplication;

import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity {
    private  ProgressBar pbr;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        Button btn = findViewById(R.id.btn_loading);
        pbr= findViewById(R.id.loading);
        //设置button监听
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int progress = pbr.getProgress(); //获取当前的 progress值
                progress += 10;
                pbr.setProgress(progress);
                if(pbr.getProgress() == 100){
                    pbr.setProgress(0);
                }
            }
        });
}
}
```

从而实现了点击增加进度条

![Capturer_2026-01-21_102734_041](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-21_102734_041.gif)

# indeterminate 循环加载

不显示精度 一直循环加载

![Capturer_2026-01-21_102936_829](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-01-21_102936_829.gif)
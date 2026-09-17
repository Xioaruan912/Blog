也就是输入控件

`EditText `也是继承 `TextView`

![image-20260121091454095](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121091454095.png)

# hint

也就是提示用户输入什么内容

```
android:hint="输入用户名字"
```

![image-20260121091729425](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121091729425.png)

会打印在 输入框中

# textColorHint

设置输出文本的颜色

```
android:textColorHint="#FF00FF00"
```

![image-20260121091829086](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121091829086.png)

# inputType

输入的类型 我们遇见 输入密码后 是`*` 就是通过这个方法设置的

![image-20260121092029854](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121092029854.png)

```
    android:inputType="textPassword" 
```

# drawableLeft

![image-20260121092233725](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121092233725.png)

可以在 输入框 左右设置 图标

如果觉得输入太近了 可以通过下面属性控制

## drawablePadding

```xml
android:drawablePadding="20dp"
```

![image-20260121092345878](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121092345878.png)

如果希望设置背景那么就通过` backGround`属性构建即可

# 获取数据 

一般我们为了有这个 就是为了获取用户输入 所以我们可以通过一个 `button`构建发送请求

通过`id`传递给后端`JAVA` 上面获取数据的 `EditText` 也需要加入`id`

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout android:layout_width="match_parent"
    android:layout_height="match_parent"
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    >

<EditText
    android:id="@+id/user"
    android:layout_width="200dp"
    android:layout_height="100dp"
    android:hint="phoneNumber"
    android:inputType="phone"
    android:textColorHint="@color/black"
    >

</EditText>

<EditText
    android:id="@+id/pass"
    android:layout_width="200dp"
    android:layout_height="100dp"
    android:hint="Password"
    android:drawableLeft="@drawable/btn_selector"
    android:drawablePadding="20dp"
    android:inputType="textPassword"
    android:textColorHint="@color/black"
    >

</EditText>
<Button
    android:id="@+id/btn_login"
    android:textColor="@color/black"
    android:text="登入"
    android:layout_width="200dp"
    android:layout_height="20pt"
    >

</Button>
</LinearLayout>
```

现在回去JAVA中

```java
//
		private EditText edt_pass;
    	private EditText edt_phone;

//方法内部
Button btn = findViewById(R.id.btn_login);
        edt_phone = findViewById(R.id.user);
        edt_pass = findViewById(R.id.pass);
```

存入 变量中 

```java
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //点击 btn 后就 获取 EditText里面的内容
                var pass = edt_pass.getText().toString();
                var phone = edt_phone.getText().toString();
                Log.e(phone, "onClick: ");
                Log.e(pass, "onClick: ");
            }
        });
```

![image-20260121095552412](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121095552412.png)

```
Log.e(pass, "onClick: ");
```

第一个参数是 日志输出的 `TAG` 小标签

第二个参数是 日志输出的内容 也可以通过` "onClick: " + pass ` 实现输出


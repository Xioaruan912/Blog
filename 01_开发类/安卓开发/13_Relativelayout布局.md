![image-20260202130612249](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260202130612249.png)

![image-20260202131245980](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260202131245980.png)

这个布局方法是一个相对布局 也就是如果我们不给出定位 那么就是相对于父容器的定位 

```xml
<?xml version="1.0" encoding="utf-8"?>

    <RelativeLayout

        android:layout_width="match_parent"
        android:layout_height="match_parent"
        xmlns:android="http://schemas.android.com/apk/res/android">
    <RelativeLayout
        android:background="#ff00ff"
        android:layout_width="100dp"
        android:layout_height="100dp">

    </RelativeLayout>
    <RelativeLayout
        android:background="#ff00ff"
        android:layout_width="100dp"
        android:layout_height="100dp">
    </RelativeLayout>
    </RelativeLayout>

```

# 依据父容器定位

![image-20260202131021159](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260202131021159.png)

# 依据兄弟容器定位

![image-20260202131157260](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260202131157260.png)
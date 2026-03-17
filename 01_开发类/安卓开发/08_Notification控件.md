# 通知控件



在用这个之前 我们需要构建两个对象

![image-20260121103255917](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121103255917.png)

首先我们需要通过系统服务获取对象

# NotificationManager

```java
    private  NotificationManager Manager;
    private  Notification notification;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        Button sendNo = findViewById(R.id.sendNo);
        Button deleteNo = findViewById(R.id.deleteNo);
        Manager = (NotificationManager)getSystemService(NOTIFICATION_SERVICE); //通过系统服务获取对象
        notification =  new NotificationCompat.Builder(this,"ni").build();  //得到 Notification 对象
        
        //设置button监听
        sendNo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });
        deleteNo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });
}
}
```

我们通过

`(NotificationManager)getSystemService(NOTIFICATION_SERVICE); `  

得到一个系统通知管理设置

` new NotificationCompat.Builder(this,"ni").build()` 

最终得到一个 Notification对象

这样就可以对系统设置了

# NotificationChannel

`"ni"` 是一个 `channelID` 类型

![image-20260121104302510](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121104302510.png)

```java
        // 如果是 安卓8.0 以上 那么需要创建 NotificationChannel
        if(Build.VERSION.SDK_INT >=  Build.VERSION_CODES.O){
             NotificationChannel notificationChannel =  new NotificationChannel("ni","测试通知",NotificationManager.IMPORTANCE_HIGH);
             Manager.createNotificationChannel(notificationChannel);
        }
```

第三个参数就是上面的 重要性

#  Notification

![image-20260121104900206](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121104900206.png)

具有下面方法

```java
        notification =  new NotificationCompat.Builder(this,"ni")
                .setContentTitle("这里是标题")
                .setContentText("这里是文本通知内容")
                .setSmallIcon(R.drawable.baseline_3g_mobiledata_24) // 这个图标在 安卓5.0后就不允许带颜色
                .build();  //得到 Notification 对象

```

这3个是必须设置的 通知内容

# 触发通知

通过  前面的ID 是随意编写 后面是 `notification` 对象

```
Manager.notify(1,notification);
```

# 如果不触发通知

在`Android 13` 中需要去申请通知权限

```
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

java代码中添加

```java
        Log.d("ver", "SDK=" + Build.VERSION.SDK_INT);
        if (Build.VERSION.SDK_INT >= 33) {
            requestPermissions(new String[]{"android.permission.POST_NOTIFICATIONS"}, 1001); // 发出请求
        }
```

![image-20260121111351283](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121111351283.png)

这样点击 就会触发 通知内容

![image-20260121111407000](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121111407000.png)

我们这里梳理一下过程 发送通知的

1.  构建两个 `button` 用于触发 通知内容
2.  判断 `SDK` 是否 大于33 如果大于 那么就需要申请权限
3.  初始化` NotificationManager` 和` NotificationCompat `用于构建` Manager `和 `Notification `对象 并且在   `Notification ` 中设置通知内容与标题等
4.  判断是否是 `安卓8.0` 以上 如果是 就需要通过 `NotificationChannel` 设置 通知强度
5.  最后通过 `Manager.notify` 发送 定义好的    `Notification ` 通知

# 发送图片

如果我们希望发送图片

```
.setLargeIcon(BitmapFactory.decodeResource(getResources(),R.drawable.black))
```

![image-20260121112002813](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260121112002813.png)

# 设置小图标的颜色

```
.setColor(Color.parseColor("#FFff0000"))
```

由于这里需要设置 `rgb`的 所以需要转化一下

# 设置跳转意图

点击通知后的跳转 意图

```
Intent intent = new Intent(this,Notifiactionactivity.class);
```

```java
package com.example.myapplication;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;

public class Notifiactionactivity extends Activity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Log.e("跳转", "onCreate: "+ "++++++++++++++++  ");
    }
}
```

这个意图我们就简单 输出一个内容 下面转化为 `PenddingIntent`

```
PendingIntent pendingIntent =  PendingIntent.getActivity(this,0,intent,0);
```

传入内容就可以了

```
.setContentIntent(pendingIntent)
```

# 点击通知自动删除

```
.setAutoCancel(true) 
```

# 点击式取消 通知

```java
deleteNo.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        Manager.cancel(1); //上面发送通知的 id
    }
});
```


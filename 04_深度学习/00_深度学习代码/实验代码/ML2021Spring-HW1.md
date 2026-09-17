[HW1](https://www.kaggle.com/competitions/ml2021spring-hw1)

[【2022版李宏毅机器学习作业讲解】-HW1](https://www.bilibili.com/video/BV1gH3qeCEBU?vd_source=84289680f04e153355b368620df7473b)

# 任务概述 

![image-20250407115612550](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407115612550.png)

# 阅读数据

首先我们知道 37个州的情况

![image-20250407144150916](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250407144150916.png)

前面字母缩写 都是州的名字 我们可以作为一个 one hat

后面的社会特征 是连续5天 每天16个 代表one hat中为1的值

118个特征 （id + 37 州 + 16个 * 5 + 1） 最后一列数据为 预测的label

无关： ID

# 代码实现

首先我们先看看数据

首先我们加载数据

# 数据加载

**LoadData.py**

  
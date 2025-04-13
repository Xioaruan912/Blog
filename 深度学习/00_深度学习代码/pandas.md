在写网络的时候 发现对数据处理远大于model

所以学习pandas和numpy

直接读取pandas 网站学习

[Pandas](https://pandas.pydata.org/docs/getting_started/intro_tutorials/01_table_oriented.html)

只要看完入门教程差不多就都学会了 不再记录了

# 基础操作

```py
import pandas as pd

data = pd.read_csv('titanic.csv')
df = pd.DataFrame(data=data)
df.columns
```

```
Index(['Survived', 'Pclass', 'Name', 'Sex', 'Age', 'Siblings/Spouses Aboard',
       'Parents/Children Aboard', 'Fare'],
      dtype='object')
```

对特定查询

```
df.loc[df['Sex'] == 'male' ,"Name"]
查询 男生的名字
df.loc[(df['Sex'] == 'male')| (df['Age'] > 20)]
查询符合两条件的内容
```

```
第 10 行至第 25 行和第 3 列至第 5 列感兴趣
data.iloc[9:25,2:5]
#(9,25] 左开右闭
```

# 绘制图片

```
import pandas as pd
import matplotlib.pyplot as plt
data = pd.read_csv("air_quality_no2.csv",index_col=0,parse_dates=True)

data.plot()
plt.show()
```

![image-20250410154007249](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250410154007249.png)

```
data['station_london'].plot()
plt.show
只查看伦敦的
```

![image-20250410154216222](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250410154216222.png)

```
data.plot.scatter(x = "station_london",y="station_paris",alpha=0.5)
plt.show
使用分布图 查看 lodon和 paris的 分布
```

![image-20250410154352495](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250410154352495.png)

每一列都有自己的子图


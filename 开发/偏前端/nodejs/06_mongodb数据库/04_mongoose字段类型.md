![image-20250526100534711](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250526100534711.png)

```java
mongoose.connection.once('open',() =>{
  console.log("mongodb连接成功");
  let test = new mongoose.Schema({
    id:Number,
    username:String,
    password:String,
    is_sign:Boolean,
    tags : Array,
    date : Date
  })
  //这里创建一个模型对象 可以增删改查
  let testModel = mongoose.model('sign',test)
  testModel.create({
    id : 1,
    username : "xxxxx",
    password : "xxxxxx.xxxxx",
    is_sign  : false,
    tags : ['1111','333333','22222'],
    date : new Date(),
  },(err,data) => {
    if(err){
      console.log(err);
      return
    }
    console.log(data);
    mongoose.disconnect()  
  })

})
```

# 字段验证

检查输入的泪恶心是否正确 否则走其他区域

## 必填项

```
    id:{
      type:String,
      required:true
    },
```

## 默认项

```
    username:{
      type:String,
      default:"效力"
    },
```

## 枚举值

```
    password:{
      type:String,
      enum:['222','2222']
    },
```

一定要在枚举的列表中才符合

## 唯一值

```
    date : {
      type:Date,
      uniquq:true
    }
```

独一无二并且需要重建集合

```
db.test.drop('signs')
```


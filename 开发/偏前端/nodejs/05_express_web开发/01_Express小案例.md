# Express小案例

Singer.json

```json
[
  {
    "id": 1,
    "name": "周杰伦",
    "gender": "男",
    "birthdate": "1979-01-18",
    "origin": "台湾",
    "genres": ["流行", "R&B", "嘻哈"],
    "debutYear": 2000,
    "representativeWorks": [
      {
        "title": "七里香",
        "releaseYear": 2004
      },
      {
        "title": "青花瓷",
        "releaseYear": 2008
      }
    ],
    "socialMedia": {
      "weibo": "https://weibo.com/jaychou",
      "weixin": "jaychou_official"
    }
  },
  {
    "id": 2,
    "name": "李荣浩",
    "gender": "男",
    "birthdate": "1985-07-11",
    "origin": "中国大陆",
    "genres": ["流行", "摇滚", "民谣"],
    "debutYear": 2013,
    "representativeWorks": [
      {
        "title": "模特",
        "releaseYear": 2013
      },
      {
        "title": "年少有为",
        "releaseYear": 2018
      }
    ],
    "socialMedia": {
      "weibo": "https://weibo.com/lironghao",
      "weixin": "lironghao_music"
    }
  },
  {
    "id": 3,
    "name": "蔡依林",
    "gender": "女",
    "birthdate": "1980-09-15",
    "origin": "台湾",
    "genres": ["流行", "舞曲"],
    "debutYear": 1999,
    "representativeWorks": [
      {
        "title": "舞娘",
        "releaseYear": 2006
      },
      {
        "title": "日不落",
        "releaseYear": 2008
      }
    ],
    "socialMedia": {
      "weibo": "https://weibo.com/jolin",
      "weixin": "jolin_cai_official"
    }
  }
]
```

```java
const express =  require("express")
const singerData = require("./result.json")
// console.log(singerData)
const app = express()


// :id 通配符获取 id值
app.get("/test/:id.html",(req,response) => {

    //通过express 获取id值
    let id = req.params.id
    let result = singerData.find(item =>{
        //通过url获取的id和json里面id比对
        if(item.id === Number(id)){
            return true
        }
    })
    if(!result){
        response.statusCode == 404  
        response.send("<h1>404 找不到</h1>")
    }
    response.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8" />
        <title>歌手获取</title>
    </head>
    <body>
        <h2>${result.name}</h2>

    </body>
    </html>
        `)
})
app.listen(3000,()=>{
    console.log("服务开启")
})
```


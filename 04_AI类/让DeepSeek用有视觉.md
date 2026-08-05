这里使用Skills 让DeepSeek 用有视觉理解能力

- [Claude Vision Skill](https://github.com/asuojun/claude-vision-skill)「视觉理解Skill」

# 如何解决视觉

因为Deep不是多模态 所以我们通过Skills 配合一个用有的模型 达到读取

**阿里百炼**的 `Qwen3.7-Flash` 系模型（有 100 万 tokens 的免费额度，由于是大致 35b 左右的 moe 模型，超出价格也不贵（可以设置超量停止）。）

```
https://bailian.console.aliyun.com/cn-beijing/?tab=model#/api-key

https://bailian.console.aliyun.com/cn-beijing/?tab=costing-balance#/costing-balance/free-quota?modelType=Text
```

直接去我的KEY中设置即可 注意记得设置免费用完就结束的设置

![image-20260805111150995](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260805111151034.png)

```
帮我以适配 codex 的形式安装为全局 skill：
https://github.com/asuojun/claude-vision-skill
使用阿里百炼平台，使用模型：qwen3.7-flash
api-key: sk-xxxxxxxx

```



这样就可以实现了
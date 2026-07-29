# [HGAME 2023 week1]Classic Childhood Game js前端查看

记录一下

给了我们一个游戏按照web的尿性 都是要通关或者干嘛才可以 我们现在去看看js



<img src="https://i-blog.csdnimg.cn/blog_migrate/450708fb544cd2c9abf26a92e51ca6c4.png" alt="" style="max-height:156px; box-sizing:content-box;" />


这里发现结局的函数

```cobol
window.setTimeout(function () {
                    Message = ["[Hero]玩家，恭喜你！通关普通结局的纪元魔塔。", "[Npc=3,仙子]谢谢支持！"];
                    mota();
                    Event.ShowMessageList(Message, function () {
                      location.reload();
 
 
发现调用了 mota() 然后就reload 了
 
我们直接去控制台执行一下mota()
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5892c213aa0fabb026daa0c29129b157.png" alt="" style="max-height:127px; box-sizing:content-box;" />


得到flag咯
# 广度优先方法

![image-20250618095811372](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250618095811372.png)

如果是这个图那么我们的广度优先顺序是

```
0 --1、2--3
```

![image-20250618095841959](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250618095841959.png)

结果不唯一

如果是从3开始那么

```
3--1--0、2
```

![image-20250618095921608](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250618095921608.png)

通过邻接表BFS操作如下GIF

![Capturer_2025-06-18_101339_448](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2025-06-18_101339_448.gif)

通过GIF我们可以很好的了解邻接表BFS操作

# 代码

```cpp
// 通过邻接表 BFS
#include <stdio.h>
#define maxsize 10
typedef char Elemtype;
typedef struct ANode
{
    int adjvar;
    struct ANode *nextvar;
} ANode, *Node;
typedef struct VNode
{
    Elemtype data;
    ANode *firstvar;
} VNode;
typedef struct Graph
{
    int numver;
    int numedge;
    VNode adjlist[maxsize];
} Graph;
// 邻接表数据结构结束
// 广度优先遍历开始
void BFS(Graph G, int v) // 给定图和起始索引
{
    int que[maxsize];
    int visit[maxsize] = {0}; // 定义是否入队的数组 并且对数组全部设置为0
    int front = 0, rear = 0;
    visit[v] = 1;
    que[++rear] = v;
    while (front != rear)
    {
        v = que[++front];
        printf("%d", v);
        for (Node p = G.adjlist[v].firstvar; p != NULL; p = p->nextvar)
        {
            if (visit[p->adjvar] != 1) // 如果没有访问过
            {
                visit[p->adjvar] = 1;
                que[++rear] = p->adjvar;
            }
        }
    }
}
```

关键是定义一个visit数组
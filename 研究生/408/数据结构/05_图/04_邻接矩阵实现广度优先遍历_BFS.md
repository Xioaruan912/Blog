![image-20250618105836331](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250618105836331.png)

邻接矩阵如下

![image-20250618105850418](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250618105850418.png)

结构体

```cpp
#define maxsize 10
typedef struct Mgraph
{
    int numver, numedge;
    int vertical[maxsize];
    int edges[maxsize][maxsize];
} Mgraph;
```

BFS

```cpp
void BFS(Mgraph G, int v)
{
    int visit[maxsize] = {0};
    int que[maxsize] = {NULL};
    int front = 0, rear = 0;
    que[++rear] = v;
    while (front != rear)
    {
        v = que[++front];
        printf("%d", v);
        for (int i = 0; i < maxsize; i++)
        {
            if (G.edges[v][i] == 1)
            {
                if (visit[i] == 0)
                {
                    visit[i] = 1;
                    que[++rear] = i;
                }
            }
        }
    }
}
```


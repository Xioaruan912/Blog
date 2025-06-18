// 通过邻接矩阵 BFS
// 邻接矩阵结构体
#include <stdio.h>
#define maxsize 10
typedef struct Mgraph
{
    int numver, numedge;
    int vertical[maxsize];
    int edges[maxsize][maxsize];
} Mgraph;

// BFS
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
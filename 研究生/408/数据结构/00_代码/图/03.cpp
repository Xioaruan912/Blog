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
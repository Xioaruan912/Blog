// 图的结构体
// 邻接矩阵
#define maxsize 10
typedef struct mGraph
{
    int numver, numedg;
    int verticle[maxsize];
    int edges[maxsize][maxsize];
} mGraph;

// 邻接表
// 边节点
typedef struct ANode
{
    int adjvex; // 顶点数组的索引
    struct ANode *nextarc;
} ANode, *Node;
// 顶点数组结构体
typedef struct VNode
{
    char data;
    ANode *firstArc;
} VNode;

// 邻接表结构体
typedef struct Graph
{
    int numver;
    int numedge;
    VNode adjlist[maxsize];

} Graph;

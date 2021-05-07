### 4.1 rank API 概述

HugeGraphServer 除了上一节提到的遍历（traverser）方法，还提供了一类专门做推荐的方法，我们称为`rank API`，
可在图中为一个点推荐与其关系密切的其它点。

### 4.2 rank API 详解

#### 4.2.1 Personal Rank API

##### 4.2.1.0 数据准备

这里以[MovieLens](https://grouplens.org/datasets/movielens/)的 1M 数据集为例，用户需
下载该数据集，然后使用 HugeGraph-Loader 导入到 HugeGraph 中，为简单起见，数据中顶点 user 
和 movie 的属性都忽略，仅使用 id 字段即可，边 rating 的具体评分值也忽略。loader 使用的元数据
文件和输入源映射文件内容如下：

```groovy
////////////////////////////////////////////////////////////
// UserID::Gender::Age::Occupation::Zip-code
// MovieID::Title::Genres
// UserID::MovieID::Rating::Timestamp
////////////////////////////////////////////////////////////

// Define schema
schema.propertyKey("id").asInt().ifNotExist().create();
schema.propertyKey("rate").asInt().ifNotExist().create();

schema.vertexLabel("user")
      .properties("id")
      .primaryKeys("id")
      .ifNotExist()
      .create();
schema.vertexLabel("movie")
      .properties("id")
      .primaryKeys("id")
      .ifNotExist()
      .create();

schema.edgeLabel("rating")
      .sourceLabel("user")
      .targetLabel("movie")
      .properties("rate")
      .ifNotExist()
      .create();
```

```json
{
  "vertices": [
    {
      "label": "user",
      "input": {
        "type": "file",
        "path": "users.dat",
        "format": "TEXT",
        "delimiter": "::",
        "header": ["UserID", "Gender", "Age", "Occupation", "Zip-code"]
      },
      "ignored": ["Gender", "Age", "Occupation", "Zip-code"],
      "mapping": {
          "UserID": "id"
      }
    },
    {
      "label": "movie",
      "input": {
        "type": "file",
        "path": "movies.dat",
        "format": "TEXT",
        "delimiter": "::",
        "header": ["MovieID", "Title", "Genres"]
      },
      "ignored": ["Title", "Genres"],
      "mapping": {
          "MovieID": "id"
      }
    }
  ],
  "edges": [
    {
      "label": "rating",
      "source": ["UserID"],
      "target": ["MovieID"],
      "input": {
        "type": "file",
        "path": "ratings.dat",
        "format": "TEXT",
        "delimiter": "::",
        "header": ["UserID", "MovieID", "Rating", "Timestamp"]
      },
      "ignored": ["Timestamp"],
      "mapping": {
          "UserID": "id",
          "MovieID": "id",
          "Rating": "rate"
      }
    }
  ]
}
```

> 注意将映射文件中`input.path`的值修改为自己本地的路径。

##### 4.2.1.1 功能介绍

适用于二分图，给出所有源顶点相关的其他顶点及其相关性组成的列表。

> 二分图：也称二部图，是图论里的一种特殊模型，也是一种特殊的网络流。其最大的特点在于，可以将图里的顶点分为两个集合，两个集合之间的点有边相连，但集合内的点之间没有直接关联。

假设有一个用户和物品的二分图，基于随机游走的 PersonalRank 算法步骤如下：

1. 选定一个起点用户 u，其初始权重为 1.0，从 Vu 开始游走（有 alpha 的概率走到邻居点，1 - alpha 的概率停留）；
2. 如果决定游走：
    2.1. 那就从当前节点的邻居节点中按照均匀分布随机选择一个，并且按照均匀分布划分权重值；
    2.2. 给源顶点补偿权重 1 - alpha；
    2.3. 重复步骤2；
3. 达到一定步数后收敛，得到推荐列表。

###### Params

- source: 源顶点 id，必填项
- label: 边的类型，必须是连接两类不同顶点的边，必填项
- alpha：每轮迭代时从某个点往外走的概率，与 PageRank 算法中的 alpha 类似，必填项，取值区间为 (0, 1] 
- max_degree: 查询过程中，单个顶点最大边数目，选填项，默认为 10000
- max_depth: 迭代次数，必填项，取值区间为 (0, 50] 
- with_label：筛选结果中保留哪些结果，选填项，可选值为 [SAME_LABEL, OTHER_LABEL, BOTH_LABEL], 默认为 BOTH_LABEL
    - SAME_LABEL：保留与源顶点相同类别的顶点
    - OTHER_LABEL：保留与源顶点不同类别（二分图的另一端）的顶点
    - BOTH_LABEL：保留与源顶点相同和相反类别的顶点
- limit: 返回的顶点的最大数目，选填项，默认为 10000000
- sorted：返回的结果是否根据 rank 排序，为 true 时降序排列，反之不排序，选填项，默认为 true

##### 4.2.1.2 使用方法

###### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/traversers/personalrank
```

###### Request Body

```json
{
    "source": "1:1",
    "label": "rating",
    "alpha": 0.6,
    "max_depth": 15,
    "with_label": "OTHER_LABEL",
    "sorted": true,
    "limit": 10
}
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "2:2858": 0.0005014026017816927,
    "2:1196": 0.0004336708357653617,
    "2:1210": 0.0004128083140214213,
    "2:593": 0.00038117341069881513,
    "2:480": 0.00037005373269728036,
    "2:1198": 0.000366641614652057,
    "2:2396": 0.0003622362410538888,
    "2:2571": 0.0003593312457300953,
    "2:589": 0.00035922123055598566,
    "2:110": 0.0003466135844390885
}
```

##### 4.2.1.3 适用场景

两类不同顶点连接形成的二分图中，给某个点推荐相关性最高的其他顶点，例如：

- 商品推荐中，查找最应该给某人推荐的商品列表

#### 4.2.2 Neighbor Rank API

##### 4.2.2.0 数据准备

```java
public class Loader {
    public static void main(String[] args) {
        HugeClient client = new HugeClient("http://127.0.0.1:8080", "hugegraph");
        SchemaManager schema = client.schema();

        schema.propertyKey("name").asText().ifNotExist().create();

        schema.vertexLabel("person")
              .properties("name")
              .useCustomizeStringId()
              .ifNotExist()
              .create();

        schema.vertexLabel("movie")
              .properties("name")
              .useCustomizeStringId()
              .ifNotExist()
              .create();

        schema.edgeLabel("follow")
              .sourceLabel("person")
              .targetLabel("person")
              .ifNotExist()
              .create();

        schema.edgeLabel("like")
              .sourceLabel("person")
              .targetLabel("movie")
              .ifNotExist()
              .create();

        schema.edgeLabel("directedBy")
              .sourceLabel("movie")
              .targetLabel("person")
              .ifNotExist()
              .create();

        GraphManager graph = client.graph();

        Vertex O = graph.addVertex(T.label, "person", T.id, "O", "name", "O");

        Vertex A = graph.addVertex(T.label, "person", T.id, "A", "name", "A");
        Vertex B = graph.addVertex(T.label, "person", T.id, "B", "name", "B");
        Vertex C = graph.addVertex(T.label, "person", T.id, "C", "name", "C");
        Vertex D = graph.addVertex(T.label, "person", T.id, "D", "name", "D");

        Vertex E = graph.addVertex(T.label, "movie", T.id, "E", "name", "E");
        Vertex F = graph.addVertex(T.label, "movie", T.id, "F", "name", "F");
        Vertex G = graph.addVertex(T.label, "movie", T.id, "G", "name", "G");
        Vertex H = graph.addVertex(T.label, "movie", T.id, "H", "name", "H");
        Vertex I = graph.addVertex(T.label, "movie", T.id, "I", "name", "I");
        Vertex J = graph.addVertex(T.label, "movie", T.id, "J", "name", "J");

        Vertex K = graph.addVertex(T.label, "person", T.id, "K", "name", "K");
        Vertex L = graph.addVertex(T.label, "person", T.id, "L", "name", "L");
        Vertex M = graph.addVertex(T.label, "person", T.id, "M", "name", "M");

        O.addEdge("follow", A);
        O.addEdge("follow", B);
        O.addEdge("follow", C);
        D.addEdge("follow", O);

        A.addEdge("follow", B);
        A.addEdge("like", E);
        A.addEdge("like", F);

        B.addEdge("like", G);
        B.addEdge("like", H);

        C.addEdge("like", I);
        C.addEdge("like", J);

        E.addEdge("directedBy", K);
        F.addEdge("directedBy", B);
        F.addEdge("directedBy", L);

        G.addEdge("directedBy", M);
    }
}
```

##### 4.2.2.1 功能介绍

在一般图结构中，找出每一层与给定起点相关性最高的前 N 个顶点及其相关度，用图的语义理解就是：从起点往外走，
走到各层各个顶点的概率。

###### Params

- source: 源顶点 id，必填项
- alpha：每轮迭代时从某个点往外走的概率，与 PageRank 算法中的 alpha 类似，必填项，取值区间为 (0, 1] 
- steps: 表示从起始顶点走过的路径规则，是一组 Step 的列表，每个 Step 对应结果中的一层，必填项。每个 Step 的结构如下：
	- direction：表示边的方向（OUT, IN, BOTH），默认是 BOTH
	- labels：边的类型列表，多个边类型取并集
	- max_degree：查询过程中，单个顶点最大边数目，默认为 10000
	- top：在结果中每一层只保留权重最高的前 N 个结果，默认为 100，最大值为 1000
- capacity: 遍历过程中最大的访问的顶点数目，选填项，默认为10000000

##### 4.2.2.2 使用方法

###### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/traversers/neighborrank
```

###### Request Body

```json
{
    "source":"O",
    "steps":[
        {
            "direction":"OUT",
            "labels":[
                "follow"
            ],
            "max_degree":-1,
            "top":100
        },
        {
            "direction":"OUT",
            "labels":[
                "follow",
                "like"
            ],
            "max_degree":-1,
            "top":100
        },
        {
            "direction":"OUT",
            "labels":[
                "directedBy"
            ],
            "max_degree":-1,
            "top":100
        }
    ],
    "alpha":0.9,
    "capacity":-1
}
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "ranks": [
        {
            "O": 1
        },
        {
            "B": 0.4305,
            "A": 0.3,
            "C": 0.3
        },
        {
            "G": 0.17550000000000002,
            "H": 0.17550000000000002,
            "I": 0.135,
            "J": 0.135,
            "E": 0.09000000000000001,
            "F": 0.09000000000000001
        },
        {
            "M": 0.15795,
            "K": 0.08100000000000002,
            "L": 0.04050000000000001
        }
    ]
}
```

##### 4.2.2.3 适用场景

为给定的起点在不同的层中找到最应该推荐的顶点。

- 比如：在观众、朋友、电影、导演的四层图结构中，根据某个观众的朋友们喜欢的电影，为这个观众推荐电影；或者根据这些电影是谁拍的，为其推荐导演。

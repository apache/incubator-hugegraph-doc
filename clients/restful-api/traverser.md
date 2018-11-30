### 3.1 遍历算法

#### 3.1.1 Shortest Path（根据起始顶点、目的顶点、方向、边的类型（可选）和最大深度，查找一条最短路径）

##### Params

- source: 起始顶点id
- target: 目的顶点id
- direction: 起始顶点到目的顶点的方向（OUT,IN,BOTH）
- max_depth: 最大深度
- label: 边的类型
- degree: 查询过程中，单个顶点最大边数目
- capacity: 遍历过程中最大的访问的顶点数目

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/shortestpath?source=1&target=12345&max_depth=5&direction=OUT
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "path": [
        1,
        27,
        76,
        582,
        12345
    ]
}
```

#### 3.1.2 K-out（根据起始顶点、方向、边的类型（可选）和深度depth，查找从起始顶点出发恰好depth步可达的顶点）

##### Params

- source: 起始顶点id
- direction: 起始顶点向外发散的方向（OUT,IN,BOTH）
- depth: 步数
- label: 边的类型
- nearest: 默认为true，代表起始顶点到达结果顶点的最短路径长度为depth，不存在更短的路径；nearest为false时，代表起始顶点到结果顶点有一条长度为depth的路径（未必最短且可以有环）
- degree: 查询过程中，单个顶点最大边数目
- capacity: 遍历过程中最大的访问的顶点数目
- limit: 返回的顶点的最大数目

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/kout?source=1&depth=5&direction=OUT
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "vertices": [
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        2,
        20,
        21,
        ......
    ]
}
```

#### 3.1.3 K-neighbor（根据起始顶点、方向、边的类型（可选）和深度depth，查找包括起始顶点在内、depth步之内可达的所有顶点）

> 相当于：起始顶点、K-out(1)、K-out(2)、... 、K-out(depth)的并集

##### Params

- source: 起始顶点id
- direction: 起始顶点向外发散的方向（OUT,IN,BOTH）
- depth: 步数
- label: 边的类型
- degree: 查询过程中，单个顶点最大边数目
- limit: 返回的顶点的最大数目

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/kneighbor?source=1&depth=5&direction=OUT
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "vertices": [
        1,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        2,
        20,
        21,
        ......
    ]
}
```

#### 3.1.4 Paths（根据起始顶点、目的顶点、方向、边的类型（可选）和最大深度等条件查找所有路径）

##### Params

- source: 起始顶点id
- target: 目的顶点id
- direction: 起始顶点到目的顶点的方向（OUT,IN,BOTH）
- label: 边的类型
- max_depth: 最大深度
- degree: 查询过程中，单个顶点最大边数目
- capacity: 遍历过程中最大的访问的顶点数目
- limit: 返回的路径的最大数目

##### Method & Url

```
GET http://localhost:8080/graphs/{graph}/traversers/paths?source=1&target=12345&max_depth=5&direction=OUT
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "paths": [
        {
            "objects": [1, 83, 12345]
        },
        {
            "objects": [1, 27, 3284, 12345]
        },
        {
            "objects": [1, 45, 1193, 12345]
        },
        {
            "objects": [1, 25, 755, 10893, 12345]
        },
        ......
    ]
}
```

#### 3.1.5 Crosspoints（根据起始顶点、目的顶点、方向、边的类型（可选）和最大深度等条件查找相交点）

例如: 1 -> 25 -> 775 <- 16331 <- 12345, 相交点为"775"

##### Params

- source: 起始顶点id
- target: 目的顶点id
- direction: 起始顶点到目的顶点的方向, 目的点到起始点是反方向，BOTH时不考虑方向（等于Paths BOTH）
- label: 边的类型
- max_depth: 最大深度
- degree: 查询过程中，单个顶点最大边数目
- capacity: 遍历过程中最大的访问的顶点数目
- limit: 返回的路径的最大数目

##### Method & Url

```
GET http://localhost:8080/graphs/{graph}/traversers/crosspoints?source=1&target=12345&max_depth=5&direction=OUT
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "crosspoints": [
        {
            "crosspoint": 5413,
            "objects": [1, 27, 5413, 12345]
        },
        {
            "crosspoint": 775,
            "objects": [1, 25, 755, 16331, 12345]
        },
        ......
    ]
}
```

#### 3.1.6 Rings（根据起始顶点、方向、边的类型（可选）和最大深度等条件查找可达的环路）

例如: 1 -> 25 -> 775 -> 14690 -> 25, 其中环路为 25 -> 775 -> 14690 -> 25

##### Params

- source: 起始顶点id
- direction: 起始顶点发出的边的方向，BOTH时不考虑方向
- label: 边的类型
- depth: 最大深度
- degree: 查询过程中，单个顶点最大边数目
- capacity: 遍历过程中最大的访问的顶点数目
- limit: 返回的可到达环路的路径的最大数目

##### Method & Url

```
GET http://localhost:8080/graphs/{graph}/traversers/rings?source=1&direction=OUT&depth=5
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "rings": [
        {
            "objects": [1, 25, 775, 14690, 25]
        },
        ......
    ]
}
```

#### 3.1.7 Rays（根据起始顶点、方向、边的类型（可选）和最大深度等条件查找发散到边界顶点的路径）

例如: 1 -> 25 -> 775 -> 14690 -> 2289 -> 18379, 其中 18379 为边界顶点，即没有从 18379 发出的边

##### Params

- source: 起始顶点id
- direction: 起始顶点发出的边的方向，BOTH时不考虑方向
- label: 边的类型
- depth: 最大深度
- degree: 查询过程中，单个顶点最大边数目
- capacity: 遍历过程中最大的访问的顶点数目
- limit: 返回的路径的最大数目

##### Method & Url

```
GET http://localhost:8080/graphs/{graph}/traversers/rays?source=1&direction=OUT&depth=5
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "rays": [
        {
            "objects": [1, 25, 775, 14690, 2289, 18379]
        },
        ......
    ]
}
```

### 3.2 顶点批量查询

#### 3.2.1 根据顶点的id列表，批量查询顶点

##### Params

- ids: 要查询的顶点id列表

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/vertices?ids="5:java-1"&ids="5:java-2"&ids="5:java-3"&ids="5:java-4"&ids="5:java-5"
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "vertices": [
        {"id": "5:java-1", "label": "book", "type": "vertex", "properties":{"name":[{"id": "5:java-1>name",…},
        {"id": "5:java-2", "label": "book", "type": "vertex", "properties":{"name":[{"id": "5:java-2>name",…},
        {"id": "5:java-3", "label": "book", "type": "vertex", "properties":{"name":[{"id": "5:java-3>name",…},
        {"id": "5:java-4", "label": "book", "type": "vertex", "properties":{"name":[{"id": "5:java-4>name",…},
        {"id": "5:java-5", "label": "book", "type": "vertex", "properties":{"name":[{"id": "5:java-5>name",…}
    ]
}
```

#### 3.2.2 获取 Shard 信息

通过指定的分片大小split_size，获取顶点分片信息（可以与 3.2.3 中的 Scan 配合使用来获取顶点）。

##### Params

- split_size: 分片大小

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/vertices/shards?split_size=67108864
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "shards":[
        {
            "start": "0",
            "end": "2165893",
            "length": 0
        },
        {
            "start": "2165893",
            "end": "4331786",
            "length": 0
        },
        {
            "start": "4331786",
            "end": "6497679",
            "length": 0
        },
        {
            "start": "6497679",
            "end": "8663572",
            "length": 0
        },
        ......
    ]
}
```

#### 3.2.3 根据Shard信息批量获取顶点

通过指定的分片信息批量查询顶点（Shard信息的获取参见 3.2.2 Shard）。

##### Params

- start: 分片起始位置
- end: 分片结束位置

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/vertices/scan?start=554189328&end=692736660
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "vertices": [
        {"id": "5:java-1", "label": "book", "type": "vertex", "properties":{"name":[{"id": "5:java-1>name",…},
        {"id": "5:java-2", "label": "book", "type": "vertex", "properties":{"name":[{"id": "5:java-2>name",…},
        {"id": "5:java-3", "label": "book", "type": "vertex", "properties":{"name":[{"id": "5:java-3>name",…},
        {"id": "5:java-4", "label": "book", "type": "vertex", "properties":{"name":[{"id": "5:java-4>name",…},
        {"id": "5:java-5", "label": "book", "type": "vertex", "properties":{"name":[{"id": "5:java-5>name",…}
    ]
}
```

### 3.3 边批量查询

#### 3.3.1 根据边的id列表，批量查询边

##### Params

- ids: 要查询的边id列表

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/edges?ids="S1:josh>1>>S2:lop"&ids="S1:josh>1>>S2:ripple"
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "edges": [
        {
            "id": "S1:josh>1>>S2:lop",
            "label": "created",
            "type": "edge",
            "inVLabel": "software",
            "outVLabel": "person",
            "inV": "2:lop",
            "outV": "1:josh",
            "properties": {
                "date": "20091111",
                "weight": 0.4
            }
        },
        {
            "id": "S1:josh>1>>S2:ripple",
            "label": "created",
            "type": "edge",
            "inVLabel": "software",
            "outVLabel": "person",
            "inV": "2:ripple",
            "outV": "1:josh",
            "properties": {
                "date": "20171210",
                "weight": 1
            }
        }
    ]
}
```

#### 3.3.2 获取边 Shard 信息

通过指定的分片大小split_size，获取边分片信息（可以与 3.3.3 中的 Scan 配合使用来获取边）。

##### Params

- split_size: 分片大小

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/edges/shards?split_size=1048576
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "shards":[
        {
            "start": "0",
            "end": "1073741823",
            "length": 0
        },
        {
            "start": "1073741823",
            "end": "2147483646",
            "length": 0
        },
        {
            "start": "2147483646",
            "end": "3221225469",
            "length": 0
        },
        {
            "start": "3221225469",
            "end": "4294967292",
            "length": 0
        },
        {
            "start": "4294967292",
            "end": "4294967295",
            "length": 0
        }
    ]
}
```

#### 3.3.3 根据Shard信息批量获取边

通过指定的分片信息批量查询边（Shard信息的获取参见 3.3.2）。

##### Params

- start: 分片起始位置
- end: 分片结束位置

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/edges/scan?start=2147483646&end=3221225469
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "edges": [
        {
            "id": "S1:peter>2>>S2:lop",
            "label": "created",
            "type": "edge",
            "inVLabel": "software",
            "outVLabel": "person",
            "inV": "2:lop",
            "outV": "1:peter",
            "properties": {
                "weight": 0.2,
                "date": "20170324"
            }
        },
        {
            "id": "S1:josh>1>>S2:lop",
            "label": "created",
            "type": "edge",
            "inVLabel": "software",
            "outVLabel": "person",
            "inV": "2:lop",
            "outV": "1:josh",
            "properties": {
                "date": "20091111",
                "weight": 0.4
            }
        },
        {
            "id": "S1:josh>1>>S2:ripple",
            "label": "created",
            "type": "edge",
            "inVLabel": "software",
            "outVLabel": "person",
            "inV": "2:ripple",
            "outV": "1:josh",
            "properties": {
                "date": "20171210",
                "weight": 1
            }
        },
        ......
    ]
}
```

### 3.1 遍历算法

#### 3.1.1 Shortest Path（根据起始顶点、目的顶点、方向、边的类型（可选）和最大深度，查找一条最短路径）

##### Method

```
GET
```

##### Params

- source: 起始顶点id
- target: 目的顶点id
- direction: 起始顶点到目的顶点的方向（OUT,IN,BOTH）
- max_depth: 最大深度
- label: 边的类型

##### Url

```
http://localhost:8080/graphs/hugegraph/traversers/shortestpath?source=1&target=12345&max_depth=5&direction=OUT
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

##### Method

```
GET
```

##### Params

- source: 起始顶点id
- direction: 起始顶点向外发散的方向（OUT,IN,BOTH）
- depth: 步数
- label: 边的类型
- nearest: 默认为true，代表起始顶点到达结果顶点的最短路径长度为depth，不存在更短的路径；nearest为false时，代表起始顶点到结果顶点有一条长度为depth的路径（未必最短且可以有环）

##### Url

```
http://localhost:8080/graphs/hugegraph/traversers/kout?source=1&depth=5&direction=OUT
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

##### Method

```
GET
```

##### Params

- source: 起始顶点id
- direction: 起始顶点向外发散的方向（OUT,IN,BOTH）
- depth: 步数
- label: 边的类型

##### Url

```
http://localhost:8080/graphs/hugegraph/traversers/kneighbor?source=1&depth=5&direction=OUT
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

### 3.2 批量查询

#### 3.2.1 根据顶点的id列表，批量查询顶点

##### Method

```
GET
```

##### Params

- ids: 要查询的顶点id列表

##### Url

```
http://localhost:8080/graphs/hugegraph/traversers/vertices?ids="5:java-1"&ids="5:java-2"&ids="5:java-3"&ids="5:java-4"&ids="5:java-5"
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

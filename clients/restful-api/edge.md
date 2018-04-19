### 2.2 Edge

顶点 id 格式的修改也影响到了边的 Id 以及源顶点和目标顶点 id 的格式。

EdgeId是由 `src-vertex-id + direction + label + sort-values + tgt-vertex-id` 拼接而成，
但是这里的顶点id不是通过带不带引号区分的，而是通过前缀区分：

- 当 id 类型为 number 时，EdgeId 的顶点 id 前有一个前缀`L` ，形如 "L123456>1>>L987654"
- 当 id 类型为 string 时，EdgeId 的顶点 id 前有一个前缀`S` ，形如 "S1:peter>1>>S2:lop"

--------------------------------------------------------------------------------

假设已经创建好了上述的各种schema和vertex

#### 2.2.1 创建一条边

##### Method

```
POST
```

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/edges
```

##### Request Body

```
{
    "label":"created",
    "outV":"1:peter",
    "inV":"2:lop",
    "outVLabel":"person",
    "inVLabel":"software",
    "properties":{
    "date": "2017-5-18",
    "weight": 0.2
    }
}
```

##### Response Status

```
201
```

##### Response Body

```
{
    "id": "S1:peter>1>>S2:lop",
    "label": "created",
    "type": "edge",
    "inVLabel": "software",
    "outVLabel": "person",
    "inV": "2:lop",
    "outV": "1:peter",
    "properties": {
        "date": "2017-5-18",
        "weight": 0.2
    }
}
```

#### 2.2.2 创建多条边

##### Method

```
POST
```

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/edges/batch
```

##### Request Body

```
[
    {
        "label": "created",
        "outV": "1:peter",
        "inV": "2:lop",
        "outVLabel": "person",
        "inVLabel": "software",
        "properties": {
            "date": "2017-5-18",
            "weight": 0.2
        }
    },
    {
        "label": "knows",
        "outV": "1:marko",
        "inV": "1:vadas",
        "outVLabel": "person",
        "inVLabel": "person",
        "properties": {
            "date": "2016-01-10",
            "weight": 0.5
        }
    }
]
```

##### Response Status

```
201
```

##### Response Body

```
[
    "S1:peter>1>>S2:lop",
    "S1:marko>2>>S1:vadas"
]
```

#### 2.2.3 更新边属性

##### Method

```
PUT
```

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/edges/S1:peter>1>>S2:lop?action=append
```

##### Request Body

```
{
    "properties":{
        "weight": 1.0
    }
}
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "S1:peter>1>>S2:lop",
    "label": "created",
    "type": "edge",
    "inVLabel": "software",
    "outVLabel": "person",
    "inV": "2:lop",
    "outV": "1:peter",
    "properties": {
        "date": "2017-5-18",
        "weight": 1
    }
}
```

#### 2.2.4 删除边属性

##### Method

```
PUT
```

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/edges/S1:peter>1>>S2:lop?action=eliminate
```

##### Request Body

```
{
    "properties":{
        "weight": 1.0
    }
}
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "S1:peter>1>>S2:lop",
    "label": "created",
    "type": "edge",
    "inVLabel": "software",
    "outVLabel": "person",
    "inV": "2:lop",
    "outV": "1:peter",
    "properties": {
        "date": "20170324"
    }
}
```

#### 2.2.5 获取符合条件的边

##### Method

```
GET
```

##### Params

- vertex_id: 顶点id
- direction: 边的方向(OUT | IN | BOTH)
- label: 边的标签
- properties: 属性键值对(必须是建了索引的)
- limit: 查询数目

其中vertex_id和direction如果要出现，则必须同时出现

##### Url

```
查询顶点 person:josh 的所有 created 边
http://127.0.0.1:8080/graphs/hugegraph/graph/edges?vertex_id="1:josh"&direction=BOTH&label=created&properties={}
```

##### Response Status

```
200
```

##### Response Body

```
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

#### 2.2.6 根据Id获取边

##### Method

```
GET
```

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/edges/S1:peter>1>>S2:lop
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "S1:peter>1>>S2:lop",
    "label": "created",
    "type": "edge",
    "inVLabel": "software",
    "outVLabel": "person",
    "inV": "2:lop",
    "outV": "1:peter",
    "properties": {
        "date": "2017-5-18",
        "weight": 0.2
    }
}
```

#### 2.2.7 根据Id删除边

##### Method

```
DELETE
```

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/edges/S1:peter>1>>S2:lop
```

##### Response Status

```
204
```
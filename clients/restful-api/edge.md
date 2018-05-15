### 2.2 Edge

顶点 id 格式的修改也影响到了边的 Id 以及源顶点和目标顶点 id 的格式。

EdgeId是由 `src-vertex-id + direction + label + sort-values + tgt-vertex-id` 拼接而成，
但是这里的顶点id类型不是通过引号区分的，而是根据前缀区分：

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

```json
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
}
```

##### Response Status

```json
201
```

##### Response Body

```json
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

```json
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

```json
201
```

##### Response Body

```json
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

```json
{
    "properties": {
        "weight": 1.0
    }
}
```

> 注意：属性的取值是有三种类别的，分别是single、set和list。如果是single，表示增加或更新属性值；如果是set或list，则表示追加属性值。

##### Response Status

```json
200
```

##### Response Body

```json
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

```json
{
    "properties": {
        "weight": 1.0
    }
}
```

> 注意：这里会直接删除属性（删除key和所有value），无论其属性的取值是single、set或list。

##### Response Status

```json
200
```

##### Response Body

```json
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
- properties: 属性键值对(根据属性查询的前提是建立了索引)
- limit: 查询数目
- page: 页号

vertex_id为可选参数，如果提供参数vertex_id则必须同时提供参数direction。无vertex_id参数时表示获取所有边，可通过limit限制查询数目。与顶点查询类似，如果提供page参数，必须提供limit参数，不允许带其他参数。

**查询与顶点 person:josh(vertex_id="1:josh") 相连且 label 为 created 的边**

##### Url

```
http://127.0.0.1:8080/graphs/hugegraph/graph/edges?vertex_id="1:josh"&direction=BOTH&label=created&properties={}
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

**分页查询所有边，获取第一页（page不带参数值），限定3条**

##### Url

```
http://127.0.0.1:8080/graphs/hugegraph/graph/edges?page&limit=3
```

##### Response Status

```json
200
```

##### Response Body

```json
{
	"edges": [{
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
			"id": "S1:josh>2>>S2:lop",
			"label": "created",
			"type": "edge",
			"inVLabel": "software",
			"outVLabel": "person",
			"inV": "2:lop",
			"outV": "1:josh",
			"properties": {
				"weight": 0.4,
				"date": "20091111"
			}
		},
		{
			"id": "S1:josh>2>>S2:ripple",
			"label": "created",
			"type": "edge",
			"inVLabel": "software",
			"outVLabel": "person",
			"inV": "2:ripple",
			"outV": "1:josh",
			"properties": {
				"weight": 1,
				"date": "20171210"
			}
		}
	],
	"page": "002500100753313a6a6f73681210010004000000020953323a726970706c65f07ffffffcf07ffffffd8460d63f4b398dd2721ed4fdb7716b420004"
}
```

返回的body里面是带有下一页的页号信息的，`"page": "002500100753313a6a6f73681210010004000000020953323a726970706c65f07ffffffcf07ffffffd8460d63f4b398dd2721ed4fdb7716b420004"`，
在查询下一页的时候将该值赋给page参数。

**分页查询所有边，获取下一页（page带上上一页返回的page值），限定3条**

##### Url

```
http://127.0.0.1:8080/graphs/hugegraph/graph/edges?page=002500100753313a6a6f73681210010004000000020953323a726970706c65f07ffffffcf07ffffffd8460d63f4b398dd2721ed4fdb7716b420004&limit=3
```

##### Response Status

```json
200
```

##### Response Body

```json
{
	"edges": [{
			"id": "S1:marko>1>20130220>S1:josh",
			"label": "knows",
			"type": "edge",
			"inVLabel": "person",
			"outVLabel": "person",
			"inV": "1:josh",
			"outV": "1:marko",
			"properties": {
				"weight": 1,
				"date": "20130220"
			}
		},
		{
			"id": "S1:marko>1>20160110>S1:vadas",
			"label": "knows",
			"type": "edge",
			"inVLabel": "person",
			"outVLabel": "person",
			"inV": "1:vadas",
			"outV": "1:marko",
			"properties": {
				"weight": 0.5,
				"date": "20160110"
			}
		},
		{
			"id": "S1:marko>2>>S2:lop",
			"label": "created",
			"type": "edge",
			"inVLabel": "software",
			"outVLabel": "person",
			"inV": "2:lop",
			"outV": "1:marko",
			"properties": {
				"weight": 0.4,
				"date": "20171210"
			}
		}
	],
	"page": "null"
}
```

此时`"page": "null"`表示已经没有下一页了。

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

```json
200
```

##### Response Body

```json
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

```json
204
```
### 2.2 Edge

顶点 id 格式的修改也影响到了边的 Id 以及源顶点和目标顶点 id 的格式。

EdgeId是由 `src-vertex-id + direction + label + sort-values + tgt-vertex-id` 拼接而成，
但是这里的顶点id类型不是通过引号区分的，而是根据前缀区分：

- 当 id 类型为 number 时，EdgeId 的顶点 id 前有一个前缀`L` ，形如 "L123456>1>>L987654"
- 当 id 类型为 string 时，EdgeId 的顶点 id 前有一个前缀`S` ，形如 "S1:peter>1>>S2:lop"

--------------------------------------------------------------------------------

接下来的示例均假设已经创建好了前述的各种schema和vertex信息

#### 2.2.1 创建边

##### 功能介绍
创建一条边

##### Method & Url

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/edges
```

##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |

##### Body参数
| 名称               | 是否必填  | 类型         | 默认值  | 取值范围               | 说明                               |
| ------------------ | -------- | ------------ | ------ | --------------------- | ---------------------------------- |
| label              | 是       | String       |        |                       | 边类型名称                          |
| outV               | 是       | String       |        |                       | 源顶点Id                            |
| intV               | 是       | String       |        |                       | 目标顶点Id                          |
| outVLabel          | 是       | String       |        |                       | 源顶点类型                           |
| intVLabel          | 是       | String       |        |                       | 目标顶点类型                         |
| properties         | 否       | Map          |        |                       | 边关联的属性，可以有多组              |


##### Response
| 名称               | 类型         | 说明                                |
| ------------------ | ------------ | ---------------------------------- |
| id                 | String       | 边Id                               |
| label              | String       | 边类型名称                          |
| outV               | String       | 源顶点Id                           |
| intV               | String       | 目标顶点Id                          |
| outVLabel          | String       | 源顶点类型                          |
| intVLabel          | String       | 目标顶点类型                        |
| properties         | Map          | 边关联的属性，可以有多组             |

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

##### 功能介绍
创建多条边

##### Method & Url

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/edges/batch?check_vertex={check_vertex}
```

##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |

##### Body参数
| 名称               | 是否必填  | 类型         | 默认值  | 取值范围               | 说明                               |
| ------------------ | -------- | ------------ | ------ | --------------------- | ---------------------------------- |
|                    | 是       | List[Map]    |        |                       | 待创建边的列表
| label              | 是       | String       |        |                       | 边类型名称                          |
| outV               | 是       | String       |        |                       | 源顶点Id                            |
| intV               | 是       | String       |        |                       | 目标顶点Id                          |
| outVLabel          | 是       | String       |        |                       | 源顶点类型                           |
| intVLabel          | 是       | String       |        |                       | 目标顶点类型                         |
| properties         | 否       | Map          |        |                       | 边关联的属性，可以有多组              |
| check_vertex       | 否       | Boolean      | true   | true, false           | 是否检查顶点存在，当设置为 true 而待插入边的源顶点或目标顶点不存在时会报错。 |


##### Response
| 名称               | 类型         | 说明                                |
| ------------------ | ------------ | ---------------------------------- |
|                    | List[String] | 边的Id列表                               |

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

##### Method & Url

```
PUT http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/edges/{edgeId}?action=append
```
##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |
| edgeId     | 是       | String |        |          | 边Id，例如 S1:peter>1>>S2:lop |

##### Body参数
| 名称               | 是否必填  | 类型         | 默认值  | 取值范围               | 说明                               |
| ------------------ | -------- | ------------ | ------ | --------------------- | ---------------------------------- |
| properties         | 否       | Map          |        |                       | 待更新的边关联的属性，可以有多组      |


##### Response
| 名称               | 类型         | 说明                                |
| ------------------ | ------------ | ---------------------------------- |
| id                 | String       | 边Id                               |
| label              | String       | 边类型名称                          |
| outV               | String       | 源顶点Id                           |
| intV               | String       | 目标顶点Id                          |
| outVLabel          | String       | 源顶点类型                          |
| intVLabel          | String       | 目标顶点类型                        |
| properties         | Map          | 边关联的属性，可以有多组             |

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

#### 2.2.4 批量更新边属性

###### 功能介绍

与批量更新顶点属性类似

假设原边及属性为：

```json
{
    "edges":[
        {
            "id":"S1:josh>2>>S2:ripple",
            "label":"created",
            "type":"edge",
            "outV":"1:josh",
            "outVLabel":"person",
            "inV":"2:ripple",
            "inVLabel":"software",
            "properties":{
                "weight":1,
                "date":1512835200000
            }
        },
        {
            "id":"S1:marko>1>7JooBil0>S1:josh",
            "label":"knows",
            "type":"edge",
            "outV":"1:marko",
            "outVLabel":"person",
            "inV":"1:josh",
            "inVLabel":"person",
            "properties":{
                "weight":1,
                "date":1361289600000
            }
        }
    ]
}
```

##### Method & Url

```
PUT http://127.0.0.1:8080/graphspaces/{graphspace}/graphs/{hugegraph}/edges/batch
```
##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |

##### Body参数
| 名称               | 是否必填  | 类型         | 默认值  | 取值范围               | 说明                               |
| ------------------ | -------- | ------------ | ------ | --------------------- | ---------------------------------- |
| edges              | 是       | List[Map]    |        |                       | 待更新的边的列表                     |
| label              | 是       | String       |        |                       | 边类型名称                          |
| outV               | 是       | String       |        |                       | 源顶点Id                            |
| intV               | 是       | String       |        |                       | 目标顶点Id                          |
| outVLabel          | 是       | String       |        |                       | 源顶点类型                           |
| intVLabel          | 是       | String       |        |                       | 目标顶点类型                         |
| properties         | 否       | Map          |        |                       | 边关联的属性，可以有多组              |
| update_strategies  | 否       | Map          |        |                       | 根据不同的标签对应的更新策略          |
| check_vertex       | 否       | Boolean      | true   | true, false           | 是否检查顶点存在，当设置为 true 而待插入边的源顶点或目标顶点不存在时会报错。 |
| create_if_not_exist| 否       | Boolean      | true   | true, false           | 在边不存在时自动创建新的边 |

##### Response
| 名称               | 类型         | 说明                                |
| ------------------ | ------------ | ---------------------------------- |
| id                 | String       | 边Id                               |
| label              | String       | 边类型名称                          |
| outV               | String       | 源顶点Id                           |
| intV               | String       | 目标顶点Id                          |
| outVLabel          | String       | 源顶点类型                          |
| intVLabel          | String       | 目标顶点类型                        |
| properties         | Map          | 边关联的属性，可以有多组             |

##### Request Body

```json
{
    "edges":[
        {
            "id":"S1:josh>2>>S2:ripple",
            "label":"created",
            "outV":"1:josh",
            "outVLabel":"person",
            "inV":"2:ripple",
            "inVLabel":"software",
            "properties":{
                "weight":0.1,
                "date":1522835200000
            }
        },
        {
            "id":"S1:marko>1>7JooBil0>S1:josh",
            "label":"knows",
            "outV":"1:marko",
            "outVLabel":"person",
            "inV":"1:josh",
            "inVLabel":"person",
            "properties":{
                "weight":0.2,
                "date":1301289600000
            }
        }
    ],
    "update_strategies":{
        "weight":"SUM",
        "date":"BIGGER"
    },
    "check_vertex": false,
    "create_if_not_exist":true
}
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "edges":[
        {
            "id":"S1:josh>2>>S2:ripple",
            "label":"created",
            "type":"edge",
            "outV":"1:josh",
            "outVLabel":"person",
            "inV":"2:ripple",
            "inVLabel":"software",
            "properties":{
                "weight":1.1,
                "date":1522835200000
            }
        },
        {
            "id":"S1:marko>1>7JooBil0>S1:josh",
            "label":"knows",
            "type":"edge",
            "outV":"1:marko",
            "outVLabel":"person",
            "inV":"1:josh",
            "inVLabel":"person",
            "properties":{
                "weight":1.2,
                "date":1301289600000
            }
        }
    ]
}
```

#### 2.2.5 删除边属性

##### Method & Url

```
PUT http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/edges/{edgeId}?action=eliminate
```
##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |
| edgeId     | 是       | String |        |          | 边Id，例如 S1:peter>1>>S2:lop |

##### Body参数
| 名称               | 是否必填  | 类型         | 默认值  | 取值范围               | 说明                               |
| ------------------ | -------- | ------------ | ------ | --------------------- | ---------------------------------- |
| properties         | 否       | Map          |        |                       | 边关联的属性，可以有多组              |

##### Response
| 名称               | 类型         | 说明                                |
| ------------------ | ------------ | ---------------------------------- |
| id                 | String       | 边Id                               |
| label              | String       | 边类型名称                          |
| outV               | String       | 源顶点Id                           |
| intV               | String       | 目标顶点Id                          |
| outVLabel          | String       | 源顶点类型                          |
| intVLabel          | String       | 目标顶点类型                        |
| properties         | Map          | 边关联的属性，可以有多组             |
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

#### 2.2.6 获取符合条件的边

##### 功能介绍

支持的查询有以下几种：

- 提供vertex_id参数时，不可以使用参数page，direction、label、properties可选，offset和limit可以
限制结果范围
- 不提供vertex_id参数时，label和properties可选
    - 如果使用page参数，则：offset参数不可用（不填或者为0），direction不可用，properties最多只能有一个
    - 如果不使用page参数，则：offset和limit可以用来限制结果范围，direction参数忽略

属性键值对由JSON格式的属性名称和属性值组成，允许多个属性键值对作为查询条件，属性值支持精确匹配和范围匹配，精确匹配时形如`properties={"weight":0.8}`，范围匹配时形如`properties={"age":"P.gt(0.8)"}`,范围匹配支持的表达式如下：

表达式           | 说明
---------------- | -------
P.eq(number)     | 属性值等于number的边
P.neq(number)    | 属性值不等于number的边
P.lt(number)     | 属性值小于number的边
P.lte(number)    | 属性值小于等于number的边
P.gt(number)     | 属性值大于number的边
P.gte(number)    | 属性值大于等于number的边
P.between(number1,number2)            | 属性值大于等于number1且小于number2的边
P.inside(number1,number2)             | 属性值大于number1且小于number2的边
P.outside(number1,number2)            | 属性值小于number1且大于number2的边
P.within(value1,value2,value3,...)    | 属性值等于任何一个给定value的边

**查询与顶点 person:josh(vertex_id="1:josh") 相连且 label 为 created 的边**

##### Method & Url

```
GET http://127.0.0.1:8080/graphspaces/{graphspace}/graphs/{hugegraph}/edges?vertex_id={vertexId}&direction=BOTH&label=created&properties={}
```
##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围      | 说明       |
| ---------- | -------- | ------ | ------ | --------      | ---------- |
| graphspace | 是       | String |        |               | 图空间名称 |
| hugegraph  | 是       | String |        |               | 图名称     |
| vertexId   | 否       | String |        |               | 顶点Id，需要包含引号，例如"1:josh"  |
| direction  | 否       | String |        | IN, OUT, BOTH | 边的方向  |
| label      | 否       | String |        |               | 边的标签  |
| properties | 否       | String |        |               | 属性键值对(根据属性查询的前提是预先建立了索引) |
| offset     | 否       | Int    | 0      |               | 偏移      |
| limit      | 否       | Int    | 100    |               | 查询数目   |
| page       | 否       | String |        |               | 页号       |

##### Body参数
无

##### Response
| 名称               | 类型         | 说明                                |
| ------------------ | ------------ | ---------------------------------- |
| edges              | List[Map]    | 查询到的边的列表                    |
| id                 | String       | 边Id                               |
| label              | String       | 边类型名称                          |
| outV               | String       | 源顶点Id                           |
| intV               | String       | 目标顶点Id                          |
| outVLabel          | String       | 源顶点类型                          |
| intVLabel          | String       | 目标顶点类型                        |
| properties         | Map          | 边关联的属性，可以有多组             |

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

##### Method & Url

```
GET http://127.0.0.1:8080/graphspaces/{graphspace}/graphs/{hugegraph}/edges?page&limit=3
```
##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围      | 说明       |
| ---------- | -------- | ------ | ------ | --------      | ---------- |
| graphspace | 是       | String |        |               | 图空间名称 |
| hugegraph  | 是       | String |        |               | 图名称     |
| vertexId   | 否       | String |        |               | 顶点Id，需要包含引号，例如"1:josh"  |
| direction  | 否       | String |        | IN, OUT, BOTH | 边的方向  |
| label      | 否       | String |        |               | 边的标签  |
| properties | 否       | String |        |               | 属性键值对(根据属性查询的前提是预先建立了索引) |
| offset     | 否       | Int    | 0      |               | 偏移      |
| limit      | 否       | Int    | 100    |               | 查询数目   |
| page       | 否       | String |        |               | 页号       |

##### Body参数
无

##### Response
| 名称               | 类型         | 说明                                |
| ------------------ | ------------ | ---------------------------------- |
| edges              | List[Map]    | 查询到的边的列表                    |
| id                 | String       | 边Id                               |
| label              | String       | 边类型名称                          |
| outV               | String       | 源顶点Id                           |
| intV               | String       | 目标顶点Id                          |
| outVLabel          | String       | 源顶点类型                          |
| intVLabel          | String       | 目标顶点类型                        |
| properties         | Map          | 边关联的属性，可以有多组             |
| page               | String       | 页号，后续的分页查询可由该页号继续    |
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

##### Method & Url

```
GET http://127.0.0.1:8080/graphspaces/{graphspace}/graphs/{hugegraph}/edges?page=002500100753313a6a6f73681210010004000000020953323a726970706c65f07ffffffcf07ffffffd8460d63f4b398dd2721ed4fdb7716b420004&limit=3
```
##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围      | 说明       |
| ---------- | -------- | ------ | ------ | --------      | ---------- |
| graphspace | 是       | String |        |               | 图空间名称 |
| hugegraph  | 是       | String |        |               | 图名称     |
| vertexId   | 否       | String |        |               | 顶点Id，需要包含引号，例如"1:josh"  |
| direction  | 否       | String |        | IN, OUT, BOTH | 边的方向  |
| label      | 否       | String |        |               | 边的标签  |
| properties | 否       | String |        |               | 属性键值对(根据属性查询的前提是预先建立了索引) |
| offset     | 否       | Int    | 0      |               | 偏移      |
| limit      | 否       | Int    | 100    |               | 查询数目   |
| page       | 否       | String |        |               | 页号       |

##### Body参数
无

##### Response
| 名称               | 类型         | 说明                                |
| ------------------ | ------------ | ---------------------------------- |
| edges              | List[Map]    | 查询到的边的列表                    |
| id                 | String       | 边Id                               |
| label              | String       | 边类型名称                          |
| outV               | String       | 源顶点Id                           |
| intV               | String       | 目标顶点Id                          |
| outVLabel          | String       | 源顶点类型                          |
| intVLabel          | String       | 目标顶点类型                        |
| properties         | Map          | 边关联的属性，可以有多组             |
| page               | String       | 页号，null表示后面没有更多的页了     |
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
	"page": null
}
```

此时`"page": null`表示已经没有下一页了 (注: 后端为 Cassandra 时，为了性能考虑，返回页恰好为最后一页时，返回 `page` 值可能非空，通过该 `page` 再请求下一页数据时则返回 `空数据` 及 `page = null`，其他情况类似)

#### 2.2.7 根据Id获取边

##### Method & Url

```
GET http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/edges/{edgeId}
```
##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围      | 说明       |
| ---------- | -------- | ------ | ------ | --------      | ---------- |
| graphspace | 是       | String |        |               | 图空间名称 |
| hugegraph  | 是       | String |        |               | 图名称     |
| edgeId     | 是       | String |        |               | 边Id，例如 S1:peter>1>>S2:lop |


##### Body参数
无

##### Response
| 名称               | 类型         | 说明                                |
| ------------------ | ------------ | ---------------------------------- |
| id                 | String       | 边Id                               |
| label              | String       | 边类型名称                          |
| outV               | String       | 源顶点Id                           |
| intV               | String       | 目标顶点Id                          |
| outVLabel          | String       | 源顶点类型                          |
| intVLabel          | String       | 目标顶点类型                        |
| properties         | Map          | 边关联的属性，可以有多组             |
| page               | String       | 页号，null表示后面没有更多的页了     |
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

#### 2.2.8 根据Id删除边


**仅根据Id删除边**

##### Method & Url

```
DELETE http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/edges/{edgeId}
```
##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围      | 说明       |
| ---------- | -------- | ------ | ------ | --------      | ---------- |
| graphspace | 是       | String |        |               | 图空间名称 |
| hugegraph  | 是       | String |        |               | 图名称     |
| edgeId     | 是       | String |        |               | 边Id，例如 S1:peter>1>>S2:lop |

##### Body参数
无

##### Response
无

##### Response Status

```json
204
```

**根据Label+Id删除边**

通过指定Label参数和Id来删除边时，一般来说其性能比仅根据Id删除会更好。

##### Method & Url

```
DELETE http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/edges/{edgeId}?label=person
```
##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围      | 说明       |
| ---------- | -------- | ------ | ------ | --------      | ---------- |
| graphspace | 是       | String |        |               | 图空间名称 |
| hugegraph  | 是       | String |        |               | 图名称     |
| edgeId     | 是       | String |        |               | 边Id，例如 S1:peter>1>>S2:lop |
| label      | 否       | String |        |               | 边的标签    |


##### Body参数
无

##### Response
无

##### Response Status

```json
204
```

#### 2.2.9 Edges

##### 2.2.9.1 根据边的id列表，批量查询边


###### Method & Url

```
GET http://localhost:8080//graphspaces/{graphspace}/graphs/{hugegraph}/traversers/edges?ids="S1:josh>1>>S2:lop"&ids="S1:josh>1>>S2:ripple"
```
##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围      | 说明       |
| ---------- | -------- | ------ | ------ | --------      | ---------- |
| graphspace | 是       | String |        |               | 图空间名称 |
| hugegraph  | 是       | String |        |               | 图名称     |
| ids        | 是       | String |        |               | 边Id列表，例如 S1:peter>1>>S2:lop，通过重复输入进行批量查询 |


##### Body参数
无

##### Response
| 名称               | 类型         | 说明                                |
| ------------------ | ------------ | ---------------------------------- |
| edges              | List[Map]    | 查询到的边的列表                    |
| id                 | String       | 边Id                               |
| label              | String       | 边类型名称                          |
| outV               | String       | 源顶点Id                           |
| intV               | String       | 目标顶点Id                          |
| outVLabel          | String       | 源顶点类型                          |
| intVLabel          | String       | 目标顶点类型                        |
| properties         | Map          | 边关联的属性，可以有多组             |
###### Response Status

```json
200
```

###### Response Body

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

##### 2.2.9.2 获取边 Shard 信息

##### 功能介绍
通过指定的分片大小split_size，获取边分片信息（可以与 3.2.22.3 中的 Scan 配合使用来获取边）。


###### Method & Url

```
GET http://localhost:8080//graphspaces/{graphspace}/graphs/{hugegraph}/traversers/edges/shards?split_size=4294967295
```
##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围      | 说明       |
| ---------- | -------- | ------ | ------ | --------      | ---------- |
| graphspace | 是       | String |        |               | 图空间名称 |
| hugegraph  | 是       | String |        |               | 图名称     |
| split_size | 是       | Int    |        |               | 分片的大小 |


##### Body参数
无

##### Response
| 名称               | 类型         | 说明                    |
| ------------------ | ------------ | ---------------------- |
| shard              | List[Map]    | 分片信息的类表          |
| start              | String       | 分片起始位置            |
| end                | String       | 分片结束位置（不包含）   |
| length             | Int          | 分片的长度              |


###### Response Status

```json
200
```

###### Response Body

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

##### 2.2.9.3 根据 Shard 信息批量获取边

##### 功能介绍
通过指定的分片信息批量查询边（Shard信息的获取参见 3.2.22.2）。

###### Method & Url

```
GET http://localhost:8080//graphspaces/{graphspace}/graphs/{hugegraph}/traversers/edges/scan?start=0&end=3221225469
```
##### URI参数
| 名称       | 是否必填  | 类型   | 默认值  | 取值范围  | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |
| start      | 是       | String |        |          | 分片起始位置           |
| end        | 是       | String |        |          | 分片结束位置           |
| page       | 否       | String | null   |          | 分页位置           |
| page_limit | 否       | Int    | 1000   |          | 分页获取边时，一页中边数目的上限          |


##### Body参数
无

##### Response
| 名称               | 类型         | 说明                                |
| ------------------ | ------------ | ---------------------------------- |
| edges              | List[Map]    | 查询到的边的列表                    |
| id                 | String       | 边Id                               |
| label              | String       | 边类型名称                          |
| outV               | String       | 源顶点Id                           |
| intV               | String       | 目标顶点Id                          |
| outVLabel          | String       | 源顶点类型                          |
| intVLabel          | String       | 目标顶点类型                        |
| properties         | Map          | 边关联的属性，可以有多组             |

###### Response Status

```json
200
```

###### Response Body

```json
{
    "edges":[
        {
            "id":"S1:peter>2>>S2:lop",
            "label":"created",
            "type":"edge",
            "inVLabel":"software",
            "outVLabel":"person",
            "inV":"2:lop",
            "outV":"1:peter",
            "properties":{
                "weight":0.2,
                "date":"20170324"
            }
        },
        {
            "id":"S1:josh>2>>S2:lop",
            "label":"created",
            "type":"edge",
            "inVLabel":"software",
            "outVLabel":"person",
            "inV":"2:lop",
            "outV":"1:josh",
            "properties":{
                "weight":0.4,
                "date":"20091111"
            }
        },
        {
            "id":"S1:josh>2>>S2:ripple",
            "label":"created",
            "type":"edge",
            "inVLabel":"software",
            "outVLabel":"person",
            "inV":"2:ripple",
            "outV":"1:josh",
            "properties":{
                "weight":1,
                "date":"20171210"
            }
        },
        {
            "id":"S1:marko>1>20130220>S1:josh",
            "label":"knows",
            "type":"edge",
            "inVLabel":"person",
            "outVLabel":"person",
            "inV":"1:josh",
            "outV":"1:marko",
            "properties":{
                "weight":1,
                "date":"20130220"
            }
        },
        {
            "id":"S1:marko>1>20160110>S1:vadas",
            "label":"knows",
            "type":"edge",
            "inVLabel":"person",
            "outVLabel":"person",
            "inV":"1:vadas",
            "outV":"1:marko",
            "properties":{
                "weight":0.5,
                "date":"20160110"
            }
        },
        {
            "id":"S1:marko>2>>S2:lop",
            "label":"created",
            "type":"edge",
            "inVLabel":"software",
            "outVLabel":"person",
            "inV":"2:lop",
            "outV":"1:marko",
            "properties":{
                "weight":0.4,
                "date":"20171210"
            }
        }
    ]
}
```

##### 2.2.9.4 适用场景

- 按id列表查询边，可用于批量查询边
- 获取分片和按分片查询边，可以用来遍历全部边

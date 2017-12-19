## 1. HugeGraph Restful API

HugeGraph Server通过HugeGraph-Api基于HTTP协议为Client提供操作图的接口，主要包括元数据和图数据增删改查。

## 2. 元数据

### 2.1 PropertyKey

#### 2.1.1 Post

功能：创建一个 PropertyKey

##### Url
```
localhost:8080/graphs/hugegraph/schema/propertykeys
```

##### Request Body
```
{
    "name": "age",
    "dataType": "INT",
    "cardinality": "SINGLE"
}
```

##### Response Status

```
201
```

##### Response Body

```
{
    "id": "3age",
    "name": "age",
    "dataType": "INT",
    "cardinality": "SINGLE",
    "properties": []
}
```
        
#### 2.1.2 Get(List)

功能：获取所有的 PropertyKey

##### Url

```
localhost:8080/graphs/hugegraph/schema/propertykeys
```

##### Response Status

```
200
```

##### Response Body

```
{
    "propertykeys": [
        {
            "id": "3city",
            "name": "city",
            "data_type": "TEXT",
            "cardinality": "SINGLE",
            "properties": []
        },
        {
            "id": "3age",
            "name": "age",
            "data_type": "INT",
            "cardinality": "SINGLE",
            "properties": []
        },
        {
            "id": "3lang",
            "name": "lang",
            "data_type": "TEXT",
            "cardinality": "SINGLE",
            "properties": []
        },
        {
            "id": "3weight",
            "name": "weight",
            "data_type": "DOUBLE",
            "cardinality": "SINGLE",
            "properties": []
        },
        {
            "id": "3date",
            "name": "date",
            "data_type": "TEXT",
            "cardinality": "SINGLE",
            "properties": []
        },
        {
            "id": "3name",
            "name": "name",
            "data_type": "TEXT",
            "cardinality": "SINGLE",
            "properties": []
        },
        {
            "id": "3price",
            "name": "price",
            "data_type": "INT",
            "cardinality": "SINGLE",
            "properties": []
        }
    ]
}
```

#### 2.1.3 Get

功能：根据name获取PropertyKey

##### Url

```
localhost:8080/graphs/hugegraph/schema/propertykeys/age
```

其中，`id`为要获取的PropertyKey的名字

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "3age",
    "name": "age",
    "dataType": "INT",
    "cardinality": "SINGLE",
    "properties": []
}
```

#### 2.1.4 Delete

功能：根据name删除PropertyKey

##### Url

```
localhost:8080/graphs/hugegraph/schema/propertykeys/age
```

其中，`id`为要获取的PropertyKey的名字

##### Response Status

```
204
```

### 2.2 VertexLabel

假设已经创建好了2.1.2中列出来的那些 PropertyKeys

#### 2.2.1 Post

功能：创建一个VertexLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/vertexlabels
```

##### Request Body

```
{
    "name": "person",
    "id_strategy": "DEFAULT",
    "properties": [
        "name",
        "age"
    ],
    "primary_keys": [
        "name"
    ],
    "nullable_keys": []
}
```

##### Response Status

```
201
```

##### Response Body

```
{
    "id": "1person",
    "primary_keys": [
        "name"
    ],
    "id_strategy": "PRIMARY_KEY",
    "name": "person2",
    "index_names": [
    ],
    "properties": [
        "name",
        "age"
    ],
    "nullable_keys": [
    ]
}
```

#### 2.2.2 Put

功能：为已存在的VertexLabel添加属性，目前不支持移除属性

##### Url

```
http://localhost:8080/graphs/hugegraph/schema/vertexlabels/person?action=append
```

注意：这个url是带有参数的

##### Request Body

```
{
    "name": "person",
    "properties": [
        "city"
    ],
    "nullable_keys": ["city"]
}
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "1person",
    "primary_keys": [
        "name"
    ],
    "id_strategy": "PRIMARY_KEY",
    "name": "person",
    "index_names": [
    ],
    "properties": [
        "city",
        "name",
        "age"
    ],
    "nullable_keys": [
        "city"
    ]
}
```

#### 2.2.3 Get(List)

功能：获取所有的VertexLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/vertexlabels
```

##### Response Status

```
200
```

##### Response Body

```
{
    "vertexlabels": [
        {
            "id": "1person",
            "primary_keys": [
                "name"
            ],
            "id_strategy": "PRIMARY_KEY",
            "name": "person",
            "index_names": [
            ],
            "properties": [
                "city",
                "name",
                "age"
            ],
            "nullable_keys": [
                "city"
            ]
        },
        {
            "id": "1software",
            "primary_keys": [
                "name"
            ],
            "id_strategy": "PRIMARY_KEY",
            "name": "software",
            "index_names": [
            ],
            "properties": [
                "price",
                "name",
                "lang"
            ],
            "nullable_keys": [
                "price"
            ]
        }
    ]
}
```

#### 2.2.4 Get

功能：根据name获取VertexLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/vertexlabels/person
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "1person",
    "primary_keys": [
        "name"
    ],
    "id_strategy": "PRIMARY_KEY",
    "name": "person",
    "index_names": [
    ],
    "properties": [
        "city",
        "name",
        "age"
    ],
    "nullable_keys": [
        "city"
    ]
}
```

#### 2.2.5 Delete

功能：根据name删除VertexLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/vertexlabels/person
```

##### Response Status

```
204
```

### 2.3 EdgeLabel

假设已经创建好了2.1.2中的 PropertyKeys 和 2.2.2中的 VertexLabels

#### 2.3.1 Post

功能：创建一个EdgeLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/edgelabels
```

##### Request Body

```
{
    "name": "created",
    "source_label": "person",
    "target_label": "software",
    "frequency": "SINGLE",
    "properties": [
        "date"
    ],
    "sort_keys": [],
    "nullable_keys": []
}
```

##### Response Status

```
201
```

##### Response Body

```
{
    "id": "2created",
    "sort_keys": [
    ],
    "source_label": "person",
    "name": "created",
    "index_names": [
    ],
    "properties": [
        "date"
    ],
    "target_label": "software",
    "frequency": "SINGLE",
    "nullable_keys": [
    ]
}
```

#### 2.3.2 Put

功能：为已存在的EdgeLabel添加properties

##### Url

```
localhost:8080/graphs/hugegraph/schema/edgelabels?action=append
```

##### Request Body

```
{
    "name": "created",
    "properties": [
        "weight"
    ],
	"nullable_keys": [
        "weight"
    ]
}
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "2created",
    "sort_keys": [
    ],
    "source_label": "person",
    "name": "created",
    "index_names": [
    ],
    "properties": [
        "date",
        "weight"
    ],
    "target_label": "software",
    "frequency": "SINGLE",
    "nullable_keys": [
        "weight"
    ]
}

```

#### 2.3.3 Get(List)

功能：获取所有的EdgeLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/edgelabels
```

##### Response Status

```
200
```

##### Response Body

```
{
    "edgelabels": [
        {
            "id": "2created",
            "sort_keys": [
            ],
            "source_label": "person",
            "name": "created",
            "index_names": [
            ],
            "properties": [
                "date",
                "weight"
            ],
            "target_label": "software",
            "frequency": "SINGLE",
            "nullable_keys": [
                "weight"
            ]
        },
        {
            "id": "2knows",
            "sort_keys": [
            ],
            "source_label": "person",
            "name": "knows",
            "index_names": [
            ],
            "properties": [
                "date",
                "weight"
            ],
            "target_label": "person",
            "frequency": "SINGLE",
            "nullable_keys": [
            ]
        }
    ]
}
```

#### 2.3.4 Get

功能：根据name获取EdgeLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/edgelabels/created
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "2created",
    "sort_keys": [
    ],
    "source_label": "person",
    "name": "created",
    "index_names": [
    ],
    "properties": [
        "date",
        "city",
        "weight"
    ],
    "target_label": "software",
    "frequency": "SINGLE",
    "nullable_keys": [
        "city",
        "weight"
    ]
}
```

#### 2.3.5 Delete

功能：根据name删除EdgeLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/edgelabels/created
```

##### Response Status

```
204
```

### 2.4 IndexLabel

假设已经创建好了2.1.2中的 PropertyKeys 、2.2.2中的 VertexLabels 以及 2.3.2中的 EdgeLabels

#### 2.3.1 Post

功能：创建一个IndexLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/indexlabels
```

##### Request Body

```
{
    "name": "personByCity",
    "base_type": "VERTEX_LABEL",
    "base_value": "person",
    "index_type": "SECONDARY",
    "fields": [
        "city"
    ]
}
```

##### Response Status

```
201
```

##### Response Body

```
{
    "id": "4personByCity",
    "base_type": "VERTEX_LABEL",
    "base_value": "person",
    "name": "personByCity",
    "fields": [
        "city"
    ],
    "index_type": "SECONDARY"
}
```

#### 2.3.2 Get(List)

功能：获取所有的IndexLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/indexlabels
```

##### Response Status

```
200
```

##### Response Body

```
{
    "indexlabels": [
        {
            "id": "4softwareByPrice",
            "base_type": "VERTEX_LABEL",
            "base_value": "software",
            "name": "softwareByPrice",
            "fields": [
                "price"
            ],
            "index_type": "SEARCH"
        },
        {
            "id": "4createdByDate",
            "base_type": "EDGE_LABEL",
            "base_value": "created",
            "name": "createdByDate",
            "fields": [
                "date"
            ],
            "index_type": "SECONDARY"
        },
        {
            "id": "4personByCity",
            "base_type": "VERTEX_LABEL",
            "base_value": "person",
            "name": "personByCity",
            "fields": [
                "city"
            ],
            "index_type": "SECONDARY"
        },
        {
            "id": "4personByAgeAndCity",
            "base_type": "VERTEX_LABEL",
            "base_value": "person",
            "name": "personByAgeAndCity",
            "fields": [
                "age",
                "city"
            ],
            "index_type": "SECONDARY"
        }
    ]
}
```

#### 2.3.3 Get

功能：根据name获取IndexLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/indexlabels/personByCity
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "4personByCity",
    "base_type": "VERTEX_LABEL",
    "base_value": "person",
    "name": "personByCity",
    "fields": [
        "city"
    ],
    "index_type": "SECONDARY"
}
```

#### 2.3.4 Delete

功能：根据name删除IndexLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/indexlabels/personByCity
```

##### Response Status

```
204
```

## 3. 图数据

### 3.1 Vertex

假设已经创建好了上述的各种schema

#### 3.1.1 Post(Single)

功能：创建一个顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/vertices
```

##### Request Body

```
{
    "label": "person",
    "properties": {
        "name": "marko",
        "age": 29
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
    "id": "person:marko",
    "label": "person",
    "type": "vertex",
    "properties": {
        "name": [
            {
                "id": "person:marko>name",
                "value": "marko"
            }
        ],
        "age": [
            {
                "id": "person:marko>age",
                "value": 29
            }
        ]
    }
}
```

#### 3.1.2 Post(Batch)

功能：创建多个顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/vertices/batch
```

##### Request Body

```
[
    {
        "label": "person",
        "properties": {
            "name": "marko",
            "age": 29
        }
    },
    {
        "label": "software",
        "properties": {
            "name": "ripple",
            "lang": "java",
            "price": 199
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
    "person:marko",
    "software:ripple"
]
```

#### 3.1.3 PUT(Vertex property update)

功能：更新顶点属性

##### Url

```
http://127.0.0.1:8080/graphs/hugegraph/graph/vertices/person:marko?action=append
```

##### Request Body

```
{
    "label": "person",
    "properties": {
        "age": 30,
        "city": "Beijing"
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
    "id": "person:marko",
    "label": "person",
    "type": "vertex",
    "properties": {
        "city": [
            {
                "id": "person:marko>city",
                "value": "Beijing"
            }
        ],
        "name": [
            {
                "id": "person:marko>name",
                "value": "marko"
            }
        ],
        "age": [
            {
                "id": "person:marko>age",
                "value": 30
            }
        ]
    }
}
```

#### 3.1.4 PUT(Vertex property delete)

功能：删除顶点属性

##### Url

```
http://127.0.0.1:8080/graphs/hugegraph/graph/vertices/person:marko?action=eliminate
```

##### Request Body

```
{
    "label": "person",
    "properties": {
        "city": "Beijing"
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
    "id": "person:marko",
    "label": "person",
    "type": "vertex",
    "properties": {
        "name": [
            {
                "id": "person:marko>name",
                "value": "marko"
            }
        ],
        "age": [
            {
                "id": "person:marko>age",
                "value": 30
            }
        ]
    }
}
```

#### 3.1.5 Get(List)

功能：获取符合条件的顶点

查询参数包括:

- label: 顶点标签

- properties: 属性键值对(必须是建了索引的)

- limit: 查询数目

以上参数都是可选的，且可以任意组合

##### Url

```
查询所有 age 为 20 的 person 顶点
http://localhost:8080/graphs/hugegraph/graph/vertices?label=person&properties={"age":29}limit=1
```

##### Response Status

```
200
```

##### Response Body

```
{
    "vertices": [
        {
            "id": "person:marko",
            "label": "person",
            "type": "vertex",
            "properties": {
                "city": [
                    {
                        "id": "person:marko>city",
                        "value": "Beijing"
                    }
                ],
                "name": [
                    {
                        "id": "person:marko>name",
                        "value": "marko"
                    }
                ],
                "age": [
                    {
                        "id": "person:marko>age",
                        "value": 29
                    }
                ]
            }
        }
    ]
}
```

#### 3.1.6 Get

功能：根据Id获取顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/vertices/person:marko
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "person:marko",
    "label": "person",
    "type": "vertex",
    "properties": {
        "name": [
            {
                "id": "person:marko>name",
                "value": "marko"
            }
        ],
        "age": [
            {
                "id": "person:marko>age",
                "value": 29
            }
        ]
    }
}
```

#### 3.1.7 Delete

功能：根据Id删除顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/vertices/person:marko
```

##### Response Status

```
204
```

### 3.2 Edge

假设已经创建好了上述的各种schema和vertex

#### 3.2.1 Post(Single)

功能：创建一条边

##### Url

```
localhost:8080/graphs/hugegraph/graph/edges
```

##### Request Body

```
{
  "label":"created",
  "outV":"person:peter",
  "inV":"software:lop",
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
    "id": "person:peter>created>>software:lop",
    "label": "created",
    "type": "edge",
    "inVLabel": "software",
    "outVLabel": "person",
    "inV": "software:lop",
    "outV": "person:peter",
    "properties": {
        "date": "2017-5-18",
        "weight": 0.2
    }
}
```

#### 3.2.2 Post(Batch)

功能：创建多条边

##### Url

```
localhost:8080/graphs/hugegraph/graph/edges/batch
```

##### Request Body

```
[
    {
        "label": "created",
        "outV": "person:peter",
        "inV": "software:lop",
        "outVLabel": "person",
        "inVLabel": "software",
        "properties": {
            "date": "2017-5-18",
            "weight": 0.2
        }
    },
    {
        "label": "knows",
        "outV": "person:marko",
        "inV": "person:vadas",
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
    "person:peter>created>>software:lop",
    "person:marko>knows>>person:vadas"
]
```

#### 3.2.3 PUT(Edge property update)

功能：更新边属性

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/edges/person:peter>created>>software:lop?action=append
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
    "id": "person:peter>created>>software:lop",
    "label": "created",
    "type": "edge",
    "inVLabel": "software",
    "outVLabel": "person",
    "inV": "software:lop",
    "outV": "person:peter",
    "properties": {
        "date": "2017-5-18",
        "weight": 1
    }
}
```

#### 3.1.4 PUT(Edge property delete)

功能：删除边属性

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/edges/person:peter>created>>software:lop?action=eliminate
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
    "id": "person:peter>created>>software:lop",
    "label": "created",
    "type": "edge",
    "inVLabel": "software",
    "outVLabel": "person",
    "inV": "software:lop",
    "outV": "person:peter",
    "properties": {
        "date": "20170324"
    }
}
```

#### 3.2.3 Get(List)

功能：获取符合条件的边

查询参数包括:

- vertex_id: 顶点id

- direction: 边的方向(OUT | IN | BOTH)

- label: 边的标签

- properties: 属性键值对(必须是建了索引的)

- limit: 查询数目

其中vertex_id和direction如果要出现，则必须同时出现

##### Url

```
查询顶点 person:josh 的所有 created 边
http://127.0.0.1:8080/graphs/hugegraph/graph/edges?vertex_id=person:josh&direction=BOTH&label=created&properties={}
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
            "id": "person:josh>created>>software:lop",
            "label": "created",
            "type": "edge",
            "inVLabel": "software",
            "outVLabel": "person",
            "inV": "software:lop",
            "outV": "person:josh",
            "properties": {
                "date": "20091111",
                "weight": 0.4
            }
        },
        {
            "id": "person:josh>created>>software:ripple",
            "label": "created",
            "type": "edge",
            "inVLabel": "software",
            "outVLabel": "person",
            "inV": "software:ripple",
            "outV": "person:josh",
            "properties": {
                "date": "20171210",
                "weight": 1
            }
        }
    ]
}
```

#### 3.2.3 Get

功能：根据Id获取边

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/edges/person:peter>created>>software:lop
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "person:peter>created>>software:lop",
    "label": "created",
    "type": "edge",
    "inVLabel": "software",
    "outVLabel": "person",
    "inV": "software:lop",
    "outV": "person:peter",
    "properties": {
        "date": "2017-5-18",
        "weight": 0.2
    }
}
```

#### 3.2.4 Delete

功能：根据Id删除顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/edges/person:peter>created>>software:lop
```

##### Response Status

```
204
```
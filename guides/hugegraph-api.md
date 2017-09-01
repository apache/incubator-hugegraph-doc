
## 1. HugeGraph-API Intro

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
    "name": "id",
    "dataType": "TEXT",
    "cardinality": "SINGLE",
    "properties": []
}
```

##### Response Status

```
201
```

##### Response Body

```
{
    "id": "3id",
    "dataType": "TEXT",
    "name": "id",
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
            "id": "3age",
            "dataType": "INT",
            "name": "age",
            "cardinality": "SINGLE",
            "properties": []
        },
        {
            "id": "3date",
            "dataType": "TEXT",
            "name": "date",
            "cardinality": "SINGLE",
            "properties": []
        },
        {
            "id": "3id",
            "dataType": "TEXT",
            "name": "id",
            "cardinality": "SINGLE",
            "properties":[]
        }
        {
            "id": "3name",
            "dataType": "TEXT",
            "name": "name",
            "cardinality": "SINGLE",
            "properties": []
        },
        {
            "id": "3price",
            "dataType": "INT",
            "name": "price",
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
localhost:8080/graphs/hugegraph/schema/propertykeys/id
```

其中，`id`为要获取的PropertyKey的名字

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "3id",
    "dataType": "TEXT",
    "name": "id",
    "cardinality": "SINGLE",
    "properties": []
}
```

#### 2.1.4 Delete

功能：根据name删除PropertyKey

##### Url

```
localhost:8080/graphs/hugegraph/schema/propertykeys/id
```

其中，`id`为要获取的PropertyKey的名字

##### Response Status

```
204
```

### 2.2 VertexLabel

#### 2.2.1 Post

功能：创建一个VertexLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/vertexlabels
```

##### Request Body

```
{
    "name": "software",
    "idStrategy": "PRIMARY_KEY",
    "properties": [
        "price",
        "name",
        "lang"
    ],
    "primaryKeys": [
        "name"
    ],
    "indexNames": []
}
```

##### Response Status

```
201
```

##### Response Body

```
{
    "id": "1software",
    "primaryKeys": [
        "name"
    ],
    "indexNames": [],
    "name": "software",
    "idStrategy": "PRIMARY_KEY",
    "properties": [
        "price",
        "name",
        "lang"
    ]
}
```

#### 2.2.2 Put

功能：为已存在的VertexLabel添加属性，目前不支持移除属性

##### Url

```
localhost:8080/graphs/hugegraph/schema/vertexlabels?action=append
```

注意：这个url是带有参数的

##### Request Body

```
{
    "name": "software",
    "idStrategy": "DEFAULT",
    "primaryKeys": [],
    "indexNames": [],
    "properties": [
        "city"
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
    "id": "1software",
    "primaryKeys": [
        "name"
    ],
    "indexNames": [],
    "name": "software",
    "idStrategy": "PRIMARY_KEY",
    "properties": [
        "city",
        "price",
        "name",
        "lang"
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
            "primaryKeys": [
                "name"
            ],
            "indexNames": [],
            "name": "person",
            "idStrategy": "PRIMARY_KEY",
            "properties": [
                "city",
                "name",
                "age"
            ]
        },
        {
            "id": "1software",
            "primaryKeys": [
                "name"
            ],
            "indexNames": [],
            "name": "software",
            "idStrategy": "PRIMARY_KEY",
            "properties": [
                "city",
                "price",
                "name",
                "lang"
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
    "primaryKeys": [
        "name"
    ],
    "indexNames": [],
    "name": "person",
    "idStrategy": "PRIMARY_KEY",
    "properties": [
        "city",
        "name",
        "age"
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
    "sourceLabel": "person",
    "targetLabel": "software",
    "frequency": "SINGLE",
    "properties": [
        "date"
    ],
    "indexNames": [],
    "sortKeys": []
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
    "sourceLabel": "person",
    "indexNames": [
        "createdByDate"
    ],
    "name": "created",
    "targetLabel": "software",
    "sortKeys": [],
    "properties": [
        "date"
    ],
    "frequency": "SINGLE"
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
    "sourceLabel": null,
    "targetLabel": null,
    "frequency": "DEFAULT",
    "properties": [
        "city"
    ],
    "indexNames": [],
    "sortKeys": []
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
    "sourceLabel": "person",
    "indexNames": [
        "createdByDate"
    ],
    "name": "created",
    "targetLabel": "software",
    "sortKeys": [],
    "properties": [
        "date",
        "city"
    ],
    "frequency": "SINGLE"
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
            "sourceLabel": "person",
            "indexNames": [
                "createdByDate",
                "createdByCity"
            ],
            "name": "created",
            "targetLabel": "software",
            "sortKeys": [],
            "properties": [
                "date",
                "city"
            ],
            "frequency": "SINGLE"
        },
        {
            "id": "2knows",
            "sourceLabel": "person",
            "indexNames": [],
            "name": "knows",
            "targetLabel": "person",
            "sortKeys": [],
            "properties": [
                "date",
                "price"
            ],
            "frequency": "SINGLE"
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
    "sourceLabel": "person",
    "indexNames": [],
    "name": "created",
    "targetLabel": "software",
    "sortKeys": [],
    "properties": [
        "date",
        "city"
    ],
    "frequency": "SINGLE"
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

#### 2.3.1 Post

功能：创建一个IndexLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/indexlabels
```

##### Request Body

```
{
    "name": "softwareByPrice",
    "baseType": "VERTEX_LABEL",
    "baseValue": "software",
    "indexType": "SEARCH",
    "fields": [
        "price"
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
    "id": "4softwareByPrice",
    "indexType": "SEARCH",
    "baseValue": "software",
    "name": "softwareByPrice",
    "fields": [
        "price"
    ],
    "baseType": "VERTEX_LABEL"
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
            "indexType": "SEARCH",
            "baseValue": "software",
            "name": "softwareByPrice",
            "fields": [
                "price"
            ],
            "baseType": "VERTEX_LABEL"
        },
        {
            "id": "4personByName",
            "indexType": "SECONDARY",
            "baseValue": "person",
            "name": "personByName",
            "fields": [
                "name"
            ],
            "baseType": "VERTEX_LABEL"
        }
    ]
}
```

#### 2.3.3 Get

功能：根据name获取IndexLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/indexlabels/softwareByPrice
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "4softwareByPrice",
    "indexType": "SEARCH",
    "baseValue": "software",
    "name": "softwareByPrice",
    "fields": [
        "price"
    ],
    "baseType": "VERTEX_LABEL"
}
```

#### 2.3.4 Delete

功能：根据name删除IndexLabel

##### Url

```
localhost:8080/graphs/hugegraph/schema/indexlabels/softwareByPrice
```

##### Response Status

```
204
```

## 3. 图数据

### 3.1 Vertex

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
        "name": "marko"
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
            "name": "marko"
        }
    },
    {
        "label": "software",
        "properties": {
            "name": "idea"
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
    "software:idea"
]
```

#### 3.1.3 Get(List)

功能：获取所有顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/vertices
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
        },
        {
            "id": "software:lop",
            "label": "software",
            "type": "vertex",
            "properties": {
                "price": [
                    {
                        "id": "software:lop>price",
                        "value": 328
                    }
                ],
                "name": [
                    {
                        "id": "software:lop>name",
                        "value": "lop"
                    }
                ],
                "lang": [
                    {
                        "id": "software:lop>lang",
                        "value": "java"
                    }
                ]
            }
        },
        {
            "id": "person:peter",
            "label": "person",
            "type": "vertex",
            "properties": {
                "city": [
                    {
                        "id": "person:peter>city",
                        "value": "Shanghai"
                    }
                ],
                "name": [
                    {
                        "id": "person:peter>name",
                        "value": "peter"
                    }
                ],
                "age": [
                    {
                        "id": "person:peter>age",
                        "value": 29
                    }
                ]
            }
        }
    ]
}
```

#### 3.1.4 Get

功能：根据Id获取顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/vertices/software:lop
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "software:lop",
    "label": "software",
    "type": "vertex",
    "properties": {
        "price": [
            {
                "id": "software:lop>price",
                "value": 328
            }
        ],
        "name": [
            {
                "id": "software:lop>name",
                "value": "lop"
            }
        ],
        "lang": [
            {
                "id": "software:lop>lang",
                "value": "java"
            }
        ]
    }
}
```

#### 3.1.5 Delete

功能：根据Id删除顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/vertices/software:lop
```

##### Response Status

```
204
```

### 3.2 Edge

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
        "city": "Hongkong",
        "date": "2017-5-18"
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
        "city": "Hongkong"
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
            "city": "Hongkong",
            "date": "2017-5-18"
        }
    },
    {
        "label": "knows",
        "outV": "person:peter",
        "inV": "person:marko",
        "outVLabel": "person",
        "inVLabel": "person",
        "properties": {
            "date": "2016-10-18"
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
    "person:peter>knows>>person:marko"
]
```

#### 3.2.3 Get(List)

功能：获取所有边

##### Url

```
localhost:8080/graphs/hugegraph/graph/edges
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
            "id": "person:peter>created>>software:lop",
            "label": "created",
            "type": "edge",
            "inVLabel": "software",
            "outVLabel": "person",
            "inV": "software:lop",
            "outV": "person:peter",
            "properties": {
                "date": "2017-5-18",
                "city": "Hongkong"
            }
        },
        {
            "id": "person:peter>knows>>person:marko",
            "label": "knows",
            "type": "edge",
            "inVLabel": "person",
            "outVLabel": "person",
            "inV": "person:marko",
            "outV": "person:peter",
            "properties": {
                "date": "2016-10-18"
            }
        }
    ]
}
```

#### 3.2.3 Get

功能：根据Id获取边

##### Url

```
localhost:8080/graphs/hugegraph/graph/edges/person:peter>created>>software:lop
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
        "city": "Hongkong"
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
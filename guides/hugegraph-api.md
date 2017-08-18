
## 1. HugeGraph-Api Intro


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
"dataType": "INT",
"name": "price",
"cardinality": "SINGLE",
"properties":[]
}
```

##### Response Status

```
201
```

##### Response Body
```
{
    "id": "3price",
    "dataType": "INT",
    "name": "price",
    "cardinality": "SINGLE",
    "properties": [
    ]
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
            "properties": [
            ]
        },
        {
            "id": "3lang",
            "dataType": "TEXT",
            "name": "lang",
            "cardinality": "SINGLE",
            "properties": [
            ]
        },
        {
            "id": "3date",
            "dataType": "TEXT",
            "name": "date",
            "cardinality": "SINGLE",
            "properties": [
            ]
        },
        {
            "id": "3name",
            "dataType": "TEXT",
            "name": "name",
            "cardinality": "SINGLE",
            "properties": [
            ]
        },
        {
            "id": "3price",
            "dataType": "INT",
            "name": "price",
            "cardinality": "SINGLE",
            "properties": [
            ]
        }
    ]
}
```

#### 2.1.3 Get

功能：根据name获取PropertyKey

##### Url

```
localhost:8080/graphs/hugegraph/schema/propertykeys/price
```

其中，`price`为要获取的PropertyKey的名字

##### Response Status

```
200
```

##### Response Body
```
{
    "id": "3price",
    "dataType": "INT",
    "name": "price",
    "cardinality": "SINGLE",
    "properties": [
    ]
}
```

#### 2.1.4 Delete

功能：根据name删除PropertyKey

##### Url

```
localhost:8080/graphs/hugegraph/schema/propertykeys/price
```

其中，`price`为要获取的PropertyKey的名字

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
"primaryKeys":[
"name"
],
"indexNames":[
"softwareByPrice"
],
"name": "software",
"properties":[
"price",
"name",
"lang"
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
    "id": "1software",
    "primaryKeys": [
        "name"
    ],
    "indexNames": [
        "softwareByPrice"
    ],
    "name": "software",
    "properties": [
        "price",
        "name",
        "lang"
    ]
}
```

#### 2.2.2 Put

功能：为已存在的VertexLabel添加属性

##### Url

```
localhost:8080/graphs/hugegraph/schema/vertexlabels
```

##### Request Body

```
{
"primaryKeys":[
],
"indexNames":[
],
"name": "software",
"properties":[
"lang"
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
    ],
    "indexNames": [
    ],
    "name": "software",
    "properties": [
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
            "indexNames": [
                "personByName"
            ],
            "name": "person",
            "properties": [
                "name",
                "age",
                "price"
            ]
        },
        {
            "id": "1software",
            "primaryKeys": [
                "name"
            ],
            "indexNames": [
                "softwareByPrice"
            ],
            "name": "software",
            "properties": [
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
    "indexNames": [
        "personByName"
    ],
    "name": "person",
    "properties": [
        "name",
        "age",
        "price"
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
"indexNames":[
"createdByDate"
],
"name": "created",
"links":[
{
"source": "person",
"target": "software"
}
],
"sortKeys":["date"],
"properties":[
"date"
],
"frequency": "MULTIPLE"
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
    "indexNames": [
        "createdByDate"
    ],
    "name": "created",
    "links": [
        {
            "source": "person",
            "target": "software"
        }
    ],
    "sortKeys": [
        "date"
    ],
    "properties": [
        "date"
    ],
    "frequency": "MULTIPLE"
}
```

#### 2.3.2 Put

功能：为已存在的EdgeLabel添加properties和link

##### Url

```
localhost:8080/graphs/hugegraph/schema/edgelabels
```

##### Request Body

```
{
"indexNames":[
],
"name": "created",
"links":[
{
"source": "person",
"target": "person"
}
],
"sortKeys":[],
"properties":[
"date"
],
"frequency": "MULTIPLE"
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
    "indexNames": [
    ],
    "name": "created",
    "links": [
        {
            "source": "person",
            "target": "person"
        }
    ],
    "sortKeys": [
    ],
    "properties": [
        "date"
    ],
    "frequency": "MULTIPLE"
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
            "indexNames": [
                "createdByDate"
            ],
            "name": "created",
            "links": [
                {
                    "source": "person",
                    "target": "software"
                }
            ],
            "sortKeys": [
                "date"
            ],
            "properties": [
                "date"
            ],
            "frequency": "MULTIPLE"
        },
        {
            "id": "2knows",
            "indexNames": [
            ],
            "name": "knows",
            "links": [
                {
                    "source": "person",
                    "target": "person"
                },
                {
                    "source": "software",
                    "target": "software"
                }
            ],
            "sortKeys": [
            ],
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
    "indexNames": [
        "createdByDate"
    ],
    "name": "created",
    "links": [
        {
            "source": "person",
            "target": "software"
        }
    ],
    "sortKeys": [
        "date"
    ],
    "properties": [
        "date"
    ],
    "frequency": "MULTIPLE"
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
"indexType": "SEARCH",
"baseValue": "software",
"name": "softwareByPrice",
"fields":["price"],
"baseType": "VERTEX_LABEL"
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
            "id": "4createdByDate",
            "indexType": "SECONDARY",
            "baseValue": "created",
            "name": "createdByDate",
            "fields": [
                "date"
            ],
            "baseType": "EDGE_LABEL"
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

#### 3.1.1 Post

功能：创建一个顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/vertices
```

##### Request Body

```
{
  "label":"person",
  "properties":{
    "name":"test-lzm"
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
    "id": "person\u0002test-lzm",
    "label": "person",
    "type": "vertex",
    "properties": {
        "name": [
            {
                "id": "name",
                "value": "test-lzm"
            }
        ]
    }
}
```

#### 3.1.2 Get(List)

功能：获取所有顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/vertices?limit=10
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
            "id": "software\u0002lop",
            "label": "software",
            "type": "vertex",
            "properties": {
                "price": [
                    {
                        "id": "price",
                        "value": 328
                    }
                ],
                "name": [
                    {
                        "id": "name",
                        "value": "lop"
                    }
                ],
                "lang": [
                    {
                        "id": "lang",
                        "value": "java"
                    }
                ]
            }
        },
        {
            "id": "person\u0002josh",
            "label": "person",
            "type": "vertex",
            "properties": {
                "name": [
                    {
                        "id": "name",
                        "value": "josh"
                    }
                ],
                "age": [
                    {
                        "id": "age",
                        "value": 32
                    }
                ]
            }
        },
        {
            "id": "person\u0002marko",
            "label": "person",
            "type": "vertex",
            "properties": {
                "name": [
                    {
                        "id": "name",
                        "value": "marko"
                    }
                ],
                "age": [
                    {
                        "id": "age",
                        "value": 29
                    }
                ]
            }
        },
        {
            "id": "person\u0002peter",
            "label": "person",
            "type": "vertex",
            "properties": {
                "name": [
                    {
                        "id": "name",
                        "value": "peter"
                    }
                ],
                "age": [
                    {
                        "id": "age",
                        "value": 35
                    }
                ]
            }
        },
        {
            "id": "person\u0002test-lzm",
            "label": "person",
            "type": "vertex",
            "properties": {
                "name": [
                    {
                        "id": "name",
                        "value": "test-lzm"
                    }
                ]
            }
        },
        {
            "id": "person\u0002vadas",
            "label": "person",
            "type": "vertex",
            "properties": {
                "name": [
                    {
                        "id": "name",
                        "value": "vadas"
                    }
                ],
                "age": [
                    {
                        "id": "age",
                        "value": 27
                    }
                ]
            }
        },
        {
            "id": "software\u0002ripple",
            "label": "software",
            "type": "vertex",
            "properties": {
                "price": [
                    {
                        "id": "price",
                        "value": 199
                    }
                ],
                "name": [
                    {
                        "id": "name",
                        "value": "ripple"
                    }
                ],
                "lang": [
                    {
                        "id": "lang",
                        "value": "java"
                    }
                ]
            }
        }
    ]
}
```

#### 3.1.3 Get

功能：根据Id获取顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/vertices/software%02lop
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "software\u0002lop",
    "label": "software",
    "type": "vertex",
    "properties": {
        "price": [
            {
                "id": "price",
                "value": 328
            }
        ],
        "name": [
            {
                "id": "name",
                "value": "lop"
            }
        ],
        "lang": [
            {
                "id": "lang",
                "value": "java"
            }
        ]
    }
}
```

#### 3.1.4 Delete

功能：根据Id删除顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/vertices/software%02lop
```

##### Response Status

```
204
```

### 3.2 Edge

#### 3.2.1 Post

功能：创建一条边

##### Url

```
localhost:8080/graphs/hugegraph/graph/edges
```

##### Request Body

```
{
  "label":"knows",
  "source":"person\u0002marko",
  "target":"person\u0002vadas",
  "properties":{
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
    "id": "person\u0002marko\u0001knows\u0001\u0001person\u0002vadas",
    "label": "knows",
    "type": "edge",
    "inVLabel": "person",
    "outVLabel": "person",
    "inV": "person\u0002vadas",
    "outV": "person\u0002marko",
    "properties": {
        "date": "2017-5-18"
    }
}
```

#### 3.2.2 Get(List)

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
            "id": "person\u0002marko\u0001knows\u0001\u0001person\u0002josh",
            "label": "knows",
            "type": "edge",
            "inVLabel": "person",
            "outVLabel": "person",
            "inV": "person\u0002josh",
            "outV": "person\u0002marko",
            "properties": {
                "date": "20130220"
            }
        },
        {
            "id": "person\u0002marko\u0001knows\u0001\u0001person\u0002vadas",
            "label": "knows",
            "type": "edge",
            "inVLabel": "person",
            "outVLabel": "person",
            "inV": "person\u0002vadas",
            "outV": "person\u0002marko",
            "properties": {
                "date": "2017-5-18"
            }
        },
        {
            "id": "person\u0002josh\u0001created\u0001\u0001software\u0002ripple",
            "label": "created",
            "type": "edge",
            "inVLabel": "software",
            "outVLabel": "person",
            "inV": "software\u0002ripple",
            "outV": "person\u0002josh",
            "properties": {
                "date": "20171210"
            }
        }
    ]
}
```

#### 3.2.3 Get

功能：根据Id获取边

##### Url

```
localhost:8080/graphs/hugegraph/graph/edges/person%02marko%01knows%01%01person%02josh
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": "person\u0002marko\u0001knows\u0001\u0001person\u0002josh",
    "label": "knows",
    "type": "edge",
    "inVLabel": "person",
    "outVLabel": "person",
    "inV": "person\u0002josh",
    "outV": "person\u0002marko",
    "properties": {
        "date": "20130220"
    }
}
```

#### 3.2.4 Delete

功能：根据Id删除顶点

##### Url

```
localhost:8080/graphs/hugegraph/graph/edges/person%02marko%01knows%01%01person%02josh
```

##### Response Status

```
204
```
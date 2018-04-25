### 1.4 IndexLabel

假设已经创建好了1.1.2中的 PropertyKeys 、1.2.2中的 VertexLabels 以及 1.3.2中的 EdgeLabels

#### 1.4.1 创建一个IndexLabel

##### Method

```
POST
```

##### Url

```http request
http://localhost:8080/graphs/hugegraph/schema/indexlabels
```

##### Request Body

```json
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

```json
{
    "id": 1,
    "base_type": "VERTEX_LABEL",
    "base_value": "person",
    "name": "personByCity",
    "fields": [
        "city"
    ],
    "index_type": "SECONDARY"
}
```

#### 1.4.2 获取所有的IndexLabel

##### Method

```
GET
```

##### Url

```http request
http://localhost:8080/graphs/hugegraph/schema/indexlabels
```

##### Response Status

```
200
```

##### Response Body

```json
{
    "indexlabels": [
        {
            "id": 3,
            "base_type": "VERTEX_LABEL",
            "base_value": "software",
            "name": "softwareByPrice",
            "fields": [
                "price"
            ],
            "index_type": "RANGE"
        },
        {
            "id": 4,
            "base_type": "EDGE_LABEL",
            "base_value": "created",
            "name": "createdByDate",
            "fields": [
                "date"
            ],
            "index_type": "SECONDARY"
        },
        {
            "id": 1,
            "base_type": "VERTEX_LABEL",
            "base_value": "person",
            "name": "personByCity",
            "fields": [
                "city"
            ],
            "index_type": "SECONDARY"
        },
        {
            "id": 3,
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

#### 1.4.3 根据name获取IndexLabel

##### Method

```
GET
```

##### Url

```http request
http://localhost:8080/graphs/hugegraph/schema/indexlabels/personByCity
```

##### Response Status

```
200
```

##### Response Body

```json
{
    "id": 1,
    "base_type": "VERTEX_LABEL",
    "base_value": "person",
    "name": "personByCity",
    "fields": [
        "city"
    ],
    "index_type": "SECONDARY"
}
```

#### 1.4.4 根据name删除IndexLabel

##### Method

```
DELETE
```

##### Url

```http request
http://localhost:8080/graphs/hugegraph/schema/indexlabels/personByCity
```

##### Response Status

```
204
```
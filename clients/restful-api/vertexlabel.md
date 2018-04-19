### 1.2 VertexLabel

假设已经创建好了1.1.2中列出来的那些 PropertyKeys

#### 1.2.1 创建一个VertexLabel

##### Method

```
POST
```

##### Url

```
http://localhost:8080/graphs/hugegraph/schema/vertexlabels
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
    "nullable_keys": [],
    "enable_label_index": true
}
```

##### Response Status

```
201
```

##### Response Body

```
{
    "id": 1,
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
    ],
    "enable_label_index": true,
    "user_data":{}
}
```

#### 1.2.2 为已存在的VertexLabel添加properties或userdata，或者移除userdata（目前不支持移除properties）

##### Method

```
PUT
```

##### Params

- action: 表示当前行为是添加还是移除，取值为`append`（添加）和`eliminate`（移除）

##### Url

```
http://localhost:8080/graphs/hugegraph/schema/vertexlabels/person?action=append
```

##### Request Body

```
{
    "name": "person",
    "properties": [
        "city"
    ],
    "nullable_keys": ["city"],
    "user_data":{
        "super": "animal"
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
    "id": 1,
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
    ],
    "enable_label_index": true,
    "user_data":{
        "super": "animal"
    }
}
```

#### 1.2.3 获取所有的VertexLabel

##### Method

```
GET
```

##### Url

```
http://localhost:8080/graphs/hugegraph/schema/vertexlabels
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
            "id": 1,
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
            ],
            "enable_label_index": true,
            "user_data":{
                "super": "animal"
            }
        },
        {
            "id": 2,
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
            ],
            "enable_label_index": false,
            "user_data":{}
        }
    ]
}
```

#### 1.2.4 根据name获取VertexLabel

##### Method

```
GET
```

##### Url

```
http://localhost:8080/graphs/hugegraph/schema/vertexlabels/person
```

##### Response Status

```
200
```

##### Response Body

```
{
    "id": 1,
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
    ],
    "enable_label_index": true,
    "user_data":{
        "super": "animal"
    }
}
```

#### 1.2.5 根据name删除VertexLabel

##### Method

```
DELETE
```

##### Url

```
http://localhost:8080/graphs/hugegraph/schema/vertexlabels/person
```

##### Response Status

```
204
```

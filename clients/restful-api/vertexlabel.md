### 1.2 VertexLabel

假设已经创建好了1.1.3中列出来的 PropertyKeys

#### 1.2.1 创建一个VertexLabel

##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/schema/vertexlabels
```

##### Request Body

```json
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

```json
201
```

##### Response Body

```json
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
    "user_data": {}
}
```

#### 1.2.2 为已存在的VertexLabel添加properties或userdata，或者移除userdata（目前不支持移除properties）

##### Params

- action: 表示当前行为是添加还是移除，取值为`append`（添加）和`eliminate`（移除）

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/schema/vertexlabels/person?action=append
```

##### Request Body

```json
{
    "name": "person",
    "properties": [
        "city"
    ],
    "nullable_keys": ["city"],
    "user_data": {
        "super": "animal"
    }
}
```

##### Response Status

```json
200
```

##### Response Body

```json
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
    "user_data": {
        "super": "animal"
    }
}
```

#### 1.2.3 获取所有的VertexLabel

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/schema/vertexlabels
```

##### Response Status

```json
200
```

##### Response Body

```json
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
            "user_data": {
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
            "user_data": {}
        }
    ]
}
```

#### 1.2.4 根据name获取VertexLabel

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/schema/vertexlabels/person
```

##### Response Status

```json
200
```

##### Response Body

```json
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
    "user_data": {
        "super": "animal"
    }
}
```

#### 1.2.5 根据name删除VertexLabel

删除 VertexLabel 会导致删除对应的顶点以及相关的索引数据，会产生一个异步任务

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/schema/vertexlabels/person
```

##### Response Status

```json
202
```

##### Response Body

```json
{
    "task_id": 1
}
```

注：

> 可以通过`GET http://localhost:8080/graphs/hugegraph/tasks/1`（其中"1"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)